using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Faz 2 — bir konu başlığına ait çoktan seçmeli (ÖSYM A–E) soru. Şıklar ÖSYM sırasında
/// (<see cref="QuestionOption.Position"/> 0–4 → A–E) saklanır ve KARIŞTIRILMAZ; tam bir şık doğrudur.
/// </summary>
public class Question : Entity
{
    public Guid QuestionTopicId { get; set; }

    public QuestionTopic QuestionTopic { get; set; } = null!;

    /// <summary>Soru kökü (gövde).</summary>
    public string Stem { get; set; } = string.Empty;

    /// <summary>Opsiyonel çözüm açıklaması (öğrenciye rapor/inceleme aşamasında gösterilebilir).</summary>
    public string? Explanation { get; set; }

    /// <summary>Banka içindeki kanonik sıra (import sırası); listeleme/teşhis için.</summary>
    public int Ordinal { get; set; }

    /// <summary>Opsiyonel kaynak referansı (ör. "2020 İlkbahar / Soru 12").</summary>
    public string? SourceRef { get; set; }

    public ICollection<QuestionOption> Options { get; set; } = new List<QuestionOption>();
}
