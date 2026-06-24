using LingoCross.Application.Auth;
using LingoCross.Application.Auth.Dtos;
using LingoCross.Application.Common.Email;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Auth;
using LingoCross.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace LingoCross.Tests.Auth;

/// <summary>
/// DELETE /api/auth/me arkasındaki AuthService.DeleteAccountAsync davranışını EF InMemory ile
/// doğrular: rol bazlı açık silme sırası, restrict FK'ların ele alınışı, karşı tarafın verisinin
/// korunması ve silinen kullanıcının token'larının geçersiz kalması.
/// </summary>
public class AccountDeletionTests
{
    private sealed class NoopEmailSender : IEmailSender
    {
        public Task SendPasswordResetAsync(string toEmail, string resetToken, CancellationToken ct = default)
            => Task.CompletedTask;
    }

    private static (AuthService Service, AppDbContext Db) CreateSut()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"account-deletion-tests-{Guid.NewGuid()}")
            .Options;
        var db = new AppDbContext(options);

        var tokenService = new JwtTokenService(Options.Create(new JwtOptions
        {
            Secret = "unit-test-super-secret-signing-key-32-chars-min!!",
            Issuer = "lingocross-test",
            Audience = "lingocross-test",
        }));
        var service = new AuthService(db, new BCryptPasswordHasher(), tokenService, new NoopEmailSender());
        return (service, db);
    }

    private static User NewUser(UserRole role, string email) => new()
    {
        Email = email,
        PasswordHash = "hash",
        DisplayName = email,
        Role = role,
        PreferredLocale = "tr",
        InviteCode = role == UserRole.Teacher ? "TCHRCODE1" : null,
    };

    [Fact]
    public async Task DeleteAccount_Throws404_WhenUserMissing()
    {
        var (service, _) = CreateSut();

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.DeleteAccountAsync(Guid.NewGuid()));

        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task DeleteTeacher_RemovesAllOwnedData_ButKeepsStudentAccount()
    {
        var (service, db) = CreateSut();

        // Öğretmen + öğrenci.
        var teacher = NewUser(UserRole.Teacher, "teacher@example.com");
        var student = NewUser(UserRole.Student, "student@example.com");
        db.Users.AddRange(teacher, student);

        // Sınıf + öğrencinin üyeliği.
        var klass = new Class { TeacherId = teacher.Id, Name = "Sınıf A" };
        db.Classes.Add(klass);
        db.ClassMembers.Add(new ClassMember { ClassId = klass.Id, StudentId = student.Id, Status = ClassMemberStatus.Active });

        // Eşleşme.
        db.Enrollments.Add(new Enrollment { TeacherId = teacher.Id, StudentId = student.Id, Status = EnrollmentStatus.Active });

        // Ders + kelime (+ çeviri/eşanlam).
        var lesson = new Lesson { TeacherId = teacher.Id, Title = "Ders 1" };
        db.Lessons.Add(lesson);
        var word = new Word { LessonId = lesson.Id, Term = "apple", SortOrder = 0, Source = WordSource.Manual };
        db.Words.Add(word);
        db.WordTranslations.Add(new WordTranslation { WordId = word.Id, Text = "elma" });
        db.WordSynonyms.Add(new WordSynonym { WordId = word.Id, Text = "pome" });

        // Oyun + sınıfa atama.
        var game = new Game { LessonId = lesson.Id, Type = GameType.WordMatching, Title = "Oyun 1", IsPublished = true };
        db.Games.Add(game);
        db.GameAssignments.Add(new GameAssignment { GameId = game.Id, ClassId = klass.Id });

        // O öğrencinin bu oyunda bir oturumu + sonucu + sonuç kalemi.
        var session = new GameSession { GameId = game.Id, StudentId = student.Id, Status = GameSessionStatus.Completed, StartedAt = DateTime.UtcNow };
        db.GameSessions.Add(session);
        var result = new GameResult { SessionId = session.Id, DurationMs = 1000, TotalItems = 1, CorrectItems = 1, Score = 100, SharedWithTeacher = true };
        db.GameResults.Add(result);
        db.GameResultItems.Add(new GameResultItem { ResultId = result.Id, Ordinal = 0, Term = "apple", ExpectedAnswer = "elma", IsCorrect = true });

        // Öğretmenin yardımcı verileri.
        db.RefreshTokens.Add(new RefreshToken { UserId = teacher.Id, TokenHash = "th", ExpiresAt = DateTime.UtcNow.AddDays(30) });
        db.Subscriptions.Add(new Subscription { UserId = teacher.Id, Plan = SubscriptionPlan.Premium, Status = SubscriptionStatus.Active, Source = SubscriptionSource.Stub, StartedAt = DateTime.UtcNow });

        await db.SaveChangesAsync();

        await service.DeleteAccountAsync(teacher.Id);

        // Öğretmen ve TÜM içeriği gitti.
        Assert.False(await db.Users.AnyAsync(u => u.Id == teacher.Id));
        Assert.Equal(0, await db.Classes.CountAsync());
        Assert.Equal(0, await db.Lessons.CountAsync());
        Assert.Equal(0, await db.Words.CountAsync());
        Assert.Equal(0, await db.WordTranslations.CountAsync());
        Assert.Equal(0, await db.WordSynonyms.CountAsync());
        Assert.Equal(0, await db.Games.CountAsync());
        Assert.Equal(0, await db.GameAssignments.CountAsync());
        Assert.Equal(0, await db.GameSessions.CountAsync());
        Assert.Equal(0, await db.GameResults.CountAsync());
        Assert.Equal(0, await db.GameResultItems.CountAsync());
        Assert.Equal(0, await db.Enrollments.CountAsync());
        Assert.Equal(0, await db.ClassMembers.CountAsync());
        Assert.Equal(0, await db.RefreshTokens.CountAsync());
        Assert.Equal(0, await db.Subscriptions.CountAsync());

        // Öğrenci hesabı duruyor.
        Assert.True(await db.Users.AnyAsync(u => u.Id == student.Id));
    }

    [Fact]
    public async Task DeleteStudent_RemovesStudentData_ButKeepsTeacherContent()
    {
        var (service, db) = CreateSut();

        var teacher = NewUser(UserRole.Teacher, "teacher@example.com");
        var student = NewUser(UserRole.Student, "student@example.com");
        db.Users.AddRange(teacher, student);

        // Öğretmen içeriği (silinmemeli).
        var klass = new Class { TeacherId = teacher.Id, Name = "Sınıf A" };
        db.Classes.Add(klass);
        var lesson = new Lesson { TeacherId = teacher.Id, Title = "Ders 1" };
        db.Lessons.Add(lesson);
        var game = new Game { LessonId = lesson.Id, Type = GameType.WordMatching, Title = "Oyun 1", IsPublished = true };
        db.Games.Add(game);

        // Öğrenciye ait veri.
        db.ClassMembers.Add(new ClassMember { ClassId = klass.Id, StudentId = student.Id, Status = ClassMemberStatus.Active });
        db.Enrollments.Add(new Enrollment { TeacherId = teacher.Id, StudentId = student.Id, Status = EnrollmentStatus.Active });

        var session = new GameSession { GameId = game.Id, StudentId = student.Id, Status = GameSessionStatus.Completed, StartedAt = DateTime.UtcNow };
        db.GameSessions.Add(session);
        var result = new GameResult { SessionId = session.Id, DurationMs = 500, TotalItems = 1, CorrectItems = 0, Score = 0, SharedWithTeacher = false };
        db.GameResults.Add(result);
        db.GameResultItems.Add(new GameResultItem { ResultId = result.Id, Ordinal = 0, Term = "apple", ExpectedAnswer = "elma", IsCorrect = false });

        db.DeviceTokens.Add(new DeviceToken { UserId = student.Id, Token = "device-1", Platform = "ios" });
        db.Subscriptions.Add(new Subscription { UserId = student.Id, Plan = SubscriptionPlan.Premium, Status = SubscriptionStatus.Active, Source = SubscriptionSource.Stub, StartedAt = DateTime.UtcNow });
        db.NotificationPreferences.Add(new NotificationPreference { UserId = student.Id });
        db.RefreshTokens.Add(new RefreshToken { UserId = student.Id, TokenHash = "th-student", ExpiresAt = DateTime.UtcNow.AddDays(30) });

        await db.SaveChangesAsync();

        await service.DeleteAccountAsync(student.Id);

        // Öğrencinin tüm verisi gitti.
        Assert.False(await db.Users.AnyAsync(u => u.Id == student.Id));
        Assert.Equal(0, await db.ClassMembers.CountAsync());
        Assert.Equal(0, await db.Enrollments.CountAsync());
        Assert.Equal(0, await db.GameSessions.CountAsync());
        Assert.Equal(0, await db.GameResults.CountAsync());
        Assert.Equal(0, await db.GameResultItems.CountAsync());
        Assert.Equal(0, await db.DeviceTokens.CountAsync());
        Assert.Equal(0, await db.Subscriptions.CountAsync());
        Assert.Equal(0, await db.NotificationPreferences.CountAsync());
        Assert.Equal(0, await db.RefreshTokens.CountAsync());

        // Öğretmenin içeriği duruyor.
        Assert.True(await db.Users.AnyAsync(u => u.Id == teacher.Id));
        Assert.Equal(1, await db.Classes.CountAsync());
        Assert.Equal(1, await db.Lessons.CountAsync());
        Assert.Equal(1, await db.Games.CountAsync());
    }

    [Fact]
    public async Task DeleteAccount_RemovesRefreshTokens_SoRefreshFails()
    {
        var (service, db) = CreateSut();

        // Kayıt ol → refresh token al; sonra hesabı sil → token gitmeli, yenileme başarısız olmalı.
        var reg = await service.RegisterAsync(new RegisterRequest("teacher@example.com", "Sifre1234!", "Öğretmen", UserRole.Teacher));

        await service.DeleteAccountAsync(reg.User.Id);

        Assert.Equal(0, await db.RefreshTokens.CountAsync());

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.RefreshAsync(new RefreshRequest(reg.RefreshToken)));
        Assert.Equal(401, ex.StatusCode);
    }
}
