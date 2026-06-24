import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/storage/token_storage.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/account/data/notification_prefs.dart';
import 'package:lingo_cross_app/features/account/presentation/screens/notification_settings_screen.dart';
import 'package:lingo_cross_app/features/auth/data/auth_repository.dart';
import 'package:lingo_cross_app/features/auth/data/login_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_auth_repository.dart';
import 'helpers/fake_secure_storage.dart';

Widget _wrap(SharedPreferences prefs) {
  final storage = FakeSecureStorage({
    'lc_access_token': 'access-x',
    'lc_refresh_token': 'refresh-x',
  });
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      secureStorageProvider.overrideWithValue(storage),
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('tr'),
      home: const NotificationSettingsScreen(),
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

  testWidgets('Stitch düzeni: ana anahtar + 3 grup + Sessiz Saatler',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 3600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrap(prefs));
    await tester.pumpAndSettle();

    expect(find.text('Bildirimler'), findsOneWidget);
    expect(find.text('ÖDEV & BULMACA'), findsOneWidget);
    expect(find.text('SONUÇLAR'), findsOneWidget);
    expect(find.text('GENEL'), findsOneWidget);
    expect(find.text('Yeni ödev/bulmaca atandığında'), findsOneWidget);
    expect(find.text('Duyurular ve güncellemeler'), findsOneWidget);
    expect(find.text('Sessiz Saatler'), findsOneWidget);
    expect(find.text('Şimdi Ayarla'), findsOneWidget);

    // Stitch varsayılanı: Duyurular kapalı, diğerleri açık (5 Switch).
    expect(find.byType(Switch), findsNWidgets(5));
  });

  testWidgets('Toggle değiştirmek tercihi cihazda saklar', (tester) async {
    tester.view.physicalSize = const Size(1080, 3600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrap(prefs));
    await tester.pumpAndSettle();

    // Başlangıç varsayılanı.
    expect(prefs.getBool(NotificationToggle.reminder.key), isNull);

    // "Ödev hatırlatması" anahtarını kapat.
    final reminderTile = find.ancestor(
      of: find.text('Ödev hatırlatması'),
      matching: find.byType(Row),
    );
    await tester.tap(find.descendant(of: reminderTile, matching: find.byType(Switch)).first);
    await tester.pumpAndSettle();

    expect(prefs.getBool(NotificationToggle.reminder.key), false);
  });

  testWidgets('Ana anahtar kapalıyken alt gruplar pasif (IgnorePointer)',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      NotificationToggle.master.key: false,
    });
    final p = await SharedPreferences.getInstance();

    tester.view.physicalSize = const Size(1080, 3600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrap(p));
    await tester.pumpAndSettle();

    // En az bir IgnorePointer aktif (ignoring: true).
    final ignorers = tester
        .widgetList<IgnorePointer>(find.byType(IgnorePointer))
        .where((w) => w.ignoring);
    expect(ignorers, isNotEmpty);
  });
}
