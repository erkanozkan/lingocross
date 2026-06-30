using System.Text.Json;
using Anthropic;
using Anthropic.Core;
using Anthropic.Models.Messages;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Ocr;
using LingoCross.Application.Ocr.Dtos;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace LingoCross.Infrastructure.Ocr;

/// <summary>
/// <see cref="IOcrEnrichmentService"/>'i resmi Anthropic C# SDK (model: claude-haiku-4-5,
/// vision + yapılandırılmış JSON çıktısı) ile uygular. Cihaz-içi OCR yerine görüntünün kendisi
/// (base64) doğrudan Claude'a gönderilir; böylece el yazısı yanlış okumaları model tarafından
/// yorumlanır. API anahtarı yoksa veya sağlayıcı/ağ hatası olursa 503 (<see cref="AppException"/>)
/// fırlatır; mobil istemci yerel ayrıştırmaya düşer.
///
/// Asıl SDK çağrısı <see cref="IClaudeChatCompleter"/> arkasına alınmıştır; böylece servis,
/// gerçek ağ çağrısı yapmadan test edilebilir.
/// </summary>
public class ClaudeOcrEnrichmentService : IOcrEnrichmentService
{
    private const long MaxTokens = 2000;

    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);

    private readonly IClaudeChatCompleter _completer;
    private readonly ILogger<ClaudeOcrEnrichmentService> _logger;

    public ClaudeOcrEnrichmentService(IConfiguration configuration, ILogger<ClaudeOcrEnrichmentService> logger)
        : this(new AnthropicChatCompleter(configuration["Anthropic:ApiKey"]), logger)
    {
    }

    // Test ve özel kurulum için: tamamlayıcı doğrudan verilir.
    internal ClaudeOcrEnrichmentService(IClaudeChatCompleter completer, ILogger<ClaudeOcrEnrichmentService> logger)
    {
        _completer = completer;
        _logger = logger;
    }

    public async Task<OcrEnrichResponse> EnrichAsync(OcrEnrichRequest request, CancellationToken cancellationToken = default)
    {
        if (!_completer.IsConfigured)
        {
            throw new AppException(503, "OCR zenginleştirme yapılandırılmamış.");
        }

        var systemPrompt = BuildSystemPrompt(request.SourceLanguage, request.TargetLanguage);

        string json;
        try
        {
            json = await _completer.CompleteJsonFromImageAsync(
                systemPrompt,
                request.ImageBase64,
                request.MediaType,
                BuildSchema(request.SourceLanguage, request.TargetLanguage),
                MaxTokens,
                cancellationToken);
        }
        catch (AppException)
        {
            throw;
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Claude OCR zenginleştirme çağrısı başarısız.");
            throw new AppException(503, "OCR zenginleştirme şu anda kullanılamıyor.");
        }

        return Parse(json);
    }

    private OcrEnrichResponse Parse(string json)
    {
        try
        {
            var payload = JsonSerializer.Deserialize<EnrichPayload>(json, JsonOptions);
            var words = (payload?.Words ?? new List<WordPayload>())
                .Where(w => !string.IsNullOrWhiteSpace(w.Term))
                .Select(w => new EnrichedWord(
                    w.Term!.Trim(),
                    (w.Meaning ?? string.Empty).Trim(),
                    (w.Synonyms ?? new List<string>())
                        .Where(s => !string.IsNullOrWhiteSpace(s))
                        .Select(s => s.Trim())
                        .ToList()))
                .ToList();

            return new OcrEnrichResponse(words);
        }
        catch (JsonException ex)
        {
            _logger.LogWarning(ex, "Claude OCR yanıtı çözümlenemedi: {Json}", json);
            throw new AppException(503, "OCR zenginleştirme yanıtı çözümlenemedi.");
        }
    }

    private static string BuildSystemPrompt(string sourceLanguage, string targetLanguage)
        => $"""
            Sen bir dil öğretmeni asistanısın. Sana bir öğretmenin kâğıda (çoğu zaman EL YAZISIYLA)
            yazdığı bir kelime listesinin görüntüsü verilecek. Görevlerin:
            1) Görüntüyü dikkatle oku; el yazısını ve olası belirsizlikleri bağlama göre yorumla.
            2) Her satırı bir kaynak dil terimi ('{sourceLanguage}') ile hedef dil karşılığına
               ('{targetLanguage}') ayır. Satırda sıra fark etmez; hangisinin '{sourceLanguage}'
               hangisinin '{targetLanguage}' olduğunu dile göre belirle. 'term' alanına
               '{sourceLanguage}' terimini, 'meaning' alanına '{targetLanguage}' karşılığını yaz.
            3) Her kelime için 1-2 eşanlam üret. 'synonyms' alanı HER ZAMAN terimin
               ('term', kaynak dil = '{sourceLanguage}') eşanlamlarını içerir; yani eşanlamlar
               '{sourceLanguage}' dilinde yazılır — '{targetLanguage}' (meaning) dilinde DEĞİL.
               Örneğin '{sourceLanguage}' = İngilizce ise eşanlamlar İngilizce olmalıdır.
               Uygun eşanlam yoksa boş liste döndür.
            Yalnızca verilen JSON şemasına uygun çıktı üret. Okunamayan/anlamsız satırları atla.
            """;

    private static Dictionary<string, JsonElement> BuildSchema(string sourceLanguage, string targetLanguage) => new()
    {
        ["type"] = JsonSerializer.SerializeToElement("object"),
        ["additionalProperties"] = JsonSerializer.SerializeToElement(false),
        ["required"] = JsonSerializer.SerializeToElement(new[] { "words" }),
        ["properties"] = JsonSerializer.SerializeToElement(new
        {
            words = new
            {
                type = "array",
                items = new
                {
                    type = "object",
                    additionalProperties = false,
                    required = new[] { "term", "meaning", "synonyms" },
                    properties = new
                    {
                        term = new
                        {
                            type = "string",
                            description = $"The source-language ('{sourceLanguage}') term.",
                        },
                        meaning = new
                        {
                            type = "string",
                            description = $"The target-language ('{targetLanguage}') translation of the term.",
                        },
                        synonyms = new
                        {
                            type = "array",
                            items = new { type = "string" },
                            description = $"1-2 synonyms of the source-language term ('term'), written in the source language ('{sourceLanguage}'). These are NOT translations and must NOT be in the target language ('{targetLanguage}'). For example, if the source language is English, these synonyms must be English words. Empty list if none.",
                        },
                    },
                },
            },
        }),
    };

    private sealed class EnrichPayload
    {
        public List<WordPayload>? Words { get; set; }
    }

    private sealed class WordPayload
    {
        public string? Term { get; set; }
        public string? Meaning { get; set; }
        public List<string>? Synonyms { get; set; }
    }
}

