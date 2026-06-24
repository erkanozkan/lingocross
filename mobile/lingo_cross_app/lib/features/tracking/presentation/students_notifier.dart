import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/tracking_dtos.dart';
import '../data/tracking_repository.dart';

part 'students_notifier.g.dart';

/// Öğretmenin öğrenci özetleri (`GET /teachers/me/students`).
///
/// Ada göre alfabetik sıralı (repository sıralar). Boş/yükleniyor/hata
/// durumları ekranda `AsyncValue` üzerinden ele alınır.
@riverpod
class StudentsNotifier extends _$StudentsNotifier {
  @override
  Future<List<StudentSummaryDto>> build() async {
    final repo = ref.read(trackingRepositoryProvider);
    return repo.listStudents();
  }

  /// Listeyi yeniden yükler (pull-to-refresh / tekrar dene).
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(trackingRepositoryProvider);
      return repo.listStudents();
    });
  }
}
