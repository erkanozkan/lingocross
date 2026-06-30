using System.Text.Json;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Games;
using LingoCross.Application.QuestionBanks;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Games;
using LingoCross.Infrastructure.Ocr;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging.Abstractions;

namespace LingoCross.Tests.QuestionBanks;

/// <summary>
/// ClaudeQuestionGenerator: sahte completer'ın döndürdüğü JSON metni doğru şekilde
/// <see cref="GeneratedQuestionsResult"/>'a ayrıştırılır ve AiQuestionService ile uçtan uca QuestionTopic'e döner.
/// Anahtar yoksa 503. Ağ yoktur.
/// </summary>
public class ClaudeQuestionGeneratorTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"aiqgen-{Guid.NewGuid()}")
            .Options);

    private const string ValidJson = """
        {
          "questions": [
            {
              "type": "word_meaning",
              "stem": "What does 'cat' mean?",
              "explanation": "Kedi anlamına gelir.",
              "options": [
                { "position": 0, "text": "kedi", "isCorrect": true },
                { "position": 1, "text": "köpek", "isCorrect": false },
                { "position": 2, "text": "kuş", "isCorrect": false },
                { "position": 3, "text": "balık", "isCorrect": false }
              ]
            }
          ]
        }
        """;

    [Fact]
    public async Task Generator_ParsesJson_IntoResult()
    {
        var gen = new ClaudeQuestionGenerator(new FakeCompleter { Json = ValidJson }, NullLogger<ClaudeQuestionGenerator>.Instance);

        var result = await gen.GenerateAsync(new QuestionGenerationInput(
            "Animals", "Hayvanlar", 5, 1, new[] { "word_meaning" },
            new[] { new QuestionGenerationWord("cat", new[] { "kedi" }, new[] { "feline" }) }));

        var q = Assert.Single(result.Questions);
        Assert.Equal("word_meaning", q.Type);
        Assert.Equal(4, q.Options.Count);
        Assert.Equal(1, q.Options.Count(o => o.IsCorrect));
    }

    [Fact]
    public async Task Generator_NotConfigured_Throws503()
    {
        var gen = new ClaudeQuestionGenerator(new FakeCompleter { IsConfigured = false }, NullLogger<ClaudeQuestionGenerator>.Instance);

        var ex = await Assert.ThrowsAsync<AppException>(() => gen.GenerateAsync(new QuestionGenerationInput(
            "Animals", null, 5, 1, new[] { "word_meaning" },
            new[] { new QuestionGenerationWord("cat", new[] { "kedi" }, Array.Empty<string>()) })));
        Assert.Equal(503, ex.StatusCode);
    }

    [Fact]
    public async Task Service_WithRealGeneratorAndFakeCompleter_EndToEnd_CreatesTopic()
    {
        var db = NewDb();
        var teacher = new User { Email = "t@x.com", PasswordHash = "x", DisplayName = "T", Role = UserRole.Teacher };
        db.Users.Add(teacher);
        var lesson = new Lesson { TeacherId = teacher.Id, Title = "Animals" };
        for (var i = 0; i < 4; i++)
        {
            var word = new Word { Term = $"w{i}", SortOrder = i };
            word.Translations.Add(new WordTranslation { Text = $"ç{i}", IsPrimary = true });
            lesson.Words.Add(word);
        }
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();

        var gen = new ClaudeQuestionGenerator(new FakeCompleter { Json = ValidJson }, NullLogger<ClaudeQuestionGenerator>.Instance);
        var svc = new AiQuestionService(db, TestCurrentUser.Teacher(teacher.Id), gen);

        var dto = await svc.GenerateAsync(lesson.Id, 5, 1, new[] { "word_meaning" });

        Assert.Single(dto.Questions);
        Assert.Equal(teacher.Id, (await db.QuestionTopics.SingleAsync()).TeacherId);
    }

    /// <summary>Metin yolu için JSON döndüren sahte completer.</summary>
    private sealed class FakeCompleter : IClaudeChatCompleter
    {
        public bool IsConfigured { get; set; } = true;
        public string Json { get; set; } = "{\"questions\":[]}";

        public Task<string> CompleteJsonFromImageAsync(
            string systemPrompt, string imageBase64, string mediaType,
            Dictionary<string, JsonElement> schema, long maxTokens, CancellationToken cancellationToken)
            => throw new NotImplementedException();

        public Task<string> CompleteJsonFromTextAsync(
            string systemPrompt, string userContent,
            Dictionary<string, JsonElement> schema, long maxTokens, CancellationToken cancellationToken)
            => Task.FromResult(Json);
    }
}
