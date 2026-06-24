using LingoCross.Application.Auth.Dtos;
using LingoCross.Application.Common.Email;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Auth;

public class AuthService : IAuthService
{
    private static readonly TimeSpan PasswordResetTokenLifetime = TimeSpan.FromMinutes(30);

    private readonly IAppDbContext _db;
    private readonly IPasswordHasher _passwordHasher;
    private readonly ITokenService _tokenService;
    private readonly IEmailSender _emailSender;

    public AuthService(
        IAppDbContext db,
        IPasswordHasher passwordHasher,
        ITokenService tokenService,
        IEmailSender emailSender)
    {
        _db = db;
        _passwordHasher = passwordHasher;
        _tokenService = tokenService;
        _emailSender = emailSender;
    }

    public async Task<AuthResponse> RegisterAsync(RegisterRequest request, CancellationToken cancellationToken = default)
    {
        var email = NormalizeEmail(request.Email);

        var exists = await _db.Users.AnyAsync(u => u.Email == email, cancellationToken);
        if (exists)
        {
            throw AppException.Conflict("Bu e-posta ile bir hesap zaten var.");
        }

        var user = new User
        {
            Email = email,
            PasswordHash = _passwordHasher.Hash(request.Password),
            DisplayName = request.DisplayName.Trim(),
            Role = request.Role,
            PreferredLocale = "tr",
            InviteCode = request.Role == UserRole.Teacher ? await GenerateUniqueInviteCodeAsync(cancellationToken) : null,
        };

        _db.Users.Add(user);
        await _db.SaveChangesAsync(cancellationToken);

        return await IssueTokensAsync(user, cancellationToken);
    }

    public async Task<AuthResponse> LoginAsync(LoginRequest request, CancellationToken cancellationToken = default)
    {
        var email = NormalizeEmail(request.Email);

        var user = await _db.Users.FirstOrDefaultAsync(u => u.Email == email, cancellationToken);
        if (user is null || !_passwordHasher.Verify(request.Password, user.PasswordHash))
        {
            throw AppException.Unauthorized("E-posta veya şifre hatalı.");
        }

        return await IssueTokensAsync(user, cancellationToken);
    }

    public async Task<AuthResponse> RefreshAsync(RefreshRequest request, CancellationToken cancellationToken = default)
    {
        var hash = _tokenService.HashRefreshToken(request.RefreshToken);

        var token = await _db.RefreshTokens
            .Include(t => t.User)
            .FirstOrDefaultAsync(t => t.TokenHash == hash, cancellationToken);

        if (token is null)
        {
            throw AppException.Unauthorized("Geçersiz refresh token.");
        }

        // Reuse-detection: zaten revoke edilmiş bir token tekrar kullanılıyorsa, kullanıcının
        // tüm aktif refresh token'larını iptal et (olası token hırsızlığı).
        if (token.RevokedAt is not null)
        {
            await RevokeAllActiveTokensAsync(token.UserId, cancellationToken);
            await _db.SaveChangesAsync(cancellationToken);
            throw AppException.Unauthorized("Refresh token tekrar kullanıldı; oturum iptal edildi.");
        }

        if (DateTime.UtcNow >= token.ExpiresAt)
        {
            throw AppException.Unauthorized("Refresh token süresi dolmuş.");
        }

        // Rotasyon: eskiyi revoke et, yenisini üret ve zinciri bağla.
        var newRefresh = _tokenService.CreateRefreshToken();
        token.RevokedAt = DateTime.UtcNow;
        token.ReplacedByTokenHash = newRefresh.TokenHash;

        var replacement = new RefreshToken
        {
            UserId = token.UserId,
            TokenHash = newRefresh.TokenHash,
            ExpiresAt = newRefresh.ExpiresAt,
        };
        _db.RefreshTokens.Add(replacement);

        var access = _tokenService.CreateAccessToken(token.User);
        await _db.SaveChangesAsync(cancellationToken);

        return BuildResponse(token.User, access, newRefresh.Token, newRefresh.ExpiresAt);
    }

    public async Task LogoutAsync(LogoutRequest request, CancellationToken cancellationToken = default)
    {
        var hash = _tokenService.HashRefreshToken(request.RefreshToken);

        var token = await _db.RefreshTokens
            .FirstOrDefaultAsync(t => t.TokenHash == hash, cancellationToken);

        if (token is not null && token.RevokedAt is null)
        {
            token.RevokedAt = DateTime.UtcNow;
            await _db.SaveChangesAsync(cancellationToken);
        }
        // Token bulunamasa bile sessizce başarı dön (idempotent).
    }

    public async Task ForgotPasswordAsync(ForgotPasswordRequest request, CancellationToken cancellationToken = default)
    {
        var email = NormalizeEmail(request.Email);

        var user = await _db.Users.FirstOrDefaultAsync(u => u.Email == email, cancellationToken);
        if (user is null)
        {
            // Enumeration sızdırmamak için sessizce çık; controller her zaman 200 döner.
            return;
        }

        var token = _tokenService.CreateRefreshToken();
        var resetToken = new PasswordResetToken
        {
            UserId = user.Id,
            TokenHash = token.TokenHash,
            ExpiresAt = DateTime.UtcNow.Add(PasswordResetTokenLifetime),
        };
        _db.PasswordResetTokens.Add(resetToken);
        await _db.SaveChangesAsync(cancellationToken);

        await _emailSender.SendPasswordResetAsync(user.Email, token.Token, cancellationToken);
    }

