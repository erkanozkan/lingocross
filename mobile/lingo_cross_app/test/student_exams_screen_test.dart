import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/data/games_repository.dart';
import 'package:lingo_cross_app/features/games/domain/game_type.dart';
import 'package:lingo_cross_app/features/games/presentation/screens/student_exams_screen.dart';

import 'helpers/fake_games_repository.dart';

String? lastGameId;
String? lastResultId;

Widget _wrap(FakeGamesRepository gamesRepo) {
  lastGameId = null;
  lastResultId = null;
  final router = GoRouter(
    initialLocation: '/student/exams',
    routes: [
      GoRoute(
          path: '/student/exams',
          builder: (_, __) => const StudentExamsScreen()),
      GoRoute(
        path: '/student/games/:gameId',
        builder: (_, state) {
          lastGameId = state.pathParameters['gameId'];
          return const Scaffold(body: Text('launcher-screen'));
        },
      ),
      GoRoute(
        path: '/student/results/:resultId',
        builder: (_, state) {
          lastResultId = state.pathParameters['resultId'];
          return const Scaffold(body: Text('result-screen'));
        },
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      gamesRepositoryProvider.overrideWithValue(gamesRepo),
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

AssignedGameDto _exam({
  String id = 'q1',
  String title = 'LGS Çıkmış Sorular',
  int words = 10,
  bool isCompleted = false,
  int? score,
  String? resultId,
}) {
  return AssignedGameDto(
    id: id,
    questionTopicId: 'topic-1',
    lessonTitle: 'Çıkmış Sorular',
    type: GameType.questionSet,
    title: title,
    wordCount: words,
    teacherName: 'Ayşe',
    publishedAt: DateTime(2026, 6, 23),
    isCompleted: isCompleted,
    score: score,
    resultId: resultId,
  );
}

AssignedGameDto _matching({String id = 'g1', String title = 'Eşleştirme'}) {
  return AssignedGameDto(
    id: id,
    lessonId: 'l1',
    lessonTitle: 'Ünite 1',
    type: GameType.wordMatching,
    title: title,
    wordCount: 5,
    teacherName: 'Ayşe',
    publishedAt: DateTime(2026, 6, 23),
  );
}

void main() {
  testWidgets('Atanan sınavları liste halinde gösterir (oyunları HARİÇ tutar)',
      (tester) async {
    await tester.pumpWidget(_wrap(
      FakeGamesRepository(assigned: [
        _matching(title: 'Kelime Oyunu'),
        _exam(id: 'q1', title: 'LGS Çıkmış Sorular', words: 12),
      ]),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('LGS Çıkmış Sorular'), findsOneWidget);
    expect(find.text('12 soru'), findsOneWidget);
    // Eşleştirme oyunu sınav listesinde gösterilmez.
    expect(find.text('Kelime Oyunu'), findsNothing);
  });

  testWidgets('Tamamlanan sınavda skor rozeti görünür', (tester) async {
    await tester.pumpWidget(_wrap(
      FakeGamesRepository(assigned: [
        _exam(id: 'q1', title: 'YDS Seti', isCompleted: true, score: 80),
      ]),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('%80'), findsOneWidget);
  });

  testWidgets('Hiç sınav yoksa boş durum gösterir', (tester) async {
    await tester.pumpWidget(_wrap(
      FakeGamesRepository(assigned: [_matching()]),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Henüz sana sınav atanmadı'), findsOneWidget);
  });

  testWidgets('Sınava dokununca gameId ile launcher rotasına gider',
      (tester) async {
    await tester.pumpWidget(_wrap(
      FakeGamesRepository(assigned: [
        _exam(id: 'q42', title: 'LGS Çıkmış Sorular'),
      ]),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('LGS Çıkmış Sorular'));
    await tester.pumpAndSettle();

    expect(lastGameId, 'q42');
    expect(find.text('launcher-screen'), findsOneWidget);
  });

  testWidgets(
      'Tamamlanmış sınava dokununca sonuç ekranına gider (launcher DEĞİL)',
      (tester) async {
    await tester.pumpWidget(_wrap(
      FakeGamesRepository(assigned: [
        _exam(
            id: 'q7',
            title: 'YDS Çıkmış',
            isCompleted: true,
            score: 70,
            resultId: 'r99'),
      ]),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('YDS Çıkmış'));
    await tester.pumpAndSettle();

    // Tek-sefer: tamamlanmış sınav yeniden başlatılmaz; sonuç/rapor ekranına gider.
    expect(lastResultId, 'r99');
    expect(find.text('result-screen'), findsOneWidget);
    expect(lastGameId, isNull);
  });
}
