using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Text.Json;
using LingoCross.Application.Subscriptions;
using LingoCross.Infrastructure.Subscriptions;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;

namespace LingoCross.Tests.Subscriptions;

/// <summary>
/// S3 — AppleReceiptVerifier: StoreKit 2 imzalı işlem JWS'inin çevrimdışı doğrulaması. Apple'ın
/// sertifika zinciri yerine test için üretilmiş bir ECDSA kök/uç zinciri kullanılır; gerçek imza
/// (ES256) ve zincir doğrulaması (CustomRootTrust) test edilir. Ağ çağrısı yoktur.
/// </summary>
public class AppleReceiptVerifierTests
{
    private const string Bundle = "com.lingocross.lingoCrossApp";

    [Fact]
    public void Verify_ValidJws_ReturnsValidWithPayloadFields()
    {
        using var chain = TestChain.Create();
        var expiresMs = DateTimeOffset.UtcNow.AddDays(7).ToUnixTimeMilliseconds();
        var jws = chain.SignTransaction(new Dictionary<string, object?>
        {
            ["bundleId"] = Bundle,
            ["productId"] = AppleOptions.MonthlyProductId,
            ["expiresDate"] = expiresMs,
            ["originalTransactionId"] = "txn-123",
        });

        var verifier = NewVerifier(chain, bundleId: Bundle);
        var result = verifier.Verify(jws);

        Assert.True(result.IsValid);
        Assert.Equal(AppleOptions.MonthlyProductId, result.ProductId);
        Assert.Equal("txn-123", result.OriginalTransactionId);
        Assert.Equal(DateTimeOffset.FromUnixTimeMilliseconds(expiresMs), result.ExpiresAt);
    }

    [Fact]
    public void Verify_TamperedPayload_FailsSignature()
    {
        using var chain = TestChain.Create();
        var jws = chain.SignTransaction(new Dictionary<string, object?>
        {
            ["bundleId"] = Bundle,
            ["productId"] = AppleOptions.MonthlyProductId,
            ["expiresDate"] = DateTimeOffset.UtcNow.AddDays(7).ToUnixTimeMilliseconds(),
        });

        // Payload bölümünü boz (imza artık tutmaz).
        var parts = jws.Split('.');
        var forgedPayload = Base64Url(Encoding.UTF8.GetBytes(
            $$"""{"bundleId":"{{Bundle}}","productId":"{{AppleOptions.AnnualProductId}}","expiresDate":99999999999999}"""));
        var tampered = $"{parts[0]}.{forgedPayload}.{parts[2]}";

        var verifier = NewVerifier(chain, bundleId: Bundle);
        var result = verifier.Verify(tampered);

        Assert.False(result.IsValid);
        Assert.Equal("bad_signature", result.RawError);
    }

    [Fact]
    public void Verify_UntrustedRoot_FailsChain()
    {
        using var signing = TestChain.Create();
        using var otherRoot = TestChain.Create();
        var jws = signing.SignTransaction(new Dictionary<string, object?>
        {
            ["bundleId"] = Bundle,
            ["productId"] = AppleOptions.MonthlyProductId,
            ["expiresDate"] = DateTimeOffset.UtcNow.AddDays(7).ToUnixTimeMilliseconds(),
        });

        // Doğrulayıcı BAŞKA bir kökü güvenilir kabul ediyor → zincir kurulamaz.
        var verifier = NewVerifierWithRoot(otherRoot.Root, bundleId: Bundle);
        var result = verifier.Verify(jws);

        Assert.False(result.IsValid);
        Assert.Equal("chain_invalid", result.RawError);
    }

    [Fact]
    public void Verify_NotAJws_ReturnsInvalid()
    {
        using var chain = TestChain.Create();
        var verifier = NewVerifier(chain, bundleId: Bundle);

        Assert.Equal("not_jws", verifier.Verify("not-a-jws").RawError);
        Assert.Equal("empty", verifier.Verify("   ").RawError);
    }

    [Fact]
    public void ParsePayload_BundleIdMismatch_ReturnsInvalid()
    {
        var json = $$"""{ "bundleId": "com.evil.app", "productId": "{{AppleOptions.MonthlyProductId}}", "expiresDate": 123 }""";
        using var doc = JsonDocument.Parse(json);

        var result = AppleReceiptVerifier.ParsePayload(doc.RootElement, expectedBundleId: Bundle);

        Assert.False(result.IsValid);
        Assert.Equal("bundle_id_mismatch", result.RawError);
    }

