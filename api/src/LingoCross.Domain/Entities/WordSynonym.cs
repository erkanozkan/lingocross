using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir kelimenin (kaynak dildeki) eşanlamlısı. Kelime silindiğinde cascade ile silinir.
/// </summary>
public class WordSynonym : Entity
{
    public Guid WordId { get; set; }

    public Word Word { get; set; } = null!;

    public string Text { get; set; } = string.Empty;
}
