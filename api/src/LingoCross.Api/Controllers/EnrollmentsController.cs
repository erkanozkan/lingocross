using FluentValidation;
using LingoCross.Application.Enrollments;
using LingoCross.Application.Enrollments.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/enrollments")]
public class EnrollmentsController : ControllerBase
{
    private readonly IEnrollmentService _enrollmentService;
    private readonly IServiceProvider _services;

    public EnrollmentsController(IEnrollmentService enrollmentService, IServiceProvider services)
    {
        _enrollmentService = enrollmentService;
        _services = services;
    }

    /// <summary>Öğrenci, davet koduyla bir öğretmene katılır (idempotent).</summary>
    [Authorize(Roles = "Student")]
    [HttpPost("join")]
    public async Task<ActionResult<EnrollmentDto>> Join(JoinByCodeRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        var enrollment = await _enrollmentService.JoinByCodeAsync(request, ct);
        return Ok(enrollment);
    }

    /// <summary>Oturum açan kullanıcının eşleşmeleri (öğretmen → öğrenciler, öğrenci → öğretmenler).</summary>
    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<EnrollmentDto>>> List(CancellationToken ct)
    {
        var enrollments = await _enrollmentService.ListMineAsync(ct);
        return Ok(enrollments);
    }

    /// <summary>(Pending akışı için) Öğretmen, bekleyen bir eşleşmeyi onaylar.</summary>
    [Authorize(Roles = "Teacher")]
    [HttpPost("{id:guid}/accept")]
    public async Task<ActionResult<EnrollmentDto>> Accept(Guid id, CancellationToken ct)
    {
        var enrollment = await _enrollmentService.AcceptAsync(id, ct);
        return Ok(enrollment);
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
