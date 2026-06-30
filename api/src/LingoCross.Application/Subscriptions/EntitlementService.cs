using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Domain.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace LingoCross.Application.Subscriptions;

/// <summary>
/// Entitlement otoritesi. Premium çözümünde lazy-expiry uygular: durum Active/Trial olsa bile
/// <c>ExpiresAt</c> geçmişse premium sayılmaz. Premium kullanıcıda tüm limitler sınırsızdır
/// (<see cref="int.MaxValue"/>) ve OCR açıktır; Free kullanıcıda limitler ayarlardan gelir.
/// </summary>
public class EntitlementService : IEntitlementService
{
    private readonly IAppDbContext _db;
    private readonly ICurrentUser _currentUser;
    private readonly SubscriptionOptions _options;

    public EntitlementService(IAppDbContext db, ICurrentUser currentUser, IOptions<SubscriptionOptions> options)
    {
        _db = db;
        _currentUser = currentUser;
        _options = options.Value;
    }

    public async Task<EntitlementSnapshot> GetAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        var subscription = await _db.Subscriptions
            .AsNoTracking()
            .FirstOrDefaultAsync(s => s.UserId == userId, cancellationToken);

        var status = subscription?.Status ?? SubscriptionStatus.None;
        var period = subscription?.Period;
        var expiresAt = subscription?.ExpiresAt;

        var isPremium = subscription is not null
            && (status == SubscriptionStatus.Active || status == SubscriptionStatus.Trial)
            && (expiresAt is null || expiresAt > DateTime.UtcNow);

        if (isPremium)
        {
            return new EntitlementSnapshot(
                IsPremium: true,
                Status: status,
                Period: period,
                ExpiresAt: expiresAt,
                MaxClasses: int.MaxValue,
                MaxLessons: int.MaxValue,
                MaxTeachers: int.MaxValue,
                OcrEnabled: true);
        }

        return new EntitlementSnapshot(
            IsPremium: false,
            Status: status,
            Period: period,
            ExpiresAt: expiresAt,
            // Sınıf/ders/öğretmen kotaları KALDIRILDI → Free'de de sınırsız. Öğretmen tarafında
            // geriye kalan tek premium özelliği OCR / AI ile kelime taramadır (OcrEnabled=false).
            MaxClasses: int.MaxValue,
            MaxLessons: int.MaxValue,
            MaxTeachers: int.MaxValue,
            OcrEnabled: false);
    }

    public async Task RequireOcrAsync(CancellationToken cancellationToken = default)
    {
        var snapshot = await GetCurrentAsync(cancellationToken);
        if (!snapshot.OcrEnabled)
        {
            throw AppException.PaymentRequired("OCR Premium özelliğidir.", "ocr");
        }
    }

    public async Task RequirePuzzleCreateAsync(CancellationToken cancellationToken = default)
    {
        var snapshot = await GetCurrentAsync(cancellationToken);
        if (!snapshot.IsPremium)
        {
            throw AppException.PaymentRequired(
                "Bulmaca oluşturmak Premium özelliğidir. Premium ile sınırsız bulmaca oluşturun.",
                "puzzle_create");
        }
    }

    public async Task RequireClassQuotaAsync(int currentCount, CancellationToken cancellationToken = default)
    {
        var snapshot = await GetCurrentAsync(cancellationToken);
        if (currentCount >= snapshot.MaxClasses)
        {
            throw AppException.PaymentRequired(
                "Ücretsiz planda en fazla sınıf sayısına ulaştınız. Premium ile sınırsız sınıf oluşturun.",
                "class_limit");
        }
    }

    public async Task RequireLessonQuotaAsync(int currentCount, CancellationToken cancellationToken = default)
    {
        var snapshot = await GetCurrentAsync(cancellationToken);
        if (currentCount >= snapshot.MaxLessons)
        {
            throw AppException.PaymentRequired(
                "Ücretsiz planda en fazla ders sayısına ulaştınız. Premium ile sınırsız ders oluşturun.",
                "lesson_limit");
        }
    }

    public async Task RequireMultiTeacherJoinAsync(int currentDistinctTeacherCount, CancellationToken cancellationToken = default)
    {
        var snapshot = await GetCurrentAsync(cancellationToken);
        if (currentDistinctTeacherCount >= snapshot.MaxTeachers)
        {
            throw AppException.PaymentRequired(
                "Ücretsiz planda yalnızca bir öğretmene katılabilirsiniz. Premium ile birden fazla öğretmene katılın.",
                "multi_teacher");
        }
    }

    private async Task<EntitlementSnapshot> GetCurrentAsync(CancellationToken cancellationToken)
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        return await GetAsync(userId, cancellationToken);
    }
}
