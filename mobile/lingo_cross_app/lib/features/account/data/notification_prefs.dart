import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/data/login_prefs.dart';

/// Bildirim Ayarları toggle anahtarları (cihaz-içi tercih).
enum NotificationToggle {
  /// Ana anahtar — kapalıyken alt satırlar pasif.
  master('lc_notif_master'),

  /// ÖDEV & BULMACA: yeni ödev/bulmaca atandığında.
  assigned('lc_notif_assigned'),

  /// ÖDEV & BULMACA: ödev hatırlatması.
  reminder('lc_notif_reminder'),

  /// SONUÇLAR: öğrenci/öğretmen sonuç bildirimi.
  results('lc_notif_results'),

  /// GENEL: duyurular ve güncellemeler.
  announcements('lc_notif_announcements');

  const NotificationToggle(this.key);

  final String key;

  /// Varsayılan değer (Stitch'te "Duyurular" hariç hepsi açık).
  bool get defaultValue => this != NotificationToggle.announcements;
}

/// Bildirim tercihlerini `shared_preferences` ile cihazda saklar.
///
/// Push altyapısı YOK (F7.4'te gelecek) — şimdilik yalnız tercih kaydı.
class NotificationPrefs {
  const NotificationPrefs(this._prefs);

  final SharedPreferences _prefs;

  /// Bir anahtarın güncel değeri (yoksa Stitch varsayılanı).
  bool read(NotificationToggle toggle) =>
      _prefs.getBool(toggle.key) ?? toggle.defaultValue;

  /// Tüm anahtarların güncel değerleri.
  Map<NotificationToggle, bool> readAll() => {
        for (final t in NotificationToggle.values) t: read(t),
      };

  /// Bir anahtarı kaydeder.
  Future<void> write(NotificationToggle toggle, bool value) =>
      _prefs.setBool(toggle.key, value);
}

final notificationPrefsProvider = Provider<NotificationPrefs>((ref) {
  return NotificationPrefs(ref.watch(sharedPreferencesProvider));
});
