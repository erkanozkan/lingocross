import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/enrollment_dtos.dart';
import '../data/enrollment_repository.dart';

part 'invite_code_notifier.g.dart';

/// Öğretmenin davet kodunu yöneten async notifier
/// (`GET /api/teachers/me/invite-code`). [regenerate] yeni kod üretir
/// (`POST .../regenerate`) ve state'i günceller.
@riverpod
class InviteCodeNotifier extends _$InviteCodeNotifier {
  @override
  Future<InviteCodeDto> build() {
    return ref.watch(enrollmentRepositoryProvider).getInviteCode();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(enrollmentRepositoryProvider).getInviteCode(),
    );
  }

  /// Yeni davet kodu üretir. Başarıda true; hata olursa eski kod korunur.
  Future<bool> regenerate() async {
    final result = await AsyncValue.guard(
      () => ref.read(enrollmentRepositoryProvider).regenerateInviteCode(),
    );
    if (result.hasValue) {
      state = AsyncValue.data(result.value!);
      return true;
    }
    return false;
  }
}
