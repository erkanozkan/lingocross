namespace LingoCross.Infrastructure.Auth;

/// <summary>appsettings/ortam değişkenlerindeki "Jwt" bölümüne bağlanan ayarlar.</summary>
public class JwtOptions
{
    public const string SectionName = "Jwt";

    public string Secret { get; set; } = string.Empty;

    public string Issuer { get; set; } = "lingocross";

    public string Audience { get; set; } = "lingocross";

    public int AccessTokenMinutes { get; set; } = 15;

    public int RefreshTokenDays { get; set; } = 30;
}
