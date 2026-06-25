using LingoCross.Application.Admin.Dtos;

namespace LingoCross.Application.Admin;

/// <summary>
/// Back office salt-okur metrik servisi. HİÇBİR yazma yapmaz; yalnız Count/GroupBy/OrderBy okur.
/// Sahiplik kontrolü yoktur — uçlar yalnızca [Authorize(Roles="Admin")] arkasındadır.
/// </summary>
public interface IAdminMetricsService
{
    /// <summary>Kullanıcı/içerik/etkileşim sayıları + abonelik kırılımı + aktif öğrenci pencereleri.</summary>
    Task<OverviewDto> GetOverviewAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Son <paramref name="days"/> günün günlük zaman serisi (boş günler 0). metric ∈
    /// {signups, sessions, results, subscriptions}.
    /// </summary>
    Task<TimeseriesDto> GetTimeseriesAsync(string metric, int days, CancellationToken cancellationToken = default);

    /// <summary>Oyun türü dağılımı + ortalama skor + paylaşılan sonuç oranı.</summary>
    Task<EngagementDto> GetEngagementAsync(CancellationToken cancellationToken = default);

    /// <summary>Abonelik durum/kaynak kırılımı + yeni abonelik zaman serisi.</summary>
    Task<SubscriptionsDto> GetSubscriptionsAsync(int days, CancellationToken cancellationToken = default);

    /// <summary>Son kaydolan kullanıcılar + son oyun sonuçları.</summary>
    Task<RecentDto> GetRecentAsync(int take, CancellationToken cancellationToken = default);
}
