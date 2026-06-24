using LingoCross.Application.Classes;
using LingoCross.Application.Classes.Dtos;
using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Enrollments;
using LingoCross.Application.Enrollments.Dtos;
using LingoCross.Application.Lessons;
using LingoCross.Application.Lessons.Dtos;
using LingoCross.Application.Subscriptions;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace LingoCross.Tests.Subscriptions;

/// <summary>
/// F8.1 — Servis katmanı enforcement: sınıf/ders limiti ve çoklu-öğretmen kapısı GERÇEK
/// EntitlementService ile uçtan uca doğrulanır. Premium senaryolarında limit uygulanmaz.
/// </summary>
public class EntitlementEnforcementTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"enforce-{Guid.NewGuid()}")
            .Options);

    private static SubscriptionOptions Opts() => new()
    {
        StubEnabled = true,
        FreeMaxClasses = 2,
        FreeMaxLessons = 5,
        FreeMaxTeachers = 1,
        TrialDays = 7,
    };

    private static IEntitlementService Entitlement(AppDbContext db, TestCurrentUser user)
        => new EntitlementService(db, user, Options.Create(Opts()));

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role, string email)
    {
        var u = new User { Email = email, PasswordHash = "x", DisplayName = email.Split('@')[0], Role = role };
        db.Users.Add(u);
        await db.SaveChangesAsync();
        return u;
    }

    private static async Task MakePremiumAsync(AppDbContext db, Guid userId)
    {
        db.Subscriptions.Add(new Subscription
        {
            UserId = userId,
            Plan = SubscriptionPlan.Premium,
            Status = SubscriptionStatus.Active,
            Period = SubscriptionPeriod.Annual,
            Source = SubscriptionSource.Stub,
            StartedAt = DateTime.UtcNow,
            ExpiresAt = DateTime.UtcNow.AddDays(365),
        });
        await db.SaveChangesAsync();
    }

    // ---- Sınıf limiti ----

    [Fact]
    public async Task ClassCreate_Free_TwoOk_ThirdThrows402_ClassLimit()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var current = TestCurrentUser.Teacher(teacher.Id);
        var svc = new ClassService(db, current, Entitlement(db, current));

        await svc.CreateAsync(new SaveClassRequest("A"));
        await svc.CreateAsync(new SaveClassRequest("B"));

        var ex = await Assert.ThrowsAsync<AppException>(() => svc.CreateAsync(new SaveClassRequest("C")));
        Assert.Equal(402, ex.StatusCode);
        Assert.Equal("subscription_required", ex.Code);
        Assert.Equal("class_limit", ex.Feature);
        Assert.Equal(2, await db.Classes.CountAsync());
    }

    [Fact]
    public async Task ClassCreate_Premium_Unlimited()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        await MakePremiumAsync(db, teacher.Id);
        var current = TestCurrentUser.Teacher(teacher.Id);
        var svc = new ClassService(db, current, Entitlement(db, current));

        for (var i = 0; i < 5; i++)
        {
            await svc.CreateAsync(new SaveClassRequest($"C{i}"));
        }

        Assert.Equal(5, await db.Classes.CountAsync());
    }

    [Fact]
    public async Task ClassCreate_ArchivedNotCounted_AllowsNewWithinLimit()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var current = TestCurrentUser.Teacher(teacher.Id);
        var svc = new ClassService(db, current, Entitlement(db, current));

        var a = await svc.CreateAsync(new SaveClassRequest("A"));
        await svc.CreateAsync(new SaveClassRequest("B"));
        await svc.ArchiveAsync(a.Id);

        // Arşivli sınıf limite sayılmadığından 3. oluşturma (1 arşivli + 2 aktif) sorun olmaz.
        await svc.CreateAsync(new SaveClassRequest("C"));

        Assert.Equal(2, await db.Classes.CountAsync(c => !c.IsArchived));
    }

    // ---- Ders limiti ----

    [Fact]
    public async Task LessonCreate_Free_FiveOk_SixthThrows402_LessonLimit()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var current = TestCurrentUser.Teacher(teacher.Id);
        var svc = new LessonService(db, current, Entitlement(db, current));

        for (var i = 0; i < 5; i++)
        {
            await svc.CreateAsync(new CreateLessonRequest($"L{i}", null, null, null));
        }

        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.CreateAsync(new CreateLessonRequest("L6", null, null, null)));
        Assert.Equal(402, ex.StatusCode);
        Assert.Equal("lesson_limit", ex.Feature);
        Assert.Equal(5, await db.Lessons.CountAsync());
    }

    [Fact]
    public async Task LessonCreate_Premium_Unlimited()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        await MakePremiumAsync(db, teacher.Id);
        var current = TestCurrentUser.Teacher(teacher.Id);
        var svc = new LessonService(db, current, Entitlement(db, current));

        for (var i = 0; i < 8; i++)
        {
            await svc.CreateAsync(new CreateLessonRequest($"L{i}", null, null, null));
        }

        Assert.Equal(8, await db.Lessons.CountAsync());
    }

    // ---- Çoklu öğretmen (sınıf koduyla katılım) ----

    [Fact]
    public async Task ClassJoin_Free_FirstTeacherOk_SecondThrows402_MultiTeacher()
    {
        var db = NewDb();
        var t1 = await SeedUserAsync(db, UserRole.Teacher, "t1@x.com");
        var t2 = await SeedUserAsync(db, UserRole.Teacher, "t2@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");

        var class1 = await new ClassService(db, TestCurrentUser.Teacher(t1.Id),
            Entitlement(db, TestCurrentUser.Teacher(t1.Id))).CreateAsync(new SaveClassRequest("9A"));
        var class2 = await new ClassService(db, TestCurrentUser.Teacher(t2.Id),
            Entitlement(db, TestCurrentUser.Teacher(t2.Id))).CreateAsync(new SaveClassRequest("9B"));

        var studentCurrent = TestCurrentUser.Student(student.Id);
        var studentSvc = new ClassService(db, studentCurrent, Entitlement(db, studentCurrent));

        // 1. öğretmen → ok
        await studentSvc.JoinByCodeAsync(new JoinClassRequest(class1.InviteCode!));

        // Farklı 2. öğretmen → 402
        var ex = await Assert.ThrowsAsync<AppException>(
            () => studentSvc.JoinByCodeAsync(new JoinClassRequest(class2.InviteCode!)));
        Assert.Equal(402, ex.StatusCode);
        Assert.Equal("multi_teacher", ex.Feature);
    }

    [Fact]
    public async Task ClassJoin_Free_SameTeacherSecondClass_NoCharge_Idempotent()
    {
        var db = NewDb();
        var t1 = await SeedUserAsync(db, UserRole.Teacher, "t1@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");

        var teacherCurrent = TestCurrentUser.Teacher(t1.Id);
        var classA = await new ClassService(db, teacherCurrent, Entitlement(db, teacherCurrent))
            .CreateAsync(new SaveClassRequest("9A"));
        var classB = await new ClassService(db, teacherCurrent, Entitlement(db, teacherCurrent))
            .CreateAsync(new SaveClassRequest("9B"));

        var studentCurrent = TestCurrentUser.Student(student.Id);
        var studentSvc = new ClassService(db, studentCurrent, Entitlement(db, studentCurrent));

        await studentSvc.JoinByCodeAsync(new JoinClassRequest(classA.InviteCode!));
        // Aynı öğretmenin başka sınıfı → 402 YOK.
        await studentSvc.JoinByCodeAsync(new JoinClassRequest(classB.InviteCode!));
        // Aynı sınıfa tekrar → 402 YOK (idempotent).
        await studentSvc.JoinByCodeAsync(new JoinClassRequest(classA.InviteCode!));

        Assert.Equal(2, await db.ClassMembers.CountAsync(m => m.StudentId == student.Id));
    }

    [Fact]
    public async Task ClassJoin_Premium_MultipleTeachersOk()
    {
        var db = NewDb();
        var t1 = await SeedUserAsync(db, UserRole.Teacher, "t1@x.com");
        var t2 = await SeedUserAsync(db, UserRole.Teacher, "t2@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        await MakePremiumAsync(db, student.Id);

        var class1 = await new ClassService(db, TestCurrentUser.Teacher(t1.Id),
            Entitlement(db, TestCurrentUser.Teacher(t1.Id))).CreateAsync(new SaveClassRequest("9A"));
        var class2 = await new ClassService(db, TestCurrentUser.Teacher(t2.Id),
            Entitlement(db, TestCurrentUser.Teacher(t2.Id))).CreateAsync(new SaveClassRequest("9B"));

        var studentCurrent = TestCurrentUser.Student(student.Id);
        var studentSvc = new ClassService(db, studentCurrent, Entitlement(db, studentCurrent));

        await studentSvc.JoinByCodeAsync(new JoinClassRequest(class1.InviteCode!));
        await studentSvc.JoinByCodeAsync(new JoinClassRequest(class2.InviteCode!));

        Assert.Equal(2, await db.ClassMembers.CountAsync(m => m.StudentId == student.Id));
    }

    // ---- Çoklu öğretmen (eski enrollment koduyla katılım) ----

    [Fact]
    public async Task EnrollmentJoin_Free_SecondTeacherThrows402_MultiTeacher()
    {
        var db = NewDb();
        var t1 = await SeedUserAsync(db, UserRole.Teacher, "t1@x.com");
        t1.InviteCode = "TEACH111";
        var t2 = await SeedUserAsync(db, UserRole.Teacher, "t2@x.com");
        t2.InviteCode = "TEACH222";
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        await db.SaveChangesAsync();

        var studentCurrent = TestCurrentUser.Student(student.Id);
        var classSvc = new ClassService(db, studentCurrent, Entitlement(db, studentCurrent));
        var enrollSvc = new EnrollmentService(db, studentCurrent, classSvc);

        await enrollSvc.JoinByCodeAsync(new JoinByCodeRequest("TEACH111"));

        var ex = await Assert.ThrowsAsync<AppException>(
            () => enrollSvc.JoinByCodeAsync(new JoinByCodeRequest("TEACH222")));
        Assert.Equal(402, ex.StatusCode);
        Assert.Equal("multi_teacher", ex.Feature);
    }

    [Fact]
    public async Task EnrollmentJoin_Free_SameTeacherAgain_Idempotent_NoCharge()
    {
        var db = NewDb();
        var t1 = await SeedUserAsync(db, UserRole.Teacher, "t1@x.com");
        t1.InviteCode = "TEACH111";
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        await db.SaveChangesAsync();

        var studentCurrent = TestCurrentUser.Student(student.Id);
        var classSvc = new ClassService(db, studentCurrent, Entitlement(db, studentCurrent));
        var enrollSvc = new EnrollmentService(db, studentCurrent, classSvc);

        await enrollSvc.JoinByCodeAsync(new JoinByCodeRequest("TEACH111"));
        await enrollSvc.JoinByCodeAsync(new JoinByCodeRequest("TEACH111"));

        Assert.Equal(1, await db.Enrollments.CountAsync(e => e.StudentId == student.Id));
    }
}
