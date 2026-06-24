import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../games/data/dtos/game_dtos.dart';
import '../../../games/domain/game_type.dart';

part 'tracking_dtos.freezed.dart';
part 'tracking_dtos.g.dart';

/// Öğretmen takip panelinde bir öğrencinin özet satırı — API `StudentSummaryDto`.
///
/// Sayılar/ortalama/son aktivite yalnızca öğrencinin bu öğretmenle <b>paylaştığı</b>
/// (shared_with_teacher=true) sonuçlar üzerinden hesaplanır. [averageScore] ve
/// [lastActivityAt] paylaşım yoksa `null` gelir (UI'de "—" / "henüz yok").
@freezed
class StudentSummaryDto with _$StudentSummaryDto {
  const StudentSummaryDto._();

  const factory StudentSummaryDto({
    required String studentId,
    required String displayName,
    required int sharedResultsCount,
    int? averageScore,
    DateTime? lastActivityAt,
  }) = _StudentSummaryDto;

  factory StudentSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$StudentSummaryDtoFromJson(json);

  /// Ortalama skor savunmacı olarak 0–100 aralığına sıkıştırılır; yoksa `null`.
  int? get averagePercent => averageScore?.clamp(0, 100);

  /// Öğrencinin paylaştığı en az bir sonucu var mı?
  bool get hasSharedResults => sharedResultsCount > 0;
}

/// Öğretmenin bir öğrencisinin paylaştığı tek bir sonucun görünümü — API
/// `SharedResultDto` (ders/oyun özetiyle). Yalnız shared_with_teacher=true sonuçlar.
@freezed
class SharedResultDto with _$SharedResultDto {
  const SharedResultDto._();

  const factory SharedResultDto({
    required String resultId,
    required String lessonTitle,
    @GameTypeConverter() required GameType gameType,
    required int score,
    required int durationMs,
    required int totalItems,
    required int correctItems,
    DateTime? sharedAt,
    required DateTime createdAt,
  }) = _SharedResultDto;

  factory SharedResultDto.fromJson(Map<String, dynamic> json) =>
      _$SharedResultDtoFromJson(json);

  /// Doğruluk yüzdesi (0–100). API skoru doğruluk yüzdesidir; aralığa sıkıştırılır.
  int get accuracyPercent => score.clamp(0, 100);

  /// Geçen süre `MM:SS` biçiminde.
  String get formattedDuration {
    final totalSeconds = (durationMs / 1000).round();
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
