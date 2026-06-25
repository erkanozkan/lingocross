using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using LingoCross.Application.Admin;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Infrastructure.Auth;
using Microsoft.Extensions.Options;

namespace LingoCross.Tests.Admin;

/// <summary>
/// AdminAuthService: doğru kimlikle Admin rollü token, yanlış kimlikle 401, yapılandırılmamış
/// admin (Email/Password boş) ile 503. Üretilen token JWT olarak doğrulanıp role=Admin claim'i
/// içermelidir (UserRole enum'una dokunulmadan).
/// </summary>
public class AdminAuthServiceTests
{
    private const string Secret = "unit-test-super-secret-signing-key-32-chars-min!!";

    private static JwtTokenService TokenService() => new(Options.Create(new JwtOptions
    {
        Secret = Secret,
        Issuer = "lingocross-test",
        Audience = "lingocross-test",
    }));

    private static AdminAuthService CreateService(string email, string password, int tokenHours = 8)
        => new(Options.Create(new AdminOptions { Email = email, Password = password, TokenHours = tokenHours }), TokenService());

    [Fact]
    public void Login_WithCorrectCredentials_ReturnsAdminToken()
    {
        var svc = CreateService("admin@lingocross.app", "s3cret-pass");

        var result = svc.Login("admin@lingocross.app", "s3cret-pass");

        Assert.False(string.IsNullOrWhiteSpace(result.Token));
        Assert.True(result.ExpiresAt > DateTime.UtcNow);

        var jwt = new JwtSecurityTokenHandler().ReadJwtToken(result.Token);
        var role = jwt.Claims.FirstOrDefault(c => c.Type == ClaimTypes.Role || c.Type == "role")?.Value;
        Assert.Equal("Admin", role);
        var sub = jwt.Claims.FirstOrDefault(c => c.Type == JwtRegisteredClaimNames.Sub)?.Value;
        Assert.Equal("admin", sub);
    }

    [Fact]
    public void Login_EmailIsCaseInsensitiveAndTrimmed()
    {
        var svc = CreateService("Admin@LingoCross.app", "s3cret-pass");

        var result = svc.Login("  admin@lingocross.APP  ", "s3cret-pass");

        Assert.False(string.IsNullOrWhiteSpace(result.Token));
    }

    [Fact]
    public void Login_WithWrongPassword_Throws401()
    {
        var svc = CreateService("admin@lingocross.app", "s3cret-pass");

        var ex = Assert.Throws<AppException>(() => svc.Login("admin@lingocross.app", "wrong"));
        Assert.Equal(401, ex.StatusCode);
    }

    [Fact]
    public void Login_WithWrongEmail_Throws401()
    {
        var svc = CreateService("admin@lingocross.app", "s3cret-pass");

        var ex = Assert.Throws<AppException>(() => svc.Login("nope@x.com", "s3cret-pass"));
        Assert.Equal(401, ex.StatusCode);
    }

    [Fact]
    public void Login_WhenAdminNotConfigured_Throws503()
    {
        var svcEmptyBoth = CreateService("", "");
        Assert.Equal(503, Assert.Throws<AppException>(() => svcEmptyBoth.Login("a@b.com", "x")).StatusCode);

        var svcEmptyPassword = CreateService("admin@lingocross.app", "");
        Assert.Equal(503, Assert.Throws<AppException>(() => svcEmptyPassword.Login("admin@lingocross.app", "x")).StatusCode);
    }
}
