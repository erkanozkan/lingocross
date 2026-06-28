namespace LingoCross.Application.Subscriptions;

/// <summary>
/// Google Play satın alma jetonunu (purchaseToken) Android Publisher API'nin <c>subscriptionsv2</c>
/// ucu ile doğrular. Implementasyon Infrastructure'dadır; Application servisi yalnızca bu arayüze
/// bağlanır (ve testte sahte verilir).
/// </summary>
public interface IGoogleReceiptVerifier
{
    /// <summary>
    /// Satın alma jetonunu Google ile doğrular. Geçersiz/tanınmayan jeton veya sağlayıcı hatası
    /// durumunda <see cref="GoogleVerifyResult.IsValid"/> false döner (istisna fırlatmaz).
    /// </summary>
    Task<GoogleVerifyResult> VerifyAsync(string purchaseToken, string productId, CancellationToken cancellationToken = default);
}

/// <summary>
/// Google Play makbuz doğrulamasının sonucu. Geçerliyse bizim tanıdığımız (premium) ürünlerden
/// ilgili satın almanın bilgileri doldurulur.
/// </summary>
/// <param name="IsValid">Jeton Google tarafından doğrulandı ve bilinen bir premium ürün içeriyor mu.</param>
/// <param name="ProductId">Doğrulanan Google Play ürün kimliği.</param>
/// <param name="ExpiresAt">Aboneliğin bitiş zamanı (UTC).</param>
/// <param name="OriginalTransactionId">Satın almanın mağaza işlem referansı (latestOrderId veya jeton).</param>
/// <param name="RawError">Geçersizse abonelik durumu veya kısa hata açıklaması (teşhis için).</param>
public record GoogleVerifyResult(
    bool IsValid,
    string? ProductId,
    DateTimeOffset? ExpiresAt,
    string? OriginalTransactionId,
    string? RawError);
