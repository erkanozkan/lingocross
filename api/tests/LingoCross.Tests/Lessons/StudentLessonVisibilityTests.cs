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

    /// <summary>
    /// F4.3: Dersi öğrenciye görünür kılar — derse yayımlı bir oyun ekler, öğretmen için bir sınıf
    /// oluşturup öğrenciyi Active üye yapar ve oyunu o sınıfa atar. Görünürlük sınıf üyeliğinden türetilir.
    /// </summary>
    private static async Task MakeLessonVisibleAsync(AppDbContext db, Guid lessonId, Guid teacherId, Guid studentId)
    {
        var game = new Game { LessonId = lessonId, Type = GameType.WordMatching, Title = "Oyun", IsPublished = true, PublishedAt = DateTime.UtcNow };
        db.Games.Add(game);
        var klass = new Class { TeacherId = teacherId, Name = "Sınıf", InviteCode = $"V{Guid.NewGuid():N}"[..8].ToUpperInvariant() };
        db.Classes.Add(klass);
        await db.SaveChangesAsync();

        db.ClassMembers.Add(new ClassMember { ClassId = klass.Id, StudentId = studentId, Status = ClassMemberStatus.Active });
        db.GameAssignments.Add(new GameAssignment { GameId = game.Id, ClassId = klass.Id });
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
        await SeedLessonAsync(db, teacher.Id, published: false);       // yayımlanmamış → görünmez
        var otherLesson = await SeedLessonAsync(db, otherTeacher.Id, published: true);   // sınıfa atanmamış → görünmez

        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        // Yalnız 'visible' dersi öğrencinin sınıfına atanmış bir oyuna sahip.
        await MakeLessonVisibleAsync(db, visible.Id, teacher.Id, student.Id);

        var list = await new LessonService(db, TestCurrentUser.Student(student.Id)).ListVisibleAsync();

        Assert.Single(list);
        Assert.Equal(visible.Id, list[0].Id);
    }

    [Fact]
    public async Task ListVisible_AsStudent_IncludesActiveAndCompleted_NotDraft()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");

        var active = await SeedLessonAsync(db, teacher.Id, published: true);
        active.Status = LessonStatus.Active;

        var completed = await SeedLessonAsync(db, teacher.Id, published: true);
        completed.Status = LessonStatus.Completed;

        var draft = await SeedLessonAsync(db, teacher.Id, published: false);
        draft.Status = LessonStatus.Draft;
        await db.SaveChangesAsync();

        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        await MakeLessonVisibleAsync(db, active.Id, teacher.Id, student.Id);
        await MakeLessonVisibleAsync(db, completed.Id, teacher.Id, student.Id);

        var list = await new LessonService(db, TestCurrentUser.Student(student.Id)).ListVisibleAsync();

        var ids = list.Select(l => l.Id).ToHashSet();
        Assert.Equal(2, list.Count);
        Assert.Contains(active.Id, ids);
        Assert.Contains(completed.Id, ids);
        Assert.DoesNotContain(draft.Id, ids);
    }

    [Fact]
    public async Task Get_AsStudent_CompletedLesson_Succeeds()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@example.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@example.com");
        var lesson = await SeedLessonAsync(db, teacher.Id, published: true);
        lesson.Status = LessonStatus.Completed;
        await db.SaveChangesAsync();
        await EnrollAsync(db, teacher.Id, student.Id, EnrollmentStatus.Active);
        await MakeLessonVisibleAsync(db, lesson.Id, teacher.Id, student.Id);

        var dto = await new LessonService(db, TestCurrentUser.Student(student.Id)).GetAsync(lesson.Id);

        Assert.Equal((int)LessonStatus.Completed, dto.Status);
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
        await MakeLessonVisibleAsync(db, lesson.Id, teacher.Id, student.Id);

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
        await MakeLessonVisibleAsync(db, lesson.Id, teacher.Id, student.Id);

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
