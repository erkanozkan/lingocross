using LingoCross.Domain.Common;
using LingoCross.Domain.Enums;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir derse ait tek bir kelime/terim (kaynak dilde). Çevirileri ve eşanlamlıları alt
/// koleksiyonlarda tutulur. Ders silindiğinde kelimeler de cascade ile silinir.
/// </summary>
public class Word : Entity
{
    public Guid LessonId { get; set; }

    public Lesson Lesson { get; set; } = null!;

    public string Term { get; set; } = string.Empty;

    /// <summary>Ders içindeki sıralama (öğretmenin düzenlediği listede).</summary>
    public int SortOrder { get; set; }

    public WordSource Source { get; set; } = WordSource.Manual;

    public ICollection<WordTranslation> Translations { get; set; } = new List<WordTranslation>();

    public ICollection<WordSynonym> Synonyms { get; set; } = new List<WordSynonym>();
}