/// <summary>
/// Anthropic SDK çağrısını soyutlayan iç arayüz. Servis bu arayüze bağlanır; gerçek
/// implementasyon SDK'yı sarar (görüntü içerik bloğu + talimat), testler sahte verir.
/// </summary>
internal interface IClaudeChatCompleter
{
    bool IsConfigured { get; }

    Task<string> CompleteJsonFromImageAsync(
        string systemPrompt,
        string imageBase64,
        string mediaType,
        Dictionary<string, JsonElement> schema,
        long maxTokens,
        CancellationToken cancellationToken);

    /// <summary>
    /// Metin tabanlı yapılandırılmış JSON üretimi: sistem prompt + kullanıcı metni → verilen JSON şemasına
    /// uyan tek metin bloğu. AI soru üretiminde kullanılır.
    /// </summary>
    Task<string> CompleteJsonFromTextAsync(
        string systemPrompt,
        string userContent,
        Dictionary<string, JsonElement> schema,
        long maxTokens,
        CancellationToken cancellationToken);
}

/// <summary>Anthropic resmi C# SDK üzerinden çalışan gerçek tamamlayıcı (vision).</summary>
internal sealed class AnthropicChatCompleter : IClaudeChatCompleter
{
    private readonly string? _apiKey;
    private readonly Lazy<AnthropicClient> _client;

    public AnthropicChatCompleter(string? apiKey)
    {
        _apiKey = apiKey;
        _client = new Lazy<AnthropicClient>(() => new AnthropicClient(new ClientOptions { ApiKey = _apiKey }));
    }

    public bool IsConfigured => !string.IsNullOrWhiteSpace(_apiKey);

    public async Task<string> CompleteJsonFromImageAsync(
        string systemPrompt,
        string imageBase64,
        string mediaType,
        Dictionary<string, JsonElement> schema,
        long maxTokens,
        CancellationToken cancellationToken)
    {
        // Görüntü içerik bloğu: base64 kaynak + (varsa) kısa metin talimatı tek mesaj içinde.
        var imageBlock = new ImageBlockParam
        {
            Source = new Base64ImageSource
            {
                Data = imageBase64,
                MediaType = ToMediaType(mediaType),
            },
        };
        var instructionBlock = new TextBlockParam(
            "Bu görüntüdeki kelime listesini oku ve verilen JSON şemasına göre çıkar.");

        var content = new List<ContentBlockParam> { imageBlock, instructionBlock };

        var parameters = new MessageCreateParams
        {
            Model = Model.ClaudeHaiku4_5,
            MaxTokens = maxTokens,
            System = systemPrompt,
            OutputConfig = new OutputConfig
            {
                Format = new JsonOutputFormat { Schema = schema },
            },
            Messages = [new MessageParam { Role = Role.User, Content = content }],
        };

        var response = await _client.Value.Messages.Create(parameters, cancellationToken);

        // Yapılandırılmış çıktıda ilk metin bloğu geçerli JSON içerir.
        var text = response.Content
            .Select(b => b.Value)
            .OfType<TextBlock>()
            .Select(t => t.Text)
            .FirstOrDefault();

        if (string.IsNullOrWhiteSpace(text))
        {
            throw new InvalidOperationException("Claude yanıtında metin bloğu bulunamadı.");
        }

        return text;
    }

    public async Task<string> CompleteJsonFromTextAsync(
        string systemPrompt,
        string userContent,
        Dictionary<string, JsonElement> schema,
        long maxTokens,
        CancellationToken cancellationToken)
    {
        var parameters = new MessageCreateParams
        {
            Model = Model.ClaudeHaiku4_5,
            MaxTokens = maxTokens,
            System = systemPrompt,
            OutputConfig = new OutputConfig
            {
                Format = new JsonOutputFormat { Schema = schema },
            },
            Messages = [new MessageParam { Role = Role.User, Content = userContent }],
        };

        var response = await _client.Value.Messages.Create(parameters, cancellationToken);

        var text = response.Content
            .Select(b => b.Value)
            .OfType<TextBlock>()
            .Select(t => t.Text)
            .FirstOrDefault();

        if (string.IsNullOrWhiteSpace(text))
        {
            throw new InvalidOperationException("Claude yanıtında metin bloğu bulunamadı.");
        }

        return text;
    }

    private static MediaType ToMediaType(string mediaType) => mediaType switch
    {
        "image/png" => Anthropic.Models.Messages.MediaType.ImagePng,
        _ => Anthropic.Models.Messages.MediaType.ImageJpeg,
    };
}
