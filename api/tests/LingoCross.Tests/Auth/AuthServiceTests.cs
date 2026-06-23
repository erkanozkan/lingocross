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
        public string? LastToken { get; private set; }

        public Task SendPasswordResetAsync(string toEmail, string resetToken, CancellationToken ct = default)
        {
            LastToken = resetToken;
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
        Assert.NotNull(email.LastToken);

        await service.ResetPasswordAsync(new ResetPasswordRequest(email.LastToken!, "YeniSifre9!"));

        // Eski şifre artık geçersiz, yenisi geçerli.
        await Assert.ThrowsAsync<AppException>(() =>
            service.LoginAsync(new LoginRequest("teacher@example.com", "Sifre1234!")));
        var login = await service.LoginAsync(new LoginRequest("teacher@example.com", "YeniSifre9!"));
        Assert.False(string.IsNullOrWhiteSpace(login.AccessToken));

        // Reset, ilk register sırasında verilen refresh token'ı iptal etmiş olmalı.
        Assert.True(await db.RefreshTokens.AnyAsync(t => t.RevokedAt != null));
    }

    [Fact]
    public async Task ForgotPassword_IsSilent_ForUnknownEmail()
    {
        var (service, _, email) = CreateSut();

        await service.ForgotPasswordAsync(new ForgotPasswordRequest("nobody@example.com"));

        Assert.Null(email.LastToken);
    }
}
