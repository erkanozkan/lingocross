using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir kullanıcının push bildirim tercihleri (kullanıcı başına tek kayıt — <see cref="UserId"/> UNIQUE).
/// <see cref="Master"/> kapalıysa hiçbir bildirim gönderilmez; açıksa tür bazlı bayraklar uygulanır.
/// Kayıt yoksa varsayılanlar kullanılır (Master/Assigned/Reminder/Results = true, Announcements = false).
/// </summary>
public class NotificationPreference : Entity
{
    public Guid UserId { get; set; }

    public User? User { get; set; }

    /// <summary>Ana anahtar: kapalıysa kullanıcıya hiç bildirim gönderilmez.</summary>
    public bool Master { get; set; } = true;

    /// <summary>Yeni ödev (oyun) atandığında bildir.</summary>
    public bool Assigned { get; set; } = true;

    /// <summary>Hatırlatma bildirimleri.</summary>
    public bool Reminder { get; set; } = true;

    /// <summary>Öğrenci sonucu paylaştığında (öğretmene) bildir.</summary>
    public bool Results { get; set; } = true;

    /// <summary>Genel duyurular (varsayılan kapalı).</summary>
    public bool Announcements { get; set; } = false;
}
