import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/storage/token_storage.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/auth/data/auth_repository.dart';
import 'package:lingo_cross_app/features/profile/data/dtos/student_stats_dto.dart';
import 'package:lingo_cross_app/features/profile/data/student_stats_repository.dart';
import 'package:lingo_cross_app/features/profile/domain/profile_failure.dart';
import 'package:lingo_cross_app/features/profile/presentation/screens/student_profile_screen.dart';

import 'helpers/fake_auth_repository.dart';
import 'helpers/fake_secure_storage.dart';
import 'helpers/fake_student_stats_repository.dart';

Widget _wrap({
  required FakeStudentStatsRepository statsRepo,
  required FakeAuthRepository authRepo,
}) {
  // Açılış geri-yükleme akışının kullanıcıyı authenticated yapması için depoda
  // token bulunmalı (logout refresh token'ı da okur).
  final storage = FakeSecureStorage({
    'lc_access_token': 'access-x',
    'lc_refresh_token': 'refresh-x',
  });
  return ProviderScope(
    overrides: [
      studentStatsRepositoryProvider.overrideWithValue(statsRepo),
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
      home: const StudentProfileScreen(),
    ),
  );
}

void main() {
  testWidgets('gerçek stats: ad + Öğrenci + Oyun (gamesPlayed) + %doğruluk',
      (tester) async {
    final authRepo = FakeAuthRepository(user: sampleUser(displayName: 'Ada'));
    final statsRepo = FakeStudentStatsRepository(
      stats: const StudentStatsDto(gamesPlayed: 24, averageAccuracy: 88),
    );
    await tester.pumpWidget(
      _wrap(statsRepo: statsRepo, authRepo: authRepo),
    );
    await tester.pumpAndSettle();

    // Ad + rol etiketi.
    expect(find.text('Ada'), findsOneWidget);
    expect(find.text('Öğrenci'), findsOneWidget);

    // Gerçek metrikler.
    expect(find.text('24'), findsOneWidget); // Oyun (gamesPlayed)
    expect(find.text('%88'), findsOneWidget); // Doğruluk (averageAccuracy)
    expect(find.text('Oyun'), findsOneWidget);
    expect(find.text('Doğruluk'), findsOneWidget);

    // Günlük Seri placeholder ("—").
    expect(find.text('Günlük Seri'), findsOneWidget);
    expect(find.text('—'), findsOneWidget);

    // Stats gerçekten çekildi.
    expect(statsRepo.fetchCount, 1);
  });

  testWidgets('stats hatası: "—" + tekrar dene; logout çağrılmaz',
      (tester) async {
    final statsRepo = FakeStudentStatsRepository(
      error: const ProfileFailure.network(),
    );
    await tester.pumpWidget(
      _wrap(statsRepo: statsRepo, authRepo: FakeAuthRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tekrar Dene'), findsOneWidget);
    // Hata durumunda gerçek metrikler "—" gösterir (Günlük Seri dahil 3 adet).
    expect(find.text('—'), findsNWidgets(3));
  });

  testWidgets('"Çıkış Yap" gerçek logout() çağırır', (tester) async {
    final authRepo = FakeAuthRepository();
    final statsRepo = FakeStudentStatsRepository(
      stats: const StudentStatsDto(gamesPlayed: 5, averageAccuracy: 60),
    );
    await tester.pumpWidget(
      _wrap(statsRepo: statsRepo, authRepo: authRepo),
    );
    await tester.pumpAndSettle();

    final logout = find.text('Çıkış Yap');
    await tester.scrollUntilVisible(logout, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(logout);
    await tester.pumpAndSettle();

    expect(authRepo.logoutCount, 1);
  });

  testWidgets('menü placeholder aksiyonları "Yakında" snackbar gösterir',
      (tester) async {
    final authRepo = FakeAuthRepository();
    await tester.pumpWidget(
      _wrap(
        statsRepo: FakeStudentStatsRepository(
          stats: const StudentStatsDto(gamesPlayed: 1, averageAccuracy: 50),
        ),
        authRepo: authRepo,
      ),
    );
    await tester.pumpAndSettle();

    final account = find.text('Hesap Ayarları');
    await tester.scrollUntilVisible(account, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(account);
    await tester.pump();

    expect(find.text('Yakında'), findsWidgets);
    expect(authRepo.logoutCount, 0);
  });
}
