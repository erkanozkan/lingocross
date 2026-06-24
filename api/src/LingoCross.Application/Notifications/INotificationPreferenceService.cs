using LingoCross.Application.Notifications.Dtos;

namespace LingoCross.Application.Notifications;

/// <summary>Oturum açan kullanıcının push bildirim tercihlerini okur/yazar.</summary>
public interface INotificationPreferenceService
{
    /// <summary>Geçerli kullanıcının tercihleri; kayıt yoksa varsayılanlar döner.</summary>
    Task<NotificationPreferencesDto> GetMineAsync(CancellationToken cancellationToken = default);

    /// <summary>Geçerli kullanıcının tercihlerini upsert eder ve kayıtlı hali döner.</summary>
    Task<NotificationPreferencesDto> UpsertMineAsync(NotificationPreferencesDto request, CancellationToken cancellationToken = default);
}
