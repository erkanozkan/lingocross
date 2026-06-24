using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir oyun sonucunun tek bir kelime-bazlı kalemi (F7.5). Öğrencinin hangi kelimeyi doğru/yanlış
/// yaptığını ve verdiği cevabı saklar; öğretmen sonuç-detay görünümünde kullanılır. Bir sonuca
/// (<see cref="ResultId"/>) bağlıdır; sonuç silindiğinde cascade ile silinir. <see cref="Ordinal"/>
/// oyundaki kalem sırasını verir.
/// </summary>
public class GameResultItem : Entity
{
    /// <summary>Kalemin ait olduğu oyun sonucu.</summary>
    public Guid ResultId { get; set; }

    public GameResult? Result { get; set; }

    /// <summary>Oyundaki kalem sırası (0 tabanlı).</summary>
    public int Ordinal { get; set; }

    /// <summary>Sorulan terim (ör. İngilizce kelime).</summary>
    public string Term { get; set; } = null!;

    /// <summary>Beklenen doğru cevap (ör. Türkçe karşılık).</summary>
    public string ExpectedAnswer { get; set; } = null!;

    /// <summary>Öğrencinin verdiği cevap; boş bırakıldıysa null.</summary>
    public string? StudentAnswer { get; set; }

    /// <summary>Öğrencinin cevabı doğru muydu.</summary>
    public bool IsCorrect { get; set; }
}
