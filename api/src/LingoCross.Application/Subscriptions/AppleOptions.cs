using LingoCross.Domain.Enums;

namespace LingoCross.Application.Subscriptions;

/// <summary>
/// appsettings/ortam değişkenlerindeki "Apple" bölümüne bağlanan App Store IAP ayarları.
/// <para>
/// Mimari notu: <see cref="SubscriptionOptions"/> ile aynı gerekçeyle POCO Application'da yer alır;
/// binding (Configure) Infrastructure'ın DI'ında yapılır. Makbuz doğrulayıcı (Infrastructure) ve
/// abonelik servisi (Application) bu ayarları okur.
/// </para>
/// </summary>
public class AppleOptions
{
    public const string SectionName = "Apple";

    /// <summary>
    /// App Store Connect'ten alınan paylaşılan sır (auto-renewable abonelik makbuz doğrulaması için).
    /// Boş/null ise IAP yapılandırılmamış sayılır ve <c>apple/verify</c> 503 döner.
    /// Env: <c>Apple__SharedSecret</c>.
    /// </summary>
    public string? SharedSecret { get; set; }

    /// <summary>
    /// Uygulamanın bundle kimliği (ör. <c>com.lingocross.app</c>). Doluysa makbuzdaki
    /// <c>receipt.bundle_id</c> ile eşleşmeyen makbuzlar geçersiz sayılır. Env: <c>Apple__BundleId</c>.
    /// </summary>
    public string? BundleId { get; set; }

    /// <summary>Aylık premium aboneliğin App Store ürün kimliği.</summary>
    public const string MonthlyProductId = "com.lingocross.premium.monthly";

    /// <summary>Yıllık premium aboneliğin App Store ürün kimliği.</summary>
    public const string AnnualProductId = "com.lingocross.premium.yearly";

    /// <summary>Bizim tanıdığımız (premium) ürün kimliklerinin tamamı.</summary>
    public static readonly IReadOnlyCollection<string> KnownProductIds = new[]
    {
        MonthlyProductId,
        AnnualProductId,
    };

    /// <summary>Verilen ürün kimliği bizim tanıdığımız premium ürünlerden biri mi?</summary>
    public static bool IsKnownProduct(string? productId) =>
        productId is not null && KnownProductIds.Contains(productId);

    /// <summary>
    /// App Store ürün kimliğini abonelik dönemine çevirir. Tanınmayan ürün için <c>null</c>.
    /// </summary>
    public static SubscriptionPeriod? MapPeriod(string? productId) => productId switch
    {
        MonthlyProductId => SubscriptionPeriod.Monthly,
        AnnualProductId => SubscriptionPeriod.Annual,
        _ => null,
    };
}
