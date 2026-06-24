import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/l10n/locale_controller.dart';
import 'package:lingo_cross_app/core/storage/token_storage.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/account/presentation/screens/language_preference_screen.dart';
import 'package:lingo_cross_app/features/auth/data/auth_repository.dart';
import 'package:lingo_cross_app/features/auth/data/login_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_auth_repository.dart';
import 'helpers/fake_secure_storage.dart';

const _delegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

/// Dil Tercihi ekranını gerçek [LocaleController] ile sarmalar. UI dilini
/// controller'ın state'i belirler; [MaterialApp]'in locale'i de buna bağlanır.
Widget _wrap(SharedPreferences prefs) {
  final storage = FakeSecureStorage({});
  final authRepo = FakeAuthRepository();
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      secureStorageProvider.overrideWithValue(storage),
      authRepositoryProvider.overrideWithValue(authRepo),
    ],
    child: const _App(),
  );
}

class _App extends ConsumerWidget {
  const _App();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: _delegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(localeControllerProvider),
      home: const LanguagePreferenceScreen(),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  testWidgets('İki dil aktif: Türkçe seçili (TR override), English seçilebilir',
      (tester) async {
    // Cihazda TR override → açılışta TR seçili.
    SharedPreferences.setMockInitialValues({'lc_ui_locale': 'tr'});
    prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(_wrap(prefs));
    await tester.pumpAndSettle();

    expect(find.text('Türkçe'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    // Seçili dil (TR) → dolu check ikonu; pasif (EN) → boş radio.
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);

    // "Yakında" rozeti artık YOK (iki dil de aktif).
    expect(find.text('Yakında'), findsNothing);
    // Info satırı + dekorasyon başlığı (TR).
    expect(find.text('Global Öğrenim Topluluğu'), findsOneWidget);
  });

  testWidgets('English seçince UI EN olur; tekrar Türkçe seçince TR döner',
      (tester) async {
    SharedPreferences.setMockInitialValues({'lc_ui_locale': 'tr'});
    prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(_wrap(prefs));
    await tester.pumpAndSettle();

    // Başlangıç TR.
    expect(find.text('Dil Tercihi'), findsOneWidget);

    // English satırına dokun → controller EN'e geçer.
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // Başlık artık EN ("Language Preference") ve "Global Learning Community".
    expect(find.text('Language Preference'), findsOneWidget);
    expect(find.text('Global Learning Community'), findsOneWidget);
    // Cihazda saklandı.
    expect(prefs.getString('lc_ui_locale'), 'en');

    // Geri TR'ye dön.
    await tester.tap(find.text('Türkçe'));
    await tester.pumpAndSettle();

    expect(find.text('Dil Tercihi'), findsOneWidget);
    expect(prefs.getString('lc_ui_locale'), 'tr');
  });
}
