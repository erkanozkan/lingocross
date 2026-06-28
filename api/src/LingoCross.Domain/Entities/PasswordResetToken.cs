using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Tek kullanımlık şifre sıfırlama kodu. Yalnızca 6 haneli kodun hash'i saklanır; ~15dk geçerlidir.
/// </summary>
public class PasswordResetToken : Entity
{
    public Guid UserId { get; set; }

    public User User { get; set; } = null!;

    public string TokenHash { get; set; } = string.Empty;

    public DateTime ExpiresAt { get; set; }

    public DateTime? UsedAt { get; set; }

    /// <summary>Yanlış kod deneme sayacı; 5'e ulaşınca kod geçersiz kılınır (brute-force koruması).</summary>
    public int Attempts { get; set; }

    public bool IsUsable => UsedAt is null && DateTime.UtcNow < ExpiresAt;
}
