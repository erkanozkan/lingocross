using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Lessons;
using LingoCross.Application.Words;
using LingoCross.Application.Words.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Lessons;

/// <summary>
/// Öğrenci ders görünürlüğü: öğrenci yalnız Active eşleşmesi olan öğretmenlerin yayımlanmış
/// derslerini (ve kelimelerini) görebilir; aksi her durumda 404.
/// </summary>
public class StudentLessonVisibilityTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"student-visibility-{Guid.NewGuid()}")
            .Options);

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role, string email)
    {
        var user = new User { Email = email, PasswordHash = "x", DisplayName = email, Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    private static async Task<Lesson> SeedLessonAsync(AppDbContext db, Guid teacherId, bool published, bool withWord = true)
    {
        var lesson = new Lesson { TeacherId = teacherId, Title = "Ders", IsPublished = published };
        if (withWord)
        {
            lesson.Words.Add(new Word { Term = "cat", Source = WordSource.Manual });
        }
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();
        return lesson;
    }

    private static async Task EnrollAsync(AppDbContext db, Guid teacherId, Guid studentId, EnrollmentStatus status)
    {
        db.Enrollments.Add(new Enrollment { TeacherId = teacherId, StudentId = studentId, Status = status });
        await db.SaveChangesAsync();
    }

    [Fact]
    public async Task ListVisible_AsStudent_ReturnsEnrolledPublishedLessonsOnly()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var otherTeacher = await SeedUserAsync(db, UserRole.Teacher, "o@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");

        var visible = await SeedLessonAsync(db, teacher.Id, published: true);
        await SeedLessonAsync(db, teacher.Id, published: false);       // enrolled ama yayımlanmamış → görünmez
        await SeedLessonAsync(db, otherTeacher.Id, published: true);   // enrolled değil → görünmez

        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);

        var list = await new LessonService(db, TestCurrentUser.Student(student.Id)).ListVisibleAsync();

        Assert.Single(list);
        Assert.Equal(visible.Id, list[0].Id);
    }

    [Fact]
    public async Task ListVisible_StudentWithPendingEnrollment_SeesNothing()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        await SeedLessonAsync(db, teacher.Id, published: true);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Pending);

        var list = await new LessonService(db, TestCurrentUser.Student(student.Id)).ListVisibleAsync();

        Assert.Empty(list);
    }

    [Fact]
    public async Task ListVisible_AsTeacher_ReturnsOwnLessonsIncludingDrafts()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        await SeedLessonAsync(db, teacher.Id, published: true);
        await SeedLessonAsync(db, teacher.Id, published: false);

        var list = await new LessonService(db, TestCurrentUser.Teacher(teacher.Id)).ListVisibleAsync();

        Assert.Equal(2, list.Count);
    }

    [Fact]
    public async Task Get_AsStudent_EnrolledPublished_Succeeds()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, published: true);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);

        var dto = await new LessonService(db, TestCurrentUser.Student(student.Id)).GetAsync(lesson.Id);

        Assert.Equal(lesson.Id, dto.Id);
    }

    [Fact]
    public async Task Get_AsStudent_NotEnrolled_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, published: true);

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            new LessonService(db, TestCurrentUser.Student(student.Id)).GetAsync(lesson.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task Get_AsStudent_EnrolledButUnpublished_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, published: false);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            new LessonService(db, TestCurrentUser.Student(student.Id)).GetAsync(lesson.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task ListWords_AsStudent_EnrolledPublished_Succeeds()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, published: true);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);

        var words = await new WordService(db, TestCurrentUser.Student(student.Id)).ListByLessonAsync(lesson.Id);

        Assert.Single(words);
        Assert.Equal("cat", words[0].Term);
    }

    [Fact]
    public async Task ListWords_AsStudent_NotEnrolled_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, published: true);

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            new WordService(db, TestCurrentUser.Student(student.Id)).ListByLessonAsync(lesson.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task ListWords_AsStudent_EnrolledButUnpublished_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, published: false);
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            new WordService(db, TestCurrentUser.Student(student.Id)).ListByLessonAsync(lesson.Id));
        Assert.Equal(404, ex.StatusCode);
    }
}
