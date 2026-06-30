using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Notifications;
using LingoCross.Application.Results.Dtos;
using LingoCross.Application.Teachers.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Results;

/// <summary>
/// Oyun sonuçlarının kaydı/paylaşımı/listelenmesi. Erişim ve sahiplik kuralları bu katmanda
/// uygulanır; öğrenci yalnızca kendi oturum/sonucuna erişebilir (aksi 404).
/// </summary>
public class ResultService : IResultService
{
    private readonly IAppDbContext _db;
    private readonly ICurrentUser _currentUser;
    private readonly PushDispatcher? _push;

    /// <summary>
    /// Oyun süresi için makul üst sınır (6 saat, ms). İstemciden gelen <c>durationMs</c> bu sınırı
    /// aşarsa (ör. arka planda unutulmuş/manipüle edilmiş oturum) sonuç reddedilir.
    /// </summary>
    public const int MaxDurationMs = 6 * 60 * 60 * 1000;

    public ResultService(IAppDbContext db, ICurrentUser currentUser, PushDispatcher? push = null)
    {
        _db = db;
        _currentUser = currentUser;
        // Push opsiyonel: enjekte edilmezse tetikler atlanır (testler için no-op).
        _push = push;
    }

    /// <summary>
    /// Doğruluk yüzdesi olarak başarı puanı (0–100). total 0 ise 0; aksi halde
    /// correct/total*100 en yakın tam sayıya yuvarlanır. correct, total ile sınırlanır.
    /// </summary>
    public static int CalculateScore(int totalItems, int correctItems)
    {
        if (totalItems <= 0)
        {
            return 0;
        }

        var correct = Math.Clamp(correctItems, 0, totalItems);
        return (int)Math.Round(correct * 100.0 / totalItems, MidpointRounding.AwayFromZero);
    }

    public async Task<GameResultDto> SubmitResultAsync(
        Guid sessionId, SubmitResultRequest request, CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        // F7.5: kelime-bazlı kırılım gelirse toplam/doğru sayıları item listesinden türetilir;
        // aksi halde istemciden gelen sayılar kullanılır (eski istemci uyumu).
        var hasItems = request.Items is { Count: > 0 };
        var totalItems = hasItems ? request.Items!.Count : request.TotalItems;
        var correctItems = hasItems ? request.Items!.Count(i => i.IsCorrect) : request.CorrectItems;

        if (request.DurationMs < 0 || request.DurationMs > MaxDurationMs
            || totalItems < 0 || correctItems < 0
            || correctItems > totalItems)
        {
            throw AppException.BadRequest("Geçersiz sonuç değerleri.");
        }

        var session = await _db.GameSessions
            .Include(s => s.Result)
            .FirstOrDefaultAsync(s => s.Id == sessionId, cancellationToken);

        // Varlığı sızdırmamak için sahibi olmayan/yok olan oturumda 404.
        if (session is null || session.StudentId != studentId)
        {
            throw AppException.NotFound("Oyun oturumu bulunamadı.");
        }

        // Oturum başına tek sonuç: tekrar gönderimde mevcut sonuç idempotent biçimde döner.
        if (session.Result is not null)
        {
            return await ToDtoAsync(session.Result, cancellationToken);
        }

        if (session.Status != GameSessionStatus.InProgress)
        {
            throw AppException.Conflict("Bu oturum için sonuç gönderilemez.");
        }

        var result = new GameResult
        {
            SessionId = session.Id,
            DurationMs = request.DurationMs,
            TotalItems = totalItems,
            CorrectItems = correctItems,
            Score = CalculateScore(totalItems, correctItems),
            // Otomatik paylaşım: bulmaca tamamlanır tamamlanmaz sonuç öğretmenle paylaşılır.
            // (Artık manuel ShareWithTeacher gerekmez; o metot geriye dönük uyum için no-op'a yakın kalır.)
            SharedWithTeacher = true,
            SharedAt = DateTime.UtcNow,
        };

        if (hasItems)
        {
            foreach (var item in request.Items!)
            {
                result.Items.Add(new GameResultItem
                {
                    Ordinal = item.Ordinal,
                    Term = item.Term,
                    ExpectedAnswer = item.ExpectedAnswer,
                    StudentAnswer = item.StudentAnswer,
                    IsCorrect = item.IsCorrect,
                });
            }
        }

        _db.GameResults.Add(result);

        session.Status = GameSessionStatus.Completed;
        session.CompletedAt = DateTime.UtcNow;

        await _db.SaveChangesAsync(cancellationToken);

        // Best-effort push: sonuç otomatik paylaşıldığı için öğretmene "sonuç paylaşıldı" bildirimi
        // burada (yeni sonuç oluşturulduğunda) tetiklenir. İdempotentlik: ikinci submit mevcut sonucu
        // yukarıda döndürdüğü için buraya yalnız ilk (yeni) kayıtta gelinir → push tam 1 kez gider.
        if (_push is not null)
        {
            await NotifyTeacherSharedAsync(result, studentId, cancellationToken);
        }

        return await ToDtoAsync(result, cancellationToken);
    }

