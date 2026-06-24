using LingoCross.Application.Common.Persistence;
using Microsoft.EntityFrameworkCore.Storage;

namespace LingoCross.Infrastructure.Persistence;

/// <summary>
/// EF Core <see cref="IDbContextTransaction"/>'ı Application katmanının <see cref="IAppDbTransaction"/>
/// soyutlamasına uyarlar. Böylece EF tipleri Application'a sızmaz.
/// </summary>
internal sealed class AppDbTransaction : IAppDbTransaction
{
    private readonly IDbContextTransaction _transaction;

    public AppDbTransaction(IDbContextTransaction transaction)
    {
        _transaction = transaction;
    }

    public Task CommitAsync(CancellationToken cancellationToken = default)
        => _transaction.CommitAsync(cancellationToken);

    public ValueTask DisposeAsync()
        => _transaction.DisposeAsync();
}

/// <summary>
/// İlişkisel olmayan sağlayıcılar (testlerdeki InMemory gibi) için no-op transaction.
/// Commit/Dispose hiçbir şey yapmaz; silmeler tek <c>SaveChanges</c> ile atomik kalır.
/// </summary>
internal sealed class NoopDbTransaction : IAppDbTransaction
{
    public static readonly NoopDbTransaction Instance = new();

    public Task CommitAsync(CancellationToken cancellationToken = default) => Task.CompletedTask;

    public ValueTask DisposeAsync() => ValueTask.CompletedTask;
}
