using LingoCross.Application.Admin.Dtos;
using LingoCross.Application.Common.Persistence;
using LingoCross.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Admin;

/// <summary>
/// Salt-okur admin metrikleri. Sayımlar DB tarafında (Count/GroupBy); zaman serileri için ilgili
/// tarih sütunu son N günle sınırlı çekilip bellekte UTC gün bazında gruplanır (boş günler 0).
/// </summary>
public class AdminMetricsService : IAdminMetricsService
{
    private readonly IAppDbContext _db;

    public AdminMetricsService(IAppDbContext db) => _db = db;

    public async Task<OverviewDto> GetOverviewAsync(CancellationToken cancellationToken = default)
    {
        var now = DateTime.UtcNow;

        var teacherCount = await _db.Users.CountAsync(u => u.Role == UserRole.Teacher, cancellationToken);
        var studentCount = await _db.Users.CountAsync(u => u.Role == UserRole.Student, cancellationToken);
        var totalUsers = teacherCount + studentCount;

        var activeClasses = await _db.Classes.CountAsync(c => !c.IsArchived, cancellationToken);
        var lessons = await _db.Lessons.CountAsync(cancellationToken);
        var words = await _db.Words.CountAsync(cancellationToken);
        var publishedGames = await _db.Games.CountAsync(g => g.IsPublished, cancellationToken);
        var sessions = await _db.GameSessions.CountAsync(cancellationToken);
        var results = await _db.GameResults.CountAsync(cancellationToken);

        double? averageScore = await _db.GameResults.AnyAsync(cancellationToken)
            ? await _db.GameResults.AverageAsync(r => (double)r.Score, cancellationToken)
            : null;

        var subscriptions = await BuildSubscriptionBreakdownAsync(now, totalUsers, cancellationToken);

        var activeStudents7d = await CountActiveStudentsAsync(now.AddDays(-7), cancellationToken);
        var activeStudents30d = await CountActiveStudentsAsync(now.AddDays(-30), cancellationToken);

        return new OverviewDto(
            teacherCount,
            studentCount,
            totalUsers,
            activeClasses,
            lessons,
            words,
            publishedGames,
            sessions,
            results,
            averageScore is { } avg ? Math.Round(avg, 1) : null,
            subscriptions,
            activeStudents7d,
            activeStudents30d);
    }

    public async Task<TimeseriesDto> GetTimeseriesAsync(
        string metric, int days, CancellationToken cancellationToken = default)
    {
        var normalizedMetric = (metric ?? string.Empty).Trim().ToLowerInvariant();
        var clampedDays = Math.Clamp(days <= 0 ? 30 : days, 1, 365);
        var since = DateTime.UtcNow.Date.AddDays(-(clampedDays - 1));

        var dates = normalizedMetric switch
        {
            "signups" => await _db.Users
                .Where(u => u.CreatedAt >= since)
                .Select(u => u.CreatedAt)
                .ToListAsync(cancellationToken),
            "sessions" => await _db.GameSessions
                .Where(s => s.StartedAt >= since)
                .Select(s => s.StartedAt)
                .ToListAsync(cancellationToken),
            "results" => await _db.GameResults
                .Where(r => r.CreatedAt >= since)
                .Select(r => r.CreatedAt)
                .ToListAsync(cancellationToken),
            "subscriptions" => await _db.Subscriptions
                .Where(sub => sub.StartedAt >= since)
                .Select(sub => sub.StartedAt)
                .ToListAsync(cancellationToken),
            _ => throw new Common.Exceptions.AppException(
                400, $"Bilinmeyen metrik: '{metric}'. signups|sessions|results|subscriptions bekleniyor."),
        };

        var points = BuildDailySeries(dates, since, clampedDays);
        return new TimeseriesDto(normalizedMetric, clampedDays, points);
    }

    public async Task<EngagementDto> GetEngagementAsync(CancellationToken cancellationToken = default)
    {
        var byTypeRaw = await _db.GameSessions
            .GroupBy(s => s.Game.Type)
            .Select(g => new { Type = g.Key, Count = g.Count() })
            .ToListAsync(cancellationToken);

        var gameTypes = byTypeRaw
            .Select(x => new GameTypeCountDto(x.Type.ToString(), x.Count))
            .OrderByDescending(x => x.Sessions)
            .ToList();

        var totalResults = await _db.GameResults.CountAsync(cancellationToken);
        double? averageScore = totalResults > 0
            ? Math.Round(await _db.GameResults.AverageAsync(r => (double)r.Score, cancellationToken), 1)
            : null;
        var sharedResults = await _db.GameResults.CountAsync(r => r.SharedWithTeacher, cancellationToken);
        var sharedRate = totalResults > 0
            ? Math.Round((double)sharedResults / totalResults, 3)
            : 0d;

        return new EngagementDto(gameTypes, averageScore, totalResults, sharedResults, sharedRate);
    }

