import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_stats_dto.freezed.dart';
part 'teacher_stats_dto.g.dart';

/// Öğretmen profil istatistikleri — API `TeacherStatsDto`
/// (`GET /api/teachers/me/stats`).
///
/// Sınıf/öğrenci sayısı + bu haftaki atanan/tamamlanan ödev sayısı ve genel
/// katılım oranı (0–100). Tümü gerçek backend verisinden türetilir.
@freezed
class TeacherStatsDto with _$TeacherStatsDto {
  const TeacherStatsDto._();

  const factory TeacherStatsDto({
    required int classCount,
    required int studentCount,
    required int weeklyAssignedCount,
    required int weeklyCompletedCount,
    required int completionRate,
  }) = _TeacherStatsDto;

  factory TeacherStatsDto.fromJson(Map<String, dynamic> json) =>
      _$TeacherStatsDtoFromJson(json);

  /// Katılım oranı savunmacı olarak 0–100 aralığına sıkıştırılır.
  int get completionPercent => completionRate.clamp(0, 100);

  /// Haftalık ilerleme oranı (0.0–1.0); atanmış ödev yoksa 0.
  double get weeklyProgress {
    if (weeklyAssignedCount <= 0) return 0;
    return (weeklyCompletedCount / weeklyAssignedCount).clamp(0.0, 1.0);
  }

  /// Bu hafta atanmış ödev var mı?
  bool get hasWeeklyAssignments => weeklyAssignedCount > 0;
}
