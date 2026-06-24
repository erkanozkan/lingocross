import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/presentation/screens/word_matching_game_screen.dart';
import 'package:lingo_cross_app/features/results/data/results_repository.dart';
import 'package:lingo_cross_app/features/results/domain/results_failure.dart';

import 'helpers/fake_results_repository.dart';

const _content = WordMatchingContent(
  pairs: [
    MatchingPair(wordId: 'w1', term: 'apple', correctTranslation: 'elma'),
    MatchingPair(wordId: 'w2', term: 'book', correctTranslation: 'kitap'),
  ],
  distractors: ['yolculuk'],
);

Widget _wrap({FakeResultsRepository? resultsRepo}) {
  final router = GoRouter(
    initialLocation: '/game',
    routes: [
      GoRoute(
        path: '/game',
        builder: (_, __) => const WordMatchingGameScreen(
          sessionId: 's1',
          content: _content,
        ),
      ),
      GoRoute(path: '/student', builder: (_, __) => const Scaffold()),
      GoRoute(
        path: '/student/results/:resultId',
        builder: (_, __) =>
            const Scaffold(body: Text('RAPOR EKRANI')),
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

/// Serbest eşleştirme: bir terim + bir karşılık seçer (doğruluk gösterilmez).
Future<void> _match(
  WidgetTester tester,
  String term,
  String translation,
) async {
  await tester.tap(find.text(term));
  await tester.pump();
  await tester.tap(find.text(translation));
  await tester.pump();
}

void main() {
  testWidgets('başlangıçta sütun başlıkları + sayaç 0/2 + Bitir/Vazgeç görünür',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(find.text('İNGİLİZCE'), findsOneWidget);
    expect(find.text('TÜRKÇE'), findsOneWidget);
    expect(find.text('0 / 2'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('Vazgeç'), findsOneWidget);
    // "Bitir" her zaman görünür; "İpucu" gösterilmez.
    expect(find.text('Bitir'), findsOneWidget);
    expect(find.text('İpucu'), findsNothing);
  });

  testWidgets('serbest eşleştirme doğruluğu oyun sırasında göstermez', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    // Bilerek yanlış eşleştir (apple ↔ kitap) — yine de ilerleme artar,
    // doğru/yanlış geri bildirimi yok.
    await _match(tester, 'apple', 'kitap');
    await tester.pump();

    expect(find.text('1 / 2'), findsOneWidget);
    expect(find.text('Tebrikler!'), findsNothing);
  });

  testWidgets(
      'Bitir → bir doğru + bir yanlış eşleştirme: correct=1/total=2, rapora geçer',
      (tester) async {
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

    // apple ↔ elma (doğru), book ↔ yolculuk (yanlış — çeldirici).
    await _match(tester, 'apple', 'elma');
    await _match(tester, 'book', 'yolculuk');
    expect(find.text('2 / 2'), findsOneWidget); // iki eşleştirme yapıldı

    await tester.tap(find.text('Bitir'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(repo.submitCount, 1);
    expect(repo.lastTotalItems, 2);
    expect(repo.lastCorrectItems, 1); // yalnız apple↔elma doğru
    expect(find.text('RAPOR EKRANI'), findsOneWidget);
  });

  testWidgets('Bitir boş bırakılan çiftlerle de çalışır (hepsi yanlış sayılır)',
      (tester) async {
    final repo = FakeResultsRepository(
      submitResultValue: sampleResult(
        id: 'r0',
        sessionId: 's1',
        totalItems: 2,
        correctItems: 0,
        score: 0,
      ),
    );
    await tester.pumpWidget(_wrap(resultsRepo: repo));
    await tester.pump();

    // Hiç eşleştirmeden Bitir.
    await tester.tap(find.text('Bitir'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(repo.submitCount, 1);
    expect(repo.lastTotalItems, 2);
    expect(repo.lastCorrectItems, 0);
    expect(find.text('RAPOR EKRANI'), findsOneWidget);
  });

  testWidgets('sonuç gönderimi hatasında "Tekrar Dene" gösterilir',
      (tester) async {
    final repo = FakeResultsRepository(submitError: const ResultsFailure.network());
    await tester.pumpWidget(_wrap(resultsRepo: repo));
    await tester.pump();

    await _match(tester, 'apple', 'elma');
    await _match(tester, 'book', 'kitap');
    await tester.tap(find.text('Bitir'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(repo.submitCount, 1);
    expect(find.text('Sonuç kaydedilemedi, tekrar dene.'), findsOneWidget);
    expect(find.text('Tekrar Dene'), findsOneWidget);
    expect(find.text('RAPOR EKRANI'), findsNothing);
  });
}
