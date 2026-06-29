namespace LingoCross.Application.QuestionBanks.Dtos;

/// <summary>
/// Faz 2 — öğretmene atanabilir aktif bir konu başlığının özeti. <see cref="QuestionCount"/> bankadaki
/// soru sayısıdır (öğretmen, bir oturumda 10 sorunun rastgele seçileceğini bu sayıdan görür).
/// </summary>
public record QuestionTopicSummaryDto(
    Guid Id,
    string Title,
    string? Description,
    int QuestionCount);
