using System.Net;
using System.Text;
using System.Text.Json;
using LingoCross.Application.Subscriptions;
using LingoCross.Infrastructure.Subscriptions;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;

namespace LingoCross.Tests.Subscriptions;

/// <summary>
/// S3 — AppleReceiptVerifier: prod→sandbox (21007) düşüşü, saf JSON-parse ve bundle id doğrulaması.
/// Apple'a GERÇEK istek atılmaz; HttpClient sahte handler ile sürülür.
/// </summary>
public class AppleReceiptVerifierTests
{
    private const string MonthlyProduct = AppleOptions.MonthlyProductId;

    [Fact]
    public async Task VerifyAsync_SandboxReceiptOnProduction_FallsBackToSandbox_AndParses()
    {
        // İlk (prod) yanıt 21007; ikinci (sandbox) yanıt geçerli.
        var expiresMs = DateTimeOffset.UtcNow.AddDays(15).ToUnixTimeMilliseconds();
        var handler = new SequencedHandler(
            ProdResponse(status: 21007),
            ValidSandboxResponse(MonthlyProduct, expiresMs, "txn-sandbox"));

        var verifier = NewVerifier(handler, sharedSecret: "secret");

        var result = await verifier.VerifyAsync("base64receipt");

        Assert.True(result.IsValid);
        Assert.Equal(MonthlyProduct, result.ProductId);
        Assert.Equal("txn-sandbox", result.OriginalTransactionId);
        Assert.Equal(DateTimeOffset.FromUnixTimeMilliseconds(expiresMs), result.ExpiresAt);

        // İki istek yapılmalı: önce prod, sonra sandbox.
        Assert.Equal(2, handler.Requests.Count);
        Assert.Contains("buy.itunes.apple.com", handler.Requests[0]);
        Assert.Contains("sandbox.itunes.apple.com", handler.Requests[1]);
    }

    [Fact]
    public async Task VerifyAsync_NonZeroStatus_ReturnsInvalid()
    {
        var handler = new SequencedHandler(ProdResponse(status: 21003));
        var verifier = NewVerifier(handler, sharedSecret: "secret");

        var result = await verifier.VerifyAsync("r");

        Assert.False(result.IsValid);
        Assert.Equal("21003", result.RawError);
        Assert.Single(handler.Requests); // 21007 olmadığı için sandbox'a düşmez.
    }

    [Fact]
    public void ParseResponse_PicksLatestExpiringKnownProduct()
    {
        var older = DateTimeOffset.UtcNow.AddDays(5).ToUnixTimeMilliseconds();
        var newer = DateTimeOffset.UtcNow.AddDays(40).ToUnixTimeMilliseconds();

        var json = $$"""
        {
          "status": 0,
          "latest_receipt_info": [
            { "product_id": "{{MonthlyProduct}}", "expires_date_ms": "{{older}}", "original_transaction_id": "old" },
            { "product_id": "{{AppleOptions.AnnualProductId}}", "expires_date_ms": "{{newer}}", "original_transaction_id": "new" },
            { "product_id": "com.other.unknown", "expires_date_ms": "99999999999999", "original_transaction_id": "ignored" }
          ]
        }
        """;

        using var doc = JsonDocument.Parse(json);
        var result = AppleReceiptVerifier.ParseResponse(doc.RootElement, expectedBundleId: null);

        Assert.True(result.IsValid);
        Assert.Equal(AppleOptions.AnnualProductId, result.ProductId);
        Assert.Equal("new", result.OriginalTransactionId);
    }

    [Fact]
    public void ParseResponse_BundleIdMismatch_ReturnsInvalid()
    {
        var ms = DateTimeOffset.UtcNow.AddDays(10).ToUnixTimeMilliseconds();
        var json = $$"""
        {
          "status": 0,
          "receipt": { "bundle_id": "com.evil.app" },
          "latest_receipt_info": [
            { "product_id": "{{MonthlyProduct}}", "expires_date_ms": {{ms}}, "original_transaction_id": "t" }
          ]
        }
        """;

        using var doc = JsonDocument.Parse(json);
        var result = AppleReceiptVerifier.ParseResponse(doc.RootElement, expectedBundleId: "com.lingocross.app");

        Assert.False(result.IsValid);
        Assert.Equal("bundle_id_mismatch", result.RawError);
    }

    [Fact]
    public void ParseResponse_NoKnownProduct_ReturnsInvalid()
    {
        var json = """
        {
          "status": 0,
          "latest_receipt_info": [
            { "product_id": "com.other.unknown", "expires_date_ms": "123", "original_transaction_id": "x" }
          ]
        }
        """;

        using var doc = JsonDocument.Parse(json);
        var result = AppleReceiptVerifier.ParseResponse(doc.RootElement, expectedBundleId: null);

        Assert.False(result.IsValid);
        Assert.Equal("no_known_product", result.RawError);
    }

    private static AppleReceiptVerifier NewVerifier(SequencedHandler handler, string? sharedSecret)
    {
        var factory = new SingleClientFactory(new HttpClient(handler));
        var options = Options.Create(new AppleOptions { SharedSecret = sharedSecret });
        return new AppleReceiptVerifier(factory, options, NullLogger<AppleReceiptVerifier>.Instance);
    }

    private static string ProdResponse(int status) => $$"""{ "status": {{status}} }""";

    private static string ValidSandboxResponse(string productId, long expiresMs, string txnId) => $$"""
    {
      "status": 0,
      "latest_receipt_info": [
        { "product_id": "{{productId}}", "expires_date_ms": "{{expiresMs}}", "original_transaction_id": "{{txnId}}" }
      ]
    }
    """;

    /// <summary>Sırayla yanıt veren ve istenen URL'leri kaydeden sahte handler.</summary>
    private sealed class SequencedHandler : HttpMessageHandler
    {
        private readonly Queue<string> _bodies;
        public List<string> Requests { get; } = new();

        public SequencedHandler(params string[] bodies) => _bodies = new Queue<string>(bodies);

        protected override Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request, CancellationToken cancellationToken)
        {
            Requests.Add(request.RequestUri!.ToString());
            var body = _bodies.Dequeue();
            return Task.FromResult(new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(body, Encoding.UTF8, "application/json"),
            });
        }
    }

    private sealed class SingleClientFactory : IHttpClientFactory
    {
        private readonly HttpClient _client;
        public SingleClientFactory(HttpClient client) => _client = client;
        public HttpClient CreateClient(string name) => _client;
    }
}
