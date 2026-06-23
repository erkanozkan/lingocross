using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Tek kullanımlık şifre sıfırlama token'ı. Yalnızca hash saklanır; ~30dk geçerlidir.
/// </summary>
public class PasswordResetToken : Entity
{
    public Guid UserId { get; set; }

    public User User { get; set; } = null!;

    public string TokenHash { get; set; } = string.Empty;

    public DateTime ExpiresAt { get; set; }

    public DateTime? UsedAt { get; set; }

    public bool IsUsable => UsedAt is null && DateTime.UtcNow < ExpiresAt;
}
