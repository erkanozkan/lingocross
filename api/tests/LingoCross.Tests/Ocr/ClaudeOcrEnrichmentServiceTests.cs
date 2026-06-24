using System.Text.Json;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Ocr.Dtos;
using LingoCross.Infrastructure.Ocr;
using Microsoft.Extensions.Logging.Abstractions;

namespace LingoCross.Tests.Ocr;

/// <summary>
/// ClaudeOcrEnrichmentService akışları: anahtar yokken 503, sahte Claude JSON yanıtının
/// DTO'ya doğru eşlenmesi (boş/whitespace ayıklama, trim), bozuk JSON'da 503 ve sağlayıcı
/// hatasının 503'e çevrilmesi. Gerçek ağ/Claude çağrısı yapılmaz.
/// </summary>
public class ClaudeOcrEnrichmentServiceTests
{
    private static ClaudeOcrEnrichmentService Build(IClaudeChatCompleter completer)
        => new(completer, NullLogger<ClaudeOcrEnrichmentService>.Instance);

    [Fact]
    public async Task Enrich_WhenNotConfigured_Throws503()
    {
        var service = Build(new FakeCompleter { IsConfigured = false });

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.EnrichAsync(new OcrEnrichRequest("happy mutlu")));

        Assert.Equal(503, ex.StatusCode);
    }

    [Fact]
    public async Task Enrich_WithValidJson_MapsToDto()
    {
        const string json = """
            {
              "words": [
                { "term": " happy ", "meaning": " mutlu ", "synonyms": [" glad ", "joyful"] },
                { "term": "sad", "meaning": "üzgün", "synonyms": [] }
              ]
            }
            """;
        var service = Build(new FakeCompleter { Json = json });

        var result = await service.EnrichAsync(new OcrEnrichRequest("happy mutlu\nsad üzgün"));

        Assert.Equal(2, result.Words.Count);

        var happy = result.Words[0];
        Assert.Equal("happy", happy.Term);   // trim uygulanır
        Assert.Equal("mutlu", happy.Meaning);
        Assert.Equal(new[] { "glad", "joyful" }, happy.Synonyms);

        var sad = result.Words[1];
        Assert.Equal("sad", sad.Term);
        Assert.Empty(sad.Synonyms);
    }

    [Fact]
    public async Task Enrich_SkipsEmptyTerms_AndBlankSynonyms()
    {
        const string json = """
            {
              "words": [
                { "term": "", "meaning": "boş", "synonyms": ["x"] },
                { "term": "book", "meaning": "kitap", "synonyms": ["", "  ", "tome"] }
              ]
            }
            """;
        var service = Build(new FakeCompleter { Json = json });

        var result = await service.EnrichAsync(new OcrEnrichRequest("book kitap"));

        var word = Assert.Single(result.Words);
        Assert.Equal("book", word.Term);
        Assert.Equal(new[] { "tome" }, word.Synonyms);
    }

    [Fact]
    public async Task Enrich_PassesSystemPromptUserTextAndSchema()
    {
        var fake = new FakeCompleter { Json = "{\"words\":[]}" };
        var service = Build(fake);

        await service.EnrichAsync(new OcrEnrichRequest("raw text here", "en", "tr"));

        Assert.Equal("raw text here", fake.LastUserText);
        Assert.Contains("en", fake.LastSystemPrompt);
        Assert.Contains("tr", fake.LastSystemPrompt);
        Assert.NotNull(fake.LastSchema);
        Assert.True(fake.LastSchema!.ContainsKey("properties"));
    }

    [Fact]
    public async Task Enrich_WhenJsonInvalid_Throws503()
    {
        var service = Build(new FakeCompleter { Json = "not-json{" });

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.EnrichAsync(new OcrEnrichRequest("happy mutlu")));

        Assert.Equal(503, ex.StatusCode);
    }

    [Fact]
    public async Task Enrich_WhenCompleterThrows_Translated503()
    {
        var service = Build(new FakeCompleter { Throw = new HttpRequestException("network down") });

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.EnrichAsync(new OcrEnrichRequest("happy mutlu")));

        Assert.Equal(503, ex.StatusCode);
    }

    private sealed class FakeCompleter : IClaudeChatCompleter
    {
        public bool IsConfigured { get; set; } = true;
        public string Json { get; set; } = "{\"words\":[]}";
        public Exception? Throw { get; set; }

        public string? LastSystemPrompt { get; private set; }
        public string? LastUserText { get; private set; }
        public Dictionary<string, JsonElement>? LastSchema { get; private set; }

        public Task<string> CompleteJsonAsync(
            string systemPrompt,
            string userText,
            Dictionary<string, JsonElement> schema,
            long maxTokens,
            CancellationToken cancellationToken)
        {
            LastSystemPrompt = systemPrompt;
            LastUserText = userText;
            LastSchema = schema;

            if (Throw is not null)
            {
                throw Throw;
            }

            return Task.FromResult(Json);
        }
    }
}
