namespace LingoCross.Application.Common.Persistence;

/// <summary>
/// EF tiplerini Application'a sızdırmadan bir veritabanı transaction'ını soyutlar.
/// Onaylamak için <see cref="CommitAsync"/> çağrılır; dispose edilirken onaylanmamışsa geri alınır.
/// </summary>
public interface IAppDbTransaction : IAsyncDisposable
{
    Task CommitAsync(CancellationToken cancellationToken = default);
}
