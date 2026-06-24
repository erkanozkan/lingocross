import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/tracking_dtos.dart';
import '../data/tracking_repository.dart';

part 'student_result_detail_notifier.g.dart';

/// Bir öğrencinin tek bir sonucunun kelime-bazlı detayı (F7.5)
/// (`GET /teachers/me/students/{studentId}/results/{resultId}`).
///
/// `studentId` + `resultId` ile parametrelendirilir. Boş/yükleniyor/hata
/// durumları ekranda `AsyncValue` ile ele alınır.
@riverpod
class StudentResultDetailNotifier extends _$StudentResultDetailNotifier {
  @override
  Future<StudentResultDetailDto> build(String studentId, String resultId) async {
    final repo = ref.read(trackingRepositoryProvider);
    return repo.getStudentResultDetail(studentId, resultId);
  }

  /// Detayı yeniden yükler (tekrar dene).
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(trackingRepositoryProvider);
      return repo.getStudentResultDetail(studentId, resultId);
    });
  }
}
