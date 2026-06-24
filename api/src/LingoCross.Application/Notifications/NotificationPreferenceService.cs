using LingoCross.Application.Common.Exceptions;
using LingoCross.Application.Common.Persistence;
using LingoCross.Application.Common.Security;
using LingoCross.Application.Notifications.Dtos;
using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Notifications;

public class NotificationPreferenceService : INotificationPreferenceService
{
    private readonly IAppDbContext _db;
    private readonly ICurrentUser _currentUser;

    public NotificationPreferenceService(IAppDbContext db, ICurrentUser currentUser)
    {
        _db = db;
        _currentUser = currentUser;
    }

    public async Task<NotificationPreferencesDto> GetMineAsync(CancellationToken cancellationToken = default)
    {
        var userId = RequireUser();

        var pref = await _db.NotificationPreferences
            .FirstOrDefaultAsync(p => p.UserId == userId, cancellationToken);

        // Kayıt yoksa varsayılanları döndür (oluşturmaya gerek yok).
        return pref is null ? Defaults() : ToDto(pref);
    }

    public async Task<NotificationPreferencesDto> UpsertMineAsync(NotificationPreferencesDto request, CancellationToken cancellationToken = default)
    {
        var userId = RequireUser();

        var pref = await _db.NotificationPreferences
            .FirstOrDefaultAsync(p => p.UserId == userId, cancellationToken);

        if (pref is null)
        {
            pref = new NotificationPreference { UserId = userId };
            _db.NotificationPreferences.Add(pref);
        }

        pref.Master = request.Master;
        pref.Assigned = request.Assigned;
        pref.Reminder = request.Reminder;
        pref.Results = request.Results;
        pref.Announcements = request.Announcements;

        await _db.SaveChangesAsync(cancellationToken);

        return ToDto(pref);
    }

    private static NotificationPreferencesDto Defaults()
        => new(Master: true, Assigned: true, Reminder: true, Results: true, Announcements: false);

    private static NotificationPreferencesDto ToDto(NotificationPreference p)
        => new(p.Master, p.Assigned, p.Reminder, p.Results, p.Announcements);

    private Guid RequireUser()
    {
        if (_currentUser.UserId is not { } userId)
        {
            throw AppException.Unauthorized("Oturum gerekli.");
        }

        return userId;
    }
}
