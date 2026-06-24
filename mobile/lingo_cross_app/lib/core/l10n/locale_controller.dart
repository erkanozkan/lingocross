import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/data/login_prefs.dart';
import '../../features/auth/presentation/auth_notifier.dart';

part 'locale_controller.g.dart';

/// Uygulamanın desteklediği UI dilleri (kodları). Yalnız bu setteki diller
/// geçerlidir; başka cihaz dili `en`e düşer.
const Set<String> kSupportedLocaleCodes = {'tr', 'en'};

/// Cihaz dili / saklı tercih → desteklenen bir [Locale]'e çözer.
///
/// Sıra: 1) `lc_ui_locale` saklı override, 2) backend `preferredLocale`
/// (override yoksa referans), 3) cihaz dili, 4) `en` fallback. `tr`/`en`
/// dışındaki tüm cihaz dilleri `en`e map edilir.
Locale resolveInitialLocale({
  String? storedOverride,
  String? backendLocale,
  Locale? deviceLocale,
}) {
  // 1) Cihazda saklı açık seçim her zaman önceliklidir.
  final stored = _normalize(storedOverride);
  if (stored != null) return Locale(stored);

  // 2) Backend tercihi (override yoksa ilk senkron referans).
  final backend = _normalize(backendLocale);
  if (backend != null) return Locale(backend);

  // 3) Cihaz dili (yalnız tr/en korunur; diğerleri → en).
  final device = deviceLocale?.languageCode.toLowerCase();
  if (device != null && kSupportedLocaleCodes.contains(device)) {
    return Locale(device);
  }

  // 4) Fallback.
  return const Locale('en');
}

/// Verilen kod desteklenen bir dile aitse normalize edip döndürür; değilse
/// `null` (çağıran fallback'e geçer).
String? _normalize(String? code) {
  if (code == null) return null;
  final lower = code.toLowerCase();
  // "en-US" gibi bölge ekleri için yalnız dil kodunu al.
  final lang = lower.split(RegExp('[-_]')).first;
  return kSupportedLocaleCodes.contains(lang) ? lang : null;
}

/// Aktif UI [Locale]'ini tutan controller (Riverpod 2.x codegen, keepAlive).
///
/// Açılışta cihaz dili / saklı override / backend tercihine göre çözülür;
/// kullanıcı Dil Tercihi ekranından değiştirir. Seçim cihazda (shared_prefs)
/// saklanır + best-effort backend'e yazılır.
@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  static const String _storageKey = 'lc_ui_locale';

  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_storageKey);

    // Backend tercihi yalnız override yokken referans alınır (cihaz seçimi esas).
    String? backendLocale;
    final authState = ref.watch(authNotifierProvider);
    backendLocale = authState.user?.preferredLocale;

    return resolveInitialLocale(
      storedOverride: stored,
      backendLocale: backendLocale,
      deviceLocale: WidgetsBinding.instance.platformDispatcher.locale,
    );
  }

  /// UI dilini değiştirir: state + cihazda saklama + best-effort backend yazımı.
  Future<void> setLocale(Locale locale) async {
    final code = locale.languageCode.toLowerCase();
    if (!kSupportedLocaleCodes.contains(code)) return;

    state = Locale(code);

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_storageKey, code);

    // Best-effort backend senkron (oturum açıksa). Hata yutulur — cihaz seçimi
    // her hâlükârda geçerli kalır.
    try {
      await ref.read(authNotifierProvider.notifier).setPreferredLocale(code);
    } catch (e) {
      debugPrint('LocaleController: backend preferredLocale yazımı atlandı: $e');
    }
  }
}