    public async Task ResetPasswordAsync(ResetPasswordRequest request, CancellationToken cancellationToken = default)
    {
        var hash = _tokenService.HashRefreshToken(request.Token);

        var resetToken = await _db.PasswordResetTokens
            .Include(t => t.User)
            .FirstOrDefaultAsync(t => t.TokenHash == hash, cancellationToken);

        if (resetToken is null || resetToken.UsedAt is not null || DateTime.UtcNow >= resetToken.ExpiresAt)
        {
            throw AppException.BadRequest("Şifre sıfırlama bağlantısı geçersiz veya süresi dolmuş.");
        }

        resetToken.UsedAt = DateTime.UtcNow;
        resetToken.User.PasswordHash = _passwordHasher.Hash(request.NewPassword);

        // Güvenlik: şifre değişince kullanıcının tüm aktif refresh token'larını iptal et.
        await RevokeAllActiveTokensAsync(resetToken.UserId, cancellationToken);

        await _db.SaveChangesAsync(cancellationToken);
    }

    public async Task<UserDto> GetMeAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        var user = await _db.Users.FirstOrDefaultAsync(u => u.Id == userId, cancellationToken);
        if (user is null)
        {
            throw AppException.NotFound("Kullanıcı bulunamadı.");
        }

        return ToDto(user);
    }

    public async Task<UserDto> UpdateProfileAsync(Guid userId, UpdateProfileRequest request, CancellationToken cancellationToken = default)
    {
        var user = await _db.Users.FirstOrDefaultAsync(u => u.Id == userId, cancellationToken);
        if (user is null)
        {
            throw AppException.NotFound("Kullanıcı bulunamadı.");
        }

        user.DisplayName = request.DisplayName.Trim();
        await _db.SaveChangesAsync(cancellationToken);

        return ToDto(user);
    }

    public async Task<AuthResponse> ChangePasswordAsync(Guid userId, ChangePasswordRequest request, CancellationToken cancellationToken = default)
    {
        var user = await _db.Users.FirstOrDefaultAsync(u => u.Id == userId, cancellationToken);
        if (user is null)
        {
            throw AppException.NotFound("Kullanıcı bulunamadı.");
        }

        if (!_passwordHasher.Verify(request.CurrentPassword, user.PasswordHash))
        {
            throw AppException.BadRequest("Mevcut şifre hatalı.");
        }

        user.PasswordHash = _passwordHasher.Hash(request.NewPassword);

        // Güvenlik: şifre değişince mevcut tüm aktif refresh token'ları iptal et.
        await RevokeAllActiveTokensAsync(userId, cancellationToken);
        await _db.SaveChangesAsync(cancellationToken);

        // Çağıran istemcinin oturumu düşmesin diye yeni access+refresh çifti üret.
        return await IssueTokensAsync(user, cancellationToken);
    }

    private async Task<AuthResponse> IssueTokensAsync(User user, CancellationToken cancellationToken)
    {
        var access = _tokenService.CreateAccessToken(user);
        var refresh = _tokenService.CreateRefreshToken();

        _db.RefreshTokens.Add(new RefreshToken
        {
            UserId = user.Id,
            TokenHash = refresh.TokenHash,
            ExpiresAt = refresh.ExpiresAt,
        });
        await _db.SaveChangesAsync(cancellationToken);

        return BuildResponse(user, access, refresh.Token, refresh.ExpiresAt);
    }

    private async Task RevokeAllActiveTokensAsync(Guid userId, CancellationToken cancellationToken)
    {
        var now = DateTime.UtcNow;
        var activeTokens = await _db.RefreshTokens
            .Where(t => t.UserId == userId && t.RevokedAt == null)
            .ToListAsync(cancellationToken);

        foreach (var t in activeTokens)
        {
            t.RevokedAt = now;
        }
    }

    private async Task<string> GenerateUniqueInviteCodeAsync(CancellationToken cancellationToken)
    {
        for (var attempt = 0; attempt < 10; attempt++)
        {
            var code = GenerateInviteCode();
            var exists = await _db.Users.AnyAsync(u => u.InviteCode == code, cancellationToken);
            if (!exists)
            {
                return code;
            }
        }

        throw AppException.Conflict("Davet kodu üretilemedi, lütfen tekrar deneyin.");
    }

    private static string GenerateInviteCode()
    {
        // Karışması kolay karakterler (0/O, 1/I) çıkarılmış 8 haneli kod.
        const string alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        var bytes = System.Security.Cryptography.RandomNumberGenerator.GetBytes(8);
        return string.Create(8, bytes, static (span, src) =>
        {
            for (var i = 0; i < span.Length; i++)
            {
                span[i] = alphabet[src[i] % alphabet.Length];
            }
        });
    }

    private static AuthResponse BuildResponse(User user, AccessTokenResult access, string refreshToken, DateTime refreshExpiresAt)
        => new(access.Token, access.ExpiresAt, refreshToken, refreshExpiresAt, ToDto(user));

    private static UserDto ToDto(User user)
        => new(user.Id, user.Email, user.DisplayName, user.Role, user.PreferredLocale, user.InviteCode);

    private static string NormalizeEmail(string email) => email.Trim().ToLowerInvariant();
}
