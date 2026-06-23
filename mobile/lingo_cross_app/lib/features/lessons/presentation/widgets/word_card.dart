import 'package:flutter/material.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/dtos/word_dtos.dart';
import '../../domain/word_source.dart';

/// Kelime listesi kart öğesi (word-list-entry.md §3.3).
///
/// Terim + kaynak rozeti (OCR/Manuel) + karşılık chip'leri (primary dolu/star)
/// + opsiyonel eşanlam satırı. Tek dokunma kart → düzenle; sağda sil aksiyonu.
class WordCard extends StatelessWidget {
  const WordCard({
    super.key,
    required this.word,
    required this.onTap,
    required this.onDelete,
  });

  final WordDto word;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primary = word.translations.where((t) => t.isPrimary).toList();
    final others = word.translations.where((t) => !t.isPrimary).toList();

    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.outlineVariant),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            word.term,
                            style: AppTypography.headlineMd,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _SourceBadge(source: word.source),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        for (final t in primary) _PrimaryChip(text: t.text),
                        for (final t in others) _OtherChip(text: t.text),
                      ],
                    ),
                    if (word.synonyms.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      RichText(
                        text: TextSpan(
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                          children: [
                            TextSpan(
                              text: '${l10n.wordsListSynonymPrefix} ',
                              style: AppTypography.bodyMd.copyWith(
                                color: AppColors.outline,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                                text: word.synonyms
                                    .map((s) => s.text)
                                    .join(', ')),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.wordsListDeleted,
                constraints:
                    const BoxConstraints(minWidth: 48, minHeight: 48),
                onPressed: onDelete,
                icon: const Icon(Icons.delete, color: AppColors.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceBadge extends StatelessWidget {
  const _SourceBadge({required this.source});

  final WordSource source;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isOcr = source.isOcr;
    // OCR → nötr (surface-container-low + outline); MANUEL → amber
    // (secondary-fixed + on-secondary-fixed-variant), Stitch tasarımı.
    final bg = isOcr ? AppColors.surfaceContainerLow : AppColors.secondaryFixed;
    final border =
        isOcr ? AppColors.outlineVariant : AppColors.secondaryContainer;
    final fg = isOcr ? AppColors.outline : AppColors.onSecondaryFixedVariant;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isOcr ? Icons.document_scanner : Icons.edit, size: 12, color: fg),
          const SizedBox(width: 2),
          Text(
            (isOcr ? l10n.wordsListSourceOcr : l10n.wordsListSourceManual)
                .toUpperCase(),
            style: AppTypography.labelSm.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryChip extends StatelessWidget {
  const _PrimaryChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs, vertical: AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 16, color: AppColors.onPrimaryContainer),
          const SizedBox(width: AppSpacing.base),
          Text(text,
              style: AppTypography.labelLg
                  .copyWith(color: AppColors.onPrimaryContainer)),
        ],
      ),
    );
  }
}

class _OtherChip extends StatelessWidget {
  const _OtherChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs, vertical: AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(text,
          style: AppTypography.labelSm
              .copyWith(color: AppColors.onSurfaceVariant)),
    );
  }
}
