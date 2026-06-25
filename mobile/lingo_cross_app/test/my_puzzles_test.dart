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
import 'package:lingo_cross_app/features/games/domain/games_failure.dart';
import 'package:lingo_cross_app/features/games/presentation/screens/my_puzzles_screen.dart';

import 'helpers/fake_games_repository.dart';

Widget _wrap(FakeGamesRepository gamesRepo) {
  final router = GoRouter(
    initialLocation: '/puzzles',
    routes: [
      GoRoute(
        path: '/puzzles',
        builder: (_, __) => const MyPuzzlesScreen(),
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

TeacherPuzzleDto _puzzle({
  String id = 'g1',
  String lessonId = 'l1',
  String lessonTitle = 'Unit 4: Food',
  GameType type = GameType.crossword,
  bool isPublished = true,
  int assignedStudentCount = 6,
  int solveCount = 12,
}) {
  return TeacherPuzzleDto(
    id: id,
    lessonId: lessonId,
    lessonTitle: lessonTitle,
    type: type,
    isPublished: isPublished,
    createdAt: DateTime(2026, 6, 12),
    assignedStudentCount: assignedStudentCount,
    solveCount: solveCount,
  );
}

void main() {
  testWidgets('Liste: tür rozeti + ders başlığı + paylaşılan öğrenci sayısı',
      (tester) async {
    await tester.pumpWidget(_wrap(FakeGamesRepository(
      myPuzzles: [
        _puzzle(lessonTitle: 'Unit 4: Food', type: GameType.crossword),
        _puzzle(
          id: 'g2',
          lessonId: 'l2',
          lessonTitle: 'Unit 3: Family',
          type: GameType.wordMatching,
          assignedStudentCount: 3,
        ),
      ],
    )));
    await tester.pumpAndSettle();

    expect(find.text('Unit 4: Food'), findsOneWidget);
    expect(find.text('Unit 3: Family'), findsOneWidget);
    // Tür rozetleri (1 → Kelime Eşleştirme, 2 → Crossword).
    expect(find.text('CROSSWORD'), findsOneWidget);
    // toUpperCase() locale-bağımsız → "i" dotless "I" olur.
    expect(find.text('KELIME EŞLEŞTIRME'), findsOneWidget);
    // Bireysel model: "Paylaşılan: {n} öğrenci".
    expect(find.text('Paylaşılan: 6 öğrenci'), findsOneWidget);
    expect(find.text('Paylaşılan: 3 öğrenci'), findsOneWidget);
  });

  testWidgets('İstatistik: Toplam Bulmaca = liste uzunluğu, Öğrenci Çözümü = solveCount toplamı',
      (tester) async {
    await tester.pumpWidget(_wrap(FakeGamesRepository(
      myPuzzles: [
        _puzzle(id: 'g1', solveCount: 10),
        _puzzle(id: 'g2', solveCount: 5),
        _puzzle(id: 'g3', solveCount: 7),
      ],
    )));
    await tester.pumpAndSettle();

    expect(find.text('Toplam Bulmaca'), findsOneWidget);
    expect(find.text('Öğrenci Çözümü'), findsOneWidget);
    expect(find.text('3'), findsOneWidget); // toplam bulmaca
    expect(find.text('22'), findsOneWidget); // 10 + 5 + 7
  });

  testWidgets('DÜZELTME 2: manuel "Paylaş" aksiyonu YOK (oto-yayın)',
      (tester) async {
    final games = FakeGamesRepository(myPuzzles: [_puzzle(id: 'g9')]);
    await tester.pumpWidget(_wrap(games));
    await tester.pumpAndSettle();

    // Paylaş butonu kaldırıldı; share asla çağrılmaz.
    expect(find.text('Paylaş'), findsNothing);
    expect(games.shareCount, 0);
    // "Detayları Gör" kalır.
    expect(find.text('Detayları Gör'), findsOneWidget);
  });

  testWidgets('DÜZELTME 3: ekrana girişte myPuzzles bir kez yenilenir',
      (tester) async {
    final games = FakeGamesRepository(myPuzzles: [_puzzle(id: 'g9')]);
    await tester.pumpWidget(_wrap(games));
    await tester.pumpAndSettle();

    // İlk build (provider build) + initState refresh → en az 2 çağrı.
    expect(games.listMyPuzzlesCount, greaterThanOrEqualTo(2));
  });

  testWidgets('Boş durum: bulmaca yokken anlamlı boş mesaj', (tester) async {
    await tester.pumpWidget(_wrap(FakeGamesRepository(myPuzzles: const [])));
    await tester.pumpAndSettle();

    expect(find.text('Henüz bulmaca yok'), findsOneWidget);
  });

  testWidgets('Hata durumu: tekrar dene gösterir', (tester) async {
    await tester.pumpWidget(_wrap(FakeGamesRepository(
      myPuzzlesError: const GamesFailure.network(),
    )));
    await tester.pumpAndSettle();

    expect(find.text('Bulmacalar yüklenemedi'), findsOneWidget);
    expect(find.text('Tekrar Dene'), findsOneWidget);
  });

  testWidgets('Aktif filtresi yalnız yayımlı bulmacaları gösterir',
      (tester) async {
    await tester.pumpWidget(_wrap(FakeGamesRepository(
      myPuzzles: [
        _puzzle(id: 'g1', lessonTitle: 'Yayımlı', isPublished: true),
        _puzzle(id: 'g2', lessonTitle: 'Taslak', isPublished: false),
      ],
    )));
    await tester.pumpAndSettle();

    // Başlangıçta Tümü: ikisi de görünür.
    expect(find.text('Yayımlı'), findsOneWidget);
    expect(find.text('Taslak'), findsOneWidget);

    // Aktif çipine dokun → yalnız yayımlı kalır.
    await tester.tap(find.text('Aktif (1)'));
    await tester.pumpAndSettle();

    expect(find.text('Yayımlı'), findsOneWidget);
    expect(find.text('Taslak'), findsNothing);
  });
}
