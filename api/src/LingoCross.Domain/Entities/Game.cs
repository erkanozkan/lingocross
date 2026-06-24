using LingoCross.Domain.Common;
using LingoCross.Domain.Enums;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir derse ait, kelimelerinden üretilen oyun. MVP'de tür yalnızca
/// <see cref="GameType.WordMatching"/>'tir. İçerik (eşleştirme çiftleri/çeldiriciler) oturum
/// başlatılırken dersin güncel kelimelerinden türetilir; burada saklanmaz. Ders silindiğinde
/// cascade ile silinir.
/// </summary>
public class Game : Entity
{
    public Guid LessonId { get; set; }

    public Lesson Lesson { get; set; } = null!;

    public GameType Type { get; set; } = GameType.WordMatching;

    public string Title { get; set; } = string.Empty;

    public ICollection<GameSession> Sessions { get; set; } = new List<GameSession>();
}
