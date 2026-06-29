using LingoCross.Application.Games.Dtos;
using LingoCross.Application.QuestionBanks.Dtos;

namespace LingoCross.Application.QuestionBanks;

/// <summary>
/// Faz 2 — "Çıkmış Sorular" konu başlıklarının öğretmen tarafından listelenmesi ve sınıflara atanması.
/// Sorular GLOBAL'dir (derse bağlı değil); öğretmen yalnız bir başlığı kendi sınıf(lar)ına atar.
/// QuestionSet oyunu konu başlığı başına idempotent bir <c>Game</c> kaydıyla temsil edilir.
/// Erişim/sahiplik kuralları bu katmanda uygulanır (yalnız öğretmen; yalnız kendi sınıfları).
/// </summary>
public interface IQuestionBankService
{
    /// <summary>
    /// Atanabilir (IsActive) konu başlıklarını SortOrder/Title sırasıyla listeler. Yalnız öğretmen.
    /// </summary>
    Task<IReadOnlyList<QuestionTopicSummaryDto>> ListTopicsAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Bir konu başlığını SET semantiğiyle öğretmenin sınıf(lar)ına atar: başlık başına idempotent bir
    /// QuestionSet <c>Game</c> upsert edilir, ardından mevcut atama mantığı (set semantiği) uygulanır.
    /// Yalnız öğretmen; başlık aktif değilse/yoksa 404; sınıf öğretmene ait değilse 404.
    /// </summary>
    Task<GameAssignmentsDto> SetTopicAssignmentsAsync(
        Guid topicId, IReadOnlyList<Guid> classIds, CancellationToken cancellationToken = default);

    /// <summary>
    /// Bir konu başlığının (QuestionSet oyununun) atandığı sınıf kimliklerini döndürür. Yalnız öğretmen;
    /// başlık yoksa 404. Henüz hiç atama yoksa boş liste döner.
    /// </summary>
    Task<GameAssignmentsDto> GetTopicAssignmentsAsync(Guid topicId, CancellationToken cancellationToken = default);
}
