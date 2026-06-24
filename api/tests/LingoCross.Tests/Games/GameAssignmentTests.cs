using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Games;
using LingoCross.Application.Games.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Games;

/// <summary>
/// F4.3 — Oyun↔sınıf atama (SET semantiği) ve sınıf-tabanlı öğrenci görünürlüğü: atanmamış oyun
/// görünmez, arşivli sınıf görünmez, başka sınıfa atanan görünmez, doğru sınıf üyesi görür.
/// </summary>
public class GameAssignmentTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"assignments-{Guid.NewGuid()}")
            .Options);

    private static Random SeededRandom() => new(12345);

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role, string email)
    {
        var user = new User { Email = email, PasswordHash = "x", DisplayName = email, Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    private static async Task<Lesson> SeedPublishedLessonWithWordsAsync(AppDbContext db, Guid teacherId, int words = 6)
    {
        var lesson = new Lesson { TeacherId = teacherId, Title = "Ders", IsPublished = true };
        for (var i = 0; i < words; i++)
        {
            var w = new Word { Term = $"term{i}", SortOrder = i, Source = WordSource.Manual };
            w.Translations.Add(new WordTranslation { Text = $"çeviri{i}", IsPrimary = true });
            lesson.Words.Add(w);
        }
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();
        return lesson;
    }

    private static async Task<Game> SeedGameAsync(AppDbContext db, Guid lessonId, bool published = true)
    {
        var game = new Game { LessonId = lessonId, Type = GameType.WordMatching, Title = "Oyun", IsPublished = published, PublishedAt = published ? DateTime.UtcNow : null };
        db.Games.Add(game);
        await db.SaveChangesAsync();
        return game;
    }

    private static async Task<Class> SeedClassAsync(AppDbContext db, Guid teacherId, bool archived = false)
    {
        var klass = new Class { TeacherId = teacherId, Name = "Sınıf", InviteCode = $"A{Guid.NewGuid():N}"[..8].ToUpperInvariant(), IsArchived = archived };
        db.Classes.Add(klass);
        await db.SaveChangesAsync();
        return klass;
    }

    private static async Task AddMemberAsync(AppDbContext db, Guid classId, Guid studentId)
    {
        db.ClassMembers.Add(new ClassMember { ClassId = classId, StudentId = studentId, Status = ClassMemberStatus.Active });
        await db.SaveChangesAsync();
    }

    // ---- SET semantiği ----

    [Fact]
    public async Task SetAssignments_ReplacesSet_AddsAndRemoves()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedPublishedLessonWithWordsAsync(db, teacher.Id);
        var game = await SeedGameAsync(db, lesson.Id);
        var c1 = await SeedClassAsync(db, teacher.Id);
        var c2 = await SeedClassAsync(db, teacher.Id);
        var c3 = await SeedClassAsync(db, teacher.Id);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());

        // İlk atama: c1, c2.
        var first = await svc.SetAssignmentsAsync(game.Id, new SetGameAssignmentsRequest([c1.Id, c2.Id]));
        Assert.Equal(2, first.ClassIds.Count);
        Assert.Equal(2, await db.GameAssignments.CountAsync(a => a.GameId == game.Id));

        // İkinci atama set: c2, c3 → c1 silinir, c3 eklenir.
        var second = await svc.SetAssignmentsAsync(game.Id, new SetGameAssignmentsRequest([c2.Id, c3.Id]));
        var ids = second.ClassIds.ToHashSet();
        Assert.Equal(2, ids.Count);
        Assert.Contains(c2.Id, ids);
        Assert.Contains(c3.Id, ids);
        Assert.DoesNotContain(c1.Id, ids);
        Assert.Equal(2, await db.GameAssignments.CountAsync(a => a.GameId == game.Id));
    }

    [Fact]
    public async Task SetAssignments_EmptyList_ClearsAll()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedPublishedLessonWithWordsAsync(db, teacher.Id);
        var game = await SeedGameAsync(db, lesson.Id);
        var c1 = await SeedClassAsync(db, teacher.Id);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        await svc.SetAssignmentsAsync(game.Id, new SetGameAssignmentsRequest([c1.Id]));
        var cleared = await svc.SetAssignmentsAsync(game.Id, new SetGameAssignmentsRequest([]));

        Assert.Empty(cleared.ClassIds);
        Assert.Equal(0, await db.GameAssignments.CountAsync(a => a.GameId == game.Id));
    }

    [Fact]
    public async Task SetAssignments_OtherTeachersClass_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var other = await SeedUserAsync(db, UserRole.Teacher, "o@x.com");
        var lesson = await SeedPublishedLessonWithWordsAsync(db, teacher.Id);
        var game = await SeedGameAsync(db, lesson.Id);
        var foreignClass = await SeedClassAsync(db, other.Id);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.SetAssignmentsAsync(game.Id, new SetGameAssignmentsRequest([foreignClass.Id])));
        Assert.Equal(404, ex.StatusCode);
        Assert.Equal(0, await db.GameAssignments.CountAsync());
    }

    [Fact]
    public async Task SetAssignments_OtherTeachersGame_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var other = await SeedUserAsync(db, UserRole.Teacher, "o@x.com");
        var lesson = await SeedPublishedLessonWithWordsAsync(db, other.Id);
        var game = await SeedGameAsync(db, lesson.Id);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(
            () => svc.SetAssignmentsAsync(game.Id, new SetGameAssignmentsRequest([])));
        Assert.Equal(404, ex.StatusCode);
    }

    [Fact]
    public async Task GetAssignments_ReturnsCurrentSet()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedPublishedLessonWithWordsAsync(db, teacher.Id);
        var game = await SeedGameAsync(db, lesson.Id);
        var c1 = await SeedClassAsync(db, teacher.Id);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        await svc.SetAssignmentsAsync(game.Id, new SetGameAssignmentsRequest([c1.Id]));

        var got = await svc.GetAssignmentsAsync(game.Id);
        Assert.Single(got.ClassIds);
        Assert.Equal(c1.Id, got.ClassIds[0]);
    }

    [Fact]
    public async Task CreateForLesson_WithClassIds_WritesAssignmentsInSameFlow()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var lesson = await SeedPublishedLessonWithWordsAsync(db, teacher.Id);
        var c1 = await SeedClassAsync(db, teacher.Id);

        var svc = new GameService(db, TestCurrentUser.Teacher(teacher.Id), SeededRandom());
        var game = await svc.CreateForLessonAsync(lesson.Id, new CreateGameRequest(GameType.WordMatching, "Hafta 1", [c1.Id]));

        var assignments = await svc.GetAssignmentsAsync(game.Id);
        Assert.Single(assignments.ClassIds);
        Assert.Equal(c1.Id, assignments.ClassIds[0]);
    }

    // ---- Sınıf-tabanlı görünürlük ----

    [Fact]
    public async Task ListAssigned_StudentInAssignedClass_SeesGame()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedPublishedLessonWithWordsAsync(db, teacher.Id);
        var game = await SeedGameAsync(db, lesson.Id);
        var klass = await SeedClassAsync(db, teacher.Id);
        await AddMemberAsync(db, klass.Id, student.Id);
        db.GameAssignments.Add(new GameAssignment { GameId = game.Id, ClassId = klass.Id });
        await db.SaveChangesAsync();

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var assigned = await svc.ListAssignedForStudentAsync();
        Assert.Single(assigned);
        Assert.Equal(game.Id, assigned[0].Id);
    }

    [Fact]
    public async Task ListAssigned_GameNotAssignedToAnyClass_NotVisible()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedPublishedLessonWithWordsAsync(db, teacher.Id);
        await SeedGameAsync(db, lesson.Id);
        var klass = await SeedClassAsync(db, teacher.Id);
        await AddMemberAsync(db, klass.Id, student.Id); // üye ama oyun atanmamış

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        Assert.Empty(await svc.ListAssignedForStudentAsync());
    }

    [Fact]
    public async Task ListAssigned_AssignedToDifferentClass_NotVisible()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedPublishedLessonWithWordsAsync(db, teacher.Id);
        var game = await SeedGameAsync(db, lesson.Id);
        var memberClass = await SeedClassAsync(db, teacher.Id);
        var assignedClass = await SeedClassAsync(db, teacher.Id);
        await AddMemberAsync(db, memberClass.Id, student.Id);   // öğrenci memberClass'ta
        db.GameAssignments.Add(new GameAssignment { GameId = game.Id, ClassId = assignedClass.Id }); // oyun başka sınıfta
        await db.SaveChangesAsync();

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        Assert.Empty(await svc.ListAssignedForStudentAsync());
    }

    [Fact]
    public async Task ListAssigned_ArchivedClass_NotVisible()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedPublishedLessonWithWordsAsync(db, teacher.Id);
        var game = await SeedGameAsync(db, lesson.Id);
        var klass = await SeedClassAsync(db, teacher.Id, archived: true);
        await AddMemberAsync(db, klass.Id, student.Id);
        db.GameAssignments.Add(new GameAssignment { GameId = game.Id, ClassId = klass.Id });
        await db.SaveChangesAsync();

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        Assert.Empty(await svc.ListAssignedForStudentAsync());
    }

    [Fact]
    public async Task StartSession_StudentInAssignedClass_Succeeds()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedPublishedLessonWithWordsAsync(db, teacher.Id);
        var game = await SeedGameAsync(db, lesson.Id);
        var klass = await SeedClassAsync(db, teacher.Id);
        await AddMemberAsync(db, klass.Id, student.Id);
        db.GameAssignments.Add(new GameAssignment { GameId = game.Id, ClassId = klass.Id });
        await db.SaveChangesAsync();

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var response = await svc.StartSessionAsync(game.Id);
        Assert.Equal(GameSessionStatus.InProgress, response.Session.Status);
    }

    [Fact]
    public async Task StartSession_StudentNotInAnyAssignedClass_Throws404()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com");
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com");
        var lesson = await SeedPublishedLessonWithWordsAsync(db, teacher.Id);
        var game = await SeedGameAsync(db, lesson.Id); // hiçbir sınıfa atanmamış

        var svc = new GameService(db, TestCurrentUser.Student(student.Id), SeededRandom());
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.StartSessionAsync(game.Id));
        Assert.Equal(404, ex.StatusCode);
    }
}
