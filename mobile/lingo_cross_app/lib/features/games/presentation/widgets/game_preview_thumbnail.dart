import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/game_type.dart';

/// Oyun türüne göre **temsili** (dekoratif) mini görsel — gerçek oyun içeriği
/// DEĞİL. Stitch `55a66eca…` "Günün Oyunu" kartının sağındaki kare görseli
/// karşılar. Her tür için ayrı bir desen üretir:
///
/// - [GameType.crossword] → 5×5 mini bulmaca ızgarası (Stitch `crossword-grid`).
/// - [GameType.wordMatching] → iki sütun eşleşme (terim ↔ karşılık) deseni.
/// - [GameType.scrambled] → karışık harf kareleri.
/// - [GameType.questionSet] → (panelde gösterilmez) çoktan-seçmeli temsili;
///   bütünlük için bir varsayılan desen verilir.
class GamePreviewThumbnail extends StatelessWidget {
  const GamePreviewThumbnail({super.key, required this.type});

  final GameType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Center(child: _patternFor(type)),
    );
  }

  Widget _patternFor(GameType type) => switch (type) {
        GameType.crossword => const _CrosswordPattern(),
        GameType.wordMatching => const _MatchingPattern(),
        GameType.scrambled => const _ScrambledPattern(),
        GameType.questionSet => const _QuestionSetPattern(),
      };
}

/// 5×5 mini ızgara: bazı hücreler dolu (harf), bazıları boş (blok). Stitch
/// `crossword-grid` desenini yeniden üretir (temsili — sabit harf/blok dizilimi).
class _CrosswordPattern extends StatelessWidget {
  const _CrosswordPattern();

  // null = blok hücre, harf = dolu hücre (Stitch örnek dizilimi).
  static const List<String?> _cells = [
    'A', null, 'K', 'I', 'L', //
    null, 'S', null, null, 'A', //
    'K', 'O', 'N', 'U', 'Ş', //
    null, 'Z', null, null, null, //
    null, 'O', 'L', 'U', 'R', //
  ];

  @override
  Widget build(BuildContext context) {
    const cols = 5;
    return Semantics(
      label: 'Bulmaca önizlemesi',
      child: Wrap(
        spacing: AppSpacing.base,
        runSpacing: AppSpacing.base,
        children: [
          for (var i = 0; i < _cells.length; i++)
            _GridCell(letter: _cells[i], showAt: i % cols),
        ],
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({required this.letter, required this.showAt});

  final String? letter;
  final int showAt;

  @override
  Widget build(BuildContext context) {
    final filled = letter != null;
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled
            ? AppColors.surfaceContainerLowest
            : AppColors.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.base / 2),
        border: filled
            ? Border.all(color: AppColors.outlineVariant)
            : null,
      ),
      child: filled
          ? Text(
              letter!,
              style: AppTypography.labelSm.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            )
          : null,
    );
  }
}

/// İki sütun eşleşme deseni: solda terim, sağda karşılık (temsili pill'ler),
/// arada eşleşme okları. Kelime eşleştirme oyununu hissettirir.
class _MatchingPattern extends StatelessWidget {
  const _MatchingPattern();

  static const List<(String, String)> _pairs = [
    ('apple', 'elma'),
    ('book', 'kitap'),
    ('water', 'su'),
  ];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Eşleştirme önizlemesi',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < _pairs.length; i++) ...[
            Row(
              children: [
                Expanded(child: _MatchPill(_pairs[i].$1)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.base),
                  child: Icon(Icons.compare_arrows,
                      size: 16, color: AppColors.primary),
                ),
                Expanded(child: _MatchPill(_pairs[i].$2)),
              ],
            ),
            if (i != _pairs.length - 1)
              const SizedBox(height: AppSpacing.base),
          ],
        ],
      ),
    );
  }
}

class _MatchPill extends StatelessWidget {
  const _MatchPill(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs, vertical: AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.base),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.labelSm.copyWith(color: AppColors.primary),
      ),
    );
  }
}

/// Karışık harf kareleri: tek bir kelimenin harfleri rastgele dizilim hissiyle
/// kare kutucuklarda. Scrambled oyununu temsil eder.
class _ScrambledPattern extends StatelessWidget {
  const _ScrambledPattern();

  // "PPELA" → apple'ın karışığı (temsili).
  static const List<String> _letters = ['P', 'P', 'E', 'L', 'A'];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Karışık harfler önizlemesi',
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        alignment: WrapAlignment.center,
        children: [
          for (final l in _letters) _LetterTile(l),
        ],
      ),
    );
  }
}

class _LetterTile extends StatelessWidget {
  const _LetterTile(this.letter);

  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.base),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Text(
        letter,
        style: AppTypography.labelLg.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Çoktan-seçmeli temsili desen (questionSet — panelde "Günün Oyunu"nda
/// gösterilmez; sınavlar bölümünde ikon kullanılır). Bütünlük için sade.
class _QuestionSetPattern extends StatelessWidget {
  const _QuestionSetPattern();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Soru önizlemesi',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 3; i++) ...[
            _ChoiceRow(filled: i == 1),
            if (i != 2) const SizedBox(height: AppSpacing.base),
          ],
        ],
      ),
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          filled ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          size: 16,
          color: filled ? AppColors.primary : AppColors.outlineVariant,
        ),
        const SizedBox(width: AppSpacing.xs),
        Container(
          width: 64,
          height: 8,
          decoration: BoxDecoration(
            color: filled
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.outlineVariant.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
      ],
    );
  }
}
