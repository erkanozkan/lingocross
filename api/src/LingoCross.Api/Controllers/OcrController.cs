using FluentValidation;
using LingoCross.Application.Ocr;
using LingoCross.Application.Ocr.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

[ApiController]
[Authorize(Roles = "Teacher")]
[Route("api/ocr")]
public class OcrController : ControllerBase
{
    private readonly IOcrEnrichmentService _enrichmentService;
    private readonly IServiceProvider _services;

    public OcrController(IOcrEnrichmentService enrichmentService, IServiceProvider services)
    {
        _enrichmentService = enrichmentService;
        _services = services;
    }

    /// <summary>
    /// OCR ham metnini Claude ile zenginleştirir: Türkçe karakter düzeltme, terim/karşılık
    /// ayrımı ve eşanlam üretimi. Yapılandırma yoksa veya sağlayıcı hatasında 503 döner.
    /// </summary>
    [HttpPost("enrich")]
    public async Task<ActionResult<OcrEnrichResponse>> Enrich(OcrEnrichRequest request, CancellationToken ct)
    {
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
