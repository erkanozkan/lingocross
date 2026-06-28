using LingoCross.Application.Auth;
using LingoCross.Application.Auth.Dtos;
using LingoCross.Application.Common.Email;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Auth;
using LingoCross.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;

namespace LingoCross.Tests.Auth;

/// <summary>
/// AuthService akışlarını EF InMemory ile uçtan uca doğrular; özellikle refresh rotasyonu ve
/// reuse-detection davranışını kapsar.
/// </summary>
public class AuthServiceTests
{
    private sealed class CapturingEmailSender : IEmailSender
    {
        public string? LastCode { get; private set; }
        public int SendCount { get; private set; }

        public Task SendPasswordResetAsync(string toEmail, string code, CancellationToken ct = default)
        {
            LastCode = code;
            SendCount++;
            return Task.CompletedTask;
        }
    }

    private static (AuthService Service, AppDbContext Db, CapturingEmailSender Email) CreateSut()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"auth-tests-{Guid.NewGuid()}")
            .Options;
        var db = new AppDbContext(options);

        var tokenService = new JwtTokenService(Options.Create(new JwtOptions
        {
            Secret = "unit-test-super-secret-signing-key-32-chars-min!!",
            Issuer = "lingocross-test",
            Audience = "lingocross-test",
        }));
        var email = new CapturingEmailSender();
        var service = new AuthService(db, new BCryptPasswordHasher(), tokenService, email);
        return (service, db, email);
    }

    private static RegisterRequest TeacherReg() =>
        new("Teacher@Example.com", "Sifre1234!", "Öğretmen", UserRole.Teacher);

    [Fact]
    public async Task Register_CreatesUser_WithInviteCodeForTeacher_AndReturnsTokens()
    {
        var (service, db, _) = CreateSut();

        var response = await service.RegisterAsync(TeacherReg());

        Assert.False(string.IsNullOrWhiteSpace(response.AccessToken));
        Assert.False(string.IsNullOrWhiteSpace(response.RefreshToken));
        Assert.Equal("teacher@example.com", response.User.Email); // normalize edilmiş
        Assert.NotNull(response.User.InviteCode);
        Assert.Equal(1, await db.RefreshTokens.CountAsync());
    }

    [Fact]
    public async Task Register_Throws_OnDuplicateEmail()
    {
        var (service, _, _) = CreateSut();
        await service.RegisterAsync(TeacherReg());

        var ex = await Assert.ThrowsAsync<AppException>(() => service.RegisterAsync(TeacherReg()));
        Assert.Equal(409, ex.StatusCode);
    }

    [Fact]
    public async Task Login_Throws_OnWrongPassword()
    {
        var (service, _, _) = CreateSut();
        await service.RegisterAsync(TeacherReg());

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.LoginAsync(new LoginRequest("teacher@example.com", "wrong")));
        Assert.Equal(401, ex.StatusCode);
    }

    [Fact]
    public async Task Refresh_RotatesToken_RevokesOldAndIssuesNew()
    {
        var (service, db, _) = CreateSut();
        var reg = await service.RegisterAsync(TeacherReg());

        var refreshed = await service.RefreshAsync(new RefreshRequest(reg.RefreshToken));

        Assert.NotEqual(reg.RefreshToken, refreshed.RefreshToken);

        var tokens = await db.RefreshTokens.ToListAsync();
        Assert.Equal(2, tokens.Count);
        Assert.Single(tokens, t => t.RevokedAt != null && t.ReplacedByTokenHash != null);
        Assert.Single(tokens, t => t.RevokedAt == null);
    }

    [Fact]
    public async Task Refresh_ReuseOfRevokedToken_RevokesEntireChain()
    {
        var (service, db, _) = CreateSut();
        var reg = await service.RegisterAsync(TeacherReg());

        // İlk rotasyon: orijinal token revoke edilir.
        await service.RefreshAsync(new RefreshRequest(reg.RefreshToken));

        // Aynı (artık revoke edilmiş) token tekrar kullanılırsa zincir iptal edilmeli.
        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.RefreshAsync(new RefreshRequest(reg.RefreshToken)));
        Assert.Equal(401, ex.StatusCode);

        var active = await db.RefreshTokens.CountAsync(t => t.RevokedAt == null);
        Assert.Equal(0, active);
    }

    [Fact]
    public async Task ForgotThenResetPassword_AllowsLoginWithNewPassword_AndRevokesTokens()
    {
        var (service, db, email) = CreateSut();
        await service.RegisterAsync(TeacherReg());

        await service.ForgotPasswordAsync(new ForgotPasswordRequest("teacher@example.com"));
        Assert.NotNull(email.LastCode);
        // 6 haneli kod üretilmiş olmalı.
        Assert.Matches("^[0-9]{6}$", email.LastCode!);

        await service.ResetPasswordAsync(
            new ResetPasswordRequest("teacher@example.com", email.LastCode!, "YeniSifre9!"));

        // Eski şifre artık geçersiz, yenisi geçerli.
        await Assert.ThrowsAsync<AppException>(() =>
            service.LoginAsync(new LoginRequest("teacher@example.com", "Sifre1234!")));
        var login = await service.LoginAsync(new LoginRequest("teacher@example.com", "YeniSifre9!"));
        Assert.False(string.IsNullOrWhiteSpace(login.AccessToken));

        // Reset, ilk register sırasında verilen refresh token'ı iptal etmiş olmalı.
        Assert.True(await db.RefreshTokens.AnyAsync(t => t.RevokedAt != null));
    }

    [Fact]
    public async Task ForgotPassword_InvalidatesPreviousUnusedCode_AndKeepsOnlyOneActive()
    {
        var (service, db, email) = CreateSut();
        await service.RegisterAsync(TeacherReg());

        await service.ForgotPasswordAsync(new ForgotPasswordRequest("teacher@example.com"));
        var firstCode = email.LastCode!;

        await service.ForgotPasswordAsync(new ForgotPasswordRequest("teacher@example.com"));
        var secondCode = email.LastCode!;

        Assert.Equal(2, email.SendCount);

        // Yalnız bir aktif (kullanılmamış) kod kalmalı.
        Assert.Equal(1, await db.PasswordResetTokens.CountAsync(t => t.UsedAt == null));

        // İlk kod artık geçersiz olmalı.
        await Assert.ThrowsAsync<AppException>(() =>
            service.ResetPasswordAsync(new ResetPasswordRequest("teacher@example.com", firstCode, "YeniSifre9!")));

        // İkinci kod hâlâ çalışmalı.
        await service.ResetPasswordAsync(new ResetPasswordRequest("teacher@example.com", secondCode, "YeniSifre9!"));
        var login = await service.LoginAsync(new LoginRequest("teacher@example.com", "YeniSifre9!"));
        Assert.False(string.IsNullOrWhiteSpace(login.AccessToken));
    }

    [Fact]
    public async Task ResetPassword_WrongCode_IncrementsAttempts_AndThrows400()
    {
        var (service, db, email) = CreateSut();
        await service.RegisterAsync(TeacherReg());
        await service.ForgotPasswordAsync(new ForgotPasswordRequest("teacher@example.com"));

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.ResetPasswordAsync(new ResetPasswordRequest("teacher@example.com", "000000", "YeniSifre9!")));
        Assert.Equal(400, ex.StatusCode);

        var token = await db.PasswordResetTokens.SingleAsync();
        Assert.Equal(1, token.Attempts);
        Assert.Null(token.UsedAt);
    }

    [Fact]
    public async Task ResetPassword_FifthWrongAttempt_InvalidatesCode()
    {
        var (service, db, email) = CreateSut();
        await service.RegisterAsync(TeacherReg());
        await service.ForgotPasswordAsync(new ForgotPasswordRequest("teacher@example.com"));
        var realCode = email.LastCode!;
        // Gerçek kodla çakışmayacak bir yanlış kod seç.
        var wrongCode = realCode == "111111" ? "222222" : "111111";

        // 1–4. yanlış denemeler "Kod hatalı".
        for (var i = 0; i < 4; i++)
        {
            await Assert.ThrowsAsync<AppException>(() =>
                service.ResetPasswordAsync(new ResetPasswordRequest("teacher@example.com", wrongCode, "YeniSifre9!")));
        }

        // 5. yanlış deneme kodu geçersiz kılar.
        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.ResetPasswordAsync(new ResetPasswordRequest("teacher@example.com", wrongCode, "YeniSifre9!")));
        Assert.Equal(400, ex.StatusCode);

        var token = await db.PasswordResetTokens.SingleAsync();
        Assert.NotNull(token.UsedAt);

        // Artık doğru kod bile işe yaramaz (kod geçersiz kılındı).
        await Assert.ThrowsAsync<AppException>(() =>
            service.ResetPasswordAsync(new ResetPasswordRequest("teacher@example.com", realCode, "YeniSifre9!")));
    }

    [Fact]
    public async Task ResetPassword_ExpiredCode_Throws400()
    {
        var (service, db, email) = CreateSut();
        await service.RegisterAsync(TeacherReg());
        await service.ForgotPasswordAsync(new ForgotPasswordRequest("teacher@example.com"));
        var code = email.LastCode!;

        // Kodun süresini geçmişe çek.
        var token = await db.PasswordResetTokens.SingleAsync();
        token.ExpiresAt = DateTime.UtcNow.AddMinutes(-1);
        await db.SaveChangesAsync();

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.ResetPasswordAsync(new ResetPasswordRequest("teacher@example.com", code, "YeniSifre9!")));
        Assert.Equal(400, ex.StatusCode);
    }

    [Fact]
    public async Task ResetPassword_UnknownEmail_Throws400_WithoutEnumeration()
    {
        var (service, _, _) = CreateSut();

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.ResetPasswordAsync(new ResetPasswordRequest("nobody@example.com", "123456", "YeniSifre9!")));
        Assert.Equal(400, ex.StatusCode);
    }

    [Fact]
    public async Task ForgotPassword_IsSilent_ForUnknownEmail()
    {
        var (service, _, email) = CreateSut();

        await service.ForgotPasswordAsync(new ForgotPasswordRequest("nobody@example.com"));

        Assert.Null(email.LastCode);
    }

    [Fact]
    public async Task ChangePassword_Throws400_OnWrongCurrentPassword()
    {
        var (service, db, _) = CreateSut();
        var reg = await service.RegisterAsync(TeacherReg());
        var userId = reg.User.Id;

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.ChangePasswordAsync(userId, new ChangePasswordRequest("wrong-current", "YeniSifre9!")));

        Assert.Equal(400, ex.StatusCode);

        // Şifre değişmemiş olmalı: eski şifre hâlâ geçerli.
        var login = await service.LoginAsync(new LoginRequest("teacher@example.com", "Sifre1234!"));
        Assert.False(string.IsNullOrWhiteSpace(login.AccessToken));
    }

    [Fact]
    public async Task ChangePassword_Succeeds_IssuesNewTokens_RevokesOld_AndSwapsPassword()
    {
        var (service, db, _) = CreateSut();
        var reg = await service.RegisterAsync(TeacherReg());
        var userId = reg.User.Id;

        var response = await service.ChangePasswordAsync(
            userId, new ChangePasswordRequest("Sifre1234!", "YeniSifre9!"));

        // Yeni token çifti dönmeli.
        Assert.False(string.IsNullOrWhiteSpace(response.AccessToken));
        Assert.False(string.IsNullOrWhiteSpace(response.RefreshToken));
        Assert.NotEqual(reg.RefreshToken, response.RefreshToken);

        // Register sırasında verilen refresh token iptal edilmiş, yenisi aktif olmalı.
        Assert.True(await db.RefreshTokens.AnyAsync(t => t.RevokedAt != null));
        Assert.Equal(1, await db.RefreshTokens.CountAsync(t => t.RevokedAt == null));

        // Eski şifre artık geçersiz, yenisi geçerli.
        await Assert.ThrowsAsync<AppException>(() =>
            service.LoginAsync(new LoginRequest("teacher@example.com", "Sifre1234!")));
        var login = await service.LoginAsync(new LoginRequest("teacher@example.com", "YeniSifre9!"));
        Assert.False(string.IsNullOrWhiteSpace(login.AccessToken));
    }

    [Fact]
    public async Task UpdateProfile_TrimsAndUpdatesDisplayName()
    {
        var (service, db, _) = CreateSut();
        var reg = await service.RegisterAsync(TeacherReg());
        var userId = reg.User.Id;

        var dto = await service.UpdateProfileAsync(userId, new UpdateProfileRequest("  Yeni Ad  "));

        Assert.Equal("Yeni Ad", dto.DisplayName);

        var persisted = await db.Users.FirstAsync(u => u.Id == userId);
        Assert.Equal("Yeni Ad", persisted.DisplayName);
    }

    [Fact]
    public async Task UpdateProfile_UpdatesPreferredLocale_WhenSupported()
    {
        var (service, db, _) = CreateSut();
        var reg = await service.RegisterAsync(TeacherReg());
        var userId = reg.User.Id;

        var dto = await service.UpdateProfileAsync(userId, new UpdateProfileRequest("Öğretmen", "en"));

        Assert.Equal("en", dto.PreferredLocale);

        var persisted = await db.Users.FirstAsync(u => u.Id == userId);
        Assert.Equal("en", persisted.PreferredLocale);
    }

    [Fact]
    public async Task UpdateProfile_IgnoresPreferredLocale_WhenInvalid()
    {
        var (service, db, _) = CreateSut();
        var reg = await service.RegisterAsync(TeacherReg());
        var userId = reg.User.Id;

        var dto = await service.UpdateProfileAsync(userId, new UpdateProfileRequest("Öğretmen", "xx"));

        // Geçersiz dil yok sayılır; kayıt sırasındaki varsayılan ("tr") korunur.
        Assert.Equal("tr", dto.PreferredLocale);

        var persisted = await db.Users.FirstAsync(u => u.Id == userId);
        Assert.Equal("tr", persisted.PreferredLocale);
    }

    [Fact]
    public async Task UpdateProfile_KeepsPreferredLocale_WhenNull_AndUpdatesDisplayName()
    {
        var (service, db, _) = CreateSut();
        var reg = await service.RegisterAsync(TeacherReg());
        var userId = reg.User.Id;

        var dto = await service.UpdateProfileAsync(userId, new UpdateProfileRequest("Yeni Ad"));

        Assert.Equal("Yeni Ad", dto.DisplayName);
        Assert.Equal("tr", dto.PreferredLocale);

        var persisted = await db.Users.FirstAsync(u => u.Id == userId);
        Assert.Equal("Yeni Ad", persisted.DisplayName);
        Assert.Equal("tr", persisted.PreferredLocale);
    }
}
