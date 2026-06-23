using LingoCross.Domain.Entities;

namespace LingoCross.Application.Common.Security;

/// <summary>Üretilen access token ve son kullanma anı.</summary>
public record AccessTokenResult(string Token, DateTime ExpiresAt);

/// <summary>Opaque refresh token: istemciye dönen ham değer ve DB'de saklanacak hash.</summary>
public record RefreshTokenResult(string Token, string TokenHash, DateTime ExpiresAt);

/// <summary>JWT access ve opaque refresh token üretimi/doğrulaması. Infrastructure'da HS256 ile uygulanır.</summary>
public interface ITokenService
{
    /// <summary>Kullanıcı için kısa ömürlü JWT access token üretir (claim: sub/role/email).</summary>
    AccessTokenResult CreateAccessToken(User user);

    /// <summary>Yeni bir opaque refresh token üretir (ham değer + hash).</summary>
    RefreshTokenResult CreateRefreshToken();

    /// <summary>Verilen ham refresh token'ın saklanan hash'ini hesaplar (eşleşme araması için).</summary>
    string HashRefreshToken(string token);

    /// <summary>Bir access token'ı doğrular ve geçerliyse içindeki kullanıcı kimliğini (sub) döner.</summary>
    Guid? ValidateAccessToken(string token);
}
