using LingoCross.Application.Enrollments;
using LingoCross.Application.Enrollments.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

[ApiController]
[Authorize(Roles = "Teacher")]
[Route("api/teachers")]
public class TeachersController : ControllerBase
{
    private readonly IEnrollmentService _enrollmentService;

    public TeachersController(IEnrollmentService enrollmentService)
    {
        _enrollmentService = enrollmentService;
    }

    /// <summary>Öğretmenin davet kodunu döndürür; yoksa üretir.</summary>
    [HttpGet("me/invite-code")]
    public async Task<ActionResult<InviteCodeDto>> GetInviteCode(CancellationToken ct)
    {
        var code = await _enrollmentService.GetOrCreateInviteCodeAsync(ct);
        return Ok(code);
    }

    /// <summary>Öğretmen için yeni bir davet kodu üretir (eskisinin yerine).</summary>
    [HttpPost("me/invite-code/regenerate")]
    public async Task<ActionResult<InviteCodeDto>> RegenerateInviteCode(CancellationToken ct)
    {
        var code = await _enrollmentService.RegenerateInviteCodeAsync(ct);
        return Ok(code);
    }
}
