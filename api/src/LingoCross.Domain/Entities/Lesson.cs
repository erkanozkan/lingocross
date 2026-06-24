using LingoCross.Domain.Common;
using LingoCross.Domain.Enums;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir öğretmenin oluşturduğu ders. Ders, kelimelerden oluşur ve yayımlandığında (is_published)
/// öğrencilerin erişimine açık hale gelir. Kaynak/hedef dil MVP'de varsayılan olarak en→tr'dir.
/// </summary>
public class Lesson : Entity
{
    public Guid TeacherId { get; set; }

    public User Teacher { get; set; } = null!;

    public string Title { get; set; } = string.Empty;

    public string? Description { get; set; }

    public string SourceLanguage { get; set; } = "en";

    public string TargetLanguage { get; set; } = "tr";

    /// <summary>Ders tarihi/haftası serbest metni (örn. "15-21 Temmuz 2024"). Opsiyonel.</summary>
    public string? ScheduledLabel { get; set; }

    /// <summary>Dersin yaşam döngüsü durumu (Draft/Active/Completed). Varsayılan Draft.</summary>
    public LessonStatus Status { get; set; } = LessonStatus.Draft;

    /// <summary>
    /// Öğrenci görünürlüğü bayrağı (DEĞİŞTİRİLMEZ kontrat). Active ve Completed durumlarında true,
    /// Draft'ta false. Erişim/listeleme mantığı bu bayrakla çalışmaya devam eder.
    /// </summary>
    public bool IsPublished { get; set; }

    public ICollection<Word> Words { get; set; } = new List<Word>();

    public ICollection<Game> Games { get; set; } = new List<Game>();
}
