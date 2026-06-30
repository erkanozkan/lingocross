using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Games;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.QuestionBanks;

/// <summary>
/// Faz 2 — QuestionSet (Çıkmış Sorular) oyununun GameService tarafı: bankadan içerik üretimi
/// (BuildQuestionSetContentAsync), oturum başlatma (atama-tabanlı erişim, ders kontrolü atlanır),
/// tek-seferlik oynama (409) ve banka yetersizliği (400). Mevcut WordMatching/Crossword/Scrambled
/// davranışı bu testlerle etkilenmez.
/// </summary>
public class QuestionSetGameServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"qset-{Guid.NewGuid()}")
            .Options);

    private static Random SeededRandom() => new(12345);

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role, string email)
    {
        var user = new User { Email = email, PasswordHash = "x", DisplayName = email, Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    /// <summary>questionCount soruluk bir aktif konu başlığı kurar; her soru 5 şık + tam 1 doğru (Position 0..4).</summary>
    private static async Task<QuestionTopic> SeedTopicAsync(AppDbContext db, int questionCount, bool active = true)
    {
        var topic = new QuestionTopic
        {
            Title = "YDS 2020",
            Slug = $"yds-{Guid.NewGuid():N}",
            IsActive = active,
            SortOrder = 0,
        };

        for (var i = 0; i < questionCount; i++)
        {
            var q = new Question { Stem = $"Soru {i}", Ordinal = i, Explanation = $"Açıklama {i}" };
            for (var p = 0; p < 5; p++)
            {
                q.Options.Add(new QuestionOption { Position = p, Text = $"S{i}-{p}", IsCorrect = p == 2 });
            }
            topic.Questions.Add(q);
        }

        db.QuestionTopics.Add(topic);
        await db.SaveChangesAsync();
        return topic;
    }

    /// <summary>QuestionSet oyunu (Lesson null, QuestionTopicId dolu) + atanmış sınıf + öğrenci üyesi kurar.</summary>
    private static async Task<Game> SeedQuestionSetGameAsync(
        AppDbContext db, Guid topicId, Guid teacherId, Guid studentId,
        bool published = true, bool assigned = true, bool archived = false)
    {
        var game = new Game
        {
            LessonId = null,
            QuestionTopicId = topicId,
            Type = GameType.QuestionSet,
            Title = "Çıkmış Sorular",
            IsPublished = published,
            PublishedAt = published ? DateTime.UtcNow : null,
        };
        db.Games.Add(game);
        await db.SaveChangesAsync();

        if (assigned)
        {
            var klass = new Class { TeacherId = teacherId, Name = "Sınıf", IsArchived = archived };
            db.Classes.Add(klass);
            await db.SaveChangesAsync();
            db.ClassMembers.Add(new ClassMember { ClassId = klass.Id, StudentId = studentId, Status = ClassMemberStatus.Active });
            db.GameAssignments.Add(new GameAssignment { GameId = game.Id, ClassId = klass.Id });
            await db.SaveChangesAsync();
        }

        return game;
    }

    [Fact]
    public async Task StartSession_QuestionSet_ReturnsSessionAndContent()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var topic = await SeedTopicAsync(db, questionCount: 12);
        var game = await SeedQuestionSetGameAsync(db, topic.Id, teacher.Id, student.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var resp = await svc.StartSessionAsync(game.Id);

        Assert.Equal(GameType.QuestionSet, resp.Type);
        Assert.NotNull(resp.QuestionSet);
        Assert.Null(resp.WordMatching);
        // Banka 12 > 10 → tam 10 soru sunulur.
        Assert.Equal(GameService.QuestionsPerSet, resp.QuestionSet!.Questions.Count);

        foreach (var item in resp.QuestionSet.Questions)
        {
            // Her soru 5 şık, ÖSYM sırasında (A..E), KARIŞTIRILMAZ.
            Assert.Equal(5, item.Choices.Count);
            Assert.Equal(new[] { "A", "B", "C", "D", "E" }, item.Choices.Select(c => c.Label).ToArray());
            // CorrectOptionId, IsCorrect olan şıkkın (Position 2 → "C") Id'sidir.
            var correct = item.Choices.Single(c => c.OptionId == item.CorrectOptionId);
            Assert.Equal("C", correct.Label);
        }

        Assert.Equal(1, await db.GameSessions.CountAsync(s => s.GameId == game.Id && s.StudentId == student.Id));
    }

    [Fact]
    public async Task StartSession_QuestionSet_BankBelowTen_UsesAllQuestions()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        // AI ile üretilen küçük set / azaltılmış sayı: 10'dan az soru → hepsi kullanılır.
        var topic = await SeedTopicAsync(db, questionCount: 3);
        var game = await SeedQuestionSetGameAsync(db, topic.Id, teacher.Id, student.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var resp = await svc.StartSessionAsync(game.Id);

        Assert.NotNull(resp.QuestionSet);
        Assert.Equal(3, resp.QuestionSet!.Questions.Count);
        Assert.Equal(1, await db.GameSessions.CountAsync(s => s.GameId == game.Id));
    }

    [Fact]
    public async Task StartSession_QuestionSet_EmptyBank_Throws400_NoSession()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var topic = await SeedTopicAsync(db, questionCount: 0);
        var game = await SeedQuestionSetGameAsync(db, topic.Id, teacher.Id, student.Id);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.StartSessionAsync(game.Id));

        Assert.Equal(400, ex.StatusCode);
        Assert.Equal(0, await db.GameSessions.CountAsync());
    }

    [Fact]
    public async Task StartSession_QuestionSet_NotAssignedToStudentsClass_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var topic = await SeedTopicAsync(db, questionCount: 12);
        // assigned=false → öğrenci hiçbir atanmış sınıfta üye değil.
        var game = await SeedQuestionSetGameAsync(db, topic.Id, teacher.Id, student.Id, assigned: false);

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.StartSessionAsync(game.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task StartSession_QuestionSet_LessonAccessSkipped_NoLessonNeeded()
    {
        // QuestionSet oyununda hiç ders yoktur (LessonId null); yine de atama-tabanlı erişimle oynanır.
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var topic = await SeedTopicAsync(db, questionCount: 10);
        var game = await SeedQuestionSetGameAsync(db, topic.Id, teacher.Id, student.Id);

        Assert.Equal(0, await db.Lessons.CountAsync()); // ortamda hiç ders yok

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var resp = await svc.StartSessionAsync(game.Id);

        Assert.NotNull(resp.QuestionSet);
        Assert.Equal(10, resp.QuestionSet!.Questions.Count);
    }

    [Fact]
    public async Task StartSession_QuestionSet_AlreadyCompleted_Throws409()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var topic = await SeedTopicAsync(db, questionCount: 12);
        var game = await SeedQuestionSetGameAsync(db, topic.Id, teacher.Id, student.Id);

        // Tamamlanmış (sonuçlu) bir oturum kur.
        var session = new GameSession
        {
            GameId = game.Id,
            StudentId = student.Id,
            Status = GameSessionStatus.Completed,
            StartedAt = DateTime.UtcNow,
            CompletedAt = DateTime.UtcNow,
        };
        db.GameSessions.Add(session);
        await db.SaveChangesAsync();
        db.GameResults.Add(new GameResult { SessionId = session.Id, DurationMs = 1000, TotalItems = 10, CorrectItems = 8, Score = 80 });
        await db.SaveChangesAsync();

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.StartSessionAsync(game.Id));
        Assert.Equal(409, ex.StatusCode);
    }

    [Fact]
    public async Task StartSession_QuestionSet_SeededRandom_IsDeterministic()
    {
        // Aynı tohumlu Random + aynı (deterministik tohumlanmış) banka → seçilen soruların Ordinal'leri
        // iki ayrı ortamda AYNI sırada gelir. (QuestionId'ler DB'ye göre değiştiğinden Ordinal ile karşılaştırırız.)
        var ordinals1 = await SelectOrdinalsAsync();
        var ordinals2 = await SelectOrdinalsAsync();

        Assert.Equal(GameService.QuestionsPerSet, ordinals1.Count);
        Assert.Equal(ordinals1, ordinals2);
        Assert.Equal(ordinals1.Count, ordinals1.Distinct().Count()); // tekrarsız

        static async Task<List<int>> SelectOrdinalsAsync()
        {
            var db = NewDb();
            var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
            var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
            var topic = await SeedTopicAsync(db, questionCount: 30);
            var game = await SeedQuestionSetGameAsync(db, topic.Id, teacher.Id, student.Id);

            var resp = await new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom())
                .StartSessionAsync(game.Id);

            // Sunulan QuestionId → o sorunun Ordinal'i (Stem "Soru {i}" → Ordinal i ile tohumlandı).
            var idToOrdinal = await db.Questions.ToDictionaryAsync(q => q.Id, q => q.Ordinal);
            return resp.QuestionSet!.Questions.Select(q => idToOrdinal[q.QuestionId]).ToList();
        }
    }
}
