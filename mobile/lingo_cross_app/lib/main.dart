import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/l10n/gen/app_localizations.dart';
import 'core/l10n/locale_controller.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_messenger.dart';
import 'features/auth/data/login_prefs.dart';
import 'features/notifications/presentation/push_notification_service.dart';

/// Arka plan (uygulama kapalı/arka planda) push mesaj işleyicisi.
///
/// Üst seviye + `@pragma('vm:entry-point')` olmalı (ayrı isolate'te çalışır).
/// Sistem bildirimi OS tarafından gösterilir; burada ek iş yapılmaz.
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  // İçerik gerekiyorsa burada işlenir; şu an no-op.
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Push yalnızca iOS'ta etkin (GoogleService-Info.plist'ten otomatik okunur;
  // firebase_options.dart gerekmez). Android'de google-services.json olmadığı
  // için Firebase.initializeApp() fırlatır ve açılışta çökerdi → iOS-only guard.
  if (Platform.isIOS) {
    await Firebase.initializeApp();
    // Arka plan push işleyicisini kaydet.
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  }

  // SharedPreferences senkron erişim için açılışta yüklenir; loginPrefsProvider
  // bunu override edilen sharedPreferencesProvider üzerinden okur.
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const LingoCrossApp(),
    ),
  );
}

class LingoCrossApp extends ConsumerWidget {
  const LingoCrossApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    // Push servisini canlı tut: oturum durumunu dinleyip token kaydı/temizliği
    // yapar (auth state'e bağlı). keepAlive olduğundan tek sefer başlatılır.
    ref.read(pushNotificationServiceProvider.notifier).ensureInitialized();

    return MaterialApp.router(
      title: 'LingoCross',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      scaffoldMessengerKey: appMessengerKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(localeControllerProvider),
    );
  }
}
