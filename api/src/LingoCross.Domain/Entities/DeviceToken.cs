using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir kullanıcının cihazına ait push bildirim (FCM) kayıt token'ı. Aynı token aynı anda yalnız
/// bir kullanıcıya bağlı olabilir (<see cref="Token"/> UNIQUE); kullanıcı silinince cihazları da silinir.
/// </summary>
public class DeviceToken : Entity
{
    public Guid UserId { get; set; }

    public User? User { get; set; }

    /// <summary>FCM kayıt token'ı (cihaz başına benzersiz).</summary>
    public string Token { get; set; } = string.Empty;

    /// <summary>Cihaz platformu: "ios" veya "android".</summary>
    public string Platform { get; set; } = string.Empty;
}
