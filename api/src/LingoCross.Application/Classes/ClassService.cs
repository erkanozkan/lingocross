using System.Security.Cryptography;
using LingoCross.Application.Classes.Dtos;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Subscriptions;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Classes;

/// <summary>
/// Adlandırılmış sınıf yönetimi (F4.3). Sahiplik servis katmanında uygulanır: tüm öğretmen
/// işlemlerinde sınıfın <c>TeacherId</c>'si geçerli kullanıcı değilse 404 (varlığı sızdırmamak için).
/// </summary>
public class ClassService : IClassService
{
    private readonly IAppDbContext _db;
    private readonly ICurrentUser _currentUser;
    private readonly IEntitlementService? _entitlement;

    // entitlement opsiyoneldir: null verildiğinde limit uygulanmaz (Premium gibi davranır). Üretimde
    // DI her zaman gerçek servisi enjekte eder; testler limit dışı senaryolarda null bırakabilir.
    public ClassService(IAppDbContext db, ICurrentUser currentUser, IEntitlementService? entitlement = null)
    {
        _db = db;
        _currentUser = currentUser;
        _entitlement = entitlement;
    }

    public async Task<ClassDto> CreateAsync(SaveClassRequest request, CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        if (_entitlement is not null)
        {
            // Yalnız aktif (arşivlenmemiş) sınıflar limite sayılır.
            var activeClassCount = await _db.Classes
                .CountAsync(c => c.TeacherId == teacherId && !c.IsArchived, cancellationToken);
            await _entitlement.RequireClassQuotaAsync(activeClassCount, cancellationToken);
        }

        var entity = new Class
        {
            TeacherId = teacherId,
            Name = request.Name.Trim(),
            InviteCode = await GenerateUniqueInviteCodeAsync(cancellationToken),
            IsArchived = false,
        };

        _db.Classes.Add(entity);
        await _db.SaveChangesAsync(cancellationToken);

        return new ClassDto(entity.Id, entity.Name, entity.InviteCode, 0, entity.CreatedAt);
    }

    public async Task<IReadOnlyList<ClassDto>> ListMineAsync(CancellationToken cancellationToken = default)
    {
        var teacherId = RequireTeacher();

        var rows = await _db.Classes
            .Where(c => c.TeacherId == teacherId && !c.IsArchived)
            .OrderByDescending(c => c.CreatedAt)
            .Select(c => new
            {
                c.Id,
                c.Name,
                c.InviteCode,
                c.CreatedAt,
                StudentCount = c.Members.Count(m => m.Status == ClassMemberStatus.Active),
            })
            .ToListAsync(cancellationToken);

        return rows
            .Select(c => new ClassDto(c.Id, c.Name, c.InviteCode, c.StudentCount, c.CreatedAt))
            .ToList();
    }

    public async Task<ClassDetailDto> GetAsync(Guid classId, CancellationToken cancellationToken = default)
    {
        var entity = await RequireOwnedClassAsync(classId, cancellationToken);

        var students = await _db.ClassMembers
            .Where(m => m.ClassId == entity.Id && m.Status == ClassMemberStatus.Active)
            .OrderBy(m => m.Student.DisplayName)
            .Select(m => new ClassMemberDto(m.StudentId, m.Student.DisplayName, m.Student.Email))
            .ToListAsync(cancellationToken);

        return new ClassDetailDto(entity.Id, entity.Name, entity.InviteCode, students.Count, students);
    }

    public async Task<ClassDto> UpdateAsync(Guid classId, SaveClassRequest request, CancellationToken cancellationToken = default)
    {
        var entity = await RequireOwnedClassAsync(classId, cancellationToken);

        entity.Name = request.Name.Trim();
        await _db.SaveChangesAsync(cancellationToken);

        var studentCount = await _db.ClassMembers
            .CountAsync(m => m.ClassId == entity.Id && m.Status == ClassMemberStatus.Active, cancellationToken);

        return new ClassDto(entity.Id, entity.Name, entity.InviteCode, studentCount, entity.CreatedAt);
    }

    public async Task ArchiveAsync(Guid classId, CancellationToken cancellationToken = default)
    {
        var entity = await RequireOwnedClassAsync(classId, cancellationToken);

        entity.IsArchived = true;
        await _db.SaveChangesAsync(cancellationToken);
    }

