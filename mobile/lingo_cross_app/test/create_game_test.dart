import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/games/data/games_repository.dart';
import 'package:lingo_cross_app/features/games/domain/game_type.dart';
import 'package:lingo_cross_app/features/games/domain/games_failure.dart';
import 'package:lingo_cross_app/features/games/presentation/screens/create_game_screen.dart';
import 'package:lingo_cross_app/features/lessons/data/dtos/lesson_dtos.dart';
import 'package:lingo_cross_app/features/lessons/data/lessons_repository.dart';
import 'package:lingo_cross_app/features/lessons/domain/lesson_status.dart';

import 'helpers/fake_games_repository.dart';
import 'helpers/fake_lessons_repository.dart';

bool didPop = false;

Widget _wrap({
  required FakeLessonsRepository lessonsRepo,
  required FakeGamesRepository gamesRepo,
  String? initialLessonId,
}) {
  didPop = false;
  final router = GoRouter(
    initialLocation: '/start',
    routes: [
      GoRoute(
        path: '/start',
        builder: (_, __) => Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => context.push('/create'),
              child: const Text('open'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/create',
        builder: (_, __) => CreateGameScreen(initialLessonId: initialLessonId),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      lessonsRepositoryProvider.overrideWithValue(lessonsRepo),
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

LessonDto _lesson({String id = 'l1', String title = 'Ünite 4'}) {
  return LessonDto(
    id: id,
    teacherId: 't1',
    title: title,
    description: null,
    sourceLanguage: 'en',
    targetLanguage: 'tr',
    status: LessonStatus.draft,
    isPublished: false,
    wordCount: 6,
    createdAt: DateTime(2026, 6, 23),
    updatedAt: DateTime(2026, 6, 23),
  );
}

/// /create rotasına gider ve dersler yüklenene dek bekler.
Future<void> _openCreate(WidgetTester tester) async {
  await tester.pump();
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('İki oyun türü kartı; Crossword aktif (Yakında kaldırıldı)',
      (tester) async {
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson()]),
      gamesRepo: FakeGamesRepository(),
    ));
    await _openCreate(tester);

    expect(find.text('Oyun Türünü Seç'), findsOneWidget);
    expect(find.text('Kelime Eşleştirme'), findsOneWidget);
    expect(find.text('Crossword'), findsOneWidget);
    // F2.4: Crossword artık aktif; "Yakında" rozeti kaldırıldı.
    expect(find.text('Yakında'), findsNothing);
  });

  testWidgets('Crossword seçilip oluştur+yayınla Crossword tipiyle çağrılır',
      (tester) async {
    final games = FakeGamesRepository();
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await tester.tap(find.text('Crossword'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bulmacayı Oluştur ve Yayınla'));
    await tester.pumpAndSettle();

    expect(games.createCount, 1);
    expect(games.lastCreateRequest?.type, GameType.crossword);
  });

  testWidgets('Ders seçilmeden "Oluştur ve Yayınla" tetiklenmez',
      (tester) async {
    final games = FakeGamesRepository();
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l9')]),
      gamesRepo: games,
    ));
    await _openCreate(tester);

    // Ders seçilmedi → buton pasif; dokunsa bile create çağrılmaz.
    await tester.tap(find.text('Bulmacayı Oluştur ve Yayınla'),
        warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(games.createCount, 0);
  });

  testWidgets('Ön-seçili ders ile oluştur+yayınla WordMatching ile çağrılır',
      (tester) async {
    final games = FakeGamesRepository();
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await tester.tap(find.text('Bulmacayı Oluştur ve Yayınla'));
    await tester.pumpAndSettle();

    expect(games.createCount, 1);
    expect(games.lastCreateLessonId, 'l1');
    expect(games.lastCreateRequest?.type, GameType.wordMatching);
    expect(find.text('Bulmaca oluşturuldu ve yayınlandı.'), findsOneWidget);
  });

  testWidgets('Yetersiz kelime (400) → "en az 4 kelime" mesajı',
      (tester) async {
    final games = FakeGamesRepository(
      createError: const GamesFailure.insufficientWords(),
    );
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await tester.tap(find.text('Bulmacayı Oluştur ve Yayınla'));
    await tester.pumpAndSettle();

    expect(
      find.text('Bulmaca oluşturmak için ders en az 4 kelime içermeli.'),
      findsOneWidget,
    );
  });

  testWidgets('Hiç ders yoksa anlamlı boş durum',
      (tester) async {
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: const []),
      gamesRepo: FakeGamesRepository(),
    ));
    await _openCreate(tester);

    expect(find.text('Henüz dersin yok. Önce bir ders oluştur.'),
        findsOneWidget);
  });
}
