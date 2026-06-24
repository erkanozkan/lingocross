using LingoCross.Domain.Enums;

namespace LingoCross.Application.Games.Dtos;

/// <summary>Bir derse ait oyunun özet bilgisi (oluşturulduktan/yayımlandıktan sonra döndürülür).</summary>
public record GameDto(
    Guid Id,
    Guid LessonId,
    GameType Type,
    string Title,
    bool IsPublished,
    DateTime? PublishedAt,
    DateTime CreatedAt,
    DateTime UpdatedAt);

/// <summary>
/// Öğrenciye atanmış (yayımlanmış) bir oyunun özeti. Öğrenci panelinde "atanan bulmacalar"
/// listesini besler: oyun + ait olduğu ders + öğretmen adı + oynanabilir kelime sayısı.
/// </summary>
public record AssignedGameDto(
    Guid Id,
    Guid LessonId,
    string LessonTitle,
    GameType Type,
    string Title,
    int WordCount,
    string TeacherName,
    DateTime? PublishedAt);

/// <summary>Öğretmenin bir derste oyun oluşturma/yayımlama isteği.</summary>
public record CreateGameRequest(
    GameType Type,
    string? Title);

/// <summary>Bir oyun oturumunun durumu.</summary>
public record GameSessionDto(
    Guid Id,
    Guid GameId,
    Guid StudentId,
    GameSessionStatus Status,
    DateTime StartedAt,
    DateTime? CompletedAt);

/// <summary>
/// Oturum başlatma yanıtı: oturum bilgisi + üretilmiş kelime eşleştirme içeriği.
/// İstemci, içerikteki <see cref="WordMatchingContent.Pairs"/>'i sol sütun (terim), birincil
/// çevirilerini + <see cref="WordMatchingContent.Distractors"/>'ı karıştırarak sağ sütun
/// (Türkçe karşılıklar) olarak kurar.
/// </summary>
public record StartGameSessionResponse(
    GameSessionDto Session,
    WordMatchingContent Content);

/// <summary>
/// Kelime eşleştirme oyun içeriği. <see cref="Pairs"/> doğru eşleşmeleri taşır; her çiftin
/// birincil Türkçe karşılığı <see cref="MatchingPair.CorrectTranslation"/>'dadır.
/// <see cref="Distractors"/>, başka kelimelerin çevirilerinden seçilmiş ve doğru cevap olmayan
/// ek Türkçe karşılıklardır (sağ sütunu zorlaştırmak için). Tüm sağ-sütun adayları
/// (doğru çeviriler + çeldiriciler) benzersizdir.
/// </summary>
public record WordMatchingContent(
    IReadOnlyList<MatchingPair> Pairs,
    IReadOnlyList<string> Distractors);

/// <summary>Tek bir eşleştirme çifti: kaynak terim ve onun doğru birincil çevirisi.</summary>
public record MatchingPair(
    Guid WordId,
    string Term,
    string CorrectTranslation);
