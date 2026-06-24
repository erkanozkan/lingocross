import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/storage/token_storage.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/auth/data/auth_repository.dart';
import 'package:lingo_cross_app/features/auth/domain/user_role.dart';
import 'package:lingo_cross_app/features/lessons/presentation/screens/teacher_profile_screen.dart';
import 'package:lingo_cross_app/features/profile/data/dtos/teacher_stats_dto.dart';
import 'package:lingo_cross_app/features/profile/data/teacher_stats_repository.dart';
import 'package:lingo_cross_app/features/profile/domain/profile_failure.dart';

import 'helpers/fake_auth_repository.dart';
import 'helpers/fake_secure_storage.dart';
import 'helpers/fake_teacher_stats_repository.dart';

Widget _wrap({
  required FakeTeacherStatsRepository statsRepo,
  required FakeAuthRepository authRepo,
}) {
  // Açılış geri-yükleme akışının kullanıcıyı authenticated yapması için depoda
  // token bulunmalı.
  final storage = FakeSecureStorage({
    'lc_access_token': 'access-x',
    'lc_refresh_token': 'refresh-x',
  });
  final router = GoRouter(
    initialLocation: '/teacher/profile',
    routes: [
      GoRoute(
        path: '/teacher/profile',
        builder: (_, __) => TeacherProfileScreen(
          onOpenClasses: () {},
          onOpenReports: () {},
        ),
      ),
      GoRoute(path: '/teacher/lessons', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/account/settings', builder: (_, __) => const Scaffold()),
    ],
  );
  return ProviderScope(
    overrides: [
      teacherStatsRepositoryProvider.overrideWithValue(statsRepo),
      authRepositoryProvider.overrideWithValue(authRepo),
      secureStorageProvider.overrideWithValue(storage),
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
  testWidgets('gerçek stats: sınıf/öğrenci sayısı + %katılım gösterir',
      (tester) async {
    final authRepo = FakeAuthRepository(
      user: sampleUser(displayName: 'Ayşe', role: UserRole.teacher),
    );
    final statsRepo = FakeTeacherStatsRepository(
      stats: const TeacherStatsDto(
        classCount: 3,
        studentCount: 18,
        weeklyAssignedCount: 10,
        weeklyCompletedCount: 7,
        completionRate: 70,
      ),
    );
    await tester.pumpWidget(_wrap(statsRepo: statsRepo, authRepo: authRepo));
    await tester.pumpAndSettle();

    expect(find.text('Ayşe'), findsOneWidget);
    expect(find.text('Öğretmen'), findsOneWidget);
    // Sınıf = 3, Öğrenci = 18, Katılım = %70.
    expect(find.text('3'), findsOneWidget);
    expect(find.text('18'), findsOneWidget);
    expect(find.text('%70'), findsOneWidget);
    expect(statsRepo.fetchCount, 1);
  });

  testWidgets('haftalık ödev: completed/assigned ilerleme + metin',
      (tester) async {
    final statsRepo = FakeTeacherStatsRepository(
      stats: const TeacherStatsDto(
        classCount: 1,
        studentCount: 4,
        weeklyAssignedCount: 8,
        weeklyCompletedCount: 5,
        completionRate: 62,
      ),
    );
    await tester.pumpWidget(_wrap(
      statsRepo: statsRepo,
      authRepo: FakeAuthRepository(user: sampleUser(role: UserRole.teacher)),
    ));
    await tester.pumpAndSettle();

    expect(find.text('5/8 ödev tamamlandı'), findsOneWidget);
    final progress = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(progress.value, closeTo(5 / 8, 0.0001));
    expect(find.text('Bu hafta atanmış ödev yok.'), findsNothing);
  });

  testWidgets('atanmış ödev yoksa nazik boş metin + ilerleme çubuğu yok',
      (tester) async {
    final statsRepo = FakeTeacherStatsRepository(
      stats: const TeacherStatsDto(
        classCount: 1,
        studentCount: 4,
        weeklyAssignedCount: 0,
        weeklyCompletedCount: 0,
        completionRate: 0,
      ),
    );
    await tester.pumpWidget(_wrap(
      statsRepo: statsRepo,
      authRepo: FakeAuthRepository(user: sampleUser(role: UserRole.teacher)),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Bu hafta atanmış ödev yok.'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('stats hatası: "—" + tekrar dene', (tester) async {
    final statsRepo = FakeTeacherStatsRepository(
      error: const ProfileFailure.network(),
    );
    await tester.pumpWidget(_wrap(
      statsRepo: statsRepo,
      authRepo: FakeAuthRepository(user: sampleUser(role: UserRole.teacher)),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Tekrar Dene'), findsOneWidget);
    // 3 stat kartı hata durumunda "—" gösterir.
    expect(find.text('—'), findsNWidgets(3));
  });

  testWidgets('"Çıkış Yap" gerçek logout() çağırır', (tester) async {
    final authRepo = FakeAuthRepository(user: sampleUser(role: UserRole.teacher));
    final statsRepo = FakeTeacherStatsRepository(
      stats: const TeacherStatsDto(
        classCount: 1,
        studentCount: 1,
        weeklyAssignedCount: 1,
        weeklyCompletedCount: 1,
        completionRate: 100,
      ),
    );
    await tester.pumpWidget(_wrap(statsRepo: statsRepo, authRepo: authRepo));
    await tester.pumpAndSettle();

    final logout = find.text('Çıkış Yap');
    await tester.scrollUntilVisible(logout, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(logout);
    await tester.pumpAndSettle();

    expect(authRepo.logoutCount, 1);
  });
}
