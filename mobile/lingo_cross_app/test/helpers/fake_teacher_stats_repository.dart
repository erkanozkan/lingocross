import 'package:lingo_cross_app/features/profile/data/dtos/teacher_stats_dto.dart';
import 'package:lingo_cross_app/features/profile/data/teacher_stats_repository.dart';
import 'package:lingo_cross_app/features/profile/domain/profile_failure.dart';

/// Testlerde gerçek Dio yerine kullanılan sahte öğretmen istatistik repository.
class FakeTeacherStatsRepository implements TeacherStatsRepository {
  FakeTeacherStatsRepository({this.stats, this.error});

  final TeacherStatsDto? stats;
  final ProfileFailure? error;

  int fetchCount = 0;

  @override
  Future<TeacherStatsDto> fetchMyStats() async {
    fetchCount++;
    if (error != null) throw error!;
    return stats ??
        const TeacherStatsDto(
          classCount: 0,
          studentCount: 0,
          weeklyAssignedCount: 0,
          weeklyCompletedCount: 0,
          completionRate: 0,
        );
  }
}
