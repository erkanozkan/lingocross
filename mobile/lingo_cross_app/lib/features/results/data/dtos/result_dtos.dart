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
  }) = _SubmitResultRequest;

  factory SubmitResultRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitResultRequestFromJson(json);
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
    required String lessonId,
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
