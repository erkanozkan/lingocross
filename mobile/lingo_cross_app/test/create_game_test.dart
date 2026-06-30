import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/classes/data/classes_repository.dart';
import 'package:lingo_cross_app/features/classes/data/dtos/class_dtos.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/data/games_repository.dart';
import 'package:lingo_cross_app/features/games/domain/game_type.dart';
import 'package:lingo_cross_app/features/games/domain/games_failure.dart';
import 'package:lingo_cross_app/features/games/presentation/screens/create_game_screen.dart';
import 'package:lingo_cross_app/features/lessons/data/dtos/lesson_dtos.dart';
import 'package:lingo_cross_app/features/lessons/data/lessons_repository.dart';
import 'package:lingo_cross_app/features/lessons/domain/lesson_status.dart';
import 'package:lingo_cross_app/features/subscription/data/dtos/subscription_dtos.dart';
import 'package:lingo_cross_app/features/subscription/presentation/subscription_notifier.dart';

import 'helpers/fake_classes_repository.dart';
import 'helpers/fake_games_repository.dart';
import 'helpers/fake_lessons_repository.dart';
import 'helpers/fake_subscription_repository.dart';

/// Test amaçlı subscription notifier: önceden belirlenen [value]'yu döner.
class _StubSubscriptionNotifier extends SubscriptionNotifier {
  _StubSubscriptionNotifier({this.value});

  final SubscriptionDto? value;

  @override
  Future<SubscriptionDto> build() => Future.value(value);
}

