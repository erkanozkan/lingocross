using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using FluentValidation;
using LingoCross.Application.Auth;
using LingoCross.Application.Auth.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;
    private readonly IServiceProvider _services;

    public AuthController(IAuthService authService, IServiceProvider services)
    {
        _authService = authService;
        _services = services;
    }

    [HttpPost("register")]
    public async Task<ActionResult<AuthResponse>> Register(RegisterRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        var result = await _authService.RegisterAsync(request, ct);
        return Ok(result);
    }

    [HttpPost("login")]
    public async Task<ActionResult<AuthResponse>> Login(LoginRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        var result = await _authService.LoginAsync(request, ct);
        return Ok(result);
    }

    [HttpPost("refresh")]
    public async Task<ActionResult<AuthResponse>> Refresh(RefreshRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        var result = await _authService.RefreshAsync(request, ct);
        return Ok(result);
    }

    [HttpPost("logout")]
    public async Task<IActionResult> Logout(LogoutRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        await _authService.LogoutAsync(request, ct);
        return NoContent();
    }

    [HttpPost("forgot-password")]
    public async Task<IActionResult> ForgotPassword(ForgotPasswordRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        await _authService.ForgotPasswordAsync(request, ct);
        // Enumeration sızdırmamak için her zaman 200.
        return Ok(new { message = "Eğer bu e-posta bir hesaba aitse, sıfırlama bağlantısı gönderildi." });
    }

    [HttpPost("reset-password")]
    public async Task<IActionResult> ResetPassword(ResetPasswordRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        await _authService.ResetPasswordAsync(request, ct);
        return NoContent();
    }

    [Authorize]
    [HttpGet("me")]
    public async Task<ActionResult<UserDto>> Me(CancellationToken ct)
    {
        var sub = User.FindFirstValue(JwtRegisteredClaimNames.Sub)
            ?? User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(sub, out var userId))
        {
            return Unauthorized();
        }

        var user = await _authService.GetMeAsync(userId, ct);
        return Ok(user);
    }

    private async Task ValidateAsync<T>(T instance, CancellationToken ct)
    {
        var validator = _services.GetService(typeof(IValidator<T>)) as IValidator<T>;
        if (validator is null)
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
