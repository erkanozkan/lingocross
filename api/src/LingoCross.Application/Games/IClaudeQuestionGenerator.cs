namespace LingoCross.Application.Games;

/// <summary>
/// Öğretmenin AI ile çoktan seçmeli sınav sorusu üretmesi için soyut üretici. Mevcut Anthropic
/// completer'ı yeniden kullanır (metin → JSON). Anahtar yapılandırılmamışsa 503 (AppException) fırlatır.
/// Implementasyon Infrastructure katmanındadır; testler sahte implementasyon verir (ağ yok).
/// </summary>
public interface IClaudeQuestionGenerator
{
    /// <summary>
    /// Verilen ders bağlamı ve seçili türlere göre TAM <paramref name="count"/> çoktan seçmeli soru üretir.
    /// Çıktı doğrulaması (şık/doğru sayısı, tür) çağıran servise aittir.
    /// </summary>
    Task<GeneratedQuestionsResult> GenerateAsync(
        QuestionGenerationInput input, CancellationToken cancellationToken = default);
}

/// <summary>AI üretimi için ders bağlamı + parametreler.</summary>
public sealed record QuestionGenerationInput(
    string LessonTitle,
    string? LessonDescription,
    int Grade,
    int Count,
    IReadOnlyList<string> Types,
    IReadOnlyList<QuestionGenerationWord> Words);

/// <summary>Üretimde bağlam olarak verilen tek bir kelime (terim + çeviriler + eşanlamlar).</summary>
public sealed record QuestionGenerationWord(
    string Term,
    IReadOnlyList<string> Translations,
    IReadOnlyList<string> Synonyms);

/// <summary>AI üretici ham çıktısı (henüz doğrulanmamış).</summary>
public sealed record GeneratedQuestionsResult(IReadOnlyList<GeneratedQuestion> Questions);

public sealed record GeneratedQuestion(
    string Type,
    string Stem,
    string? Explanation,
    IReadOnlyList<GeneratedOption> Options);

public sealed record GeneratedOption(int Position, string Text, bool IsCorrect);
