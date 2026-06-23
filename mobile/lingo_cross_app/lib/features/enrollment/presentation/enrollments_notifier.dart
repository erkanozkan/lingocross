import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/enrollment_dtos.dart';
import '../data/enrollment_repository.dart';

part 'enrollments_notifier.g.dart';

/// Oturum açan kullanıcının eşleşmelerini yöneten async notifier
/// (`GET /api/enrollments`). Öğrenci dalında counterpart = öğretmen.
///
/// Yalnız **Active** eşleşmeler ürün açısından anlamlıdır (doğrudan-Active
/// kararı). [activeTeacherIds] / [teacherNameById] türetilmiş yardımcılarla
/// öğrenci panelinde ders ↔ öğretmen adı eşlemesi yapılır.
@riverpod
class EnrollmentsNotifier extends _$EnrollmentsNotifier {
  @override
  Future<List<EnrollmentDto>> build() {
    return ref.watch(enrollmentRepositoryProvider).listMine();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(enrollmentRepositoryProvider).listMine(),
    );
  }
}
