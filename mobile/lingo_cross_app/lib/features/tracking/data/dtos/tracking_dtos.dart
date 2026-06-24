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

/// "Sonuç Detayı" ekranındaki tek bir kelimenin dökümü (F7.5) — API `ResultItemDto`.
@freezed
class ResultItemDto with _$ResultItemDto {
  const factory ResultItemDto({
    required int ordinal,
    required String term,
    required String expectedAnswer,
    String? studentAnswer,
    required bool isCorrect,
  }) = _ResultItemDto;

  factory ResultItemDto.fromJson(Map<String, dynamic> json) =>
      _$ResultItemDtoFromJson(json);
}

/// Bir öğrencinin tek bir sonucunun, kelime-bazlı dökümle birlikte tam görünümü
/// (F7.5) — API `StudentResultDetailDto`.
///
/// `GET /teachers/me/students/{studentId}/results/{resultId}` yanıtı. [items]
/// boşsa (eski sonuç) ekran "kelime detayı yok" boş durumunu gösterir.
@freezed
class StudentResultDetailDto with _$StudentResultDetailDto {
  const StudentResultDetailDto._();

  const factory StudentResultDetailDto({
    required String resultId,
    required String studentDisplayName,
    required String lessonTitle,
    @GameTypeConverter() required GameType gameType,
    required int score,
    required int durationMs,
    required int totalItems,
    required int correctItems,
    DateTime? sharedAt,
    required DateTime createdAt,
    @Default(<ResultItemDto>[]) List<ResultItemDto> items,
  }) = _StudentResultDetailDto;

  factory StudentResultDetailDto.fromJson(Map<String, dynamic> json) =>
      _$StudentResultDetailDtoFromJson(json);

  /// Doğruluk yüzdesi (0–100). API skoru doğruluk yüzdesidir; aralığa sıkıştırılır.
  int get accuracyPercent => score.clamp(0, 100);

  /// Geçen süre `MM:SS` biçiminde.
  String get formattedDuration {
    final totalSeconds = (durationMs / 1000).round();
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Kelime-bazlı döküm var mı (yoksa boş durum gösterilir).
  bool get hasItems => items.isNotEmpty;

  /// Doğru cevaplanan item sayısı (filtre rozeti için).
  int get correctItemsCount => items.where((i) => i.isCorrect).length;

  /// Yanlış cevaplanan item sayısı (filtre rozeti için).
  int get wrongItemsCount => items.where((i) => !i.isCorrect).length;

  /// Kelime başına ortalama saniye (Bölüm Analizi — sınıf ortalaması YOK).
  /// [totalItems] 0 ise null (bölüm gizlenir).
  double? get secondsPerWord {
    if (totalItems <= 0) return null;
    return durationMs / 1000 / totalItems;
  }
}
