using LingoCross.Application.Lessons.Dtos;

namespace LingoCross.Application.Lessons;

/// <summary>
/// Öğretmenin ders içerik yönetimi. Sahiplik kuralları bu katmanda uygulanır: yalnızca Teacher
/// rolü ders oluşturabilir ve öğretmen yalnızca kendi derslerine erişebilir.
/// </summary>
public interface ILessonService
{
    Task<LessonDto> CreateAsync(CreateLessonRequest request, CancellationToken cancellationToken = default);

    /// <summary>Oturum açan öğretmenin tüm dersleri.</summary>
    Task<IReadOnlyList<LessonDto>> ListMineAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Rol-duyarlı listeleme: öğretmen → kendi tüm dersleri; öğrenci → Active eşleşmesi olduğu
    /// öğretmenlerin yayımlanmış (is_published) dersleri.
    /// </summary>
    Task<IReadOnlyList<LessonDto>> ListVisibleAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Rol-duyarlı erişim: öğretmen → kendi dersi; öğrenci → enrolled+published ders. Aksi 404.
    /// </summary>
    Task<LessonDto> GetAsync(Guid lessonId, CancellationToken cancellationToken = default);

    Task<LessonDto> UpdateAsync(Guid lessonId, UpdateLessonRequest request, CancellationToken cancellationToken = default);

    Task DeleteAsync(Guid lessonId, CancellationToken cancellationToken = default);

    Task<LessonDto> PublishAsync(Guid lessonId, CancellationToken cancellationToken = default);
}
