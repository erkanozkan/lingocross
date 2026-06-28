import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/account/presentation/screens/privacy_policy_screen.dart';

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
    home: const PrivacyPolicyScreen(),
  );
}

void main() {
  testWidgets('Tüm 6 bölüm + son güncelleme + iletişim render olur',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 5200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.textContaining('Son güncelleme'), findsOneWidget);
    expect(find.text('1. Topladığımız Bilgiler'), findsOneWidget);
    expect(find.text('2. Bilgileri Nasıl Kullanırız'), findsOneWidget);
    expect(find.text('3. Veri Saklama ve Güvenlik'), findsOneWidget);
    expect(find.text('4. Üçüncü Taraf Hizmetler'), findsOneWidget);
    expect(find.text('5. Haklarınız'), findsOneWidget);
    expect(find.text('6. İletişim'), findsOneWidget);
    expect(find.textContaining('@duocross.com'), findsOneWidget);
  });
}
