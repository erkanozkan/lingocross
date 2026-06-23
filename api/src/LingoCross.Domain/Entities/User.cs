using LingoCross.Domain.Common;
using LingoCross.Domain.Enums;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Uygulama kullanıcısı (öğretmen veya öğrenci). Kimlik doğrulama kendi JWT akışımızla yapılır;
/// ASP.NET Identity kullanılmaz.
/// </summary>
public class User : Entity
{
    public string Email { get; set; } = string.Empty;

    public string PasswordHash { get; set; } = string.Empty;

    public string DisplayName { get; set; } = string.Empty;

    public UserRole Role { get; set; }

    public string PreferredLocale { get; set; } = "tr";

    /// <summary>Öğretmenlerin öğrenci davet kodu; öğrenciler için null.</summary>
    public string? InviteCode { get; set; }

    public ICollection<RefreshToken> RefreshTokens { get; set; } = new List<RefreshToken>();

    public ICollection<PasswordResetToken> PasswordResetTokens { get; set; } = new List<PasswordResetToken>();
}
