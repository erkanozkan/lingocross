using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Games;
using LingoCross.Application.Games.Dtos;
using LingoCross.Application.QuestionBanks.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.QuestionBanks;

/// <summary>
/// Faz 2 — konu başlıklarının öğretmen tarafından listelenmesi ve sınıflara atanması. Sorular GLOBAL'dir;
/// öğretmen bir başlığı sınıf(lar)ına atar. Her başlık+QuestionSet için idempotent tek bir <c>Game</c>
/// kaydı tutulur; sınıf ataması <see cref="IGameService.ApplyAssignmentsForGameAsync"/> ile (set semantiği)
/// uygulanır. Erişim/sahiplik bu katmanda: yalnız öğretmen; yalnız kendi sınıfları.
/// </summary>
public class QuestionBankService : IQuestionBankService
{
    private readonly IAppDbContext _db;
    private readonly ICurrentUser _currentUser;
    private readonly IGameService _gameService;

    public QuestionBankService(IAppDbContext db, ICurrentUser currentUser, IGameService gameService)
    {
        _db = db;
        _currentUser = currentUser;
        _gameService = gameService;
    }

    public async Task<IReadOnlyList<QuestionTopicSummaryDto>> ListTopicsAsync(CancellationToken cancellationToken = default)
    {
        RequireTeacher();

        return await _db.QuestionTopics
            .Where(t => t.IsActive)
            .OrderBy(t => t.SortOrder)
            .ThenBy(t => t.Title)
            .Select(t => new QuestionTopicSummaryDto(
                t.Id,
                t.Title,
                t.Description,
                t.Questions.Count))
            .ToListAsync(cancellationToken);
    }

    public async Task<GameAssignmentsDto> SetTopicAssignmentsAsync(
        Guid topicId, IReadOnlyList<Guid> classIds, CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        // Yalnız aktif (atanabilir) başlık; aksi 404 (varlığı sızdırmamak için).
        var topic = await _db.QuestionTopics
            .FirstOrDefaultAsync(t => t.Id == topicId && t.IsActive, cancellationToken);

        if (topic is null)
        {
            throw AppException.NotFound("Konu başlığı bulunamadı.");
        }

        // İdempotent upsert: başlık başına tek QuestionSet oyunu. Yoksa oluştur (yayımlı), varsa kullan.
        var game = await _db.Games
            .FirstOrDefaultAsync(g => g.QuestionTopicId == topicId && g.Type == GameType.QuestionSet, cancellationToken);

        if (game is null)
        {
            game = new Game
            {
                LessonId = null,
                QuestionTopicId = topicId,
                Type = GameType.QuestionSet,
                Title = topic.Title,
                IsPublished = true,
                PublishedAt = DateTime.UtcNow,
            };
            _db.Games.Add(game);
            await _db.SaveChangesAsync(cancellationToken);
        }
        else if (!game.IsPublished)
        {
            game.IsPublished = true;
            game.PublishedAt ??= DateTime.UtcNow;
            await _db.SaveChangesAsync(cancellationToken);
        }

        // Sınıf ataması set semantiğiyle (mevcut GameService mantığı yeniden kullanılır).
        var finalClassIds = await _gameService.ApplyAssignmentsForGameAsync(
            game, teacherId, classIds, cancellationToken);

        return new GameAssignmentsDto(finalClassIds);
    }

    public async Task<GameAssignmentsDto> GetTopicAssignmentsAsync(Guid topicId, CancellationToken cancellationToken = default)
    {
        RequireTeacher();

        var topicExists = await _db.QuestionTopics.AnyAsync(t => t.Id == topicId, cancellationToken);
        if (!topicExists)
        {
            throw AppException.NotFound("Konu başlığı bulunamadı.");
        }

        // Bu başlığın QuestionSet oyunu yoksa henüz hiç atama yapılmamıştır → boş liste.
        var gameId = await _db.Games
            .Where(g => g.QuestionTopicId == topicId && g.Type == GameType.QuestionSet)
            .Select(g => (Guid?)g.Id)
            .FirstOrDefaultAsync(cancellationToken);

        if (gameId is null)
        {
            return new GameAssignmentsDto([]);
        }

        var classIds = await _db.GameAssignments
            .Where(a => a.GameId == gameId.Value)
            .Select(a => a.ClassId)
            .ToListAsync(cancellationToken);

        return new GameAssignmentsDto(classIds);
    }

    private Guid RequireTeacher()
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        if (_currentUser.Role != UserRole.Teacher)
        {
            throw new AppException(403, "Bu işlem için öğretmen yetkisi gerekir.");
        }

        return userId;
    }
}
