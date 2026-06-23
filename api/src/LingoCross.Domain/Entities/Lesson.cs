using LingoCross.Domain.Common;

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

    public bool IsPublished { get; set; }

    public ICollection<Word> Words { get; set; } = new List<Word>();
}
