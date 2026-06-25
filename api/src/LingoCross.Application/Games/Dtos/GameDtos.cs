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
/// Tamamlanma alanları öğrencinin bu oyunu zaten bitirip bitirmediğini taşır: tamamlanmışsa
/// <see cref="IsCompleted"/> true ve <see cref="ResultId"/>/<see cref="Score"/>/<see cref="CompletedAt"/>
/// dolar; aksi halde false/null. Tamamlanmış bir oyun tekrar oynanamaz (StartSession 409 döner).
/// </summary>
public record AssignedGameDto(
    Guid Id,
    Guid LessonId,
    string LessonTitle,
    GameType Type,
    string Title,
    int WordCount,
    string TeacherName,
    DateTime? PublishedAt,
    bool IsCompleted,
    Guid? ResultId,
    int? Score,
    DateTime? CompletedAt);

/// <summary>
/// Öğretmenin "Bulmacalarım" görünümü için tüm derslerindeki bir bulmacanın özeti. Yayımlanmış bir
/// bulmaca, öğretmenin tüm Active eşleşmeli öğrencilerine atanmış sayılır (<see cref="AssignedStudentCount"/>);
/// <see cref="SolveCount"/> bu bulmacaya ait tamamlanmış sonuç (game_results) sayısıdır.
/// </summary>
public record TeacherPuzzleDto(
    Guid Id,
    Guid LessonId,
    string LessonTitle,
    GameType Type,
    bool IsPublished,
    DateTime CreatedAt,
    int AssignedStudentCount,
    int SolveCount);

/// <summary>
/// Öğretmenin bir derste oyun oluşturma/yayımlama isteği. <see cref="ClassIds"/> verilirse (F4.3)
/// oyun, oluşturma ile aynı işlemde bu sınıflara atanır (set semantiği). null → atama dokunulmaz.
/// </summary>
public record CreateGameRequest(
    GameType Type,
    string? Title,
    IReadOnlyList<Guid>? ClassIds = null);

/// <summary>Bir oyunun atandığı sınıf kimlikleri (F4.3, set semantiği).</summary>
public record GameAssignmentsDto(
    IReadOnlyList<Guid> ClassIds);

/// <summary>Bir oyunu sınıflara atama isteği (gönderilen liste nihaidir; set semantiği).</summary>
public record SetGameAssignmentsRequest(
    IReadOnlyList<Guid> ClassIds);

/// <summary>
/// Öğretmenin bir oyun (bulmaca) için, kaydetmeden ÖNCE örnek içerik önizleme isteği. Yalnız tür
/// taşınır; başlık/atama yok (önizleme kalıcı değildir).
/// </summary>
public record PreviewGameRequest(
    GameType Type);

/// <summary>
/// Öğretmen önizleme yanıtı: oturum OLMADAN üretilmiş örnek oyun içeriği (<see cref="StartGameSessionResponse"/>
/// deseni, ama session yok). İçerik <see cref="Type"/>'a göre tür-duyarlıdır:
/// <list type="bullet">
///   <item><see cref="GameType.WordMatching"/> → <see cref="WordMatching"/> doludur (diğeri null).</item>
///   <item><see cref="GameType.Crossword"/> → <see cref="Crossword"/> doludur (diğeri null).</item>
/// </list>
/// Hiçbir Game/GameSession kaydı oluşturulmaz; içerik StartSession ile aynı yeterlilik kurallarına tabidir.
/// </summary>
public record GamePreviewResponse(
    GameType Type,
    WordMatchingContent? WordMatching,
    CrosswordContent? Crossword,
    ScrambledContent? Scrambled);

/// <summary>Bir oyun oturumunun durumu.</summary>
public record GameSessionDto(
    Guid Id,
    Guid GameId,
    Guid StudentId,
    GameSessionStatus Status,
    DateTime StartedAt,
    DateTime? CompletedAt);

