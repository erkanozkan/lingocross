import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/lessons/data/dtos/lesson_dtos.dart';
import 'package:lingo_cross_app/features/lessons/data/lessons_repository.dart';
import 'package:lingo_cross_app/features/lessons/domain/lesson_status.dart';
import 'package:lingo_cross_app/features/lessons/presentation/screens/teacher_dashboard_screen.dart';
import 'package:lingo_cross_app/features/tracking/data/tracking_repository.dart';

import 'helpers/fake_lessons_repository.dart';
import 'helpers/fake_tracking_repository.dart';

Widget _wrap(FakeLessonsRepository repo, {FakeTrackingRepository? trackingRepo}) {
  final router = GoRouter(
    initialLocation: '/teacher',
    routes: [
      GoRoute(
        path: '/teacher',
        builder: (_, __) => const TeacherDashboardScreen(),
      ),
      GoRoute(path: '/teacher/lessons/new', builder: (_, __) => const Scaffold()),
      GoRoute(
        path: '/teacher/students',
        builder: (_, __) => const Scaffold(body: Text('reports-tab')),
      ),
      GoRoute(
        path: '/teacher/students/:id/results',
        builder: (_, state) =>
            Scaffold(body: Text('DETAY ${state.extra ?? ''}')),
      ),
      GoRoute(path: '/profile', builder: (_, __) => const Scaffold()),
    ],
  );
  return ProviderScope(
    overrides: [
      lessonsRepositoryProvider.overrideWithValue(repo),
      trackingRepositoryProvider
          .overrideWithValue(trackingRepo ?? FakeTrackingRepository()),
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

LessonDto _lesson({String title = 'Ders', bool published = true, int words = 3}) {
  return LessonDto(
    id: 'l1',
    teacherId: 't1',
    title: title,
    description: null,
    sourceLanguage: 'en',
    targetLanguage: 'tr',
    status: published ? LessonStatus.active : LessonStatus.draft,
    isPublished: published,
    wordCount: words,
    createdAt: DateTime(2026, 6, 23),
    updatedAt: DateTime(2026, 6, 23),
  );
}

void main() {
  testWidgets('Boş ders listesinde boş durum ve aksiyon kartı görünür',
      (tester) async {
    await tester.pumpWidget(_wrap(FakeLessonsRepository(lessons: const [])));
    // Skeleton animasyonu sonsuz döngüde olduğundan pumpAndSettle kullanılmaz;
    // future microtask çözülene kadar birkaç frame ilerlet.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Bento aksiyon kartı en üstte her zaman görünür.
    expect(find.text('Öğrenci Gelişimi'), findsOneWidget);
    // Boş durum kartı ListView'da fold altında; görünür alana kaydır
    // (kaydırma sırasında "Derslerim" başlığı da inşa edilir).
    await tester.scrollUntilVisible(find.text('Henüz dersiniz yok'), 200);
    expect(find.text('Henüz dersiniz yok'), findsOneWidget);
    expect(find.text('Derslerim'), findsOneWidget);
  });

  testWidgets('Ders listesi kartı başlık, yayın durumu ve kelime sayısı gösterir',
      (tester) async {
    await tester.pumpWidget(
      _wrap(FakeLessonsRepository(
        lessons: [_lesson(title: '9-A İngilizce', published: true, words: 12)],
      )),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Kart ListView içinde fold altında olabilir; görünür alana kaydır.
    await tester.scrollUntilVisible(find.text('9-A İngilizce'), 200);

    expect(find.text('9-A İngilizce'), findsOneWidget);
    expect(find.text('Yayında'), findsOneWidget);
    expect(find.text('12 kelime'), findsOneWidget);
    expect(find.text('Henüz dersiniz yok'), findsNothing);
  });

  testWidgets(
      'Son Raporlar: paylaşılan sonucu olan öğrenci ad + ortalama % rozetiyle listelenir',
      (tester) async {
    await tester.pumpWidget(_wrap(
      FakeLessonsRepository(lessons: const []),
      trackingRepo: FakeTrackingRepository(students: [
        sampleStudent(
          studentId: 's1',
          displayName: 'Ada Yılmaz',
          sharedResultsCount: 4,
          averageScore: 90,
        ),
        // Paylaşımı olmayan öğrenci listelenmez.
        sampleStudent(
          studentId: 's2',
          displayName: 'Boş Öğrenci',
          sharedResultsCount: 0,
          averageScore: null,
        ),
      ]),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.scrollUntilVisible(find.text('Ada Yılmaz'), 200);
    expect(find.text('Ada Yılmaz'), findsOneWidget);
    expect(find.text('%90'), findsOneWidget);
    // Paylaşımı olmayan öğrenci mini listede görünmez.
    expect(find.text('Boş Öğrenci'), findsNothing);
  });

  testWidgets('Son Raporlar: paylaşılan sonuç yoksa boş durum metni',
      (tester) async {
    await tester.pumpWidget(_wrap(
      FakeLessonsRepository(lessons: const []),
      trackingRepo: FakeTrackingRepository(students: [
        sampleStudent(sharedResultsCount: 0, averageScore: null),
      ]),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.scrollUntilVisible(
        find.text('Öğrenciler sonuç paylaştıkça burada görünecek.'), 200);
    expect(find.text('Öğrenciler sonuç paylaştıkça burada görünecek.'),
        findsOneWidget);
  });

  testWidgets('Son Raporlar satırına dokununca öğrenci detayına gider',
      (tester) async {
    await tester.pumpWidget(_wrap(
      FakeLessonsRepository(lessons: const []),
      trackingRepo: FakeTrackingRepository(students: [
        sampleStudent(studentId: 's1', displayName: 'Ada', sharedResultsCount: 2),
      ]),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.scrollUntilVisible(find.text('Ada'), 200);
    await tester.tap(find.text('Ada'));
    await tester.pumpAndSettle();

    expect(find.text('DETAY Ada'), findsOneWidget);
  });
}
