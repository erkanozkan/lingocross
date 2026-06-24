using System.Security.Cryptography;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Enrollments.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Enrollments;

public class EnrollmentService : IEnrollmentService
{
    private readonly IAppDbContext _db;
    private readonly ICurrentUser _currentUser;
    private readonly Classes.IClassService _classService;

    public EnrollmentService(IAppDbContext db, ICurrentUser currentUser, Classes.IClassService classService)
    {
        _db = db;
        _currentUser = currentUser;
        _classService = classService;
    }

    public async Task<InviteCodeDto> GetOrCreateInviteCodeAsync(CancellationToken cancellationToken = default)
    {
        var teacher = await RequireTeacherEntityAsync(cancellationToken);

        if (string.IsNullOrWhiteSpace(teacher.InviteCode))
        {
            teacher.InviteCode = await GenerateUniqueInviteCodeAsync(cancellationToken);
            await _db.SaveChangesAsync(cancellationToken);
        }

        return new InviteCodeDto(teacher.InviteCode!);
    }

    public async Task<InviteCodeDto> RegenerateInviteCodeAsync(CancellationToken cancellationToken = default)
    {
        var teacher = await RequireTeacherEntityAsync(cancellationToken);

        teacher.InviteCode = await GenerateUniqueInviteCodeAsync(cancellationToken);
        await _db.SaveChangesAsync(cancellationToken);

        return new InviteCodeDto(teacher.InviteCode!);
    }

    public async Task<EnrollmentDto> JoinByCodeAsync(JoinByCodeRequest request, CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        var code = (request.Code ?? string.Empty).Trim().ToUpperInvariant();
        if (code.Length == 0)
        {
            throw AppException.BadRequest("Davet kodu boş olamaz.");
        }

        // F4.3 KÖPRÜ (geri uyum): kodu önce sınıf davet kodlarında ara. Bulunursa hem class_members
        // kaydı oluştur (yeni model) hem de geriye-uyumlu enrollment(Active) yaz (eski TestFlight
        // sürümü öğretmen↔öğrenci eşleşmesine güvenir).
        var matchedClass = await _classService.FindJoinableClassByCodeAsync(code, cancellationToken);
        var teacher = matchedClass is not null
            ? matchedClass.Teacher
            : await _db.Users.FirstOrDefaultAsync(
                u => u.Role == UserRole.Teacher && u.InviteCode == code, cancellationToken);

        if (teacher is null)
        {
            throw AppException.NotFound("Davet kodu geçersiz.");
        }

        if (matchedClass is not null)
        {
            await _classService.EnsureClassMembershipAsync(matchedClass.Id, studentId, cancellationToken);
        }

        // Idempotent: aynı (teacher, student) çifti zaten varsa mevcut eşleşmeyi döndür.
        var existing = await LoadWithCounterpartAsync(
            e => e.TeacherId == teacher.Id && e.StudentId == studentId, cancellationToken);

        if (existing is not null)
        {
            return ToDto(existing, counterpartIsTeacher: true);
        }

        var enrollment = new Enrollment
        {
            TeacherId = teacher.Id,
            StudentId = studentId,
            // M3 kararı: davet kodu paylaşımı rıza sayılır → doğrudan Active.
            Status = EnrollmentStatus.Active,
        };

        _db.Enrollments.Add(enrollment);
        await _db.SaveChangesAsync(cancellationToken);

        // Counterpart (öğretmen) bilgileriyle DTO üret.
        enrollment.Teacher = teacher;
        return ToDto(enrollment, counterpartIsTeacher: true);
    }

    public async Task<IReadOnlyList<EnrollmentDto>> ListMineAsync(CancellationToken cancellationToken = default)
    {
        var userId = RequireUser();
        var role = _currentUser.Role;

        if (role == UserRole.Teacher)
        {
            var rows = await _db.Enrollments
                .Where(e => e.TeacherId == userId)
                .Include(e => e.Student)
                .OrderByDescending(e => e.CreatedAt)
                .ToListAsync(cancellationToken);

            return rows.Select(e => ToDto(e, counterpartIsTeacher: false)).ToList();
        }

        var studentRows = await _db.Enrollments
            .Where(e => e.StudentId == userId)
            .Include(e => e.Teacher)
            .OrderByDescending(e => e.CreatedAt)
            .ToListAsync(cancellationToken);

        return studentRows.Select(e => ToDto(e, counterpartIsTeacher: true)).ToList();
    }

