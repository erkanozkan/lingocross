import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/classes_repository.dart';
import '../data/dtos/class_dtos.dart';

part 'class_invite_code_notifier.g.dart';

/// Bir sınıfın davet kodunu yöneten async notifier
/// (`GET /api/classes/{id}/invite-code`), classId'ye göre family.
/// [regenerate] yeni kod üretir ve state'i günceller.
@riverpod
class ClassInviteCodeNotifier extends _$ClassInviteCodeNotifier {
  @override
  Future<ClassInviteCodeDto> build(String classId) {
    return ref.watch(classesRepositoryProvider).getInviteCode(classId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(classesRepositoryProvider).getInviteCode(classId),
    );
  }

  /// Yeni davet kodu üretir. Başarıda true; hata olursa eski kod korunur.
  Future<bool> regenerate() async {
    final result = await AsyncValue.guard(
      () => ref.read(classesRepositoryProvider).regenerateInviteCode(classId),
    );
    if (result.hasValue) {
      state = AsyncValue.data(result.value!);
      return true;
    }
    return false;
  }
}
