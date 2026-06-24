using LingoCross.Application.Notifications;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using LingoCross.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Tests.Notifications;

/// <summary>
/// F7.4 — PushDispatcher tercih filtreleme + geçersiz token temizliği. Gerçek FCM yerine
/// no-op/programlanabilir bir <see cref="FakePushSender"/> kullanılır.
/// </summary>
public class PushDispatcherTests
{
    private static AppDbContext NewDb() =>
        new(new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase($"push-{Guid.NewGuid()}")
            .Options);

    private sealed class FakePushSender : IPushSender
    {
        private readonly IReadOnlyList<string> _invalidToReturn;

        public FakePushSender(IReadOnlyList<string>? invalidToReturn = null)
        {
            _invalidToReturn = invalidToReturn ?? [];
        }

        public int CallCount { get; private set; }

        public List<string> LastTokens { get; } = new();

        public Task<IReadOnlyList<string>> SendToTokensAsync(
            IReadOnlyList<string> tokens,
            string title,
            string body,
            IReadOnlyDictionary<string, string>? data,
            CancellationToken ct = default)
        {
            CallCount++;
            LastTokens.Clear();
            LastTokens.AddRange(tokens);
            return Task.FromResult(_invalidToReturn);
        }
    }

    private static async Task<User> SeedUserAsync(AppDbContext db, UserRole role)
    {
        var user = new User { Email = $"{Guid.NewGuid():N}@x.com", PasswordHash = "x", DisplayName = "U", Role = role };
        db.Users.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    private static async Task AddTokenAsync(AppDbContext db, Guid userId, string token)
    {
        db.DeviceTokens.Add(new DeviceToken { UserId = userId, Token = token, Platform = "ios" });
        await db.SaveChangesAsync();
    }

    private static async Task SetPrefAsync(AppDbContext db, Guid userId, bool master, bool assigned = true, bool results = true)
    {
        db.NotificationPreferences.Add(new NotificationPreference
        {
            UserId = userId,
            Master = master,
            Assigned = assigned,
            Reminder = true,
            Results = results,
            Announcements = false,
        });
        await db.SaveChangesAsync();
    }

    [Fact]
    public async Task NoPreferenceRecord_UsesDefaults_SendsForAssigned()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student);
        await AddTokenAsync(db, student.Id, "tok-1");

        var fake = new FakePushSender();
        var dispatcher = new PushDispatcher(db, fake);

        await dispatcher.NotifyUsersAsync([student.Id], PushType.Assigned, "T", "B", null, default);

        Assert.Equal(1, fake.CallCount);
        Assert.Contains("tok-1", fake.LastTokens);
    }

    [Fact]
    public async Task NoPreferenceRecord_Announcements_DefaultOff_DoesNotSend()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student);
        await AddTokenAsync(db, student.Id, "tok-1");

        var fake = new FakePushSender();
        var dispatcher = new PushDispatcher(db, fake);

        await dispatcher.NotifyUsersAsync([student.Id], PushType.Announcements, "T", "B", null, default);

        Assert.Equal(0, fake.CallCount);
    }

    [Fact]
    public async Task MasterOff_DoesNotSend()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student);
        await AddTokenAsync(db, student.Id, "tok-1");
        await SetPrefAsync(db, student.Id, master: false);

        var fake = new FakePushSender();
        var dispatcher = new PushDispatcher(db, fake);

        await dispatcher.NotifyUsersAsync([student.Id], PushType.Assigned, "T", "B", null, default);

        Assert.Equal(0, fake.CallCount);
    }

    [Fact]
    public async Task TypeFlagOff_DoesNotSend()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student);
        await AddTokenAsync(db, student.Id, "tok-1");
        await SetPrefAsync(db, student.Id, master: true, assigned: false);

        var fake = new FakePushSender();
        var dispatcher = new PushDispatcher(db, fake);

        await dispatcher.NotifyUsersAsync([student.Id], PushType.Assigned, "T", "B", null, default);

        Assert.Equal(0, fake.CallCount);
    }

    [Fact]
    public async Task NoTokens_DoesNotCallSender()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student);
        // tercih izinli ama hiç token yok
        await SetPrefAsync(db, student.Id, master: true);

        var fake = new FakePushSender();
        var dispatcher = new PushDispatcher(db, fake);

        await dispatcher.NotifyUsersAsync([student.Id], PushType.Assigned, "T", "B", null, default);

        Assert.Equal(0, fake.CallCount);
    }

    [Fact]
    public async Task InvalidTokens_AreDeleted()
    {
        var db = NewDb();
        var student = await SeedUserAsync(db, UserRole.Student);
        await AddTokenAsync(db, student.Id, "good");
        await AddTokenAsync(db, student.Id, "stale");

        var fake = new FakePushSender(invalidToReturn: ["stale"]);
        var dispatcher = new PushDispatcher(db, fake);

        await dispatcher.NotifyUsersAsync([student.Id], PushType.Assigned, "T", "B", null, default);

        Assert.Equal(1, fake.CallCount);
        var remaining = await db.DeviceTokens.Select(t => t.Token).ToListAsync();
        Assert.Contains("good", remaining);
        Assert.DoesNotContain("stale", remaining);
    }

    [Fact]
    public async Task MixedUsers_OnlyAllowedUsersTokensSent()
    {
        var db = NewDb();
        var allowed = await SeedUserAsync(db, UserRole.Student);
        var blocked = await SeedUserAsync(db, UserRole.Student);
        await AddTokenAsync(db, allowed.Id, "allowed-tok");
        await AddTokenAsync(db, blocked.Id, "blocked-tok");
        await SetPrefAsync(db, allowed.Id, master: true);
        await SetPrefAsync(db, blocked.Id, master: false);

        var fake = new FakePushSender();
        var dispatcher = new PushDispatcher(db, fake);

        await dispatcher.NotifyUsersAsync([allowed.Id, blocked.Id], PushType.Assigned, "T", "B", null, default);

        Assert.Equal(1, fake.CallCount);
        Assert.Contains("allowed-tok", fake.LastTokens);
        Assert.DoesNotContain("blocked-tok", fake.LastTokens);
    }
}
