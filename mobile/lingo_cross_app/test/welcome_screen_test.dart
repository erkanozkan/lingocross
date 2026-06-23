import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/storage/token_storage.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/auth/presentation/screens/welcome_screen.dart';

import 'helpers/fake_secure_storage.dart';

Widget _wrap(Widget child, GoRouter router) {
  return ProviderScope(
    overrides: [
      secureStorageProvider.overrideWithValue(FakeSecureStorage()),
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
  testWidgets('Welcome ekranı başlık ve iki rol kartını gösterir',
      (tester) async {
    final router = GoRouter(
      initialLocation: '/welcome',
      routes: [
        GoRoute(
            path: '/welcome', builder: (_, __) => const WelcomeScreen()),
        GoRoute(path: '/login', builder: (_, __) => const Scaffold()),
        GoRoute(path: '/register', builder: (_, __) => const Scaffold()),
        GoRoute(
            path: '/forgot-password', builder: (_, __) => const Scaffold()),
      ],
    );

    await tester.pumpWidget(_wrap(const WelcomeScreen(), router));
    await tester.pumpAndSettle();

    expect(find.text("LingoCross'a Hoş Geldiniz"), findsOneWidget);
    expect(find.text('Öğrenci Girişi'), findsOneWidget);
    expect(find.text('Eğitmen Girişi'), findsOneWidget);
    expect(find.text('Şifremi Unuttum'), findsOneWidget);
    expect(find.text('Hesap Oluştur'), findsOneWidget);
  });

  testWidgets('Öğrenci kartına dokununca /login?role=student rotasına gider',
      (tester) async {
    String? lastLocation;
    final router = GoRouter(
      initialLocation: '/welcome',
      routes: [
        GoRoute(
            path: '/welcome', builder: (_, __) => const WelcomeScreen()),
        GoRoute(
          path: '/login',
          builder: (context, state) {
            lastLocation = state.uri.toString();
            return const Scaffold(body: Text('LOGIN'));
          },
        ),
        GoRoute(path: '/register', builder: (_, __) => const Scaffold()),
        GoRoute(
            path: '/forgot-password', builder: (_, __) => const Scaffold()),
      ],
    );

    await tester.pumpWidget(_wrap(const WelcomeScreen(), router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Öğrenci Girişi'));
    await tester.pumpAndSettle();

    expect(find.text('LOGIN'), findsOneWidget);
    expect(lastLocation, '/login?role=student');
  });
}
