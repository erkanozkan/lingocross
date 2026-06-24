using LingoCross.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace LingoCross.Application.Common.Persistence;

/// <summary>
/// Application servislerinin veritabanına eriştiği soyutlama. AppDbContext (Infrastructure) bunu uygular.
/// EF tipleri Domain'e sızmaz; Application yalnızca DbSet'ler ve SaveChanges'e ihtiyaç duyar.
/// </summary>
public interface IAppDbContext
{
    DbSet<User> Users { get; }

    DbSet<RefreshToken> RefreshTokens { get; }

    DbSet<PasswordResetToken> PasswordResetTokens { get; }

    DbSet<Enrollment> Enrollments { get; }

    DbSet<Lesson> Lessons { get; }

    DbSet<Word> Words { get; }

    DbSet<WordTranslation> WordTranslations { get; }

    DbSet<WordSynonym> WordSynonyms { get; }

    DbSet<Game> Games { get; }

    DbSet<GameSession> GameSessions { get; }

    DbSet<GameResult> GameResults { get; }

    DbSet<GameResultItem> GameResultItems { get; }

    DbSet<Class> Classes { get; }

    DbSet<ClassMember> ClassMembers { get; }

    DbSet<GameAssignment> GameAssignments { get; }

    DbSet<DeviceToken> DeviceTokens { get; }

    DbSet<NotificationPreference> NotificationPreferences { get; }

    DbSet<Subscription> Subscriptions { get; }

    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Bir veritabanı transaction'ı başlatır. Çağıran <c>CommitAsync</c> ile onaylar; aksi halde
    /// (dispose anında) geri alınır. İlişkisel olmayan sağlayıcılarda (ör. testlerdeki InMemory)
    /// no-op bir transaction döner.
    /// </summary>
    Task<IAppDbTransaction> BeginTransactionAsync(CancellationToken cancellationToken = default);
}
