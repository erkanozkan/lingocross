using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Games.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Games;

public class GameService : IGameService
{
    /// <summary>Bir eşleştirme oyununda yer alacak en fazla kelime (çift) sayısı.</summary>
    public const int MaxPairs = 8;

    /// <summary>Oyunun oynanabilmesi için gereken en az çevirili kelime sayısı.</summary>
    public const int MinWordsToPlay = 4;

    /// <summary>Üretilecek en fazla çeldirici (fazladan Türkçe karşılık) sayısı.</summary>
    public const int MaxDistractors = 4;

    private readonly IAppDbContext _db;
    private readonly ICurrentUser _currentUser;
    private readonly Random _random;

    public GameService(IAppDbContext db, ICurrentUser currentUser, Random? random = null)
    {
        _db = db;
        _currentUser = currentUser;
        // Determinizm: testler tohumlanmış bir Random enjekte edebilir.
        _random = random ?? Random.Shared;
    }

    public async Task<IReadOnlyList<GameDto>> ListOrCreateForLessonAsync(Guid lessonId, CancellationToken cancellationToken = default)
    {
        var lesson = await GetAccessibleLessonAsync(lessonId, cancellationToken);

        var games = await _db.Games
            .Where(g => g.LessonId == lesson.Id)
            .OrderBy(g => g.CreatedAt)
            .ToListAsync(cancellationToken);

        // Yalnızca öğretmen (ders sahibi) eksik oyunu üretebilir; öğrenci salt-okunur listeler.
        var hasWordMatching = games.Any(g => g.Type == GameType.WordMatching);
        if (!hasWordMatching && _currentUser.Role == UserRole.Teacher)
        {
            var game = new Game
            {
                LessonId = lesson.Id,
                Type = GameType.WordMatching,
                Title = "Kelime Eşleştirme",
            };
            _db.Games.Add(game);
            await _db.SaveChangesAsync(cancellationToken);
            games.Add(game);
        }

        return games.Select(ToDto).ToList();
    }

    public async Task<StartGameSessionResponse> StartSessionAsync(Guid gameId, CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        var game = await _db.Games.FirstOrDefaultAsync(g => g.Id == gameId, cancellationToken);
        if (game is null)
        {
            throw AppException.NotFound("Oyun bulunamadı.");
        }

        // Ders erişimi (enrolled + published) doğrula; aksi 404.
        await GetAccessibleLessonAsync(game.LessonId, cancellationToken);

        var content = await BuildWordMatchingContentAsync(game.LessonId, cancellationToken);

        var session = new GameSession
        {
            GameId = game.Id,
            StudentId = studentId,
            Status = GameSessionStatus.InProgress,
            StartedAt = DateTime.UtcNow,
        };
        _db.GameSessions.Add(session);
        await _db.SaveChangesAsync(cancellationToken);

        return new StartGameSessionResponse(ToDto(session), content);
    }

    public async Task<GameSessionDto> GetSessionAsync(Guid sessionId, CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        var session = await _db.GameSessions.FirstOrDefaultAsync(s => s.Id == sessionId, cancellationToken);
        // Varlığı sızdırmamak için sahibi olmayan her durumda 404.
        if (session is null || session.StudentId != studentId)
        {
            throw AppException.NotFound("Oyun oturumu bulunamadı.");
        }

        return ToDto(session);
    }

