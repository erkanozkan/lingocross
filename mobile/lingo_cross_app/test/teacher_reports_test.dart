import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/lessons/presentation/screens/teacher_reports_screen.dart';
import 'package:lingo_cross_app/features/tracking/data/tracking_repository.dart';
import 'package:lingo_cross_app/features/tracking/domain/tracking_failure.dart';

import 'helpers/fake_tracking_repository.dart';

Widget _wrap(FakeTrackingRepository repo) {
  final router = GoRouter(
    initialLocation: '/teacher/reports',
    routes: [
      GoRoute(
        path: '/teacher/reports',
        builder: (_, __) => const TeacherReportsScreen(),
      ),
      GoRoute(
        path: '/teacher/students/:id/results',
        builder: (_, state) =>
            Scaffold(body: Text('DETAY ${state.extra ?? ''}')),
      ),
    ],
  );
  return ProviderScope(
    overrides: [trackingRepositoryProvider.overrideWithValue(repo)],
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
  testWidgets('dolu liste: öğrenci kartı + sayım + ortalama % rozeti',
      (tester) async {
    final repo = FakeTrackingRepository(students: [
      sampleStudent(
        studentId: 's1',
        displayName: 'Ada Yılmaz',
        sharedResultsCount: 4,
        averageScore: 90,
      ),
    ]);
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Öğrenci Raporları'), findsOneWidget);
    expect(find.text('Ada Yılmaz'), findsOneWidget);
    expect(find.text('4 paylaşılan sonuç'), findsOneWidget);
    expect(find.text('%90'), findsOneWidget); // ortalama rozeti
  });

  testWidgets('ortalama yoksa "—" gösterilir', (tester) async {
    final repo = FakeTrackingRepository(students: [
      sampleStudent(
        displayName: 'Boş Öğrenci',
        sharedResultsCount: 0,
        averageScore: null,
        lastActivityAt: null,
      ),
    ]);
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('—'), findsOneWidget);
    expect(find.text('Son aktivite: henüz yok'), findsOneWidget);
  });

  testWidgets('boş liste: boş durum metni', (tester) async {
    final repo = FakeTrackingRepository(students: const []);
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Henüz paylaşılan sonuç yok'), findsOneWidget);
  });

  testWidgets('karta dokununca öğrenci detayına gider (ad extra ile)',
      (tester) async {
    final repo = FakeTrackingRepository(students: [
      sampleStudent(studentId: 's1', displayName: 'Ada'),
    ]);
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ada'));
    await tester.pumpAndSettle();

    expect(find.text('DETAY Ada'), findsOneWidget);
  });

  testWidgets('hata: tekrar dene çağrısı', (tester) async {
    final repo = FakeTrackingRepository(
      studentsError: const TrackingFailure.network(),
    );
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Öğrenciler yüklenemedi'), findsOneWidget);
    expect(find.text('Tekrar Dene'), findsOneWidget);
  });
}
