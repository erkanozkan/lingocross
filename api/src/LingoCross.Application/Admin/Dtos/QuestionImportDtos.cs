namespace LingoCross.Application.Admin.Dtos;

/// <summary>
/// Faz 2 — admin "Çıkmış Sorular" toplu import gövdesi (ÖSYM resmi JSON; scraping YOK). Slug ile
/// idempotenttir: aynı slug yeniden gönderilirse başlık güncellenir ve soruları yeniden yazılır.
/// </summary>
public record ImportQuestionTopicRequest(
    string Slug,
    string Title,
    string? Description,
    bool IsActive,
    int SortOrder,
    IReadOnlyList<ImportQuestionDto> Questions);

/// <summary>İçe aktarılan tek bir soru. Tam 5 şık + tam 1 doğru zorunludur (aksi 400).</summary>
public record ImportQuestionDto(
    string Stem,
    string? Explanation,
    string? SourceRef,
    IReadOnlyList<ImportQuestionOptionDto> Options);

/// <summary>
/// İçe aktarılan tek bir şık. <see cref="Position"/> ÖSYM sırasıdır (0–4 → A–E); şıklar bu sıraya göre
/// saklanır ve KARIŞTIRILMAZ. <see cref="IsCorrect"/> soru başına tam bir kez true olmalıdır.
/// </summary>
public record ImportQuestionOptionDto(
    int Position,
    string Text,
    bool IsCorrect);

/// <summary>Import sonucu: işlenen başlık + oluşturulan/güncellenen soru sayısı.</summary>
public record QuestionImportResultDto(
    Guid TopicId,
    string Slug,
    int QuestionCount);

/// <summary>Admin yönetim listesinde bir konu başlığı (aktif/pasif dahil) + soru sayısı.</summary>
public record AdminQuestionTopicDto(
    Guid Id,
    string Slug,
    string Title,
    string? Description,
    bool IsActive,
    int SortOrder,
    int QuestionCount);
