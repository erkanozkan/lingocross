import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/lessons/data/dtos/lesson_dtos.dart';
import 'package:lingo_cross_app/features/lessons/data/lessons_repository.dart';
import 'package:lingo_cross_app/features/lessons/presentation/screens/teacher_dashboard_screen.dart';

import 'helpers/fake_lessons_repository.dart';

Widget _wrap(FakeLessonsRepository repo) {
  final router = GoRouter(
    initialLocation: '/teacher',
    routes: [
      GoRoute(
        path: '/teacher',
        builder: (_, __) => const TeacherDashboardScreen(),
      ),
      GoRoute(path: '/teacher/lessons/new', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/profile', builder: (_, __) => const Scaffold()),
    ],
  );
  return ProviderScope(
    overrides: [
      lessonsRepositoryProvider.overrideWithValue(repo),
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
}
