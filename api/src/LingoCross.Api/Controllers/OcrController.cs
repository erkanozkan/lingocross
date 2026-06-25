using FluentValidation;
using LingoCross.Application.Ocr;
using LingoCross.Application.Ocr.Dtos;
using LingoCross.Application.Subscriptions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

[ApiController]
[Authorize(Roles = "Teacher")]
[Route("api/ocr")]
public class OcrController : ControllerBase
{
    private readonly IOcrEnrichmentService _enrichmentService;
    private readonly IEntitlementService _entitlement;
    private readonly IServiceProvider _services;

    public OcrController(
        IOcrEnrichmentService enrichmentService,
        IEntitlementService entitlement,
        IServiceProvider services)
    {
        _enrichmentService = enrichmentService;
        _entitlement = entitlement;
        _services = services;
    }

    /// <summary>
    /// Kelime listesi görüntüsünü (base64) Claude vision ile zenginleştirir: görüntüyü doğrudan
    /// okuyup terim/karşılık ayrımı ve eşanlam üretir. OCR Premium özelliğidir; Free öğretmen 402 (feature="ocr") alır.
    /// Rol kapısı (yalnız Teacher) [Authorize] ile sağlanır → öğrenci 403. Yapılandırma yoksa veya
    /// sağlayıcı hatasında 503 döner.
    /// </summary>
    [HttpPost("enrich")]
    public async Task<ActionResult<OcrEnrichResponse>> Enrich(OcrEnrichRequest request, CancellationToken ct)
    {
        await _entitlement.RequireOcrAsync(ct);
        await ValidateAsync(request, ct);
        var result = await _enrichmentService.EnrichAsync(request, ct);
        return Ok(result);
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
