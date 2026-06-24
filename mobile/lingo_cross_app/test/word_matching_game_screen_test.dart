import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/presentation/screens/word_matching_game_screen.dart';

const _content = WordMatchingContent(
  pairs: [
    MatchingPair(wordId: 'w1', term: 'apple', correctTranslation: 'elma'),
    MatchingPair(wordId: 'w2', term: 'book', correctTranslation: 'kitap'),
  ],
  distractors: ['yolculuk'],
);

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/game',
    routes: [
      GoRoute(
        path: '/game',
        builder: (_, __) => const WordMatchingGameScreen(content: _content),
      ),
      GoRoute(path: '/student', builder: (_, __) => const Scaffold()),
    ],
  );
  return ProviderScope(
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

  testWidgets('tüm çiftler eşleşince tamamlanma overlay (süre + doğru/toplam)',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    await _matchPair(tester, 'apple', 'elma');
    expect(find.text('1 / 2'), findsOneWidget);

    await _matchPair(tester, 'book', 'kitap');
    await tester.pump(const Duration(milliseconds: 350));

    // Minimal tamamlandı durumu.
    expect(find.text('Tebrikler!'), findsOneWidget);
    expect(find.text('Bitir'), findsOneWidget);
    expect(
      find.textContaining('Tüm kelimeleri 2/2 eşleştirdin'),
      findsOneWidget,
    );
  });
}
