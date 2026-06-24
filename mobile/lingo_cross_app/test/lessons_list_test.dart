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
import 'package:lingo_cross_app/features/lessons/presentation/screens/lessons_list_screen.dart';

import 'helpers/fake_lessons_repository.dart';

Widget _wrap(FakeLessonsRepository repo) {
  final router = GoRouter(
    initialLocation: '/classes',
    routes: [
      GoRoute(path: '/classes', builder: (_, __) => const LessonsListScreen()),
      GoRoute(path: '/teacher/lessons/new', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/teacher/lessons/:id', builder: (_, __) => const Scaffold()),
    ],
  );
  return ProviderScope(
    overrides: [lessonsRepositoryProvider.overrideWithValue(repo)],
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

LessonDto _lesson({
  String id = 'l1',
  String title = 'Unit 4',
  LessonStatus status = LessonStatus.active,
  String? schedule = '15 - 21 Temmuz 2024',
  int words = 12,
}) {
  return LessonDto(
    id: id,
    teacherId: 't1',
    title: title,
    description: null,
    sourceLanguage: 'en',
    targetLanguage: 'tr',
    scheduledLabel: schedule,
    status: status,
    isPublished: status != LessonStatus.draft,
    wordCount: words,
    createdAt: DateTime(2026, 6, 23),
    updatedAt: DateTime(2026, 6, 23),
  );
}

void main() {
  testWidgets('Boş liste → boş durum + oluştur butonu', (tester) async {
    await tester.pumpWidget(_wrap(FakeLessonsRepository(lessons: const [])));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('+ Yeni Ders Oluştur'), findsOneWidget);
    expect(find.text('Henüz dersiniz yok'), findsOneWidget);
  });

  testWidgets('Ders kartı tarih, kelime sayısı ve durum rozetini gösterir',
      (tester) async {
    await tester.pumpWidget(
      _wrap(FakeLessonsRepository(lessons: [
        _lesson(title: 'Unit 4: Food', status: LessonStatus.active, words: 12),
        _lesson(
            id: 'l2',
            title: 'Unit 3: Family',
            status: LessonStatus.completed,
            words: 15),
      ])),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Unit 4: Food'), findsOneWidget);
    expect(find.text('15 - 21 Temmuz 2024'), findsNWidgets(2));
    expect(find.text('12 Kelime'), findsOneWidget);
    // Durum rozetleri (büyük harf).
    expect(find.text('AKTİF'), findsOneWidget);
    expect(find.text('TAMAMLANDI'), findsOneWidget);
    expect(find.text('Toplam: 2'), findsOneWidget);
  });
}
