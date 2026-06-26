using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Text.Json;
using LingoCross.Application.Subscriptions;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace LingoCross.Infrastructure.Subscriptions;

/// <summary>
/// <see cref="IAppleReceiptVerifier"/>'i StoreKit 2'nin <c>jwsRepresentation</c>'ı (imzalı işlem
/// JWS'i) üzerinden uygular. <c>in_app_purchase</c> (StoreKit 2 varsayılan) mağaza tarafında
/// doğrulanmış işlemi base64url JWS olarak döndürür; biz de bu JWS'i <b>çevrimdışı</b> doğrularız:
/// <list type="number">
///   <item>JWS başlığındaki <c>x5c</c> sertifika zincirini gömülü <b>Apple Root CA - G3</b>'e kadar doğrula.</item>
///   <item>İmzayı (ES256) zincirin uç (leaf) sertifikasının açık anahtarıyla doğrula.</item>
///   <item>Payload'dan ürün/bitiş/işlem bilgisini oku; <c>bundleId</c> ve bilinen ürün kontrolü yap.</item>
/// </list>
/// Eski <c>verifyReceipt</c> ucu (ve App-Specific Shared Secret) StoreKit 2 JWS'iyle uyumsuzdur
/// (Apple <c>21002</c> döner); bu yüzden ağ çağrısı yapılmaz. Her hata yutulur ve
/// <see cref="AppleVerifyResult.IsValid"/> false döner (sebep <see cref="AppleVerifyResult.RawError"/>).
/// </summary>
public class AppleReceiptVerifier : IAppleReceiptVerifier
{
    /// <summary>
    /// Apple Root CA - G3 (DER, base64). Kaynak: https://www.apple.com/certificateauthority/
    /// SHA-256: 63:34:3A:BF:B8:9A:6A:03:EB:B5:7E:9B:3F:5F:A7:BE:7C:4F:5C:75:6F:30:17:B3:A8:C4:88:C3:65:3E:91:79
    /// </summary>
    private const string AppleRootCaG3Base64 =
        "MIICQzCCAcmgAwIBAgIILcX8iNLFS5UwCgYIKoZIzj0EAwMwZzEbMBkGA1UEAwwSQXBwbGUg" +
        "Um9vdCBDQSAtIEczMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTET" +
        "MBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwHhcNMTQwNDMwMTgxOTA2WhcNMzkw" +
        "NDMwMTgxOTA2WjBnMRswGQYDVQQDDBJBcHBsZSBSb290IENBIC0gRzMxJjAkBgNVBAsMHUFw" +
        "cGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRMwEQYDVQQKDApBcHBsZSBJbmMuMQswCQYD" +
        "VQQGEwJVUzB2MBAGByqGSM49AgEGBSuBBAAiA2IABJjpLz1AcqTtkyJygRMc3RCV8cWjTnHc" +
        "FBbZDuWmBSp3ZHtfTjjTuxxEtX/1H7YyYl3J6YRbTzBPEVoA/VhYDKX1DyxNB0cTddqXl5d" +
        "vMVztK517IDvYuVTZXpmkOlEKMaNCMEAwHQYDVR0OBBYEFLuw3qFYM4iapIqZ3r6966/ayyS" +
        "rMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMAoGCCqGSM49BAMDA2gAMGUCMQCD" +
        "6cHEFl4aXTQY2e3v9GwOAEZLuN+yRhHFD/3meoyhpmvOwgPUnPWTxnS4at+qIxUCMG1mihDK" +
        "1A3UT82NQz60imOlM27jbdoXt2QfyFMm+YhidDkLF1vLUagM6BgD56KyKA==";

    private readonly AppleOptions _options;
    private readonly ILogger<AppleReceiptVerifier> _logger;
    private readonly X509Certificate2 _trustedRoot;

    public AppleReceiptVerifier(IOptions<AppleOptions> options, ILogger<AppleReceiptVerifier> logger)
        : this(options, logger, X509CertificateLoader.LoadCertificate(Convert.FromBase64String(AppleRootCaG3Base64)))
    {
    }

    /// <summary>Test için: güvenilen kök sertifika dışarıdan verilebilir (sahte zincir doğrulaması).</summary>
    internal AppleReceiptVerifier(
        IOptions<AppleOptions> options,
        ILogger<AppleReceiptVerifier> logger,
        X509Certificate2 trustedRoot)
    {
        _options = options.Value;
        _logger = logger;
        _trustedRoot = trustedRoot;
    }

    public Task<AppleVerifyResult> VerifyAsync(string receiptData, CancellationToken cancellationToken = default)
        => Task.FromResult(Verify(receiptData));

