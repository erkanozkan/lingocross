import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Giriş ekranı "Beni Hatırla" tercihi.
///
/// Yalnız **e-posta** ve **checkbox tercihi** saklanır — ŞİFRE ASLA SAKLANMAZ.
/// "Beni Hatırla" kapatılırsa kayıtlı e-posta da temizlenir.
class LoginPrefs {
  const LoginPrefs(this._prefs);

  final SharedPreferences _prefs;

  static const String _rememberKey = 'lc_login_remember';
  static const String _emailKey = 'lc_login_email';

  /// "Beni Hatırla" tercihi (varsayılan AÇIK).
  bool get rememberMe => _prefs.getBool(_rememberKey) ?? true;

  /// Hatırlanan e-posta (yoksa boş).
  String get savedEmail => _prefs.getString(_emailKey) ?? '';

  /// Başarılı login sonrası tercihi kaydeder. [remember] kapalıysa e-posta
  /// temizlenir; açıksa verilen e-posta saklanır.
  Future<void> save({required bool remember, required String email}) async {
    await _prefs.setBool(_rememberKey, remember);
    if (remember) {
      await _prefs.setString(_emailKey, email);
    } else {
      await _prefs.remove(_emailKey);
    }
  }
}

/// SharedPreferences örneğini açar (uygulama başında [ProviderScope]
/// override'ı ile gerçek örnek sağlanır; bkz. main.dart).
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider main.dart içinde override edilmeli.',
  );
});

final loginPrefsProvider = Provider<LoginPrefs>((ref) {
  return LoginPrefs(ref.watch(sharedPreferencesProvider));
});