    public async Task<GameResultDto> ShareWithTeacherAsync(Guid resultId, CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        var result = await _db.GameResults
            .Include(r => r.Session)
            .FirstOrDefaultAsync(r => r.Id == resultId, cancellationToken);

        if (result is null || result.Session.StudentId != studentId)
        {
            throw AppException.NotFound("Sonuç bulunamadı.");
        }

        if (!result.SharedWithTeacher)
        {
            result.SharedWithTeacher = true;
            result.SharedAt = DateTime.UtcNow;
            await _db.SaveChangesAsync(cancellationToken);

            // Best-effort push: dersin öğretmenine "sonuç paylaşıldı" bildirimi (yalnız yeni paylaşımda).
            if (_push is not null)
            {
                await NotifyTeacherSharedAsync(result, studentId, cancellationToken);
            }
        }

        return await ToDtoAsync(result, cancellationToken);
    }

    /// <summary>
    /// Sonucun ait olduğu dersin öğretmenine "sonuç paylaşıldı" push'u gönderir. Öğretmen id'si ve
    /// öğrenci adı oturum→oyun→ders zincirinden çekilir. Best-effort: hata yutulur.
    /// </summary>
    private async Task NotifyTeacherSharedAsync(GameResult result, Guid studentId, CancellationToken cancellationToken)
    {
        try
        {
            var info = await _db.GameSessions
                .Where(s => s.Id == result.SessionId)
                .Select(s => new
                {
                    // Ders-tabanlı oyunda öğretmen dersin sahibidir; QuestionSet (Lesson null) oyununda
                    // ise oyunun atandığı (arşivlenmemiş) sınıfın sahibi öğretmendir.
                    TeacherId = s.Game.Lesson != null
                        ? (Guid?)s.Game.Lesson.TeacherId
                        : _db.GameAssignments
                            .Where(a => a.GameId == s.GameId && !a.Class.IsArchived)
                            .Select(a => (Guid?)a.Class.TeacherId)
                            .FirstOrDefault(),
                    LessonId = s.Game.LessonId,
                })
                .FirstOrDefaultAsync(cancellationToken);

            if (info?.TeacherId is not { } teacherId)
            {
                return;
            }

            var studentName = await _db.Users
                .Where(u => u.Id == studentId)
                .Select(u => u.DisplayName)
                .FirstOrDefaultAsync(cancellationToken) ?? "Bir öğrenci";

            var data = new Dictionary<string, string>
            {
                ["type"] = "results",
                ["resultId"] = result.Id.ToString(),
            };

            // Ders-tabanlı oyunda deep-link için lessonId; QuestionSet'te ders yok → eklenmez.
            if (info.LessonId is { } lessonId)
            {
                data["lessonId"] = lessonId.ToString();
            }

            await _push!.NotifyUsersAsync(
                new[] { teacherId },
                PushType.Results,
                "Sonuç paylaşıldı",
                $"{studentName} bir sonucu seninle paylaştı",
                data,
                cancellationToken);
        }
        catch
        {
            // Bildirim hatası paylaşma işlemini bozmaz.
        }
    }

