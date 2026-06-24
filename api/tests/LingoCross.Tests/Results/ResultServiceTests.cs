using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Notifications;
using LingoCross.Application.Results;
using LingoCross.Application.Results.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Results;

/// <summary>
/// M5 — Oyun sonuç/özet (öğrenci tarafı): skor hesabı, oturum Completed + tek sonuç (idempotent),
/// öğretmenle paylaşım (sahiplik + flag/shared_at), geçmiş listesi ve erişim reddi (404).
/// </summary>
public class ResultServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"results-{Guid.NewGuid()}")
            .Options);

    /// <summary>Gönderim çağrılarını sayan no-op push sender (FCM yerine).</summary>
    private sealed class FakePushSender : IPushSender
    {
        public int CallCount { get; private set; }

        public Task<IReadOnlyList<string>> SendToTokensAsync(
            IReadOnlyList<string> tokens,
            string title,
            string body,
            IReadOnlyDictionary<string, string>? data,
            CancellationToken ct = default)
        {
            CallCount++;
            return Task.FromResult<IReadOnlyList<string>>([]);
        }
    }

    /// <summary>Öğretmenin push alabilmesi için bir cihaz token'ı ekler (tercih kaydı yok → varsayılan: Results açık).</summary>
    private static async Task AddTeacherTokenAsync(AppDbContext db, Guid teacherId)
    {
        db.DeviceTokens.Add(new DeviceToken { UserId = teacherId, Token = $"tok-{Guid.NewGuid():N}", Platform = "ios" });
        await db.SaveChangesAsync();
    }

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role, string email)
    {
        var user = new User { Email = email, PasswordHash = "x", DisplayName = email, Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    /// <summary>Bir ders + oyun + (verilen öğrenci için) InProgress oturum seed eder.</summary>
    private static async Task<GameSession> SeedSessionAsync(
        AppDbContext db, Guid teacherId, Guid studentId, GameSessionStatus status = GameSessionStatus.InProgress)
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
            Status = status,
            StartedAt = DateTime.UtcNow,
        };
        db.GameSessions.Add(session);
        await db.SaveChangesAsync();
        return session;
    }

    // ---- Skor hesabı ----

    [Theory]
    [InlineData(8, 8, 100)]
    [InlineData(8, 4, 50)]
    [InlineData(8, 0, 0)]
    [InlineData(3, 1, 33)]   // 33.33 → 33
    [InlineData(3, 2, 67)]   // 66.66 → 67
    [InlineData(0, 0, 0)]    // toplam 0 → 0 (bölme yok)
    public void CalculateScore_IsAccuracyPercentRounded(int total, int correct, int expected)
    {
        Assert.Equal(expected, ResultService.CalculateScore(total, correct));
    }

    // ---- Submit ----

    [Fact]
    public async Task Submit_ComputesScore_CompletesSession_CreatesSingleResult()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, student.Id);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var result = await svc.SubmitResultAsync(session.Id, new SubmitResultRequest(45_000, 8, 6));

        Assert.Equal(75, result.Score); // 6/8 = 75
        Assert.Equal(45_000, result.DurationMs);
        Assert.Equal(8, result.TotalItems);
        Assert.Equal(6, result.CorrectItems);
        // Otomatik paylaşım: sonuç tamamlanır tamamlanmaz öğretmenle paylaşılır.
        Assert.True(result.SharedWithTeacher);
        Assert.NotNull(result.SharedAt);
        Assert.Equal(session.GameId, result.GameId);

        var reloaded = await db.GameSessions.FirstAsync(s => s.Id == session.Id);
        Assert.Equal(GameSessionStatus.Completed, reloaded.Status);
        Assert.NotNull(reloaded.CompletedAt);
        Assert.Equal(1, await db.GameResults.CountAsync());
    }

    [Fact]
    public async Task Submit_Twice_IsIdempotent_ReturnsSameResult()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, student.Id);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var first = await svc.SubmitResultAsync(session.Id, new SubmitResultRequest(45_000, 8, 6));
        // İkinci gönderim farklı değerlerle gelse de mevcut sonuç korunur (oturum başına tek sonuç).
        var second = await svc.SubmitResultAsync(session.Id, new SubmitResultRequest(99_000, 8, 2));

        Assert.Equal(first.Id, second.Id);
        Assert.Equal(first.Score, second.Score);
        Assert.Equal(1, await db.GameResults.CountAsync());
    }

    [Fact]
    public async Task Submit_AutoShares_AndPushesTeacher_ExactlyOnce()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, student.Id);
        await AddTeacherTokenAsync(db, teacher.Id);

        var fake = new FakePushSender();
        var svc = new ResultService(db, TestCurrentUser.Student(student.Id), new PushDispatcher(db, fake));

        var result = await svc.SubmitResultAsync(session.Id, new SubmitResultRequest(45_000, 8, 6));

        Assert.True(result.SharedWithTeacher);
        Assert.NotNull(result.SharedAt);
        Assert.Equal(1, fake.CallCount); // öğretmene results push'u tam 1 kez

        // İkinci (idempotent) submit mevcut sonucu döndürür, tekrar push ETMEZ.
        await svc.SubmitResultAsync(session.Id, new SubmitResultRequest(99_000, 8, 2));
        Assert.Equal(1, fake.CallCount);
    }

    [Fact]
    public async Task Share_AlreadyShared_IsNoOp_NoPush_NoFieldChange()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, student.Id);
        await AddTeacherTokenAsync(db, teacher.Id);

        var fake = new FakePushSender();
        var svc = new ResultService(db, TestCurrentUser.Student(student.Id), new PushDispatcher(db, fake));

        // Submit zaten auto-share + 1 push yapar.
        var submitted = await svc.SubmitResultAsync(session.Id, new SubmitResultRequest(1000, 8, 8));
        Assert.Equal(1, fake.CallCount);
        var sharedAt = submitted.SharedAt;

        // ShareWithTeacher zaten-paylaşılmış sonuçta no-op: alan değişmez, ek push gitmez.
        var shared = await svc.ShareWithTeacherAsync(submitted.Id);
        Assert.True(shared.SharedWithTeacher);
        Assert.Equal(sharedAt, shared.SharedAt);
        Assert.Equal(1, fake.CallCount);
    }

    [Fact]
    public async Task Submit_InvalidValues_Throws400()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, student.Id);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        // correct > total geçersiz.
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.SubmitResultAsync(session.Id, new SubmitResultRequest(1000, 5, 6)));
        Assert.Equal(400, ex.StatusCode);
        Assert.Equal(0, await db.GameResults.CountAsync());
    }

    [Fact]
    public async Task Submit_NegativeDuration_Throws400()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, student.Id);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.SubmitResultAsync(session.Id, new SubmitResultRequest(-1, 8, 8)));
        Assert.Equal(400, ex.StatusCode);
        Assert.Equal(0, await db.GameResults.CountAsync());
    }

    [Fact]
    public async Task Submit_ExcessiveDuration_Throws400()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, student.Id);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        // 6 saat sınırını 1 ms aşan değer reddedilir.
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.SubmitResultAsync(session.Id, new SubmitResultRequest(ResultService.MaxDurationMs + 1, 8, 8)));
        Assert.Equal(400, ex.StatusCode);
        Assert.Equal(0, await db.GameResults.CountAsync());
    }

    [Fact]
    public async Task Submit_DurationAtUpperBound_Succeeds()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, student.Id);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        // Tam sınırdaki (6 saat) değer geçerli.
        var result = await svc.SubmitResultAsync(
            session.Id, new SubmitResultRequest(ResultService.MaxDurationMs, 8, 8));

        Assert.Equal(ResultService.MaxDurationMs, result.DurationMs);
        Assert.Equal(100, result.Score);
        Assert.Equal(1, await db.GameResults.CountAsync());
    }

    [Fact]
    public async Task Submit_OtherStudentsSession_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var owner = await SeedUserAsync(db, UserRole.Student, "s1@x.com");
        var intruder = await SeedUserAsync(db, UserRole.Student, "s2@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, owner.Id);

        var svc = new ResultService(db, TestCurrentUser.Student(intruder.Id));
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.SubmitResultAsync(session.Id, new SubmitResultRequest(1000, 8, 8)));
        Assert.Equal(404, ex.StatusCode);
        Assert.Equal(0, await db.GameResults.CountAsync());
    }

    [Fact]
    public async Task Submit_WithItems_PersistsBreakdown_AndDerivesTotals()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, student.Id);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        // İstemci totals=99/99 yollasa da item listesinden türetilmeli: 3 kalem, 2 doğru.
        var items = new List<SubmitResultItem>
        {
            new(0, "cat", "kedi", "kedi", true),
            new(1, "dog", "köpek", "balık", false),
            new(2, "bird", "kuş", "kuş", true),
        };
        var result = await svc.SubmitResultAsync(session.Id, new SubmitResultRequest(10_000, 99, 99, items));

        Assert.Equal(3, result.TotalItems);     // items.Count
        Assert.Equal(2, result.CorrectItems);    // items.Count(IsCorrect)
        Assert.Equal(67, result.Score);          // 2/3 → 66.66 → 67

        var saved = await db.GameResultItems
            .Where(i => i.ResultId == result.Id)
            .OrderBy(i => i.Ordinal)
            .ToListAsync();
        Assert.Equal(3, saved.Count);
        Assert.Equal("dog", saved[1].Term);
        Assert.Equal("köpek", saved[1].ExpectedAnswer);
        Assert.Equal("balık", saved[1].StudentAnswer);
        Assert.False(saved[1].IsCorrect);
    }

    [Fact]
    public async Task Submit_WithoutItems_KeepsClientTotals_AndStoresNoBreakdown()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, student.Id);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        // Items null (eski istemci): istemciden gelen sayılar korunur.
        var result = await svc.SubmitResultAsync(session.Id, new SubmitResultRequest(5000, 8, 6));

        Assert.Equal(8, result.TotalItems);
        Assert.Equal(6, result.CorrectItems);
        Assert.Equal(0, await db.GameResultItems.CountAsync());
    }

    // ---- Share ----

    [Fact]
    public async Task Share_Owner_SetsFlagAndSharedAt()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, student.Id);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var submitted = await svc.SubmitResultAsync(session.Id, new SubmitResultRequest(1000, 8, 8));

        var shared = await svc.ShareWithTeacherAsync(submitted.Id);
        Assert.True(shared.SharedWithTeacher);
        Assert.NotNull(shared.SharedAt);

        var reloaded = await db.GameResults.FirstAsync(r => r.Id == submitted.Id);
        Assert.True(reloaded.SharedWithTeacher);
        Assert.NotNull(reloaded.SharedAt);
    }

    [Fact]
    public async Task Share_Twice_IsIdempotent()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, student.Id);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var submitted = await svc.SubmitResultAsync(session.Id, new SubmitResultRequest(1000, 8, 8));

        var first = await svc.ShareWithTeacherAsync(submitted.Id);
        var second = await svc.ShareWithTeacherAsync(submitted.Id);

        Assert.True(second.SharedWithTeacher);
        Assert.Equal(first.SharedAt, second.SharedAt); // ikinci çağrı shared_at'i değiştirmez
    }

    [Fact]
    public async Task Share_OtherStudentsResult_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var owner = await SeedUserAsync(db, UserRole.Student, "s1@x.com");
        var intruder = await SeedUserAsync(db, UserRole.Student, "s2@x.com");
        var session = await SeedSessionAsync(db, teacher.Id, owner.Id);

        var ownerSvc = new ResultService(db, TestCurrentUser.Student(owner.Id));
        var submitted = await ownerSvc.SubmitResultAsync(session.Id, new SubmitResultRequest(1000, 8, 8));

        var intruderSvc = new ResultService(db, TestCurrentUser.Student(intruder.Id));
        var ex = await Assert.ThrowsAsync<AppException>(() => intruderSvc.ShareWithTeacherAsync(submitted.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    // ---- ListMine ----

    [Fact]
    public async Task ListMine_ReturnsOnlyOwnResults_WithLessonSummary_Newest_First()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var other = await SeedUserAsync(db, UserRole.Student, "o@x.com");

        var s1 = await SeedSessionAsync(db, teacher.Id, student.Id);
        var s2 = await SeedSessionAsync(db, teacher.Id, student.Id);
        var otherSession = await SeedSessionAsync(db, teacher.Id, other.Id);

        var studentSvc = new ResultService(db, TestCurrentUser.Student(student.Id));
        await studentSvc.SubmitResultAsync(s1.Id, new SubmitResultRequest(1000, 8, 4));
        await studentSvc.SubmitResultAsync(s2.Id, new SubmitResultRequest(2000, 8, 8));

        var otherSvc = new ResultService(db, TestCurrentUser.Student(other.Id));
        await otherSvc.SubmitResultAsync(otherSession.Id, new SubmitResultRequest(3000, 8, 1));

        var mine = await studentSvc.ListMineAsync();
        Assert.Equal(2, mine.Count);
        Assert.All(mine, r =>
        {
            Assert.Equal("Ders", r.LessonTitle);
            Assert.NotEqual(Guid.Empty, r.GameId);
            Assert.NotEqual(Guid.Empty, r.LessonId);
        });
        // Yeniden eskiye sıralı (en son gönderilen s2 başta).
        Assert.True(mine[0].CreatedAt >= mine[1].CreatedAt);
    }
}
