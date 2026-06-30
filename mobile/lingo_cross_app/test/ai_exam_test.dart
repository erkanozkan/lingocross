import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/classes/data/classes_repository.dart';
import 'package:lingo_cross_app/features/classes/data/dtos/class_dtos.dart';
import 'package:lingo_cross_app/features/games/data/ai_exam_repository.dart';
import 'package:lingo_cross_app/features/games/data/dtos/ai_exam_dtos.dart';
import 'package:lingo_cross_app/features/games/data/games_repository.dart';
import 'package:lingo_cross_app/features/games/domain/ai_question_type.dart';
import 'package:lingo_cross_app/features/games/domain/games_failure.dart';
import 'package:lingo_cross_app/features/games/presentation/screens/ai_exam_create_screen.dart';
import 'package:lingo_cross_app/features/games/presentation/screens/ai_exam_review_screen.dart';
import 'package:lingo_cross_app/features/lessons/data/dtos/lesson_dtos.dart';
import 'package:lingo_cross_app/features/lessons/data/lessons_repository.dart';
import 'package:lingo_cross_app/features/lessons/domain/lesson_status.dart';

import 'helpers/fake_ai_exam_repository.dart';
import 'helpers/fake_classes_repository.dart';
import 'helpers/fake_games_repository.dart';
import 'helpers/fake_lessons_repository.dart';

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
    wordCount: 12,
    createdAt: DateTime(2026, 6, 23),
    updatedAt: DateTime(2026, 6, 23),
  );
}

ClassDto _class({String id = 'cls1', String name = '6-A'}) {
  return ClassDto(
    id: id,
    name: name,
    inviteCode: 'A1B2C3D4',
    studentCount: 12,
    createdAt: DateTime(2026, 6, 23),
  );
}

AiExamResultDto _result({int questionCount = 2}) {
  return AiExamResultDto(
    topicId: 'topic-1',
    title: 'Ünite 4',
    grade: 6,
    lessonId: 'l1',
    questions: [
      for (var i = 0; i < questionCount; i++)
        AiGeneratedQuestion(
          id: 'q${i + 1}',
          type: 'word_meaning',
          stem: 'Soru kökü ${i + 1}?',
          explanation: 'Açıklama metni ${i + 1}.',
          options: [
            AiGeneratedQuestionOption(
                id: 'o${i}a', position: 0, text: 'Şık A', isCorrect: false),
            AiGeneratedQuestionOption(
                id: 'o${i}b', position: 1, text: 'Şık B', isCorrect: true),
            AiGeneratedQuestionOption(
                id: 'o${i}c', position: 2, text: 'Şık C', isCorrect: false),
            AiGeneratedQuestionOption(
                id: 'o${i}d', position: 3, text: 'Şık D', isCorrect: false),
          ],
        ),
    ],
  );
}