    public async Task<ClassInviteCodeDto> GetOrCreateInviteCodeAsync(Guid classId, CancellationToken cancellationToken = default)
    {
        var entity = await RequireOwnedClassAsync(classId, cancellationToken);

        if (string.IsNullOrWhiteSpace(entity.InviteCode))
        {
            entity.InviteCode = await GenerateUniqueInviteCodeAsync(cancellationToken);
            await _db.SaveChangesAsync(cancellationToken);
        }

        return new ClassInviteCodeDto(entity.InviteCode!);
    }

    public async Task<ClassInviteCodeDto> RegenerateInviteCodeAsync(Guid classId, CancellationToken cancellationToken = default)
    {
        var entity = await RequireOwnedClassAsync(classId, cancellationToken);

        entity.InviteCode = await GenerateUniqueInviteCodeAsync(cancellationToken);
        await _db.SaveChangesAsync(cancellationToken);

        return new ClassInviteCodeDto(entity.InviteCode!);
    }

    public async Task RemoveStudentAsync(Guid classId, Guid studentId, CancellationToken cancellationToken = default)
    {
        await RequireOwnedClassAsync(classId, cancellationToken);

        var member = await _db.ClassMembers
            .FirstOrDefaultAsync(m => m.ClassId == classId && m.StudentId == studentId, cancellationToken);

        // İdempotent: üye yoksa sessizce 204 (DELETE).
        if (member is not null)
        {
            _db.ClassMembers.Remove(member);
            await _db.SaveChangesAsync(cancellationToken);
        }
    }

    public async Task<IReadOnlyList<StudentClassDto>> ListForStudentAsync(CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        var rows = await _db.ClassMembers
            .Where(m => m.StudentId == studentId
                && m.Status == ClassMemberStatus.Active
                && !m.Class.IsArchived)
            .OrderByDescending(m => m.CreatedAt)
            .Select(m => new StudentClassDto(m.ClassId, m.Class.Name, m.Class.Teacher.DisplayName))
            .ToListAsync(cancellationToken);

        return rows;
    }

    public async Task<StudentClassDto> JoinByCodeAsync(JoinClassRequest request, CancellationToken cancellationToken = default)
    {
        var studentId = RequireStudent();

        var code = (request.Code ?? string.Empty).Trim().ToUpperInvariant();
        if (code.Length == 0)
        {
            throw AppException.BadRequest("Davet kodu boş olamaz.");
        }

        var entity = await FindJoinableClassByCodeAsync(code, cancellationToken);
        if (entity is null)
        {
            throw AppException.NotFound("Davet kodu geçersiz.");
        }

        // Çoklu öğretmen kapısı: yalnız YENİ bir öğretmene katılınıyorsa limit uygulanır
        // (aynı öğretmenin başka sınıfı / tekrar katılım idempotenttir, 402 yok).
        if (_entitlement is not null)
        {
            await RequireTeacherJoinAllowedAsync(studentId, entity.TeacherId, cancellationToken);
        }

        await EnsureClassMembershipAsync(entity.Id, studentId, cancellationToken);

        // Geri uyum: öğrenci panelinin "katıldı" durumu ve eski sürümler öğretmen↔öğrenci
        // enrollment'ına güvenir. /enrollments/join köprüsüyle simetrik olsun diye burada da yaz.
        await EnsureEnrollmentAsync(entity.TeacherId, studentId, cancellationToken);

        return new StudentClassDto(entity.Id, entity.Name, entity.Teacher.DisplayName);
    }

    /// <summary>(teacher, student) için Active enrollment yoksa oluşturur (idempotent).</summary>
    private async Task EnsureEnrollmentAsync(Guid teacherId, Guid studentId, CancellationToken cancellationToken)
    {
        var exists = await _db.Enrollments
            .AnyAsync(e => e.TeacherId == teacherId && e.StudentId == studentId, cancellationToken);

        if (exists)
        {
            return;
        }

        _db.Enrollments.Add(new Enrollment
        {
            TeacherId = teacherId,
            StudentId = studentId,
            Status = EnrollmentStatus.Active,
        });
        await _db.SaveChangesAsync(cancellationToken);
    }

