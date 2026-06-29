using LingoCross.Application.Admin.Dtos;

namespace LingoCross.Application.Admin;

/// <summary>
/// Faz 2 — admin tarafından ÖSYM resmi soru bankasının (konu başlığı + sorular + şıklar) toplu, idempotent
/// import'u. Slug ile idempotent: aynı slug yeniden gönderilirse başlık güncellenir, soruları yeniden yazılır.
/// Doğrulama: her soru tam 5 şık + tam 1 doğru içermeli; aksi 400 ve hiçbir değişiklik yazılmaz (transaction).
/// </summary>
public interface IQuestionImportService
{
    Task<QuestionImportResultDto> ImportAsync(
        ImportQuestionTopicRequest request, CancellationToken cancellationToken = default);

    /// <summary>Yönetim listesi: tüm konu başlıkları (aktif/pasif), SortOrder/Title sırasıyla.</summary>
    Task<IReadOnlyList<AdminQuestionTopicDto>> ListTopicsAsync(CancellationToken cancellationToken = default);
}
