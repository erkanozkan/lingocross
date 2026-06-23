import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/storage/token_storage.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/auth/domain/user_role.dart';
import 'package:lingo_cross_app/features/auth/presentation/screens/login_screen.dart';

import 'helpers/fake_secure_storage.dart';

void main() {
  group('UserRole eşlemesi (API int 1/2)', () {
    test('teacher=1, student=2', () {
      expect(UserRole.teacher.value, 1);
      expect(UserRole.student.value, 2);
      expect(UserRole.fromValue(1), UserRole.teacher);
      expect(UserRole.fromValue(2), UserRole.student);
    });
  });

  testWidgets('Boş form submit edilince e-posta/şifre hataları gösterilir',
      (tester) async {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(
            path: '/forgot-password', builder: (_, __) => const Scaffold()),
        GoRoute(path: '/register', builder: (_, __) => const Scaffold()),
        GoRoute(path: '/home', builder: (_, __) => const Scaffold()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
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
      ),
    );
    await tester.pumpAndSettle();

    // Boş formda "Giriş Yap" butonuna bas.
    await tester.tap(find.text('Giriş Yap'));
    await tester.pumpAndSettle();

    expect(find.text('E-posta adresi gerekli.'), findsOneWidget);
    expect(find.text('Şifre gerekli.'), findsOneWidget);
  });
}
