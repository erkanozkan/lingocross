import 'package:lingo_cross_app/features/profile/data/dtos/student_progress_dto.dart';
import 'package:lingo_cross_app/features/profile/data/dtos/student_stats_dto.dart';
import 'package:lingo_cross_app/features/profile/data/student_stats_repository.dart';
import 'package:lingo_cross_app/features/profile/domain/profile_failure.dart';

/// Testlerde gerçek Dio yerine kullanılan sahte öğrenci istatistik repository.
class FakeStudentStatsRepository implements StudentStatsRepository {
  FakeStudentStatsRepository({
    this.stats,
    this.error,
    this.progress,
    this.progressError,
  });

  final StudentStatsDto? stats;
  final ProfileFailure? error;
  final StudentProgressDto? progress;
  final ProfileFailure? progressError;

  int fetchCount = 0;
  int progressFetchCount = 0;

  @override
  Future<StudentStatsDto> fetchMyStats() async {
    fetchCount++;
    if (error != null) throw error!;
    return stats ?? const StudentStatsDto(gamesPlayed: 0, averageAccuracy: 0);
  }

  @override
  Future<StudentProgressDto> getMyProgress() async {
    progressFetchCount++;
    if (progressError != null) throw progressError!;
    return progress ??
        const StudentProgressDto(
          gamesPlayed: 0,
          averageAccuracy: 0,
          accuracyTrendDelta: null,
          weeklyMinutes: 0,
          weeklyGoalMinutes: 500,
          streakDays: 0,
        );
  }
}
