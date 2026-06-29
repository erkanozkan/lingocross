import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/game_type.dart';

part 'game_dtos.freezed.dart';
part 'game_dtos.g.dart';

/// API'deki int `GameType` değerini ([GameType]) enum'una çevirir.
class GameTypeConverter implements JsonConverter<GameType, int> {
  const GameTypeConverter();

  @override
  GameType fromJson(int json) => GameType.fromValue(json);

  @override
  int toJson(GameType object) => object.value;
}

/// API'deki int `GameSessionStatus` değerini ([GameSessionStatus]) enum'una çevirir.
class GameSessionStatusConverter
    implements JsonConverter<GameSessionStatus, int> {
  const GameSessionStatusConverter();

  @override
  GameSessionStatus fromJson(int json) => GameSessionStatus.fromValue(json);

  @override
  int toJson(GameSessionStatus object) => object.value;
}

/// Bir derse ait oyunun özeti (GameDto) — API ile birebir.
@freezed
class GameDto with _$GameDto {
  const factory GameDto({
    required String id,
    required String lessonId,
    @GameTypeConverter() required GameType type,
    required String title,
    required bool isPublished,
    DateTime? publishedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _GameDto;

  factory GameDto.fromJson(Map<String, dynamic> json) =>
      _$GameDtoFromJson(json);
}

/// Öğrenciye atanmış (yayımlanmış) bir oyunun özeti (AssignedGameDto) — API ile
/// birebir. Öğrenci panelindeki "atanan bulmacalar" listesini besler.
///
/// [isCompleted] true ise bulmaca tamamlanmıştır (tekrar oynanamaz; yalnız
/// istatistik). Tamamlanmış oyunlarda [resultId]/[score]/[completedAt] doludur
/// ve dokununca `GET /results`'ten istatistik ekranına gidilir (replay değil).
@freezed
class AssignedGameDto with _$AssignedGameDto {
  const factory AssignedGameDto({
    required String id,
    required String lessonId,
    required String lessonTitle,
    @GameTypeConverter() required GameType type,
    required String title,
    required int wordCount,
    required String teacherName,
    DateTime? publishedAt,
    @Default(false) bool isCompleted,
    String? resultId,
    int? score,
    DateTime? completedAt,
  }) = _AssignedGameDto;

  factory AssignedGameDto.fromJson(Map<String, dynamic> json) =>
      _$AssignedGameDtoFromJson(json);
}

/// Öğretmenin "Bulmacalarım" görünümü için tüm derslerindeki bir bulmacanın
/// özeti (TeacherPuzzleDto) — API ile birebir.
///
/// [assignedStudentCount] yayımlı bulmacanın atandığı Active öğrenci sayısı
/// (bireysel model; sınıf/grup yok). [solveCount] bu bulmacaya ait tamamlanmış
/// sonuç (game_results) sayısıdır.
@freezed
class TeacherPuzzleDto with _$TeacherPuzzleDto {
  const factory TeacherPuzzleDto({
    required String id,
    required String lessonId,
    required String lessonTitle,
    @GameTypeConverter() required GameType type,
    required bool isPublished,
    required DateTime createdAt,
    required int assignedStudentCount,
    required int solveCount,
  }) = _TeacherPuzzleDto;

  factory TeacherPuzzleDto.fromJson(Map<String, dynamic> json) =>
      _$TeacherPuzzleDtoFromJson(json);
}

/// Öğretmenin bir derste oyun oluşturma/yayımlama isteği (CreateGameRequest).
///
/// [classIds] opsiyonel: F4.3 ile oyun oluştururken hedef sınıflar atanır
/// (`POST /lessons/{id}/games` body'sine eklenir). Boş/null ise mevcut davranış.
@freezed
class CreateGameRequest with _$CreateGameRequest {
  const factory CreateGameRequest({
    @GameTypeConverter() required GameType type,
    String? title,
    List<String>? classIds,
  }) = _CreateGameRequest;

  factory CreateGameRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateGameRequestFromJson(json);
}

/// Bir oyun oturumunun durumu (GameSessionDto) — API ile birebir.
@freezed
class GameSessionDto with _$GameSessionDto {
  const factory GameSessionDto({
    required String id,
    required String gameId,
    required String studentId,
    @GameSessionStatusConverter() required GameSessionStatus status,
    required DateTime startedAt,
    DateTime? completedAt,
  }) = _GameSessionDto;

  factory GameSessionDto.fromJson(Map<String, dynamic> json) =>
      _$GameSessionDtoFromJson(json);
}

/// Tek bir eşleştirme çifti: kaynak terim + doğru birincil çeviri (MatchingPair).
@freezed
class MatchingPair with _$MatchingPair {
  const factory MatchingPair({
    required String wordId,
    required String term,
    required String correctTranslation,
  }) = _MatchingPair;

  factory MatchingPair.fromJson(Map<String, dynamic> json) =>
      _$MatchingPairFromJson(json);
}

/// Kelime eşleştirme oyun içeriği (WordMatchingContent).
///
/// [pairs] doğru eşleşmeleri taşır; [distractors] hiçbir terimle eşleşmeyen
/// ek (çeldirici) Türkçe karşılıklardır. İstemci sağ sütunu
/// (doğru çeviriler + çeldiriciler) karıştırarak kurar.
@freezed
class WordMatchingContent with _$WordMatchingContent {
  const factory WordMatchingContent({
    required List<MatchingPair> pairs,
    required List<String> distractors,
  }) = _WordMatchingContent;

  factory WordMatchingContent.fromJson(Map<String, dynamic> json) =>
      _$WordMatchingContentFromJson(json);
}

/// Scrambled (karışık harfler) oyununda tek bir kelime (ScrambledItem) — API ile
/// birebir.
///
/// [answer] kaynak (doğru) terim; öğrenci bunu yeniden dizer. [scrambledLetters]
/// karışık harflerin tek string hâli (ör. "ppela"); istemci karaktere bölerek
/// havuzu kurar. [clue] hedef dildeki çeviri (ipucu olarak gösterilir).
@freezed
class ScrambledItem with _$ScrambledItem {
  const factory ScrambledItem({
    required String wordId,
    required String answer,
    required String scrambledLetters,
    required String clue,
  }) = _ScrambledItem;

  factory ScrambledItem.fromJson(Map<String, dynamic> json) =>
      _$ScrambledItemFromJson(json);
}

/// Scrambled (karışık harfler) oyun içeriği (ScrambledContent) — API ile birebir.
///
/// [items] her biri bir kelimeyi temsil eder (karışık harfler + çeviri ipucu).
@freezed
class ScrambledContent with _$ScrambledContent {
  const factory ScrambledContent({
    required List<ScrambledItem> items,
  }) = _ScrambledContent;

  factory ScrambledContent.fromJson(Map<String, dynamic> json) =>
      _$ScrambledContentFromJson(json);
}

/// Çoktan seçmeli soruda tek bir şık (QuestionChoice) — API ile birebir.
///
/// [optionId] şıkkın kalıcı kimliği (doğru cevap eşleşmesi bununla yapılır).
/// [label] görünür harf etiketi ("A".."E"). [text] şık metni.
@freezed
class QuestionChoice with _$QuestionChoice {
  const factory QuestionChoice({
    required String optionId,
    required String label,
    required String text,
  }) = _QuestionChoice;

  factory QuestionChoice.fromJson(Map<String, dynamic> json) =>
      _$QuestionChoiceFromJson(json);
}

/// Çoktan seçmeli tek bir soru (QuestionItem) — API ile birebir.
///
/// [stem] soru kökü. [choices] A–E sırasında şıklar. [correctOptionId] doğru
/// şıkkın [QuestionChoice.optionId]'si (skorlama İSTEMCİDE bununla yapılır).
/// [explanation] opsiyonel açıklama (oyun sırasında gösterilmez; ileride
/// kullanılabilir).
@freezed
class QuestionItem with _$QuestionItem {
  const factory QuestionItem({
    required String questionId,
    required String stem,
    required List<QuestionChoice> choices,
    required String correctOptionId,
    String? explanation,
  }) = _QuestionItem;

  factory QuestionItem.fromJson(Map<String, dynamic> json) =>
      _$QuestionItemFromJson(json);
}

/// Çıkmış Sorular (çoktan seçmeli) oyun içeriği (QuestionSetContent) — API ile
/// birebir.
///
/// [questions] 10 soruluk set; her biri A–E şıklı tek seçimdir. Doğru cevap
/// içerikle gelir (skorlama istemcide); tekrar çözme backend'de tek sefer.
@freezed
class QuestionSetContent with _$QuestionSetContent {
  const factory QuestionSetContent({
    required List<QuestionItem> questions,
  }) = _QuestionSetContent;

  factory QuestionSetContent.fromJson(Map<String, dynamic> json) =>
      _$QuestionSetContentFromJson(json);
}

/// Öğretmenin atayabileceği bir soru konusu (QuestionTopicDto) — API ile birebir.
///
/// `GET /api/question-topics` döner. [questionCount] konudaki soru adedi (rozet).
@freezed
class QuestionTopicDto with _$QuestionTopicDto {
  const factory QuestionTopicDto({
    required String id,
    required String title,
    String? description,
    required int questionCount,
  }) = _QuestionTopicDto;

  factory QuestionTopicDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionTopicDtoFromJson(json);
}

/// Bir oyunun/konunun sınıf atamalarının özeti (GameAssignmentsDto) — API ile
/// birebir.
///
/// `POST/GET /api/question-topics/{topicId}/assignments` yanıtı. [classIds]
/// konunun atandığı sınıf kimlikleridir.
@freezed
class GameAssignmentsDto with _$GameAssignmentsDto {
  const factory GameAssignmentsDto({
    @Default(<String>[]) List<String> classIds,
  }) = _GameAssignmentsDto;

  factory GameAssignmentsDto.fromJson(Map<String, dynamic> json) =>
      _$GameAssignmentsDtoFromJson(json);
}

/// API'deki int `CrosswordDirection` değerini ([CrosswordDirection]) enum'una çevirir.
class CrosswordDirectionConverter
    implements JsonConverter<CrosswordDirection, int> {
  const CrosswordDirectionConverter();

  @override
  CrosswordDirection fromJson(int json) => CrosswordDirection.fromValue(json);

  @override
  int toJson(CrosswordDirection object) => object.value;
}

/// Bulmacadaki tek bir kelime girişi (CrosswordEntry) — API ile birebir.
///
/// [answer] yalnız A–Z BÜYÜK harfler (doğrulama istemcide). [clue] Türkçe ipucu.
/// [row]/[col] başlangıç hücresi (0-tabanlı). across → harfler sütun artarak,
/// down → satır artarak yerleşir. [number] klasik bulmaca numarasıdır.
@freezed
class CrosswordEntry with _$CrosswordEntry {
  const factory CrosswordEntry({
    required int number,
    required String answer,
    required String clue,
    required int row,
    required int col,
    @CrosswordDirectionConverter() required CrosswordDirection direction,
    required int length,
  }) = _CrosswordEntry;

  factory CrosswordEntry.fromJson(Map<String, dynamic> json) =>
      _$CrosswordEntryFromJson(json);
}

/// Crossword (bulmaca) oyun içeriği (CrosswordContent) — API ile birebir.
///
/// Izgara [rows]×[cols] hücredir (0-tabanlı, satır-major). [entries] her biri bir
/// kelimeyi temsil eder. Kesişen hücrelerde harfler tutarlıdır (üretim garanti eder).
@freezed
class CrosswordContent with _$CrosswordContent {
  const factory CrosswordContent({
    required int rows,
    required int cols,
    required List<CrosswordEntry> entries,
  }) = _CrosswordContent;

  factory CrosswordContent.fromJson(Map<String, dynamic> json) =>
      _$CrosswordContentFromJson(json);
}

/// Oyun önizleme yanıtı (GamePreviewResponse): kaydetmeden önce üretilecek
/// örnek içerik. `POST /lessons/{lessonId}/games/preview` döner. Kalıcı değildir;
/// [type] WordMatching ise [wordMatching] doludur, Crossword ise [crossword].
/// İçerik şekilleri [StartGameSessionResponse] ile aynı DTO'ları kullanır.
@freezed
class GamePreviewResponse with _$GamePreviewResponse {
  const factory GamePreviewResponse({
    @GameTypeConverter() required GameType type,
    WordMatchingContent? wordMatching,
    CrosswordContent? crossword,
    ScrambledContent? scrambled,
    QuestionSetContent? questionSet,
  }) = _GamePreviewResponse;

  factory GamePreviewResponse.fromJson(Map<String, dynamic> json) =>
      _$GamePreviewResponseFromJson(json);
}

/// Oturum başlatma yanıtı (StartGameSessionResponse): oturum + tür-duyarlı içerik.
///
/// Yeni şekil: `{ session, type, wordMatching?, crossword? }`. [type] WordMatching
/// ise [wordMatching] doludur (eski `content` ile aynı şekil); Crossword ise
/// [crossword] doludur. İstemci [type]'a göre dallanır.
@freezed
class StartGameSessionResponse with _$StartGameSessionResponse {
  const factory StartGameSessionResponse({
    required GameSessionDto session,
    @GameTypeConverter() required GameType type,
    WordMatchingContent? wordMatching,
    CrosswordContent? crossword,
    ScrambledContent? scrambled,
    QuestionSetContent? questionSet,
  }) = _StartGameSessionResponse;

  factory StartGameSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$StartGameSessionResponseFromJson(json);
}
