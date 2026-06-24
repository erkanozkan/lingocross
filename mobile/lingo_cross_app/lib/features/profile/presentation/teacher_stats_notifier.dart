import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/teacher_stats_dto.dart';
import '../data/teacher_stats_repository.dart';

part 'teacher_stats_notifier.g.dart';

/// Öğretmen profil istatistikleri (`GET /teachers/me/stats`).
///
/// Yükleniyor/hata/veri durumları ekranda `AsyncValue` ile ele alınır.
@riverpod
class TeacherStatsNotifier extends _$TeacherStatsNotifier {
  @override
  Future<TeacherStatsDto> build() async {
    final repo = ref.read(teacherStatsRepositoryProvider);
    return repo.fetchMyStats();
  }

  /// İstatistikleri yeniden yükler (tekrar dene).
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(teacherStatsRepositoryProvider);
      return repo.fetchMyStats();
    });
  }
}
