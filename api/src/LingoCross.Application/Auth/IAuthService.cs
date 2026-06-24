using LingoCross.Application.Auth.Dtos;

namespace LingoCross.Application.Auth;

/// <summary>Kimlik doğrulama iş akışları. Sahiplik/iş kuralları bu katmanda uygulanır.</summary>
public interface IAuthService
{
    Task<AuthResponse> RegisterAsync(RegisterRequest request, CancellationToken cancellationToken = default);

    Task<AuthResponse> LoginAsync(LoginRequest request, CancellationToken cancellationToken = default);

    Task<AuthResponse> RefreshAsync(RefreshRequest request, CancellationToken cancellationToken = default);

    Task LogoutAsync(LogoutRequest request, CancellationToken cancellationToken = default);

    /// <summary>Hesap olup olmadığını sızdırmaz; her zaman sessizce tamamlanır (controller 200 döner).</summary>
    Task ForgotPasswordAsync(ForgotPasswordRequest request, CancellationToken cancellationToken = default);

    Task ResetPasswordAsync(ResetPasswordRequest request, CancellationToken cancellationToken = default);

    Task<UserDto> GetMeAsync(Guid userId, CancellationToken cancellationToken = default);

    Task<UserDto> UpdateProfileAsync(Guid userId, UpdateProfileRequest request, CancellationToken cancellationToken = default);

    /// <summary>Mevcut şifreyi doğrular; başarılıysa şifreyi değiştirir, tüm refresh token'ları iptal eder ve yeni token çifti üretir.</summary>
    Task<AuthResponse> ChangePasswordAsync(Guid userId, ChangePasswordRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Kullanıcıyı ve ona ait TÜM verileri kalıcı olarak siler (Apple hesap silme zorunluluğu).
    /// Rolüne göre, restrict FK'ları ihlal etmeyecek doğru sırada açık silme yapar; bir transaction
    /// içinde çalışır. Kullanıcı yoksa <see cref="Common.Exceptions.AppException"/> (404) atar.
    /// </summary>
    Task DeleteAccountAsync(Guid userId, CancellationToken cancellationToken = default);
}
