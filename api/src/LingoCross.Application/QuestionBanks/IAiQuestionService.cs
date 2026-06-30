using LingoCross.Application.QuestionBanks.Dtos;

namespace LingoCross.Application.QuestionBanks;

/// <summary>
/// Öğretmenin bir dersi temel alıp AI'dan çoktan seçmeli sınav sorusu ürettirmesi. Sonuç teacher-owned
/// bir <c>QuestionTopic</c> olarak kaydolur; mevcut atama/çözüm/sonuç altyapısını (QuestionSet) kullanır.
/// Erişim/sahiplik kuralları bu katmanda uygulanır (yalnız öğretmen; yalnız kendi dersi/topic'i).
/// </summary>
public interface IAiQuestionService
{
    /// <summary>
    /// <paramref name="lessonId"/> dersinden AI ile <paramref name="count"/> adet (1–10) çoktan seçmeli
    /// soru üretir ve teacher-owned bir başlık olarak kaydeder. Ders sahibi değil → 404; ders çevirili
    /// kelime &lt; 4 → 400; geçersiz count/types → 400; AI çıktısı doğrulamayı geçemezse (1 retry sonrası) 400.
    /// </summary>
    Task<AiQuestionsResultDto> GenerateAsync(
        Guid lessonId, int grade, int count, IReadOnlyList<string> types, CancellationToken cancellationToken = default);

    /// <summary>
    /// Bir AI başlığından tek bir soruyu (şıklarıyla cascade) siler. Başlık sahibi değilse 404. 204 döner.
    /// </summary>
    Task DeleteQuestionAsync(Guid topicId, Guid questionId, CancellationToken cancellationToken = default);
}
