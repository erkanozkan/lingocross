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
import 'package:lingo_cross_app/features/games/presentation/screens/game_launcher_screen.dart';
import 'package:lingo_cross_app/features/games/presentation/screens/question_set_game_screen.dart';
import 'package:lingo_cross_app/features/results/data/results_repository.dart';

import 'helpers/fake_games_repository.dart';
import 'helpers/fake_results_repository.dart';

StartGameSessionResponse _response({QuestionSetContent? content}) =>
    StartGameSessionResponse(
      session: GameSessionDto(
        id: 'sess-1',
        gameId: 'g1',
        studentId: 's1',
        status: GameSessionStatus.inProgress,
        startedAt: DateTime(2026, 6, 23),
      ),
      type: GameType.questionSet,
      questionSet: content,
    );

const _content = QuestionSetContent(
  questions: [
    QuestionItem(
      questionId: 'q1',
      stem: 'Tanımlayıcı soru kökü?',
      choices: [
        QuestionChoice(optionId: 'q1a', label: 'A', text: 'Birinci şık'),
        QuestionChoice(optionId: 'q1b', label: 'B', text: 'İkinci şık'),
      ],
      correctOptionId: 'q1a',
    ),
  ],
);

Widget _wrap({required FakeGamesRepository gamesRepo}) {
  final router = GoRouter(
    initialLocation: '/student/games/g1',
    routes: [
      GoRoute(
        path: '/student/games/:gameId',
        builder: (_, state) =>
            GameLauncherScreen(gameId: state.pathParameters['gameId']!),
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
      gamesRepositoryProvider.overrideWithValue(gamesRepo),
      resultsRepositoryProvider.overrideWithValue(FakeResultsRepository()),
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
  testWidgets('questionSet tipi → QuestionSetGameScreen açılır', (tester) async {
    final games = FakeGamesRepository(startValue: _response(content: _content));
    await tester.pumpWidget(_wrap(gamesRepo: games));
    await tester.pump(); // post-frame start
    await tester.pump(); // session resolved

    expect(find.byType(QuestionSetGameScreen), findsOneWidget);
    // Başlık + alt başlık aynı metni gösterir (Stitch header).
    expect(find.text('Çıkmış Sorular'), findsWidgets); // başlık/alt başlık
    expect(find.text('Tanımlayıcı soru kökü?'), findsOneWidget);
    expect(find.text('Birinci şık'), findsOneWidget);
    expect(games.lastStartGameId, 'g1');
  });

  testWidgets('questionSet içerik null ise hata scaffold', (tester) async {
    final games = FakeGamesRepository(startValue: _response(content: null));
    await tester.pumpWidget(_wrap(gamesRepo: games));
    await tester.pump();
    await tester.pump();

    expect(find.byType(QuestionSetGameScreen), findsNothing);
    expect(find.text('Oyun yüklenemedi'), findsOneWidget);
  });
}
