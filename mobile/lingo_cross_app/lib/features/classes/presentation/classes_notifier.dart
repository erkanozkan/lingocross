import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/classes_repository.dart';
import '../data/dtos/class_dtos.dart';

part 'classes_notifier.g.dart';

/// Öğretmenin sınıf listesini yöneten async notifier (`GET /api/classes`).
@riverpod
class ClassesNotifier extends _$ClassesNotifier {
  @override
  Future<List<ClassDto>> build() {
    return ref.watch(classesRepositoryProvider).listMine();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(classesRepositoryProvider).listMine(),
    );
  }
}
