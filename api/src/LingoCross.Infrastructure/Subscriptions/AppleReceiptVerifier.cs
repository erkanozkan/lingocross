using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using LingoCross.Application.Subscriptions;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace LingoCross.Infrastructure.Subscriptions;

/// <summary>
/// <see cref="IAppleReceiptVerifier"/>'i Apple'ın klasik <c>verifyReceipt</c> ucu ile uygular.
/// Apple'ın önerdiği akış: önce production'a POST; yanıt <c>status == 21007</c> ise (sandbox makbuzu
/// production'a gönderilmiş) sandbox ucuna tekrar gönder. <c>status == 0</c> geçerlidir.
/// <para>
/// Geçerli makbuzda <c>latest_receipt_info</c> dizisinden bizim premium ürünlerimize ait satın
/// almalar arasında en geç biten (<c>expires_date_ms</c>) seçilir. Sağlayıcı/ağ/parse hataları
/// yutulur ve <see cref="AppleVerifyResult.IsValid"/> false döner; servis katmanı 400'e çevirir.
/// </para>
/// </summary>
public class AppleReceiptVerifier : IAppleReceiptVerifier
{
    private const string ProductionUrl = "https://buy.itunes.apple.com/verifyReceipt";
    private const string SandboxUrl = "https://sandbox.itunes.apple.com/verifyReceipt";

    /// <summary>Sandbox makbuzu production'a gönderildiğinde Apple'ın döndürdüğü status.</summary>
    private const int StatusSandboxReceiptOnProduction = 21007;

    private const int StatusValid = 0;

    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);

    private readonly IHttpClientFactory _httpClientFactory;
    private readonly AppleOptions _options;
    private readonly ILogger<AppleReceiptVerifier> _logger;

    public AppleReceiptVerifier(
        IHttpClientFactory httpClientFactory,
        IOptions<AppleOptions> options,
        ILogger<AppleReceiptVerifier> logger)
    {
        _httpClientFactory = httpClientFactory;
        _options = options.Value;
        _logger = logger;
    }

    public async Task<AppleVerifyResult> VerifyAsync(string receiptData, CancellationToken cancellationToken = default)
    {
        try
        {
            using var client = _httpClientFactory.CreateClient();

            var json = await PostAsync(client, ProductionUrl, receiptData, _options.SharedSecret, cancellationToken);

            // Sandbox makbuzu production'a düşmüşse sandbox'a tekrar gönder (Apple'ın önerdiği akış).
            if (json.RootElement.TryGetProperty("status", out var statusEl)
                && statusEl.TryGetInt32(out var status)
                && status == StatusSandboxReceiptOnProduction)
            {
                json.Dispose();
                json = await PostAsync(client, SandboxUrl, receiptData, _options.SharedSecret, cancellationToken);
            }

            using (json)
            {
                return ParseResponse(json.RootElement, _options.BundleId);
            }
        }
        catch (Exception ex) when (ex is HttpRequestException or TaskCanceledException or JsonException)
        {
            _logger.LogWarning(ex, "Apple makbuz doğrulama çağrısı başarısız.");
            return Invalid("provider_error");
        }
    }

    private static async Task<JsonDocument> PostAsync(
        HttpClient client,
        string url,
        string receiptData,
        string? sharedSecret,
        CancellationToken cancellationToken)
    {
        var body = new AppleVerifyRequest
        {
            ReceiptData = receiptData,
            Password = sharedSecret,
            ExcludeOldTransactions = true,
        };

        using var response = await client.PostAsJsonAsync(url, body, cancellationToken);
        response.EnsureSuccessStatusCode();

        var stream = await response.Content.ReadAsStreamAsync(cancellationToken);
        return await JsonDocument.ParseAsync(stream, cancellationToken: cancellationToken);
    }

    /// <summary>
    /// Apple yanıtını ayrıştırır. Saf (ağsız) olduğu için doğrudan birim testlenebilir.
    /// </summary>
    /// <param name="root">Apple <c>verifyReceipt</c> yanıtının kök JSON elemanı.</param>
    /// <param name="expectedBundleId">Doluysa <c>receipt.bundle_id</c> ile eşleşmeli; aksi halde geçersiz.</param>
    public static AppleVerifyResult ParseResponse(JsonElement root, string? expectedBundleId)
    {
        if (!root.TryGetProperty("status", out var statusEl) || !statusEl.TryGetInt32(out var status))
        {
            return Invalid("missing_status");
        }

        if (status != StatusValid)
        {
            return Invalid(status.ToString());
        }

        // Opsiyonel bundle id doğrulaması.
        if (!string.IsNullOrWhiteSpace(expectedBundleId))
        {
            var bundleId = root.TryGetProperty("receipt", out var receiptEl)
                && receiptEl.TryGetProperty("bundle_id", out var bundleEl)
                    ? bundleEl.GetString()
                    : null;

            if (!string.Equals(bundleId, expectedBundleId, StringComparison.Ordinal))
            {
                return Invalid("bundle_id_mismatch");
            }
        }

        if (!root.TryGetProperty("latest_receipt_info", out var infoArray)
            || infoArray.ValueKind != JsonValueKind.Array)
        {
            return Invalid("no_latest_receipt_info");
        }

        AppleVerifyResult? best = null;
        long bestExpiresMs = long.MinValue;

        foreach (var item in infoArray.EnumerateArray())
        {
            var productId = item.TryGetProperty("product_id", out var pidEl) ? pidEl.GetString() : null;
            if (!AppleOptions.IsKnownProduct(productId))
            {
                continue;
            }

            if (!item.TryGetProperty("expires_date_ms", out var expEl)
                || !TryReadLong(expEl, out var expiresMs))
            {
                continue;
            }

            if (expiresMs <= bestExpiresMs)
            {
                continue;
            }

            var originalTxnId = item.TryGetProperty("original_transaction_id", out var txnEl)
                ? txnEl.GetString()
                : null;

            bestExpiresMs = expiresMs;
            best = new AppleVerifyResult(
                IsValid: true,
                ProductId: productId,
                ExpiresAt: DateTimeOffset.FromUnixTimeMilliseconds(expiresMs),
                OriginalTransactionId: originalTxnId,
                RawError: null);
        }

        return best ?? Invalid("no_known_product");
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

    private static AppleVerifyResult Invalid(string error) => new(false, null, null, null, error);

    /// <summary>Apple klasik <c>verifyReceipt</c> istek gövdesi (kebab-case anahtarlar).</summary>
    private sealed class AppleVerifyRequest
    {
        [System.Text.Json.Serialization.JsonPropertyName("receipt-data")]
        public string ReceiptData { get; set; } = string.Empty;

        [System.Text.Json.Serialization.JsonPropertyName("password")]
        public string? Password { get; set; }

        [System.Text.Json.Serialization.JsonPropertyName("exclude-old-transactions")]
        public bool ExcludeOldTransactions { get; set; }
    }
}
