using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Auth;
using Microsoft.Extensions.Options;

namespace LingoCross.Tests.Auth;

public class JwtTokenServiceTests
{
    private static JwtTokenService CreateService(int accessMinutes = 15, int refreshDays = 30)
    {
        var options = Options.Create(new JwtOptions
        {
            Secret = "unit-test-super-secret-signing-key-32-chars-min!!",
            Issuer = "lingocross-test",
            Audience = "lingocross-test",
            AccessTokenMinutes = accessMinutes,
            RefreshTokenDays = refreshDays,
        });
        return new JwtTokenService(options);
    }

    private static User SampleUser() => new()
    {
        Id = Guid.NewGuid(),
        Email = "ogretmen@example.com",
        Role = UserRole.Teacher,
    };

    [Fact]
    public void Constructor_Throws_WhenSecretTooShort()
    {
        var options = Options.Create(new JwtOptions { Secret = "short" });
        Assert.Throws<InvalidOperationException>(() => new JwtTokenService(options));
    }

    [Fact]
    public void CreateAccessToken_IsValidatable_AndReturnsUserId()
    {
        var service = CreateService();
        var user = SampleUser();

        var result = service.CreateAccessToken(user);

        Assert.False(string.IsNullOrWhiteSpace(result.Token));
        Assert.True(result.ExpiresAt > DateTime.UtcNow);

        var validatedId = service.ValidateAccessToken(result.Token);
        Assert.Equal(user.Id, validatedId);
    }

    [Fact]
    public void ValidateAccessToken_ReturnsNull_ForGarbageToken()
    {
        var service = CreateService();
        Assert.Null(service.ValidateAccessToken("not.a.jwt"));
    }

    [Fact]
    public void ValidateAccessToken_ReturnsNull_WhenPayloadTampered()
    {
        var service = CreateService();
        var token = service.CreateAccessToken(SampleUser()).Token;

        // İmzayı bozmadan payload'ı değiştir → imza doğrulaması başarısız olmalı.
        var parts = token.Split('.');
        var tamperedPayload = parts[1].Length > 4
            ? parts[1][..^4] + "AAAA"
            : parts[1] + "AAAA";
        var tampered = $"{parts[0]}.{tamperedPayload}.{parts[2]}";

        Assert.Null(service.ValidateAccessToken(tampered));
    }

    [Fact]
    public void ValidateAccessToken_ReturnsNull_WhenSignedWithDifferentKey()
    {
        var issuer = CreateService();
        var other = new JwtTokenService(Options.Create(new JwtOptions
        {
            Secret = "a-completely-different-secret-key-32-characters!",
            Issuer = "lingocross-test",
            Audience = "lingocross-test",
        }));

        var token = issuer.CreateAccessToken(SampleUser());

        Assert.Null(other.ValidateAccessToken(token.Token));
    }

    [Fact]
    public void CreateRefreshToken_ReturnsHashMatchingHashRefreshToken()
    {
        var service = CreateService();

        var refresh = service.CreateRefreshToken();

        Assert.False(string.IsNullOrWhiteSpace(refresh.Token));
        Assert.NotEqual(refresh.Token, refresh.TokenHash);
        Assert.Equal(refresh.TokenHash, service.HashRefreshToken(refresh.Token));
        Assert.True(refresh.ExpiresAt > DateTime.UtcNow.AddDays(29));
    }

    [Fact]
    public void CreateRefreshToken_ProducesUniqueTokens()
    {
        var service = CreateService();

        var a = service.CreateRefreshToken();
        var b = service.CreateRefreshToken();

        Assert.NotEqual(a.Token, b.Token);
        Assert.NotEqual(a.TokenHash, b.TokenHash);
    }

    [Fact]
    public void HashRefreshToken_IsDeterministic()
    {
        var service = CreateService();
        const string raw = "some-opaque-refresh-token-value";

        Assert.Equal(service.HashRefreshToken(raw), service.HashRefreshToken(raw));
    }
}
