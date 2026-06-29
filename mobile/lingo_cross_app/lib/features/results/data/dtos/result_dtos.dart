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
