using LingoCross.Domain.Common;
using LingoCross.Domain.Enums;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir derse ait, kelimelerinden üretilen oyun. MVP'de tür yalnızca
/// <see cref="GameType.WordMatching"/>'tir. İçerik (eşleştirme çiftleri/çeldiriciler) oturum
/// başlatılırken dersin güncel kelimelerinden türetilir; burada saklanmaz. Ders silindiğinde
/// cascade ile silinir.
///
/// F2.2: Oyun öğretmen tarafından açıkça oluşturulup yayımlanır. Yayımlanmış (<see cref="IsPublished"/>)
/// bir oyun, öğretmenin Active eşleşmeli öğrencilerine atanmış sayılır (ayrı atama tablosu yoktur,
/// enrollment'tan türetilir).
/// </summary>
public class Game : Entity
{
    public Guid LessonId { get; set; }

    public Lesson Lesson { get; set; } = null!;

    public GameType Type { get; set; } = GameType.WordMatching;

    public string Title { get; set; } = string.Empty;

    /// <summary>
    /// Oyun öğrencilere atanmış (oynanabilir) mı? Öğretmen oyunu oluşturup yayımladığında true olur.
    /// Yayımlanmamış oyun yalnız sahibi öğretmene listelenir; öğrenci başlatamaz.
    /// </summary>
    public bool IsPublished { get; set; }

    /// <summary>Oyunun yayımlandığı an (UTC); yayımlanmamışsa null.</summary>
    public DateTime? PublishedAt { get; set; }

    public ICollection<GameSession> Sessions { get; set; } = new List<GameSession>();

    /// <summary>Bu oyunun atandığı sınıflar (F4.3).</summary>
    public ICollection<GameAssignment> Assignments { get; set; } = new List<GameAssignment>();
}