    public async Task<EnrollmentDto> AcceptAsync(Guid enrollmentId, CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        var enrollment = await _db.Enrollments
            .Include(e => e.Student)
            .FirstOrDefaultAsync(e => e.Id == enrollmentId, cancellationToken);

        // Varlığı sızdırmamak için başkasının eşleşmesi de 404.
        if (enrollment is null || enrollment.TeacherId != teacherId)
        {
            throw AppException.NotFound("Eşleşme bulunamadı.");
        }

        if (enrollment.Status == EnrollmentStatus.Active)
        {
            return ToDto(enrollment, counterpartIsTeacher: false);
        }

        if (enrollment.Status == EnrollmentStatus.Rejected)
        {
            throw AppException.BadRequest("Reddedilmiş bir eşleşme onaylanamaz.");
        }

        enrollment.Status = EnrollmentStatus.Active;
        await _db.SaveChangesAsync(cancellationToken);

        return ToDto(enrollment, counterpartIsTeacher: false);
    }

    private async Task<Enrollment?> LoadWithCounterpartAsync(
        System.Linq.Expressions.Expression<Func<Enrollment, bool>> predicate,
        CancellationToken cancellationToken)
        => await _db.Enrollments
            .Include(e => e.Teacher)
            .FirstOrDefaultAsync(predicate, cancellationToken);

    private Guid RequireUser()
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        return userId;
    }

    private Guid RequireStudent()
    {
        var userId = RequireUser();
        if (_currentUser.Role != UserRole.Student)
        {
            throw new AppException(403, "Bu işlem için öğrenci yetkisi gerekir.");
        }

        return userId;
    }

    private Guid RequireTeacher()
    {
        var userId = RequireUser();
        if (_currentUser.Role != UserRole.Teacher)
        {
            throw new AppException(403, "Bu işlem için öğretmen yetkisi gerekir.");
        }

        return userId;
    }

    private async Task<User> RequireTeacherEntityAsync(CancellationToken cancellationToken)
    {
        var teacherId = RequireTeacher();
        var teacher = await _db.Users.FirstOrDefaultAsync(u => u.Id == teacherId, cancellationToken);
        if (teacher is null)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        return teacher;
    }

    private async Task<string> GenerateUniqueInviteCodeAsync(CancellationToken cancellationToken)
    {
        for (var attempt = 0; attempt < 10; attempt++)
        {
            var code = GenerateInviteCode();
            var exists = await _db.Users.AnyAsync(u => u.InviteCode == code, cancellationToken);
            if (!exists)
            {
                return code;
            }
        }

        throw AppException.Conflict("Davet kodu üretilemedi, lütfen tekrar deneyin.");
    }

    private static string GenerateInviteCode()
    {
        // Karışması kolay karakterler (0/O, 1/I) çıkarılmış 8 haneli kod.
        const string alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        var bytes = RandomNumberGenerator.GetBytes(8);
        return string.Create(8, bytes, static (span, src) =>
        {
            for (var i = 0; i < span.Length; i++)
            {
                span[i] = alphabet[src[i] % alphabet.Length];
            }
        });
    }

    private static EnrollmentDto ToDto(Enrollment e, bool counterpartIsTeacher)
    {
        var counterpart = counterpartIsTeacher ? e.Teacher : e.Student;
        return new EnrollmentDto(
            e.Id,
            e.TeacherId,
            e.StudentId,
            e.Status,
            counterpart?.Id ?? (counterpartIsTeacher ? e.TeacherId : e.StudentId),
            counterpart?.DisplayName ?? string.Empty,
            counterpart?.Email ?? string.Empty,
            e.CreatedAt,
            e.UpdatedAt);
    }
}
