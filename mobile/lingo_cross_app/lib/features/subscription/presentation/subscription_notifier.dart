import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/presentation/auth_notifier.dart';
import '../../auth/presentation/auth_state.dart';
import '../data/dtos/subscription_dtos.dart';
import '../data/subscription_repository.dart';
import '../domain/subscription_enums.dart';

part 'subscription_notifier.g.dart';

/// Kullanıcının abonelik/entitlement durumunu yöneten async notifier.
///
/// - Açılışta: oturum açıksa `getMine()` ile yüklenir; değilse boş Free durumu.
/// - Auth state izlenir: login olunca yüklenir, logout olunca Free'ye temizlenir.
/// - [refresh] yeniden çeker; [activate]/[cancelStub] sonrası kendini tazeler.
///
/// `keepAlive`: oturum boyunca tek örnek; gated ekranlar bunu izler.
@Riverpod(keepAlive: true)
class SubscriptionNotifier extends _$SubscriptionNotifier {
  SubscriptionRepository get _repository =>
      ref.read(subscriptionRepositoryProvider);

  @override
  Future<SubscriptionDto> build() {
    // Auth durumunu izle: login → yükle, logout → Free'ye temizle.
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      final wasAuth = previous?.isAuthenticated ?? false;
      final isAuth = next.isAuthenticated;
      if (isAuth && !wasAuth) {
        refresh();
      } else if (!isAuth && wasAuth) {
        state = const AsyncValue<SubscriptionDto>.data(_free);
      }
    });

    final current = ref.read(authNotifierProvider);
    if (!current.isAuthenticated) {
      return Future.value(_free);
    }
    return _repository.getMine();
  }

  /// Durumu yeniden çeker (`GET /api/subscription/me`). Oturum yoksa Free.
  Future<void> refresh() async {
    final auth = ref.read(authNotifierProvider);
    if (!auth.isAuthenticated) {
      state = const AsyncValue<SubscriptionDto>.data(_free);
      return;
    }
    state = const AsyncValue<SubscriptionDto>.loading();
    state = await AsyncValue.guard(() => _repository.getMine());
  }

  /// Stub satın alma yapar (`POST /api/subscription/activate`) ve başarıda
  /// dönen Premium durumu state'e yazar. Hata yukarı fırlatılır (sunum yakalar).
  Future<void> activate(ActivateStubRequest request) async {
    final result = await _repository.activateStub(request);
    state = AsyncValue<SubscriptionDto>.data(result);
  }

  /// Aboneliği iptal eder (`POST /api/subscription/cancel`) ve dönen durumu
  /// state'e yazar. Hata yukarı fırlatılır.
  Future<void> cancelStub() async {
    final result = await _repository.cancel();
    state = AsyncValue<SubscriptionDto>.data(result);
  }

  /// Oturum yokken / logout sonrası kullanılan ücretsiz (Free) varsayılan durum.
  static const SubscriptionDto _free = SubscriptionDto(
    plan: SubscriptionPlan.none,
    status: SubscriptionStatus.none,
    period: SubscriptionPeriod.none,
    isPremium: false,
    // Backend SubscriptionOptions varsayılanlarıyla hizalı (FreeMaxClasses=2,
    // FreeMaxLessons=5, FreeMaxTeachers=1); canlı değer GET /subscription/me'den gelir.
    maxClasses: 2,
    maxLessons: 5,
    maxTeachers: 1,
    ocrEnabled: false,
  );
}
