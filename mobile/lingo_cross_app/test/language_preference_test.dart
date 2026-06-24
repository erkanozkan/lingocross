import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/account/presentation/screens/language_preference_screen.dart';

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
    home: const LanguagePreferenceScreen(),
  );
}

void main() {
  testWidgets('Türkçe seçili (check_circle); English pasif + "Yakında" rozeti',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.text('Türkçe'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    // Seçili dil için dolu check ikonu; pasif için boş radio.
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);

    // "Yakında" rozeti + info satırı + dekorasyon başlığı.
    expect(find.text('Yakında'), findsOneWidget);
    expect(find.text('Daha fazla dil yakında eklenecek.'), findsOneWidget);
    expect(find.text('Global Öğrenim Topluluğu'), findsOneWidget);
  });
}
