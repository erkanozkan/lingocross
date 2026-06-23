using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir kelimenin hedef dildeki çevirisi. Bir kelimenin birden çok çevirisi olabilir; biri
/// <see cref="IsPrimary"/> olarak işaretlenir. Kelime silindiğinde cascade ile silinir.
/// </summary>
public class WordTranslation : Entity
{
    public Guid WordId { get; set; }

    public Word Word { get; set; } = null!;

    public string Text { get; set; } = string.Empty;

    public bool IsPrimary { get; set; }
}
