namespace LingoCross.Application.Subscriptions;

/// <summary>
/// App Store makbuzunu Apple'ın <c>verifyReceipt</c> ucu ile doğrular. Implementasyon
/// Infrastructure'dadır; Application servisi yalnızca bu arayüze bağlanır (ve testte sahte verilir).
/// </summary>
public interface IAppleReceiptVerifier
{
    /// <summary>
    /// Base64 makbuz verisini Apple ile doğrular. Geçersiz/tanınmayan makbuz veya sağlayıcı hatası
    /// durumunda <see cref="AppleVerifyResult.IsValid"/> false döner (istisna fırlatmaz).
    /// </summary>
    Task<AppleVerifyResult> VerifyAsync(string receiptData, CancellationToken cancellationToken = default);
}

/// <summary>
/// Makbuz doğrulamasının sonucu. Geçerliyse bizim tanıdığımız (premium) ürünlerden en geç biten
/// satın almanın bilgileri doldurulur.
/// </summary>
/// <param name="IsValid">Makbuz Apple tarafından doğrulandı ve bilinen bir premium ürün içeriyor mu.</param>
/// <param name="ProductId">Doğrulanan App Store ürün kimliği (en geç biten satın alma).</param>
/// <param name="ExpiresAt">Aboneliğin bitiş zamanı (UTC).</param>
/// <param name="OriginalTransactionId">Satın almanın özgün işlem kimliği (mağaza işlem referansı).</param>
/// <param name="RawError">Geçersizse Apple'ın <c>status</c> kodu veya kısa hata açıklaması (teşhis için).</param>
public record AppleVerifyResult(
    bool IsValid,
    string? ProductId,
    DateTimeOffset? ExpiresAt,
    string? OriginalTransactionId,
    string? RawError);
