using LingoCross.Application.Subscriptions.Dtos;

namespace LingoCross.Application.Subscriptions;

/// <summary>
/// Abonelik durumu okuma + stub (sahte) satın alma/iptal akışı. GERÇEK ÖDEME YOKTUR; stub uçları
/// yalnızca <c>SubscriptionOptions.StubEnabled</c> true iken çalışır, aksi halde 503 döner.
/// Apple IAP doğrulaması ileriye dönük dikiştir (S3).
/// </summary>
public interface ISubscriptionService
{
    /// <summary>Geçerli kullanıcının abonelik durumunu döndürür; satır yoksa Free DTO döner.</summary>
    Task<SubscriptionDto> GetMineAsync(CancellationToken cancellationToken = default);

    /// <summary>STUB: geçerli kullanıcı için premium aboneliği etkinleştirir (upsert). StubEnabled false ise 503.</summary>
    Task<SubscriptionDto> ActivateStubAsync(ActivateStubRequest request, CancellationToken cancellationToken = default);

    /// <summary>STUB: geçerli kullanıcının aboneliğini iptal eder (Free'ye düşer). StubEnabled false ise 503.</summary>
    Task<SubscriptionDto> CancelAsync(CancellationToken cancellationToken = default);
}