    /// <summary>
    /// Dersin kelimelerinden eşleştirme içeriği üretir: en çok <see cref="MaxPairs"/> çift + en çok
    /// <see cref="MaxDistractors"/> benzersiz çeldirici. Yeterli çevirili kelime yoksa AppException(400).
    /// </summary>
    private async Task<WordMatchingContent> BuildWordMatchingContentAsync(Guid lessonId, CancellationToken cancellationToken)
    {
        var words = await _db.Words
            .Where(w => w.LessonId == lessonId)
            .Include(w => w.Translations)
            .OrderBy(w => w.SortOrder)
            .ThenBy(w => w.CreatedAt)
            .ToListAsync(cancellationToken);

        // Birincil çevirisi (yoksa ilk çevirisi) olan kelimeler oynanabilir adaylardır.
        var eligible = words
            .Select(w => new
            {
                Word = w,
                Translation = PrimaryTranslation(w),
            })
            .Where(x => x.Translation is not null)
            .ToList();

        if (eligible.Count < MinWordsToPlay)
        {
            throw AppException.BadRequest(
                $"Bu ders için eşleştirme oyunu oynatılamıyor; en az {MinWordsToPlay} çevirili kelime gerekir.");
        }

        // Oyuna girecek çiftleri seç (deterministik karıştırma sonrası ilk N).
        var shuffled = Shuffle(eligible);
        var chosen = shuffled.Take(MaxPairs).ToList();

        var pairs = chosen
            .Select(x => new MatchingPair(x.Word.Id, x.Word.Term, x.Translation!))
            .ToList();

        // Çeldiriciler: çifte girmeyen kelimelerin çevirilerinden, doğru cevaplarla çakışmayan,
        // benzersiz Türkçe karşılıklar.
        var correctSet = pairs
            .Select(p => p.CorrectTranslation)
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        var distractors = new List<string>();
        var seen = new HashSet<string>(correctSet, StringComparer.OrdinalIgnoreCase);

        // Önce çifte girmeyen kelimelerin tüm çevirilerini çeldirici havuzu yap.
        var chosenWordIds = chosen.Select(x => x.Word.Id).ToHashSet();
        var pool = words
            .Where(w => !chosenWordIds.Contains(w.Id))
            .SelectMany(w => w.Translations.Select(t => t.Text))
            .ToList();

        foreach (var candidate in Shuffle(pool))
        {
            if (distractors.Count >= MaxDistractors)
            {
                break;
            }

            if (!string.IsNullOrWhiteSpace(candidate) && seen.Add(candidate.Trim()))
            {
                distractors.Add(candidate.Trim());
            }
        }

        return new WordMatchingContent(pairs, distractors);
    }

    private static string? PrimaryTranslation(Word word)
    {
        var primary = word.Translations.FirstOrDefault(t => t.IsPrimary)
            ?? word.Translations.FirstOrDefault();
        return string.IsNullOrWhiteSpace(primary?.Text) ? null : primary!.Text.Trim();
    }

    /// <summary>
    /// Rol-duyarlı okuma erişimi (LessonService.GetAccessibleLessonAsync ile aynı kural): öğretmen
    /// kendi dersine, öğrenci yalnız Active eşleşmesi olan öğretmenin yayımlanmış dersine erişebilir.
    /// Aksi her durumda 404 (varlığı sızdırmamak için).
    /// </summary>
    private async Task<Lesson> GetAccessibleLessonAsync(Guid lessonId, CancellationToken cancellationToken)
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        var lesson = await _db.Lessons.FirstOrDefaultAsync(l => l.Id == lessonId, cancellationToken);
        if (lesson is null)
        {
            throw AppException.NotFound("Ders bulunamadı.");
        }

        if (_currentUser.Role == UserRole.Teacher)
        {
            if (lesson.TeacherId != userId)
            {
                throw AppException.NotFound("Ders bulunamadı.");
            }

            return lesson;
        }

        var hasAccess = lesson.IsPublished && await _db.Enrollments.AnyAsync(
            e => e.StudentId == userId
                && e.TeacherId == lesson.TeacherId
                && e.Status == EnrollmentStatus.Active,
            cancellationToken);

        if (!hasAccess)
        {
            throw AppException.NotFound("Ders bulunamadı.");
        }

        return lesson;
    }

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

    private List<T> Shuffle<T>(IReadOnlyList<T> source)
    {
        // Fisher–Yates; enjekte edilen Random ile testlerde deterministik.
        var list = source.ToList();
        for (var i = list.Count - 1; i > 0; i--)
        {
            var j = _random.Next(i + 1);
            (list[i], list[j]) = (list[j], list[i]);
        }

        return list;
    }

    private static GameDto ToDto(Game g)
        => new(g.Id, g.LessonId, g.Type, g.Title, g.CreatedAt, g.UpdatedAt);

    private static GameSessionDto ToDto(GameSession s)
        => new(s.Id, s.GameId, s.StudentId, s.Status, s.StartedAt, s.CompletedAt);
}
