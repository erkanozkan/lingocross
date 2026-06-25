import 'dart:async';

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
import 'package:lingo_cross_app/features/lessons/presentation/screens/ocr_capture_screen.dart';
import 'package:lingo_cross_app/features/lessons/presentation/screens/word_list_screen.dart';
import 'package:lingo_cross_app/features/subscription/data/dtos/subscription_dtos.dart';
import 'package:lingo_cross_app/features/subscription/presentation/subscription_notifier.dart';

import 'helpers/fake_lessons_repository.dart';
import 'helpers/fake_subscription_repository.dart';

/// Test amaçlı subscription notifier: önceden belirlenen [value]'yu döner.
/// [loadingForever] true ise build hiç tamamlanmaz → AsyncLoading'de kalır.
class _StubSubscriptionNotifier extends SubscriptionNotifier {
  _StubSubscriptionNotifier({this.value, this.loadingForever = false});

  final SubscriptionDto? value;
  final bool loadingForever;

  @override
  Future<SubscriptionDto> build() {
    if (loadingForever) return Completer<SubscriptionDto>().future;
    return Future.value(value);
  }
}

LessonDto _lesson({String id = 'l1'}) => LessonDto(
      id: id,
      teacherId: 't1',
      title: 'Ünite 4',
      description: null,
      sourceLanguage: 'en',
      targetLanguage: 'tr',
      status: LessonStatus.draft,
      isPublished: false,
      wordCount: 6,
      createdAt: DateTime(2026, 6, 23),
      updatedAt: DateTime(2026, 6, 23),
    );

Widget _wrap({
  required Widget home,
  required SubscriptionNotifier Function() subOverride,
  required List<String> pushedRoutes,
}) {
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/home', builder: (_, __) => home),
      GoRoute(
        path: '/paywall',
        builder: (context, state) {
          pushedRoutes.add(state.uri.toString());
          return const Scaffold(body: Text('PAYWALL'));
        },
      ),
      GoRoute(
        path: '/teacher/lessons/:id/ocr',
        builder: (_, __) {
          pushedRoutes.add('ocr-capture');
          return const Scaffold(body: Text('CAPTURE'));
        },
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      lessonsRepositoryProvider.overrideWithValue(
        FakeLessonsRepository(lessons: [_lesson()]),
      ),
      subscriptionNotifierProvider.overrideWith(subOverride),
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

void main() {
  group('BUG 2 — word_list openScan default-deny', () {
    Future<void> tapScan(WidgetTester tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('tr'));
      final scan = find.text(l10n.wordsListScan).first;
      await tester.ensureVisible(scan);
      await tester.pumpAndSettle();
      await tester.tap(scan, warnIfMissed: false);
      await tester.pumpAndSettle();
    }

    testWidgets('free → /paywall?feature=ocr (capture açılmaz)', (tester) async {
      final pushed = <String>[];
      await tester.pumpWidget(_wrap(
        home: const WordListScreen(lessonId: 'l1'),
        subOverride: () =>
            _StubSubscriptionNotifier(value: freeSubscription()),
        pushedRoutes: pushed,
      ));
      await tester.pumpAndSettle();
      await tapScan(tester);

      expect(pushed.any((r) => r.contains('feature=ocr')), isTrue);
      expect(pushed.contains('ocr-capture'), isFalse);
      expect(find.text('PAYWALL'), findsOneWidget);
    });

    testWidgets('loading → /paywall (default-deny, tarama açılmaz)',
        (tester) async {
      final pushed = <String>[];
      await tester.pumpWidget(_wrap(
        home: const WordListScreen(lessonId: 'l1'),
        subOverride: () => _StubSubscriptionNotifier(loadingForever: true),
        pushedRoutes: pushed,
      ));
      await tester.pump();
      await tapScan(tester);

      expect(pushed.any((r) => r.contains('feature=ocr')), isTrue);
      expect(pushed.contains('ocr-capture'), isFalse);
    });

    testWidgets('premium → capture açılır', (tester) async {
      final pushed = <String>[];
      await tester.pumpWidget(_wrap(
        home: const WordListScreen(lessonId: 'l1'),
        subOverride: () =>
            _StubSubscriptionNotifier(value: premiumSubscription()),
        pushedRoutes: pushed,
      ));
      await tester.pumpAndSettle();
      await tapScan(tester);

      expect(pushed.contains('ocr-capture'), isTrue);
      expect(pushed.any((r) => r.contains('feature=ocr')), isFalse);
    });
  });

  group('BUG 2 — OcrCaptureScreen guard (savunma derinliği)', () {
    testWidgets('free → capture gösterilmez, paywall\'a yönlenir',
        (tester) async {
      final pushed = <String>[];
      await tester.pumpWidget(_wrap(
        home: const OcrCaptureScreen(lessonId: 'l1'),
        subOverride: () =>
            _StubSubscriptionNotifier(value: freeSubscription()),
        pushedRoutes: pushed,
      ));
      await tester.pumpAndSettle();

      // Capture içeriği (Kelimeleri Çıkart vb.) görünmez; paywall'a gidilir.
      expect(find.text('PAYWALL'), findsOneWidget);
      expect(pushed.any((r) => r.contains('feature=ocr')), isTrue);
    });

    testWidgets('premium → capture normal görünür', (tester) async {
      final pushed = <String>[];
      final l10n = await AppLocalizations.delegate.load(const Locale('tr'));
      await tester.pumpWidget(_wrap(
        home: const OcrCaptureScreen(lessonId: 'l1'),
        subOverride: () =>
            _StubSubscriptionNotifier(value: premiumSubscription()),
        pushedRoutes: pushed,
      ));
      await tester.pumpAndSettle();

      expect(find.text('PAYWALL'), findsNothing);
      // Yakalama ekranı başlığı görünür.
      expect(find.text(l10n.ocrCaptureTitle), findsOneWidget);
    });
  });
}
