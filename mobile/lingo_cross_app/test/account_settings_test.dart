import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/storage/token_storage.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/account/presentation/screens/account_settings_screen.dart';
import 'package:lingo_cross_app/features/auth/data/auth_repository.dart';
import 'package:lingo_cross_app/features/auth/data/login_prefs.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_auth_repository.dart';
import 'helpers/fake_secure_storage.dart';

const _localizationDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

/// Hesap Ayarları + alt route'lar için bir go_router (push hedefini doğrular).
Widget _wrap(FakeAuthRepository authRepo, SharedPreferences prefs) {
  final storage = FakeSecureStorage({
    'lc_access_token': 'access-x',
    'lc_refresh_token': 'refresh-x',
  });
  final router = GoRouter(
    initialLocation: '/account/settings',
    routes: [
      GoRoute(
        path: '/account/settings',
        builder: (context, state) => const AccountSettingsScreen(),
      ),
      // Alt ekranlar yerine hafif probe sayfaları — yalnız hedef route'u doğrular.
      for (final r in const [
        ('/account/notifications', 'PROBE_NOTIFICATIONS'),
        ('/account/language', 'PROBE_LANGUAGE'),
        ('/account/help', 'PROBE_HELP'),
        ('/account/privacy', 'PROBE_PRIVACY'),
      ])
        GoRoute(
          path: r.$1,
          builder: (context, state) => Scaffold(
            appBar: AppBar(),
            body: Text(r.$2),
          ),
        ),
    ],
  );
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepo),
      secureStorageProvider.overrideWithValue(storage),
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: _localizationDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('tr'),
      routerConfig: router,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    PackageInfo.setMockInitialValues(
      appName: 'LingoCross',
      packageName: 'com.lingocross.app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  testWidgets('Stitch düzeni: profil başlığı + 3 grup + Çıkış Yap', (tester) async {
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final authRepo = FakeAuthRepository(
      user: sampleUser(displayName: 'Ada Lovelace', email: 'ada@ornek.com'),
    );
    await tester.pumpWidget(_wrap(authRepo, prefs));
    await tester.pumpAndSettle();

    expect(find.text('Hesap Ayarları'), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('ada@ornek.com'), findsOneWidget);
    expect(find.text('Profili Düzenle'), findsOneWidget);

    expect(find.text('GENEL'), findsOneWidget);
    expect(find.text('GÜVENLİK'), findsOneWidget);
    expect(find.text('DESTEK & HAKKIMIZDA'), findsOneWidget);

    expect(find.text('Bildirim Ayarları'), findsOneWidget);
    expect(find.text('Dil Tercihi'), findsOneWidget);
    expect(find.text('Türkçe'), findsOneWidget);
    expect(find.text('Şifre Değiştir'), findsOneWidget);
    // Tema ve İki Faktörlü Doğrulama kaldırıldı (kullanıcı isteği).
    expect(find.text('Tema'), findsNothing);
    expect(find.text('İki Faktörlü Doğrulama'), findsNothing);
    expect(find.text('Çıkış Yap'), findsOneWidget);
  });

  testWidgets('4 satır gerçek route push eder', (tester) async {
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final authRepo = FakeAuthRepository();
    await tester.pumpWidget(_wrap(authRepo, prefs));
    await tester.pumpAndSettle();

    // Bildirim Ayarları → /account/notifications.
    await tester.tap(find.text('Bildirim Ayarları'));
    await tester.pumpAndSettle();
    expect(find.text('PROBE_NOTIFICATIONS'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Dil Tercihi → /account/language.
    await tester.tap(find.text('Dil Tercihi'));
    await tester.pumpAndSettle();
    expect(find.text('PROBE_LANGUAGE'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Yardım Merkezi → /account/help.
    await tester.tap(find.text('Yardım Merkezi'));
    await tester.pumpAndSettle();
    expect(find.text('PROBE_HELP'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Gizlilik Politikası → /account/privacy.
    await tester.tap(find.text('Gizlilik Politikası'));
    await tester.pumpAndSettle();
    expect(find.text('PROBE_PRIVACY'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
  });

  testWidgets('Çıkış Yap → gerçek logout', (tester) async {
    final authRepo = FakeAuthRepository();
    await tester.pumpWidget(_wrap(authRepo, prefs));
    await tester.pumpAndSettle();

    final logout = find.text('Çıkış Yap');
    await tester.scrollUntilVisible(logout, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(logout);
    await tester.pumpAndSettle();

    expect(authRepo.logoutCount, 1);
  });
}
