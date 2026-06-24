using FluentValidation;
using LingoCross.Application.Subscriptions;
using LingoCross.Application.Subscriptions.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

/// <summary>
/// Abonelik durumu + stub (sahte) satın alma/iptal. GERÇEK ÖDEME YOKTUR. Etkinleştirme/iptal
/// uçları yalnızca <c>Subscription:StubEnabled</c> açıkken çalışır (aksi halde 503). Apple IAP
/// doğrulaması ileriye dönük dikiştir (S3) ve şu an 501 döner.
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
    /// Apple IAP makbuz doğrulaması (S3 dikişi). Henüz uygulanmadı; 501 Not Implemented döner.
    /// </summary>
    [HttpPost("apple/verify")]
    public IActionResult VerifyApple()
        => StatusCode(StatusCodes.Status501NotImplemented);

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
