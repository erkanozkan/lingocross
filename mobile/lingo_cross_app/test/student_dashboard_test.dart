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
import 'package:lingo_cross_app/features/lessons/data/dtos/lesson_dtos.dart';
import 'package:lingo_cross_app/features/lessons/data/lessons_repository.dart';
import 'package:lingo_cross_app/features/lessons/domain/lesson_status.dart';

import 'helpers/fake_enrollment_repository.dart';
import 'helpers/fake_lessons_repository.dart';

Widget _wrap({
  required FakeEnrollmentRepository enrollmentRepo,
  required FakeLessonsRepository lessonsRepo,
}) {
  final router = GoRouter(
    initialLocation: '/student',
    routes: [
      GoRoute(path: '/student', builder: (_, __) => const StudentDashboardScreen()),
      GoRoute(path: '/student/join', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/student/lessons/:id', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/profile', builder: (_, __) => const Scaffold()),
    ],
  );
  return ProviderScope(
    overrides: [
      enrollmentRepositoryProvider.overrideWithValue(enrollmentRepo),
      lessonsRepositoryProvider.overrideWithValue(lessonsRepo),
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

LessonDto _lesson({
  String id = 'l1',
  String teacherId = 't1',
  String title = 'Ünite 3',
  bool published = true,
  int words = 5,
}) {
  return LessonDto(
    id: id,
    teacherId: teacherId,
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
  testWidgets('Hiç öğretmene katılmamış → "Öğretmene Katıl" + boş durum',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo: FakeEnrollmentRepository(enrollments: const []),
      lessonsRepo: FakeLessonsRepository(lessons: const []),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Bir Öğretmene Katıl'), findsOneWidget);
    expect(find.text('Henüz bir derse katılmadın'), findsOneWidget);
    // Faz 2 öğeleri gizli.
    expect(find.text('Günün Oyunu'), findsNothing);
  });

  testWidgets('Aktif öğretmen + yayınlanmış ders → Günün Oyunu kartı',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo:
          FakeEnrollmentRepository(enrollments: [_enrollment(name: 'Ayşe')]),
      lessonsRepo: FakeLessonsRepository(
        lessons: [_lesson(title: 'Ünite 3', words: 5)],
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Bölüm etiketi uppercase render edilir ("GÜNÜN OYUNU").
    expect(find.text('GÜNÜN OYUNU'), findsOneWidget);
    expect(find.text('Ünite 3'), findsOneWidget);
    expect(find.text('Oyuna Başla'), findsOneWidget);
    expect(find.text('Paylaşan: Ayşe'), findsOneWidget);
    expect(find.text('Henüz bir derse katılmadın'), findsNothing);
  });

  testWidgets('Öğretmen var ama yayınlanmış ders yok → boş ders durumu',
      (tester) async {
    await tester.pumpWidget(_wrap(
      enrollmentRepo:
          FakeEnrollmentRepository(enrollments: [_enrollment()]),
      lessonsRepo: FakeLessonsRepository(
        lessons: [_lesson(published: false)],
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Öğretmenin henüz ders yayınlamadı'), findsOneWidget);
    expect(find.text('Günün Oyunu'), findsNothing);
  });
}