Widget _wrapCreate({
  required FakeLessonsRepository lessonsRepo,
  required FakeClassesRepository classesRepo,
  required FakeAiExamRepository aiRepo,
  FakeGamesRepository? gamesRepo,
  List<String>? wentTo,
  String? initialLessonId,
}) {
  final router = GoRouter(
    initialLocation: '/create',
    routes: [
      GoRoute(
        path: '/create',
        builder: (_, __) => AiExamCreateScreen(initialLessonId: initialLessonId),
      ),
      GoRoute(
        path: '/teacher',
        builder: (_, __) {
          wentTo?.add('/teacher');
          return const Scaffold(body: Text('TEACHER_HOME'));
        },
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      lessonsRepositoryProvider.overrideWithValue(lessonsRepo),
      classesRepositoryProvider.overrideWithValue(classesRepo),
      aiExamRepositoryProvider.overrideWithValue(aiRepo),
      gamesRepositoryProvider
          .overrideWithValue(gamesRepo ?? FakeGamesRepository()),
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

Widget _wrapReview({
  required AiExamResultDto result,
  required FakeAiExamRepository aiRepo,
  required FakeGamesRepository gamesRepo,
  String className = '6-A',
  String classId = 'cls1',
  List<String>? events,
}) {
  return ProviderScope(
    overrides: [
      aiExamRepositoryProvider.overrideWithValue(aiRepo),
      gamesRepositoryProvider.overrideWithValue(gamesRepo),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('tr'),
      home: AiExamReviewScreen(
        result: result,
        className: className,
        classId: classId,
        onRegenerate: () => events?.add('regenerate'),
        onAssigned: () => events?.add('assigned'),
      ),
    ),
  );
}

/// Yükleme ekranı sonsuz animasyon içerir; pumpAndSettle takılır. Fake repo
/// senkron çözer → review'a geçiş için birkaç pump yeterli.
Future<void> _settleAfterGenerate(WidgetTester tester) async {
  await tester.pump(); // generate başlat (loading)
  await tester.pump(); // future tamamlanır → review
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  group('AiExamGenerateRequest / AiExamResultDto JSON round-trip', () {
    test('request toJson camelCase + types', () {
      const req = AiExamGenerateRequest(
        grade: 6,
        count: 8,
        types: ['word_meaning', 'fill_blank'],
      );
      expect(req.toJson(), {
        'grade': 6,
        'count': 8,
        'types': ['word_meaning', 'fill_blank'],
      });
    });

    test('result fromJson/toJson preserves nested options', () {
      final json = {
        'topicId': 't1',
        'title': 'Ünite 4',
        'grade': 6,
        'lessonId': 'l1',
        'questions': [
          {
            'id': 'q1',
            'type': 'fill_blank',
            'stem': 'I like ___ soup.',
            'explanation': null,
            'options': [
              {'id': 'o1', 'position': 0, 'text': 'Lentil', 'isCorrect': true},
              {'id': 'o2', 'position': 1, 'text': 'Juice', 'isCorrect': false},
            ],
          },
        ],
      };
      final dto = AiExamResultDto.fromJson(json);
      expect(dto.topicId, 't1');
      expect(dto.questions.single.explanation, isNull);
      expect(dto.questions.single.options.first.isCorrect, isTrue);
      expect(AiExamResultDto.fromJson(dto.toJson()), dto);
    });
  });

  group('Config ekranı', () {
    testWidgets('Stitch alanları + varsayılan tür/sayı render', (tester) async {
      await tester.pumpWidget(_wrapCreate(
        lessonsRepo: FakeLessonsRepository(lessons: [_lesson()]),
        classesRepo: FakeClassesRepository(classes: [_class()]),
        aiRepo: FakeAiExamRepository(),
      ));
      await tester.pumpAndSettle();

      // Üst bölüm (kaydırmadan görünür) + bottomNavigationBar butonu.
      expect(find.text('Sınav Soruları Oluştur'), findsWidgets);
      expect(find.text('Ders Seç'), findsOneWidget);
      expect(find.text('Sınıf Seç'), findsOneWidget);
      expect(find.text('Sınıf Seviyesi'), findsOneWidget);
      // Buton bottomNavigationBar'da → her zaman görünür.
      expect(find.text('Yapay Zeka ile Soru Oluştur'), findsOneWidget);

      // Alt alanlar (Soru Türleri / chip'ler / sayı) fold altında → kaydır.
      await tester.dragUntilVisible(
        find.text('Eş Anlam'),
        find.byType(ListView),
        const Offset(0, -250),
      );
      await tester.pumpAndSettle();
      expect(find.text('Soru Türleri'), findsOneWidget);
      expect(find.text('Kelime-Anlam'), findsOneWidget);
      expect(find.text('Boşluk Doldurma'), findsOneWidget);
      expect(find.text('Eş Anlam'), findsOneWidget);
      // Varsayılan soru sayısı 10 (stepper).
      expect(find.text('10'), findsWidgets);
    });

    testWidgets('Ders seçilmeden buton pasif → generate çağrılmaz',
        (tester) async {
      final ai = FakeAiExamRepository();
      await tester.pumpWidget(_wrapCreate(
        lessonsRepo: FakeLessonsRepository(lessons: [_lesson()]),
        classesRepo: FakeClassesRepository(classes: [_class()]),
        aiRepo: ai,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yapay Zeka ile Soru Oluştur'),
          warnIfMissed: false);
      await tester.pump();
      expect(ai.generateCount, 0);
    });

    testWidgets('Tüm türler kaldırılınca uyarı görünür', (tester) async {
      await tester.pumpWidget(_wrapCreate(
        lessonsRepo: FakeLessonsRepository(lessons: [_lesson()]),
        classesRepo: FakeClassesRepository(classes: [_class()]),
        aiRepo: FakeAiExamRepository(),
        initialLessonId: 'l1',
      ));
      await tester.pumpAndSettle();

      // Tür chip'leri fold altında olabilir → görünür yap.
      await tester.dragUntilVisible(
        find.text('Kelime-Anlam'),
        find.byType(ListView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      // Varsayılan seçili tek tür (Kelime-Anlam) kaldırılır → uyarı.
      await tester.tap(find.text('Kelime-Anlam'));
      await tester.pumpAndSettle();
      expect(find.text('En az bir soru türü seç.'), findsOneWidget);
    });

    testWidgets('Oluştur → repo.generate doğru argümanlarla + review',
        (tester) async {
      final ai = FakeAiExamRepository(generateValue: _result());
      await tester.pumpWidget(_wrapCreate(
        lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
        classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
        aiRepo: ai,
        initialLessonId: 'l1',
      ));
      await tester.pumpAndSettle();

      // Sınıf seç (chip yatay listede üstte, görünür). Varsayılan tek tür
      // (Kelime-Anlam) seçili kalır.
      await tester.tap(find.text('6-A'));
      await tester.pumpAndSettle();

      // "Oluştur" butonu bottomNavigationBar'da → her zaman görünür.
      await tester.tap(find.text('Yapay Zeka ile Soru Oluştur'));
      await _settleAfterGenerate(tester);

      expect(ai.generateCount, 1);
      expect(ai.lastLessonId, 'l1');
      expect(ai.lastRequest?.grade, 6);
      expect(ai.lastRequest?.count, 10);
      expect(ai.lastRequest?.types, [AiQuestionType.wordMeaning.code]);
      // Review ekranına geçildi.
      expect(find.text('Üretilen Sorular'), findsOneWidget);
      expect(find.text('2 soru üretildi'), findsOneWidget);
    });

    testWidgets('Üretim 503 → config\'e dön + AI kapalı SnackBar',
        (tester) async {
      final ai = FakeAiExamRepository(
        generateError: const GamesFailure.aiUnavailable(),
      );
      await tester.pumpWidget(_wrapCreate(
        lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
        classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
        aiRepo: ai,
        initialLessonId: 'l1',
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('6-A'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yapay Zeka ile Soru Oluştur'));
      await _settleAfterGenerate(tester);

      expect(find.text('Yapay zekâ ile soru üretimi şu an kullanılamıyor.'),
          findsOneWidget);
      // Config'e dönüldü (üretme butonu yeniden görünür).
      expect(find.text('Yapay Zeka ile Soru Oluştur'), findsOneWidget);
    });

    testWidgets('Üretim 400 → yetersiz kelime SnackBar', (tester) async {
      final ai = FakeAiExamRepository(
        generateError: const GamesFailure.insufficientWords(),
      );
      await tester.pumpWidget(_wrapCreate(
        lessonsRepo: FakeLessonsRepository(lessons: [_lesson(id: 'l1')]),
        classesRepo: FakeClassesRepository(classes: [_class(id: 'cls1')]),
        aiRepo: ai,
        initialLessonId: 'l1',
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('6-A'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yapay Zeka ile Soru Oluştur'));
      await _settleAfterGenerate(tester);

      expect(find.text('Soru üretmek için ders yeterli kelime içermiyor.'),
          findsOneWidget);
    });
  });

  group('Review ekranı', () {
    testWidgets('Sorular + doğru-şık vurgusu + açıklama render', (tester) async {
      await tester.pumpWidget(_wrapReview(
        result: _result(),
        aiRepo: FakeAiExamRepository(),
        gamesRepo: FakeGamesRepository(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Soru 1'), findsOneWidget);
      expect(find.text('Soru kökü 1?'), findsOneWidget);
      expect(find.text('Şık B'), findsWidgets);
      // Doğru şık onay simgesiyle (ilk soruda bir adet doğru).
      expect(find.byIcon(Icons.check_circle), findsWidgets);
      expect(find.text('Açıklama:'), findsWidgets);
      expect(find.text('Öğrencilere Ata'), findsOneWidget);
      // İkinci soru kartı fold altında olabilir → kaydırarak doğrula.
      await tester.scrollUntilVisible(find.text('Soru 2'), 300);
      expect(find.text('Soru 2'), findsOneWidget);
      expect(find.text('Soru kökü 2?'), findsOneWidget);
    });

    testWidgets('Çöp ikonu → deleteQuestion + listeden çıkar', (tester) async {
      final ai = FakeAiExamRepository();
      await tester.pumpWidget(_wrapReview(
        result: _result(),
        aiRepo: ai,
        gamesRepo: FakeGamesRepository(),
      ));
      await tester.pumpAndSettle();

      // İlk sorunun sil ikonuna dokun.
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      expect(ai.deleteCount, 1);
      expect(ai.lastDeleteTopicId, 'topic-1');
      expect(ai.lastDeleteQuestionId, 'q1');
      // Soru 1 kalktı, Soru 2 yeniden numaralanır → "Soru 1" hâlâ var (eski q2).
      expect(find.text('Soru kökü 1?'), findsNothing);
      expect(find.text('Soru kökü 2?'), findsOneWidget);
    });

    testWidgets('Öğrencilere Ata → setTopicAssignments(topicId,[class]) + dönüş',
        (tester) async {
      final games = FakeGamesRepository();
      final events = <String>[];
      await tester.pumpWidget(_wrapReview(
        result: _result(),
        aiRepo: FakeAiExamRepository(),
        gamesRepo: games,
        events: events,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Öğrencilere Ata'));
      await tester.pumpAndSettle();

      expect(games.setAssignmentsCount, 1);
      expect(games.lastAssignTopicId, 'topic-1');
      expect(games.lastAssignClassIds, ['cls1']);
      expect(find.text('Sorular sınıfa atandı.'), findsOneWidget);
      expect(events, contains('assigned'));
    });

    testWidgets('Tüm sorular silinince "Ata" pasif + boş durum',
        (tester) async {
      final games = FakeGamesRepository();
      await tester.pumpWidget(_wrapReview(
        result: _result(questionCount: 1),
        aiRepo: FakeAiExamRepository(),
        gamesRepo: games,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      expect(find.text('Tüm sorular silindi. Yeniden üret veya geri dön.'),
          findsOneWidget);
      // Boş listede "Ata" tetiklenmez.
      await tester.tap(find.text('Öğrencilere Ata'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(games.setAssignmentsCount, 0);
    });

    testWidgets('Yeniden Üret → onRegenerate callback', (tester) async {
      final events = <String>[];
      await tester.pumpWidget(_wrapReview(
        result: _result(),
        aiRepo: FakeAiExamRepository(),
        gamesRepo: FakeGamesRepository(),
        events: events,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yeniden Üret'));
      await tester.pumpAndSettle();
      expect(events, contains('regenerate'));
    });
  });
}
