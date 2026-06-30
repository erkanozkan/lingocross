using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Games;
using LingoCross.Application.QuestionBanks;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.QuestionBanks;

/// <summary>
/// Faz 2 — QuestionBankService: atanabilir başlık listesi, başlık→QuestionSet Game idempotent upsert ve
/// sınıf atama SET semantiği (GameService.ApplyAssignmentsForGameAsync yeniden kullanılarak).
/// </summary>
public class QuestionBankServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"qbank-{Guid.NewGuid()}")
            .Options);

    private static IQuestionBankService NewService(AppDbContext db, Guid teacherId)
    {
        var gameService = new GameService(db, TestCurrentUser.Teacher(teacherId), new Random(1));
        return new QuestionBankService(db, TestCurrentUser.Teacher(teacherId), gameService);
    }

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role, string email)
    {
        var user = new User { Email = email, PasswordHash = "x", DisplayName = email, Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    private static async Task<QuestionTopic> SeedTopicAsync(AppDbContext db, int questionCount = 10, bool active = true)
    {
        var topic = new QuestionTopic { Title = "YDS 2020", Slug = $"yds-{Guid.NewGuid():N}", IsActive = active };
        for (var i = 0; i < questionCount; i++)
        {
            var q = new Question { Stem = $"Soru {i}", Ordinal = i };
            for (var p = 0; p < 5; p++)
            {
                q.Options.Add(new QuestionOption { Position = p, Text = $"o{p}", IsCorrect = p == 0 });
            }
            topic.Questions.Add(q);
        }
        db.QuestionTopics.Add(topic);
        await db.SaveChangesAsync();
        return topic;
    }

    private static async Task<Class> SeedClassAsync(AppDbContext db, Guid teacherId, string name = "Sınıf")
    {
        var klass = new Class { TeacherId = teacherId, Name = name };
        db.Classes.Add(klass);
        await db.SaveChangesAsync();
        return klass;
    }

    private static async Task<QuestionTopic> SeedAiTopicAsync(AppDbContext db, Guid teacherId, int questionCount = 3)
    {
        var topic = new QuestionTopic
        {
            Title = "Animals — Sınav",
            Slug = $"ai-{Guid.NewGuid():N}"[..11],
            TeacherId = teacherId,
            Grade = 5,
            IsActive = true,
        };
        for (var i = 0; i < questionCount; i++)
        {
            var q = new Question { Stem = $"Soru {i}", Ordinal = i, Kind = "word_meaning" };
            for (var p = 0; p < 4; p++)
            {
                q.Options.Add(new QuestionOption { Position = p, Text = $"o{p}", IsCorrect = p == 0 });
            }
            topic.Questions.Add(q);
        }
        db.QuestionTopics.Add(topic);
        await db.SaveChangesAsync();
        return topic;
    }

    [Fact]
    public async Task ListTopics_ReturnsGlobalAndOwnAi_ButNotOtherTeachersAi()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var other = await SeedUserAsync(db, UserRole.Teacher, "o@x.com");
        var global = await SeedTopicAsync(db, questionCount: 10, active: true); // TeacherId null
        var mine = await SeedAiTopicAsync(db, teacher.Id);
        await SeedAiTopicAsync(db, other.Id); // başka öğretmenin AI seti → görünmemeli

        var list = await NewService(db, teacher.Id).ListTopicsAsync();

        var ids = list.Select(t => t.Id).ToHashSet();
        Assert.Contains(global.Id, ids);
        Assert.Contains(mine.Id, ids);
        Assert.Equal(2, list.Count);
    }

    [Fact]
    public async Task ListTopics_ReturnsOnlyActive_WithQuestionCount()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var active = await SeedTopicAsync(db, questionCount: 12, active: true);
        await SeedTopicAsync(db, questionCount: 8, active: false);

        var list = await NewService(db, teacher.Id).ListTopicsAsync();

        Assert.Single(list);
        Assert.Equal(active.Id, list[0].Id);
        Assert.Equal(12, list[0].QuestionCount);
    }

    [Fact]
    public async Task SetTopicAssignments_FirstTime_UpsertsSingleQuestionSetGame_AndAssigns()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var topic = await SeedTopicAsync(db);
        var c1 = await SeedClassAsync(db, teacher.Id, "A");

        var dto = await NewService(db, teacher.Id).SetTopicAssignmentsAsync(topic.Id, new[] { c1.Id });

        Assert.Equal(new[] { c1.Id }, dto.ClassIds);
        // Tam bir QuestionSet oyunu (Lesson null, başlık dolu, yayımlı) oluşur.
        var games = await db.Games.Where(g => g.QuestionTopicId == topic.Id && g.Type == GameType.QuestionSet).ToListAsync();
        Assert.Single(games);
        Assert.Null(games[0].LessonId);
        Assert.True(games[0].IsPublished);
        Assert.Equal(1, await db.GameAssignments.CountAsync(a => a.GameId == games[0].Id));
    }

    [Fact]
    public async Task SetTopicAssignments_CalledTwice_IsIdempotent_NoDuplicateGame()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var topic = await SeedTopicAsync(db);
        var c1 = await SeedClassAsync(db, teacher.Id, "A");
        var c2 = await SeedClassAsync(db, teacher.Id, "B");
        var svc = NewService(db, teacher.Id);

        await svc.SetTopicAssignmentsAsync(topic.Id, new[] { c1.Id });
        var dto = await svc.SetTopicAssignmentsAsync(topic.Id, new[] { c2.Id }); // SET semantiği: c1 düşer, c2 gelir

        Assert.Equal(new[] { c2.Id }, dto.ClassIds);
        Assert.Equal(1, await db.Games.CountAsync(g => g.QuestionTopicId == topic.Id)); // tek oyun
        var assignments = await db.GameAssignments.Select(a => a.ClassId).ToListAsync();
        Assert.Equal(new[] { c2.Id }, assignments);
    }

    [Fact]
    public async Task SetTopicAssignments_EmptyList_ClearsAssignments()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var topic = await SeedTopicAsync(db);
        var c1 = await SeedClassAsync(db, teacher.Id);
        var svc = NewService(db, teacher.Id);

        await svc.SetTopicAssignmentsAsync(topic.Id, new[] { c1.Id });
        var dto = await svc.SetTopicAssignmentsAsync(topic.Id, Array.Empty<Guid>());

        Assert.Empty(dto.ClassIds);
        Assert.Equal(0, await db.GameAssignments.CountAsync());
    }

    [Fact]
    public async Task SetTopicAssignments_ClassNotOwnedByTeacher_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var other = await SeedUserAsync(db, UserRole.Teacher, "o@x.com");
        var topic = await SeedTopicAsync(db);
        var foreignClass = await SeedClassAsync(db, other.Id);

        var ex = await Assert.ThrowsAsync<AppException>(
            () => NewService(db, teacher.Id).SetTopicAssignmentsAsync(topic.Id, new[] { foreignClass.Id }));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task SetTopicAssignments_InactiveTopic_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var topic = await SeedTopicAsync(db, active: false);
        var c1 = await SeedClassAsync(db, teacher.Id);

        var ex = await Assert.ThrowsAsync<AppException>(
            () => NewService(db, teacher.Id).SetTopicAssignmentsAsync(topic.Id, new[] { c1.Id }));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task GetTopicAssignments_NoGameYet_ReturnsEmpty()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var topic = await SeedTopicAsync(db);

        var dto = await NewService(db, teacher.Id).GetTopicAssignmentsAsync(topic.Id);
        Assert.Empty(dto.ClassIds);
    }

    [Fact]
    public async Task GetTopicAssignments_ReturnsCurrentClasses()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var topic = await SeedTopicAsync(db);
        var c1 = await SeedClassAsync(db, teacher.Id);
        var svc = NewService(db, teacher.Id);
        await svc.SetTopicAssignmentsAsync(topic.Id, new[] { c1.Id });

        var dto = await svc.GetTopicAssignmentsAsync(topic.Id);
        Assert.Equal(new[] { c1.Id }, dto.ClassIds);
    }

    [Fact]
    public async Task ListTopics_AsStudent_Throws403()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        await SeedTopicAsync(db);

        var gameService = new GameService(db, TestCurrentUser.Student(student.Id), new Random(1));
        var svc = new QuestionBankService(db, TestCurrentUser.Student(student.Id), gameService);

        var ex = await Assert.ThrowsAsync<AppException>(() => svc.ListTopicsAsync());
        Assert.Equal(403, ex.StatusCode);
    }
}
