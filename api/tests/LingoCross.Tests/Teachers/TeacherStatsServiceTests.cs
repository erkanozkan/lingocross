using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Teachers;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using LingoCross.Tests.Lessons;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Teachers;

/// <summary>
/// F7 — Öğretmen profili istatistikleri (GET /api/teachers/me/stats). Sınıf/öğrenci sayıları
/// (arşivli sınıf ve inactive üye sayılmaz; distinct öğrenci), haftalık beklenen/tamamlanan
/// (son 7 gün penceresi; eski kayıtlar dışarıda; completed ≤ assigned), boş durum (hepsi 0) ve
/// öğretmen-only yetki (öğrenci/anonim → 403).
/// </summary>
public class TeacherStatsServiceTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"teacher-stats-{Guid.NewGuid()}")
            .Options);

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role, string email, string name)
    {
        var user = new User { Email = email, PasswordHash = "x", DisplayName = name, Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    private static async Task<Class> SeedClassAsync(
        AppDbContext db, Guid teacherId, string name, bool archived = false)
    {
        var klass = new Class
        {
            TeacherId = teacherId,
            Name = name,
            IsArchived = archived,
            InviteCode = $"C{Guid.NewGuid():N}"[..8].ToUpperInvariant(),
        };
        db.Classes.Add(klass);
        await db.SaveChangesAsync();
        return klass;
    }

    private static async Task AddMemberAsync(
        AppDbContext db, Guid classId, Guid studentId, ClassMemberStatus status = ClassMemberStatus.Active)
    {
        db.ClassMembers.Add(new ClassMember { ClassId = classId, StudentId = studentId, Status = status });
        await db.SaveChangesAsync();
    }

    private static async Task<Game> SeedGameAsync(AppDbContext db, Guid teacherId)
    {
        var lesson = new Lesson { TeacherId = teacherId, Title = "Ders", IsPublished = true };
        db.Lessons.Add(lesson);
        await db.SaveChangesAsync();

        var game = new Game { LessonId = lesson.Id, Type = GameType.WordMatching, Title = "Kelime Eşleştirme", IsPublished = true };
        db.Games.Add(game);
        await db.SaveChangesAsync();
        return game;
    }

    /// <summary>Bir oyunu bir sınıfa atar; created_at'i geçmişe çekebilmek için doğrudan set eder.</summary>
    private static async Task SeedAssignmentAsync(
        AppDbContext db, Guid gameId, Guid classId, DateTime? createdAt = null)
    {
        var assignment = new GameAssignment { GameId = gameId, ClassId = classId };
        db.GameAssignments.Add(assignment);
        await db.SaveChangesAsync();

        if (createdAt is { } ts)
        {
            assignment.CreatedAt = ts;
            await db.SaveChangesAsync();
        }
    }

    /// <summary>Tamamlanmış bir oturum + sonuç seed eder (CompletedAt set'lenir).</summary>
    private static async Task SeedCompletedResultAsync(
        AppDbContext db, Guid gameId, Guid studentId, DateTime completedAt)
    {
        var session = new GameSession
        {
            GameId = gameId,
            StudentId = studentId,
            Status = GameSessionStatus.Completed,
            StartedAt = completedAt,
            CompletedAt = completedAt,
        };
        db.GameSessions.Add(session);
        await db.SaveChangesAsync();

        db.GameResults.Add(new GameResult
        {
            SessionId = session.Id,
            DurationMs = 1000,
            TotalItems = 8,
            CorrectItems = 8,
            Score = 100,
        });
        await db.SaveChangesAsync();
    }

    [Fact]
    public async Task GetMyStats_CountsActiveClassesAndDistinctActiveStudents()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@x.com", "S1");
        var s2 = await SeedUserAsync(db, UserRole.Student, "s2@x.com", "S2");

        var classA = await SeedClassAsync(db, teacher.Id, "6-A");
        var classB = await SeedClassAsync(db, teacher.Id, "6-B");
        var archived = await SeedClassAsync(db, teacher.Id, "Eski", archived: true);

        // s1 hem A hem B'de Active → distinct sayılır (1 kişi).
        await AddMemberAsync(db, classA.Id, s1.Id);
        await AddMemberAsync(db, classB.Id, s1.Id);
        // s2 yalnız A'da Active.
        await AddMemberAsync(db, classA.Id, s2.Id);
        // Arşivli sınıftaki üye sayılmaz (s1 zaten distinct sayıda, s2 yalnız arşivde olsaydı da düşerdi).
        await AddMemberAsync(db, archived.Id, s1.Id);

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var stats = await svc.GetMyStatsAsync();

        Assert.Equal(2, stats.ClassCount);     // arşivli hariç
        Assert.Equal(2, stats.StudentCount);   // distinct s1, s2
    }

    [Fact]
    public async Task GetMyStats_WeeklyAssigned_SumsActiveStudentsPerAssignment_IgnoresOldAndArchived()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@x.com", "S1");
        var s2 = await SeedUserAsync(db, UserRole.Student, "s2@x.com", "S2");
        var s3 = await SeedUserAsync(db, UserRole.Student, "s3@x.com", "S3");

        var classA = await SeedClassAsync(db, teacher.Id, "6-A"); // 2 active (s1, s2)
        var classB = await SeedClassAsync(db, teacher.Id, "6-B"); // 1 active (s3)
        var archived = await SeedClassAsync(db, teacher.Id, "Eski", archived: true);

        await AddMemberAsync(db, classA.Id, s1.Id);
        await AddMemberAsync(db, classA.Id, s2.Id);
        await AddMemberAsync(db, classB.Id, s3.Id);
        await AddMemberAsync(db, archived.Id, s1.Id); // arşivli sınıf atamaya katkı vermez

        var game1 = await SeedGameAsync(db, teacher.Id);
        var game2 = await SeedGameAsync(db, teacher.Id);

        // Bu hafta: game1→A (2 öğrenci), game1→B (1), game2→A (2) = 5 beklenen.
        await SeedAssignmentAsync(db, game1.Id, classA.Id);
        await SeedAssignmentAsync(db, game1.Id, classB.Id);
        await SeedAssignmentAsync(db, game2.Id, classA.Id);
        // Eski atama (8 gün önce) → sayılmaz.
        await SeedAssignmentAsync(db, game2.Id, classB.Id, createdAt: DateTime.UtcNow.AddDays(-8));
        // Arşivli sınıfa atama → sayılmaz.
        await SeedAssignmentAsync(db, game1.Id, archived.Id);

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var stats = await svc.GetMyStatsAsync();

        Assert.Equal(5, stats.WeeklyAssignedCount);
    }

    [Fact]
    public async Task GetMyStats_WeeklyCompleted_DistinctStudentGamePairs_WindowedAndScopedToTeacher()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var other = await SeedUserAsync(db, UserRole.Teacher, "o@x.com", "Other");
        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@x.com", "S1");
        var s2 = await SeedUserAsync(db, UserRole.Student, "s2@x.com", "S2");

        var classA = await SeedClassAsync(db, teacher.Id, "6-A");
        await AddMemberAsync(db, classA.Id, s1.Id);
        await AddMemberAsync(db, classA.Id, s2.Id);

        var game1 = await SeedGameAsync(db, teacher.Id);
        await SeedAssignmentAsync(db, game1.Id, classA.Id);

        // s1: iki kez aynı oyunu tamamladı → distinct (s1, game1) = 1 sayılır.
        await SeedCompletedResultAsync(db, game1.Id, s1.Id, DateTime.UtcNow.AddHours(-2));
        await SeedCompletedResultAsync(db, game1.Id, s1.Id, DateTime.UtcNow.AddHours(-1));
        // s2: bir kez → +1.
        await SeedCompletedResultAsync(db, game1.Id, s2.Id, DateTime.UtcNow.AddHours(-3));
        // Eski tamamlama (8 gün önce) → sayılmaz.
        await SeedCompletedResultAsync(db, game1.Id, s2.Id, DateTime.UtcNow.AddDays(-8));

        // Başka öğretmenin atadığı oyuna ait tamamlama → sayılmaz.
        var otherGame = await SeedGameAsync(db, other.Id);
        var otherClass = await SeedClassAsync(db, other.Id, "Diğer");
        await SeedAssignmentAsync(db, otherGame.Id, otherClass.Id);
        await SeedCompletedResultAsync(db, otherGame.Id, s1.Id, DateTime.UtcNow.AddHours(-1));

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var stats = await svc.GetMyStatsAsync();

        Assert.Equal(2, stats.WeeklyCompletedCount); // (s1,game1) + (s2,game1)
    }

    [Fact]
    public async Task GetMyStats_CompletionRate_RoundsAndStaysWithinAssigned()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");
        var s1 = await SeedUserAsync(db, UserRole.Student, "s1@x.com", "S1");
        var s2 = await SeedUserAsync(db, UserRole.Student, "s2@x.com", "S2");
        var s3 = await SeedUserAsync(db, UserRole.Student, "s3@x.com", "S3");

        var classA = await SeedClassAsync(db, teacher.Id, "6-A");
        await AddMemberAsync(db, classA.Id, s1.Id);
        await AddMemberAsync(db, classA.Id, s2.Id);
        await AddMemberAsync(db, classA.Id, s3.Id);

        var game1 = await SeedGameAsync(db, teacher.Id);
        await SeedAssignmentAsync(db, game1.Id, classA.Id); // beklenen 3

        // 2/3 tamamlandı → round(66.67) = 67.
        await SeedCompletedResultAsync(db, game1.Id, s1.Id, DateTime.UtcNow.AddHours(-1));
        await SeedCompletedResultAsync(db, game1.Id, s2.Id, DateTime.UtcNow.AddHours(-1));

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var stats = await svc.GetMyStatsAsync();

        Assert.Equal(3, stats.WeeklyAssignedCount);
        Assert.Equal(2, stats.WeeklyCompletedCount);
        Assert.True(stats.WeeklyCompletedCount <= stats.WeeklyAssignedCount);
        Assert.Equal(67, stats.CompletionRate);
    }

    [Fact]
    public async Task GetMyStats_NoClasses_AllZero_NoError()
    {
        var db = NewDb();
        var teacher = await SeedUserAsync(db, UserRole.Teacher, "t@x.com", "Teacher");

        var svc = new TeacherTrackingService(db, TestCurrentUser.Teacher(teacher.Id));
        var stats = await svc.GetMyStatsAsync();

        Assert.Equal(0, stats.ClassCount);
        Assert.Equal(0, stats.StudentCount);
        Assert.Equal(0, stats.WeeklyAssignedCount);
        Assert.Equal(0, stats.WeeklyCompletedCount);
        Assert.Equal(0, stats.CompletionRate);
    }

    [Fact]
    public async Task GetMyStats_AsStudent_Throws403()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student, "s@x.com", "Sema");

        var svc = new TeacherTrackingService(db, TestCurrentUser.Student(student.Id));
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.GetMyStatsAsync());
        Assert.Equal(403, ex.StatusCode);
    }

    [Fact]
    public async Task GetMyStats_Anonymous_Throws401()
    {
        var db = NewDb();
        var svc = new TeacherTrackingService(db, new TestCurrentUser(null, null));
        var ex = await Assert.ThrowsAsync<AppException>(() => svc.GetMyStatsAsync());
        Assert.Equal(401, ex.StatusCode);
    }
}
