import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_progress_dto.freezed.dart';
part 'student_progress_dto.g.dart';

/// Öğrenci gelişim özeti — API `StudentProgressDto`
/// (`GET /api/students/me/progress`).
///
/// Stitch `55a66eca…` "Gelişim Özeti" bentosunu besler. `studentStatsDto`'dan
/// farklı olarak haftalık çalışma süresi/hedefi, günlük seri ve doğruluk trendi
/// gibi türetilmiş metrikleri de içerir.
///
/// - [accuracyTrendDelta] son 7 gün − önceki 7 gün doğruluk farkı (int). Önceki
///   pencerede hiç sonuç yoksa null (kıyaslanacak veri yok).
/// - [weeklyMinutes] / [weeklyGoalMinutes] haftalık çalışma süresi ve hedefi (dk).
/// - [streakDays] ardışık aktif gün sayısı (greeting'deki ateş rozeti).
@freezed
class StudentProgressDto with _$StudentProgressDto {
  const StudentProgressDto._();

  const factory StudentProgressDto({
    required int gamesPlayed,
    required int averageAccuracy,
    int? accuracyTrendDelta,
    required int weeklyMinutes,
    required int weeklyGoalMinutes,
    required int streakDays,
  }) = _StudentProgressDto;

  factory StudentProgressDto.fromJson(Map<String, dynamic> json) =>
      _$StudentProgressDtoFromJson(json);

  /// Ortalama doğruluk savunmacı olarak 0–100 aralığına sıkıştırılır.
  int get accuracyPercent => averageAccuracy.clamp(0, 100);

  /// Haftalık hedef ilerlemesi 0.0–1.0 aralığında (hedef 0 ise 0).
  double get weeklyProgress {
    if (weeklyGoalMinutes <= 0) return 0;
    return (weeklyMinutes / weeklyGoalMinutes).clamp(0.0, 1.0);
  }

  /// Hedefe ulaşmak için kalan dakika (negatif olmaz).
  int get remainingMinutes {
    final remaining = weeklyGoalMinutes - weeklyMinutes;
    return remaining > 0 ? remaining : 0;
  }
}
