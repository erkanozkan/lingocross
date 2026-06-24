using LingoCross.Application.Notifications.Dtos;

namespace LingoCross.Application.Notifications;

/// <summary>Oturum açan kullanıcının push cihaz token'larını yönetir.</summary>
public interface IDeviceService
{
    /// <summary>
    /// Token'ı geçerli kullanıcıya kaydeder (upsert): token başka kullanıcıdaysa o kayıt geçerli
    /// kullanıcıya taşınır; yoksa eklenir; varsa platform/zaman damgası güncellenir.
    /// </summary>
    Task RegisterAsync(RegisterDeviceRequest request, CancellationToken cancellationToken = default);

    /// <summary>Geçerli kullanıcının verilen token kaydını siler (idempotent).</summary>
    Task UnregisterAsync(string token, CancellationToken cancellationToken = default);
}
