namespace LingoCross.Application.Common.Email;

/// <summary>
/// "Gmail" bölümüne bağlanan e-posta gönderim ayarları (Gmail API, HTTPS).
/// <para>
/// Railway giden SMTP portlarını (25/465/587) bloklar; bu yüzden e-posta SMTP yerine
/// Gmail API üzerinden (HTTPS/443) gönderilir. Google Workspace servis hesabı
/// <see cref="ServiceAccountJson"/> ile RS256 imzalı JWT üretip <see cref="SenderEmail"/>
/// kullanıcısını impersonate eder (Workspace Admin'de domain-wide delegation +
/// <c>gmail.send</c> scope gerekir). Boşsa geliştirme için log stub'ı kullanılır.
/// </para>
/// </summary>
public class GmailOptions
{
    public const string SectionName = "Gmail";

    /// <summary>Google servis hesabı anahtarı (JSON). Play doğrulamasıyla aynı SA olabilir
    /// (yeter ki o SA'ya gmail.send domain-wide delegation verilmiş olsun).</summary>
    public string ServiceAccountJson { get; set; } = string.Empty;

    /// <summary>Gönderen / impersonate edilen Workspace kullanıcısı (ör. support@duocross.com).</summary>
    public string SenderEmail { get; set; } = string.Empty;

    /// <summary>Gönderen görünen adı.</summary>
    public string FromName { get; set; } = "LingoCross";

    /// <summary>Gerçek Gmail API gönderimi için yeterli ayar mevcut mu?</summary>
    public bool IsConfigured =>
        !string.IsNullOrWhiteSpace(ServiceAccountJson)
        && !string.IsNullOrWhiteSpace(SenderEmail);
}