    public async Task<SubscriptionsDto> GetSubscriptionsAsync(
        int days, CancellationToken cancellationToken = default)
    {
        var now = DateTime.UtcNow;
        var totalUsers = await _db.Users.CountAsync(cancellationToken);
        var breakdown = await BuildSubscriptionBreakdownAsync(now, totalUsers, cancellationToken);

        var bySourceRaw = await _db.Subscriptions
            .GroupBy(s => s.Source)
            .Select(g => new { Source = g.Key, Count = g.Count() })
            .ToListAsync(cancellationToken);

        var bySource = bySourceRaw
            .Select(x => new GameTypeCountDto(x.Source.ToString(), x.Count))
            .OrderByDescending(x => x.Sessions)
            .ToList();

        var newSubscriptions = await GetTimeseriesAsync("subscriptions", days, cancellationToken);

        return new SubscriptionsDto(breakdown, bySource, newSubscriptions);
    }

    public async Task<RecentDto> GetRecentAsync(int take, CancellationToken cancellationToken = default)
    {
        var clampedTake = Math.Clamp(take <= 0 ? 20 : take, 1, 100);

        var usersRaw = await _db.Users
            .OrderByDescending(u => u.CreatedAt)
            .Take(clampedTake)
            .Select(u => new { u.DisplayName, u.Email, u.Role, u.CreatedAt })
            .ToListAsync(cancellationToken);

        var users = usersRaw
            .Select(u => new RecentUserDto(u.DisplayName, u.Email, u.Role.ToString(), u.CreatedAt))
            .ToList();

        var results = await _db.GameResults
            .OrderByDescending(r => r.CreatedAt)
            .Take(clampedTake)
            .Select(r => new RecentResultDto(
                r.Session.Student.DisplayName,
                // QuestionSet oyununda (Lesson null) başlık konu başlığından gelir.
                r.Session.Game.Lesson != null
                    ? r.Session.Game.Lesson.Title
                    : (r.Session.Game.QuestionTopic != null ? r.Session.Game.QuestionTopic.Title : ""),
                r.Score,
                r.CreatedAt))
            .ToListAsync(cancellationToken);

        return new RecentDto(users, results);
    }

    /// <summary>
    /// Premium = (Active veya Trial) ve (ExpiresAt null veya gelecekte). Free = totalUsers eksi
    /// premium-aktif sahipleri. Diğer kategoriler ham durum sayımıdır (bilgi amaçlı).
    /// </summary>
    private async Task<SubscriptionBreakdownDto> BuildSubscriptionBreakdownAsync(
        DateTime now, int totalUsers, CancellationToken cancellationToken)
    {
        var premiumActive = await _db.Subscriptions.CountAsync(
            s => (s.Status == SubscriptionStatus.Active || s.Status == SubscriptionStatus.Trial)
                && (s.ExpiresAt == null || s.ExpiresAt > now),
            cancellationToken);

        var trial = await _db.Subscriptions.CountAsync(
            s => s.Status == SubscriptionStatus.Trial
                && (s.ExpiresAt == null || s.ExpiresAt > now),
            cancellationToken);

        var canceled = await _db.Subscriptions.CountAsync(
            s => s.Status == SubscriptionStatus.Canceled, cancellationToken);

        var expired = await _db.Subscriptions.CountAsync(
            s => s.Status == SubscriptionStatus.Expired
                || ((s.Status == SubscriptionStatus.Active || s.Status == SubscriptionStatus.Trial)
                    && s.ExpiresAt != null && s.ExpiresAt <= now),
            cancellationToken);

        var free = Math.Max(0, totalUsers - premiumActive);

        return new SubscriptionBreakdownDto(premiumActive, trial, canceled, expired, free);
    }

    /// <summary>Verilen andan beri en az bir GameResult'u olan distinct öğrenci sayısı (Result→Session→Student).</summary>
    private async Task<int> CountActiveStudentsAsync(DateTime since, CancellationToken cancellationToken)
    {
        return await _db.GameResults
            .Where(r => r.CreatedAt >= since)
            .Select(r => r.Session.StudentId)
            .Distinct()
            .CountAsync(cancellationToken);
    }

    /// <summary>UTC gün bazında [since, since+days) penceresinde günlük sayar; boş günleri 0 ile doldurur.</summary>
    private static IReadOnlyList<TimeseriesPointDto> BuildDailySeries(
        IReadOnlyList<DateTime> timestamps, DateTime since, int days)
    {
        var counts = new int[days];
        var startDate = DateOnly.FromDateTime(since);

        foreach (var ts in timestamps)
        {
            var index = (DateOnly.FromDateTime(ts.ToUniversalTime()).DayNumber) - startDate.DayNumber;
            if (index >= 0 && index < days)
            {
                counts[index]++;
            }
        }

        var points = new List<TimeseriesPointDto>(days);
        for (var i = 0; i < days; i++)
        {
            points.Add(new TimeseriesPointDto(startDate.AddDays(i), counts[i]));
        }

        return points;
    }
}
