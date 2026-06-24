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
  }) = _AssignedGameDto;

  factory AssignedGameDto.fromJson(Map<String, dynamic> json) =>
      _$AssignedGameDtoFromJson(json);
}

/// Öğretmenin bir derste oyun oluşturma/yayımlama isteği (CreateGameRequest).
@freezed
class CreateGameRequest with _$CreateGameRequest {
  const factory CreateGameRequest({
    @GameTypeConverter() required GameType type,
    String? title,
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

/// Oturum başlatma yanıtı (StartGameSessionResponse): oturum + içerik.
@freezed
class StartGameSessionResponse with _$StartGameSessionResponse {
  const factory StartGameSessionResponse({
    required GameSessionDto session,
    required WordMatchingContent content,
  }) = _StartGameSessionResponse;

  factory StartGameSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$StartGameSessionResponseFromJson(json);
}
