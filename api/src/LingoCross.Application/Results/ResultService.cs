using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Results.Dtos;
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

    public ResultService(IAppDbContext db, ICurrentUser currentUser)
    {
        _db = db;
        _currentUser = currentUser;
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

        if (request.DurationMs < 0 || request.TotalItems < 0 || request.CorrectItems < 0
            || request.CorrectItems > request.TotalItems)
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
            TotalItems = request.TotalItems,
            CorrectItems = request.CorrectItems,
            Score = CalculateScore(request.TotalItems, request.CorrectItems),
            SharedWithTeacher = false,
        };
        _db.GameResults.Add(result);

        session.Status = GameSessionStatus.Completed;
        session.CompletedAt = DateTime.UtcNow;

        await _db.SaveChangesAsync(cancellationToken);

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
        }

        return await ToDtoAsync(result, cancellationToken);
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
                LessonTitle = r.Session.Game.Lesson.Title,
            })
            .ToListAsync(cancellationToken);

        return rows
            .Select(x => ToDto(x.Result, x.GameId, x.GameType, x.LessonId, x.LessonTitle))
            .ToList();
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
                LessonTitle = s.Game.Lesson.Title,
            })
            .FirstAsync(cancellationToken);

        return ToDto(result, summary.GameId, summary.GameType, summary.LessonId, summary.LessonTitle);
    }

    private static GameResultDto ToDto(
        GameResult r, Guid gameId, GameType gameType, Guid lessonId, string lessonTitle)
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
