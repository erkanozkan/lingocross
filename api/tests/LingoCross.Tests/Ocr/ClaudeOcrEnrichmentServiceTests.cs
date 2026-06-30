using System.Text.Json;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Ocr.Dtos;
using LingoCross.Infrastructure.Ocr;
using Microsoft.Extensions.Logging.Abstractions;

namespace LingoCross.Tests.Ocr;

/// <summary>
/// ClaudeOcrEnrichmentService akışları: anahtar yokken 503, sahte Claude JSON yanıtının
/// DTO'ya doğru eşlenmesi (boş/whitespace ayıklama, trim), bozuk JSON'da 503 ve sağlayıcı
/// hatasının 503'e çevrilmesi. Girdi artık base64 görüntüdür; gerçek ağ/Claude çağrısı yapılmaz.
/// </summary>
public class ClaudeOcrEnrichmentServiceTests
{
    // Tipik küçük base64 örneği (içerik önemsiz; sahte completer çağrıyı yapmaz).
    private const string SampleImage = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==";

    private static ClaudeOcrEnrichmentService Build(IClaudeChatCompleter completer)
        => new(completer, NullLogger<ClaudeOcrEnrichmentService>.Instance);

    private static OcrEnrichRequest Request(string image = SampleImage, string mediaType = "image/png")
        => new(image, mediaType, "en", "tr");

    [Fact]
    public async Task Enrich_WhenNotConfigured_Throws503()
    {
        var service = Build(new FakeCompleter { IsConfigured = false });

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.EnrichAsync(Request()));

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

        var result = await service.EnrichAsync(Request());

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

        var result = await service.EnrichAsync(Request());

        var word = Assert.Single(result.Words);
        Assert.Equal("book", word.Term);
        Assert.Equal(new[] { "tome" }, word.Synonyms);
    }

    [Fact]
    public async Task Enrich_PassesSystemPromptImageMediaTypeAndSchema()
    {
        var fake = new FakeCompleter { Json = "{\"words\":[]}" };
        var service = Build(fake);

        await service.EnrichAsync(new OcrEnrichRequest(SampleImage, "image/jpeg", "en", "tr"));

        Assert.Equal(SampleImage, fake.LastImageBase64);
        Assert.Equal("image/jpeg", fake.LastMediaType);
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
            service.EnrichAsync(Request()));

        Assert.Equal(503, ex.StatusCode);
    }

    [Fact]
    public async Task Enrich_WhenCompleterThrows_Translated503()
    {
        var service = Build(new FakeCompleter { Throw = new HttpRequestException("network down") });

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.EnrichAsync(Request()));

        Assert.Equal(503, ex.StatusCode);
    }

    private sealed class FakeCompleter : IClaudeChatCompleter
    {
        public bool IsConfigured { get; set; } = true;
        public string Json { get; set; } = "{\"words\":[]}";
        public Exception? Throw { get; set; }

        public string? LastSystemPrompt { get; private set; }
        public string? LastImageBase64 { get; private set; }
        public string? LastMediaType { get; private set; }
        public Dictionary<string, JsonElement>? LastSchema { get; private set; }

        public Task<string> CompleteJsonFromImageAsync(
            string systemPrompt,
            string imageBase64,
            string mediaType,
            Dictionary<string, JsonElement> schema,
            long maxTokens,
            CancellationToken cancellationToken)
        {
            LastSystemPrompt = systemPrompt;
            LastImageBase64 = imageBase64;
            LastMediaType = mediaType;
            LastSchema = schema;

            if (Throw is not null)
            {
                throw Throw;
            }

            return Task.FromResult(Json);
        }

        // Bu fake yalnız görüntü yolunu test eder; metin yolu kullanılmaz.
        public Task<string> CompleteJsonFromTextAsync(
            string systemPrompt,
            string userContent,
            Dictionary<string, JsonElement> schema,
            long maxTokens,
            CancellationToken cancellationToken)
            => throw new NotImplementedException();
    }
}
