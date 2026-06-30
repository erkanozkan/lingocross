// @JsonKey on a freezed constructor parameter triggers invalid_annotation_target.
// Suppress it file-wide here rather than per-line: a line-level `// ignore:` above
// the field gets copied into the generated getters, where the file-level ignore in
// the .freezed.dart already covers it → duplicate_ignore warnings.
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../games/data/dtos/game_dtos.dart';
import '../../../games/domain/game_type.dart';

part 'result_dtos.freezed.dart';
part 'result_dtos.g.dart';

/// Bir oyun sonucunun gönderimi (öğrenci, oyun sonunda) — API `SubmitResultRequest`.
///
/// `durationMs` geçen süre (ms), `totalItems` çift sayısı, `correctItems` doğru
/// eşleşme sayısı. Eşleştirme oyunu tüm çiftler eşleşince biter → genelde
/// `correctItems == totalItems`, ama API skoru bu alanlardan hesaplar.
@freezed
class SubmitResultRequest with _$SubmitResultRequest {
  const factory SubmitResultRequest({
    required int durationMs,
    required int totalItems,
    required int correctItems,

    /// Kelime-bazlı döküm (F7.5). Opsiyonel; doluysa öğretmen "Sonuç Detayı"
    /// ekranında her terimin doğru/yanlış durumu + öğrenci cevabı gösterilir.
    /// Boş/null ise backend yalnız [totalItems]/[correctItems]'ten türetir.
    /// null iken JSON'a yazılmaz (gövde temiz kalır).
    @JsonKey(includeIfNull: false) List<SubmitResultItem>? items,
  }) = _SubmitResultRequest;

  factory SubmitResultRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitResultRequestFromJson(json);
}

/// Sonuç gönderiminde tek bir kelimenin sonucu (F7.5).
///
/// [ordinal] terim sırası (0-tabanlı), [term] kaynak (İngilizce) kelime ya da
/// bulmaca ipucu/cevap gösterimi, [expectedAnswer] doğru karşılık,
/// [studentAnswer] öğrencinin verdiği cevap (boş bıraktıysa null), [isCorrect]
/// doğru cevaplandı mı. JSON camelCase.
@freezed
class SubmitResultItem with _$SubmitResultItem {
  const factory SubmitResultItem({
    required int ordinal,
    required String term,
    required String expectedAnswer,
    String? studentAnswer,
    required bool isCorrect,
  }) = _SubmitResultItem;

  factory SubmitResultItem.fromJson(Map<String, dynamic> json) =>
      _$SubmitResultItemFromJson(json);
}

/// Bir oyun sonucunun tam görünümü (oturum + ders/oyun özetiyle) — API
/// `GameResultDto`. `submit`/`share`/`listMine` yanıtlarında kullanılır.
@freezed
class GameResultDto with _$GameResultDto {
  const GameResultDto._();

  const factory GameResultDto({
    required String id,
    required String sessionId,
    required String gameId,
    @GameTypeConverter() required GameType gameType,
    // QuestionSet (çıkmış sorular) sonucunda ders yoktur → lessonId null gelir;
    // lessonTitle yerine konu başlığı döner. (API ile birebir; aksi halde sonuç
    // yanıtı parse edilemez ve "Bitir" hata verir.)
    String? lessonId,
    required String lessonTitle,
    required int durationMs,
    required int totalItems,
    required int correctItems,
    required int score,
    required bool sharedWithTeacher,
    DateTime? sharedAt,
    required DateTime createdAt,
  }) = _GameResultDto;

  factory GameResultDto.fromJson(Map<String, dynamic> json) =>
      _$GameResultDtoFromJson(json);

  /// Doğruluk yüzdesi (0–100). API'nin verdiği [score] doğruluk yüzdesidir
  /// (M5 #40: 0–100); savunmacı olarak aralığa sıkıştırılır.
  int get accuracyPercent => score.clamp(0, 100);

  /// Geçen süre `MM:SS` biçiminde.
  String get formattedDuration {
    final totalSeconds = (durationMs / 1000).round();
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

/// Öğrencinin kendi sonucundaki tek bir kelimenin dökümü — API
/// `GET /api/results/{resultId}` yanıtındaki `items[]` öğesi (F7.5).
///
/// Öğretmen tarafındaki `ResultItemDto` ile alanları birebir aynıdır; ayrı
/// feature olduğu için ayrı tutulur (ortak görsel kart `ResultItemsBreakdown`
/// ile paylaşılır). [studentAnswer] öğrenci boş bıraktıysa null gelir. JSON
/// camelCase.
@freezed
class ResultItemModel with _$ResultItemModel {
  const factory ResultItemModel({
    required int ordinal,
    required String term,
    required String expectedAnswer,
    String? studentAnswer,
    required bool isCorrect,
  }) = _ResultItemModel;

  factory ResultItemModel.fromJson(Map<String, dynamic> json) =>
      _$ResultItemModelFromJson(json);
}

/// Öğrencinin kendi sonucunun kelime-bazlı dökümle birlikte tam görünümü —
/// API `GET /api/results/{resultId}` yanıtı.
///
/// Özet alanları `GameResultDto` ile birebirdir; ek olarak [items] kelime
/// dökümünü taşır. Eski sonuçlarda `items: []` döner → rapor ekranı "Cevap
/// Dökümü" bölümünü gizler. Başka bir öğrencinin sonucunda API 404 verir
/// (repository `ResultsFailure.notFound`'a çevirir).
@freezed
class GameResultDetailDto with _$GameResultDetailDto {
  const GameResultDetailDto._();

  const factory GameResultDetailDto({
    required String id,
    required String gameId,
    @GameTypeConverter() required GameType gameType,
    // QuestionSet sonucunda ders yoktur → lessonId null gelir.
    String? lessonId,
    required String lessonTitle,
    required int durationMs,
    required int totalItems,
    required int correctItems,
    required int score,
    required bool sharedWithTeacher,
    DateTime? sharedAt,
    required DateTime createdAt,
    @Default(<ResultItemModel>[]) List<ResultItemModel> items,
  }) = _GameResultDetailDto;

  factory GameResultDetailDto.fromJson(Map<String, dynamic> json) =>
      _$GameResultDetailDtoFromJson(json);

  /// Doğruluk yüzdesi (0–100). API skoru doğruluk yüzdesidir; aralığa sıkıştırılır.
  int get accuracyPercent => score.clamp(0, 100);

  /// Geçen süre `MM:SS` biçiminde.
  String get formattedDuration {
    final totalSeconds = (durationMs / 1000).round();
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Kelime-bazlı döküm var mı (yoksa bölüm gizlenir).
  bool get hasItems => items.isNotEmpty;

  /// Bu detayı özet rapor gövdesinin beklediği [GameResultDto]'ya dönüştürür
  /// (mevcut özet/radyal/bento UI'ı değişmeden çalışsın diye).
  GameResultDto toSummary({required String sessionId}) => GameResultDto(
    id: id,
    sessionId: sessionId,
    gameId: gameId,
    gameType: gameType,
    lessonId: lessonId,
    lessonTitle: lessonTitle,
    durationMs: durationMs,
    totalItems: totalItems,
    correctItems: correctItems,
    score: score,
    sharedWithTeacher: sharedWithTeacher,
    sharedAt: sharedAt,
    createdAt: createdAt,
  );
}
