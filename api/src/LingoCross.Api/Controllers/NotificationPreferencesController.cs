using LingoCross.Application.Notifications;
using LingoCross.Application.Notifications.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/me/notification-preferences")]
public class NotificationPreferencesController : ControllerBase
{
    private readonly INotificationPreferenceService _preferenceService;

    public NotificationPreferencesController(INotificationPreferenceService preferenceService)
    {
        _preferenceService = preferenceService;
    }

    /// <summary>Geçerli kullanıcının push bildirim tercihleri (kayıt yoksa varsayılanlar).</summary>
    [HttpGet]
    public async Task<ActionResult<NotificationPreferencesDto>> Get(CancellationToken ct)
    {
        var prefs = await _preferenceService.GetMineAsync(ct);
        return Ok(prefs);
    }

    /// <summary>Geçerli kullanıcının push bildirim tercihlerini günceller (upsert).</summary>
    [HttpPut]
    public async Task<ActionResult<NotificationPreferencesDto>> Put(NotificationPreferencesDto request, CancellationToken ct)
    {
        var prefs = await _preferenceService.UpsertMineAsync(request, ct);
        return Ok(prefs);
    }
}
