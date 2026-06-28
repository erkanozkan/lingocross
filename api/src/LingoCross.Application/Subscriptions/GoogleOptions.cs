namespace LingoCross.Application.Subscriptions;

/// <summary>
/// appsettings/ortam değişkenlerindeki "Google" bölümüne bağlanan Google Play IAP ayarları.
/// <para>
/// Mimari notu: <see cref="AppleOptions"/> ile aynı gerekçeyle POCO Application'da yer alır;
/// binding (Configure) Infrastructure'ın DI'ında yapılır. Makbuz doğrulayıcı (Infrastructure) ve
/// abonelik servisi (Application) bu ayarları okur. Ürün kimlikleri Apple ile ORTAKTIR
/// (<see cref="AppleOptions.MonthlyProductId"/> / <see cref="AppleOptions.AnnualProductId"/>).
/// </para>
/// </summary>
public class GoogleOptions
{
    public const string SectionName = "Google";

    /// <summary>
    /// Google Cloud servis hesabı anahtarının TAM JSON içeriği (Android Publisher API erişimi için).
    /// Boş/null ise IAP yapılandırılmamış sayılır ve <c>google/verify</c> 503 döner.
    /// Env: <c>Google__ServiceAccountJson</c>.
    /// </summary>
    public string? ServiceAccountJson { get; set; }

    /// <summary>
    /// Uygulamanın Android paket adı (ör. <c>com.lingocross.lingo_cross_app</c>). Android Publisher
    /// abonelik sorgusu bu paket adıyla yapılır. Boş/null ise IAP yapılandırılmamış sayılır.
    /// Env: <c>Google__PackageName</c>.
    /// </summary>
    public string? PackageName { get; set; }
}