    /// <summary>İmzalı işlem JWS'ini çevrimdışı doğrular. Saf (ağsız) olduğu için birim testlenebilir.</summary>
    public AppleVerifyResult Verify(string signedTransaction)
    {
        if (string.IsNullOrWhiteSpace(signedTransaction))
        {
            return Invalid("empty");
        }

        try
        {
            var parts = signedTransaction.Split('.');
            if (parts.Length != 3)
            {
                return Invalid("not_jws");
            }

            using var headerDoc = JsonDocument.Parse(Base64UrlDecode(parts[0]));
            var header = headerDoc.RootElement;

            if (!header.TryGetProperty("alg", out var algEl) || algEl.GetString() != "ES256")
            {
                return Invalid("unsupported_alg");
            }

            if (!header.TryGetProperty("x5c", out var x5cEl)
                || x5cEl.ValueKind != JsonValueKind.Array
                || x5cEl.GetArrayLength() == 0)
            {
                return Invalid("missing_x5c");
            }

            var chainCerts = new List<X509Certificate2>();
            try
            {
                foreach (var certEl in x5cEl.EnumerateArray())
                {
                    var der = Convert.FromBase64String(certEl.GetString() ?? string.Empty);
                    chainCerts.Add(X509CertificateLoader.LoadCertificate(der));
                }

                var leaf = chainCerts[0];

                if (!VerifyChain(leaf, chainCerts.Skip(1)))
                {
                    return Invalid("chain_invalid");
                }

                if (!VerifySignature(parts[0], parts[1], parts[2], leaf))
                {
                    return Invalid("bad_signature");
                }
            }
            finally
            {
                foreach (var cert in chainCerts)
                {
                    cert.Dispose();
                }
            }

            using var payloadDoc = JsonDocument.Parse(Base64UrlDecode(parts[1]));
            return ParsePayload(payloadDoc.RootElement, _options.BundleId);
        }
        catch (Exception ex) when (ex is FormatException or JsonException or CryptographicException)
        {
            _logger.LogWarning(ex, "Apple JWS doğrulaması sırasında hata.");
            return Invalid("parse_error");
        }
    }

    /// <summary>Uç (leaf) sertifikadan güvenilen köke (Apple Root CA - G3) kadar zinciri doğrular.</summary>
    private bool VerifyChain(X509Certificate2 leaf, IEnumerable<X509Certificate2> extras)
    {
        using var chain = new X509Chain();
        chain.ChainPolicy.RevocationMode = X509RevocationMode.NoCheck;
        chain.ChainPolicy.TrustMode = X509ChainTrustMode.CustomRootTrust;
        chain.ChainPolicy.CustomTrustStore.Add(_trustedRoot);
        foreach (var extra in extras)
        {
            chain.ChainPolicy.ExtraStore.Add(extra);
        }

        return chain.Build(leaf);
    }

    /// <summary>JWS imzasını (ES256 = ECDSA P-256 / SHA-256) leaf sertifikanın açık anahtarıyla doğrular.</summary>
    private static bool VerifySignature(string headerB64, string payloadB64, string signatureB64, X509Certificate2 leaf)
    {
        using var ecdsa = leaf.GetECDsaPublicKey();
        if (ecdsa is null)
        {
            return false;
        }

        var signedData = Encoding.ASCII.GetBytes(headerB64 + "." + payloadB64);
        var signature = Base64UrlDecode(signatureB64);
        // JWS ES256 imzası R||S sabit-uzunluk (IEEE P1363) biçimindedir.
        return ecdsa.VerifyData(
            signedData,
            signature,
            HashAlgorithmName.SHA256,
            DSASignatureFormat.IeeeP1363FixedFieldConcatenation);
    }

    /// <summary>
    /// İmzalı işlem payload'ını ayrıştırır (StoreKit 2 <c>JWSTransactionDecodedPayload</c>). Saf
    /// olduğu için doğrudan birim testlenebilir.
    /// </summary>
    /// <param name="payload">JWS payload'ının kök JSON elemanı.</param>
    /// <param name="expectedBundleId">Doluysa payload <c>bundleId</c> ile eşleşmeli; aksi halde geçersiz.</param>
    public static AppleVerifyResult ParsePayload(JsonElement payload, string? expectedBundleId)
    {
        if (!string.IsNullOrWhiteSpace(expectedBundleId))
        {
            var bundleId = payload.TryGetProperty("bundleId", out var bundleEl) ? bundleEl.GetString() : null;
            if (!string.Equals(bundleId, expectedBundleId, StringComparison.Ordinal))
            {
                return Invalid("bundle_id_mismatch");
            }
        }

        var productId = payload.TryGetProperty("productId", out var pidEl) ? pidEl.GetString() : null;
        if (!AppleOptions.IsKnownProduct(productId))
        {
            return Invalid("no_known_product");
        }

        DateTimeOffset? expiresAt = null;
        if (payload.TryGetProperty("expiresDate", out var expEl) && TryReadLong(expEl, out var expiresMs))
        {
            expiresAt = DateTimeOffset.FromUnixTimeMilliseconds(expiresMs);
        }

        var originalTxnId = payload.TryGetProperty("originalTransactionId", out var txnEl)
            ? txnEl.GetString()
            : null;

        return new AppleVerifyResult(
            IsValid: true,
            ProductId: productId,
            ExpiresAt: expiresAt,
            OriginalTransactionId: originalTxnId,
            RawError: null);
    }

    /// <summary>Apple sayısal alanları kimi zaman string olarak döner; her iki biçimi de oku.</summary>
    private static bool TryReadLong(JsonElement element, out long value)
    {
        switch (element.ValueKind)
        {
            case JsonValueKind.Number when element.TryGetInt64(out value):
                return true;
            case JsonValueKind.String when long.TryParse(element.GetString(), out value):
                return true;
            default:
                value = 0;
                return false;
        }
    }

    /// <summary>base64url (dolgusuz, <c>-_</c> alfabesi) çözer.</summary>
    private static byte[] Base64UrlDecode(string input)
    {
        var s = input.Replace('-', '+').Replace('_', '/');
        switch (s.Length % 4)
        {
            case 2: s += "=="; break;
            case 3: s += "="; break;
        }

        return Convert.FromBase64String(s);
    }

    private static AppleVerifyResult Invalid(string error) => new(false, null, null, null, error);
}
