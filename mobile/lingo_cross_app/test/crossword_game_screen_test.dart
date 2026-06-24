import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/domain/game_type.dart';
import 'package:lingo_cross_app/features/games/presentation/screens/crossword_game_screen.dart';
import 'package:lingo_cross_app/features/results/data/results_repository.dart';

import 'helpers/fake_results_repository.dart';

// Türkçe klavyede bulunan harflerden kelimeler (W/X/Q yok).
// across 1: KAR  down 2: KOL — (0,0)="K" ortak.
const _content = CrosswordContent(
  rows: 3,
  cols: 3,
  entries: [
    CrosswordEntry(
      number: 1,
      answer: 'KAR',
      clue: 'kedi',
      row: 0,
      col: 0,
      direction: CrosswordDirection.across,
      length: 3,
    ),
    CrosswordEntry(
      number: 2,
      answer: 'KOL',
      clue: 'inek',
      row: 0,
      col: 0,
      direction: CrosswordDirection.down,
      length: 3,
    ),
  ],
);

Widget _wrap({FakeResultsRepository? resultsRepo}) {
  final router = GoRouter(
    initialLocation: '/game',
    routes: [
      GoRoute(
        path: '/game',
        builder: (_, __) => const CrosswordGameScreen(
          sessionId: 's1',
          content: _content,
        ),
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

/// Aktif kelimeyi verilen harflerle doldurur (özel A–Z klavye tuşları, Key ile).
Future<void> _typeWord(WidgetTester tester, String word) async {
  for (final ch in word.split('')) {
    await tester.tap(find.byKey(ValueKey('crossword-key-$ch')));
    await tester.pump();
  }
}

/// İpucu listesi grid'in altında (kaydırılabilir alan). Test görünümünde
/// görünür kılmak için kaydırır, sonra ipucuna dokunur.
Future<void> _tapClue(WidgetTester tester, String clue) async {
  final finder = find.textContaining(clue);
  await tester.scrollUntilVisible(finder, 120,
      scrollable: find.byType(Scrollable).first);
  await tester.tap(finder);
  await tester.pump();
}

void main() {
  // Geniş + uzun test yüzeyi (telefon yüksekliği) — grid + ipucu + klavye sığsın.
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('başlangıçta başlık + sayaç 0/2 + ipucu başlıkları görünür',
      (tester) async {
    tester.view.physicalSize = const Size(440, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(find.text('Günün Bulmacası'), findsOneWidget);
    expect(find.text('0 / 2'), findsOneWidget);
    expect(find.text('SOLDAN SAĞA'), findsOneWidget);
    expect(find.text('YUKARIDAN AŞAĞI'), findsOneWidget);
    expect(find.textContaining('kedi'), findsOneWidget);
    expect(find.textContaining('inek'), findsOneWidget);
  });

  testWidgets('ipucuna dokun → kelimeye odak; harf girince sayaç artar',
      (tester) async {
    tester.view.physicalSize = const Size(440, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_wrap());
    await tester.pump();

    await _tapClue(tester, 'kedi'); // across KAR'a odaklan
    await _typeWord(tester, 'KAR');
    await tester.pump();

    expect(find.text('1 / 2'), findsOneWidget);
  });

  testWidgets('tüm hücreler dolup Bitir → sonuç gönderilir ve rapora geçer',
      (tester) async {
    tester.view.physicalSize = const Size(440, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final repo = FakeResultsRepository(
      submitResultValue: sampleResult(
        id: 'r1',
        sessionId: 's1',
        totalItems: 2,
        correctItems: 2,
        score: 100,
      ),
    );
    await tester.pumpWidget(_wrap(resultsRepo: repo));
    await tester.pump();

    await _tapClue(tester, 'kedi');
    await _typeWord(tester, 'KAR');
    await _tapClue(tester, 'inek');
    await _typeWord(tester, 'KOL');
    await tester.pump();

    // Tüm hücreler dolu → "Bitir" (enter) tuşu aktif; dokun.
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(repo.submitCount, 1);
    expect(find.text('RAPOR EKRANI'), findsOneWidget);
  });
}
