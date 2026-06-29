using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Faz 2 — "Çıkmış Sorular" konu başlığı (ör. "YDS 2020 İlkbahar"). Sorular GLOBAL'dir ve bir derse
/// değil, bir konu başlığına bağlanır. Öğretmen bir başlığı sınıfa atar; öğrenci o bankadan rastgele
/// sorular çözer. Başlıklar yalnızca admin tarafından (ÖSYM resmi JSON import) oluşturulur/güncellenir.
/// </summary>
public class QuestionTopic : Entity
{
    /// <summary>Başlığın görünen adı (ör. "YDS 2020 İlkbahar").</summary>
    public string Title { get; set; } = string.Empty;

    /// <summary>İdempotent import + URL için benzersiz makine-okunur anahtar (ör. "yds-2020-ilkbahar").</summary>
    public string Slug { get; set; } = string.Empty;

    /// <summary>Opsiyonel açıklama (kaynak/kapsam notu).</summary>
    public string? Description { get; set; }

    /// <summary>Atanabilir/listelenebilir mi? Pasif başlıklar öğretmene gösterilmez.</summary>
    public bool IsActive { get; set; } = true;

    /// <summary>Listeleme sırası (artan).</summary>
    public int SortOrder { get; set; }

    public ICollection<Question> Questions { get; set; } = new List<Question>();
}
