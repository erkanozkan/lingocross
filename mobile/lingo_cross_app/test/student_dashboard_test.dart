import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/enrollment/data/dtos/enrollment_dtos.dart';
import 'package:lingo_cross_app/features/enrollment/data/enrollment_repository.dart';
import 'package:lingo_cross_app/features/enrollment/domain/enrollment_status.dart';
import 'package:lingo_cross_app/features/enrollment/presentation/screens/student_dashboard_screen.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/data/games_repository.dart';
import 'package:lingo_cross_app/features/games/domain/game_type.dart';

import 'helpers/fake_enrollment_repository.dart';
import 'helpers/fake_games_repository.dart';

String? lastGameId;

Widget _wrap({
  required FakeEnrollmentRepository enrollmentRepo,
  required FakeGamesRepository gamesRepo,
}) {
  lastGameId = null;
  final router = GoRouter(
    initialLocation: '/student',
    routes: [
      GoRoute(path: '/student', builder: (_, __) => const StudentDashboardScreen()),
      GoRoute(path: '/student/join', builder: (_, __) => const Scaffold()),
      GoRoute(
        path: '/student/games/:gameId',
        builder: (_, state) {
          lastGameId = state.pathParameters['gameId'];
          return const Scaffold(body: Text('game-screen'));
        },
      ),
      GoRoute(path: '/profile', builder: (_, __) => const Scaffold()),
    ],
  );
  return ProviderScope(
    overrides: [
      enrollmentRepositoryProvider.overrideWithValue(enrollmentRepo),
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

EnrollmentDto _enrollment({String teacherId = 't1', String name = 'Ayşe'}) {
  return EnrollmentDto(
    id: 'e1',
    teacherId: teacherId,
    studentId: 's1',
    status: EnrollmentStatus.active,
    counterpartUserId: teacherId,
    counterpartDisplayName: name,
    counterpartEmail: 'ayse@ornek.com',
    createdAt: DateTime(2026, 6, 23),
    updatedAt: DateTime(2026, 6, 23),
  );
}

AssignedGameDto _game({
  String id = 'g1',
  String title = 'Ünite 3 Bulmaca',
  String lessonTitle = 'Ünite 3',
  String teacherName = 'Ayşe',
  int words = 5,
}) {
  return AssignedGameDto(
    id: id,
    lessonId: 'l1',
    lessonTitle: lessonTitle,
    type: GameType.wordMatching,
    title: title,
    wordCount: words,
    teacherName: teacherName,
    publishedAt: DateTime(2026, 6, 23),
  );
}

void main() {
  testWidgets('Hiç öğretmene katılmamış → "Öğretmene Katıl" + boş durum',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: const []),
      gamesRepo: FakeGamesRepository(assigned: const []),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Bir Öğretmene Katıl'), findsOneWidget);
    expect(find.text('Henüz bir derse katılmadın'), findsOneWidget);
    expect(find.text('GÜNÜN OYUNU'), findsNothing);
  });

  testWidgets('Aktif öğretmen + atanan bulmaca → Günün Oyunu kartı',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo:
          FakeEnrollmentRepository(enrollments: [_enrollment(name: 'Ayşe')]),
      gamesRepo: FakeGamesRepository(
        assigned: [_game(title: 'Ünite 3 Bulmaca', words: 5)],
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('GÜNÜN OYUNU'), findsOneWidget);
    expect(find.text('Ünite 3 Bulmaca'), findsOneWidget);
    expect(find.text('Oyuna Başla'), findsOneWidget);
    expect(find.text('Paylaşan: Ayşe'), findsOneWidget);
    expect(find.text('Öğretmenin henüz bulmaca atamadı'), findsNothing);
  });

  testWidgets('Öğretmen var ama atanan bulmaca yok → boş bulmaca durumu',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(assigned: const []),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Öğretmenin henüz bulmaca atamadı'), findsOneWidget);
    expect(find.text('GÜNÜN OYUNU'), findsNothing);
  });

  testWidgets('Günün Oyunu kartına dokununca gameId ile oturum rotasına gider',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(
        assigned: [_game(id: 'g42', title: 'Ünite 3 Bulmaca')],
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Ünite 3 Bulmaca'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(lastGameId, 'g42');
    expect(find.text('game-screen'), findsOneWidget);
  });

  testWidgets('İkinci bulmaca "Atanan Bulmacalar" listesinde görünür',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(
        assigned: [
          _game(id: 'g1', title: 'İlk Bulmaca'),
          _game(id: 'g2', title: 'İkinci Bulmaca'),
        ],
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Atanan Bulmacalar'), findsOneWidget);
    expect(find.text('İkinci Bulmaca'), findsOneWidget);
  });
}
