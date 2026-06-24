import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/storage/token_storage.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/account/presentation/screens/account_settings_screen.dart';
import 'package:lingo_cross_app/features/auth/data/auth_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'helpers/fake_auth_repository.dart';
import 'helpers/fake_secure_storage.dart';

Widget _wrap(FakeAuthRepository authRepo) {
  final storage = FakeSecureStorage({
    'lc_access_token': 'access-x',
    'lc_refresh_token': 'refresh-x',
  });
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepo),
      secureStorageProvider.overrideWithValue(storage),
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
      home: const AccountSettingsScreen(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Sürüm satırı için package_info platform kanalını mock'la.
    PackageInfo.setMockInitialValues(
      appName: 'LingoCross',
      packageName: 'com.lingocross.app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  testWidgets('Stitch düzeni: profil başlığı + 3 grup + Çıkış Yap', (tester) async {
    // Listenin tamamı (3 grup + çıkış) tek ekrana sığsın diye yüksek yüzey.
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final authRepo = FakeAuthRepository(
      user: sampleUser(displayName: 'Ada Lovelace', email: 'ada@ornek.com'),
    );
    await tester.pumpWidget(_wrap(authRepo));
    await tester.pumpAndSettle();

    // Başlık + profil başlığı.
    expect(find.text('Hesap Ayarları'), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('ada@ornek.com'), findsOneWidget);
    expect(find.text('Profili Düzenle'), findsOneWidget);

    // Grup başlıkları (uppercase).
    expect(find.text('GENEL'), findsOneWidget);
    expect(find.text('GÜVENLİK'), findsOneWidget);
    expect(find.text('DESTEK & HAKKIMIZDA'), findsOneWidget);

    // GENEL satırları + GÜVENLİK satırları.
    expect(find.text('Bildirim Ayarları'), findsOneWidget);
    expect(find.text('Dil Tercihi'), findsOneWidget);
    expect(find.text('Türkçe'), findsOneWidget);
    expect(find.text('Tema'), findsOneWidget);
    expect(find.text('Şifre Değiştir'), findsOneWidget);
    expect(find.text('İki Faktörlü Doğrulama'), findsOneWidget);
    expect(find.text('Çıkış Yap'), findsOneWidget);
  });

  testWidgets('Placeholder satır → "Yakında"; Çıkış Yap → gerçek logout',
      (tester) async {
    final authRepo = FakeAuthRepository();
    await tester.pumpWidget(_wrap(authRepo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bildirim Ayarları'));
    await tester.pump();
    expect(find.text('Yakında'), findsWidgets);

    final logout = find.text('Çıkış Yap');
    await tester.scrollUntilVisible(logout, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(logout);
    await tester.pumpAndSettle();

    expect(authRepo.logoutCount, 1);
  });
}
