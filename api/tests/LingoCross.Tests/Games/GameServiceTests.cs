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

    private static async Task EnrollAsync(AppDbContext db, Guid teacherId, Guid studentId, EnrollmentStatus status)
    {
        db.Enrollments.Add(new Enrollment { TeacherId = teacherId, StudentId = studentId, Status = status });
        await db.SaveChangesAsync();
    }

    private static async Task<Game> SeedGameAsync(AppDbContext db, Guid lessonId, bool published = true)
    {
        var game = new Game
        {
            LessonId = lessonId,
            Type = GameType.WordMatching,
            Title = "Kelime Eşleştirme",
            IsPublished = published,
            PublishedAt = published ? DateTime.UtcNow : null,
        };
        db.Games.Add(game);
        await db.SaveChangesAsync();
        return game;
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
    public async Task Create_Crossword_Throws400_NotSupported()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: false, translatedWordCount: 5);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.CreateForLessonAsync(lesson.Id, new CreateGameRequest(GameType.Crossword, null)));
        Assert.Equal(400, ex.StatusCode);
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
        await SeedGameAsync(db, lesson.Id, published: true);
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

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var response = await svc.StartSessionAsync(game.Id);

        Assert.Equal(GameSessionStatus.InProgress, response.Session.Status);
        Assert.Equal(student.Id, response.Session.StudentId);
        Assert.Equal(game.Id, response.Session.GameId);
        Assert.Equal(1, await db.GameSessions.CountAsync());

        // 6 kelime ≤ MaxPairs(8) → 6 çift.
        Assert.Equal(6, response.Content.Pairs.Count);
        // Her çiftin term ve doğru çevirisi dolu.
        Assert.All(response.Content.Pairs, p =>
        {
            Assert.False(string.IsNullOrWhiteSpace(p.Term));
            Assert.False(string.IsNullOrWhiteSpace(p.CorrectTranslation));
            Assert.NotEqual(Guid.Empty, p.WordId);
        });
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

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var content = (await svc.StartSessionAsync(game.Id)).Content;

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
    public async Task GetSession_Owner_Succeeds()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedLessonWithWordsAsync(db, teacher.Id, published: true, translatedWordCount: 5);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        var game = await SeedGameAsync(db, lesson.Id);

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

        var ownerSvc = new GameService(db, TestCurrentUser.Student(owner.Id), SeededRandom());
        var started = await ownerSvc.StartSessionAsync(game.Id);

        var intruderSvc = new GameService(db, TestCurrentUser.Student(intruder.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => intruderSvc.GetSessionAsync(started.Session.Id));
        Assert.Equal(404, ex.StatusCode);
    }
}
