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

    public async Task<GameDto> CreateForLessonAsync(Guid lessonId, CreateGameRequest request, CancellationToken cancellationToken = default)
    {
        // Yalnızca ders sahibi öğretmen oluşturabilir.
        var lesson = await GetOwnedLessonAsync(lessonId, cancellationToken);

        // MVP/F2.2: yalnız WordMatching desteklenir. Crossword (F2.4) rezerve.
        if (request.Type == GameType.Crossword)
        {
            throw AppException.BadRequest("Bulmaca (crossword) oyunu henüz desteklenmiyor.");
        }

        if (request.Type != GameType.WordMatching)
        {
            throw AppException.BadRequest("Geçersiz oyun türü.");
        }

        // Oynanabilirlik: ders en az MinWordsToPlay çevirili kelime içermeli (StartSession ile aynı kural).
        var eligibleCount = await CountTranslatedWordsAsync(lesson.Id, cancellationToken);
        if (eligibleCount < MinWordsToPlay)
        {
            throw AppException.BadRequest(
                $"Bu ders için oyun oluşturulamıyor; en az {MinWordsToPlay} çevirili kelime gerekir.");
        }

        var now = DateTime.UtcNow;

        // Idempotent: aynı ders+tür için oyun zaten varsa onu (gerekirse yeniden) yayımla.
        var game = await _db.Games
            .FirstOrDefaultAsync(g => g.LessonId == lesson.Id && g.Type == request.Type, cancellationToken);

        if (game is null)
        {
            game = new Game
            {
                LessonId = lesson.Id,
                Type = request.Type,
                Title = NormalizeTitle(request.Title) ?? DefaultTitle(request.Type),
                IsPublished = true,
                PublishedAt = now,
            };
            _db.Games.Add(game);
        }
        else
        {
            if (!string.IsNullOrWhiteSpace(request.Title))
            {
                game.Title = NormalizeTitle(request.Title)!;
            }

            game.IsPublished = true;
            game.PublishedAt ??= now;
        }

        await _db.SaveChangesAsync(cancellationToken);
        return ToDto(game);
    }

    public async Task<IReadOnlyList<GameDto>> ListForLessonAsync(Guid lessonId, CancellationToken cancellationToken = default)
    {
        // Salt-okunur: yalnız ders sahibi öğretmen. Otomatik üretim YOK.
        var lesson = await GetOwnedLessonAsync(lessonId, cancellationToken);

        var games = await _db.Games
            .Where(g => g.LessonId == lesson.Id)
            .OrderBy(g => g.CreatedAt)
            .ToListAsync(cancellationToken);

        return games.Select(ToDto).ToList();
    }

    public async Task<IReadOnlyList<AssignedGameDto>> ListAssignedForStudentAsync(CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        // Öğrencinin Active eşleşmeli öğretmenlerinin yayımlanmış derslerindeki yayımlanmış oyunlar.
        var assigned = await _db.Games
            .Where(g => g.IsPublished
                && g.Lesson.IsPublished
                && _db.Enrollments.Any(e =>
                    e.StudentId == studentId
                    && e.TeacherId == g.Lesson.TeacherId
                    && e.Status == EnrollmentStatus.Active))
            .OrderByDescending(g => g.PublishedAt)
            .Select(g => new AssignedGameDto(
                g.Id,
                g.LessonId,
                g.Lesson.Title,
                g.Type,
                g.Title,
                g.Lesson.Words.Count,
                g.Lesson.Teacher.DisplayName,
                g.PublishedAt))
            .ToListAsync(cancellationToken);

        return assigned;
    }

    public async Task<StartGameSessionResponse> StartSessionAsync(Guid gameId, CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        var game = await _db.Games.FirstOrDefaultAsync(g => g.Id == gameId, cancellationToken);
        // Yayımlanmamış oyunun varlığını sızdırmamak için 404 (erişim öncesi).
        if (game is null || !game.IsPublished)
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

    /// <summary>
    /// Dersi getirir ve sahiplik kontrolü yapar (yalnız öğretmen). Başkasının dersi de dahil
    /// bulunamayan her durumda 404 (varlığı sızdırmamak için).
    /// </summary>
    private async Task<Lesson> GetOwnedLessonAsync(Guid lessonId, CancellationToken cancellationToken)
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        if (_currentUser.Role != UserRole.Teacher)
        {
            throw new AppException(403, "Bu işlem için öğretmen yetkisi gerekir.");
        }

        var lesson = await _db.Lessons.FirstOrDefaultAsync(l => l.Id == lessonId, cancellationToken);
        if (lesson is null || lesson.TeacherId != userId)
        {
            throw AppException.NotFound("Ders bulunamadı.");
        }

        return lesson;
    }

    /// <summary>Dersin oynanabilir (birincil/ilk çevirisi dolu) kelime sayısı.</summary>
    private async Task<int> CountTranslatedWordsAsync(Guid lessonId, CancellationToken cancellationToken)
    {
        return await _db.Words
            .Where(w => w.LessonId == lessonId
                && w.Translations.Any(t => t.Text != null && t.Text.Trim() != ""))
            .CountAsync(cancellationToken);
    }

    private static string? NormalizeTitle(string? title)
        => string.IsNullOrWhiteSpace(title) ? null : title.Trim();

    private static string DefaultTitle(GameType type) => type switch
    {
        GameType.WordMatching => "Kelime Eşleştirme",
        GameType.Crossword => "Bulmaca",
        _ => "Oyun",
    };

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
        => new(g.Id, g.LessonId, g.Type, g.Title, g.IsPublished, g.PublishedAt, g.CreatedAt, g.UpdatedAt);

    private static GameSessionDto ToDto(GameSession s)
        => new(s.Id, s.GameId, s.StudentId, s.Status, s.StartedAt, s.CompletedAt);
}
