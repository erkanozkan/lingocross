import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/classes/data/classes_repository.dart';
import 'package:lingo_cross_app/features/classes/data/dtos/class_dtos.dart';
import 'package:lingo_cross_app/features/enrollment/data/dtos/enrollment_dtos.dart';
import 'package:lingo_cross_app/features/enrollment/data/enrollment_repository.dart';
import 'package:lingo_cross_app/features/enrollment/domain/enrollment_status.dart';
import 'package:lingo_cross_app/features/enrollment/presentation/screens/student_dashboard_screen.dart';
import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/data/games_repository.dart';
import 'package:lingo_cross_app/features/games/domain/game_type.dart';
import 'package:lingo_cross_app/features/profile/data/dtos/student_progress_dto.dart';
import 'package:lingo_cross_app/features/profile/data/student_stats_repository.dart';

import 'helpers/fake_classes_repository.dart';
import 'helpers/fake_enrollment_repository.dart';
import 'helpers/fake_games_repository.dart';
import 'helpers/fake_student_stats_repository.dart';

String? lastGameId;
String? lastResultId;

Widget _wrap({
  required FakeEnrollmentRepository enrollmentRepo,
  required FakeGamesRepository gamesRepo,
  FakeStudentStatsRepository? statsRepo,
  FakeClassesRepository? classesRepo,
}) {
  lastGameId = null;
  lastResultId = null;
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
      // Sonuç/istatistik ekranı (tamamlanan bulmacadan buraya gidilir).
      // Not: en spesifik route (/student/results) önce gelmeli ki sonuç listesi
      // ile detay (/student/results/:resultId) çakışmasın.
      GoRoute(
          path: '/student/results',
          builder: (_, __) => const Scaffold(body: Text('results-screen'))),
      GoRoute(
        path: '/student/results/:resultId',
        builder: (_, state) {
          lastResultId = state.pathParameters['resultId'];
          return const Scaffold(body: Text('result-detail-screen'));
        },
      ),
      GoRoute(path: '/profile', builder: (_, __) => const Scaffold()),
    ],
  );
  return ProviderScope(
    overrides: [
      enrollmentRepositoryProvider.overrideWithValue(enrollmentRepo),
      gamesRepositoryProvider.overrideWithValue(gamesRepo),
      studentStatsRepositoryProvider
          .overrideWithValue(statsRepo ?? FakeStudentStatsRepository()),
      classesRepositoryProvider
          .overrideWithValue(classesRepo ?? FakeClassesRepository()),
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
  GameType type = GameType.wordMatching,
  bool isCompleted = false,
  String? resultId,
  int? score,
  DateTime? completedAt,
}) {
  return AssignedGameDto(
    id: id,
    lessonId: 'l1',
    lessonTitle: lessonTitle,
    type: type,
    title: title,
    wordCount: words,
    teacherName: teacherName,
    publishedAt: DateTime(2026, 6, 23),
    isCompleted: isCompleted,
    resultId: resultId,
    score: score,
    completedAt: completedAt,
  );
}

