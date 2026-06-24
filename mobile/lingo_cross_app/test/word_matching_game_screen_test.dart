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

Future<void> _matchPair(
  WidgetTester tester,
  String term,
  String translation,
) async {
  await tester.tap(find.text(term));
  await tester.pump();
  await tester.tap(find.text(translation));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  testWidgets('başlangıçta sütun başlıkları + sayaç 0/2 + timer görünür',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(find.text('İNGİLİZCE'), findsOneWidget);
    expect(find.text('TÜRKÇE'), findsOneWidget);
    expect(find.text('0 / 2'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);
    // M4: "İpucu" gösterilmez, "Vazgeç" var.
    expect(find.text('Vazgeç'), findsOneWidget);
    expect(find.text('İpucu'), findsNothing);
  });

  testWidgets('yanlış eşleşme ilerlemeyi artırmaz', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    // apple seçili + yanlış (kitap = book'un çevirisi).
    await _matchPair(tester, 'apple', 'kitap');
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('0 / 2'), findsOneWidget);
    expect(find.text('Tebrikler!'), findsNothing);
  });

  testWidgets(
      'tüm çiftler eşleşince sonuç gönderilir (correct=total) ve rapora geçer',
      (tester) async {
    final repo = FakeResultsRepository(
      submitResultValue: sampleResult(
        id: 'r9',
        sessionId: 's1',
        totalItems: 2,
        correctItems: 2,
        score: 100,
      ),
    );
    await tester.pumpWidget(_wrap(resultsRepo: repo));
    await tester.pump();

    await _matchPair(tester, 'apple', 'elma');
    expect(find.text('1 / 2'), findsOneWidget);

    await _matchPair(tester, 'book', 'kitap');
    await tester.pump(const Duration(milliseconds: 350));
    // Post-frame submit + navigation çözülür.
    await tester.pumpAndSettle();

    // Doğru sayısı = toplam (oyun tüm çiftler eşleşince biter).
    expect(repo.submitCount, 1);
    // Başarıda Oyun Sonu Raporu ekranına geçilir (seed ile).
    expect(find.text('RAPOR EKRANI'), findsOneWidget);
  });

  testWidgets('sonuç gönderimi hatasında "Tekrar Dene" gösterilir',
      (tester) async {
    final repo = FakeResultsRepository(submitError: const ResultsFailure.network());
    await tester.pumpWidget(_wrap(resultsRepo: repo));
    await tester.pump();

    await _matchPair(tester, 'apple', 'elma');
    await _matchPair(tester, 'book', 'kitap');
    await tester.pump(const Duration(milliseconds: 350));
    // Submit error (microtask) + setState + overlay pop animasyonu.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(repo.submitCount, 1);
    expect(find.text('Sonuç kaydedilemedi, tekrar dene.'), findsOneWidget);
    expect(find.text('Tekrar Dene'), findsOneWidget);
    expect(find.text('RAPOR EKRANI'), findsNothing);
  });
}
