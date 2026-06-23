using LingoCross.Infrastructure.Auth;

namespace LingoCross.Tests.Auth;

public class BCryptPasswordHasherTests
{
    private readonly BCryptPasswordHasher _hasher = new();

    [Fact]
    public void Hash_ProducesNonEmptyHash_DifferentFromPlaintext()
    {
        var hash = _hasher.Hash("Sifre1234!");

        Assert.False(string.IsNullOrWhiteSpace(hash));
        Assert.NotEqual("Sifre1234!", hash);
    }

    [Fact]
    public void Verify_ReturnsTrue_ForCorrectPassword()
    {
        const string password = "Sifre1234!";
        var hash = _hasher.Hash(password);

        Assert.True(_hasher.Verify(password, hash));
    }

    [Fact]
    public void Verify_ReturnsFalse_ForWrongPassword()
    {
        var hash = _hasher.Hash("Sifre1234!");

        Assert.False(_hasher.Verify("YanlisSifre", hash));
    }

    [Fact]
    public void Verify_ReturnsFalse_ForMalformedHash()
    {
        Assert.False(_hasher.Verify("herhangi", "not-a-valid-bcrypt-hash"));
    }

    [Fact]
    public void Hash_IsSalted_SameInputProducesDifferentHashes()
    {
        var a = _hasher.Hash("Sifre1234!");
        var b = _hasher.Hash("Sifre1234!");

        Assert.NotEqual(a, b);
        Assert.True(_hasher.Verify("Sifre1234!", a));
        Assert.True(_hasher.Verify("Sifre1234!", b));
    }
}