/// <summary>
/// Oturum başlatma yanıtı: oturum bilgisi + üretilmiş oyun içeriği. İçerik <see cref="Type"/>'a göre
/// tür-duyarlıdır; istemci türü okuyup yalnızca ilgili alanı kullanır:
/// <list type="bullet">
///   <item><see cref="GameType.WordMatching"/> → <see cref="WordMatching"/> doludur (diğeri null).</item>
///   <item><see cref="GameType.Crossword"/> → <see cref="Crossword"/> doludur (diğeri null).</item>
/// </list>
/// Geriye dönük uyumluluk: WordMatching oturumlarında <see cref="WordMatching"/> önceki
/// <c>Content</c> alanının aynısıdır (aynı şekil: pairs + distractors).
/// </summary>
public record StartGameSessionResponse(
    GameSessionDto Session,
    GameType Type,
    WordMatchingContent? WordMatching,
    CrosswordContent? Crossword,
    ScrambledContent? Scrambled);

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

/// <summary>
/// Crossword (bulmaca) oyun içeriği. Izgara <see cref="Rows"/>×<see cref="Cols"/> hücredir
/// (0-tabanlı, satır-major). Her giriş bir kelimeyi temsil eder:
/// <para>
/// - <see cref="CrosswordEntry.Answer"/> doğru cevaptır: yalnız A–Z BÜYÜK harfler (İngilizce terimden
///   normalize). MVP'de cevap istemciye gönderilir; doğrulama istemcide yapılır.<br/>
/// - <see cref="CrosswordEntry.Clue"/> ipucudur: terimin birincil Türkçe karşılığı.<br/>
/// - <see cref="CrosswordEntry.Row"/>/<see cref="CrosswordEntry.Col"/> kelimenin BAŞLANGIÇ hücresidir
///   (0-tabanlı). across (yatay) ise harfler sütun artarak, down (dikey) ise satır artarak yerleşir.<br/>
/// - <see cref="CrosswordEntry.Direction"/>: 0 = across (yatay), 1 = down (dikey).<br/>
/// - <see cref="CrosswordEntry.Number"/> klasik bulmaca numarasıdır; başlangıç hücreleri satır-major
///   sırada numaralanır, aynı hücreden hem across hem down başlıyorsa ikisi aynı numarayı paylaşır.
/// </para>
/// İstemci ızgarayı şöyle kurabilir: <see cref="Rows"/>×<see cref="Cols"/> boş ızgara aç; her giriş
/// için başlangıç hücresinden yönüne göre <see cref="CrosswordEntry.Length"/> hücreyi işaretle.
/// Kesişen hücrelerde harfler tutarlıdır (üretim bunu garanti eder).
/// </summary>
public record CrosswordContent(
    int Rows,
    int Cols,
    IReadOnlyList<CrosswordEntry> Entries);

/// <summary>Bulmacadaki tek bir kelime girişi. Bkz. <see cref="CrosswordContent"/>.</summary>
public record CrosswordEntry(
    int Number,
    string Answer,
    string Clue,
    int Row,
    int Col,
    CrosswordDirection Direction,
    int Length);

/// <summary>
/// Scrambled (harf karıştırma) oyun içeriği. Her <see cref="ScrambledItem"/> bir kelimeyi temsil eder:
/// kaynak terimin harfleri karıştırılmış olarak verilir, öğrenci doğru sıraya dizer.
/// </summary>
public record ScrambledContent(
    IReadOnlyList<ScrambledItem> Items);

/// <summary>
/// Tek bir scrambled kelime. <see cref="Answer"/> doğru cevaptır (kaynak terim, olduğu gibi),
/// <see cref="ScrambledLetters"/> aynı harflerin karıştırılmış hâlidir (çoklu-küme olarak Answer ile aynı),
/// <see cref="Clue"/> ipucudur (terimin birincil Türkçe karşılığı). MVP'de cevap istemciye gönderilir;
/// doğrulama istemcide yapılır.
/// </summary>
public record ScrambledItem(
    Guid WordId,
    string Answer,
    string ScrambledLetters,
    string Clue);

/// <summary>Bulmaca kelime yönü. Sayısal değerler istemciyle paylaşılır.</summary>
public enum CrosswordDirection
{
    /// <summary>Yatay (soldan sağa); harfler sütun artarak yerleşir.</summary>
    Across = 0,

    /// <summary>Dikey (yukarıdan aşağı); harfler satır artarak yerleşir.</summary>
    Down = 1,
}
