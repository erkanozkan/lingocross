using LingoCross.Application.Admin;
using LingoCross.Application.Admin.Dtos;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.QuestionBanks;

/// <summary>
/// Faz 2 — QuestionImportService: slug ile idempotent upsert (tam-yenileme), 5 şık / 1 doğru doğrulaması
/// ve geçersiz gövdede hiçbir değişiklik yazılmaması (doğrulama yazımdan önce → no-op transaction'da bile güvenli).
/// </summary>
public class QuestionImportServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"qimport-{Guid.NewGuid()}")
            .Options);

    private static ImportQuestionOptionDto[] FiveOptions(int correctPosition = 0) =>
        Enumerable.Range(0, 5)
            .Select(p => new ImportQuestionOptionDto(p, $"Şık {p}", p == correctPosition))
            .ToArray();

    private static ImportQuestionDto Question(string stem, int correctPosition = 0) =>
        new(stem, Explanation: "açıklama", SourceRef: "ref", Options: FiveOptions(correctPosition));

    private static ImportQuestionTopicRequest Request(string slug, params ImportQuestionDto[] questions) =>
        new(slug, "YDS 2020", "açıklama", IsActive: true, SortOrder: 1, Questions: questions);

    [Fact]
    public async Task Import_NewTopic_CreatesTopicQuestionsAndOptions()
    {
        var db = NewDb();
        var svc = new QuestionImportService(db);

        var result = await svc.ImportAsync(Request("yds-2020", Question("S1"), Question("S2", correctPosition: 3)));

        Assert.Equal("yds-2020", result.Slug);
        Assert.Equal(2, result.QuestionCount);
        Assert.Equal(1, await db.QuestionTopics.CountAsync());
        Assert.Equal(2, await db.Questions.CountAsync());
        Assert.Equal(10, await db.QuestionOptions.CountAsync());
        // Doğru şık pozisyonları korunur.
        var topic = await db.QuestionTopics.Include(t => t.Questions).ThenInclude(q => q.Options).SingleAsync();
        var s2 = topic.Questions.Single(q => q.Stem == "S2");
        Assert.True(s2.Options.Single(o => o.IsCorrect).Position == 3);
    }

    [Fact]
    public async Task Import_SameSlugTwice_IsIdempotent_ReplacesQuestions()
    {
        var db = NewDb();
        var svc = new QuestionImportService(db);

        await svc.ImportAsync(Request("yds-2020", Question("S1"), Question("S2"), Question("S3")));
        await svc.ImportAsync(Request("yds-2020", Question("Yeni")));

        // Tek başlık (slug eşsiz) + tam-yenileme (eski 3 soru gider, yeni 1 kalır).
        Assert.Equal(1, await db.QuestionTopics.CountAsync());
        Assert.Equal(1, await db.Questions.CountAsync());
        Assert.Equal(5, await db.QuestionOptions.CountAsync());
        var only = await db.Questions.SingleAsync();
        Assert.Equal("Yeni", only.Stem);
    }

    [Fact]
    public async Task Import_QuestionWithFourOptions_Throws400_NoWrite()
    {
        var db = NewDb();
        var svc = new QuestionImportService(db);

        var bad = new ImportQuestionDto("Bozuk", null, null,
            Enumerable.Range(0, 4).Select(p => new ImportQuestionOptionDto(p, $"o{p}", p == 0)).ToArray());

        var ex = await Assert.ThrowsAsync<AppException>(() => svc.ImportAsync(Request("yds-bad", bad)));
        Assert.Equal(400, ex.StatusCode);
        Assert.Equal(0, await db.QuestionTopics.CountAsync());
        Assert.Equal(0, await db.Questions.CountAsync());
    }

    [Fact]
    public async Task Import_QuestionWithNoCorrect_Throws400()
    {
        var db = NewDb();
        var svc = new QuestionImportService(db);

        var bad = new ImportQuestionDto("Bozuk", null, null,
            Enumerable.Range(0, 5).Select(p => new ImportQuestionOptionDto(p, $"o{p}", false)).ToArray());

        var ex = await Assert.ThrowsAsync<AppException>(() => svc.ImportAsync(Request("yds-bad", bad)));
        Assert.Equal(400, ex.StatusCode);
    }

    [Fact]
    public async Task Import_QuestionWithTwoCorrect_Throws400()
    {
        var db = NewDb();
        var svc = new QuestionImportService(db);

        var bad = new ImportQuestionDto("Bozuk", null, null,
            Enumerable.Range(0, 5).Select(p => new ImportQuestionOptionDto(p, $"o{p}", p < 2)).ToArray());

        var ex = await Assert.ThrowsAsync<AppException>(() => svc.ImportAsync(Request("yds-bad", bad)));
        Assert.Equal(400, ex.StatusCode);
    }

    [Fact]
    public async Task Import_DuplicatePositions_Throws400()
    {
        var db = NewDb();
        var svc = new QuestionImportService(db);

        // Pozisyonlar benzersiz değil (0,0,1,2,3).
        var opts = new[]
        {
            new ImportQuestionOptionDto(0, "a", true),
            new ImportQuestionOptionDto(0, "b", false),
            new ImportQuestionOptionDto(1, "c", false),
            new ImportQuestionOptionDto(2, "d", false),
            new ImportQuestionOptionDto(3, "e", false),
        };
        var bad = new ImportQuestionDto("Bozuk", null, null, opts);

        var ex = await Assert.ThrowsAsync<AppException>(() => svc.ImportAsync(Request("yds-bad", bad)));
        Assert.Equal(400, ex.StatusCode);
    }

    [Fact]
    public async Task Import_NoQuestions_Throws400()
    {
        var db = NewDb();
        var svc = new QuestionImportService(db);

        var ex = await Assert.ThrowsAsync<AppException>(() => svc.ImportAsync(Request("yds-empty")));
        Assert.Equal(400, ex.StatusCode);
    }

    [Fact]
    public async Task ListTopics_ReturnsAll_WithCounts()
    {
        var db = NewDb();
        var svc = new QuestionImportService(db);
        await svc.ImportAsync(Request("yds-a", Question("S1"), Question("S2")));
        await svc.ImportAsync(new ImportQuestionTopicRequest("yds-b", "Pasif", null, IsActive: false, SortOrder: 2, Questions: new[] { Question("X") }));

        var list = await svc.ListTopicsAsync();

        Assert.Equal(2, list.Count);
        var a = list.Single(t => t.Slug == "yds-a");
        Assert.Equal(2, a.QuestionCount);
        Assert.True(a.IsActive);
        Assert.False(list.Single(t => t.Slug == "yds-b").IsActive);
    }
}
