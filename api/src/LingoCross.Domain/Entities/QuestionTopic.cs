using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir çoktan seçmeli soru bankası başlığı. İki kaynaktan gelir:
/// (1) GLOBAL "Çıkmış Sorular" (ör. "YDS 2020 İlkbahar") — <see cref="TeacherId"/> null, admin import eder;
/// (2) Öğretmen AI üretimi — <see cref="TeacherId"/> dolu, bir derse (<see cref="LessonId"/>) ve sınıf
/// düzeyine (<see cref="Grade"/>) dayanır. Öğretmen bir başlığı sınıfa atar; öğrenci o bankadan sorular çözer.
/// </summary>
public class QuestionTopic : Entity
{
    /// <summary>Başlığın görünen adı (ör. "YDS 2020 İlkbahar").</summary>
    public string Title { get; set; } = string.Empty;

    /// <summary>
    /// Sahip öğretmen. Null = GLOBAL (YDS vb. admin import). Dolu = öğretmenin AI ile ürettiği özel set;
    /// yalnız o öğretmen listeler/atar/silebilir.
    /// </summary>
    public Guid? TeacherId { get; set; }

    /// <summary>AI üretimi için temel alınan ders (opsiyonel). Global başlıklarda null.</summary>
    public Guid? LessonId { get; set; }

    /// <summary>AI üretiminde hedeflenen sınıf düzeyi (1–12). Global başlıklarda null.</summary>
    public int? Grade { get; set; }

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