    public async Task<IReadOnlyList<GameResultDto>> ListMineAsync(CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        var rows = await _db.GameResults
            .Where(r => r.Session.StudentId == studentId)
            .OrderByDescending(r => r.CreatedAt)
            .Select(r => new
            {
                Result = r,
                r.Session.GameId,
                GameType = r.Session.Game.Type,
                LessonId = r.Session.Game.LessonId,
                // QuestionSet oyununda (Lesson null) başlık konu başlığından gelir.
                LessonTitle = r.Session.Game.Lesson != null
                    ? r.Session.Game.Lesson.Title
                    : (r.Session.Game.QuestionTopic != null ? r.Session.Game.QuestionTopic.Title : ""),
            })
            .ToListAsync(cancellationToken);

        return rows
            .Select(x => ToDto(x.Result, x.GameId, x.GameType, x.LessonId, x.LessonTitle))
            .ToList();
    }

    public async Task<MyResultDetailDto> GetMyResultAsync(Guid resultId, CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        // Sonuç geçerli öğrencinin oturumuna ait olmalı; aksi/yoksa 404 (varlığı sızdırmamak için).
        // Items oturum→sonuç kırılımından, Ordinal artan sırada projekte edilir.
        var detail = await _db.GameResults
            .Where(r => r.Id == resultId && r.Session.StudentId == studentId)
            .Select(r => new
            {
                r.Id,
                r.Session.GameId,
                GameType = r.Session.Game.Type,
                LessonId = r.Session.Game.LessonId,
                // QuestionSet oyununda (Lesson null) başlık konu başlığından gelir.
                LessonTitle = r.Session.Game.Lesson != null
                    ? r.Session.Game.Lesson.Title
                    : (r.Session.Game.QuestionTopic != null ? r.Session.Game.QuestionTopic.Title : ""),
                r.DurationMs,
                r.TotalItems,
                r.CorrectItems,
                r.Score,
                r.SharedWithTeacher,
                r.SharedAt,
                r.CreatedAt,
                Items = r.Items
                    .OrderBy(i => i.Ordinal)
                    .Select(i => new ResultItemDto(
                        i.Ordinal, i.Term, i.ExpectedAnswer, i.StudentAnswer, i.IsCorrect))
                    .ToList(),
            })
            .FirstOrDefaultAsync(cancellationToken);

        if (detail is null)
        {
            throw AppException.NotFound("Sonuç bulunamadı.");
        }

        return new MyResultDetailDto(
            detail.Id,
            detail.GameId,
            detail.GameType,
            detail.LessonId,
            detail.LessonTitle,
            detail.DurationMs,
            detail.TotalItems,
            detail.CorrectItems,
            detail.Score,
            detail.SharedWithTeacher,
            detail.SharedAt,
            detail.CreatedAt,
            detail.Items);
    }

    public async Task<StudentStatsDto> GetMyStatsAsync(CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        // Tamamlanmış sonuçlar = öğrencinin oturumlarına bağlı game_results kayıtları.
        var scores = await _db.GameResults
            .Where(r => r.Session.StudentId == studentId)
            .Select(r => r.Score)
            .ToListAsync(cancellationToken);

        if (scores.Count == 0)
        {
            return new StudentStatsDto(0, 0);
        }

        var average = (int)Math.Round(scores.Average(), MidpointRounding.AwayFromZero);
        return new StudentStatsDto(scores.Count, average);
    }

    /// <summary>Sabit haftalık çalışma hedefi (dakika). İleride kullanıcı-ayarına taşınabilir.</summary>
    public const int WeeklyGoalMinutes = 150;

