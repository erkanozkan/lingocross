import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../account/data/notification_prefs.dart';
import '../data/dtos/notification_preferences_dto.dart';
import '../data/notification_prefs_repository.dart';

part 'notification_prefs_notifier.g.dart';

/// Bildirim tercihleri (`GET|PUT /api/me/notification-preferences`).
///
/// Açılışta GET ile yükler; bir toggle değiştiğinde iyimser (optimistic)
/// günceller ve PUT eder. PUT başarısız olursa eski değere geri döner ve
/// hatayı yukarı fırlatır (ekran SnackBar gösterir). Yükleniyor/hata/veri
/// durumları ekranda `AsyncValue` ile ele alınır.
@riverpod
class NotificationPrefsNotifier extends _$NotificationPrefsNotifier {
  @override
  Future<NotificationPreferencesDto> build() async {
    final repo = ref.read(notificationPrefsRepositoryProvider);
    return repo.fetch();
  }

  /// Tercihleri yeniden yükler (tekrar dene).
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(notificationPrefsRepositoryProvider);
      return repo.fetch();
    });
  }

  /// Tek bir anahtarı değiştirir. İyimser güncelleme + PUT; hata olursa eski
  /// değere döner ve istisnayı yeniden fırlatır.
  Future<void> setToggle(NotificationToggle toggle, bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.withToggle(toggle, value);
    // İyimser: UI hemen yansısın.
    state = AsyncValue.data(updated);

    try {
      final repo = ref.read(notificationPrefsRepositoryProvider);
      final saved = await repo.update(updated);
      state = AsyncValue.data(saved);
    } catch (e) {
      // Geri al ve hatayı ekrana taşı.
      state = AsyncValue.data(current);
      rethrow;
    }
  }
}
