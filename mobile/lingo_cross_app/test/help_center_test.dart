import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/account/presentation/screens/help_center_screen.dart';

Widget _wrap() {
  return MaterialApp(
    theme: AppTheme.light,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('tr'),
    home: const HelpCenterScreen(),
  );
}

void main() {
  const q1 = 'Nasıl sınıf oluştururum?';
  const a1Fragment = 'Sınıflarım';

  testWidgets('SSS akordiyonu dokununca cevap açılır', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.text('Sıkça Sorulan Sorular'), findsOneWidget);
    expect(find.text(q1), findsOneWidget);
    // Cevap başlangıçta gizli (CrossFade firstChild boş).
    expect(find.textContaining(a1Fragment), findsNothing);

    await tester.tap(find.text(q1));
    await tester.pumpAndSettle();

    expect(find.textContaining(a1Fragment), findsOneWidget);
  });

  testWidgets('Arama SSS listesini yerel olarak filtreler', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    // Tüm 6 soru görünür.
    expect(find.text(q1), findsOneWidget);
    expect(find.text('Şifremi unuttum, ne yapmalıyım?'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'şifre');
    await tester.pumpAndSettle();

    // Yalnız şifre sorusu kalır.
    expect(find.text('Şifremi unuttum, ne yapmalıyım?'), findsOneWidget);
    expect(find.text(q1), findsNothing);
  });

  testWidgets('İletişim kartı + "Bize Ulaşın" butonu görünür', (tester) async {
    tester.view.physicalSize = const Size(1080, 3600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.text('Hâlâ yardıma mı ihtiyacın var?'), findsOneWidget);
    expect(find.text('Bize Ulaşın'), findsOneWidget);
  });
}
