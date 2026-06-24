import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/results/data/dtos/result_dtos.dart';
import 'package:lingo_cross_app/features/results/data/results_repository.dart';
import 'package:lingo_cross_app/features/results/presentation/screens/game_result_report_screen.dart';

import 'helpers/fake_results_repository.dart';

Widget _wrap({
  required GameResultDto seed,
  required FakeResultsRepository repo,
}) {
  final router = GoRouter(
    initialLocation: '/report',
    routes: [
      GoRoute(
        path: '/report',
        builder: (_, __) => GameResultReportScreen(
          resultId: seed.id,
          seedResult: seed,
        ),
      ),
      GoRoute(path: '/student', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/student/results', builder: (_, __) => const Scaffold()),
      GoRoute(
          path: '/student/games/:gameId',
          builder: (_, state) =>
              Scaffold(body: Text('OYUN ${state.pathParameters['gameId']}'))),
      GoRoute(path: '/profile', builder: (_, __) => const Scaffold()),
    ],
  );
  return ProviderScope(
    overrides: [
      resultsRepositoryProvider.overrideWithValue(repo),
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

/// Rapor içeriği uzundur (radyal + bento + iki buton); test yüzeyini büyüt ki
/// alttaki aksiyon butonları lazy ListView'da inşa edilsin.
void _tallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('skor/süre/doğru-toplam ve idle paylaş butonu gösterilir',
      (tester) async {
    _tallSurface(tester);
    final seed = sampleResult(
      score: 85,
      durationMs: 252000, // 04:12
      totalItems: 20,
      correctItems: 17,
    );
    await tester.pumpWidget(
      _wrap(seed: seed, repo: FakeResultsRepository()),
    );
    await tester.pump(); // seed (post-frame)
    await tester.pump();

    expect(find.text('Oyun Özeti'), findsOneWidget);
    expect(find.text('%85'), findsOneWidget); // doğruluk radyali
    expect(find.text('04:12'), findsOneWidget); // geçen süre
    expect(find.text('17 / 20'), findsOneWidget); // bulunan kelime
    expect(find.text('Öğretmene Gönder'), findsOneWidget);
    expect(find.text('Tekrar Oyna'), findsOneWidget);
  });

  testWidgets('"Tekrar Oyna" → launcher\'a gameId ile gider (lessonId değil)',
      (tester) async {
    _tallSurface(tester);
    // gameId=g1, lessonId=l1 (ayrı). Route gameId beklediği için g1 ile
    // gidilmeli; lessonId geçilirse StartSession 404 döner (regresyon).
    final seed = sampleResult(lessonId: 'l1');
    await tester.pumpWidget(
      _wrap(seed: seed, repo: FakeResultsRepository()),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Tekrar Oyna'));
    await tester.pumpAndSettle();

    expect(find.text('OYUN g1'), findsOneWidget);
    expect(find.text('OYUN l1'), findsNothing);
  });

  testWidgets('paylaş → "Öğretmene Gönderildi" (tek-yön kilit) + share çağrısı',
      (tester) async {
    _tallSurface(tester);
    final seed = sampleResult(id: 'r5', sharedWithTeacher: false);
    final repo = FakeResultsRepository(mine: [seed]);
    await tester.pumpWidget(_wrap(seed: seed, repo: repo));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Öğretmene Gönder'));
    await tester.pump(); // sending
    await tester.pumpAndSettle(); // share resolves + toast

    expect(repo.shareCount, 1);
    expect(find.text('Öğretmene Gönderildi'), findsOneWidget);
    expect(find.text('Öğretmene Gönder'), findsNothing);

    // Tek-yön kilit: tekrar dokunma yeni istek üretmez.
    await tester.tap(find.text('Öğretmene Gönderildi'));
    await tester.pump();
    expect(repo.shareCount, 1);
  });

  testWidgets('zaten paylaşılmış sonuç doğrudan "Gönderildi" render edilir',
      (tester) async {
    _tallSurface(tester);
    final seed = sampleResult(id: 'r6', sharedWithTeacher: true);
    await tester.pumpWidget(
      _wrap(seed: seed, repo: FakeResultsRepository()),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Öğretmene Gönderildi'), findsOneWidget);
  });
}
