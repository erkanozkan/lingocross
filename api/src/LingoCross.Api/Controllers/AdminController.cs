using LingoCross.Application.Admin;
using LingoCross.Application.Admin.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

/// <summary>
/// Back office (yönetim paneli) için salt-okur metrik uçları + tek-admin (env) girişi. Giriş
/// dışındaki tüm uçlar Admin rollü JWT gerektirir; Teacher/Student token'ları erişemez (403).
/// </summary>
[ApiController]
[Route("api/admin")]
public class AdminController : ControllerBase
{
    private readonly IAdminAuthService _authService;
    private readonly IAdminMetricsService _metricsService;

    public AdminController(IAdminAuthService authService, IAdminMetricsService metricsService)
    {
        _authService = authService;
        _metricsService = metricsService;
    }

    [AllowAnonymous]
    [HttpPost("login")]
    public ActionResult<AdminLoginResult> Login(AdminLoginRequest request)
    {
        var result = _authService.Login(request.Email, request.Password);
        return Ok(result);
    }

    [Authorize(Roles = "Admin")]
    [HttpGet("overview")]
    public async Task<ActionResult<OverviewDto>> Overview(CancellationToken ct)
        => Ok(await _metricsService.GetOverviewAsync(ct));

    [Authorize(Roles = "Admin")]
    [HttpGet("timeseries")]
    public async Task<ActionResult<TimeseriesDto>> Timeseries(
        [FromQuery] string metric, [FromQuery] int days, CancellationToken ct)
        => Ok(await _metricsService.GetTimeseriesAsync(metric, days, ct));

    [Authorize(Roles = "Admin")]
    [HttpGet("engagement")]
    public async Task<ActionResult<EngagementDto>> Engagement(CancellationToken ct)
        => Ok(await _metricsService.GetEngagementAsync(ct));

    [Authorize(Roles = "Admin")]
    [HttpGet("subscriptions")]
    public async Task<ActionResult<SubscriptionsDto>> Subscriptions([FromQuery] int days, CancellationToken ct)
        => Ok(await _metricsService.GetSubscriptionsAsync(days, ct));

    [Authorize(Roles = "Admin")]
    [HttpGet("recent")]
    public async Task<ActionResult<RecentDto>> Recent([FromQuery] int take, CancellationToken ct)
        => Ok(await _metricsService.GetRecentAsync(take, ct));
}
