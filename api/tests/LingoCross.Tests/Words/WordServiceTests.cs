using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Lessons;
using LingoCross.Application.Lessons.Dtos;
using LingoCross.Application.Words;
using LingoCross.Application.Words.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Words;

/// <summary>
/// WordService akışları: çeviri+eşanlam ile ekleme, primary çeviri normalizasyonu, güncelleme ile
/// koleksiyon değişimi ve başka öğretmenin dersine kelime ekleme engeli.
/// </summary>
public class WordServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"word-tests-{Guid.NewGuid()}")
            .Options);

    private static async Task<Guid> SeedTeacherAsync(AppDbContext db, string email)
    {
        var teacher = new User { Email = email, PasswordHash = "x", DisplayName = "T", Role = UserRole.Teacher };
        db.Users.Add(teacher);
        await db.SaveChangesAsync();
        return teacher.Id;
    }

    [Fact]
    public async Task Add_WithTranslationsAndSynonyms_Persists()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db, "a@example.com");
        var current = TestCurrentUser.Teacher(teacherId);
        var lesson = await new LessonService(db, current).CreateAsync(new CreateLessonRequest("L", null, null, null));
        var wordSvc = new WordService(db, current);

        var word = await wordSvc.AddAsync(lesson.Id, new AddWordRequest(
            "happy", null, WordSource.Manual,
            new[] { new TranslationPayload("mutlu", true), new TranslationPayload("neşeli", false) },
            new[] { "glad", "joyful" }));

        Assert.Equal("happy", word.Term);
        Assert.Equal(WordSource.Manual, word.Source);
        Assert.Equal(2, word.Translations.Count);
        Assert.Equal(2, word.Synonyms.Count);
        Assert.Single(word.Translations, t => t.IsPrimary);
        Assert.Equal("mutlu", word.Translations.First(t => t.IsPrimary).Text);

        Assert.Equal(2, await db.WordTranslations.CountAsync());
        Assert.Equal(2, await db.WordSynonyms.CountAsync());
    }

    [Fact]
    public async Task Add_NoPrimaryFlag_FirstTranslationBecomesPrimary()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db, "a@example.com");
        var current = TestCurrentUser.Teacher(teacherId);
        var lesson = await new LessonService(db, current).CreateAsync(new CreateLessonRequest("L", null, null, null));

        var word = await new WordService(db, current).AddAsync(lesson.Id, new AddWordRequest(
            "dog", null, null,
            new[] { new TranslationPayload("köpek", false), new TranslationPayload("it", false) }, null));

        Assert.Single(word.Translations, t => t.IsPrimary);
        Assert.Equal(WordSource.Manual, word.Source); // varsayılan
    }

    [Fact]
    public async Task Add_AutoIncrementsSortOrder()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db, "a@example.com");
        var current = TestCurrentUser.Teacher(teacherId);
        var lesson = await new LessonService(db, current).CreateAsync(new CreateLessonRequest("L", null, null, null));
        var wordSvc = new WordService(db, current);

        var w1 = await wordSvc.AddAsync(lesson.Id, new AddWordRequest("one", null, null, new[] { new TranslationPayload("bir", true) }, null));
        var w2 = await wordSvc.AddAsync(lesson.Id, new AddWordRequest("two", null, null, new[] { new TranslationPayload("iki", true) }, null));

        Assert.Equal(0, w1.SortOrder);
        Assert.Equal(1, w2.SortOrder);
    }

    [Fact]
    public async Task Add_ToOtherTeachersLesson_Throws404()
    {
        var db = NewDb();
        var teacherA = await SeedTeacherAsync(db, "a@example.com");
        var teacherB = await SeedTeacherAsync(db, "b@example.com");
        var lesson = await new LessonService(db, TestCurrentUser.Teacher(teacherA)).CreateAsync(new CreateLessonRequest("L", null, null, null));

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            new WordService(db, TestCurrentUser.Teacher(teacherB)).AddAsync(lesson.Id, new AddWordRequest(
                "x", null, null, new[] { new TranslationPayload("y", true) }, null)));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task Update_ReplacesTranslationsAndSynonyms()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db, "a@example.com");
        var current = TestCurrentUser.Teacher(teacherId);
        var lesson = await new LessonService(db, current).CreateAsync(new CreateLessonRequest("L", null, null, null));
        var wordSvc = new WordService(db, current);

        var word = await wordSvc.AddAsync(lesson.Id, new AddWordRequest(
            "happy", null, WordSource.Manual,
            new[] { new TranslationPayload("mutlu", true) }, new[] { "glad" }));

        var updated = await wordSvc.UpdateAsync(word.Id, new UpdateWordRequest(
            "happy", null, WordSource.Ocr,
            new[] { new TranslationPayload("sevinçli", true), new TranslationPayload("memnun", false) },
            new[] { "joyful", "cheerful", "merry" }));

        Assert.Equal(WordSource.Ocr, updated.Source);
        Assert.Equal(2, updated.Translations.Count);
        Assert.Equal(3, updated.Synonyms.Count);
        Assert.Equal("sevinçli", updated.Translations.First(t => t.IsPrimary).Text);

        // Eski kayıtlar gerçekten silinmiş olmalı (cascade temizlik değil, koleksiyon değişimi).
        Assert.Equal(2, await db.WordTranslations.CountAsync());
        Assert.Equal(3, await db.WordSynonyms.CountAsync());
    }

    [Fact]
    public async Task Delete_OtherTeachersWord_Throws404()
    {
        var db = NewDb();
        var teacherA = await SeedTeacherAsync(db, "a@example.com");
        var teacherB = await SeedTeacherAsync(db, "b@example.com");
        var current = TestCurrentUser.Teacher(teacherA);
        var lesson = await new LessonService(db, current).CreateAsync(new CreateLessonRequest("L", null, null, null));
        var word = await new WordService(db, current).AddAsync(lesson.Id, new AddWordRequest(
            "x", null, null, new[] { new TranslationPayload("y", true) }, null));

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            new WordService(db, TestCurrentUser.Teacher(teacherB)).DeleteAsync(word.Id));
        Assert.Equal(404, ex.StatusCode);
        Assert.Equal(1, await db.Words.CountAsync());
    }

    [Fact]
    public async Task ListByLesson_ReturnsWordsOrderedBySortOrder()
    {
        var db = NewDb();
        var teacherId = await SeedTeacherAsync(db, "a@example.com");
        var current = TestCurrentUser.Teacher(teacherId);
        var lesson = await new LessonService(db, current).CreateAsync(new CreateLessonRequest("L", null, null, null));
        var wordSvc = new WordService(db, current);

        await wordSvc.AddAsync(lesson.Id, new AddWordRequest("b", 1, null, new[] { new TranslationPayload("b", true) }, null));
        await wordSvc.AddAsync(lesson.Id, new AddWordRequest("a", 0, null, new[] { new TranslationPayload("a", true) }, null));

        var list = await wordSvc.ListByLessonAsync(lesson.Id);

        Assert.Equal(2, list.Count);
        Assert.Equal("a", list[0].Term);
        Assert.Equal("b", list[1].Term);
    }
}