Widget _wrap({
  required FakeLessonsRepository lessonsRepo,
  required FakeGamesRepository gamesRepo,
  required FakeClassesRepository classesRepo,
  String? initialLessonId,
  List<String>? pushedRoutes,
  // Bulmaca oluşturma Premium-only; sihirbazı test eden senaryolar için varsayılan
  // premium. Gate testleri free/loading override geçer.
  SubscriptionNotifier Function()? subOverride,
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
      GoRoute(
        path: '/paywall',
        builder: (context, state) {
          pushedRoutes?.add(state.uri.toString());
          return const Scaffold(body: Text('PAYWALL'));
        },
      ),
      GoRoute(
        path: '/teacher/classes/new',
        builder: (_, __) {
          pushedRoutes?.add('/teacher/classes/new');
          return const Scaffold(body: Text('CREATE_CLASS'));
        },
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      lessonsRepositoryProvider.overrideWithValue(lessonsRepo),
      gamesRepositoryProvider.overrideWithValue(gamesRepo),
      classesRepositoryProvider.overrideWithValue(classesRepo),
      subscriptionNotifierProvider.overrideWith(
        subOverride ??
            () => _StubSubscriptionNotifier(value: premiumSubscription()),
      ),
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

GamePreviewResponse _matchingPreview() {
  return const GamePreviewResponse(
    type: GameType.wordMatching,
    wordMatching: WordMatchingContent(
      pairs: [
        MatchingPair(wordId: 'w1', term: 'apple', correctTranslation: 'elma'),
        MatchingPair(wordId: 'w2', term: 'book', correctTranslation: 'kitap'),
      ],
      distractors: ['masa'],
    ),
  );
}

GamePreviewResponse _crosswordPreview() {
  return const GamePreviewResponse(
    type: GameType.crossword,
    crossword: CrosswordContent(
      rows: 5,
      cols: 5,
      entries: [
        CrosswordEntry(
          number: 1,
          answer: 'APPLE',
          clue: 'Bir meyve',
          row: 0,
          col: 0,
          direction: CrosswordDirection.across,
          length: 5,
        ),
        CrosswordEntry(
          number: 2,
          answer: 'ANT',
          clue: 'Küçük bir böcek',
          row: 0,
          col: 0,
          direction: CrosswordDirection.down,
          length: 3,
        ),
      ],
    ),
  );
}

GamePreviewResponse _scrambledPreview() {
  return const GamePreviewResponse(
    type: GameType.scrambled,
    scrambled: ScrambledContent(
      items: [
        ScrambledItem(
          wordId: 'w1',
          answer: 'apple',
          scrambledLetters: 'ppale',
          clue: 'elma',
        ),
        ScrambledItem(
          wordId: 'w2',
          answer: 'book',
          scrambledLetters: 'okbo',
          clue: 'kitap',
        ),
      ],
    ),
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

/// Bir sonraki adıma geç: "Sonraki Adım" butonunu bul (gerekirse uzun içerik
/// — örn. crossword önizleme ızgarası — için ListView'ı kaydırarak görünür yap).
Future<void> _next(WidgetTester tester) async {
  final next = find.text('Sonraki Adım');
  // Uzun önizleme içeriğinde buton fold altında kalabilir; tekrar tekrar kaydır.
  var guard = 0;
  while (next.evaluate().isEmpty && guard < 10) {
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    guard++;
  }
  await tester.ensureVisible(next);
  await tester.pumpAndSettle();
  await tester.tap(next);
  await tester.pumpAndSettle();
}

void main() {
  group('Bulmaca oluşturma artık ücretsiz (giriş kapısı yok)', () {
    testWidgets('FREE → sihirbaz doğrudan açılır, paywall yok', (tester) async {
      final pushed = <String>[];
      await tester.pumpWidget(_wrap(
        lessonsRepo: FakeLessonsRepository(lessons: [_lesson()]),
        gamesRepo: FakeGamesRepository(),
        classesRepo: FakeClassesRepository(classes: [_class()]),
        pushedRoutes: pushed,
        subOverride: () => _StubSubscriptionNotifier(value: freeSubscription()),
      ));
      await _openCreate(tester);

      // Free kullanıcıda da sihirbazın ilk adımı görünür; paywall'a gidilmez.
      expect(find.text('Oyun Türünü Seç'), findsOneWidget);
      expect(find.text('PAYWALL'), findsNothing);
      expect(pushed, isEmpty);
    });

    testWidgets('PREMIUM → sihirbaz normal açılır', (tester) async {
      await tester.pumpWidget(_wrap(
        lessonsRepo: FakeLessonsRepository(lessons: [_lesson()]),
        gamesRepo: FakeGamesRepository(),
        classesRepo: FakeClassesRepository(classes: [_class()]),
        subOverride: () =>
            _StubSubscriptionNotifier(value: premiumSubscription()),
      ));
      await _openCreate(tester);

      expect(find.text('Oyun Türünü Seç'), findsOneWidget);
      expect(find.text('PAYWALL'), findsNothing);
    });
  });

  testWidgets('Adım 1: üç oyun türü kartı (Karışık Harfler dahil)',
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
    expect(find.text('Karışık Harfler'), findsOneWidget);
    expect(find.text('Yakında'), findsNothing);
  });

  testWidgets(
      'Tam akış: tür→ders→önizleme→sınıf seçilip oluştur+yayınla WordMatching',
      (tester) async {
    final games = FakeGamesRepository(previewValue: _matchingPreview());
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await _next(tester); // tür → ders
    await _next(tester); // ders → önizleme
    await _next(tester); // önizleme → sınıf
    // Adım 4: sınıf seç.
    await tester.tap(find.text('6-A Sınıfı'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bulmacayı Oluştur'));
    await tester.pumpAndSettle();

    expect(games.createCount, 1);
    expect(games.lastCreateLessonId, 'l1');
    expect(games.lastCreateRequest?.type, GameType.wordMatching);
    expect(games.lastCreateRequest?.classIds, ['cls1']);
    expect(find.text('Bulmaca oluşturuldu ve yayınlandı.'), findsOneWidget);
  });

  testWidgets('Crossword türü seçilince Crossword tipiyle oluşturulur',
      (tester) async {
    final games = FakeGamesRepository(previewValue: _crosswordPreview());
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
    await _next(tester);
    await tester.tap(find.text('6-A Sınıfı'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bulmacayı Oluştur'));
    await tester.pumpAndSettle();

    expect(games.createCount, 1);
    expect(games.lastCreateRequest?.type, GameType.crossword);
  });

  testWidgets('Sınıf seçilmeden "Bulmacayı Oluştur" tetiklenmez',
      (tester) async {
    final games = FakeGamesRepository(previewValue: _matchingPreview());
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await _next(tester);
    await _next(tester);
    await _next(tester);
    // Sınıf seçilmedi → buton pasif; dokunsa bile create çağrılmaz.
    await tester.tap(find.text('Bulmacayı Oluştur'),
        warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(games.createCount, 0);
  });

  testWidgets(
      'BUG 1: hiç sınıf yoksa EN BAŞTA boş durum (sihirbaz gövdesi gizli)',
      (tester) async {
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: FakeGamesRepository(previewValue: _matchingPreview()),
      classesRepo: FakeClassesRepository(classes: const []),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    // Sihirbazın 1. adımına bile girmeden boş durum görünür.
    expect(find.text('Önce bir sınıf oluştur'), findsOneWidget);
    expect(find.text('Bulmaca atayabilmek için en az bir sınıfın olması gerekir.'),
        findsOneWidget);
    expect(find.text('Sınıf Oluştur'), findsOneWidget);
    // Sihirbaz adımları / oluştur+yayınla bottom bar görünmez.
    expect(find.text('Oyun Türünü Seç'), findsNothing);
    expect(find.text('Bulmacayı Oluştur'), findsNothing);
  });

  testWidgets('BUG 1: "Sınıf Oluştur" → /teacher/classes/new push',
      (tester) async {
    final pushed = <String>[];
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: FakeGamesRepository(previewValue: _matchingPreview()),
      classesRepo: FakeClassesRepository(classes: const []),
      initialLessonId: 'l1',
      pushedRoutes: pushed,
    ));
    await _openCreate(tester);

    await tester.tap(find.text('Sınıf Oluştur'));
    await tester.pumpAndSettle();

    expect(pushed, contains('/teacher/classes/new'));
    expect(find.text('CREATE_CLASS'), findsOneWidget);
  });

  testWidgets('BUG 1: sınıf VARKEN normal sihirbaz görünür (boş durum yok)',
      (tester) async {
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: FakeGamesRepository(previewValue: _matchingPreview()),
      classesRepo: FakeClassesRepository(classes: [_class()]),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    expect(find.text('Oyun Türünü Seç'), findsOneWidget);
    expect(find.text('Önce bir sınıf oluştur'), findsNothing);
  });

  testWidgets('Yetersiz kelime (400) → "en az 4 kelime" mesajı',
      (tester) async {
    final games = FakeGamesRepository(
      previewValue: _matchingPreview(),
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
    await _next(tester);
    await tester.tap(find.text('6-A Sınıfı'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bulmacayı Oluştur'));
    await tester.pumpAndSettle();

    expect(
      find.text('Bulmaca oluşturmak için ders en az 4 kelime içermeli.'),
      findsOneWidget,
    );
  });

  testWidgets('Önizleme adımı: WordMatching çiftleri eşleşmiş halde render',
      (tester) async {
    final games = FakeGamesRepository(previewValue: _matchingPreview());
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await _next(tester); // tür → ders
    await _next(tester); // ders → önizleme

    expect(games.previewCount, 1);
    expect(games.lastPreviewLessonId, 'l1');
    expect(games.lastPreviewType, GameType.wordMatching);
    expect(find.text('Örnek Önizleme'), findsOneWidget);
    expect(find.text('apple'), findsOneWidget);
    expect(find.text('elma'), findsOneWidget);
    expect(find.text('book'), findsOneWidget);
    expect(find.text('kitap'), findsOneWidget);
    // Salt-okunur not görünür.
    expect(
      find.text('Bu yalnızca bir örnek önizlemedir; kaydedilmedi.'),
      findsOneWidget,
    );
    // create henüz çağrılmadı (önizleme yalnız görsel).
    expect(games.createCount, 0);
  });

  testWidgets('Önizleme adımı: Crossword ipuçları + yön başlıkları render',
      (tester) async {
    final games = FakeGamesRepository(previewValue: _crosswordPreview());
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await tester.tap(find.text('Çengel Bulmaca'));
    await tester.pumpAndSettle();
    await _next(tester); // tür → ders
    await _next(tester); // ders → önizleme

    expect(games.lastPreviewType, GameType.crossword);
    expect(find.text('SOLDAN SAĞA'), findsOneWidget);
    expect(find.text('YUKARIDAN AŞAĞI'), findsOneWidget);
    expect(find.text('Bir meyve'), findsOneWidget);
    expect(find.text('Küçük bir böcek'), findsOneWidget);
    // Cevap harfleri ızgarada gösterilmez (statik boş kutular).
    expect(find.text('APPLE'), findsNothing);
  });

  testWidgets('Scrambled türü seçilince Scrambled tipiyle oluşturulur',
      (tester) async {
    final games = FakeGamesRepository(previewValue: _scrambledPreview());
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await tester.ensureVisible(find.text('Karışık Harfler'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Karışık Harfler'));
    await tester.pumpAndSettle();
    await _next(tester);
    await _next(tester);
    await _next(tester);
    await tester.tap(find.text('6-A Sınıfı'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bulmacayı Oluştur'));
    await tester.pumpAndSettle();

    expect(games.createCount, 1);
    expect(games.lastCreateRequest?.type, GameType.scrambled);
  });

  testWidgets('Önizleme adımı: Scrambled ipucu + karışık harf chip render',
      (tester) async {
    final games = FakeGamesRepository(previewValue: _scrambledPreview());
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await tester.ensureVisible(find.text('Karışık Harfler'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Karışık Harfler'));
    await tester.pumpAndSettle();
    await _next(tester); // tür → ders
    await _next(tester); // ders → önizleme

    expect(games.lastPreviewType, GameType.scrambled);
    expect(find.text('Örnek Önizleme'), findsOneWidget);
    // Çeviri ipuçları gösterilir.
    expect(find.text('elma'), findsOneWidget);
    expect(find.text('kitap'), findsOneWidget);
    // Karışık harfler chip olarak gösterilir (cevap dizilmemiş).
    expect(find.text('apple'), findsNothing);
    expect(games.createCount, 0);
  });

  testWidgets('Önizleme adımı: yetersiz kelime → net mesaj + Geri Dön',
      (tester) async {
    final games = FakeGamesRepository(
      previewError: const GamesFailure.insufficientWords(),
    );
    await tester.pumpWidget(_wrap(
      lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
      gamesRepo: games,
      classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
      initialLessonId: 'l1',
    ));
    await _openCreate(tester);

    await _next(tester); // tür → ders
    await _next(tester); // ders → önizleme

    expect(
      find.text('Bulmaca oluşturmak için ders en az 4 kelime içermeli.'),
      findsOneWidget,
    );
    // Hata kutusu içinde "Geri Dön" var (ders adımına dönmek için).
    expect(find.text('Geri Dön'), findsWidgets);
    expect(games.createCount, 0);
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
