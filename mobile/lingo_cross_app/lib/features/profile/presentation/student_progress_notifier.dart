import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/student_progress_dto.dart';
import '../data/student_stats_repository.dart';

part 'student_progress_notifier.g.dart';

/// Öğrenci gelişim özeti (`GET /students/me/progress`).
///
/// Öğrenci panelindeki "Gelişim Özeti" bentosunu besler. Yükleniyor/hata/veri
/// durumları ekranda `AsyncValue` ile ele alınır; pull-to-refresh ile [refresh].
@riverpod
class StudentProgressNotifier extends _$StudentProgressNotifier {
  @override
  Future<StudentProgressDto> build() async {
    final repo = ref.read(studentStatsRepositoryProvider);
    return repo.getMyProgress();
  }

  /// Gelişim özetini yeniden yükler (tekrar dene / pull-to-refresh).
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(studentStatsRepositoryProvider);
      return repo.getMyProgress();
    });
  }
}