    public async Task<StudentProgressDto> GetMyProgressAsync(CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        // Öğrencinin tüm tamamlanmış sonuçlarından yalnızca gerekli iki alanı çekeriz (skor + süre +
        // oluşturulma anı). Öğrenci başına sonuç sayısı küçük olduğundan client-eval güvenli;
        // ardışık gün (streak) mantığı zaten EF'de çevrilemez, bu yüzden listeyi belleğe alırız.
        var rows = await _db.GameResults
            .Where(r => r.Session.StudentId == studentId)
            .Select(r => new { r.Score, r.DurationMs, r.CreatedAt })
            .ToListAsync(cancellationToken);

        if (rows.Count == 0)
        {
            return new StudentProgressDto(0, 0, null, 0, WeeklyGoalMinutes, 0);
        }

        var gamesPlayed = rows.Count;
        var averageAccuracy = (int)Math.Round(rows.Average(r => r.Score), MidpointRounding.AwayFromZero);

        // Tüm pencere hesapları tek bir referans "şimdi" (UTC) üzerinden yapılır.
        var now = DateTime.UtcNow;
        var last7Start = now.AddDays(-7);
        var prev7Start = now.AddDays(-14);

        // Haftalık dakika: son 7 gündeki sonuçların toplam süresi / 60000 (aşağı yuvarla). long ile
        // taşma önlenir (çok sayıda uzun oturum toplamı int'i aşabilir).
        var weeklyDurationMs = rows
            .Where(r => r.CreatedAt >= last7Start)
            .Sum(r => (long)r.DurationMs);
        var weeklyMinutes = (int)(weeklyDurationMs / 60000);

        // Doğruluk trendi: son 7 gün ort. − önceki 7 gün (14..7) ort. Önceki pencerede sonuç yoksa null.
        var last7Scores = rows.Where(r => r.CreatedAt >= last7Start).Select(r => r.Score).ToList();
        var prev7Scores = rows.Where(r => r.CreatedAt >= prev7Start && r.CreatedAt < last7Start)
            .Select(r => r.Score).ToList();

        int? accuracyTrendDelta = prev7Scores.Count == 0
            ? null
            : (int)Math.Round(
                (last7Scores.Count == 0 ? 0 : last7Scores.Average()) - prev7Scores.Average(),
                MidpointRounding.AwayFromZero);

        var streakDays = CalculateStreakDays(rows.Select(r => r.CreatedAt), now);

        return new StudentProgressDto(
            gamesPlayed, averageAccuracy, accuracyTrendDelta, weeklyMinutes, WeeklyGoalMinutes, streakDays);
    }

    /// <summary>
    /// Sonuç tarihlerinin UTC gün kümesinden ardışık seri uzunluğunu hesaplar. Bugün (UTC) sonuç
    /// varsa bugünden, yoksa dünden başlanır; geriye doğru ardışık günler sayılır, ilk boşlukta durur.
    /// Hiç gün yoksa 0. Bugünden eskiye bir boşlukla başlanan seriler (ör. yalnız 3 gün önce) 0 sayılır.
    /// </summary>
    private static int CalculateStreakDays(IEnumerable<DateTime> createdAtUtc, DateTime nowUtc)
    {
        var days = createdAtUtc.Select(d => d.Date).ToHashSet();
        if (days.Count == 0)
        {
            return 0;
        }

        var today = nowUtc.Date;

        // Seri ya bugünden ya da (bugün boşsa) dünden başlar; ikisi de boşsa seri yok.
        DateTime cursor;
        if (days.Contains(today))
        {
            cursor = today;
        }
        else if (days.Contains(today.AddDays(-1)))
        {
            cursor = today.AddDays(-1);
        }
        else
        {
            return 0;
        }

        var streak = 0;
        while (days.Contains(cursor))
        {
            streak++;
            cursor = cursor.AddDays(-1);
        }

        return streak;
    }

    private async Task<GameResultDto> ToDtoAsync(GameResult result, CancellationToken cancellationToken)
    {
        // Submit/Share dönüşünde ders/oyun özetini doldurmak için oturum→oyun→ders zincirini çek.
        var summary = await _db.GameSessions
            .Where(s => s.Id == result.SessionId)
            .Select(s => new
            {
                s.GameId,
                GameType = s.Game.Type,
                LessonId = s.Game.LessonId,
                // QuestionSet oyununda (Lesson null) başlık konu başlığından gelir.
                LessonTitle = s.Game.Lesson != null
                    ? s.Game.Lesson.Title
                    : (s.Game.QuestionTopic != null ? s.Game.QuestionTopic.Title : ""),
            })
            .FirstAsync(cancellationToken);

        return ToDto(result, summary.GameId, summary.GameType, summary.LessonId, summary.LessonTitle);
    }

    private static GameResultDto ToDto(
        GameResult r, Guid gameId, GameType gameType, Guid? lessonId, string lessonTitle)
        => new(
            r.Id,
            r.SessionId,
            gameId,
            gameType,
            lessonId,
            lessonTitle,
            r.DurationMs,
            r.TotalItems,
            r.CorrectItems,
            r.Score,
            r.SharedWithTeacher,
            r.SharedAt,
            r.CreatedAt);

    private Guid RequireStudent()
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        if (_currentUser.Role != UserRole.Student)
        {
            throw new AppException(403, "Bu işlem için öğrenci yetkisi gerekir.");
        }

        return userId;
    }
}
