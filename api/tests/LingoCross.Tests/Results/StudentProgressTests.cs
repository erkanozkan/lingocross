using LingoCross.Application.Results;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Results;

/// <summary>
/// F3.1+ — Öğrenci "Gelişim Özeti" (GetMyProgressAsync): oynanan oyun, ortalama doğruluk,
/// 7 günlük doğruluk trendi, haftalık dakika/hedef ve günlük seri. Tarihler elle set edilerek
/// deterministik test edilir; pencere hesapları sabit "şimdi"ye göre değil, gerçek UtcNow'a göre
/// yapıldığından, tohumlanan tarihler UtcNow'a göreli (now-Xg) seçilir.
/// </summary>
public class StudentProgressTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"progress-{Guid.NewGuid()}")
            .Options);

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role, string email)
    {
        var user = new User { Email = email, PasswordHash = "x", DisplayName = email, Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    private static async Task<Game> SeedGameAsync(AppDbContext db, Guid teacherId)
    {
        var lesson = new Lesson { TeacherId = teacherId, Title = "Ders", IsPublished = true };
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();

        var game = new Game { LessonId = lesson.Id, Type = GameType.WordMatching, Title = "Kelime Eşleştirme" };
        db.Games.Add(game);
        await db.SaveChangesAsync();
        return game;
    }

    /// <summary>
    /// Belirli bir CreatedAt, skor ve süre ile tamamlanmış bir sonuç (+ oturum) seed eder.
    /// CreatedAt otomatik damgalandığı için kayıt sonrası Modified ile geçersiz kılınır (yalnız
    /// UpdatedAt değişir, CreatedAt korunur).
    /// </summary>
    private static async Task SeedResultAsync(
        AppDbContext db, Guid gameId, Guid studentId, DateTime createdAtUtc, int score, int durationMs)
    {
        var session = new GameSession
        {
            GameId = gameId,
            StudentId = studentId,
            Status = GameSessionStatus.Completed,
            StartedAt = createdAtUtc,
            CompletedAt = createdAtUtc,
        };
        db.GameSessions.Add(session);
        await db.SaveChangesAsync();

        var result = new GameResult
        {
            SessionId = session.Id,
            DurationMs = durationMs,
            TotalItems = 10,
            CorrectItems = score / 10,
            Score = score,
            SharedWithTeacher = true,
            SharedAt = createdAtUtc,
        };
        db.GameResults.Add(result);
        await db.SaveChangesAsync();

        // CreatedAt'i deterministik değere çek (Add anında UtcNow damgalanmıştı).
        result.CreatedAt = createdAtUtc;
        await db.SaveChangesAsync();
    }

    [Fact]
    public async Task GetMyProgress_NoResults_AllZero_TrendNull()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var p = await svc.GetMyProgressAsync();

        Assert.Equal(0, p.GamesPlayed);
        Assert.Equal(0, p.AverageAccuracy);
        Assert.Null(p.AccuracyTrendDelta);
        Assert.Equal(0, p.WeeklyMinutes);
        Assert.Equal(ResultService.WeeklyGoalMinutes, p.WeeklyGoalMinutes);
        Assert.Equal(0, p.StreakDays);
    }

    [Fact]
    public async Task GetMyProgress_ComputesAllMetrics()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var game = await SeedGameAsync(db, teacher.Id);

        var now = DateTime.UtcNow;

        // Son 7 gün penceresi: bugün, dün, 2 gün önce (ardışık → streak 3). Skorlar 100/80/60.
        // Süreler 5dk + 10dk + 6dk = 21 dk (1.260.000 ms toplam, haftalık).
        await SeedResultAsync(db, game.Id, student.Id, now, 100, 5 * 60000);
        await SeedResultAsync(db, game.Id, student.Id, now.AddDays(-1), 80, 10 * 60000);
        await SeedResultAsync(db, game.Id, student.Id, now.AddDays(-2), 60, 6 * 60000);

        // Önceki 7 gün (14..7): 9 ve 10 gün önce. Skorlar 40/60 → ort 50. Süreler haftalık'a girmez.
        await SeedResultAsync(db, game.Id, student.Id, now.AddDays(-9), 40, 99 * 60000);
        await SeedResultAsync(db, game.Id, student.Id, now.AddDays(-10), 60, 99 * 60000);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var p = await svc.GetMyProgressAsync();

        Assert.Equal(5, p.GamesPlayed);
        // (100+80+60+40+60)/5 = 68
        Assert.Equal(68, p.AverageAccuracy);
        Assert.Equal(21, p.WeeklyMinutes);
        Assert.Equal(ResultService.WeeklyGoalMinutes, p.WeeklyGoalMinutes);
        // Son7 ort = (100+80+60)/3 = 80 ; Önceki7 ort = (40+60)/2 = 50 → delta +30
        Assert.Equal(30, p.AccuracyTrendDelta);
        // Bugün, dün, 2 gün önce ardışık → streak 3 (9/10 gün öncesi boşlukla kopuk).
        Assert.Equal(3, p.StreakDays);
    }

    [Fact]
    public async Task GetMyProgress_NoPreviousWindow_TrendNull()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var game = await SeedGameAsync(db, teacher.Id);

        var now = DateTime.UtcNow;

        // Yalnız son 7 günde sonuç var → önceki pencere boş → trend null.
        await SeedResultAsync(db, game.Id, student.Id, now, 90, 4 * 60000);
        await SeedResultAsync(db, game.Id, student.Id, now.AddDays(-1), 70, 4 * 60000);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var p = await svc.GetMyProgressAsync();

        Assert.Equal(2, p.GamesPlayed);
        Assert.Null(p.AccuracyTrendDelta);
        Assert.Equal(8, p.WeeklyMinutes);
        Assert.Equal(2, p.StreakDays);
    }

    [Fact]
    public async Task GetMyProgress_StreakBreaksOnGap()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var game = await SeedGameAsync(db, teacher.Id);

        var now = DateTime.UtcNow;

        // Bugün + dün (ardışık), sonra 3 gün önce (boşluk: 2 gün önce yok) → streak 2.
        await SeedResultAsync(db, game.Id, student.Id, now, 100, 60000);
        await SeedResultAsync(db, game.Id, student.Id, now.AddDays(-1), 100, 60000);
        await SeedResultAsync(db, game.Id, student.Id, now.AddDays(-3), 100, 60000);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var p = await svc.GetMyProgressAsync();

        Assert.Equal(2, p.StreakDays);
    }

    [Fact]
    public async Task GetMyProgress_StreakStartsYesterday_WhenNoResultToday()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var game = await SeedGameAsync(db, teacher.Id);

        var now = DateTime.UtcNow;

        // Bugün sonuç yok; dün + 2 gün önce ardışık → streak dünden başlar = 2.
        await SeedResultAsync(db, game.Id, student.Id, now.AddDays(-1), 100, 60000);
        await SeedResultAsync(db, game.Id, student.Id, now.AddDays(-2), 100, 60000);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var p = await svc.GetMyProgressAsync();

        Assert.Equal(2, p.StreakDays);
    }

    [Fact]
    public async Task GetMyProgress_StaleResults_StreakZero()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var game = await SeedGameAsync(db, teacher.Id);

        var now = DateTime.UtcNow;

        // Ne bugün ne dün sonuç var (en yenisi 3 gün önce) → streak 0.
        await SeedResultAsync(db, game.Id, student.Id, now.AddDays(-3), 100, 60000);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var p = await svc.GetMyProgressAsync();

        Assert.Equal(0, p.StreakDays);
        Assert.Equal(1, p.GamesPlayed);
    }

    [Fact]
    public async Task GetMyProgress_OnlyCountsOwnResults()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var other = await SeedUserAsync(db, UserRole.Student, "o@x.com");
        var game = await SeedGameAsync(db, teacher.Id);

        var now = DateTime.UtcNow;

        await SeedResultAsync(db, game.Id, student.Id, now, 100, 5 * 60000);
        // Başka öğrencinin sonuçları sayılmamalı.
        await SeedResultAsync(db, game.Id, other.Id, now, 0, 99 * 60000);
        await SeedResultAsync(db, game.Id, other.Id, now.AddDays(-1), 0, 99 * 60000);

        var svc = new ResultService(db, TestCurrentUser.Student(student.Id));
        var p = await svc.GetMyProgressAsync();

        Assert.Equal(1, p.GamesPlayed);
        Assert.Equal(100, p.AverageAccuracy);
        Assert.Equal(5, p.WeeklyMinutes);
        Assert.Equal(1, p.StreakDays);
    }
}