    [Fact]
    public void ParsePayload_UnknownProduct_ReturnsInvalid()
    {
        var json = """{ "bundleId": "com.lingocross.lingoCrossApp", "productId": "com.other.unknown", "expiresDate": 123 }""";
        using var doc = JsonDocument.Parse(json);

        var result = AppleReceiptVerifier.ParsePayload(doc.RootElement, expectedBundleId: Bundle);

        Assert.False(result.IsValid);
        Assert.Equal("no_known_product", result.RawError);
    }

    [Fact]
    public void ParsePayload_KnownProduct_ReadsFields()
    {
        var ms = DateTimeOffset.UtcNow.AddDays(30).ToUnixTimeMilliseconds();
        var json = $$"""
        { "bundleId": "{{Bundle}}", "productId": "{{AppleOptions.AnnualProductId}}",
          "expiresDate": {{ms}}, "originalTransactionId": "orig-9" }
        """;
        using var doc = JsonDocument.Parse(json);

        var result = AppleReceiptVerifier.ParsePayload(doc.RootElement, expectedBundleId: null);

        Assert.True(result.IsValid);
        Assert.Equal(AppleOptions.AnnualProductId, result.ProductId);
        Assert.Equal("orig-9", result.OriginalTransactionId);
        Assert.Equal(DateTimeOffset.FromUnixTimeMilliseconds(ms), result.ExpiresAt);
    }

    private static AppleReceiptVerifier NewVerifier(TestChain chain, string? bundleId)
        => NewVerifierWithRoot(chain.Root, bundleId);

    private static AppleReceiptVerifier NewVerifierWithRoot(X509Certificate2 root, string? bundleId)
    {
        var options = Options.Create(new AppleOptions { SharedSecret = "x", BundleId = bundleId });
        return new AppleReceiptVerifier(options, NullLogger<AppleReceiptVerifier>.Instance, root);
    }

    private static string Base64Url(byte[] bytes) =>
        Convert.ToBase64String(bytes).TrimEnd('=').Replace('+', '-').Replace('/', '_');

    /// <summary>Test için ECDSA P-256 kök + uç (leaf) sertifika zinciri ve JWS imzalayıcı.</summary>
    private sealed class TestChain : IDisposable
    {
        public required X509Certificate2 Root { get; init; }
        public required X509Certificate2 Leaf { get; init; }
        public required ECDsa LeafKey { get; init; }

        public static TestChain Create()
        {
            var rootKey = ECDsa.Create(ECCurve.NamedCurves.nistP256);
            var rootReq = new CertificateRequest("CN=LC Test Root", rootKey, HashAlgorithmName.SHA256);
            rootReq.CertificateExtensions.Add(new X509BasicConstraintsExtension(true, false, 0, true));
            var root = rootReq.CreateSelfSigned(
                DateTimeOffset.UtcNow.AddDays(-1), DateTimeOffset.UtcNow.AddYears(1));

            var leafKey = ECDsa.Create(ECCurve.NamedCurves.nistP256);
            var leafReq = new CertificateRequest("CN=LC Test Leaf", leafKey, HashAlgorithmName.SHA256);
            leafReq.CertificateExtensions.Add(new X509BasicConstraintsExtension(false, false, 0, false));
            var leaf = leafReq.Create(
                root, DateTimeOffset.UtcNow.AddDays(-1), DateTimeOffset.UtcNow.AddMonths(6), new byte[] { 1, 2, 3, 4 });

            return new TestChain { Root = root, Leaf = leaf, LeafKey = leafKey };
        }

        public string SignTransaction(Dictionary<string, object?> payload)
        {
            var header = new Dictionary<string, object?>
            {
                ["alg"] = "ES256",
                ["x5c"] = new[]
                {
                    Convert.ToBase64String(Leaf.RawData),
                    Convert.ToBase64String(Root.RawData),
                },
            };

            var headerB64 = Base64Url(JsonSerializer.SerializeToUtf8Bytes(header));
            var payloadB64 = Base64Url(JsonSerializer.SerializeToUtf8Bytes(payload));
            var signingInput = $"{headerB64}.{payloadB64}";

            var signature = LeafKey.SignData(
                Encoding.ASCII.GetBytes(signingInput),
                HashAlgorithmName.SHA256,
                DSASignatureFormat.IeeeP1363FixedFieldConcatenation);

            return $"{signingInput}.{Base64Url(signature)}";
        }

        public void Dispose()
        {
            Root.Dispose();
            Leaf.Dispose();
            LeafKey.Dispose();
        }
    }
}
