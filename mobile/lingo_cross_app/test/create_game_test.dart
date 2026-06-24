import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/classes/data/classes_repository.dart';
import 'package:lingo_cross_app/features/classes/data/dtos/class_dtos.dart';
import 'package:lingo_cross_app/features/games/data/games_repository.dart';
import 'package:lingo_cross_app/features/games/domain/game_type.dart';
import 'package:lingo_cross_app/features/games/domain/games_failure.dart';
import 'package:lingo_cross_app/features/games/presentation/screens/create_game_screen.dart';
import 'package:lingo_cross_app/features/lessons/data/dtos/lesson_dtos.dart';
import 'package:lingo_cross_app/features/lessons/data/lessons_repository.dart';
import 'package:lingo_cross_app/features/lessons/domain/lesson_status.dart';

import 'helpers/fake_classes_repository.dart';
import 'helpers/fake_games_repository.dart';
import 'helpers/fake_lessons_repository.dart';

Widget _wrap({
  required FakeLessonsRepository lessonsRepo,
  required FakeGamesRepository gamesRepo,
  required FakeClassesRepository classesRepo,
  String? initialLessonId,
}) {
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
      classesRepositoryProvider.overrideWithValue(classesRepo),
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

ClassDto _class({String id = 'cls1', String name = '6-A Sınıfı'}) {
  return ClassDto(
    id: id,
    name: name,
    inviteCode: 'A1B2C3D4',
    studentCount: 12,
    createdAt: DateTime(2026, 6, 23),
  );
}

Future<void> _openCreate(WidgetTester tester) async {
  await tester.pump();
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

/// Adım 1 → 2 ve 2 → 3: "Sonraki Adım" (gerekirse görünür yap).
Future<void> _next(WidgetTester tester) async {
  final next = find.text('Sonraki Adım');
  if (next.evaluate().isEmpty) {
    // ListView'da alt fold'da kalmış olabilir; aşağı kaydır.
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
  }
  await tester.ensureVisible(next);
  await tester.pumpAndSettle();
  await tester.tap(next);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Adım 1: iki oyun türü kartı (Çengel Bulmaca aktif)',
      (tester) async {
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson()]),
      gamesRepo: FakeGamesRepository(),
      classesRepo: FakeClassesRepository(classes: [_class()]),
    ));
    await _openCreate(tester);

    expect(find.text('Oyun Türünü Seç'), findsOneWidget);
    expect(find.text('Kelime Eşleştirme'), findsOneWidget);
    expect(find.text('Çengel Bulmaca'), findsOneWidget);
    expect(find.text('Yakında'), findsNothing);
  });

  testWidgets('Tam akış: tür+ders+sınıf seçilip oluştur+yayınla WordMatching',
      (tester) async {
    final games = FakeGamesRepository();
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await _next(tester);
    await _next(tester);
    // Adım 3: sınıf seç.
    await tester.tap(find.text('6-A Sınıfı'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bulmacayı Oluştur ve Yayınla'));
    await tester.pumpAndSettle();

    expect(games.createCount, 1);
    expect(games.lastCreateLessonId, 'l1');
    expect(games.lastCreateRequest?.type, GameType.wordMatching);
    expect(games.lastCreateRequest?.classIds, ['cls1']);
    expect(find.text('Bulmaca oluşturuldu ve yayınlandı.'), findsOneWidget);
  });

  testWidgets('Crossword türü seçilince Crossword tipiyle oluşturulur',
      (tester) async {
    final games = FakeGamesRepository();
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await tester.tap(find.text('Çengel Bulmaca'));
    await tester.pumpAndSettle();
    await _next(tester);
    await _next(tester);
    await tester.tap(find.text('6-A Sınıfı'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bulmacayı Oluştur ve Yayınla'));
    await tester.pumpAndSettle();

    expect(games.createCount, 1);
    expect(games.lastCreateRequest?.type, GameType.crossword);
  });

  testWidgets('Sınıf seçilmeden "Oluştur ve Yayınla" tetiklenmez',
      (tester) async {
    final games = FakeGamesRepository();
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await _next(tester);
    await _next(tester);
    // Sınıf seçilmedi → buton pasif; dokunsa bile create çağrılmaz.
    await tester.tap(find.text('Bulmacayı Oluştur ve Yayınla'),
        warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(games.createCount, 0);
  });

  testWidgets('Adım 3: hiç sınıf yoksa anlamlı boş durum',
      (tester) async {
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: FakeGamesRepository(),
      classesRepo: FakeClassesRepository(classes: const []),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await _next(tester);
    await _next(tester);

    expect(find.text('Henüz sınıfın yok. Önce bir sınıf oluştur.'),
        findsOneWidget);
  });

  testWidgets('Yetersiz kelime (400) → "en az 4 kelime" mesajı',
      (tester) async {
    final games = FakeGamesRepository(
      createError: const GamesFailure.insufficientWords(),
    );
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await _next(tester);
    await _next(tester);
    await tester.tap(find.text('6-A Sınıfı'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bulmacayı Oluştur ve Yayınla'));
    await tester.pumpAndSettle();

    expect(
      find.text('Bulmaca oluşturmak için ders en az 4 kelime içermeli.'),
      findsOneWidget,
    );
  });

  testWidgets('Adım 2: hiç ders yoksa anlamlı boş durum',
      (tester) async {
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: const []),
      gamesRepo: FakeGamesRepository(),
      classesRepo: FakeClassesRepository(classes: [_class()]),
    ));
    await _openCreate(tester);

    await _next(tester);
    expect(find.text('Henüz dersin yok. Önce bir ders oluştur.'),
        findsOneWidget);
  });
}
