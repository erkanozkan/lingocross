import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/games/domain/game_type.dart';
import 'package:lingo_cross_app/features/games/presentation/widgets/game_preview_thumbnail.dart';

Widget _wrap(GameType type) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(child: GamePreviewThumbnail(type: type)),
      ),
    );

void main() {
  testWidgets('her tür için hatasız render edilir', (tester) async {
    for (final type in GameType.values) {
      await tester.pumpWidget(_wrap(type));
      await tester.pump();
      expect(find.byType(GamePreviewThumbnail), findsOneWidget,
          reason: 'render: $type');
      expect(tester.takeException(), isNull, reason: 'exception: $type');
    }
  });

  testWidgets('crossword → ızgara hücre harfleri içerir', (tester) async {
    await tester.pumpWidget(_wrap(GameType.crossword));
    await tester.pump();
    // 5x5 ızgaradaki dolu hücrelerden bazı harfler.
    expect(find.text('K'), findsWidgets);
    expect(find.text('O'), findsWidgets);
  });

  testWidgets('wordMatching → terim/karşılık pill çiftleri içerir',
      (tester) async {
    await tester.pumpWidget(_wrap(GameType.wordMatching));
    await tester.pump();
    expect(find.text('apple'), findsOneWidget);
    expect(find.text('elma'), findsOneWidget);
    expect(find.byIcon(Icons.compare_arrows), findsWidgets);
  });

  testWidgets('scrambled → karışık harf kareleri içerir', (tester) async {
    await tester.pumpWidget(_wrap(GameType.scrambled));
    await tester.pump();
    expect(find.text('P'), findsWidgets);
    expect(find.text('A'), findsOneWidget);
  });
}
