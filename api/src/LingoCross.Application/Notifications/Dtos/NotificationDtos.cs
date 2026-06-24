namespace LingoCross.Application.Notifications.Dtos;

/// <summary>Cihaz push token'ı kayıt isteği.</summary>
public record RegisterDeviceRequest(string Token, string Platform);

/// <summary>Bir kullanıcının push bildirim tercihleri (okuma/yazma gövdesi).</summary>
public record NotificationPreferencesDto(
    bool Master,
    bool Assigned,
    bool Reminder,
    bool Results,
    bool Announcements);
