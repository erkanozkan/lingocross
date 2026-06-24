using LingoCross.Application.Games.Dtos;

namespace LingoCross.Application.Games;

/// <summary>
/// Kelime eşleştirme oyunlarının üretimi ve oturum yönetimi. Erişim/sahiplik kuralları bu
/// katmanda uygulanır: öğretmen yalnızca kendi derslerine, öğrenci yalnızca Active eşleşmesi olan
/// öğretmenin yayımlanmış derslerine erişebilir. Sonuç (game_results) M5 kapsamındadır.
/// </summary>
public interface IGameService
{
    /// <summary>
    /// Dersin oyunlarını döndürür; WordMatching oyunu yoksa üretip ekler (idempotent).
    /// Öğretmen kendi dersi, öğrenci enrolled+published ders için erişebilir; aksi 404.
    /// </summary>
    Task<IReadOnlyList<GameDto>> ListOrCreateForLessonAsync(Guid lessonId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Bir oyun için (yalnızca öğrenci) yeni bir InProgress oturum oluşturur ve üretilmiş kelime
    /// eşleştirme içeriğini döndürür. Dersin enrolled+published olması gerekir; içerik için yeterli
    /// (en az 4) çevirili kelime yoksa AppException(400) atılır.
    /// </summary>
    Task<StartGameSessionResponse> StartSessionAsync(Guid gameId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Bir oturumun durumunu döndürür. Yalnızca oturumun sahibi öğrenci erişebilir; aksi 404.
    /// </summary>
    Task<GameSessionDto> GetSessionAsync(Guid sessionId, CancellationToken cancellationToken = default);
}
