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
import 'package:lingo_cross_app/features/games/presentation/screens/scrambled_game_screen.dart';
import 'package:lingo_cross_app/features/results/data/results_repository.dart';

import 'helpers/fake_games_repository.dart';
import 'helpers/fake_results_repository.dart';

StartGameSessionResponse _scrambledResponse() => StartGameSessionResponse(
      session: GameSessionDto(
        id: 'sess-1',
        gameId: 'g1',
        studentId: 's1',
        status: GameSessionStatus.inProgress,
        startedAt: DateTime(2026, 6, 23),
      ),
      type: GameType.scrambled,
      scrambled: const ScrambledContent(
        items: [
          ScrambledItem(
            wordId: 'w1',
            answer: 'cat',
            scrambledLetters: 'tac',
            clue: 'kedi',
          ),
        ],
      ),
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
  testWidgets('scrambled tipi → ScrambledGameScreen açılır', (tester) async {
    final games = FakeGamesRepository(startValue: _scrambledResponse());
    await tester.pumpWidget(_wrap(gamesRepo: games));
    await tester.pump(); // post-frame start
    await tester.pump(); // session resolved

    expect(find.byType(ScrambledGameScreen), findsOneWidget);
    expect(find.text('Harfleri Diz'), findsOneWidget);
    expect(find.text('kedi'), findsOneWidget); // ipucu
    expect(games.lastStartGameId, 'g1');
  });

  testWidgets('scrambled içerik null ise hata scaffold', (tester) async {
    final games = FakeGamesRepository(
      startValue: StartGameSessionResponse(
        session: GameSessionDto(
          id: 'sess-1',
          gameId: 'g1',
          studentId: 's1',
          status: GameSessionStatus.inProgress,
          startedAt: DateTime(2026, 6, 23),
        ),
        type: GameType.scrambled,
        scrambled: null,
      ),
    );
    await tester.pumpWidget(_wrap(gamesRepo: games));
    await tester.pump();
    await tester.pump();

    expect(find.byType(ScrambledGameScreen), findsNothing);
    expect(find.text('Oyun yüklenemedi'), findsOneWidget);
  });
}
