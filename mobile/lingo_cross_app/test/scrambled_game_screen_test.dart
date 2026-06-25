import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/presentation/screens/scrambled_game_screen.dart';
import 'package:lingo_cross_app/features/results/data/results_repository.dart';
import 'package:lingo_cross_app/features/results/domain/results_failure.dart';

import 'helpers/fake_results_repository.dart';

// Tekrarsız harfli kelimeler → find.text('harf') tek widget bulur.
const _content = ScrambledContent(
  items: [
    ScrambledItem(
      wordId: 'w1',
      answer: 'cat',
      scrambledLetters: 'tac',
      clue: 'kedi',
    ),
    ScrambledItem(
      wordId: 'w2',
      answer: 'dog',
      scrambledLetters: 'gdo',
      clue: 'köpek',
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
            const ScrambledGameScreen(sessionId: 's1', content: _content),
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

/// Havuzdaki bir harfe dokunur (ilk eşleşen text widget'ı).
Future<void> _tapLetter(WidgetTester tester, String letter) async {
  await tester.tap(find.text(letter).first);
  await tester.pump();
}

void main() {
  testWidgets('başlangıçta ipucu + sayaç 0/2 + Bitir/Vazgeç görünür',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(find.text('Harfleri Diz'), findsOneWidget); // başlık
    expect(find.text('kedi'), findsOneWidget); // ilk kelimenin çeviri ipucu
    expect(find.text('0 / 2'), findsOneWidget); // ilerleme sayacı
    // Kelime gezinme göstergesi ("1 / 2") + sayaç ayrı; başlangıçta
    // sayaç 0/2 olduğundan "1 / 2" yalnız navigasyondan gelir.
    expect(find.text('1 / 2'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget); // timer
    expect(find.text('Vazgeç'), findsOneWidget);
    expect(find.text('Bitir'), findsOneWidget);
  });

  testWidgets('harf yerleştir → cevap dolar, ilerleme artar (doğruluk gizli)',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    // "cat" diz: c, a, t.
    await _tapLetter(tester, 'c');
    await _tapLetter(tester, 'a');
    await _tapLetter(tester, 't');

    // İlk kelime tamamen dolduğunda ilerleme sayacı 1/2 olur; kelime gezinme
    // göstergesi de hâlâ "1 / 2" → toplam iki "1 / 2" (doğru/yanlış gösterilmez).
    expect(find.text('1 / 2'), findsNWidgets(2));
    expect(find.text('Tebrikler!'), findsNothing);
  });

  testWidgets(
      'Bitir → bir doğru + bir boş kelime: correct=1/total=2, rapora geçer',
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

    // İlk kelimeyi doğru diz (cat), ikinciyi boş bırak.
    await _tapLetter(tester, 'c');
    await _tapLetter(tester, 'a');
    await _tapLetter(tester, 't');

    await tester.tap(find.text('Bitir'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(repo.submitCount, 1);
    expect(repo.lastTotalItems, 2);
    expect(repo.lastCorrectItems, 1); // yalnız cat doğru
    expect(find.text('RAPOR EKRANI'), findsOneWidget);
  });

  testWidgets('Bitir hiç harf dizilmeden de çalışır (hepsi yanlış sayılır)',
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
    final repo =
        FakeResultsRepository(submitError: const ResultsFailure.network());
    await tester.pumpWidget(_wrap(resultsRepo: repo));
    await tester.pump();

    await _tapLetter(tester, 'c');
    await tester.tap(find.text('Bitir'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(repo.submitCount, 1);
    expect(find.text('Sonuç kaydedilemedi, tekrar dene.'), findsOneWidget);
    expect(find.text('Tekrar Dene'), findsOneWidget);
    expect(find.text('RAPOR EKRANI'), findsNothing);
  });
}
