using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Games;
using LingoCross.Application.Games.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Games;

/// <summary>
/// M4/F2.2 — Kelime eşleştirme oyunu: öğretmen oluşturma+yayımlama, ders oyun listesi, öğrenciye
/// atanan bulmacalar, içerik üretimi (çift + çeldirici), yetersiz kelime hatası, oturum başlatma
/// (yayımlanmış + enrolled+published), erişim reddi ve oturum sahipliği.
/// </summary>
public class GameServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"games-{Guid.NewGuid()}")
            .Options);

    // Determinizm: testlerde sabit tohumlu Random kullanılır.
    private static Random SeededRandom() => new(12345);

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role, string email)
    {
        var user = new User { Email = email, PasswordHash = "x", DisplayName = email, Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    private static async Task<Lesson> SeedLessonWithWordsAsync(
        AppDbContext db, Guid teacherId, bool published, int translatedWordCount)
    {
        var lesson = new Lesson { TeacherId = teacherId, Title = "Ders", IsPublished = published };
        for (var i = 0; i < translatedWordCount; i++)
        {
            var word = new Word { Term = $"term{i}", SortOrder = i, Source = WordSource.Manual };
            word.Translations.Add(new WordTranslation { Text = $"çeviri{i}", IsPrimary = true });
            lesson.Words.Add(word);
        }
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();
        return lesson;
    }

    /// <summary>Belirli bir terim+birincil çeviriyle kelime ekler (crossword uygunluk testleri için).</summary>
    private static void AddWord(Lesson lesson, string term, string translation, int sortOrder)
    {
        var word = new Word { Term = term, SortOrder = sortOrder, Source = WordSource.Manual };
        word.Translations.Add(new WordTranslation { Text = translation, IsPrimary = true });
        lesson.Words.Add(word);
    }

    /// <summary>Verilen (terim, çeviri) çiftleriyle bir ders kurar.</summary>
    private static async Task<Lesson> SeedLessonWithTermsAsync(
        AppDbContext db, Guid teacherId, bool published, params (string Term, string Translation)[] words)
    {
        var lesson = new Lesson { TeacherId = teacherId, Title = "Ders", IsPublished = published };
        for (var i = 0; i < words.Length; i++)
        {
            AddWord(lesson, words[i].Term, words[i].Translation, i);
        }
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();
        return lesson;
    }

    private static async Task EnrollAsync(AppDbContext db, Guid teacherId, Guid studentId, EnrollmentStatus status)
    {
        db.Enrollments.Add(new Enrollment { TeacherId = teacherId, StudentId = studentId, Status = status });
        await db.SaveChangesAsync();
    }

    /// <summary>
    /// F4.3: Öğretmen için bir sınıf oluşturur, öğrenciyi Active üye yapar ve verilen oyunu o sınıfa atar.
    /// Görünürlük artık sınıf üyeliği + atamadan türetilir. Oluşturulan sınıfı döndürür.
    /// </summary>
    private static async Task<Class> SeedClassWithMemberAndAssignmentAsync(
        AppDbContext db, Guid teacherId, Guid studentId, Guid gameId,
        ClassMemberStatus memberStatus = ClassMemberStatus.Active, bool archived = false)
    {
        var klass = new Class { TeacherId = teacherId, Name = "Sınıf", InviteCode = $"C{Guid.NewGuid():N}"[..8].ToUpperInvariant(), IsArchived = archived };
        db.Classes.Add(klass);
        await db.SaveChangesAsync();

        db.ClassMembers.Add(new ClassMember { ClassId = klass.Id, StudentId = studentId, Status = memberStatus });
        db.GameAssignments.Add(new GameAssignment { GameId = gameId, ClassId = klass.Id });
        await db.SaveChangesAsync();
        return klass;
    }

    private static async Task<Game> SeedGameAsync(
        AppDbContext db, Guid lessonId, bool published = true, GameType type = GameType.WordMatching)
    {
        var game = new Game
        {
            LessonId = lessonId,
            Type = type,
            Title = type == GameType.Crossword ? "Bulmaca" : "Kelime Eşleştirme",
            IsPublished = published,
            PublishedAt = published ? DateTime.UtcNow : null,
        };
        db.Games.Add(game);
        await db.SaveChangesAsync();
        return game;
    }

    /// <summary>Bir oyun için tamamlanmış bir oturum + sonuç (game_result) ekler (solveCount testleri için).</summary>
    private static async Task SeedCompletedResultAsync(AppDbContext db, Guid gameId, Guid studentId)
    {
        var session = new GameSession
        {
            GameId = gameId,
            StudentId = studentId,
            Status = GameSessionStatus.Completed,
            StartedAt = DateTime.UtcNow,
            CompletedAt = DateTime.UtcNow,
        };
        db.GameSessions.Add(session);
        await db.SaveChangesAsync();

        db.GameResults.Add(new GameResult
        {
            SessionId = session.Id,
            DurationMs = 1000,
            TotalItems = 5,
            CorrectItems = 5,
            Score = 100,
        });
        await db.SaveChangesAsync();
    }

    // ---- F2.2: CreateForLesson (öğretmen oluşturma + yayımlama) ----

    [Fact]
    public async Task Create_AsOwnerTeacher_WordMatching_CreatesAndPublishes()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: false, translatedWordCount: 5);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var game = await svc.CreateForLessonAsync(lesson.Id, new CreateGameRequest(GameType.WordMatching, "Hafta 1"));

        Assert.Equal(GameType.WordMatching, game.Type);
        Assert.Equal("Hafta 1", game.Title);
        Assert.True(game.IsPublished);
        Assert.NotNull(game.PublishedAt);
        Assert.Equal(1, await db.Games.CountAsync(g => g.LessonId == lesson.Id));
    }

    [Fact]
    public async Task Create_WithoutTitle_UsesDefaultTitle()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: false, translatedWordCount: 4);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var game = await svc.CreateForLessonAsync(lesson.Id, new CreateGameRequest(GameType.WordMatching, null));

        Assert.Equal("Kelime Eşleştirme", game.Title);
    }

    [Fact]
    public async Task Create_InsufficientWords_Throws400()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        // 3 < MinWordsToPlay(4) → oluşturulamaz.
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: false, translatedWordCount: 3);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.CreateForLessonAsync(lesson.Id, new CreateGameRequest(GameType.WordMatching, null)));
        Assert.Equal(400, ex.StatusCode);
        Assert.Equal(0, await db.Games.CountAsync());
    }

    [Fact]
    public async Task Create_Crossword_WithEnoughEligibleWords_Returns201()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        // 5 crossword-uygun (A–Z) çevirili kelime → crossword oluşturulabilir.
        var lesson = await SeedLessonWithTermsAsync(db, teacher.Id, published: false,
            ("apple", "elma"),
            ("pear", "armut"),
            ("plate", "tabak"),
            ("lemon", "limon"),
            ("melon", "kavun"));

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var game = await svc.CreateForLessonAsync(lesson.Id, new CreateGameRequest(GameType.Crossword, "Bulmaca 1"));

        Assert.Equal(GameType.Crossword, game.Type);
        Assert.Equal("Bulmaca 1", game.Title);
        Assert.True(game.IsPublished);
        Assert.NotNull(game.PublishedAt);
    }

    [Fact]
    public async Task Create_Crossword_InsufficientEligibleWords_Throws400()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        // 5 çevirili kelime ama yalnız 3'ü crossword-uygun (geri kalanlar çok kelimeli/tireli → uygunsuz).
        // Not: tek kelime aksanlı terimler (örn. "çiçek") artık UYGUN; o yüzden burada boşluk/tire kullanıyoruz.
        var lesson = new Lesson { TeacherId = teacher.Id, Title = "Ders", IsPublished = false };
        AddWord(lesson, "apple", "elma", 0);
        AddWord(lesson, "book", "kitap", 1);
        AddWord(lesson, "table", "masa", 2);
        AddWord(lesson, "book store", "kitapçı", 3); // boşluk → uygunsuz
        AddWord(lesson, "kitap evi", "bookstore", 4); // boşluk → uygunsuz
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.CreateForLessonAsync(lesson.Id, new CreateGameRequest(GameType.Crossword, null)));
        Assert.Equal(400, ex.StatusCode);
        Assert.Equal(0, await db.Games.CountAsync());
    }

    [Fact]
    public async Task Create_Twice_IsIdempotent_Republishes()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: false, translatedWordCount: 5);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var first = await svc.CreateForLessonAsync(lesson.Id, new CreateGameRequest(GameType.WordMatching, null));
        var second = await svc.CreateForLessonAsync(lesson.Id, new CreateGameRequest(GameType.WordMatching, null));

        Assert.Equal(first.Id, second.Id);
        Assert.Equal(1, await db.Games.CountAsync(g => g.LessonId == lesson.Id));
        Assert.True(second.IsPublished);
    }

    [Fact]
    public async Task Create_AsOtherTeacher_Throws404()
    {
        var db = NewDb();
        var owner = await SeedUserAsync(db, UserRole.Teacher, "o@x.com");
        var other = await SeedUserAsync(db, UserRole.Teacher, "x@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, owner.Id, published: false, translatedWordCount: 5);

        var svc = new GameService(db, TestCurrentUser.Teacher(other.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.CreateForLessonAsync(lesson.Id, new CreateGameRequest(GameType.WordMatching, null)));
        Assert.Equal(404, ex.StatusCode);
    }

    // ---- F2.2: ListForLesson (öğretmen, salt-okunur) ----

    [Fact]
    public async Task ListForLesson_AsOwnerTeacher_ReturnsGames_NoAutoCreate()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: false, translatedWordCount: 5);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());

        // Hiç oyun yokken liste boş (otomatik üretim YOK).
        var empty = await svc.ListForLessonAsync(lesson.Id);
        Assert.Empty(empty);
        Assert.Equal(0, await db.Games.CountAsync());

        await SeedGameAsync(db, lesson.Id);
        var games = await svc.ListForLessonAsync(lesson.Id);
        Assert.Single(games);
    }

    [Fact]
    public async Task ListForLesson_AsOtherTeacher_Throws404()
    {
        var db = NewDb();
        var owner = await SeedUserAsync(db, UserRole.Teacher, "o@x.com");
        var other = await SeedUserAsync(db, UserRole.Teacher, "x@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, owner.Id, published: false, translatedWordCount: 5);

        var svc = new GameService(db, TestCurrentUser.Teacher(other.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.ListForLessonAsync(lesson.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    // ---- F2.2: ListAssignedForStudent (öğrenciye atanan bulmacalar) ----

    [Fact]
    public async Task ListAssigned_EnrolledPublishedLessonPublishedGame_IsVisible()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "teacher@x.com");
        teacher.DisplayName = "Ayşe Öğretmen";
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 6);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var visibleGame = await SeedGameAsync(db, lesson.Id, published: true);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, student.Id, visibleGame.Id);
        await db.SaveChangesAsync();

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var assigned = await svc.ListAssignedForStudentAsync();

        Assert.Single(assigned);
        Assert.Equal(lesson.Id, assigned[0].LessonId);
        Assert.Equal("Ders", assigned[0].LessonTitle);
        Assert.Equal("Ayşe Öğretmen", assigned[0].TeacherName);
        Assert.Equal(6, assigned[0].WordCount);
        Assert.Equal(GameType.WordMatching, assigned[0].Type);
    }

    [Fact]
    public async Task ListAssigned_UnpublishedGame_NotVisible()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 6);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        await SeedGameAsync(db, lesson.Id, published: false);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        Assert.Empty(await svc.ListAssignedForStudentAsync());
    }

    [Fact]
    public async Task ListAssigned_UnpublishedLesson_NotVisible()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: false, translatedWordCount: 6);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        await SeedGameAsync(db, lesson.Id, published: true);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        Assert.Empty(await svc.ListAssignedForStudentAsync());
    }

    [Fact]
    public async Task ListAssigned_NotEnrolled_NotVisible()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 6);
        await SeedGameAsync(db, lesson.Id, published: true);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        Assert.Empty(await svc.ListAssignedForStudentAsync());
    }

    [Fact]
    public async Task ListAssigned_PendingEnrollment_NotVisible()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 6);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Pending);
        await SeedGameAsync(db, lesson.Id, published: true);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        Assert.Empty(await svc.ListAssignedForStudentAsync());
    }

    [Fact]
    public async Task StartSession_EnrolledPublished_CreatesInProgressAndContent()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 6);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, student.Id, game.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var response = await svc.StartSessionAsync(game.Id);

        Assert.Equal(GameSessionStatus.InProgress, response.Session.Status);
        Assert.Equal(student.Id, response.Session.StudentId);
        Assert.Equal(game.Id, response.Session.GameId);
        Assert.Equal(1, await db.GameSessions.CountAsync());

        // WordMatching oturumu: tür-duyarlı içerik WordMatching alanında.
        Assert.Equal(GameType.WordMatching, response.Type);
        Assert.NotNull(response.WordMatching);
        Assert.Null(response.Crossword);

        // 6 kelime ≤ MaxPairs(8) → 6 çift.
        Assert.Equal(6, response.WordMatching!.Pairs.Count);
        // Her çiftin term ve doğru çevirisi dolu.
        Assert.All(response.WordMatching!.Pairs, p =>
        {
            Assert.False(string.IsNullOrWhiteSpace(p.Term));
            Assert.False(string.IsNullOrWhiteSpace(p.CorrectTranslation));
            Assert.NotEqual(Guid.Empty, p.WordId);
        });
    }

    [Fact]
    public async Task StartSession_AlreadyCompleted_Throws409()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 6);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, student.Id, game.Id);
        // Bu öğrenci bu oyunu zaten tamamlamış (sonuçlu oturum).
        await SeedCompletedResultAsync(db, game.Id, student.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.StartSessionAsync(game.Id));
        Assert.Equal(409, ex.StatusCode);
    }

    [Fact]
    public async Task StartSession_HalfFinishedInProgressSession_DoesNotBlock_StartsAgain()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 6);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, student.Id, game.Id);
        // Yarım kalmış (sonuçsuz) InProgress oturum engel DEĞİL.
        db.GameSessions.Add(new GameSession
        {
            GameId = game.Id,
            StudentId = student.Id,
            Status = GameSessionStatus.InProgress,
            StartedAt = DateTime.UtcNow,
        });
        await db.SaveChangesAsync();

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var response = await svc.StartSessionAsync(game.Id);
        Assert.Equal(GameSessionStatus.InProgress, response.Session.Status);
    }

    [Fact]
    public async Task ListAssigned_CompletedGame_CarriesCompletionInfo()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 6);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id, published: true);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, student.Id, game.Id);
        await SeedCompletedResultAsync(db, game.Id, student.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var assigned = await svc.ListAssignedForStudentAsync();

        Assert.Single(assigned);
        Assert.True(assigned[0].IsCompleted);
        Assert.NotNull(assigned[0].ResultId);
        Assert.Equal(100, assigned[0].Score);
        Assert.NotNull(assigned[0].CompletedAt);
    }

    [Fact]
    public async Task ListAssigned_NotCompletedGame_HasNoCompletionInfo()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 6);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id, published: true);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, student.Id, game.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var assigned = await svc.ListAssignedForStudentAsync();

        Assert.Single(assigned);
        Assert.False(assigned[0].IsCompleted);
        Assert.Null(assigned[0].ResultId);
        Assert.Null(assigned[0].Score);
        Assert.Null(assigned[0].CompletedAt);
    }

    [Fact]
    public async Task StartSession_CapsPairsAtMax_AndProducesDistractors()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        // 12 kelime → en çok 8 çift, kalan kelimelerden çeldirici üretilir.
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 12);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, student.Id, game.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var content = (await svc.StartSessionAsync(game.Id)).WordMatching!;

        Assert.Equal(GameService.MaxPairs, content.Pairs.Count);
        Assert.Equal(GameService.MaxDistractors, content.Distractors.Count);

        // Çift terimleri benzersiz; sağ-sütun adayları (doğru çeviriler + çeldiriciler) benzersiz.
        Assert.Equal(content.Pairs.Select(p => p.WordId).Distinct().Count(), content.Pairs.Count);

        var correct = content.Pairs.Select(p => p.CorrectTranslation).ToList();
        var rightColumn = correct.Concat(content.Distractors).ToList();
        Assert.Equal(rightColumn.Distinct(StringComparer.OrdinalIgnoreCase).Count(), rightColumn.Count);

        // Çeldiriciler doğru cevaplarla çakışmaz.
        Assert.Empty(content.Distractors.Intersect(correct, StringComparer.OrdinalIgnoreCase));
    }

    [Fact]
    public async Task StartSession_InsufficientWords_Throws400()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        // 3 < MinWordsToPlay(4) → oynatılamaz.
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 3);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, student.Id, game.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.StartSessionAsync(game.Id));
        Assert.Equal(400, ex.StatusCode);
        // Hata atılınca oturum oluşturulmaz.
        Assert.Equal(0, await db.GameSessions.CountAsync());
    }

    [Fact]
    public async Task StartSession_StudentNotEnrolled_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 6);
        var game = await SeedGameAsync(db, lesson.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.StartSessionAsync(game.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task StartSession_EnrolledButUnpublished_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: false, translatedWordCount: 6);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.StartSessionAsync(game.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task StartSession_UnpublishedGame_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 6);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id, published: false);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.StartSessionAsync(game.Id));
        Assert.Equal(404, ex.StatusCode);
        Assert.Equal(0, await db.GameSessions.CountAsync());
    }

    [Fact]
    public async Task StartSession_Crossword_ReturnsCrosswordContent()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithTermsAsync(db, teacher.Id, published: true,
            ("APPLE", "elma"),
            ("PEAR", "armut"),
            ("PLATE", "tabak"),
            ("LEMON", "limon"),
            ("MELON", "kavun"));
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id, published: true, type: GameType.Crossword);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, student.Id, game.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var response = await svc.StartSessionAsync(game.Id);

        Assert.Equal(GameType.Crossword, response.Type);
        Assert.Null(response.WordMatching);
        Assert.NotNull(response.Crossword);
        Assert.Equal(GameSessionStatus.InProgress, response.Session.Status);
        Assert.Equal(1, await db.GameSessions.CountAsync());

        var content = response.Crossword!;
        Assert.True(content.Entries.Count >= CrosswordGenerator.MinEligibleWords);
        Assert.True(content.Rows > 0 && content.Cols > 0);
        // Cevaplar yalnız A–Z BÜYÜK; ipuçları dolu.
        Assert.All(content.Entries, e =>
        {
            Assert.Matches("^[A-Z]+$", e.Answer);
            Assert.False(string.IsNullOrWhiteSpace(e.Clue));
            Assert.Equal(e.Answer.Length, e.Length);
        });
    }

    [Fact]
    public async Task StartSession_Crossword_InsufficientEligible_Throws400_NoSession()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        // Yalnız 3 uygun terim → crossword oynatılamaz.
        var lesson = await SeedLessonWithTermsAsync(db, teacher.Id, published: true,
            ("APPLE", "elma"),
            ("PEAR", "armut"),
            ("PLATE", "tabak"));
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id, published: true, type: GameType.Crossword);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, student.Id, game.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.StartSessionAsync(game.Id));
        Assert.Equal(400, ex.StatusCode);
        Assert.Equal(0, await db.GameSessions.CountAsync());
    }

    [Fact]
    public async Task GetSession_Owner_Succeeds()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, student.Id, game.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var started = await svc.StartSessionAsync(game.Id);

        var fetched = await svc.GetSessionAsync(started.Session.Id);
        Assert.Equal(started.Session.Id, fetched.Id);
    }

    [Fact]
    public async Task GetSession_NonOwnerStudent_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var owner = await SeedUserAsync(db, UserRole.Student, "s1@x.com");
        var intruder = await SeedUserAsync(db, UserRole.Student, "s2@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);
        await EnrollAsync(db, teacher.Id, owner.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, owner.Id, game.Id);

        var ownerSvc = new GameService(db, TestCurrentUser.Student(owner.Id), SeededRandom());
        var started = await ownerSvc.StartSessionAsync(game.Id);

        var intruderSvc = new GameService(db, TestCurrentUser.Student(intruder.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => intruderSvc.GetSessionAsync(started.Session.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    // ---- F3.2: ListMyPuzzles (öğretmenin tüm derslerindeki bulmacaları) ----

    [Fact]
    public async Task ListMyPuzzles_ReturnsGamesAcrossAllOwnedLessons_NewestFirst()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lessonA = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);
        var lessonB = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);

        // Oluşturma zamanları farklı olsun: önce A, sonra B.
        var older = await SeedGameAsync(db, lessonA.Id);
        older.CreatedAt = DateTime.UtcNow.AddHours(-2);
        var newer = await SeedGameAsync(db, lessonB.Id);
        newer.CreatedAt = DateTime.UtcNow;
        await db.SaveChangesAsync();

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var puzzles = await svc.ListMyPuzzlesAsync();

        Assert.Equal(2, puzzles.Count);
        // Yeniden → eskiye: B önce.
        Assert.Equal(newer.Id, puzzles[0].Id);
        Assert.Equal(lessonB.Id, puzzles[0].LessonId);
        Assert.Equal(older.Id, puzzles[1].Id);
    }

    [Fact]
    public async Task ListMyPuzzles_AssignedStudentCount_EqualsAssignedClassActiveMembers()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);
        var game = await SeedGameAsync(db, lesson.Id, published: true);

        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@x.com");
        var s2 = await SeedUserAsync(db, UserRole.Student, "s2@x.com");
        var s3 = await SeedUserAsync(db, UserRole.Student, "s3@x.com");

        // s1, s2 atanmış sınıfın üyesi; s3 sınıfta değil → 2 sayılır.
        var klass = await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, s1.Id, game.Id);
        db.ClassMembers.Add(new ClassMember { ClassId = klass.Id, StudentId = s2.Id, Status = ClassMemberStatus.Active });
        await db.SaveChangesAsync();

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var puzzles = await svc.ListMyPuzzlesAsync();

        Assert.Single(puzzles);
        Assert.Equal(2, puzzles[0].AssignedStudentCount);
    }

    [Fact]
    public async Task ListMyPuzzles_AssignedStudentCount_CountsDistinctAcrossClasses()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);
        var game = await SeedGameAsync(db, lesson.Id, published: true);

        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@x.com");
        var s2 = await SeedUserAsync(db, UserRole.Student, "s2@x.com");

        // İki sınıf, ikisine de oyun atanmış; s1 her ikisinde üye, s2 yalnız birinde → distinct 2.
        var classA = await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, s1.Id, game.Id);
        var classB = await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, s1.Id, game.Id);
        db.ClassMembers.Add(new ClassMember { ClassId = classB.Id, StudentId = s2.Id, Status = ClassMemberStatus.Active });
        await db.SaveChangesAsync();

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var puzzles = await svc.ListMyPuzzlesAsync();

        Assert.Single(puzzles);
        Assert.Equal(2, puzzles[0].AssignedStudentCount);
    }

    [Fact]
    public async Task ListMyPuzzles_ArchivedClassMembers_NotCounted()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);
        var game = await SeedGameAsync(db, lesson.Id, published: true);

        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@x.com");
        // Oyun arşivli sınıfa atanmış → üye sayılmaz.
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, s1.Id, game.Id, archived: true);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var puzzles = await svc.ListMyPuzzlesAsync();

        Assert.Single(puzzles);
        Assert.Equal(0, puzzles[0].AssignedStudentCount);
    }

    [Fact]
    public async Task ListMyPuzzles_UnpublishedGame_AssignedStudentCountIsZero()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);
        await SeedGameAsync(db, lesson.Id, published: false);

        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@x.com");
        await EnrollAsync(db, teacher.Id, s1.Id, EnrollmentStatus.Active);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var puzzles = await svc.ListMyPuzzlesAsync();

        Assert.Single(puzzles);
        Assert.False(puzzles[0].IsPublished);
        Assert.Equal(0, puzzles[0].AssignedStudentCount);
    }

    [Fact]
    public async Task ListMyPuzzles_SolveCount_CountsCompletedResults()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);
        var game = await SeedGameAsync(db, lesson.Id, published: true);
        var other = await SeedGameAsync(db, lesson.Id, published: true, type: GameType.Crossword);

        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@x.com");
        var s2 = await SeedUserAsync(db, UserRole.Student, "s2@x.com");
        // game için 2 tamamlanmış sonuç, other için 1.
        await SeedCompletedResultAsync(db, game.Id, s1.Id);
        await SeedCompletedResultAsync(db, game.Id, s2.Id);
        await SeedCompletedResultAsync(db, other.Id, s1.Id);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var puzzles = await svc.ListMyPuzzlesAsync();

        Assert.Equal(2, puzzles.Single(p => p.Id == game.Id).SolveCount);
        Assert.Equal(1, puzzles.Single(p => p.Id == other.Id).SolveCount);
    }

    [Fact]
    public async Task ListMyPuzzles_DoesNotReturnOtherTeachersGames()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var other = await SeedUserAsync(db, UserRole.Teacher, "o@x.com");
        var mine = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);
        var theirs = await SeedLessonWithWordsAsync(db, other.Id, published: true, translatedWordCount: 5);
        var myGame = await SeedGameAsync(db, mine.Id);
        await SeedGameAsync(db, theirs.Id);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var puzzles = await svc.ListMyPuzzlesAsync();

        Assert.Single(puzzles);
        Assert.Equal(myGame.Id, puzzles[0].Id);
    }

    [Fact]
    public async Task ListMyPuzzles_AsStudent_Throws403()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.ListMyPuzzlesAsync());
        Assert.Equal(403, ex.StatusCode);
    }

    // ---- F3.2: Share (idempotent yeniden-yayınla) ----

    [Fact]
    public async Task Share_AsOwner_PublishesAndSetsPublishedAt()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);
        var game = await SeedGameAsync(db, lesson.Id, published: false);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var result = await svc.ShareAsync(game.Id);

        Assert.True(result.IsPublished);
        Assert.NotNull(result.PublishedAt);

        var reloaded = await db.Games.FirstAsync(g => g.Id == game.Id);
        Assert.True(reloaded.IsPublished);
        Assert.NotNull(reloaded.PublishedAt);
    }

    [Fact]
    public async Task Share_IsIdempotent_RefreshesPublishedAt()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);
        var game = await SeedGameAsync(db, lesson.Id, published: true);
        // Eski bir yayımlama zamanı koy.
        game.PublishedAt = DateTime.UtcNow.AddDays(-3);
        await db.SaveChangesAsync();
        var before = game.PublishedAt!.Value;

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var result = await svc.ShareAsync(game.Id);

        Assert.True(result.IsPublished);
        Assert.NotNull(result.PublishedAt);
        Assert.True(result.PublishedAt > before);
    }

    [Fact]
    public async Task Share_OtherTeachersGame_Throws404()
    {
        var db = NewDb();
        var owner = await SeedUserAsync(db, UserRole.Teacher, "o@x.com");
        var other = await SeedUserAsync(db, UserRole.Teacher, "x@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, owner.Id, published: true, translatedWordCount: 5);
        var game = await SeedGameAsync(db, lesson.Id, published: false);

        var svc = new GameService(db, TestCurrentUser.Teacher(other.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.ShareAsync(game.Id));
        Assert.Equal(404, ex.StatusCode);

        // Başkasının oyunu değişmemeli.
        var reloaded = await db.Games.FirstAsync(g => g.Id == game.Id);
        Assert.False(reloaded.IsPublished);
    }

    [Fact]
    public async Task Share_NonexistentGame_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.ShareAsync(Guid.NewGuid()));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task Share_AsStudent_Throws403()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);
        var game = await SeedGameAsync(db, lesson.Id, published: false);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.ShareAsync(game.Id));
        Assert.Equal(403, ex.StatusCode);
    }

    // ---- Preview (kaydetmeden önce örnek içerik; kalıcı DEĞİL) ----

    [Fact]
    public async Task Preview_WordMatching_ReturnsPairs_NoPersistence()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: false, translatedWordCount: 6);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var preview = await svc.PreviewForLessonAsync(lesson.Id, GameType.WordMatching);

        Assert.Equal(GameType.WordMatching, preview.Type);
        Assert.NotNull(preview.WordMatching);
        Assert.Null(preview.Crossword);
        Assert.Equal(6, preview.WordMatching!.Pairs.Count);
        Assert.All(preview.WordMatching!.Pairs, p =>
        {
            Assert.False(string.IsNullOrWhiteSpace(p.Term));
            Assert.False(string.IsNullOrWhiteSpace(p.CorrectTranslation));
        });

        // Kalıcılık yok: ne Game ne de GameSession oluşturuldu.
        Assert.Equal(0, await db.Games.CountAsync());
        Assert.Equal(0, await db.GameSessions.CountAsync());
    }

    [Fact]
    public async Task Preview_Crossword_ReturnsEntries_NoPersistence()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithTermsAsync(db, teacher.Id, published: false,
            ("apple", "elma"),
            ("pear", "armut"),
            ("plate", "tabak"),
            ("lemon", "limon"),
            ("melon", "kavun"));

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var preview = await svc.PreviewForLessonAsync(lesson.Id, GameType.Crossword);

        Assert.Equal(GameType.Crossword, preview.Type);
        Assert.Null(preview.WordMatching);
        Assert.NotNull(preview.Crossword);
        Assert.True(preview.Crossword!.Entries.Count >= CrosswordGenerator.MinEligibleWords);
        Assert.True(preview.Crossword!.Rows > 0 && preview.Crossword!.Cols > 0);

        // Kalıcılık yok.
        Assert.Equal(0, await db.Games.CountAsync());
        Assert.Equal(0, await db.GameSessions.CountAsync());
    }

    [Fact]
    public async Task Preview_AsOtherTeacher_Throws404()
    {
        var db = NewDb();
        var owner = await SeedUserAsync(db, UserRole.Teacher, "o@x.com");
        var other = await SeedUserAsync(db, UserRole.Teacher, "x@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, owner.Id, published: false, translatedWordCount: 6);

        var svc = new GameService(db, TestCurrentUser.Teacher(other.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.PreviewForLessonAsync(lesson.Id, GameType.WordMatching));
        Assert.Equal(404, ex.StatusCode);
        Assert.Equal(0, await db.Games.CountAsync());
    }

    [Fact]
    public async Task Preview_NonexistentLesson_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.PreviewForLessonAsync(Guid.NewGuid(), GameType.WordMatching));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task Preview_InsufficientWords_Throws400_NoPersistence()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        // 3 < MinWordsToPlay(4) → önizleme üretilemez (CreateForLesson ile aynı davranış).
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: false, translatedWordCount: 3);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.PreviewForLessonAsync(lesson.Id, GameType.WordMatching));
        Assert.Equal(400, ex.StatusCode);
        Assert.Equal(0, await db.Games.CountAsync());
        Assert.Equal(0, await db.GameSessions.CountAsync());
    }

    [Fact]
    public async Task Preview_AsStudent_Throws403()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.PreviewForLessonAsync(Guid.NewGuid(), GameType.WordMatching));
        Assert.Equal(403, ex.StatusCode);
    }

    // ---- Scrambled (harf karıştırma) ----

    /// <summary>Bir kaynak terimin (trim) harfleri ile karıştırılmış dizenin aynı çoklu-küme olduğunu doğrular.</summary>
    private static void AssertSameMultiset(string answer, string scrambled)
    {
        var a = answer.OrderBy(c => c).ToArray();
        var s = scrambled.OrderBy(c => c).ToArray();
        Assert.Equal(new string(a), new string(s));
    }

    [Fact]
    public async Task Create_Scrambled_WithEnoughEligibleWords_CreatesAndPublishes()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        // 5 tek-kelimeli, çevirili kelime → scrambled oluşturulabilir.
        var lesson = await SeedLessonWithTermsAsync(db, teacher.Id, published: false,
            ("apple", "elma"),
            ("pear", "armut"),
            ("plate", "tabak"),
            ("lemon", "limon"),
            ("melon", "kavun"));

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var game = await svc.CreateForLessonAsync(lesson.Id, new CreateGameRequest(GameType.Scrambled, null));

        Assert.Equal(GameType.Scrambled, game.Type);
        Assert.Equal("Harfleri Diz", game.Title);
        Assert.True(game.IsPublished);
        Assert.NotNull(game.PublishedAt);
    }

    [Fact]
    public async Task Create_Scrambled_InsufficientEligibleWords_Throws400()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        // 5 çevirili kelime ama yalnız 3'ü scrambled-uygun (2'si çok-kelimeli/tireli → uygunsuz).
        var lesson = new Lesson { TeacherId = teacher.Id, Title = "Ders", IsPublished = false };
        AddWord(lesson, "apple", "elma", 0);
        AddWord(lesson, "book", "kitap", 1);
        AddWord(lesson, "table", "masa", 2);
        AddWord(lesson, "book store", "kitapçı", 3); // boşluk → uygunsuz
        AddWord(lesson, "re-use", "yeniden kullan", 4); // tire → uygunsuz
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.CreateForLessonAsync(lesson.Id, new CreateGameRequest(GameType.Scrambled, null)));
        Assert.Equal(400, ex.StatusCode);
        Assert.Equal(0, await db.Games.CountAsync());
    }

    [Fact]
    public async Task StartSession_Scrambled_ReturnsScrambledContent()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithTermsAsync(db, teacher.Id, published: true,
            ("apple", "elma"),
            ("pear", "armut"),
            ("plate", "tabak"),
            ("lemon", "limon"),
            ("melon", "kavun"));
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id, published: true, type: GameType.Scrambled);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, student.Id, game.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var response = await svc.StartSessionAsync(game.Id);

        Assert.Equal(GameType.Scrambled, response.Type);
        Assert.NotNull(response.Scrambled);
        Assert.Null(response.WordMatching);
        Assert.Null(response.Crossword);
        Assert.Equal(GameSessionStatus.InProgress, response.Session.Status);
        Assert.Equal(1, await db.GameSessions.CountAsync());

        // 5 kelime ≤ MaxPairs(8) → 5 item.
        Assert.Equal(5, response.Scrambled!.Items.Count);
        Assert.All(response.Scrambled!.Items, item =>
        {
            Assert.False(string.IsNullOrWhiteSpace(item.Answer));
            Assert.False(string.IsNullOrWhiteSpace(item.Clue));
            Assert.NotEqual(Guid.Empty, item.WordId);
            // Karışık harfler cevabın bir permütasyonu (aynı çoklu-küme).
            AssertSameMultiset(item.Answer, item.ScrambledLetters);
        });
    }

    [Fact]
    public async Task BuildScrambledContent_ItemShapeAndEligibility()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        // 4 tek-kelimeli uygun + 2 uygunsuz (çok-kelimeli, tek-harfli).
        var lesson = new Lesson { TeacherId = teacher.Id, Title = "Ders", IsPublished = false };
        AddWord(lesson, "apple", "elma", 0);
        AddWord(lesson, "pear", "armut", 1);
        AddWord(lesson, "plate", "tabak", 2);
        AddWord(lesson, "lemon", "limon", 3);
        AddWord(lesson, "book store", "kitapçı", 4); // çok kelimeli → elenir
        AddWord(lesson, "a", "bir", 5);              // tek harf → elenir
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var preview = await svc.PreviewForLessonAsync(lesson.Id, GameType.Scrambled);

        Assert.NotNull(preview.Scrambled);
        // Yalnız 4 uygun kelime; uygunsuzlar elenir.
        Assert.Equal(4, preview.Scrambled!.Items.Count);

        var byClue = new Dictionary<string, string>
        {
            ["elma"] = "apple",
            ["armut"] = "pear",
            ["tabak"] = "plate",
            ["limon"] = "lemon",
        };

        Assert.All(preview.Scrambled!.Items, item =>
        {
            // Clue = birincil çeviri; Answer = ilgili terim.
            Assert.True(byClue.ContainsKey(item.Clue));
            Assert.Equal(byClue[item.Clue], item.Answer);
            // ScrambledLetters Answer'ın permütasyonu.
            AssertSameMultiset(item.Answer, item.ScrambledLetters);
        });

        // Çok-kelimeli/tek-harfli terimler içerikte yok.
        Assert.DoesNotContain(preview.Scrambled!.Items, i => i.Answer is "book store" or "a");
    }

    [Fact]
    public async Task Preview_Scrambled_ReturnsItems_NoPersistence()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithTermsAsync(db, teacher.Id, published: false,
            ("apple", "elma"),
            ("pear", "armut"),
            ("plate", "tabak"),
            ("lemon", "limon"),
            ("melon", "kavun"));

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var preview = await svc.PreviewForLessonAsync(lesson.Id, GameType.Scrambled);

        Assert.Equal(GameType.Scrambled, preview.Type);
        Assert.NotNull(preview.Scrambled);
        Assert.Null(preview.WordMatching);
        Assert.Null(preview.Crossword);
        Assert.Equal(5, preview.Scrambled!.Items.Count);

        // Kalıcılık yok: ne Game ne de GameSession oluşturuldu.
        Assert.Equal(0, await db.Games.CountAsync());
        Assert.Equal(0, await db.GameSessions.CountAsync());
    }

    [Fact]
    public async Task StartSession_Scrambled_InsufficientEligible_Throws400_NoSession()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        // Yalnız 3 uygun terim → scrambled oynatılamaz.
        var lesson = await SeedLessonWithTermsAsync(db, teacher.Id, published: true,
            ("apple", "elma"),
            ("pear", "armut"),
            ("plate", "tabak"));
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id, published: true, type: GameType.Scrambled);
        await SeedClassWithMemberAndAssignmentAsync(db, teacher.Id, student.Id, game.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.StartSessionAsync(game.Id));
        Assert.Equal(400, ex.StatusCode);
        Assert.Equal(0, await db.GameSessions.CountAsync());
    }
}
