import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/classes_repository.dart';
import '../data/dtos/class_dtos.dart';

part 'my_classes_notifier.g.dart';

/// Öğrencinin katıldığı sınıfları yöneten async notifier
/// (`GET /api/classes/me`).
@riverpod
class MyClassesNotifier extends _$MyClassesNotifier {
  @override
  Future<List<ClassMembershipDto>> build() {
    return ref.watch(classesRepositoryProvider).listMemberships();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(classesRepositoryProvider).listMemberships(),
    );
  }
}
