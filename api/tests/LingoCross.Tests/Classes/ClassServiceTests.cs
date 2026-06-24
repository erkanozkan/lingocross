using LingoCross.Application.Classes;
using LingoCross.Application.Classes.Dtos;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Classes;

/// <summary>
/// F4.3 — Adlandırılmış sınıflar: CRUD + sahiplik(404), davet kodu, üye yönetimi, öğrenci listesi
/// ve koddan katılım (idempotent, arşivli/geçersiz kod 404).
/// </summary>
public class ClassServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"classes-{Guid.NewGuid()}")
            .Options);

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role, string email)
    {
        var user = new User { Email = email, PasswordHash = "x", DisplayName = email.Split('@')[0], Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    private static ClassService Svc(AppDbContext db, TestCurrentUser user) => new(db, user);

    [Fact]
    public async Task Create_AsTeacher_GeneratesInviteCode_AndZeroStudents()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");

        var dto = await Svc(db, TestCurrentUser.Teacher(teacher.Id)).CreateAsync(new SaveClassRequest("  9A  "));

        Assert.Equal("9A", dto.Name);
        Assert.False(string.IsNullOrWhiteSpace(dto.InviteCode));
        Assert.Equal(0, dto.StudentCount);
        Assert.Equal(1, await db.Classes.CountAsync());
    }

    [Fact]
    public async Task Create_AsStudent_Throws403()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");

        var ex = await Assert.ThrowsAsync<AppException>(
            () => Svc(db, TestCurrentUser.Student(student.Id)).CreateAsync(new SaveClassRequest("9A")));
        Assert.Equal(403, ex.StatusCode);
    }

    [Fact]
    public async Task ListMine_ReturnsOnlyOwnNonArchived_WithActiveStudentCount()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var other = await SeedUserAsync(db, UserRole.Teacher, "o@x.com");
        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@x.com");
        var s2 = await SeedUserAsync(db, UserRole.Student, "s2@x.com");

        var svc = Svc(db, TestCurrentUser.Teacher(teacher.Id));
        var a = await svc.CreateAsync(new SaveClassRequest("A"));
        var archived = await svc.CreateAsync(new SaveClassRequest("Arşiv"));
        await svc.ArchiveAsync(archived.Id);
        await Svc(db, TestCurrentUser.Teacher(other.Id)).CreateAsync(new SaveClassRequest("Başka"));

        db.ClassMembers.Add(new ClassMember { ClassId = a.Id, StudentId = s1.Id, Status = ClassMemberStatus.Active });
        db.ClassMembers.Add(new ClassMember { ClassId = a.Id, StudentId = s2.Id, Status = ClassMemberStatus.Active });
        await db.SaveChangesAsync();

        var list = await svc.ListMineAsync();

        Assert.Single(list);
        Assert.Equal(a.Id, list[0].Id);
        Assert.Equal(2, list[0].StudentCount);
    }

    [Fact]
    public async Task Get_OtherTeachersClass_Throws404()
    {
        var db = NewDb();
        var owner = await SeedUserAsync(db, UserRole.Teacher, "o@x.com");
        var other = await SeedUserAsync(db, UserRole.Teacher, "x@x.com");
        var created = await Svc(db, TestCurrentUser.Teacher(owner.Id)).CreateAsync(new SaveClassRequest("A"));

        var ex = await Assert.ThrowsAsync<AppException>(
            () => Svc(db, TestCurrentUser.Teacher(other.Id)).GetAsync(created.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task Get_ReturnsActiveStudents()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var s1 = await SeedUserAsync(db, UserRole.Student, "ali@x.com");
        var svc = Svc(db, TestCurrentUser.Teacher(teacher.Id));
        var created = await svc.CreateAsync(new SaveClassRequest("A"));

        db.ClassMembers.Add(new ClassMember { ClassId = created.Id, StudentId = s1.Id, Status = ClassMemberStatus.Active });
        await db.SaveChangesAsync();

        var detail = await svc.GetAsync(created.Id);

        Assert.Equal(1, detail.StudentCount);
        Assert.Single(detail.Students);
        Assert.Equal(s1.Id, detail.Students[0].StudentId);
        Assert.Equal("ali@x.com", detail.Students[0].Email);
    }

    [Fact]
    public async Task Update_RenamesClass()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var svc = Svc(db, TestCurrentUser.Teacher(teacher.Id));
        var created = await svc.CreateAsync(new SaveClassRequest("Eski"));

        var updated = await svc.UpdateAsync(created.Id, new SaveClassRequest("Yeni"));

        Assert.Equal("Yeni", updated.Name);
    }

    [Fact]
    public async Task Archive_HidesFromListAndDetail()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var svc = Svc(db, TestCurrentUser.Teacher(teacher.Id));
        var created = await svc.CreateAsync(new SaveClassRequest("A"));

        await svc.ArchiveAsync(created.Id);

        Assert.Empty(await svc.ListMineAsync());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.GetAsync(created.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task InviteCode_GetIsStable_RegenerateChangesIt()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var svc = Svc(db, TestCurrentUser.Teacher(teacher.Id));
        var created = await svc.CreateAsync(new SaveClassRequest("A"));

        var first = await svc.GetOrCreateInviteCodeAsync(created.Id);
        var again = await svc.GetOrCreateInviteCodeAsync(created.Id);
        Assert.Equal(first.Code, again.Code);

        var regenerated = await svc.RegenerateInviteCodeAsync(created.Id);
        Assert.NotEqual(first.Code, regenerated.Code);
    }

    [Fact]
    public async Task RemoveStudent_DeletesMembership_Idempotent()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var svc = Svc(db, TestCurrentUser.Teacher(teacher.Id));
        var created = await svc.CreateAsync(new SaveClassRequest("A"));
        db.ClassMembers.Add(new ClassMember { ClassId = created.Id, StudentId = student.Id, Status = ClassMemberStatus.Active });
        await db.SaveChangesAsync();

        await svc.RemoveStudentAsync(created.Id, student.Id);
        Assert.Equal(0, await db.ClassMembers.CountAsync());

        // Tekrar çağırmak hata vermez (idempotent).
        await svc.RemoveStudentAsync(created.Id, student.Id);
    }

    // ---- Öğrenci tarafı ----

    [Fact]
    public async Task Join_ValidCode_CreatesActiveMembership_Idempotent()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var created = await Svc(db, TestCurrentUser.Teacher(teacher.Id)).CreateAsync(new SaveClassRequest("A"));

        var studentSvc = Svc(db, TestCurrentUser.Student(student.Id));
        var first = await studentSvc.JoinByCodeAsync(new JoinClassRequest(created.InviteCode!.ToLowerInvariant()));
        var second = await studentSvc.JoinByCodeAsync(new JoinClassRequest("  " + created.InviteCode! + "  "));

        Assert.Equal(created.Id, first.ClassId);
        Assert.Equal(created.Id, second.ClassId);
        Assert.Equal(1, await db.ClassMembers.CountAsync());
    }

    [Fact]
    public async Task Join_InvalidCode_Throws404()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");

        var ex = await Assert.ThrowsAsync<AppException>(
            () => Svc(db, TestCurrentUser.Student(student.Id)).JoinByCodeAsync(new JoinClassRequest("NOPE9999")));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task Join_ArchivedClassCode_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var teacherSvc = Svc(db, TestCurrentUser.Teacher(teacher.Id));
        var created = await teacherSvc.CreateAsync(new SaveClassRequest("A"));
        await teacherSvc.ArchiveAsync(created.Id);

        var ex = await Assert.ThrowsAsync<AppException>(
            () => Svc(db, TestCurrentUser.Student(student.Id)).JoinByCodeAsync(new JoinClassRequest(created.InviteCode!)));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task ListForStudent_ReturnsActiveNonArchivedClasses()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        teacher.DisplayName = "Ayşe";
        await db.SaveChangesAsync();
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var created = await Svc(db, TestCurrentUser.Teacher(teacher.Id)).CreateAsync(new SaveClassRequest("9A"));

        var studentSvc = Svc(db, TestCurrentUser.Student(student.Id));
        await studentSvc.JoinByCodeAsync(new JoinClassRequest(created.InviteCode!));

        var list = await studentSvc.ListForStudentAsync();

        Assert.Single(list);
        Assert.Equal(created.Id, list[0].ClassId);
        Assert.Equal("9A", list[0].ClassName);
        Assert.Equal("Ayşe", list[0].TeacherName);
    }
}
