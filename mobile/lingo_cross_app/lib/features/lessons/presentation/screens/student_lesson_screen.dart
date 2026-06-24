import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../data/dtos/word_dtos.dart';
import '../lessons_notifier.dart';
import '../words_notifier.dart';
import '../widgets/skeleton_card.dart';

/// Öğrenci ders görünümü (read-only). Öğrenci bir derse dokununca terim +
/// Türkçe karşılıklar + eşanlam listesini görür. Ekle/düzenle/sil/OCR YOK.
/// "Oyna" butonu M4 placeholder ("Yakında").
class StudentLessonScreen extends ConsumerWidget {
  const StudentLessonScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lessonAsync = ref.watch(lessonProvider(lessonId));
    final wordsAsync = ref.watch(wordsNotifierProvider(lessonId));

    final title = lessonAsync.maybeWhen(data: (l) => l.title, orElse: () => '');

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          title,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      bottomNavigationBar: _PlayBar(
        onPlay: () => context.push(AppRoutes.studentGame(lessonId)),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(wordsNotifierProvider(lessonId).notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.md,
            AppSpacing.marginMobile,
            AppSpacing.xl,
          ),
          children: [
            wordsAsync.when(
              loading: () => const SkeletonList(count: 5, height: 88),
              error: (_, __) => _ErrorCard(
                onRetry: () => ref
                    .read(wordsNotifierProvider(lessonId).notifier)
                    .refresh(),
              ),
              data: (words) {
                if (words.isEmpty) return const _EmptyWords();
                final sorted = [...words]
                  ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.wordsListCount(words.length),
                      style: AppTypography.headlineMd,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    for (final word in sorted) ...[
                      _ReadOnlyWordCard(word: word),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Read-only kelime kartı: terim + Türkçe karşılıklar (birincil yıldızlı) +
/// eşanlam satırı. Düzenle/sil aksiyonu YOK.
class _ReadOnlyWordCard extends StatelessWidget {
  const _ReadOnlyWordCard({required this.word});

  final WordDto word;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primary = word.translations.where((t) => t.isPrimary).toList();
    final others = word.translations.where((t) => !t.isPrimary).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            word.term,
            style: AppTypography.headlineMd,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
            const SizedBox(height: AppSpacing.xs),
            RichText(
              text: TextSpan(
                style: AppTypography.labelSm
                    .copyWith(color: AppColors.onSurfaceVariant),
                children: [
                  TextSpan(
                    text: '${l10n.wordsListSynonymPrefix} ',
                    style: AppTypography.labelSm
                        .copyWith(color: AppColors.outline),
                  ),
                  TextSpan(
                    text: word.synonyms.map((s) => s.text).join(', '),
                  ),
                ],
              ),
            ),
          ],
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
          const Icon(Icons.star, size: 14, color: AppColors.onPrimary),
          const SizedBox(width: AppSpacing.base),
          Text(text,
              style: AppTypography.labelLg.copyWith(color: AppColors.onPrimary)),
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

/// Alt çubuk: "Oyna" (M4 placeholder → "Yakında").
class _PlayBar extends StatelessWidget {
  const _PlayBar({required this.onPlay});

  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      color: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.sm,
            AppSpacing.marginMobile,
            AppSpacing.sm,
          ),
          child: PrimaryButton3D(
            label: l10n.studentLessonPlay,
            trailingIcon: Icons.play_arrow,
            onPressed: onPlay,
          ),
        ),
      ),
    );
  }
}

class _EmptyWords extends StatelessWidget {
  const _EmptyWords();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          const Icon(Icons.spellcheck, color: AppColors.primary, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.studentLessonEmptyTitle,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.base),
          Text(
            l10n.studentLessonEmptyDesc,
            textAlign: TextAlign.center,
            style:
                AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off, color: AppColors.error, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.studentLessonError,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}
