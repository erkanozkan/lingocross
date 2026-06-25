using LingoCross.Application.Admin;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Admin;

/// <summary>
/// AdminMetricsService (salt-okur): overview sayıları, timeseries gün/sayı + boş gün doldurma,
/// engagement tür dağılımı/paylaşım oranı, premium tanımı (Active/Trial + süresi geçmemiş) ve
/// activeStudents (Result→Session→Student distinct, pencere) doğrulanır.
/// </summary>
public class AdminMetricsServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"admin-metrics-{Guid.NewGuid()}")
            .Options);

    private static async Task<User> SeedUserAsync(
        AppDbContext db, UserRole role, string email, string name, DateTime? createdAt = null)
    {
        var user = new User { Email = email, PasswordHash = "x", DisplayName = name, Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        if (createdAt is { } ts)
        {
            user.CreatedAt = ts;
            await db.SaveChangesAsync();
        }
        return user;
    }

    private static async Task<Game> SeedPublishedGameAsync(
        AppDbContext db, Guid teacherId, GameType type = GameType.WordMatching, int wordCount = 0)
    {
        var lesson = new Lesson { TeacherId = teacherId, Title = "Ders", IsPublished = true };
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();

        for (var i = 0; i < wordCount; i++)
        {
            db.Words.Add(new Word { LessonId = lesson.Id, Term = $"w{i}", SortOrder = i });
        }
        await db.SaveChangesAsync();

        var game = new Game { LessonId = lesson.Id, Type = type, Title = "Oyun", IsPublished = true, PublishedAt = DateTime.UtcNow };
        db.Games.Add(game);
        await db.SaveChangesAsync();
        return game;
    }

    private static async Task<GameResult> SeedResultAsync(
        AppDbContext db, Guid gameId, Guid studentId, int score, bool shared, DateTime createdAt)
    {
        var session = new GameSession
        {
            GameId = gameId,
            StudentId = studentId,
            Status = GameSessionStatus.Completed,
            StartedAt = createdAt,
            CompletedAt = createdAt,
        };
        db.GameSessions.Add(session);
        await db.SaveChangesAsync();
        session.StartedAt = createdAt;
        await db.SaveChangesAsync();

        var result = new GameResult
        {
            SessionId = session.Id,
            DurationMs = 1000,
            TotalItems = 10,
            CorrectItems = score / 10,
            Score = score,
            SharedWithTeacher = shared,
        };
        db.GameResults.Add(result);
        await db.SaveChangesAsync();
        result.CreatedAt = createdAt;
        await db.SaveChangesAsync();
        return result;
    }

    [Fact]
    public async Task GetOverview_CountsUsersContentAndEngagement()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@x.com", "S1");
        var s2 = await SeedUserAsync(db, UserRole.Student, "s2@x.com", "S2");

        db.Classes.Add(new Class { TeacherId = teacher.Id, Name = "Aktif" });
        db.Classes.Add(new Class { TeacherId = teacher.Id, Name = "Arşiv", IsArchived = true });
        await db.SaveChangesAsync();

        var game = await SeedPublishedGameAsync(db, teacher.Id, wordCount: 3);

        await SeedResultAsync(db, game.Id, s1.Id, 80, shared: true, DateTime.UtcNow.AddDays(-1));
        await SeedResultAsync(db, game.Id, s2.Id, 60, shared: false, DateTime.UtcNow.AddDays(-2));

        var svc = new AdminMetricsService(db);
        var o = await svc.GetOverviewAsync();

        Assert.Equal(1, o.TeacherCount);
        Assert.Equal(2, o.StudentCount);
        Assert.Equal(3, o.TotalUsers);
        Assert.Equal(1, o.ActiveClasses); // arşivli hariç
        Assert.Equal(1, o.Lessons);
        Assert.Equal(3, o.Words);
        Assert.Equal(1, o.PublishedGames);
        Assert.Equal(2, o.Sessions);
        Assert.Equal(2, o.Results);
        Assert.Equal(70d, o.AverageScore);
        Assert.Equal(2, o.ActiveStudents7d);
        Assert.Equal(2, o.ActiveStudents30d);
    }

    [Fact]
    public async Task GetOverview_PremiumDefinition_RespectsExpiry()
    {
        var db = NewDb();
        var a = await SeedUserAsync(db, UserRole.Student, "a@x.com", "A");
        var b = await SeedUserAsync(db, UserRole.Student, "b@x.com", "B");
        var c = await SeedUserAsync(db, UserRole.Student, "c@x.com", "C");
        var d = await SeedUserAsync(db, UserRole.Student, "d@x.com", "D");

        // Aktif premium (süresi gelecekte).
        db.Subscriptions.Add(new Subscription { UserId = a.Id, Plan = SubscriptionPlan.Premium, Status = SubscriptionStatus.Active, Source = SubscriptionSource.Manual, StartedAt = DateTime.UtcNow.AddDays(-3), ExpiresAt = DateTime.UtcNow.AddDays(20) });
        // Trial (süresi gelecekte) → premium + trial sayılır.
        db.Subscriptions.Add(new Subscription { UserId = b.Id, Plan = SubscriptionPlan.Premium, Status = SubscriptionStatus.Trial, Source = SubscriptionSource.Stub, StartedAt = DateTime.UtcNow.AddDays(-1), ExpiresAt = DateTime.UtcNow.AddDays(6) });
        // Active ama süresi geçmiş → premium DEĞİL, expired sayılır.
        db.Subscriptions.Add(new Subscription { UserId = c.Id, Plan = SubscriptionPlan.Premium, Status = SubscriptionStatus.Active, Source = SubscriptionSource.Manual, StartedAt = DateTime.UtcNow.AddDays(-40), ExpiresAt = DateTime.UtcNow.AddDays(-1) });
        // Canceled.
        db.Subscriptions.Add(new Subscription { UserId = d.Id, Plan = SubscriptionPlan.Premium, Status = SubscriptionStatus.Canceled, Source = SubscriptionSource.Manual, StartedAt = DateTime.UtcNow.AddDays(-10) });
        await db.SaveChangesAsync();

        var svc = new AdminMetricsService(db);
        var o = await svc.GetOverviewAsync();

        Assert.Equal(2, o.Subscriptions.PremiumActive); // a + b
        Assert.Equal(1, o.Subscriptions.Trial);         // b
        Assert.Equal(1, o.Subscriptions.Canceled);      // d
        Assert.Equal(1, o.Subscriptions.Expired);       // c (lazy-expiry)
        Assert.Equal(2, o.Subscriptions.Free);          // totalUsers(4) - premiumActive(2)
    }

    [Fact]
    public async Task GetTimeseries_BucketsByDay_AndFillsEmptyDays()
    {
        var db = NewDb();
        // 3 kullanıcı: bugün 2, dün 0, 2 gün önce 1.
        await SeedUserAsync(db, UserRole.Student, "u1@x.com", "U1", DateTime.UtcNow);
        await SeedUserAsync(db, UserRole.Student, "u2@x.com", "U2", DateTime.UtcNow);
        await SeedUserAsync(db, UserRole.Student, "u3@x.com", "U3", DateTime.UtcNow.AddDays(-2));

        var svc = new AdminMetricsService(db);
        var ts = await svc.GetTimeseriesAsync("signups", 3);

        Assert.Equal("signups", ts.Metric);
        Assert.Equal(3, ts.Days);
        Assert.Equal(3, ts.Points.Count);
        // En eski → en yeni sırada: [2 gün önce]=1, [dün]=0, [bugün]=2.
        Assert.Equal(1, ts.Points[0].Count);
        Assert.Equal(0, ts.Points[1].Count);
        Assert.Equal(2, ts.Points[2].Count);
        Assert.Equal(3, ts.Points.Sum(p => p.Count));
    }

    [Fact]
    public async Task GetTimeseries_UnknownMetric_Throws400()
    {
        var db = NewDb();
        var svc = new AdminMetricsService(db);
        var ex = await Assert.ThrowsAsync<LingoCross.Application.Common.Exceptions.AppException>(
            () => svc.GetTimeseriesAsync("bogus", 7));
        Assert.Equal(400, ex.StatusCode);
    }

    [Fact]
    public async Task GetEngagement_GameTypeDistributionAndSharedRate()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@x.com", "S1");

        var matching = await SeedPublishedGameAsync(db, teacher.Id, GameType.WordMatching);
        var scrambled = await SeedPublishedGameAsync(db, teacher.Id, GameType.Scrambled);

        await SeedResultAsync(db, matching.Id, s1.Id, 100, shared: true, DateTime.UtcNow.AddHours(-1));
        await SeedResultAsync(db, matching.Id, s1.Id, 50, shared: false, DateTime.UtcNow.AddHours(-2));
        await SeedResultAsync(db, scrambled.Id, s1.Id, 90, shared: true, DateTime.UtcNow.AddHours(-3));

        var svc = new AdminMetricsService(db);
        var e = await svc.GetEngagementAsync();

        Assert.Equal(3, e.TotalResults);
        Assert.Equal(2, e.SharedResults);
        Assert.Equal(0.667, e.SharedRate);
        Assert.Equal(80d, e.AverageScore); // (100+50+90)/3 = 80
        Assert.Equal(2, e.GameTypes.Count);
        var wm = e.GameTypes.First(g => g.Type == nameof(GameType.WordMatching));
        Assert.Equal(2, wm.Sessions);
        var sc = e.GameTypes.First(g => g.Type == nameof(GameType.Scrambled));
        Assert.Equal(1, sc.Sessions);
    }

    [Fact]
    public async Task GetRecent_ReturnsLatestUsersAndResults()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@x.com", "Sema");
        var game = await SeedPublishedGameAsync(db, teacher.Id);
        await SeedResultAsync(db, game.Id, s1.Id, 95, shared: false, DateTime.UtcNow.AddMinutes(-5));

        var svc = new AdminMetricsService(db);
        var r = await svc.GetRecentAsync(10);

        Assert.Equal(2, r.Users.Count); // teacher + student
        Assert.Single(r.Results);
        Assert.Equal("Sema", r.Results[0].StudentName);
        Assert.Equal("Ders", r.Results[0].LessonTitle);
        Assert.Equal(95, r.Results[0].Score);
    }
}
