import 'package:flutter/material.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../lessons/domain/language_option.dart';
import '../../data/dtos/game_dtos.dart';
import '../../domain/game_type.dart';

/// Bulmaca örnek önizleme bloğu (SALT-OKUNUR).
///
/// Sihirbazın önizleme adımında kaydetmeden önce üretilecek içeriği gösterir.
/// [GameType.wordMatching] → eşleşmiş iki sütun; [GameType.crossword] → statik
/// ızgara + ipucu listesi. İnteraktif DEĞİLDİR (dokunma/skor yok). Üstte
/// "bu bir örnek önizlemedir" notu yer alır.
class PuzzlePreview extends StatelessWidget {
  const PuzzlePreview({
    super.key,
    required this.preview,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  final GamePreviewResponse preview;

  /// Dersin KAYNAK/HEDEF dil kodu (ISO) — sütun başlıkları için (F9.2).
  final String sourceLanguage;
  final String targetLanguage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SampleNote(text: l10n.createGamePreviewSampleNote),
        const SizedBox(height: AppSpacing.lg),
        if (preview.type == GameType.crossword && preview.crossword != null)
          _CrosswordPreview(content: preview.crossword!)
        else if (preview.wordMatching != null)
          _WordMatchingPreview(
            content: preview.wordMatching!,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
          )
        else
          _SampleNote(text: l10n.createGamePreviewEmpty),
      ],
    );
  }
}

/// "Bu bir örnek önizlemedir" bilgi notu (tonal kart).
class _SampleNote extends StatelessWidget {
  const _SampleNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.visibility_outlined,
              size: 20, color: AppColors.onSecondaryFixedVariant),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.labelLg
                  .copyWith(color: AppColors.onSecondaryFixedVariant),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kelime Eşleştirme örnek görünümü: iki sütun (kaynak terim ↔ doğru karşılık)
/// eşleşmiş halde. Salt-okunur — dokunma/skor yok.
class _WordMatchingPreview extends StatelessWidget {
  const _WordMatchingPreview({
    required this.content,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  final WordMatchingContent content;
  final String sourceLanguage;
  final String targetLanguage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sourceLabel = LanguageOption.fromCode(sourceLanguage).label(l10n);
    final targetLabel = LanguageOption.fromCode(targetLanguage).label(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _ColumnHeading(label: sourceLabel)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _ColumnHeading(label: targetLabel)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final pair in content.pairs)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: _PreviewChip(
                    text: pair.term,
                    color: AppColors.primaryContainer,
                    fg: AppColors.onPrimaryContainer,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.base),
                  child: Icon(Icons.link,
                      size: 18, color: AppColors.onSurfaceVariant),
                ),
                Expanded(
                  child: _PreviewChip(
                    text: pair.correctTranslation,
                    color: AppColors.tertiaryContainer,
                    fg: AppColors.onTertiaryContainer,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ColumnHeading extends StatelessWidget {
  const _ColumnHeading({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.labelLg.copyWith(
        color: AppColors.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip({
    required this.text,
    required this.color,
    required this.fg,
  });

  final String text;
  final Color color;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodyMd.copyWith(color: fg),
      ),
    );
  }
}

/// Çengel Bulmaca örnek görünümü: statik ızgara (girişlerin kapladığı hücreler
/// boş kutu + başlangıç numarası; diğer hücreler koyu) + ipucu listesi. Cevap
/// harfleri gösterilmez — öğretmen yalnız yapıyı görür. Salt-okunur.
class _CrosswordPreview extends StatelessWidget {
  const _CrosswordPreview({required this.content});

  final CrosswordContent content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cells = _buildCells(content);
    final across = content.entries
        .where((e) => e.direction == CrosswordDirection.across)
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));
    final down = content.entries
        .where((e) => e.direction == CrosswordDirection.down)
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: AppShadows.soft,
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: content.rows * content.cols,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: content.cols,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemBuilder: (context, index) => _PreviewCell(cell: cells[index]),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _ClueList(
                icon: Icons.swap_horiz,
                color: AppColors.primary,
                heading: l10n.gameCrosswordAcross,
                entries: across,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _ClueList(
                icon: Icons.swap_vert,
                color: AppColors.tertiary,
                heading: l10n.gameCrosswordDown,
                entries: down,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Izgara hücrelerini düzleştirir: blok mu, bulmacaya mı ait, başlangıç numarası.
  static List<_PreviewCellData> _buildCells(CrosswordContent content) {
    final fillable = List<bool>.filled(content.rows * content.cols, false);
    final numbers = <int, int>{};
    for (final entry in content.entries) {
      for (var i = 0; i < entry.length; i++) {
        final r = entry.direction == CrosswordDirection.down
            ? entry.row + i
            : entry.row;
        final c = entry.direction == CrosswordDirection.across
            ? entry.col + i
            : entry.col;
        if (r < 0 || r >= content.rows || c < 0 || c >= content.cols) continue;
        fillable[r * content.cols + c] = true;
      }
      final startIdx = entry.row * content.cols + entry.col;
      // Aynı başlangıç hücresini paylaşan girişlerde en küçük numara gösterilir.
      final existing = numbers[startIdx];
      if (existing == null || entry.number < existing) {
        numbers[startIdx] = entry.number;
      }
    }
    return [
      for (var i = 0; i < fillable.length; i++)
        _PreviewCellData(fillable: fillable[i], number: numbers[i]),
    ];
  }
}

class _PreviewCellData {
  const _PreviewCellData({required this.fillable, this.number});

  final bool fillable;
  final int? number;
}

/// Statik ızgara hücresi. Boş kutu (bulmacaya ait) veya koyu (blok). Harf yok.
class _PreviewCell extends StatelessWidget {
  const _PreviewCell({required this.cell});

  final _PreviewCellData cell;

  @override
  Widget build(BuildContext context) {
    if (!cell.fillable) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.inverseSurface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: cell.number != null
          ? Padding(
              padding: const EdgeInsets.only(top: 1, left: 2),
              child: Text(
                '${cell.number}',
                style: const TextStyle(
                  fontSize: 8,
                  height: 1,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            )
          : null,
    );
  }
}

/// İpucu listesi (yön başlığı + numara + clue) — salt-okunur.
class _ClueList extends StatelessWidget {
  const _ClueList({
    required this.icon,
    required this.color,
    required this.heading,
    required this.entries,
  });

  final IconData icon;
  final Color color;
  final String heading;
  final List<CrosswordEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                heading,
                style: AppTypography.labelLg
                    .copyWith(color: color, letterSpacing: 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final entry in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.number}.',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.base),
                Expanded(
                  child: Text(
                    entry.clue,
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
