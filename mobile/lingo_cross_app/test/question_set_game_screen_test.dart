import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/presentation/screens/question_set_game_screen.dart';
import 'package:lingo_cross_app/features/results/data/results_repository.dart';
import 'package:lingo_cross_app/features/results/domain/results_failure.dart';

import 'helpers/fake_results_repository.dart';

const _content = QuestionSetContent(
  questions: [
    QuestionItem(
      questionId: 'q1',
      stem: 'Birinci soru kökü?',
      choices: [
        QuestionChoice(optionId: 'q1a', label: 'A', text: 'Şık A bir'),
        QuestionChoice(optionId: 'q1b', label: 'B', text: 'Şık B bir'),
      ],
      correctOptionId: 'q1a',
    ),
    QuestionItem(
      questionId: 'q2',
      stem: 'İkinci soru kökü?',
      choices: [
        QuestionChoice(optionId: 'q2a', label: 'A', text: 'Şık A iki'),
        QuestionChoice(optionId: 'q2b', label: 'B', text: 'Şık B iki'),
      ],
      correctOptionId: 'q2b',
    ),
  ],
);

Widget _wrap({FakeResultsRepository? resultsRepo}) {
  final router = GoRouter(
    initialLocation: '/game',
    routes: [
      GoRoute(
        path: '/game',
        builder: (_, __) =>
            const QuestionSetGameScreen(sessionId: 's1', content: _content),
      ),
      GoRoute(path: '/student', builder: (_, __) => const Scaffold()),
      GoRoute(
        path: '/student/results/:resultId',
        builder: (_, __) => const Scaffold(body: Text('RAPOR EKRANI')),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      resultsRepositoryProvider
          .overrideWithValue(resultsRepo ?? FakeResultsRepository()),
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
  testWidgets(
      'başlangıçta başlık + ilk soru + Soru 1/2 + süre + Önceki/Sonraki Soru',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    // Başlık birden çok kez geçebilir (header başlık + alt başlık aynı metin).
    expect(find.text('Çıkmış Sorular'), findsWidgets); // başlık/alt başlık
    expect(find.text('Birinci soru kökü?'), findsOneWidget);
    expect(find.text('Soru 1 / 2'), findsOneWidget); // ilerleme göstergesi
    expect(find.text('Süre 00:00'), findsOneWidget); // geçen süre (count-up)
    expect(find.text('Önceki'), findsOneWidget);
    expect(find.text('Sonraki Soru'), findsOneWidget); // son soru değil
    expect(find.text('Bitir'), findsNothing); // son soruda değiliz
  });

  testWidgets('şık seç → kart seçili işaretlenir (doğruluk gizli)',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    await tester.tap(find.text('Şık A bir'));
    await tester.pump();

    // Seçim semantics ile yansır; tamamlanma overlay'i görünmez.
    expect(find.text('Tebrikler!'), findsNothing); // tamamlanmadı
    expect(find.text('Soru 1 / 2'), findsOneWidget);
  });

  testWidgets('şık seç → Bitir → submit çağrısı + rapora geçiş', (tester) async {
    final repo = FakeResultsRepository(
      submitResultValue: sampleResult(
        id: 'r9',
        sessionId: 's1',
        totalItems: 2,
        correctItems: 1,
        score: 50,
      ),
    );
    await tester.pumpWidget(_wrap(resultsRepo: repo));
    await tester.pump();

    // 1. soruyu doğru işaretle (q1a), 2. soruyu boş bırak.
    await tester.tap(find.text('Şık A bir'));
    await tester.pump();

    // Son soruya geç → "Bitir" görünür.
    await tester.tap(find.text('Sonraki Soru'));
    await tester.pump();
    expect(find.text('Bitir'), findsOneWidget);

    await tester.tap(find.text('Bitir'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(repo.submitCount, 1);
    expect(repo.lastTotalItems, 2);
    expect(repo.lastCorrectItems, 1); // yalnız 1. soru doğru
    expect(find.text('RAPOR EKRANI'), findsOneWidget);
  });

  testWidgets('Sonraki Soru ile gezinme: ikinci (son) soru gösterilir',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    await tester.tap(find.text('Sonraki Soru'));
    await tester.pump();

    expect(find.text('İkinci soru kökü?'), findsOneWidget);
    expect(find.text('Soru 2 / 2'), findsOneWidget);
    expect(find.text('Bitir'), findsOneWidget); // son soruda Bitir
    expect(find.text('Sonraki Soru'), findsNothing);
  });

  testWidgets('sonuç gönderimi hatasında "Tekrar Dene" gösterilir',
      (tester) async {
    final repo =
        FakeResultsRepository(submitError: const ResultsFailure.network());
    await tester.pumpWidget(_wrap(resultsRepo: repo));
    await tester.pump();

    await tester.tap(find.text('Şık A bir'));
    await tester.pump();
    await tester.tap(find.text('Sonraki Soru')); // son soruya geç
    await tester.pump();
    await tester.tap(find.text('Bitir'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(repo.submitCount, 1);
    expect(find.text('Tekrar Dene'), findsOneWidget);
    expect(find.text('RAPOR EKRANI'), findsNothing);
  });
}
