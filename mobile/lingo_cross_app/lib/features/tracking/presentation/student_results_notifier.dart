import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/tracking_dtos.dart';
import '../data/tracking_repository.dart';

part 'student_results_notifier.g.dart';

/// Bir öğrencinin öğretmenle paylaştığı sonuçlar
/// (`GET /teachers/me/students/{studentId}/results`).
///
/// `studentId` ile parametrelendirilir. En yeni → en eski sıralı (repository
/// sıralar). Boş/yükleniyor/hata durumları ekranda `AsyncValue` ile ele alınır.
@riverpod
class StudentResultsNotifier extends _$StudentResultsNotifier {
  @override
  Future<List<SharedResultDto>> build(String studentId) async {
    final repo = ref.read(trackingRepositoryProvider);
    return repo.listStudentResults(studentId);
  }

  /// Listeyi yeniden yükler (pull-to-refresh / tekrar dene).
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(trackingRepositoryProvider);
      return repo.listStudentResults(studentId);
    });
  }
}
