import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/core/widgets/error_banner.dart';
import 'package:lingo_cross_app/core/widgets/primary_button_3d.dart';
import 'package:lingo_cross_app/features/auth/data/auth_repository.dart';
import 'package:lingo_cross_app/features/auth/domain/auth_failure.dart';
import 'package:lingo_cross_app/features/auth/presentation/screens/reset_password_screen.dart';

import 'helpers/fake_auth_repository.dart';

const _email = 'ada@ornek.com';

const _localizationDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

/// Reset ekranı + login probe sayfası için go_router (başarıda /login hedefini
/// doğrular).
Widget _wrap(FakeAuthRepository authRepo) {
  final router = GoRouter(
    initialLocation: '/reset',
    routes: [
      GoRoute(
        path: '/reset',
        builder: (context, state) => const ResetPasswordScreen(email: _email),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const Scaffold(body: Text('LOGIN_PROBE')),
      ),
    ],
  );
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(authRepo)],
    child: MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: _localizationDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('tr'),
      routerConfig: router,
    ),
  );
}

/// Kod + iki şifre alanını sırayla doldurur (label sırasına göre).
Future<void> _fill(
  WidgetTester tester, {
  required String code,
  required String password,
  required String confirm,
}) async {
  await tester.enterText(find.byType(TextField).at(0), code);
  await tester.enterText(find.byType(TextField).at(1), password);
  await tester.enterText(find.byType(TextField).at(2), confirm);
}

/// Submit (3D buton) — başlıkla aynı metni taşıdığı için widget tipinden bulunur.
Future<void> _tapSubmit(WidgetTester tester) async {
  final button = find.byType(PrimaryButton3D);
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Açıklamada e-posta gösterilir + 3 alan + buton', (tester) async {
    await tester.pumpWidget(_wrap(FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.textContaining(_email), findsOneWidget);
    expect(find.text('Doğrulama Kodu'), findsOneWidget);
    expect(find.text('Yeni Şifre'), findsOneWidget);
    expect(find.text('Yeni Şifre (Tekrar)'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
  });

  testWidgets('Geçerli giriş → resetPassword doğru argümanlarla + /login',
      (tester) async {
    final repo = FakeAuthRepository();
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    await _fill(tester,
        code: '123456', password: 'sifre1234', confirm: 'sifre1234');
    await _tapSubmit(tester);

    expect(repo.resetPasswordCount, 1);
    expect(repo.lastResetEmail, _email);
    expect(repo.lastResetCode, '123456');
    expect(repo.lastResetNewPassword, 'sifre1234');
    expect(find.text('LOGIN_PROBE'), findsOneWidget);
  });

  testWidgets('Kod 6 rakam değilse → validasyon hatası, çağrı yok',
      (tester) async {
    final repo = FakeAuthRepository();
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    await _fill(tester,
        code: '123', password: 'sifre1234', confirm: 'sifre1234');
    await _tapSubmit(tester);

    expect(find.text('Kod 6 rakam olmalı.'), findsOneWidget);
    expect(repo.resetPasswordCount, 0);
  });

  testWidgets('Şifreler eşleşmiyorsa → validasyon hatası, çağrı yok',
      (tester) async {
    final repo = FakeAuthRepository();
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    await _fill(tester,
        code: '123456', password: 'sifre1234', confirm: 'baska9999');
    await _tapSubmit(tester);

    expect(find.text('Şifreler eşleşmiyor.'), findsOneWidget);
    expect(repo.resetPasswordCount, 0);
  });

  testWidgets('400 (kod hatalı) → ErrorBanner backend mesajıyla, login yok',
      (tester) async {
    final repo = FakeAuthRepository()
      ..resetPasswordError =
          const AuthFailure.resetCodeInvalid(message: 'Kodun süresi dolmuş.');
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    await _fill(tester,
        code: '123456', password: 'sifre1234', confirm: 'sifre1234');
    await _tapSubmit(tester);

    expect(find.byType(ErrorBanner), findsOneWidget);
    expect(find.text('Kodun süresi dolmuş.'), findsOneWidget);
    expect(find.text('LOGIN_PROBE'), findsNothing);
  });

  testWidgets('400 mesajsız → genel "kod hatalı" metni', (tester) async {
    final repo = FakeAuthRepository()
      ..resetPasswordError = const AuthFailure.resetCodeInvalid();
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    await _fill(tester,
        code: '123456', password: 'sifre1234', confirm: 'sifre1234');
    await _tapSubmit(tester);

    expect(find.byType(ErrorBanner), findsOneWidget);
    expect(
        find.text('Kod hatalı veya süresi dolmuş. Lütfen tekrar deneyin.'),
        findsOneWidget);
  });

  testWidgets('"Tekrar gönder" → forgotPassword(email) + cooldown',
      (tester) async {
    final repo = FakeAuthRepository();
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    final resend = find.textContaining('Tekrar gönder');
    await tester.ensureVisible(resend);
    await tester.tap(resend);
    await tester.pump();

    expect(repo.forgotPasswordCount, 1);
    expect(repo.lastForgotEmail, _email);
    // Cooldown başladı → etikette sayaç görünür.
    await tester.pump();
    expect(find.textContaining('(30)'), findsOneWidget);
  });
}
