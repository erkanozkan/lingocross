import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/classes_repository.dart';
import '../data/dtos/class_dtos.dart';

part 'class_detail_notifier.g.dart';

/// Bir sınıfın detayını (öğrenci listesi dâhil) yöneten async notifier
/// (`GET /api/classes/{id}`), classId'ye göre family.
@riverpod
class ClassDetailNotifier extends _$ClassDetailNotifier {
  @override
  Future<ClassDetailDto> build(String classId) {
    return ref.watch(classesRepositoryProvider).detail(classId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(classesRepositoryProvider).detail(classId),
    );
  }

  /// Bir öğrenciyi sınıftan çıkarır; başarıda listeyi yeniler ve true döner.
  Future<bool> removeStudent(String studentId) async {
    final result = await AsyncValue.guard(() async {
      await ref.read(classesRepositoryProvider).removeStudent(classId, studentId);
      return ref.read(classesRepositoryProvider).detail(classId);
    });
    if (result.hasValue) {
      state = AsyncValue.data(result.value!);
      return true;
    }
    return false;
  }
}
