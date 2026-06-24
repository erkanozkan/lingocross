using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Results;
using LingoCross.Application.Results.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Results;

/// <summary>
/// F3.1 — Öğrenci profil istatistikleri (GetMyStatsAsync): tamamlanmış sonuç sayısı +
/// ortalama başarı puanı. Sonuç yoksa 0/0; yalnızca kendi sonuçları sayılır; öğretmen rolü → 403.
/// </summary>
public class StudentStatsTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"stats-{Guid.NewGuid()}")
            .Options);

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role, string email)
    {
        var user = new User { Email = email, PasswordHash = "x", DisplayName = email, Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    /// <summary>Bir ders + oyun + (verilen öğrenci için) InProgress oturum seed eder.</summary>
    private static async Task<GameSession> SeedSessionAsync(AppDbContext db, Guid teacherId, Guid studentId)
    {
        var lesson = new Lesson { TeacherId = teacherId, Title = "Ders", IsPublished = true };
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();

        var game = new Game { LessonId = lesson.Id, Type = GameType.WordMatching, Title = "Kelime Eşleştirme" };
        db.Games.Add(game);
        await db.SaveChangesAsync();

        var session = new GameSession
        {
            GameId = game.Id,
            StudentId = studentId,
            Status = GameSessionStatus.InProgress,
            StartedAt = DateTime.UtcNow,
        };
        db.GameSessions.Add(session);
        await db.SaveChangesAsync();
        return session;
    }

    [Fact]
    public async Task GetMyStats_MultipleResults_CountsAndAveragesScore()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));

        var s1 = await SeedSessionAsync(db, teacher.Id, student.Id);
        var s2 = await SeedSessionAsync(db, teacher.Id, student.Id);
        var s3 = await SeedSessionAsync(db, teacher.Id, student.Id);
        await svc.SubmitResultAsync(s1.Id, new SubmitResultRequest(1000, 8, 8)); // 100
        await svc.SubmitResultAsync(s2.Id, new SubmitResultRequest(1000, 8, 4)); // 50
        await svc.SubmitResultAsync(s3.Id, new SubmitResultRequest(3, 1, 1));    // 100

        var stats = await svc.GetMyStatsAsync();

        Assert.Equal(3, stats.GamesPlayed);
        // (100 + 50 + 100) / 3 = 83.33 → 83 (AwayFromZero)
        Assert.Equal(83, stats.AverageAccuracy);
    }

    [Fact]
    public async Task GetMyStats_AverageRoundsAwayFromZero()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));

        var s1 = await SeedSessionAsync(db, teacher.Id, student.Id);
        var s2 = await SeedSessionAsync(db, teacher.Id, student.Id);
        await svc.SubmitResultAsync(s1.Id, new SubmitResultRequest(1000, 8, 8)); // 100
        await svc.SubmitResultAsync(s2.Id, new SubmitResultRequest(1000, 8, 0)); // 0

        var stats = await svc.GetMyStatsAsync();

        Assert.Equal(2, stats.GamesPlayed);
        // (100 + 0) / 2 = 50
        Assert.Equal(50, stats.AverageAccuracy);
    }

    [Fact]
    public async Task GetMyStats_NoResults_ReturnsZeroZero()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var stats = await svc.GetMyStatsAsync();

        Assert.Equal(0, stats.GamesPlayed);
        Assert.Equal(0, stats.AverageAccuracy);
    }

    [Fact]
    public async Task GetMyStats_DoesNotCountOtherStudentsResults()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var other = await SeedUserAsync(db, UserRole.Student, "o@x.com");

        var studentSvc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var otherSvc = new ResultService(db, TestCurrentUser.Student(other.Id));

        var mine = await SeedSessionAsync(db, teacher.Id, student.Id);
        await studentSvc.SubmitResultAsync(mine.Id, new SubmitResultRequest(1000, 8, 8)); // 100

        // Başka öğrencinin iki sonucu öğrencinin istatistiğini etkilememeli.
        var o1 = await SeedSessionAsync(db, teacher.Id, other.Id);
        var o2 = await SeedSessionAsync(db, teacher.Id, other.Id);
        await otherSvc.SubmitResultAsync(o1.Id, new SubmitResultRequest(1000, 8, 0)); // 0
        await otherSvc.SubmitResultAsync(o2.Id, new SubmitResultRequest(1000, 8, 2)); // 25

        var stats = await studentSvc.GetMyStatsAsync();

        Assert.Equal(1, stats.GamesPlayed);
        Assert.Equal(100, stats.AverageAccuracy);
    }

    [Fact]
    public async Task GetMyStats_TeacherRole_Throws403()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");

        var svc = new ResultService(db, TestCurrentUser.Teacher(teacher.Id));
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.GetMyStatsAsync());
        Assert.Equal(403, ex.StatusCode);
    }
}
