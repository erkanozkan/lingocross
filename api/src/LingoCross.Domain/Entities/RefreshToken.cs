using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Opaque refresh token. Yalnızca token'ın hash'i saklanır. Rotasyon zinciri
/// <see cref="ReplacedByTokenHash"/> üzerinden takip edilir; revoke edilmiş bir token
/// tekrar kullanılırsa tüm zincir iptal edilir (reuse-detection).
/// </summary>
public class RefreshToken : Entity
{
    public Guid UserId { get; set; }

    public User User { get; set; } = null!;

    public string TokenHash { get; set; } = string.Empty;

    public DateTime ExpiresAt { get; set; }

    public DateTime? RevokedAt { get; set; }

    public string? ReplacedByTokenHash { get; set; }

    public bool IsActive => RevokedAt is null && DateTime.UtcNow < ExpiresAt;
}
