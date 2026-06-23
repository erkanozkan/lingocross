import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/storage/token_storage.dart';
import '../data/auth_repository.dart';
import '../domain/user_role.dart';
import 'auth_state.dart';

part 'auth_notifier.g.dart';

/// Oturum state'ini yöneten Riverpod 2.x notifier (codegen).
///
/// - Açılışta secure storage'da token varsa `authenticated` kabul edilir
///   (kullanıcı bilgisi token yenileme/`/me` ile M2'de zenginleştirilebilir).
/// - login/register başarıda token'lar saklanır, state `authenticated` olur.
/// - 401 refresh kalıcı başarısız olursa (SessionEvents) state
///   `unauthenticated`'a düşer ve router giriş ekranına yönlendirir.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    final sessionEvents = ref.watch(sessionEventsProvider);
    void onExpired() => _onSessionExpired();
    sessionEvents.addListener(onExpired);
    ref.onDispose(() => sessionEvents.removeListener(onExpired));

    // Açılış kontrolü asenkron; ilk durum `unknown`.
    _restore();
    return const AuthState();
  }

  TokenStorage get _storage => ref.read(tokenStorageProvider);
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> _restore() async {
    final access = await _storage.readAccessToken();
    if (access != null && access.isNotEmpty) {
      state = state.copyWith(status: AuthStatus.authenticated);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  void _onSessionExpired() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Giriş. Başarıda state `authenticated` olur. Hata yukarı fırlatılır
  /// (sunum katmanı yakalar — bkz. AuthFailure).
  Future<void> login({required String email, required String password}) async {
    final res = await _repository.login(email: email, password: password);
    await _storage.saveTokens(
      accessToken: res.accessToken,
      refreshToken: res.refreshToken,
    );
    state = AuthState(status: AuthStatus.authenticated, user: res.user);
  }

  /// Kayıt. API token döndürdüğü için başarıda otomatik login.
  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    final res = await _repository.register(
      email: email,
      password: password,
      displayName: displayName,
      role: role,
    );
    await _storage.saveTokens(
      accessToken: res.accessToken,
      refreshToken: res.refreshToken,
    );
    state = AuthState(status: AuthStatus.authenticated, user: res.user);
  }

  Future<void> logout() async {
    final refresh = await _storage.readRefreshToken();
    if (refresh != null && refresh.isNotEmpty) {
      await _repository.logout(refreshToken: refresh);
    }
    await _storage.clear();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
