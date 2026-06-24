using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Subscriptions.Dtos;
using LingoCross.Domain.Entities;
using LingoCross.Domain.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace LingoCross.Application.Subscriptions;

/// <summary>
/// Stub abonelik servisi. Gerçek ödeme yoktur; <c>StubEnabled</c> kapalıyken etkinleştirme/iptal
/// uçları 503 döner. Premium çözümü/limitler tek otorite olan <see cref="IEntitlementService"/>'ten
/// alınır; DTO'daki limitler bu otoriteyle tutarlıdır (sınırsız = -1 konvansiyonu).
/// </summary>
public class SubscriptionService : ISubscriptionService
{
    private const int MonthlyDays = 30;
    private const int AnnualDays = 365;

    private readonly IAppDbContext _db;
    private readonly ICurrentUser _currentUser;
    private readonly IEntitlementService _entitlement;
    private readonly SubscriptionOptions _options;

    public SubscriptionService(
        IAppDbContext db,
        ICurrentUser currentUser,
        IEntitlementService entitlement,
        IOptions<SubscriptionOptions> options)
    {
        _db = db;
        _currentUser = currentUser;
        _entitlement = entitlement;
        _options = options.Value;
    }

    public async Task<SubscriptionDto> GetMineAsync(CancellationToken cancellationToken = default)
    {
        var userId = RequireUser();
        return await BuildDtoAsync(userId, cancellationToken);
    }

    public async Task<SubscriptionDto> ActivateStubAsync(ActivateStubRequest request, CancellationToken cancellationToken = default)
    {
        var userId = RequireUser();
        EnsureStubEnabled();

        var subscription = await _db.Subscriptions
            .FirstOrDefaultAsync(s => s.UserId == userId, cancellationToken);

        if (subscription is null)
        {
            subscription = new Subscription { UserId = userId };
            _db.Subscriptions.Add(subscription);
        }

        var now = DateTime.UtcNow;
        subscription.Plan = SubscriptionPlan.Premium;
        subscription.Source = SubscriptionSource.Stub;
        subscription.StartedAt = now;

        if (request.Trial)
        {
            subscription.Status = SubscriptionStatus.Trial;
            subscription.Period = null;
            subscription.ExpiresAt = now.AddDays(_options.TrialDays);
        }
        else
        {
            // Validator Trial=false iken Period'ü zorunlu kılar; yine de savunmacı davran.
            var period = request.Period
                ?? throw AppException.BadRequest("Dönem (aylık/yıllık) zorunludur.");

            subscription.Status = SubscriptionStatus.Active;
            subscription.Period = period;
            subscription.ExpiresAt = now.AddDays(period == SubscriptionPeriod.Annual ? AnnualDays : MonthlyDays);
        }

        await _db.SaveChangesAsync(cancellationToken);

        return await BuildDtoAsync(userId, cancellationToken);
    }

    public async Task<SubscriptionDto> CancelAsync(CancellationToken cancellationToken = default)
    {
        var userId = RequireUser();
        EnsureStubEnabled();

        var subscription = await _db.Subscriptions
            .FirstOrDefaultAsync(s => s.UserId == userId, cancellationToken);

        if (subscription is not null)
        {
            subscription.Status = SubscriptionStatus.Canceled;
            subscription.Period = null;
            subscription.ExpiresAt = DateTime.UtcNow;
            await _db.SaveChangesAsync(cancellationToken);
        }

        return await BuildDtoAsync(userId, cancellationToken);
    }

    /// <summary>
    /// Entitlement otoritesinden anlık görüntü alıp DTO'ya çevirir. Sınırsız (int.MaxValue) limitler
    /// dışa -1 olarak yansıtılır (mobil için sınırsız konvansiyonu).
    /// </summary>
    private async Task<SubscriptionDto> BuildDtoAsync(Guid userId, CancellationToken cancellationToken)
    {
        var snapshot = await _entitlement.GetAsync(userId, cancellationToken);

        return new SubscriptionDto(
            Plan: SubscriptionPlan.Premium,
            Status: snapshot.Status,
            Period: snapshot.Period,
            ExpiresAt: snapshot.ExpiresAt,
            IsPremium: snapshot.IsPremium,
            MaxClasses: ToWireLimit(snapshot.MaxClasses),
            MaxLessons: ToWireLimit(snapshot.MaxLessons),
            MaxTeachers: ToWireLimit(snapshot.MaxTeachers),
            OcrEnabled: snapshot.OcrEnabled);
    }

    /// <summary>Sınırsız limiti (int.MaxValue) tel üzerinde -1'e çevirir; aksi halde değeri korur.</summary>
    private static int ToWireLimit(int value) => value == int.MaxValue ? -1 : value;

    private void EnsureStubEnabled()
    {
        if (!_options.StubEnabled)
        {
            throw new AppException(503, "Stub abonelik kapalı.");
        }
    }

    private Guid RequireUser()
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        return userId;
    }
}
