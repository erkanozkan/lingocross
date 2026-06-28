using System.Text.Json;
using LingoCross.Application.Subscriptions;
using LingoCross.Infrastructure.Subscriptions;

namespace LingoCross.Tests.Subscriptions;

/// <summary>
/// GoogleReceiptVerifier: Android Publisher <c>SubscriptionPurchaseV2</c> yanıtının saf (ağsız)
/// ayrıştırması. Abonelik durumu, ürün eşleştirme ve bitiş zamanı yorumlaması test edilir; ağ
/// çağrısı yoktur.
/// </summary>
public class GoogleReceiptVerifierTests
{
    [Fact]
    public void ParseSubscriptionV2_ActiveMatchingProduct_ReturnsValidWithFields()
    {
        var expiry = DateTimeOffset.UtcNow.AddDays(15);
        var json = $$"""
        {
          "subscriptionState": "SUBSCRIPTION_STATE_ACTIVE",
          "latestOrderId": "GPA.1234-5678",
          "lineItems": [
            { "productId": "{{AppleOptions.MonthlyProductId}}", "expiryTime": "{{expiry:o}}" }
          ]
        }
        """;
        using var doc = JsonDocument.Parse(json);

        var result = GoogleReceiptVerifier.ParseSubscriptionV2(doc.RootElement, AppleOptions.MonthlyProductId);

        Assert.True(result.IsValid);
        Assert.Equal(AppleOptions.MonthlyProductId, result.ProductId);
        Assert.Equal("GPA.1234-5678", result.OriginalTransactionId);
        Assert.NotNull(result.ExpiresAt);
        Assert.Equal(expiry.ToUnixTimeSeconds(), result.ExpiresAt!.Value.ToUnixTimeSeconds());
    }

    [Fact]
    public void ParseSubscriptionV2_UnknownProduct_ReturnsInvalid()
    {
        var json = $$"""
        {
          "subscriptionState": "SUBSCRIPTION_STATE_ACTIVE",
          "lineItems": [
            { "productId": "com.other.unknown", "expiryTime": "{{DateTimeOffset.UtcNow.AddDays(10):o}}" }
          ]
        }
        """;
        using var doc = JsonDocument.Parse(json);

        var result = GoogleReceiptVerifier.ParseSubscriptionV2(doc.RootElement, "com.other.unknown");

        Assert.False(result.IsValid);
        Assert.Equal("no_known_product", result.RawError);
    }

    [Fact]
    public void ParseSubscriptionV2_ExpiredState_ReturnsInvalid()
    {
        var json = $$"""
        {
          "subscriptionState": "SUBSCRIPTION_STATE_EXPIRED",
          "lineItems": [
            { "productId": "{{AppleOptions.MonthlyProductId}}", "expiryTime": "{{DateTimeOffset.UtcNow.AddDays(-1):o}}" }
          ]
        }
        """;
        using var doc = JsonDocument.Parse(json);

        var result = GoogleReceiptVerifier.ParseSubscriptionV2(doc.RootElement, AppleOptions.MonthlyProductId);

        Assert.False(result.IsValid);
        Assert.Equal("SUBSCRIPTION_STATE_EXPIRED", result.RawError);
    }

    [Fact]
    public void ParseSubscriptionV2_GracePeriodAnnual_ReturnsValid()
    {
        var expiry = DateTimeOffset.UtcNow.AddDays(300);
        var json = $$"""
        {
          "subscriptionState": "SUBSCRIPTION_STATE_IN_GRACE_PERIOD",
          "latestOrderId": "GPA.9999",
          "lineItems": [
            { "productId": "{{AppleOptions.AnnualProductId}}", "expiryTime": "{{expiry:o}}" }
          ]
        }
        """;
        using var doc = JsonDocument.Parse(json);

        var result = GoogleReceiptVerifier.ParseSubscriptionV2(doc.RootElement, AppleOptions.AnnualProductId);

        Assert.True(result.IsValid);
        Assert.Equal(AppleOptions.AnnualProductId, result.ProductId);
        Assert.Equal("GPA.9999", result.OriginalTransactionId);
        Assert.NotNull(result.ExpiresAt);
    }
}
