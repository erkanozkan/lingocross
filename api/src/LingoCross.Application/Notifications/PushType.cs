namespace LingoCross.Application.Notifications;

/// <summary>
/// Bir push bildiriminin türü. Her tür, kullanıcının <c>NotificationPreference</c> üzerindeki
/// karşılık gelen bayrağıyla filtrelenir (Master kapalıysa tümü atlanır).
/// </summary>
public enum PushType
{
    /// <summary>Yeni ödev (oyun) atandı.</summary>
    Assigned,

    /// <summary>Hatırlatma.</summary>
    Reminder,

    /// <summary>Öğrenci sonucu paylaştı.</summary>
    Results,

    /// <summary>Genel duyuru.</summary>
    Announcements,
}
