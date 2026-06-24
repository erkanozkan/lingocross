using LingoCross.Domain.Common;
using LingoCross.Domain.Enums;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir kullanıcının premium abonelik satırı. Free kullanıcıların satırı yoktur (veya
/// <see cref="SubscriptionStatus.None"/>). Kullanıcı başına en fazla bir satır bulunur
/// (<c>UserId</c> benzersizdir). Premium çözümü "lazy-expiry"dir: durum Active/Trial olsa bile
/// <see cref="ExpiresAt"/> geçmişse premium sayılmaz (bkz. EntitlementService).
/// </summary>
public class Subscription : Entity
{
    /// <summary>Aboneliğin sahibi kullanıcı (benzersiz).</summary>
    public Guid UserId { get; set; }

    public User User { get; set; } = null!;

    public SubscriptionPlan Plan { get; set; }

    public SubscriptionStatus Status { get; set; }

    /// <summary>Aylık/yıllık dönem; trial veya henüz dönemi belirlenmemiş satırlar için null.</summary>
    public SubscriptionPeriod? Period { get; set; }

    public SubscriptionSource Source { get; set; }

    public DateTime StartedAt { get; set; }

    /// <summary>Bitiş zamanı; sonsuz/atanmamış için null. Geçmişse abonelik premium sayılmaz.</summary>
    public DateTime? ExpiresAt { get; set; }

    /// <summary>
    /// IAP dikişi (S3): mağaza işlem kimliği. Şimdilik kullanılmaz, ileride Apple/Google için tutulur.
    /// </summary>
    public string? StoreTransactionId { get; set; }

    /// <summary>
    /// IAP dikişi (S3): en son makbuz/abonelik referansı. Şimdilik kullanılmaz.
    /// </summary>
    public string? LatestReceiptRef { get; set; }
}
