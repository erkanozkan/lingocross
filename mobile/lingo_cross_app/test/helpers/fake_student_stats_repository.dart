import 'package:lingo_cross_app/features/profile/data/dtos/student_stats_dto.dart';
import 'package:lingo_cross_app/features/profile/data/student_stats_repository.dart';
import 'package:lingo_cross_app/features/profile/domain/profile_failure.dart';

/// Testlerde gerçek Dio yerine kullanılan sahte öğrenci istatistik repository.
class FakeStudentStatsRepository implements StudentStatsRepository {
  FakeStudentStatsRepository({this.stats, this.error});

  final StudentStatsDto? stats;
  final ProfileFailure? error;

  int fetchCount = 0;

  @override
  Future<StudentStatsDto> fetchMyStats() async {
    fetchCount++;
    if (error != null) throw error!;
    return stats ?? const StudentStatsDto(gamesPlayed: 0, averageAccuracy: 0);
  }
}