    /// <summary>
    /// Verilen koda sahip katılınabilir (arşivlenmemiş) sınıfı öğretmeniyle birlikte getirir; yoksa null.
    /// Hem ClassService.JoinByCode hem de EnrollmentService köprüsü tarafından kullanılır.
    /// </summary>
    public async Task<Class?> FindJoinableClassByCodeAsync(string normalizedCode, CancellationToken cancellationToken)
        => await _db.Classes
            .Include(c => c.Teacher)
            .FirstOrDefaultAsync(c => c.InviteCode == normalizedCode && !c.IsArchived, cancellationToken);

    /// <summary>
    /// (class, student) için Active üyelik yoksa oluşturur (idempotent). Köprü için public.
    /// </summary>
    public async Task EnsureClassMembershipAsync(Guid classId, Guid studentId, CancellationToken cancellationToken)
    {
        var exists = await _db.ClassMembers
            .AnyAsync(m => m.ClassId == classId && m.StudentId == studentId, cancellationToken);

        if (exists)
        {
            return;
        }

        _db.ClassMembers.Add(new ClassMember
        {
            ClassId = classId,
            StudentId = studentId,
            Status = ClassMemberStatus.Active,
        });
        await _db.SaveChangesAsync(cancellationToken);
    }

    public async Task RequireTeacherJoinAllowedAsync(Guid studentId, Guid teacherId, CancellationToken cancellationToken)
    {
        if (_entitlement is null)
        {
            return;
        }

        var teacherIds = await GetDistinctTeacherIdsAsync(studentId, cancellationToken);

        // Aynı öğretmene tekrar/aynı öğretmenin başka sınıfı → kümede zaten var → limit uygulanmaz.
        if (teacherIds.Contains(teacherId))
        {
            return;
        }

        await _entitlement.RequireMultiTeacherJoinAsync(teacherIds.Count, cancellationToken);
    }

    /// <summary>
    /// Öğrencinin halihazırda ilişkili olduğu farklı öğretmenlerin kümesi: sınıf üyeliklerinden
    /// (class_members → class.teacher_id) ve geriye-uyumlu enrollment'lardan (enrollment.teacher_id) türetilir.
    /// </summary>
    private async Task<HashSet<Guid>> GetDistinctTeacherIdsAsync(Guid studentId, CancellationToken cancellationToken)
    {
        var fromClasses = await _db.ClassMembers
            .Where(m => m.StudentId == studentId)
            .Select(m => m.Class.TeacherId)
            .ToListAsync(cancellationToken);

        var fromEnrollments = await _db.Enrollments
            .Where(e => e.StudentId == studentId)
            .Select(e => e.TeacherId)
            .ToListAsync(cancellationToken);

        return fromClasses.Concat(fromEnrollments).ToHashSet();
    }

    private async Task<Class> RequireOwnedClassAsync(Guid classId, CancellationToken cancellationToken)
    {
        var teacherId = RequireTeacher();

        var entity = await _db.Classes.FirstOrDefaultAsync(c => c.Id == classId, cancellationToken);
        // Sahibi olmayan/yok olan/arşivli sınıf da dahil bulunamayan her durumda 404.
        if (entity is null || entity.TeacherId != teacherId || entity.IsArchived)
        {
            throw AppException.NotFound("Sınıf bulunamadı.");
        }

        return entity;
    }

    private Guid RequireTeacher()
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        if (_currentUser.Role != UserRole.Teacher)
        {
            throw new AppException(403, "Bu işlem için öğretmen yetkisi gerekir.");
        }

        return userId;
    }

    private Guid RequireStudent()
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        if (_currentUser.Role != UserRole.Student)
        {
            throw new AppException(403, "Bu işlem için öğrenci yetkisi gerekir.");
        }

        return userId;
    }

    private async Task<string> GenerateUniqueInviteCodeAsync(CancellationToken cancellationToken)
    {
        for (var attempt = 0; attempt < 10; attempt++)
        {
            var code = GenerateInviteCode();
            var exists = await _db.Classes.AnyAsync(c => c.InviteCode == code, cancellationToken);
            if (!exists)
            {
                return code;
            }
        }

        throw AppException.Conflict("Davet kodu üretilemedi, lütfen tekrar deneyin.");
    }

    private static string GenerateInviteCode()
    {
        // Karışması kolay karakterler (0/O, 1/I) çıkarılmış 8 haneli kod (EnrollmentService ile aynı alfabe).
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
}
