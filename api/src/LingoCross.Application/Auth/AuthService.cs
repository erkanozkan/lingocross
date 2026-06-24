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

    /// <summary>UI'ın desteklediği diller; bunun dışındaki değerler yok sayılır.</summary>
    private static readonly HashSet<string> SupportedLocales = new(StringComparer.OrdinalIgnoreCase) { "tr", "en" };

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

        // PreferredLocale opsiyonel: yalnızca desteklenen bir dil gelirse güncelle, aksi halde
        // (null/boş/geçersiz) mevcut değeri koru — hata atma.
        if (!string.IsNullOrWhiteSpace(request.PreferredLocale)
            && SupportedLocales.TryGetValue(request.PreferredLocale.Trim(), out var locale))
        {
            user.PreferredLocale = locale;
        }

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

    public async Task DeleteAccountAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        var user = await _db.Users.FirstOrDefaultAsync(u => u.Id == userId, cancellationToken);
        if (user is null)
        {
            throw AppException.NotFound("Kullanıcı bulunamadı.");
        }

        // Tüm silmeler tek transaction içinde; herhangi biri patlarsa hiçbiri uygulanmaz.
        // Restrict olan FK'lar (ClassMember.StudentId, GameSession.StudentId, Enrollment'ın bir ucu,
        // GameAssignment.ClassId) cascade ile temizlenemediğinden ELLE ve doğru sırada siliniyor.
        await using var transaction = await _db.BeginTransactionAsync(cancellationToken);

        if (user.Role == UserRole.Teacher)
        {
            await DeleteTeacherDataAsync(userId, cancellationToken);
        }
        else
        {
            await DeleteStudentDataAsync(userId, cancellationToken);
        }

        // Her iki rol için ortak, user'a doğrudan bağlı (cascade) tablolar — güvence için açıkça siliyoruz.
        await DeleteUserOwnedAuxiliaryDataAsync(userId, cancellationToken);

        _db.Users.Remove(user);
        await _db.SaveChangesAsync(cancellationToken);

        await transaction.CommitAsync(cancellationToken);
    }

    private async Task DeleteStudentDataAsync(Guid studentId, CancellationToken cancellationToken)
    {
        // 1) Öğrencinin oyun oturumları (results → items session'dan cascade). GameSession.StudentId Restrict.
        var sessions = await _db.GameSessions
            .Where(s => s.StudentId == studentId)
            .ToListAsync(cancellationToken);
        _db.GameSessions.RemoveRange(sessions);

        // 2) Sınıf üyelikleri. ClassMember.StudentId Restrict.
        var memberships = await _db.ClassMembers
            .Where(m => m.StudentId == studentId)
            .ToListAsync(cancellationToken);
        _db.ClassMembers.RemoveRange(memberships);

        // 3) Öğrenci tarafındaki eşleşmeler. Enrollment.StudentId Restrict (TeacherId Cascade).
        var enrollments = await _db.Enrollments
            .Where(e => e.StudentId == studentId)
            .ToListAsync(cancellationToken);
        _db.Enrollments.RemoveRange(enrollments);
    }

    private async Task DeleteTeacherDataAsync(Guid teacherId, CancellationToken cancellationToken)
    {
        // 1) Atamalar: hem öğretmenin oyunlarına ait olanlar hem öğretmenin sınıflarına ait olanlar.
        //    GameAssignment.ClassId Restrict olduğundan, sınıf silinmeden önce mutlaka temizlenmeli.
        var lessonIds = await _db.Lessons
            .Where(l => l.TeacherId == teacherId)
            .Select(l => l.Id)
            .ToListAsync(cancellationToken);

        var gameIds = await _db.Games
            .Where(g => lessonIds.Contains(g.LessonId))
            .Select(g => g.Id)
            .ToListAsync(cancellationToken);

        var classIds = await _db.Classes
            .Where(c => c.TeacherId == teacherId)
            .Select(c => c.Id)
            .ToListAsync(cancellationToken);

        var assignments = await _db.GameAssignments
            .Where(a => gameIds.Contains(a.GameId) || classIds.Contains(a.ClassId))
            .ToListAsync(cancellationToken);
        _db.GameAssignments.RemoveRange(assignments);

        // 2) Öğretmenin oyunları (sessions → results → items cascade). Bu oyunlardaki öğrenci
        //    oturumları GameSession.StudentId Restrict olsa da, FK Game tarafından (Cascade) gider;
        //    yine de güvence için oturumları açıkça siliyoruz.
        var sessions = await _db.GameSessions
            .Where(s => gameIds.Contains(s.GameId))
            .ToListAsync(cancellationToken);
        _db.GameSessions.RemoveRange(sessions);

        var games = await _db.Games
            .Where(g => gameIds.Contains(g.Id))
            .ToListAsync(cancellationToken);
        _db.Games.RemoveRange(games);

        // 3) Dersler (words → translations/synonyms cascade). Lesson.TeacherId Cascade.
        var lessons = await _db.Lessons
            .Where(l => l.TeacherId == teacherId)
            .ToListAsync(cancellationToken);
        _db.Lessons.RemoveRange(lessons);

        // 4) Sınıflar (class_members ClassId'den cascade). Class.TeacherId Cascade.
        var classes = await _db.Classes
            .Where(c => c.TeacherId == teacherId)
            .ToListAsync(cancellationToken);
        _db.Classes.RemoveRange(classes);

        // 5) Öğretmen tarafındaki eşleşmeler. Enrollment.TeacherId Cascade ama açıkça siliyoruz.
        var enrollments = await _db.Enrollments
            .Where(e => e.TeacherId == teacherId)
            .ToListAsync(cancellationToken);
        _db.Enrollments.RemoveRange(enrollments);
    }

    /// <summary>
    /// User'a doğrudan bağlı, FK'sı Cascade olan yardımcı tablolar. Cascade'e güvenmek yerine
    /// açık silme (en güvenli; ilişkisel olmayan test sağlayıcısında da çalışır).
    /// </summary>
    private async Task DeleteUserOwnedAuxiliaryDataAsync(Guid userId, CancellationToken cancellationToken)
    {
        var refreshTokens = await _db.RefreshTokens
            .Where(t => t.UserId == userId)
            .ToListAsync(cancellationToken);
        _db.RefreshTokens.RemoveRange(refreshTokens);

        var resetTokens = await _db.PasswordResetTokens
            .Where(t => t.UserId == userId)
            .ToListAsync(cancellationToken);
        _db.PasswordResetTokens.RemoveRange(resetTokens);

        var deviceTokens = await _db.DeviceTokens
            .Where(t => t.UserId == userId)
            .ToListAsync(cancellationToken);
        _db.DeviceTokens.RemoveRange(deviceTokens);

        var notifPrefs = await _db.NotificationPreferences
            .Where(p => p.UserId == userId)
            .ToListAsync(cancellationToken);
        _db.NotificationPreferences.RemoveRange(notifPrefs);

        var subscriptions = await _db.Subscriptions
            .Where(s => s.UserId == userId)
            .ToListAsync(cancellationToken);
        _db.Subscriptions.RemoveRange(subscriptions);
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
