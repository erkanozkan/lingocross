namespace LingoCross.Application.QuestionBanks.Dtos;

/// <summary>Öğretmenin AI ile soru üretme isteği gövdesi (JSON camelCase: grade/count/types).</summary>
public record GenerateAiQuestionsRequest(int Grade, int Count, IReadOnlyList<string> Types);

/// <summary>
/// AI üretimi sonucu: kaydedilen teacher-owned <see cref="QuestionTopic"/> ve soruları. Review ekranı
/// bu DTO ile çalışır (silme için her soru/şık id taşır).
/// </summary>
public record AiQuestionsResultDto(
    Guid TopicId,
    string Title,
    int Grade,
    Guid LessonId,
    IReadOnlyList<AiQuestionDto> Questions);

public record AiQuestionDto(
    Guid Id,
    string Type,
    string Stem,
    string? Explanation,
    IReadOnlyList<AiQuestionOptionDto> Options);

public record AiQuestionOptionDto(
    Guid Id,
    int Position,
    string Text,
    bool IsCorrect);
