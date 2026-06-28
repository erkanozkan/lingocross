using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using LingoCross.Application.Subscriptions;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace LingoCross.Infrastructure.Subscriptions;

/// <summary>
/// <see cref="IGoogleReceiptVerifier"/>'i Google Android Publisher API'nin <c>subscriptionsv2</c>
/// ucu üzerinden uygular. Akış:
/// <list type="number">
///   <item>Servis hesabı anahtarından (ServiceAccountJson) RS256 imzalı bir OAuth2 JWT üretilir.</item>
///   <item>JWT, <c>jwt-bearer</c> grant ile erişim jetonuna takas edilir (token kısa süre cache'lenir).</item>
///   <item>Abonelik jetonu <c>purchases/subscriptionsv2/tokens/{token}</c> ile sorgulanır.</item>
///   <item>Dönen <c>SubscriptionPurchaseV2</c> JSON'u <see cref="ParseSubscriptionV2"/> ile yorumlanır.</item>
/// </list>
/// Her hata yutulur ve <see cref="GoogleVerifyResult.IsValid"/> false döner (sebep
/// <see cref="GoogleVerifyResult.RawError"/>).
/// </summary>
public class GoogleReceiptVerifier : IGoogleReceiptVerifier
{
    private const string AndroidPublisherScope = "https://www.googleapis.com/auth/androidpublisher";
    private const string DefaultTokenUri = "https://oauth2.googleapis.com/token";
    private const string JwtBearerGrant = "urn:ietf:params:oauth:grant-type:jwt-bearer";

    private readonly IHttpClientFactory _httpClientFactory;
    private readonly GoogleOptions _options;
    private readonly ILogger<GoogleReceiptVerifier> _logger;

    // OAuth2 erişim jetonu birden çok çağrı arasında paylaşılır; her doğrulamada yeniden alınmaz.
    private static readonly object TokenLock = new();
    private static string? _cachedAccessToken;
    private static DateTimeOffset _cachedTokenExpiry = DateTimeOffset.MinValue;

    public GoogleReceiptVerifier(
        IHttpClientFactory httpClientFactory,
        IOptions<GoogleOptions> options,
        ILogger<GoogleReceiptVerifier> logger)
    {
        _httpClientFactory = httpClientFactory;
        _options = options.Value;
        _logger = logger;
    }

    public async Task<GoogleVerifyResult> VerifyAsync(string purchaseToken, string productId, CancellationToken cancellationToken = default)
    {
        try
        {
            using var keyDoc = JsonDocument.Parse(_options.ServiceAccountJson ?? string.Empty);
            var key = keyDoc.RootElement;

            var clientEmail = key.TryGetProperty("client_email", out var emailEl) ? emailEl.GetString() : null;
            var privateKey = key.TryGetProperty("private_key", out var pkEl) ? pkEl.GetString() : null;
            var tokenUri = key.TryGetProperty("token_uri", out var tuEl) ? tuEl.GetString() : null;
            tokenUri = string.IsNullOrWhiteSpace(tokenUri) ? DefaultTokenUri : tokenUri;

            if (string.IsNullOrWhiteSpace(clientEmail) || string.IsNullOrWhiteSpace(privateKey))
            {
                return Invalid("bad_service_account");
            }

            var accessToken = await GetAccessTokenAsync(clientEmail, privateKey, tokenUri, cancellationToken);

            var http = _httpClientFactory.CreateClient();
            var url = "https://androidpublisher.googleapis.com/androidpublisher/v3/applications/"
                + $"{_options.PackageName}/purchases/subscriptionsv2/tokens/{purchaseToken}";

            using var request = new HttpRequestMessage(HttpMethod.Get, url);
            request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", accessToken);

            using var response = await http.SendAsync(request, cancellationToken);
            response.EnsureSuccessStatusCode();

            await using var stream = await response.Content.ReadAsStreamAsync(cancellationToken);
            using var purchaseDoc = await JsonDocument.ParseAsync(stream, cancellationToken: cancellationToken);

            var result = ParseSubscriptionV2(purchaseDoc.RootElement, productId);

            // OriginalTransactionId yoksa (latestOrderId gelmediyse) jetonu referans olarak kullan.
            if (result.IsValid && string.IsNullOrWhiteSpace(result.OriginalTransactionId))
            {
                result = result with { OriginalTransactionId = purchaseToken };
            }

            return result;
        }
        catch (Exception ex) when (ex is HttpRequestException or JsonException or CryptographicException or FormatException)
        {
            _logger.LogWarning(ex, "Google satın alma doğrulaması sırasında hata.");
            return Invalid("provider_error");
        }
    }

    /// <summary>
    /// Servis hesabıyla bir OAuth2 erişim jetonu alır. Geçerli (sona ermesine ~60sn'den fazla)
    /// cache'lenmiş jeton varsa onu döndürür.
    /// </summary>
    private async Task<string> GetAccessTokenAsync(string clientEmail, string privateKey, string tokenUri, CancellationToken cancellationToken)
    {
        lock (TokenLock)
        {
            if (_cachedAccessToken is not null && _cachedTokenExpiry > DateTimeOffset.UtcNow.AddSeconds(60))
            {
                return _cachedAccessToken;
            }
        }

        var jwt = BuildSignedJwt(clientEmail, privateKey, tokenUri);

        var http = _httpClientFactory.CreateClient();
        using var content = new FormUrlEncodedContent(new[]
        {
            new KeyValuePair<string, string>("grant_type", JwtBearerGrant),
            new KeyValuePair<string, string>("assertion", jwt),
        });

        using var response = await http.PostAsync(tokenUri, content, cancellationToken);
        response.EnsureSuccessStatusCode();

        await using var stream = await response.Content.ReadAsStreamAsync(cancellationToken);
        using var doc = await JsonDocument.ParseAsync(stream, cancellationToken: cancellationToken);
        var root = doc.RootElement;

        var accessToken = root.TryGetProperty("access_token", out var atEl) ? atEl.GetString() : null;
        var expiresIn = root.TryGetProperty("expires_in", out var exEl) && exEl.TryGetInt32(out var s) ? s : 3600;

        if (string.IsNullOrWhiteSpace(accessToken))
        {
            throw new HttpRequestException("OAuth2 yanıtı access_token içermiyor.");
        }

        lock (TokenLock)
        {
            _cachedAccessToken = accessToken;
            _cachedTokenExpiry = DateTimeOffset.UtcNow.AddSeconds(expiresIn);
        }

        return accessToken;
    }

