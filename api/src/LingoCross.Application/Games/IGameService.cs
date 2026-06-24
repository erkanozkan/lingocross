using LingoCross.Application.Games.Dtos;
using LingoCross.Domain.Enums;

namespace LingoCross.Application.Games;

/// <summary>
/// Kelime eşleştirme oyunlarının (bulmacaların) oluşturulması, yayımlanması ve oturum yönetimi.
/// F2.2: Öğretmen oyunu açıkça oluşturup yayımlar; yayımlanan oyun, öğretmenin Active eşleşmeli
/// öğrencilerine atanmış sayılır (enrollment'tan türetilir, ayrı atama tablosu yoktur).
/// Erişim/sahiplik kuralları bu katmanda uygulanır: öğretmen yalnızca kendi derslerine, öğrenci
/// yalnızca Active eşleşmesi olan öğretmenin yayımlanmış derslerine erişebilir.
/// </summary>
public interface IGameService
{
    /// <summary>
    /// Öğretmen, kendi dersinde bir oyun oluşturur ve yayımlar (IsPublished=true, PublishedAt=now).
    /// <see cref="GameType.WordMatching"/> için ders en az <c>MinWordsToPlay</c> çevirili kelime;
    /// <see cref="GameType.Crossword"/> için (F2.4) en az 4 bulmaca-uygun (yalnız A–Z harfli, ≥2 harf,
    /// çevirili) kelime içermeli; aksi 400. <see cref="GameType.QuestionSet"/> hâlâ rezerve → 400.
    /// Aynı ders+tür için oyun zaten varsa idempotent davranır: mevcut oyunu (gerekirse yeniden)
    /// yayımlayıp döndürür. Ders sahibi olmayan öğretmen/öğrenci → 404/403.
    /// </summary>
    Task<GameDto> CreateForLessonAsync(Guid lessonId, CreateGameRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Ders sahibinin o derse ait oyunlarını listeler (yalnız öğretmen, salt-okunur — otomatik
    /// üretim YOK). Ders sahibi olmayan öğretmen/öğrenci → 404.
    /// </summary>
    Task<IReadOnlyList<GameDto>> ListForLessonAsync(Guid lessonId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Öğrencinin Active eşleşmeli öğretmenlerinin yayımlanmış derslerindeki yayımlanmış
    /// (IsPublished=true) oyunlarını döndürür — öğrenciye atanmış bulmaca listesi.
    /// </summary>
    Task<IReadOnlyList<AssignedGameDto>> ListAssignedForStudentAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Bir oyun için (yalnızca öğrenci) yeni bir InProgress oturum oluşturur ve üretilmiş kelime
    /// eşleştirme içeriğini döndürür. Oyun yayımlanmış (IsPublished) olmalı ve dersin enrolled+published
    /// olması gerekir; aksi 403/404. İçerik için yeterli (en az 4) çevirili kelime yoksa AppException(400).
    /// </summary>
    Task<StartGameSessionResponse> StartSessionAsync(Guid gameId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Bir oturumun durumunu döndürür. Yalnızca oturumun sahibi öğrenci erişebilir; aksi 404.
    /// </summary>
    Task<GameSessionDto> GetSessionAsync(Guid sessionId, CancellationToken cancellationToken = default);
}
