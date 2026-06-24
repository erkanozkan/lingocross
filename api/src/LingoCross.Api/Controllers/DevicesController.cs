using FluentValidation;
using LingoCross.Application.Notifications;
using LingoCross.Application.Notifications.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/devices")]
public class DevicesController : ControllerBase
{
    private readonly IDeviceService _deviceService;
    private readonly IServiceProvider _services;

    public DevicesController(IDeviceService deviceService, IServiceProvider services)
    {
        _deviceService = deviceService;
        _services = services;
    }

    /// <summary>Cihazın push token'ını geçerli kullanıcıya kaydeder (upsert).</summary>
    [HttpPost]
    public async Task<IActionResult> Register(RegisterDeviceRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        await _deviceService.RegisterAsync(request, ct);
        return NoContent();
    }

    /// <summary>Geçerli kullanıcının verilen token kaydını siler (idempotent).</summary>
    [HttpDelete("{token}")]
    public async Task<IActionResult> Unregister(string token, CancellationToken ct)
    {
        await _deviceService.UnregisterAsync(token, ct);
        return NoContent();
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
