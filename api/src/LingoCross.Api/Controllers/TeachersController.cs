using LingoCross.Application.Enrollments;
using LingoCross.Application.Enrollments.Dtos;
using LingoCross.Application.Teachers;
using LingoCross.Application.Teachers.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

[ApiController]
[Authorize(Roles = "Teacher")]
[Route("api/teachers")]
public class TeachersController : ControllerBase
{
    private readonly IEnrollmentService _enrollmentService;
    private readonly ITeacherTrackingService _trackingService;

    public TeachersController(
        IEnrollmentService enrollmentService,
        ITeacherTrackingService trackingService)
    {
        _enrollmentService = enrollmentService;
        _trackingService = trackingService;
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

    /// <summary>
    /// Öğretmenin Active eşleşmeli öğrencileri + her biri için paylaşılan sonuç özeti
    /// (sayı, ortalama skor, son aktivite).
    /// </summary>
    [HttpGet("me/students")]
    public async Task<ActionResult<IReadOnlyList<StudentSummaryDto>>> GetMyStudents(CancellationToken ct)
    {
        var students = await _trackingService.ListMyStudentsAsync(ct);
        return Ok(students);
    }

    /// <summary>
    /// Belirtilen öğrencinin bu öğretmenle paylaştığı sonuçları (yeniden eskiye) döndürür.
    /// Öğrenci öğretmene Active eşleşmeli değilse 404.
    /// </summary>
    [HttpGet("me/students/{studentId:guid}/results")]
    public async Task<ActionResult<IReadOnlyList<SharedResultDto>>> GetStudentResults(
        Guid studentId, CancellationToken ct)
    {
        var results = await _trackingService.GetStudentSharedResultsAsync(studentId, ct);
        return Ok(results);
    }
}
