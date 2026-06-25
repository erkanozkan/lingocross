namespace LingoCross.Application.Admin;

/// <summary>
/// appsettings/ortam değişkenlerindeki "Admin" bölümüne bağlanan ayarlar (back office tek-admin girişi).
/// Email/Password boşsa admin girişi devre dışıdır (servis 503 döner). Üretimde yalnızca env ile verilir
/// (<c>Admin__Email</c>, <c>Admin__Password</c>). Tek admin olduğundan kullanıcı tablosuna dokunulmaz.
/// </summary>
public class AdminOptions
{
    public const string SectionName = "Admin";

    /// <summary>Tek admin e-postası. Boşsa admin girişi kapalıdır.</summary>
    public string Email { get; set; } = string.Empty;

    /// <summary>Tek admin parolası (düz metin; env ile verilir). Boşsa admin girişi kapalıdır.</summary>
    public string Password { get; set; } = string.Empty;

    /// <summary>Admin access token'ının saat cinsinden ömrü.</summary>
    public int TokenHours { get; set; } = 8;
}
