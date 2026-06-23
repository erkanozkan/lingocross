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

    DbSet<Lesson> Lessons { get; }

    DbSet<Word> Words { get; }

    DbSet<WordTranslation> WordTranslations { get; }

    DbSet<WordSynonym> WordSynonyms { get; }

    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
}
