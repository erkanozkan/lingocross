using FluentValidation;
using LingoCross.Application.Subscriptions;
using LingoCross.Application.Subscriptions.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

/// <summary>
/// Abonelik durumu + stub (sahte) satın alma/iptal. GERÇEK ÖDEME YOKTUR. Etkinleştirme/iptal
/// uçları yalnızca <c>Subscription:StubEnabled</c> açıkken çalışır (aksi halde 503). Apple IAP
/// makbuz doğrulaması (<c>apple/verify</c>) gerçek olarak yapılır; <c>Apple:SharedSecret</c> yoksa 503.
/// </summary>
[ApiController]
[Authorize]
[Route("api/subscription")]
public class SubscriptionController : ControllerBase
{
    private readonly ISubscriptionService _subscriptionService;
    private readonly IServiceProvider _services;

    public SubscriptionController(ISubscriptionService subscriptionService, IServiceProvider services)
    {
        _subscriptionService = subscriptionService;
        _services = services;
    }

    /// <summary>Geçerli kullanıcının abonelik durumu + uygulanan limitler (her zaman erişilebilir).</summary>
    [HttpGet("me")]
    public async Task<ActionResult<SubscriptionDto>> GetMine(CancellationToken ct)
    {
        var dto = await _subscriptionService.GetMineAsync(ct);
        return Ok(dto);
    }

    /// <summary>STUB: premium aboneliği etkinleştirir (trial veya aylık/yıllık). StubEnabled false ise 503.</summary>
    [HttpPost("activate")]
    public async Task<ActionResult<SubscriptionDto>> Activate(ActivateStubRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        var dto = await _subscriptionService.ActivateStubAsync(request, ct);
        return Ok(dto);
    }

    /// <summary>STUB: aboneliği iptal eder (Free'ye düşer). StubEnabled false ise 503.</summary>
    [HttpPost("cancel")]
    public async Task<ActionResult<SubscriptionDto>> Cancel(CancellationToken ct)
    {
        var dto = await _subscriptionService.CancelAsync(ct);
        return Ok(dto);
    }

    /// <summary>
    /// Apple App Store makbuzunu doğrular ve geçerliyse premium aboneliği (Source=AppleIap) upsert eder.
    /// <c>Apple:SharedSecret</c> ayarlı değilse 503, makbuz boş/doğrulanamazsa 400 döner.
    /// </summary>
    [HttpPost("apple/verify")]
    public async Task<ActionResult<SubscriptionDto>> VerifyApple(VerifyAppleReceiptRequest request, CancellationToken ct)
    {
        var dto = await _subscriptionService.VerifyAppleReceiptAsync(request.ReceiptData, ct);
        return Ok(dto);
    }

    /// <summary>
    /// Google Play satın alma jetonunu doğrular ve geçerliyse premium aboneliği (Source=GoogleIap) upsert eder.
    /// <c>Google:ServiceAccountJson</c>/<c>Google:PackageName</c> ayarlı değilse 503, jeton/ürün boş veya
    /// doğrulanamazsa 400 döner.
    /// </summary>
    [HttpPost("google/verify")]
    public async Task<ActionResult<SubscriptionDto>> VerifyGoogle(VerifyGoogleReceiptRequest request, CancellationToken ct)
    {
        var dto = await _subscriptionService.VerifyGoogleReceiptAsync(request.PurchaseToken, request.ProductId, ct);
        return Ok(dto);
    }

    private async Task ValidateAsync<T>(T instance, CancellationToken ct)
    {
        if (_services.GetService(typeof(IValidator<T>)) is not IValidator<T> validator)
        {
            return;
        }

        var result = await validator.ValidateAsync(instance, ct);
        if (!result.IsValid)
        {
            throw new ValidationException(result.Errors);
        }
    }
}
