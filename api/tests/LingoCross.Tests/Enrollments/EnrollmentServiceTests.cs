using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Enrollments;
using LingoCross.Application.Enrollments.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Enrollments;

/// <summary>
/// EnrollmentService akışlarını EF InMemory ile doğrular: davet kodu üretimi, koddan katılım
/// (yeni + idempotent) ve rol bazlı listeleme.
/// </summary>
public class EnrollmentServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"enrollment-tests-{Guid.NewGuid()}")
            .Options);

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role, string email, string? inviteCode = null)
    {
        var user = new User
        {
            Email = email,
            PasswordHash = "x",
            DisplayName = email.Split('@')[0],
            Role = role,
            InviteCode = inviteCode,
        };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    // F4.3: EnrollmentService artık IClassService köprüsüne bağımlı; testlerde gerçek ClassService verilir.
    private static EnrollmentService MakeService(AppDbContext db, TestCurrentUser currentUser)
        => new(db, currentUser, new Application.Classes.ClassService(db, currentUser));

    [Fact]
    public async Task GetOrCreateInviteCode_AsTeacher_GeneratesAndPersists()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var service = MakeService(db, TestCurrentUser.Teacher(teacher.Id));

        var dto = await service.GetOrCreateInviteCodeAsync();

        Assert.False(string.IsNullOrWhiteSpace(dto.Code));
        var reloaded = await db.Users.FindAsync(teacher.Id);
        Assert.Equal(dto.Code, reloaded!.InviteCode);
    }

    [Fact]
    public async Task GetOrCreateInviteCode_ReturnsExistingWhenPresent()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com", inviteCode: "ABCD2345");
        var service = MakeService(db, TestCurrentUser.Teacher(teacher.Id));

        var dto = await service.GetOrCreateInviteCodeAsync();

        Assert.Equal("ABCD2345", dto.Code);
    }

    [Fact]
    public async Task Regenerate_ProducesDifferentCode()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com", inviteCode: "ABCD2345");
        var service = MakeService(db, TestCurrentUser.Teacher(teacher.Id));

        var dto = await service.RegenerateInviteCodeAsync();

        Assert.NotEqual("ABCD2345", dto.Code);
        var reloaded = await db.Users.FindAsync(teacher.Id);
        Assert.Equal(dto.Code, reloaded!.InviteCode);
    }

    [Fact]
    public async Task GetInviteCode_AsStudent_Throws403()
    {
        var db = NewDb();
        var service = MakeService(db, TestCurrentUser.Student(Guid.NewGuid()));

        var ex = await Assert.ThrowsAsync<AppException>(() => service.GetOrCreateInviteCodeAsync());
        Assert.Equal(403, ex.StatusCode);
    }

    [Fact]
    public async Task JoinByCode_NewPair_CreatesActiveEnrollment()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com", inviteCode: "JOIN1234");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var service = MakeService(db, TestCurrentUser.Student(student.Id));

        var dto = await service.JoinByCodeAsync(new JoinByCodeRequest("JOIN1234"));

        Assert.Equal(EnrollmentStatus.Active, dto.Status);
        Assert.Equal(teacher.Id, dto.TeacherId);
        Assert.Equal(student.Id, dto.StudentId);
        // Counterpart (öğretmen) bilgileri dolu.
        Assert.Equal(teacher.Id, dto.CounterpartUserId);
        Assert.Equal(teacher.Email, dto.CounterpartEmail);
        Assert.Equal(1, await db.Enrollments.CountAsync());
    }

    [Fact]
    public async Task JoinByCode_LowercaseCode_IsNormalized()
    {
        var db = NewDb();
        await SeedUserAsync(db, UserRole.Teacher, "t@example.com", inviteCode: "JOIN1234");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var service = MakeService(db, TestCurrentUser.Student(student.Id));

        var dto = await service.JoinByCodeAsync(new JoinByCodeRequest("  join1234 "));

        Assert.Equal(EnrollmentStatus.Active, dto.Status);
    }

    [Fact]
    public async Task JoinByCode_ExistingPair_IsIdempotent()
    {
        var db = NewDb();
        await SeedUserAsync(db, UserRole.Teacher, "t@example.com", inviteCode: "JOIN1234");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var service = MakeService(db, TestCurrentUser.Student(student.Id));

        var first = await service.JoinByCodeAsync(new JoinByCodeRequest("JOIN1234"));
        var second = await service.JoinByCodeAsync(new JoinByCodeRequest("JOIN1234"));

        Assert.Equal(first.Id, second.Id);
        Assert.Equal(1, await db.Enrollments.CountAsync());
    }

    [Fact]
    public async Task JoinByCode_ClassCode_BridgeCreatesMembershipAndEnrollment()
    {
        // F4.3 köprü: eski /enrollments/join ucu bir SINIF davet kodunu kabul eder; hem class_members
        // hem de geriye-uyumlu enrollment(Active) yazar.
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");

        var klass = new Class { TeacherId = teacher.Id, Name = "9A", InviteCode = "CLASS123" };
        db.Classes.Add(klass);
        await db.SaveChangesAsync();

        var dto = await MakeService(db, TestCurrentUser.Student(student.Id))
            .JoinByCodeAsync(new JoinByCodeRequest("class123"));

        Assert.Equal(EnrollmentStatus.Active, dto.Status);
        Assert.Equal(teacher.Id, dto.TeacherId);
        Assert.Equal(1, await db.ClassMembers.CountAsync(m => m.ClassId == klass.Id && m.StudentId == student.Id));
        Assert.Equal(1, await db.Enrollments.CountAsync(e => e.TeacherId == teacher.Id && e.StudentId == student.Id));
    }

    [Fact]
    public async Task JoinByCode_ClassCode_IsIdempotent()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        db.Classes.Add(new Class { TeacherId = teacher.Id, Name = "9A", InviteCode = "CLASS123" });
        await db.SaveChangesAsync();

        var svc = MakeService(db, TestCurrentUser.Student(student.Id));
        await svc.JoinByCodeAsync(new JoinByCodeRequest("CLASS123"));
        await svc.JoinByCodeAsync(new JoinByCodeRequest("CLASS123"));

        Assert.Equal(1, await db.ClassMembers.CountAsync());
        Assert.Equal(1, await db.Enrollments.CountAsync());
    }

    [Fact]
    public async Task JoinByCode_InvalidCode_Throws404()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var service = MakeService(db, TestCurrentUser.Student(student.Id));

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.JoinByCodeAsync(new JoinByCodeRequest("NOPE9999")));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task JoinByCode_AsTeacher_Throws403()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com", inviteCode: "JOIN1234");
        var service = MakeService(db, TestCurrentUser.Teacher(teacher.Id));

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            service.JoinByCodeAsync(new JoinByCodeRequest("JOIN1234")));
        Assert.Equal(403, ex.StatusCode);
    }

    [Fact]
    public async Task ListMine_AsTeacher_ReturnsStudents()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com", inviteCode: "JOIN1234");
        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@example.com");
        var s2 = await SeedUserAsync(db, UserRole.Student, "s2@example.com");

        await MakeService(db, TestCurrentUser.Student(s1.Id)).JoinByCodeAsync(new JoinByCodeRequest("JOIN1234"));
        await MakeService(db, TestCurrentUser.Student(s2.Id)).JoinByCodeAsync(new JoinByCodeRequest("JOIN1234"));

        var list = await MakeService(db, TestCurrentUser.Teacher(teacher.Id)).ListMineAsync();

        Assert.Equal(2, list.Count);
        Assert.All(list, e => Assert.Equal(teacher.Id, e.TeacherId));
        // Counterpart öğrencidir.
        Assert.Contains(list, e => e.CounterpartUserId == s1.Id);
        Assert.Contains(list, e => e.CounterpartUserId == s2.Id);
    }

    [Fact]
    public async Task ListMine_AsStudent_ReturnsTeachers()
    {
        var db = NewDb();
        var t1 = await SeedUserAsync(db, UserRole.Teacher, "t1@example.com", inviteCode: "CODE1111");
        var t2 = await SeedUserAsync(db, UserRole.Teacher, "t2@example.com", inviteCode: "CODE2222");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var service = MakeService(db, TestCurrentUser.Student(student.Id));

        await service.JoinByCodeAsync(new JoinByCodeRequest("CODE1111"));
        await service.JoinByCodeAsync(new JoinByCodeRequest("CODE2222"));

        var list = await service.ListMineAsync();

        Assert.Equal(2, list.Count);
        Assert.All(list, e => Assert.Equal(student.Id, e.StudentId));
        Assert.Contains(list, e => e.CounterpartUserId == t1.Id);
        Assert.Contains(list, e => e.CounterpartUserId == t2.Id);
    }

    [Fact]
    public async Task Accept_PendingEnrollment_AsTeacher_SetsActive()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var enrollment = new Enrollment { TeacherId = teacher.Id, StudentId = student.Id, Status = EnrollmentStatus.Pending };
        db.Enrollments.Add(enrollment);
        await db.SaveChangesAsync();

        var dto = await MakeService(db, TestCurrentUser.Teacher(teacher.Id)).AcceptAsync(enrollment.Id);

        Assert.Equal(EnrollmentStatus.Active, dto.Status);
    }

    [Fact]
    public async Task Accept_OtherTeachersEnrollment_Throws404()
    {
        var db = NewDb();
        var teacherA = await SeedUserAsync(db, UserRole.Teacher, "a@example.com");
        var teacherB = await SeedUserAsync(db, UserRole.Teacher, "b@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var enrollment = new Enrollment { TeacherId = teacherA.Id, StudentId = student.Id, Status = EnrollmentStatus.Pending };
        db.Enrollments.Add(enrollment);
        await db.SaveChangesAsync();

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            MakeService(db, TestCurrentUser.Teacher(teacherB.Id)).AcceptAsync(enrollment.Id));
        Assert.Equal(404, ex.StatusCode);
    }
}
