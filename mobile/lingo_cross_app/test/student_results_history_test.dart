import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/results/data/results_repository.dart';
import 'package:lingo_cross_app/features/results/presentation/screens/student_results_history_screen.dart';

import 'helpers/fake_results_repository.dart';

Widget _wrap(FakeResultsRepository repo) {
  final router = GoRouter(
    initialLocation: '/student/results',
    routes: [
      GoRoute(
        path: '/student/results',
        builder: (_, __) => const StudentResultsHistoryScreen(),
      ),
      GoRoute(path: '/student', builder: (_, __) => const Scaffold()),
      GoRoute(
        path: '/student/results/:resultId',
        builder: (_, __) => const Scaffold(body: Text('RAPOR DETAY')),
      ),
      GoRoute(path: '/profile', builder: (_, __) => const Scaffold()),
    ],
  );
  return ProviderScope(
    overrides: [resultsRepositoryProvider.overrideWithValue(repo)],
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
  testWidgets('dolu liste: özet + sonuç kartı + paylaşıldı rozeti', (tester) async {
    final repo = FakeResultsRepository(mine: [
      sampleResult(
        id: 'r1',
        lessonTitle: 'Ünite 3',
        score: 90,
        correctItems: 18,
        totalItems: 20,
        sharedWithTeacher: true,
      ),
      sampleResult(
        id: 'r2',
        lessonTitle: 'Ünite 4',
        score: 70,
        correctItems: 14,
        totalItems: 20,
      ),
    ]);
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Sonuçlarım'), findsOneWidget);
    expect(find.text('Toplam Oyun'), findsOneWidget);
    expect(find.text('2'), findsOneWidget); // toplam oyun
    expect(find.text('%80'), findsOneWidget); // ort doğruluk (90+70)/2
    expect(find.text('Ünite 3'), findsOneWidget);
    expect(find.text('Ünite 4'), findsOneWidget);
    expect(find.text('Gönderildi'), findsOneWidget); // yalnız paylaşılan kartta
  });

  testWidgets('satıra dokununca rapor detayına gider', (tester) async {
    final repo = FakeResultsRepository(mine: [
      sampleResult(id: 'r1', lessonTitle: 'Ünite 3'),
    ]);
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ünite 3'));
    await tester.pumpAndSettle();

    expect(find.text('RAPOR DETAY'), findsOneWidget);
  });

  testWidgets('boş durum: "Henüz oyun oynamadın" + CTA', (tester) async {
    final repo = FakeResultsRepository(mine: const []);
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Henüz oyun oynamadın'), findsOneWidget);
    expect(find.text('Oyuna Başla'), findsOneWidget);
  });
}
