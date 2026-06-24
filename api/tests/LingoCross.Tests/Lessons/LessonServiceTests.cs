using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Lessons;
using LingoCross.Application.Lessons.Dtos;
using LingoCross.Application.Words;
using LingoCross.Application.Words.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Lessons;

/// <summary>
/// LessonService akışlarını EF InMemory ile doğrular; sahiplik (başka öğretmen / öğrenci) ve
/// publish kuralları dahil.
/// </summary>
public class LessonServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"lesson-tests-{Guid.NewGuid()}")
            .Options);

    private static async Task<Guid> SeedTeacherAsync(AppDbContext db, string email = "t@example.com")
    {
        var teacher = new User { Email = email, PasswordHash = "x", DisplayName = "T", Role = UserRole.Teacher };
        db.Users.Add(teacher);
        await db.SaveChangesAsync();
        return teacher.Id;
    }

    private static CreateLessonRequest Req() => new("Hayvanlar", "Temel hayvan isimleri", null, null);

    [Fact]
    public async Task Create_AsTeacher_PersistsLessonWithDefaults()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db);
        var service = new LessonService(db, TestCurrentUser.Teacher(teacherId));

        var dto = await service.CreateAsync(Req());

        Assert.Equal("Hayvanlar", dto.Title);
        Assert.Equal("en", dto.SourceLanguage);
        Assert.Equal("tr", dto.TargetLanguage);
        Assert.False(dto.IsPublished);
        Assert.Equal(teacherId, dto.TeacherId);
        Assert.Equal(1, await db.Lessons.CountAsync());
    }

    [Fact]
    public async Task Create_AsStudent_Throws403()
    {
        var db = NewDb();
        var studentId = Guid.NewGuid();
        var service = new LessonService(db, TestCurrentUser.Student(studentId));

        var ex = await Assert.ThrowsAsync<AppException>(() => service.CreateAsync(Req()));
        Assert.Equal(403, ex.StatusCode);
    }

    [Fact]
    public async Task ListMine_ReturnsOnlyOwnLessons()
    {
        var db = NewDb();
        var teacherA = await SeedTeacherAsync(db, "a@example.com");
        var teacherB = await SeedTeacherAsync(db, "b@example.com");

        await new LessonService(db, TestCurrentUser.Teacher(teacherA)).CreateAsync(Req());
        await new LessonService(db, TestCurrentUser.Teacher(teacherB)).CreateAsync(new CreateLessonRequest("B dersi", null, null, null));

        var mine = await new LessonService(db, TestCurrentUser.Teacher(teacherA)).ListMineAsync();

        Assert.Single(mine);
        Assert.Equal(teacherA, mine[0].TeacherId);
    }

    [Fact]
    public async Task Get_OtherTeachersLesson_Throws404()
    {
        var db = NewDb();
        var teacherA = await SeedTeacherAsync(db, "a@example.com");
        var teacherB = await SeedTeacherAsync(db, "b@example.com");

        var lesson = await new LessonService(db, TestCurrentUser.Teacher(teacherA)).CreateAsync(Req());

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            new LessonService(db, TestCurrentUser.Teacher(teacherB)).GetAsync(lesson.Id));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task Update_OtherTeachersLesson_Throws404()
    {
        var db = NewDb();
        var teacherA = await SeedTeacherAsync(db, "a@example.com");
        var teacherB = await SeedTeacherAsync(db, "b@example.com");
        var lesson = await new LessonService(db, TestCurrentUser.Teacher(teacherA)).CreateAsync(Req());

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            new LessonService(db, TestCurrentUser.Teacher(teacherB))
                .UpdateAsync(lesson.Id, new UpdateLessonRequest("Hack", null, null, null)));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task Delete_OtherTeachersLesson_Throws404_AndLeavesItIntact()
    {
        var db = NewDb();
        var teacherA = await SeedTeacherAsync(db, "a@example.com");
        var teacherB = await SeedTeacherAsync(db, "b@example.com");
        var lesson = await new LessonService(db, TestCurrentUser.Teacher(teacherA)).CreateAsync(Req());

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            new LessonService(db, TestCurrentUser.Teacher(teacherB)).DeleteAsync(lesson.Id));
        Assert.Equal(404, ex.StatusCode);
        Assert.Equal(1, await db.Lessons.CountAsync());
    }

    [Fact]
    public async Task Publish_EmptyLesson_Throws400()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db);
        var lessonSvc = new LessonService(db, TestCurrentUser.Teacher(teacherId));
        var lesson = await lessonSvc.CreateAsync(Req());

        var ex = await Assert.ThrowsAsync<AppException>(() => lessonSvc.PublishAsync(lesson.Id));
        Assert.Equal(400, ex.StatusCode);
    }

    [Fact]
    public async Task Publish_WithWords_SetsIsPublished()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db);
        var current = TestCurrentUser.Teacher(teacherId);
        var lessonSvc = new LessonService(db, current);
        var wordSvc = new WordService(db, current);

        var lesson = await lessonSvc.CreateAsync(Req());
        await wordSvc.AddAsync(lesson.Id, new AddWordRequest(
            "cat", null, WordSource.Manual,
            new[] { new TranslationPayload("kedi", true) }, null));

        var published = await lessonSvc.PublishAsync(lesson.Id);

        Assert.True(published.IsPublished);
        Assert.Equal(1, published.WordCount);
    }

    [Fact]
    public async Task Create_DefaultsToDraftStatus()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db);
        var service = new LessonService(db, TestCurrentUser.Teacher(teacherId));

        var dto = await service.CreateAsync(Req());

        Assert.Equal((int)LessonStatus.Draft, dto.Status);
        Assert.False(dto.IsPublished);
    }

    [Fact]
    public async Task Create_PersistsScheduledLabel()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db);
        var service = new LessonService(db, TestCurrentUser.Teacher(teacherId));

        var dto = await service.CreateAsync(new CreateLessonRequest(
            "Hayvanlar", null, null, null, "  15-21 Temmuz 2024  "));

        Assert.Equal("15-21 Temmuz 2024", dto.ScheduledLabel);
        var stored = await db.Lessons.SingleAsync();
        Assert.Equal("15-21 Temmuz 2024", stored.ScheduledLabel);
    }

    [Fact]
    public async Task Update_ChangesScheduledLabel()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db);
        var svc = new LessonService(db, TestCurrentUser.Teacher(teacherId));
        var lesson = await svc.CreateAsync(Req());

        var updated = await svc.UpdateAsync(lesson.Id, new UpdateLessonRequest(
            "Hayvanlar", null, null, null, "1. Hafta"));

        Assert.Equal("1. Hafta", updated.ScheduledLabel);
    }

    [Fact]
    public async Task Publish_SetsStatusActive()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db);
        var current = TestCurrentUser.Teacher(teacherId);
        var lessonSvc = new LessonService(db, current);
        var lesson = await CreateLessonWithWordAsync(db, lessonSvc, current);

        var published = await lessonSvc.PublishAsync(lesson.Id);

        Assert.Equal((int)LessonStatus.Active, published.Status);
        Assert.True(published.IsPublished);
    }

    [Fact]
    public async Task Unpublish_RevertsToDraftAndHides()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db);
        var current = TestCurrentUser.Teacher(teacherId);
        var lessonSvc = new LessonService(db, current);
        var lesson = await CreateLessonWithWordAsync(db, lessonSvc, current);
        await lessonSvc.PublishAsync(lesson.Id);

        var unpublished = await lessonSvc.UnpublishAsync(lesson.Id);

        Assert.Equal((int)LessonStatus.Draft, unpublished.Status);
        Assert.False(unpublished.IsPublished);
    }

    [Fact]
    public async Task Complete_FromActive_SetsCompletedAndStaysVisible()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db);
        var current = TestCurrentUser.Teacher(teacherId);
        var lessonSvc = new LessonService(db, current);
        var lesson = await CreateLessonWithWordAsync(db, lessonSvc, current);
        await lessonSvc.PublishAsync(lesson.Id);

        var completed = await lessonSvc.CompleteAsync(lesson.Id);

        Assert.Equal((int)LessonStatus.Completed, completed.Status);
        Assert.True(completed.IsPublished);
    }

    [Fact]
    public async Task Complete_FromDraft_Throws400()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db);
        var current = TestCurrentUser.Teacher(teacherId);
        var lessonSvc = new LessonService(db, current);
        var lesson = await CreateLessonWithWordAsync(db, lessonSvc, current);

        var ex = await Assert.ThrowsAsync<AppException>(() => lessonSvc.CompleteAsync(lesson.Id));
        Assert.Equal(400, ex.StatusCode);
    }

    [Fact]
    public async Task Complete_FromCompleted_Throws400()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db);
        var current = TestCurrentUser.Teacher(teacherId);
        var lessonSvc = new LessonService(db, current);
        var lesson = await CreateLessonWithWordAsync(db, lessonSvc, current);
        await lessonSvc.PublishAsync(lesson.Id);
        await lessonSvc.CompleteAsync(lesson.Id);

        var ex = await Assert.ThrowsAsync<AppException>(() => lessonSvc.CompleteAsync(lesson.Id));
        Assert.Equal(400, ex.StatusCode);
    }

    private static async Task<LessonDto> CreateLessonWithWordAsync(AppDbContext db, LessonService lessonSvc, Application.Common.Security.ICurrentUser current)
    {
        var lesson = await lessonSvc.CreateAsync(Req());
        await new WordService(db, current).AddAsync(lesson.Id, new AddWordRequest(
            "cat", null, WordSource.Manual,
            new[] { new TranslationPayload("kedi", true) }, null));
        return lesson;
    }
}
