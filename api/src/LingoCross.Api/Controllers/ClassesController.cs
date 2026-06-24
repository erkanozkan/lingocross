using FluentValidation;
using LingoCross.Application.Classes;
using LingoCross.Application.Classes.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace LingoCross.Api.Controllers;

/// <summary>
/// Adlandırılmış sınıflar (F4.3). Öğretmen uçları sınıf CRUD + davet kodu + üye yönetimi; öğrenci
/// uçları sınıfları listeleme + koda katılma. Sahiplik/yetki kuralları servis katmanında uygulanır
/// (sahibi olmayan sınıf → 404).
/// </summary>
[ApiController]
[Authorize]
[Route("api/classes")]
public class ClassesController : ControllerBase
{
    private readonly IClassService _classService;
    private readonly IServiceProvider _services;

    public ClassesController(IClassService classService, IServiceProvider services)
    {
        _classService = classService;
        _services = services;
    }

    /// <summary>Öğretmen yeni bir sınıf oluşturur (davet kodu üretilir).</summary>
    [Authorize(Roles = "Teacher")]
    [HttpPost]
    public async Task<ActionResult<ClassDto>> Create(SaveClassRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        var dto = await _classService.CreateAsync(request, ct);
        return CreatedAtAction(nameof(Get), new { id = dto.Id }, dto);
    }

    /// <summary>Öğretmenin arşivlenmemiş sınıfları.</summary>
    [Authorize(Roles = "Teacher")]
    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<ClassDto>>> List(CancellationToken ct)
    {
        var dtos = await _classService.ListMineAsync(ct);
        return Ok(dtos);
    }

    /// <summary>Öğrencinin aktif üye olduğu sınıflar.</summary>
    [Authorize(Roles = "Student")]
    [HttpGet("me")]
    public async Task<ActionResult<IReadOnlyList<StudentClassDto>>> ListForMe(CancellationToken ct)
    {
        var dtos = await _classService.ListForStudentAsync(ct);
        return Ok(dtos);
    }

    /// <summary>Öğrenci, davet koduyla bir sınıfa katılır (idempotent).</summary>
    [Authorize(Roles = "Student")]
    [HttpPost("join")]
    public async Task<ActionResult<StudentClassDto>> Join(JoinClassRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        var dto = await _classService.JoinByCodeAsync(request, ct);
        return Ok(dto);
    }

    /// <summary>Sınıf detayı (aktif üyelerle). Sahibi değilse 404.</summary>
    [Authorize(Roles = "Teacher")]
    [HttpGet("{id:guid}")]
    public async Task<ActionResult<ClassDetailDto>> Get(Guid id, CancellationToken ct)
    {
        var dto = await _classService.GetAsync(id, ct);
        return Ok(dto);
    }

    /// <summary>Sınıf adını günceller. Sahibi değilse 404.</summary>
    [Authorize(Roles = "Teacher")]
    [HttpPut("{id:guid}")]
    public async Task<ActionResult<ClassDto>> Update(Guid id, SaveClassRequest request, CancellationToken ct)
    {
        await ValidateAsync(request, ct);
        var dto = await _classService.UpdateAsync(id, request, ct);
        return Ok(dto);
    }

    /// <summary>Sınıfı arşivler (is_archived=true). Sahibi değilse 404.</summary>
    [Authorize(Roles = "Teacher")]
    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id, CancellationToken ct)
    {
        await _classService.ArchiveAsync(id, ct);
        return NoContent();
    }

    /// <summary>Sınıfın davet kodunu döndürür; yoksa üretir. Sahibi değilse 404.</summary>
    [Authorize(Roles = "Teacher")]
    [HttpGet("{id:guid}/invite-code")]
    public async Task<ActionResult<ClassInviteCodeDto>> GetInviteCode(Guid id, CancellationToken ct)
    {
        var dto = await _classService.GetOrCreateInviteCodeAsync(id, ct);
        return Ok(dto);
    }

    /// <summary>Sınıf için yeni bir davet kodu üretir (eskisinin yerine). Sahibi değilse 404.</summary>
    [Authorize(Roles = "Teacher")]
    [HttpPost("{id:guid}/invite-code/regenerate")]
    public async Task<ActionResult<ClassInviteCodeDto>> RegenerateInviteCode(Guid id, CancellationToken ct)
    {
        var dto = await _classService.RegenerateInviteCodeAsync(id, ct);
        return Ok(dto);
    }

    /// <summary>Bir öğrenciyi sınıftan çıkarır. Sahibi değilse 404.</summary>
    [Authorize(Roles = "Teacher")]
    [HttpDelete("{id:guid}/students/{studentId:guid}")]
    public async Task<IActionResult> RemoveStudent(Guid id, Guid studentId, CancellationToken ct)
    {
        await _classService.RemoveStudentAsync(id, studentId, ct);
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
