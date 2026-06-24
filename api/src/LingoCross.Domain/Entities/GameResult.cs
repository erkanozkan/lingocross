using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir oyun oturumunun tamamlanmış sonucu (süre + başarı). Oturum başına en fazla bir sonuç
/// olur (<see cref="SessionId"/> unique). Öğrenci sonucu isterse öğretmeniyle paylaşır
/// (<see cref="SharedWithTeacher"/>); öğretmen takip görünümü M6 kapsamındadır.
/// </summary>
public class GameResult : Entity
{
    /// <summary>Sonucun ait olduğu oyun oturumu (1-1, unique).</summary>
    public Guid SessionId { get; set; }

    public GameSession Session { get; set; } = null!;

    /// <summary>Oyunun süresi (milisaniye). İstemci tarafından ölçülüp gönderilir.</summary>
    public int DurationMs { get; set; }

    /// <summary>Oyundaki toplam eşleştirme (soru) sayısı.</summary>
    public int TotalItems { get; set; }

    /// <summary>Doğru eşleştirilen sayısı.</summary>
    public int CorrectItems { get; set; }

    /// <summary>Hesaplanan başarı puanı (0–100, doğruluk yüzdesi).</summary>
    public int Score { get; set; }

    /// <summary>Sonuç öğretmenle paylaşıldı mı.</summary>
    public bool SharedWithTeacher { get; set; }

    /// <summary>Paylaşıldıysa paylaşım zamanı, aksi halde null.</summary>
    public DateTime? SharedAt { get; set; }

    /// <summary>
    /// Sonucun kelime-bazlı kırılımı (F7.5). İstemci gönderirse doldurulur; eski sonuçlarda boş olur.
    /// </summary>
    public ICollection<GameResultItem> Items { get; set; } = new List<GameResultItem>();
}
