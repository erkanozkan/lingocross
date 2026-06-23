using LingoCross.Application.Words.Dtos;

namespace LingoCross.Application.Words;

/// <summary>
/// Bir derse ait kelimelerin (çeviri + eşanlam dahil) yönetimi. Sahiplik kuralları bu katmanda
/// uygulanır: öğretmen yalnızca kendi dersinin kelimelerini görür ve yönetir.
/// </summary>
public interface IWordService
{
    Task<IReadOnlyList<WordDto>> ListByLessonAsync(Guid lessonId, CancellationToken cancellationToken = default);

    Task<WordDto> AddAsync(Guid lessonId, AddWordRequest request, CancellationToken cancellationToken = default);

    Task<WordDto> UpdateAsync(Guid wordId, UpdateWordRequest request, CancellationToken cancellationToken = default);

    Task DeleteAsync(Guid wordId, CancellationToken cancellationToken = default);
}
