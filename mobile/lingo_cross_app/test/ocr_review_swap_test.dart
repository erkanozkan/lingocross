import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/lessons/domain/ocr_line_parser.dart';
import 'package:lingo_cross_app/features/lessons/presentation/screens/ocr_review_screen.dart';

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/review',
    routes: [
      GoRoute(
        path: '/review',
        builder: (_, __) => const OcrReviewScreen(
          lessonId: 'l1',
          args: OcrReviewArgs(
            candidates: [OcrCandidate(term: 'elma', meaning: 'apple')],
            sourceLangLabel: 'İngilizce',
            targetLangLabel: 'Türkçe',
          ),
        ),
      ),
    ],
  );
  return ProviderScope(
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
  testWidgets('⇄ butonu terim ve karşılık alanlarının içeriğini takas eder',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    // Başlangıç: term=elma, meaning=apple.
    expect(find.widgetWithText(TextField, 'elma'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'apple'), findsOneWidget);

    final swapButton = find.byIcon(Icons.swap_horiz);
    expect(swapButton, findsOneWidget);

    await tester.tap(swapButton);
    await tester.pumpAndSettle();

    // Terim alanı: ilk TextField (term Row'unda, headlineMd). Karşılık: ikinci.
    final fields = tester.widgetList<TextField>(find.byType(TextField)).toList();
    final termField = fields[0];
    final meaningField = fields[1];

    // Takas sonrası terim 'apple', karşılık 'elma' olmalı.
    expect(termField.controller!.text, 'apple');
    expect(meaningField.controller!.text, 'elma');
  });
}
