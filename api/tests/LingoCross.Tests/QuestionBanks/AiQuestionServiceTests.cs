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
/// AI ile öğretmen sınav sorusu üretimi: doğrulama, sahiplik kapıları, retry ve teacher-owned topic kaydı.
/// Üretici (Claude completer) sahtelenir; ağ yoktur.
/// </summary>
public class AiQuestionServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"aiq-{Guid.NewGuid()}")
            .Options);

    private static AiQuestionService NewService(AppDbContext db, Guid teacherId, IClaudeQuestionGenerator generator)
        => new(db, TestCurrentUser.Teacher(teacherId), generator);

    private static async Task<User> SeedUserAsync(AppDbContext db, string email, UserRole role = UserRole.Teacher)
    {
        var user = new User { Email = email, PasswordHash = "x", DisplayName = email, Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    private static async Task<Lesson> SeedLessonAsync(AppDbContext db, Guid teacherId, int wordsWithTranslation)
    {
        var lesson = new Lesson { TeacherId = teacherId, Title = "Animals", Description = "Hayvanlar" };
        for (var i = 0; i < wordsWithTranslation; i++)
        {
            var word = new Word { Term = $"word{i}", SortOrder = i };
            word.Translations.Add(new WordTranslation { Text = $"çeviri{i}", IsPrimary = true });
            word.Synonyms.Add(new WordSynonym { Text = $"syn{i}" });
            lesson.Words.Add(word);
        }
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();
        return lesson;
    }

    /// <summary>İstenen sayıda geçerli (4 şık / 1 doğru) soru döndüren sahte üretici.</summary>
    private static GeneratedQuestionsResult ValidResult(int count, string type = "word_meaning")
    {
        var qs = new List<GeneratedQuestion>();
        for (var i = 0; i < count; i++)
        {
            qs.Add(new GeneratedQuestion(
                type,
                $"What is the meaning of word{i}?",
                "Açıklama",
                new List<GeneratedOption>
                {
                    new(0, "a", true),
                    new(1, "b", false),
                    new(2, "c", false),
                    new(3, "d", false),
                }));
        }
        return new GeneratedQuestionsResult(qs);
    }

    [Fact]
    public async Task Generate_Success_CreatesTeacherOwnedTopic_WithQuestionsAndOptions()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, "t@x.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, wordsWithTranslation: 5);
        var gen = new FakeGenerator { Results = { ValidResult(3) } };

        var dto = await NewService(db, teacher.Id, gen)
            .GenerateAsync(lesson.Id, grade: 5, count: 3, types: new[] { "word_meaning" });

        Assert.Equal(3, dto.Questions.Count);
        Assert.Equal(5, dto.Grade);
        Assert.Equal(lesson.Id, dto.LessonId);
        Assert.All(dto.Questions, q =>
        {
            Assert.Equal(4, q.Options.Count);
            Assert.Equal(1, q.Options.Count(o => o.IsCorrect));
            Assert.Equal("word_meaning", q.Type);
        });

        var topic = await db.QuestionTopics.SingleAsync();
        Assert.Equal(teacher.Id, topic.TeacherId);
        Assert.Equal(lesson.Id, topic.LessonId);
        Assert.Equal(5, topic.Grade);
        Assert.True(topic.IsActive);
        Assert.StartsWith("ai-", topic.Slug);
        Assert.Equal(3, await db.Questions.CountAsync());
        Assert.Equal(12, await db.QuestionOptions.CountAsync());
    }

    [Fact]
    public async Task Generate_NotLessonOwner_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, "t@x.com");
        var other = await SeedUserAsync(db, "o@x.com");
        var lesson = await SeedLessonAsync(db, other.Id, wordsWithTranslation: 5);
        var gen = new FakeGenerator { Results = { ValidResult(3) } };

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            NewService(db, teacher.Id, gen).GenerateAsync(lesson.Id, 5, 3, new[] { "word_meaning" }));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task Generate_NotEnoughWords_Throws400()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, "t@x.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, wordsWithTranslation: 3);
        var gen = new FakeGenerator { Results = { ValidResult(3) } };

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            NewService(db, teacher.Id, gen).GenerateAsync(lesson.Id, 5, 3, new[] { "word_meaning" }));
        Assert.Equal(400, ex.StatusCode);
    }

    [Theory]
    [InlineData(0)]
    [InlineData(11)]
    public async Task Generate_InvalidCount_Throws400(int count)
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, "t@x.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, wordsWithTranslation: 5);
        var gen = new FakeGenerator { Results = { ValidResult(3) } };

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            NewService(db, teacher.Id, gen).GenerateAsync(lesson.Id, 5, count, new[] { "word_meaning" }));
        Assert.Equal(400, ex.StatusCode);
    }

    [Fact]
    public async Task Generate_EmptyOrInvalidTypes_Throws400()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, "t@x.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, wordsWithTranslation: 5);
        var gen = new FakeGenerator { Results = { ValidResult(3) } };
        var svc = NewService(db, teacher.Id, gen);

        var empty = await Assert.ThrowsAsync<AppException>(() =>
            svc.GenerateAsync(lesson.Id, 5, 3, Array.Empty<string>()));
        Assert.Equal(400, empty.StatusCode);

        var invalid = await Assert.ThrowsAsync<AppException>(() =>
            svc.GenerateAsync(lesson.Id, 5, 3, new[] { "crossword" }));
        Assert.Equal(400, invalid.StatusCode);
    }

    [Fact]
    public async Task Generate_BadShape_RetriesOnce_ThenSucceeds()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, "t@x.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, wordsWithTranslation: 5);
        // İlk yanıt bozuk (2 doğru şık), ikinci yanıt geçerli → retry sonrası başarı.
        var broken = new GeneratedQuestionsResult(new List<GeneratedQuestion>
        {
            new("word_meaning", "stem", "açıklama", new List<GeneratedOption>
            {
                new(0, "a", true), new(1, "b", true), new(2, "c", false), new(3, "d", false),
            }),
        });
        var gen = new FakeGenerator { Results = { broken, ValidResult(1) } };

        var dto = await NewService(db, teacher.Id, gen).GenerateAsync(lesson.Id, 5, 1, new[] { "word_meaning" });

        Assert.Single(dto.Questions);
        Assert.Equal(2, gen.CallCount);
    }

    [Fact]
    public async Task Generate_BadShapeTwice_Throws400()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, "t@x.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, wordsWithTranslation: 5);
        // Yanlış soru sayısı (3 istendi, 1 döndü) iki kez → 400.
        var gen = new FakeGenerator { Results = { ValidResult(1), ValidResult(1) } };

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            NewService(db, teacher.Id, gen).GenerateAsync(lesson.Id, 5, 3, new[] { "word_meaning" }));
        Assert.Equal(400, ex.StatusCode);
        Assert.Equal(2, gen.CallCount);
        Assert.Equal(0, await db.QuestionTopics.CountAsync());
    }

    [Fact]
    public async Task DeleteQuestion_Owner_Returns204_RemovesQuestionAndOptions()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, "t@x.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, wordsWithTranslation: 5);
        var gen = new FakeGenerator { Results = { ValidResult(2) } };
        var svc = NewService(db, teacher.Id, gen);
        var dto = await svc.GenerateAsync(lesson.Id, 5, 2, new[] { "word_meaning" });
        var toDelete = dto.Questions[0].Id;

        await svc.DeleteQuestionAsync(dto.TopicId, toDelete);

        Assert.Equal(1, await db.Questions.CountAsync());
        Assert.False(await db.Questions.AnyAsync(q => q.Id == toDelete));
        Assert.Equal(4, await db.QuestionOptions.CountAsync());
    }

    [Fact]
    public async Task DeleteQuestion_OtherTeachersTopic_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, "t@x.com");
        var other = await SeedUserAsync(db, "o@x.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, wordsWithTranslation: 5);
        var gen = new FakeGenerator { Results = { ValidResult(2) } };
        var dto = await NewService(db, teacher.Id, gen).GenerateAsync(lesson.Id, 5, 2, new[] { "word_meaning" });

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            NewService(db, other.Id, gen).DeleteQuestionAsync(dto.TopicId, dto.Questions[0].Id));
        Assert.Equal(404, ex.StatusCode);
        Assert.Equal(2, await db.Questions.CountAsync());
    }

    /// <summary>Önceden sıralanmış sonuçları sırayla döndüren sahte üretici (ağ yok).</summary>
    private sealed class FakeGenerator : IClaudeQuestionGenerator
    {
        public List<GeneratedQuestionsResult> Results { get; } = new();
        public int CallCount { get; private set; }

        public Task<GeneratedQuestionsResult> GenerateAsync(
            QuestionGenerationInput input, CancellationToken cancellationToken = default)
        {
            var result = Results[Math.Min(CallCount, Results.Count - 1)];
            CallCount++;
            return Task.FromResult(result);
        }
    }
}
