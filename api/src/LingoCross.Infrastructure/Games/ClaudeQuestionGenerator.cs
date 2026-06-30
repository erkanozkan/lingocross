using System.Text;
using System.Text.Json;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Games;
using LingoCross.Infrastructure.Ocr;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace LingoCross.Infrastructure.Games;

/// <summary>
/// <see cref="IClaudeQuestionGenerator"/>'ı resmi Anthropic SDK (metin → yapılandırılmış JSON) ile uygular.
/// OCR ile aynı <see cref="IClaudeChatCompleter"/> soyutlamasını yeniden kullanır; testlerde sahte verilir.
/// Anahtar yapılandırılmamışsa veya sağlayıcı hatasında 503 (<see cref="AppException"/>) fırlatır.
/// </summary>
public class ClaudeQuestionGenerator : IClaudeQuestionGenerator
{
    private const long MaxTokens = 4000;

    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);

    private readonly IClaudeChatCompleter _completer;
    private readonly ILogger<ClaudeQuestionGenerator> _logger;

    public ClaudeQuestionGenerator(IConfiguration configuration, ILogger<ClaudeQuestionGenerator> logger)
        : this(new AnthropicChatCompleter(configuration["Anthropic:ApiKey"]), logger)
    {
    }

    // Test ve özel kurulum için: tamamlayıcı doğrudan verilir.
    internal ClaudeQuestionGenerator(IClaudeChatCompleter completer, ILogger<ClaudeQuestionGenerator> logger)
    {
        _completer = completer;
        _logger = logger;
    }

    public async Task<GeneratedQuestionsResult> GenerateAsync(
        QuestionGenerationInput input, CancellationToken cancellationToken = default)
    {
        if (!_completer.IsConfigured)
        {
            throw new AppException(503, "AI soru üretimi yapılandırılmamış.");
        }

        var systemPrompt = BuildSystemPrompt(input);
        var userContent = BuildUserContent(input);

        string json;
        try
        {
            json = await _completer.CompleteJsonFromTextAsync(
                systemPrompt, userContent, BuildSchema(), MaxTokens, cancellationToken);
        }
        catch (AppException)
        {
            throw;
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Claude AI soru üretimi çağrısı başarısız.");
            throw new AppException(503, "AI soru üretimi şu anda kullanılamıyor.");
        }

        return Parse(json);
    }

    private GeneratedQuestionsResult Parse(string json)
    {
        try
        {
            var payload = JsonSerializer.Deserialize<QuestionsPayload>(json, JsonOptions);
            var questions = (payload?.Questions ?? new List<QuestionPayload>())
                .Select(q => new GeneratedQuestion(
                    (q.Type ?? string.Empty).Trim(),
                    (q.Stem ?? string.Empty).Trim(),
                    string.IsNullOrWhiteSpace(q.Explanation) ? null : q.Explanation!.Trim(),
                    (q.Options ?? new List<OptionPayload>())
                        .Select(o => new GeneratedOption(o.Position, (o.Text ?? string.Empty).Trim(), o.IsCorrect))
                        .ToList()))
                .ToList();

            return new GeneratedQuestionsResult(questions);
        }
        catch (JsonException ex)
        {
            _logger.LogWarning(ex, "Claude AI soru yanıtı çözümlenemedi: {Json}", json);
            throw new AppException(503, "AI soru üretimi yanıtı çözümlenemedi.");
        }
    }

    private static string BuildSystemPrompt(QuestionGenerationInput input)
    {
        var typeLabel = string.Join(", ", input.Types);
        return $"""
            Sen İngilizce öğrenen öğrenciler için sınav sorusu yazan bir uzmansın. Sana verilen ders
            başlığı/açıklaması, sınıf düzeyi (grade), kelimeler ve seçili TÜR(LER)e göre, {input.Grade}.
            sınıf düzeyinde TAM {input.Count} çoktan seçmeli İngilizce soru üret.
            Türler — yalnız seçilenleri üret, birden çoksa dengeli dağıt: word_meaning (kelime anlamı),
            fill_blank (boşluk doldurma, cümlede --- ), synonym (eş anlam). Bu üretimde seçilen tür(ler):
            {typeLabel}.
            Her soru TAM 4 şık (A–D) ve TAM 1 doğru içermelidir. Sorular dersin kelimelerini/konusunu
            kapsasın; çeldiriciler makul olsun; zorluk grade'e uygun olsun. Soru kökü ve şıklar İngilizce,
            açıklama (explanation) TÜRKÇE olmalıdır. Yalnızca verilen JSON şemasına uy.
            """;
    }

    private static string BuildUserContent(QuestionGenerationInput input)
    {
        var sb = new StringBuilder();
        sb.AppendLine($"Ders başlığı: {input.LessonTitle}");
        if (!string.IsNullOrWhiteSpace(input.LessonDescription))
        {
            sb.AppendLine($"Ders açıklaması: {input.LessonDescription}");
        }

        sb.AppendLine($"Sınıf düzeyi: {input.Grade}");
        sb.AppendLine($"Üretilecek soru sayısı: {input.Count}");
        sb.AppendLine($"Seçili tür(ler): {string.Join(", ", input.Types)}");
        sb.AppendLine("Kelimeler (terim | çeviriler | eşanlamlar):");
        foreach (var w in input.Words)
        {
            var translations = string.Join(", ", w.Translations);
            var synonyms = string.Join(", ", w.Synonyms);
            sb.AppendLine($"- {w.Term} | {translations} | {synonyms}");
        }

        return sb.ToString();
    }

    private static Dictionary<string, JsonElement> BuildSchema() => new()
    {
        ["type"] = JsonSerializer.SerializeToElement("object"),
        ["additionalProperties"] = JsonSerializer.SerializeToElement(false),
        ["required"] = JsonSerializer.SerializeToElement(new[] { "questions" }),
        ["properties"] = JsonSerializer.SerializeToElement(new
        {
            questions = new
            {
                type = "array",
                items = new
                {
                    type = "object",
                    additionalProperties = false,
                    required = new[] { "type", "stem", "explanation", "options" },
                    properties = new
                    {
                        type = new
                        {
                            type = "string",
                            @enum = new[] { "word_meaning", "fill_blank", "synonym" },
                        },
                        stem = new { type = "string" },
                        explanation = new { type = "string", description = "Çözüm açıklaması (TÜRKÇE)." },
                        options = new
                        {
                            type = "array",
                            items = new
                            {
                                type = "object",
                                additionalProperties = false,
                                required = new[] { "position", "text", "isCorrect" },
                                properties = new
                                {
                                    position = new { type = "integer", description = "0–3 (A–D)." },
                                    text = new { type = "string" },
                                    isCorrect = new { type = "boolean" },
                                },
                            },
                        },
                    },
                },
            },
        }),
    };

    private sealed class QuestionsPayload
    {
        public List<QuestionPayload>? Questions { get; set; }
    }

    private sealed class QuestionPayload
    {
        public string? Type { get; set; }
        public string? Stem { get; set; }
        public string? Explanation { get; set; }
        public List<OptionPayload>? Options { get; set; }
    }

    private sealed class OptionPayload
    {
        public int Position { get; set; }
        public string? Text { get; set; }
        public bool IsCorrect { get; set; }
    }
}
