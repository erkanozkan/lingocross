using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Games.Dtos;
using LingoCross.Application.Notifications;
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
    private readonly PushDispatcher? _push;

    public GameService(IAppDbContext db, ICurrentUser currentUser, Random? random = null, PushDispatcher? push = null)
    {
        _db = db;
        _currentUser = currentUser;
        // Determinizm: testler tohumlanmış bir Random enjekte edebilir.
        _random = random ?? Random.Shared;
        // Push opsiyonel: enjekte edilmezse tetikler atlanır (testler için no-op).
        _push = push;
    }

    public async Task<GameDto> CreateForLessonAsync(Guid lessonId, CreateGameRequest request, CancellationToken cancellationToken = default)
    {
        // Yalnızca ders sahibi öğretmen oluşturabilir.
        var lesson = await GetOwnedLessonAsync(lessonId, cancellationToken);

        // F2.4: WordMatching ve Crossword desteklenir. QuestionSet hâlâ rezerve.
        switch (request.Type)
        {
            case GameType.WordMatching:
                // Oynanabilirlik: ders en az MinWordsToPlay çevirili kelime içermeli (StartSession ile aynı kural).
                var translatedCount = await CountTranslatedWordsAsync(lesson.Id, cancellationToken);
                if (translatedCount < MinWordsToPlay)
                {
                    throw AppException.BadRequest(
                        $"Bu ders için oyun oluşturulamıyor; en az {MinWordsToPlay} çevirili kelime gerekir.");
                }

                break;

            case GameType.Scrambled:
                // Oynanabilirlik: ders en az MinWordsToPlay scrambled-uygun (tek kelime, ≥2 harf, çevirili) kelime içermeli.
                var scrambledEligible = await CountScrambledEligibleWordsAsync(lesson.Id, cancellationToken);
                if (scrambledEligible < MinWordsToPlay)
                {
                    throw AppException.BadRequest(
                        $"Bu ders için oyun oluşturulamıyor; en az {MinWordsToPlay} uygun (tek kelimeli, çevirili) kelime gerekir.");
                }

                break;

            case GameType.Crossword:
                // Crossword için: terim İngilizce (yalnız A–Z, ≥2 harf) VE birincil/ilk çevirisi (ipucu) dolu olmalı.
                var crosswordEligible = await CountCrosswordEligibleWordsAsync(lesson.Id, cancellationToken);
                if (crosswordEligible < CrosswordGenerator.MinEligibleWords)
                {
                    throw AppException.BadRequest(
                        $"Bu ders için bulmaca oluşturulamıyor; en az {CrosswordGenerator.MinEligibleWords} " +
                        "bulmaca-uygun (yalnız İngilizce A–Z harfli, çevirili) kelime gerekir.");
                }

                break;

            default:
                throw AppException.BadRequest("Geçersiz oyun türü.");
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

        // F4.3: classIds verilirse oyun oluşturma ile aynı akışta sınıflara atanır (set semantiği).
        if (request.ClassIds is not null)
        {
            await ApplyAssignmentsAsync(game, lesson.TeacherId, request.ClassIds, cancellationToken);
        }

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

    public async Task<IReadOnlyList<TeacherPuzzleDto>> ListMyPuzzlesAsync(CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        // Yalnız öğretmenin sahip olduğu derslerdeki bulmacalar; yeniden → eskiye.
        var puzzles = await _db.Games
            .Where(g => g.Lesson.TeacherId == teacherId)
            .OrderByDescending(g => g.CreatedAt)
            .Select(g => new
            {
                g.Id,
                g.LessonId,
                LessonTitle = g.Lesson.Title,
                g.Type,
                g.IsPublished,
                g.CreatedAt,
                // F4.3: atanan öğrenci sayısı = oyunun atandığı (arşivlenmemiş) sınıfların DISTINCT
                // Active üye sayısı. Bir öğrenci birden çok atanmış sınıfta üyeyse bir kez sayılır.
                AssignedStudentCount = _db.ClassMembers
                    .Where(m => m.Status == ClassMemberStatus.Active
                        && !m.Class.IsArchived
                        && _db.GameAssignments.Any(a => a.GameId == g.Id && a.ClassId == m.ClassId))
                    .Select(m => m.StudentId)
                    .Distinct()
                    .Count(),
                // Tamamlanmış sonuç sayısı: bu oyuna ait oturumların sonuçları.
                SolveCount = _db.GameResults.Count(r => r.Session.GameId == g.Id),
            })
            .ToListAsync(cancellationToken);

        return puzzles
            .Select(p => new TeacherPuzzleDto(
                p.Id,
                p.LessonId,
                p.LessonTitle,
                p.Type,
                p.IsPublished,
                p.CreatedAt,
                // Atanmış sayılan öğrenci sayısı yalnız yayımlanmış bulmaca için anlamlı.
                p.IsPublished ? p.AssignedStudentCount : 0,
                p.SolveCount))
            .ToList();
    }

    public async Task<GameDto> ShareAsync(Guid gameId, CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        // Sahiplik servis katmanında: oyun + dersi tek sorguda al, sahibi değilse 404.
        var game = await _db.Games
            .FirstOrDefaultAsync(g => g.Id == gameId && g.Lesson.TeacherId == teacherId, cancellationToken);

        if (game is null)
        {
            throw AppException.NotFound("Oyun bulunamadı.");
        }

        // İdempotent yeniden-yayınla: her zaman yayımlı yap, zamanı güncelle.
        game.IsPublished = true;
        game.PublishedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync(cancellationToken);

        return ToDto(game);
    }

    public async Task<IReadOnlyList<AssignedGameDto>> ListAssignedForStudentAsync(CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        // F4.3: öğrencinin üye olduğu (arşivlenmemiş) sınıflara atanmış, yayımlanmış oyunlar
        // (ders de yayımlanmış olmalı). Görünürlük sınıf üyeliğinden türetilir.
        var assigned = await _db.Games
            .Where(g => g.IsPublished
                && g.Lesson.IsPublished
                && _db.GameAssignments.Any(a => a.GameId == g.Id
                    && !a.Class.IsArchived
                    && _db.ClassMembers.Any(m => m.ClassId == a.ClassId
                        && m.StudentId == studentId
                        && m.Status == ClassMemberStatus.Active)))
            .OrderByDescending(g => g.PublishedAt)
            .Select(g => new
            {
                g.Id,
                g.LessonId,
                LessonTitle = g.Lesson.Title,
                g.Type,
                g.Title,
                WordCount = g.Lesson.Words.Count,
                TeacherName = g.Lesson.Teacher.DisplayName,
                g.PublishedAt,
                // Bu öğrencinin bu oyuna ait (varsa) en güncel tamamlanmış sonucu (oturum→sonuç).
                // Aynı oyuna birden çok oturum oluşabilir (yarım kalan vb.); sonucu olan en yeni alınır.
                Result = _db.GameResults
                    .Where(r => r.Session.GameId == g.Id && r.Session.StudentId == studentId)
                    .OrderByDescending(r => r.CreatedAt)
                    .Select(r => new { r.Id, r.Score, r.CreatedAt })
                    .FirstOrDefault(),
            })
            .ToListAsync(cancellationToken);

        return assigned
            .Select(g => new AssignedGameDto(
                g.Id,
                g.LessonId,
                g.LessonTitle,
                g.Type,
                g.Title,
                g.WordCount,
                g.TeacherName,
                g.PublishedAt,
                g.Result is not null,
                g.Result?.Id,
                g.Result?.Score,
                g.Result?.CreatedAt))
            .ToList();
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

        // Tek seferlik oynanır: öğrencinin bu oyuna ait TAMAMLANMIŞ (sonuçlu) bir oturumu varsa
        // yeniden başlatılamaz (409). Yarım kalmış (sonuçsuz) InProgress oturum engel değildir;
        // öğrenci yeniden başlayabilir.
        var alreadyCompleted = await _db.GameResults
            .AnyAsync(r => r.Session.GameId == gameId && r.Session.StudentId == studentId, cancellationToken);
        if (alreadyCompleted)
        {
            throw AppException.Conflict("Bu bulmacayı zaten tamamladın.");
        }

        // İçerik tür-duyarlı üretilir. Yeterli/uygun kelime yoksa içerik üreticisi 400 atar ve
        // (SaveChanges'tan önce olduğu için) oturum oluşturulmaz.
        WordMatchingContent? wordMatching = null;
        CrosswordContent? crossword = null;
        ScrambledContent? scrambled = null;

        switch (game.Type)
        {
            case GameType.WordMatching:
                wordMatching = await BuildWordMatchingContentAsync(game.LessonId, cancellationToken);
                break;

            case GameType.Crossword:
                crossword = await BuildCrosswordContentAsync(game.LessonId, cancellationToken);
                break;

            case GameType.Scrambled:
                scrambled = await BuildScrambledContentAsync(game.LessonId, cancellationToken);
                break;

            default:
                throw AppException.BadRequest("Bu oyun türü oynatılamıyor.");
        }

        var session = new GameSession
        {
            GameId = game.Id,
            StudentId = studentId,
            Status = GameSessionStatus.InProgress,
            StartedAt = DateTime.UtcNow,
        };
        _db.GameSessions.Add(session);
        await _db.SaveChangesAsync(cancellationToken);

        return new StartGameSessionResponse(ToDto(session), game.Type, wordMatching, crossword, scrambled);
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

    public async Task<GameAssignmentsDto> SetAssignmentsAsync(Guid gameId, SetGameAssignmentsRequest request, CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        // Sahiplik: oyun + dersi tek sorguda; ders sahibi değilse 404.
        var game = await _db.Games
            .FirstOrDefaultAsync(g => g.Id == gameId && g.Lesson.TeacherId == teacherId, cancellationToken);

        if (game is null)
        {
            throw AppException.NotFound("Oyun bulunamadı.");
        }

        var classIds = await ApplyAssignmentsAsync(game, teacherId, request.ClassIds ?? [], cancellationToken);
        return new GameAssignmentsDto(classIds);
    }

    public async Task<GameAssignmentsDto> GetAssignmentsAsync(Guid gameId, CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        var owns = await _db.Games
            .AnyAsync(g => g.Id == gameId && g.Lesson.TeacherId == teacherId, cancellationToken);

        if (!owns)
        {
            throw AppException.NotFound("Oyun bulunamadı.");
        }

        var classIds = await _db.GameAssignments
            .Where(a => a.GameId == gameId)
            .Select(a => a.ClassId)
            .ToListAsync(cancellationToken);

        return new GameAssignmentsDto(classIds);
    }

    public async Task<GamePreviewResponse> PreviewForLessonAsync(Guid lessonId, GameType type, CancellationToken cancellationToken = default)
    {
        // Sahiplik: CreateForLesson ile birebir aynı (yalnız ders sahibi öğretmen; aksi 404/403).
        var lesson = await GetOwnedLessonAsync(lessonId, cancellationToken);

        // İçerik tür-duyarlı üretilir; içerik üreticileri StartSession/CreateForLesson ile AYNI
        // yeterlilik kurallarını uygular (yetersiz/uygunsuz kelime → AppException(400), aynı mesajlar).
        // HİÇBİR ŞEY KAYDEDİLMEZ: yalnız okuma + bellek içi üretim, SaveChanges yok.
        WordMatchingContent? wordMatching = null;
        CrosswordContent? crossword = null;
        ScrambledContent? scrambled = null;

        switch (type)
        {
            case GameType.WordMatching:
                wordMatching = await BuildWordMatchingContentAsync(lesson.Id, cancellationToken);
                break;

            case GameType.Crossword:
                crossword = await BuildCrosswordContentAsync(lesson.Id, cancellationToken);
                break;

            case GameType.Scrambled:
                scrambled = await BuildScrambledContentAsync(lesson.Id, cancellationToken);
                break;

            default:
                throw AppException.BadRequest("Geçersiz oyun türü.");
        }

        return new GamePreviewResponse(type, wordMatching, crossword, scrambled);
    }

    /// <summary>
    /// SET semantiğiyle oyunun atamalarını uygular: yalnız öğretmenin kendi (arşivlenmemiş) sınıfları
    /// kabul edilir; verilen listede olmayan mevcut atamalar silinir, yeni olanlar eklenir. Verilen bir
    /// classId öğretmene ait değilse 404. Nihai atanmış sınıf kimliklerini döndürür.
    /// </summary>
    private async Task<IReadOnlyList<Guid>> ApplyAssignmentsAsync(
        Game game, Guid teacherId, IReadOnlyList<Guid> requestedClassIds, CancellationToken cancellationToken)
    {
        var desired = requestedClassIds.Distinct().ToList();

        if (desired.Count > 0)
        {
            // Her istenen sınıf öğretmene ait ve arşivlenmemiş olmalı; aksi 404.
            var ownedCount = await _db.Classes
                .CountAsync(c => desired.Contains(c.Id) && c.TeacherId == teacherId && !c.IsArchived, cancellationToken);

            if (ownedCount != desired.Count)
            {
                throw AppException.NotFound("Sınıf bulunamadı.");
            }
        }

        var existing = await _db.GameAssignments
            .Where(a => a.GameId == game.Id)
            .ToListAsync(cancellationToken);

        var existingIds = existing.Select(a => a.ClassId).ToHashSet();
        var desiredSet = desired.ToHashSet();

        // Sil: istenmeyenler.
        var toRemove = existing.Where(a => !desiredSet.Contains(a.ClassId)).ToList();
        if (toRemove.Count > 0)
        {
            _db.GameAssignments.RemoveRange(toRemove);
        }

        // Ekle: yeni olanlar.
        var newlyAdded = desired.Where(id => !existingIds.Contains(id)).ToList();
        foreach (var classId in newlyAdded)
        {
            _db.GameAssignments.Add(new GameAssignment { GameId = game.Id, ClassId = classId });
        }

        // Oto-yayın: ≥1 sınıf atanan oyun her durumda yayımlı olur. Atama listesi boşaltılırsa
        // IsPublished'a dokunmayız (yayımda kalır; geri almıyoruz).
        if (desired.Count > 0)
        {
            game.IsPublished = true;
            game.PublishedAt ??= DateTime.UtcNow;
        }

        await _db.SaveChangesAsync(cancellationToken);

        // Best-effort push: yalnız YENİ eklenen sınıfların aktif öğrencilerine "yeni ödev" bildirimi.
        // İsteği başarısız etmemek için try/catch ile sarılır.
        if (_push is not null && newlyAdded.Count > 0)
        {
            await NotifyAssignedStudentsAsync(game, newlyAdded, cancellationToken);
        }

        return desired;
    }

    /// <summary>
    /// Yeni atanan sınıfların aktif (arşivlenmemiş sınıf) öğrencilerine "yeni ödev" push'u gönderir.
    /// Best-effort: herhangi bir hata yutulur, atama akışını etkilemez.
    /// </summary>
    private async Task NotifyAssignedStudentsAsync(Game game, IReadOnlyList<Guid> newClassIds, CancellationToken cancellationToken)
    {
        try
        {
            var studentIds = await _db.ClassMembers
                .Where(m => newClassIds.Contains(m.ClassId)
                    && m.Status == ClassMemberStatus.Active
                    && !m.Class.IsArchived)
                .Select(m => m.StudentId)
                .Distinct()
                .ToListAsync(cancellationToken);

            if (studentIds.Count == 0)
            {
                return;
            }

            // Ders adını oyunun dersinden al (deep-link/metin için).
            var lessonInfo = await _db.Lessons
                .Where(l => l.Id == game.LessonId)
                .Select(l => new { l.Id, l.Title })
                .FirstOrDefaultAsync(cancellationToken);

            var lessonTitle = lessonInfo?.Title ?? "Ders";
            var data = new Dictionary<string, string>
            {
                ["type"] = "assigned",
                ["lessonId"] = game.LessonId.ToString(),
                ["gameId"] = game.Id.ToString(),
            };

            await _push!.NotifyUsersAsync(
                studentIds,
                PushType.Assigned,
                "Yeni ödev",
                $"{lessonTitle} için yeni bir oyun atandı",
                data,
                cancellationToken);
        }
        catch
        {
            // Bildirim hatası atama işlemini bozmaz.
        }
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

    /// <summary>
    /// Dersin kelimelerinden crossword içeriği üretir. Uygun terimler (yalnız A–Z, ≥2 harf, birincil/ilk
    /// çevirisi dolu) cevap=İngilizce terim (A–Z BÜYÜK), ipucu=birincil Türkçe karşılık olacak şekilde
    /// alınır; greedy kesişim yerleştirmeyle bağlı bir ızgaraya konur. En az
    /// <see cref="CrosswordGenerator.MinEligibleWords"/> kelime yerleştirilemezse AppException(400).
    /// </summary>
    private async Task<CrosswordContent> BuildCrosswordContentAsync(Guid lessonId, CancellationToken cancellationToken)
    {
        var words = await _db.Words
            .Where(w => w.LessonId == lessonId)
            .Include(w => w.Translations)
            .OrderBy(w => w.SortOrder)
            .ThenBy(w => w.CreatedAt)
            .ToListAsync(cancellationToken);

        // Uygun aday: terim crossword-uygun (A–Z, ≥2 harf) VE bir ipucu (birincil/ilk çeviri) var.
        var candidates = words
            .Where(w => CrosswordGenerator.IsEligibleTerm(w.Term))
            .Select(w => new
            {
                Answer = CrosswordGenerator.NormalizeAnswer(w.Term),
                Clue = PrimaryTranslation(w),
            })
            .Where(x => x.Answer.Length >= 2 && x.Clue is not null)
            .Select(x => (x.Answer, Clue: x.Clue!))
            .ToList();

        if (candidates.Count < CrosswordGenerator.MinEligibleWords)
        {
            throw AppException.BadRequest(
                $"Bu ders için bulmaca oynatılamıyor; en az {CrosswordGenerator.MinEligibleWords} " +
                "bulmaca-uygun (yalnız İngilizce A–Z harfli, çevirili) kelime gerekir.");
        }

        var result = CrosswordGenerator.Generate(candidates, _random);
        if (result.PlacedCount < CrosswordGenerator.MinEligibleWords)
        {
            throw AppException.BadRequest(
                "Bu ders için bağlantılı bir bulmaca üretilemedi (yeterli kesişen kelime yok).");
        }

        return result.Content;
    }

    /// <summary>
    /// Dersin kelimelerinden scrambled (harf karıştırma) içeriği üretir: birincil/ilk çevirisi (ipucu) olan
    /// VE scrambled-uygun (tek kelime, ≥2 harf) terimler alınır, deterministik karıştırılır ve en çok
    /// <see cref="MaxPairs"/> tanesi seçilir. Yeterli uygun kelime yoksa AppException(400).
    /// Her item: cevap=terim (olduğu gibi), ipucu=birincil çeviri, karışık=terim harflerinin permütasyonu.
    /// </summary>
    private async Task<ScrambledContent> BuildScrambledContentAsync(Guid lessonId, CancellationToken cancellationToken)
    {
        var words = await _db.Words
            .Where(w => w.LessonId == lessonId)
            .Include(w => w.Translations)
            .OrderBy(w => w.SortOrder)
            .ThenBy(w => w.CreatedAt)
            .ToListAsync(cancellationToken);

        // Uygun aday: terim scrambled-uygun (tek kelime, ≥2 karakter) VE bir ipucu (birincil/ilk çeviri) var.
        var eligible = words
            .Where(w => IsEligibleForScrambled(w.Term))
            .Select(w => new
            {
                Word = w,
                Clue = PrimaryTranslation(w),
            })
            .Where(x => x.Clue is not null)
            .ToList();

        if (eligible.Count < MinWordsToPlay)
        {
            throw AppException.BadRequest(
                $"Bu ders için harf karıştırma oyunu oynatılamıyor; en az {MinWordsToPlay} uygun " +
                "(tek kelimeli, çevirili) kelime gerekir.");
        }

        // Deterministik karıştırma sonrası ilk N kelime.
        var chosen = Shuffle(eligible).Take(MaxPairs).ToList();

        var items = chosen
            .Select(x => new ScrambledItem(
                x.Word.Id,
                x.Word.Term.Trim(),
                ScrambleLetters(x.Word.Term.Trim()),
                x.Clue!))
            .ToList();

        return new ScrambledContent(items);
    }

    /// <summary>
    /// Bir terimin scrambled'a uygun olup olmadığı: trim sonrası boş değil, boşluk/tire İÇERMEZ (tek kelime),
    /// en az 2 karakter. Aksanlı harfler olduğu gibi kalır (A–Z zorunluluğu YOK).
    /// </summary>
    private static bool IsEligibleForScrambled(string term)
    {
        if (string.IsNullOrWhiteSpace(term))
        {
            return false;
        }

        var trimmed = term.Trim();
        if (trimmed.Length < 2)
        {
            return false;
        }

        // Çok-kelimeli / tireli ifadeler elenir (Crossword'ün eleme mantığı; ama A–Z şartı yok).
        foreach (var ch in trimmed)
        {
            if (char.IsWhiteSpace(ch) || ch is '-' or '‐' or '‑' or '‒' or '–' or '—')
            {
                return false;
            }
        }

        return true;
    }

    /// <summary>
    /// Terimin (trim edilmiş) karakterlerini deterministik (_random) karıştırır. Sonuç orijinale eşitse
    /// birkaç kez (5) yeniden dener; hâlâ eşitse (tek/aynı harfli kelime) olduğu gibi bırakır.
    /// </summary>
    private string ScrambleLetters(string term)
    {
        var chars = term.ToCharArray();
        if (chars.Length < 2)
        {
            return term;
        }

        for (var attempt = 0; attempt < 5; attempt++)
        {
            // Fisher–Yates; enjekte edilen Random ile testlerde deterministik.
            for (var i = chars.Length - 1; i > 0; i--)
            {
                var j = _random.Next(i + 1);
                (chars[i], chars[j]) = (chars[j], chars[i]);
            }

            var candidate = new string(chars);
            if (!string.Equals(candidate, term, StringComparison.Ordinal))
            {
                return candidate;
            }
        }

        // Karıştırma orijinalden farklılaştırılamadı (örn. tüm harfler aynı) → son hâli döndür.
        return new string(chars);
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

        // F4.3: öğrenci, derse ait + üye olduğu (arşivlenmemiş) sınıfa atanmış yayımlı bir oyun varsa
        // derse erişebilir.
        var hasAccess = lesson.IsPublished && await _db.Games.AnyAsync(
            g => g.LessonId == lesson.Id
                && g.IsPublished
                && _db.GameAssignments.Any(a => a.GameId == g.Id
                    && !a.Class.IsArchived
                    && _db.ClassMembers.Any(m => m.ClassId == a.ClassId
                        && m.StudentId == userId
                        && m.Status == ClassMemberStatus.Active)),
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

    /// <summary>
    /// Dersin crossword-uygun kelime sayısı: terim yalnız A–Z (≥2 harf) VE bir çevirisi (ipucu) dolu.
    /// Terim eleme kuralı SQL'e çevrilemediği için bellekte değerlendirilir.
    /// </summary>
    private async Task<int> CountCrosswordEligibleWordsAsync(Guid lessonId, CancellationToken cancellationToken)
    {
        var words = await _db.Words
            .Where(w => w.LessonId == lessonId)
            .Include(w => w.Translations)
            .ToListAsync(cancellationToken);

        return words.Count(w =>
            CrosswordGenerator.IsEligibleTerm(w.Term)
            && CrosswordGenerator.NormalizeAnswer(w.Term).Length >= 2
            && PrimaryTranslation(w) is not null);
    }

    /// <summary>
    /// Dersin scrambled-uygun kelime sayısı: terim tek kelime (boşluk/tire içermez), ≥2 karakter VE bir
    /// çevirisi (ipucu) dolu. Terim eleme kuralı SQL'e çevrilemediği için bellekte değerlendirilir.
    /// </summary>
    private async Task<int> CountScrambledEligibleWordsAsync(Guid lessonId, CancellationToken cancellationToken)
    {
        var words = await _db.Words
            .Where(w => w.LessonId == lessonId)
            .Include(w => w.Translations)
            .ToListAsync(cancellationToken);

        return words.Count(w => IsEligibleForScrambled(w.Term) && PrimaryTranslation(w) is not null);
    }

    private static string? NormalizeTitle(string? title)
        => string.IsNullOrWhiteSpace(title) ? null : title.Trim();

    private static string DefaultTitle(GameType type) => type switch
    {
        GameType.WordMatching => "Kelime Eşleştirme",
        GameType.Crossword => "Bulmaca",
        GameType.Scrambled => "Harfleri Diz",
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
