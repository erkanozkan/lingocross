using LingoCross.Application.Common.Persistence;
using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Notifications;

/// <summary>
/// Push bildirim tetik mantığının merkezi: tercih filtreleme + cihaz token'larını toplama +
/// gönderim + geçersiz token temizliği. Servisler (GameService, ResultService) bunu çağırır.
/// Veritabanı kullandığı için scoped'tır.
/// </summary>
public class PushDispatcher
{
    private readonly IAppDbContext _db;
    private readonly IPushSender _sender;

    public PushDispatcher(IAppDbContext db, IPushSender sender)
    {
        _db = db;
        _sender = sender;
    }

    /// <summary>
    /// Verilen kullanıcılara bir bildirim gönderir. Her kullanıcı için tercih okunur (kayıt yoksa
    /// varsayılan): <c>Master</c> kapalıysa veya türe karşılık gelen bayrak kapalıysa o kullanıcı
    /// atlanır. Geçen kullanıcıların cihaz token'ları toplanır; boşsa gönderim yapılmaz. Sağlayıcı
    /// geçersiz token bildirirse o kayıtlar silinir.
    /// </summary>
    public async Task NotifyUsersAsync(
        IEnumerable<Guid> userIds,
        PushType type,
        string title,
        string body,
        IReadOnlyDictionary<string, string>? data,
        CancellationToken ct)
    {
        var ids = userIds.Distinct().ToList();
        if (ids.Count == 0)
        {
            return;
        }

        // İlgili tercih kayıtlarını tek sorguda al; eksik olanlar varsayılan kabul edilir.
        var prefs = await _db.NotificationPreferences
            .Where(p => ids.Contains(p.UserId))
            .ToDictionaryAsync(p => p.UserId, ct);

        var allowedUserIds = ids
            .Where(id => IsAllowed(prefs.TryGetValue(id, out var pref) ? pref : null, type))
            .ToList();

        if (allowedUserIds.Count == 0)
        {
            return;
        }

        var tokens = await _db.DeviceTokens
            .Where(t => allowedUserIds.Contains(t.UserId))
            .Select(t => t.Token)
            .ToListAsync(ct);

        if (tokens.Count == 0)
        {
            return;
        }

        var invalid = await _sender.SendToTokensAsync(tokens, title, body, data, ct);
        if (invalid.Count == 0)
        {
            return;
        }

        var invalidSet = invalid.ToHashSet();
        var stale = await _db.DeviceTokens
            .Where(t => invalidSet.Contains(t.Token))
            .ToListAsync(ct);

        if (stale.Count > 0)
        {
            _db.DeviceTokens.RemoveRange(stale);
            await _db.SaveChangesAsync(ct);
        }
    }

    /// <summary>Tercihe ve türe göre kullanıcının bu bildirimi alıp almayacağını belirler.</summary>
    private static bool IsAllowed(NotificationPreference? pref, PushType type)
    {
        // Kayıt yoksa varsayılanlar: Master/Assigned/Reminder/Results açık, Announcements kapalı.
        if (pref is null)
        {
            return type != PushType.Announcements;
        }

        if (!pref.Master)
        {
            return false;
        }

        return type switch
        {
            PushType.Assigned => pref.Assigned,
            PushType.Reminder => pref.Reminder,
            PushType.Results => pref.Results,
            PushType.Announcements => pref.Announcements,
            _ => false,
        };
    }
}