void main() {
  testWidgets('Hiç sınıfa katılmamış → "Sınıfa Katıl" + boş durum',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: const []),
      gamesRepo: FakeGamesRepository(assigned: const []),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Bir Sınıfa Katıl'), findsOneWidget);
    expect(find.text('Henüz bir sınıfa katılmadın'), findsOneWidget);
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

  testWidgets(
      'Tamamlanan bulmaca: "Tamamlanan Bulmacalar" bölümünde + skor; '
      'atanan listesinden çıkar', (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(
        assigned: [
          _game(id: 'g1', title: 'Atanan Bulmaca'),
          _game(
            id: 'g2',
            title: 'Bitmiş Bulmaca',
            isCompleted: true,
            resultId: 'r2',
            score: 85,
          ),
        ],
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Oynanabilir g1 günün oyunu olur; tamamlanan g2 ayrı bölümde.
    expect(find.text('GÜNÜN OYUNU'), findsOneWidget);
    expect(find.text('Atanan Bulmaca'), findsOneWidget);
    expect(find.text('Tamamlanan Bulmacalar'), findsOneWidget);
    expect(find.text('Bitmiş Bulmaca'), findsOneWidget);
    expect(find.text('%85'), findsOneWidget);
    // "Atanan Bulmacalar" listesi yalnız oynanabilirler için; g1 tek olduğundan
    // (günün oyunu) bu başlık görünmez ama tamamlanan da burada DEĞİL.
    expect(find.text('İstatistikleri Gör'), findsOneWidget);
  });

  testWidgets('Tamamlanan bulmacaya dokununca resultId ile istatistik ekranına '
      'gider (launcher\'a DEĞİL)', (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(
        assigned: [
          _game(id: 'g1', title: 'Atanan Bulmaca'),
          _game(
            id: 'g2',
            title: 'Bitmiş Bulmaca',
            isCompleted: true,
            resultId: 'res-77',
            score: 90,
          ),
        ],
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Tamamlanan satır listenin altındadır; önce görünür hale getir.
    await tester.scrollUntilVisible(find.text('Bitmiş Bulmaca'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(find.text('Bitmiş Bulmaca'));
    await tester.pump();
    await tester.tap(find.text('Bitmiş Bulmaca'));
    await tester.pumpAndSettle();

    expect(find.text('result-detail-screen'), findsOneWidget);
    expect(lastResultId, 'res-77');
    // Asla oyun launcher'ına gitmemeli.
    expect(lastGameId, isNull);
    expect(find.text('game-screen'), findsNothing);
  });

  testWidgets('Tümü tamamlanmış: atanan boş durumu + tamamlanan bölüm görünür',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(
        assigned: [
          _game(
            id: 'g1',
            title: 'Bitmiş Bulmaca',
            isCompleted: true,
            resultId: 'r1',
            score: 70,
          ),
        ],
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Oynanabilir yok → boş bulmaca durumu makul gösterilir.
    expect(find.text('Öğretmenin henüz bulmaca atamadı'), findsOneWidget);
    expect(find.text('GÜNÜN OYUNU'), findsNothing);
    // Tamamlanan bölüm yine de görünür.
    expect(find.text('Tamamlanan Bulmacalar'), findsOneWidget);
    expect(find.text('Bitmiş Bulmaca'), findsOneWidget);
    expect(find.text('%70'), findsOneWidget);
  });

  testWidgets('Tamamlanan yoksa "Tamamlanan Bulmacalar" bölümü gizli',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(
        assigned: [_game(id: 'g1', title: 'Atanan Bulmaca')],
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Tamamlanan Bulmacalar'), findsNothing);
  });

  testWidgets(
      'Gelişim Özeti: oyun oynanmışsa oyun sayısı + doğruluk + haftalık hedef',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(assigned: [_game(title: 'Ünite 3 Bulmaca')]),
      statsRepo: FakeStudentStatsRepository(
        progress: const StudentProgressDto(
          gamesPlayed: 7,
          averageAccuracy: 82,
          accuracyTrendDelta: 3,
          weeklyMinutes: 320,
          weeklyGoalMinutes: 500,
          streakDays: 4,
        ),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.scrollUntilVisible(find.text('Raporlarım'), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Raporlarım'), findsOneWidget);
    expect(find.text('7'), findsOneWidget); // Tamamlanan Oyun
    expect(find.text('%82'), findsOneWidget); // Ortalama Doğruluk
    expect(find.text('↑ %3'), findsOneWidget); // pozitif trend
    expect(find.text('320 / 500 dk'), findsOneWidget); // haftalık hedef
    expect(find.textContaining('180 dakika kaldı'), findsOneWidget);
    expect(find.text('Henüz oyun oynamadın.'), findsNothing);
  });

  testWidgets('Gelişim Özeti: hiç oyun yoksa boş metin gösterir',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(assigned: [_game(title: 'Ünite 3 Bulmaca')]),
      statsRepo: FakeStudentStatsRepository(
        progress: const StudentProgressDto(
          gamesPlayed: 0,
          averageAccuracy: 0,
          weeklyMinutes: 0,
          weeklyGoalMinutes: 500,
          streakDays: 0,
        ),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.scrollUntilVisible(find.text("Henüz oyun oynamadın."), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Henüz oyun oynamadın.'), findsOneWidget);
  });

  testWidgets('Greeting: streakDays > 0 ise ateş rozeti görünür',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(assigned: [_game(title: 'Ünite 3 Bulmaca')]),
      statsRepo: FakeStudentStatsRepository(
        progress: const StudentProgressDto(
          gamesPlayed: 2,
          averageAccuracy: 90,
          weeklyMinutes: 10,
          weeklyGoalMinutes: 500,
          streakDays: 5,
        ),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('Gelişim Özeti "Raporlarım" → sonuç ekranına gider',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(assigned: [_game(title: 'Ünite 3 Bulmaca')]),
      statsRepo: FakeStudentStatsRepository(
        progress: const StudentProgressDto(
          gamesPlayed: 3,
          averageAccuracy: 70,
          weeklyMinutes: 50,
          weeklyGoalMinutes: 500,
          streakDays: 1,
        ),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.scrollUntilVisible(find.text('Raporlarım'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(find.text('Raporlarım'));
    await tester.pump();
    await tester.tap(find.text('Raporlarım'));
    await tester.pumpAndSettle();

    expect(find.text('results-screen'), findsOneWidget);
  });

  testWidgets(
      'DÜZELTME 2: questionSet oyun listesinde DEĞİL; Sınavlara Hazırlan kartı',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(
        assigned: [
          _game(id: 'g1', title: 'Eşleştirme Oyunu'),
          _game(
            id: 'q1',
            title: 'LGS Çıkmış Sorular',
            type: GameType.questionSet,
          ),
        ],
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Oyun "Günün Oyunu"nda; questionSet sınav ise "Sınavlara Hazırlan" altında.
    expect(find.text('Eşleştirme Oyunu'), findsOneWidget);
    // Çözülmemiş sınav artık ana sayfada satır olarak doğrudan görünür.
    expect(find.text('LGS Çıkmış Sorular'), findsOneWidget);
    // "tümü" kartı (Sınav Hazırlık Soruları) da görünür.
    expect(find.text('Sınav Hazırlık Soruları'), findsOneWidget);
  });

  testWidgets('Atanan sınav yoksa Sınavlara Hazırlan kartı gizli',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(
        assigned: [_game(id: 'g1', title: 'Eşleştirme Oyunu')],
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Atanan sınav yoksa "Sınavlara Hazırlan" bölümü hiç görünmez (kart başlığı yok).
    expect(find.text('Sınav Hazırlık Soruları'), findsNothing);
  });

  testWidgets('DÜZELTME 1: "Sınıflarım" bölümü sınıf adı + öğretmeni gösterir',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(assigned: const []),
      classesRepo: FakeClassesRepository(
        memberships: const [
          ClassMembershipDto(
            classId: 'c1',
            className: '7-A İngilizce',
            teacherName: 'Ayşe Öğretmen',
          ),
        ],
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Sınıflarım'.toUpperCase()), findsOneWidget);
    expect(find.text('7-A İngilizce'), findsOneWidget);
    expect(find.text('Öğretmen: Ayşe Öğretmen'), findsOneWidget);
  });

  testWidgets('DÜZELTME 1: hiç sınıf yoksa boş durum metni',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: [_enrollment()]),
      gamesRepo: FakeGamesRepository(assigned: const []),
      classesRepo: FakeClassesRepository(memberships: const []),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Henüz bir sınıfa katılmadın.'), findsOneWidget);
  });
}
