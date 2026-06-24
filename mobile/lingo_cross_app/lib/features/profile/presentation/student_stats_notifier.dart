import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/student_stats_dto.dart';
import '../data/student_stats_repository.dart';

part 'student_stats_notifier.g.dart';

/// Öğrenci profil istatistikleri (`GET /students/me/stats`).
///
/// Yükleniyor/hata/veri durumları ekranda `AsyncValue` ile ele alınır.
@riverpod
class StudentStatsNotifier extends _$StudentStatsNotifier {
  @override
  Future<StudentStatsDto> build() async {
    final repo = ref.read(studentStatsRepositoryProvider);
    return repo.fetchMyStats();
  }

  /// İstatistikleri yeniden yükler (tekrar dene).
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(studentStatsRepositoryProvider);
      return repo.fetchMyStats();
    });
  }
}
