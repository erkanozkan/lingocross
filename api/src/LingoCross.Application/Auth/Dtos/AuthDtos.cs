using LingoCross.Domain.Enums;

namespace LingoCross.Application.Auth.Dtos;

public record RegisterRequest(string Email, string Password, string DisplayName, UserRole Role);

public record LoginRequest(string Email, string Password);

public record RefreshRequest(string RefreshToken);

public record LogoutRequest(string RefreshToken);

public record ForgotPasswordRequest(string Email);

public record ResetPasswordRequest(string Email, string Code, string NewPassword);

public record UpdateProfileRequest(string DisplayName, string? PreferredLocale = null);

public record ChangePasswordRequest(string CurrentPassword, string NewPassword);

/// <summary>Giriş/kayıt/yenileme sonrası istemciye dönen token çifti ve kullanıcı.</summary>
public record AuthResponse(
    string AccessToken,
    DateTime AccessTokenExpiresAt,
    string RefreshToken,
    DateTime RefreshTokenExpiresAt,
    UserDto User);

public record UserDto(
    Guid Id,
    string Email,
    string DisplayName,
    UserRole Role,
    string PreferredLocale,
    string? InviteCode);
