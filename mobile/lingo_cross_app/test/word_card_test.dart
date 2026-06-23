import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_colors.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/lessons/data/dtos/word_dtos.dart';
import 'package:lingo_cross_app/features/lessons/domain/word_source.dart';
import 'package:lingo_cross_app/features/lessons/presentation/widgets/word_card.dart';

WordDto _word({
  required WordSource source,
  List<TranslationDto> translations = const [],
  List<SynonymDto> synonyms = const [],
}) {
  final now = DateTime(2026, 1, 1);
  return WordDto(
    id: 'w1',
    lessonId: 'l1',
    term: 'apple',
    sortOrder: 0,
    source: source,
    translations: translations,
    synonyms: synonyms,
    createdAt: now,
    updatedAt: now,
  );
}

Widget _wrap(WordDto word, {VoidCallback? onTap, VoidCallback? onDelete}) {
  return MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('tr'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: WordCard(
        word: word,
        onTap: onTap ?? () {},
        onDelete: onDelete ?? () {},
      ),
    ),
  );
}

void main() {
  testWidgets('OCR kaynak rozeti nötr (outline) renkte gösterilir',
      (tester) async {
    await tester.pumpWidget(_wrap(_word(
      source: WordSource.ocr,
      translations: const [
        TranslationDto(id: 't1', text: 'elma', isPrimary: true),
      ],
    )));
    await tester.pumpAndSettle();

    expect(find.text('OCR'), findsOneWidget);
    expect(find.byIcon(Icons.document_scanner), findsOneWidget);

    final badgeText = tester.widget<Text>(find.text('OCR'));
    expect(badgeText.style?.color, AppColors.outline);
  });

  testWidgets('MANUEL kaynak rozeti amber (secondary-fixed) renkte gösterilir',
      (tester) async {
    await tester.pumpWidget(_wrap(_word(
      source: WordSource.manual,
      translations: const [
        TranslationDto(id: 't1', text: 'kitap', isPrimary: true),
      ],
    )));
    await tester.pumpAndSettle();

    expect(find.text('MANUEL'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);

    final badgeText = tester.widget<Text>(find.text('MANUEL'));
    expect(badgeText.style?.color, AppColors.onSecondaryFixedVariant);
  });

  testWidgets('Birincil karşılık yıldız ikonlu chip olarak gösterilir',
      (tester) async {
    await tester.pumpWidget(_wrap(_word(
      source: WordSource.manual,
      translations: const [
        TranslationDto(id: 't1', text: 'kitap', isPrimary: true),
        TranslationDto(id: 't2', text: 'defter', isPrimary: false),
      ],
    )));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.text('kitap'), findsOneWidget);
    expect(find.text('defter'), findsOneWidget);
  });

  testWidgets('Eş anlamlı satırı ayraç ile gösterilir', (tester) async {
    await tester.pumpWidget(_wrap(_word(
      source: WordSource.manual,
      translations: const [
        TranslationDto(id: 't1', text: 'kitap', isPrimary: true),
      ],
      synonyms: const [SynonymDto(id: 's1', text: 'tome')],
    )));
    await tester.pumpAndSettle();

    expect(find.byType(Divider), findsOneWidget);
    final richText = tester.widget<RichText>(
      find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains('eş anlamlı:'),
      ),
    );
    expect(richText.text.toPlainText(), contains('tome'));
  });

  testWidgets('Sil ikonu kırmızı ve ≥48px dokunma hedefi', (tester) async {
    var deleted = false;
    await tester.pumpWidget(_wrap(
      _word(
        source: WordSource.ocr,
        translations: const [
          TranslationDto(id: 't1', text: 'elma', isPrimary: true),
        ],
      ),
      onDelete: () => deleted = true,
    ));
    await tester.pumpAndSettle();

    final deleteIcon = tester.widget<Icon>(find.byIcon(Icons.delete));
    expect(deleteIcon.color, AppColors.error);

    await tester.tap(find.byIcon(Icons.delete));
    expect(deleted, isTrue);
  });

  testWidgets('Karta dokununca onTap tetiklenir (düzenleme)', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(
      _word(
        source: WordSource.manual,
        translations: const [
          TranslationDto(id: 't1', text: 'kitap', isPrimary: true),
        ],
      ),
      onTap: () => tapped = true,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('apple'));
    expect(tapped, isTrue);
  });
}
