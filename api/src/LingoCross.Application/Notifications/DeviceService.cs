using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Notifications.Dtos;
using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Notifications;

public class DeviceService : IDeviceService
{
    private readonly IAppDbContext _db;
    private readonly ICurrentUser _currentUser;

    public DeviceService(IAppDbContext db, ICurrentUser currentUser)
    {
        _db = db;
        _currentUser = currentUser;
    }

    public async Task RegisterAsync(RegisterDeviceRequest request, CancellationToken cancellationToken = default)
    {
        var userId = RequireUser();
        var token = (request.Token ?? string.Empty).Trim();
        var platform = (request.Platform ?? string.Empty).Trim().ToLowerInvariant();

        var existing = await _db.DeviceTokens
            .FirstOrDefaultAsync(t => t.Token == token, cancellationToken);

        if (existing is null)
        {
            _db.DeviceTokens.Add(new DeviceToken
            {
                UserId = userId,
                Token = token,
                Platform = platform,
            });
        }
        else
        {
            // Token başka kullanıcıdaysa geçerli kullanıcıya taşı; her durumda platformu güncelle.
            existing.UserId = userId;
            existing.Platform = platform;
        }

        await _db.SaveChangesAsync(cancellationToken);
    }

    public async Task UnregisterAsync(string token, CancellationToken cancellationToken = default)
    {
        var userId = RequireUser();
        var normalized = (token ?? string.Empty).Trim();

        var existing = await _db.DeviceTokens
            .FirstOrDefaultAsync(t => t.Token == normalized && t.UserId == userId, cancellationToken);

        // Idempotent: kayıt yoksa sessizce başarı.
        if (existing is not null)
        {
            _db.DeviceTokens.Remove(existing);
            await _db.SaveChangesAsync(cancellationToken);
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
