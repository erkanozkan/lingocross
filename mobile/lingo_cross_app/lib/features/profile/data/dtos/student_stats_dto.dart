import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_stats_dto.freezed.dart';
part 'student_stats_dto.g.dart';

/// Öğrenci profil istatistikleri — API `StudentStatsDto`
/// (`GET /api/students/me/stats`).
///
/// Yalnızca tamamlanmış oyun sonuçlarından türetilen iki **gerçek** metrik
/// içerir: oynanan oyun sayısı ve ortalama başarı puanı (0–100). Günlük seri /
/// haftalık hedef / rozet bu fazda yoktur (ekranda placeholder olarak gösterilir).
@freezed
class StudentStatsDto with _$StudentStatsDto {
  const StudentStatsDto._();

  const factory StudentStatsDto({
    required int gamesPlayed,
    required int averageAccuracy,
  }) = _StudentStatsDto;

  factory StudentStatsDto.fromJson(Map<String, dynamic> json) =>
      _$StudentStatsDtoFromJson(json);

  /// Ortalama doğruluk savunmacı olarak 0–100 aralığına sıkıştırılır.
  int get accuracyPercent => averageAccuracy.clamp(0, 100);
}
