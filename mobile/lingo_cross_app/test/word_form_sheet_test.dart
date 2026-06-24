import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/lessons/data/lessons_repository.dart';
import 'package:lingo_cross_app/features/lessons/presentation/widgets/word_form_sheet.dart';

import 'helpers/fake_lessons_repository.dart';

/// F9.2: kelime ekleme formundaki karşılık (meaning) etiketi dersin HEDEF
/// diline göre dinamiktir; terim etiketi KAYNAK diline göre.
Widget _wrap({
  required String sourceLangLabel,
  required String targetLangLabel,
  Locale locale = const Locale('tr'),
}) {
  return ProviderScope(
    overrides: [
      lessonsRepositoryProvider.overrideWithValue(FakeLessonsRepository()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: WordFormSheet(
          lessonId: 'l1',
          sourceLangLabel: sourceLangLabel,
          targetLangLabel: targetLangLabel,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets(
      'meaning etiketi hedef dile (Almanca) göre; terim etiketi kaynak dile (İngilizce) göre',
      (tester) async {
    await tester.pumpWidget(
      _wrap(sourceLangLabel: 'İngilizce', targetLangLabel: 'Almanca'),
    );
    await tester.pumpAndSettle();

    // "Almanca Karşılık(lar)" — hedef dile göre.
    expect(find.text('Almanca Karşılık(lar)'), findsOneWidget);
    // Eski sabit "Türkçe Karşılık(lar)" görünmemeli.
    expect(find.text('Türkçe Karşılık(lar)'), findsNothing);
    // Terim etiketi kaynak dile göre.
    expect(find.text('Terim (İngilizce)'), findsOneWidget);
  });

  testWidgets('EN locale: meaning etiketi "{lang} meaning(s)" biçiminde',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        sourceLangLabel: 'German',
        targetLangLabel: 'Spanish',
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Spanish meaning(s)'), findsOneWidget);
    expect(find.text('Term (German)'), findsOneWidget);
  });
}