    /// <summary>
    /// Servis hesabı akışı için RS256 imzalı bir JWT (assertion) üretir.
    /// </summary>
    private static string BuildSignedJwt(string clientEmail, string privateKey, string tokenUri)
    {
        var now = DateTimeOffset.UtcNow;

        var header = new Dictionary<string, object?> { ["alg"] = "RS256", ["typ"] = "JWT" };
        var claims = new Dictionary<string, object?>
        {
            ["iss"] = clientEmail,
            ["scope"] = AndroidPublisherScope,
            ["aud"] = tokenUri,
            ["iat"] = now.ToUnixTimeSeconds(),
            ["exp"] = now.AddHours(1).ToUnixTimeSeconds(),
        };

        var headerB64 = Base64UrlEncode(JsonSerializer.SerializeToUtf8Bytes(header));
        var claimsB64 = Base64UrlEncode(JsonSerializer.SerializeToUtf8Bytes(claims));
        var signingInput = $"{headerB64}.{claimsB64}";

        using var rsa = RSA.Create();
        rsa.ImportFromPem(privateKey);
        var signature = rsa.SignData(
            Encoding.ASCII.GetBytes(signingInput),
            HashAlgorithmName.SHA256,
            RSASignaturePadding.Pkcs1);

        return $"{signingInput}.{Base64UrlEncode(signature)}";
    }

    /// <summary>
    /// <c>SubscriptionPurchaseV2</c> JSON'unu yorumlar. Saf (ağsız) olduğu için doğrudan birim
    /// testlenebilir. Geçerli kabul edilen durumlar: aktif, ödemesiz dönem (grace) ve iptal edilmiş
    /// (henüz ödenmiş dönem içinde olabilir). Diğer durumlar geçersizdir.
    /// </summary>
    /// <param name="root">Abonelik satın alma yanıtının kök JSON elemanı.</param>
    /// <param name="expectedProductId">Beklenen ürün kimliği; lineItems içinden bu eşleşme tercih edilir.</param>
    public static GoogleVerifyResult ParseSubscriptionV2(JsonElement root, string expectedProductId)
    {
        var state = root.TryGetProperty("subscriptionState", out var stateEl) ? stateEl.GetString() : null;

        var acceptable = state is "SUBSCRIPTION_STATE_ACTIVE"
            or "SUBSCRIPTION_STATE_IN_GRACE_PERIOD"
            or "SUBSCRIPTION_STATE_CANCELED";
        if (!acceptable)
        {
            return Invalid(state ?? "unknown_state");
        }

        if (!root.TryGetProperty("lineItems", out var lineItemsEl)
            || lineItemsEl.ValueKind != JsonValueKind.Array
            || lineItemsEl.GetArrayLength() == 0)
        {
            return Invalid("no_known_product");
        }

        string? chosenProductId = null;
        DateTimeOffset? chosenExpiry = null;

        foreach (var item in lineItemsEl.EnumerateArray())
        {
            var pid = item.TryGetProperty("productId", out var pidEl) ? pidEl.GetString() : null;
            if (pid is null)
            {
                continue;
            }

            DateTimeOffset? expiry = null;
            if (item.TryGetProperty("expiryTime", out var expEl) && expEl.GetString() is { } expStr
                && DateTimeOffset.TryParse(expStr, CultureInfo.InvariantCulture, DateTimeStyles.RoundtripKind, out var parsed))
            {
                expiry = parsed;
            }

            // Beklenen ürün eşleşirse onu seç; aksi halde en geç biten satırı tut.
            if (pid == expectedProductId)
            {
                chosenProductId = pid;
                chosenExpiry = expiry;
                break;
            }

            if (chosenProductId is null || (expiry is { } e && chosenExpiry is { } c && e > c))
            {
                chosenProductId = pid;
                chosenExpiry = expiry;
            }
        }

        if (!AppleOptions.IsKnownProduct(chosenProductId))
        {
            return Invalid("no_known_product");
        }

        var orderId = root.TryGetProperty("latestOrderId", out var orderEl) ? orderEl.GetString() : null;

        return new GoogleVerifyResult(
            IsValid: true,
            ProductId: chosenProductId,
            ExpiresAt: chosenExpiry,
            OriginalTransactionId: orderId,
            RawError: null);
    }

    /// <summary>base64url (dolgusuz, <c>-_</c> alfabesi) kodlar.</summary>
    private static string Base64UrlEncode(byte[] bytes) =>
        Convert.ToBase64String(bytes).TrimEnd('=').Replace('+', '-').Replace('/', '_');

    private static GoogleVerifyResult Invalid(string error) => new(false, null, null, null, error);
}
