import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/storage/token_storage.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/core/widgets/primary_button_3d.dart';
import 'package:lingo_cross_app/features/auth/data/login_prefs.dart';
import 'package:lingo_cross_app/features/auth/presentation/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_secure_storage.dart';

/// Birleşik karşılama + giriş ekranı testleri. Eski `welcome_screen_test`
/// yerini alır: hero (karşılama) + giriş formu + kayıt CTA aynı ekrandadır.
GoRouter _router({
  void Function(String location)? onRoute,
}) {
  Widget stub(String name) => Scaffold(body: Text(name));
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          onRoute?.call(state.uri.toString());
          return stub('REGISTER');
        },
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) {
          onRoute?.call(state.uri.toString());
          return stub('FORGOT');
        },
      ),
    ],
  );
}

Widget _wrap(GoRouter router, SharedPreferences prefs) {
  return ProviderScope(
    overrides: [
      secureStorageProvider.overrideWithValue(FakeSecureStorage()),
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('tr'),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  testWidgets('Birleşik ekran hero + giriş formunu birlikte gösterir',
      (tester) async {
    await tester.pumpWidget(_wrap(_router(), prefs));
    await tester.pumpAndSettle();

    // Hero (karşılama).
    expect(find.text("LingoCross'a Hoş Geldiniz"), findsOneWidget);
    // Giriş formu alanları.
    expect(find.text('E-posta Adresi'), findsOneWidget);
    expect(find.text('Şifre'), findsOneWidget);
    expect(find.text('Şifremi Unuttum?'), findsOneWidget);
    // Üst marka "LingoCross" (redundant giriş linki yok).
    expect(find.text('LingoCross'), findsOneWidget);
    // Submit butonu.
    expect(find.widgetWithText(PrimaryButton3D, 'Giriş Yap'), findsOneWidget);
    // Kayıt CTA.
    expect(find.textContaining('Hesabın yok mu?'), findsOneWidget);
    expect(find.text('Ücretsiz kayıt ol'), findsOneWidget);
  });

  testWidgets('Rol kartları ve sosyal giriş gösterilmez', (tester) async {
    await tester.pumpWidget(_wrap(_router(), prefs));
    await tester.pumpAndSettle();

    // Welcome rol kartları kaldırıldı.
    expect(find.text('Öğrenci Olarak Kaydol'), findsNothing);
    expect(find.text('Eğitmen Olarak Kaydol'), findsNothing);
    // OAuth ayracı / sosyal butonlar yok.
    expect(find.textContaining('VEYA'), findsNothing);
    expect(find.text('Google'), findsNothing);
    expect(find.text('Apple'), findsNothing);
  });

  testWidgets('"Ücretsiz kayıt ol" → /register (rolsüz)', (tester) async {
    String? last;
    await tester.pumpWidget(_wrap(_router(onRoute: (l) => last = l), prefs));
    await tester.pumpAndSettle();

    final cta = find.text('Ücretsiz kayıt ol');
    await tester.ensureVisible(cta);
    await tester.pumpAndSettle();
    await tester.tap(cta);
    await tester.pumpAndSettle();

    expect(find.text('REGISTER'), findsOneWidget);
    expect(last, '/register');
  });

  testWidgets('"Şifremi Unuttum?" → /forgot-password', (tester) async {
    String? last;
    await tester.pumpWidget(_wrap(_router(onRoute: (l) => last = l), prefs));
    await tester.pumpAndSettle();

    final link = find.text('Şifremi Unuttum?');
    await tester.ensureVisible(link);
    await tester.pumpAndSettle();
    await tester.tap(link);
    await tester.pumpAndSettle();

    expect(find.text('FORGOT'), findsOneWidget);
    expect(last, '/forgot-password');
  });
}
