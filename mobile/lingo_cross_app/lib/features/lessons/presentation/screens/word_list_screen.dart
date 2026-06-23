import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/dtos/word_dtos.dart';
import '../../domain/language_option.dart';
import '../lessons_notifier.dart';
import '../word_form_controller.dart';
import '../words_notifier.dart';
import '../widgets/skeleton_card.dart';
import '../widgets/word_card.dart';
import '../widgets/word_form_sheet.dart';

/// Ders kelimeleri: liste + manuel ekle/düzenle/sil (word-list-entry.md).
///
/// OCR akışı (Kameradan Tara) M2'de #18'de ayrı; burada pasif yer tutucu
/// ("Yakında") olarak gösterilir.
class WordListScreen extends ConsumerWidget {
  const WordListScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lessonAsync = ref.watch(lessonProvider(lessonId));
    final wordsAsync = ref.watch(wordsNotifierProvider(lessonId));

    final title = lessonAsync.maybeWhen(
      data: (l) => l.title,
      orElse: () => '',
    );
    final sourceLang = lessonAsync.maybeWhen(
      data: (l) => l.sourceLanguage,
      orElse: () => LanguageOption.defaultSource,
    );
    final targetLang = lessonAsync.maybeWhen(
      data: (l) => l.targetLanguage,
      orElse: () => LanguageOption.defaultTarget,
    );
    final sourceLabel =
        LanguageOption.fromCode(sourceLang).label(l10n);

    Future<void> openAdd() async {
      await WordFormSheet.show(
        context,
        lessonId: lessonId,
        sourceLangLabel: sourceLabel,
      );
    }

    void openScan() {
      context.push(AppRoutes.lessonOcrCapture(lessonId));
    }

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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
            onSelected: (v) {
              if (v == 'edit') {
                context.push(AppRoutes.lessonEdit(lessonId));
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Text(l10n.wordsListMenuEditLesson),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: wordsAsync.maybeWhen(
        data: (words) => words.isEmpty
            ? null
            : FloatingActionButton.extended(
                onPressed: openAdd,
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                icon: const Icon(Icons.add),
                label: Text(l10n.wordsListAddManual),
              ),
        orElse: () => null,
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
            _Summary(
              countAsync: wordsAsync,
              sourceCode: sourceLang,
              targetCode: targetLang,
              onScan: openScan,
              onAdd: openAdd,
            ),
            const SizedBox(height: AppSpacing.lg),
            wordsAsync.when(
              loading: () => const SkeletonList(count: 5, height: 88),
              error: (_, __) => _WordsError(
                onRetry: () => ref
                    .read(wordsNotifierProvider(lessonId).notifier)
                    .refresh(),
              ),
              data: (words) {
                if (words.isEmpty) {
                  return _EmptyWords(
                    onScan: openScan,
                    onAdd: openAdd,
                  );
                }
                // En son eklenen üstte (createdAt desc).
                final sorted = [...words]
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                return Column(
                  children: [
                    for (final word in sorted) ...[
                      WordCard(
                        word: word,
                        onTap: () => _openEdit(
                            context, ref, word, sourceLabel),
                        onDelete: () =>
                            _deleteWord(context, ref, l10n, word),
                      ),
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

  Future<void> _openEdit(
    BuildContext context,
    WidgetRef ref,
    WordDto word,
    String sourceLabel,
  ) async {
    await WordFormSheet.show(
      context,
      lessonId: lessonId,
      sourceLangLabel: sourceLabel,
      word: word,
    );
  }

  Future<void> _deleteWord(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    WordDto word,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok =
        await ref.read(wordFormControllerProvider.notifier).delete(lessonId, word.id);
    if (!context.mounted) return;
    if (ok) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.wordsListDeleted)));
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.wordsFormError)));
    }
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.countAsync,
    required this.sourceCode,
    required this.targetCode,
    required this.onScan,
    required this.onAdd,
  });

  final AsyncValue<List<WordDto>> countAsync;
  final String sourceCode;
  final String targetCode;
  final VoidCallback onScan;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final count = countAsync.maybeWhen(data: (w) => w.length, orElse: () => 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(l10n.wordsListCount(count), style: AppTypography.headlineMd),
            const SizedBox(width: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs, vertical: AppSpacing.base),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                l10n.wordsListLangDir(
                  languageShortLabel(sourceCode),
                  languageShortLabel(targetCode),
                ),
                style:
                    AppTypography.labelSm.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: onScan,
                icon: const Icon(Icons.camera_alt),
                label: Text(l10n.wordsListScan),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: Text(l10n.wordsListAddManual),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyWords extends StatelessWidget {
  const _EmptyWords({required this.onScan, required this.onAdd});

  final VoidCallback onScan;
  final VoidCallback onAdd;

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
          Text(l10n.wordsListEmptyTitle,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.base),
          Text(
            l10n.wordsListEmptyDesc,
            textAlign: TextAlign.center,
            style:
                AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: onScan,
            icon: const Icon(Icons.camera_alt),
            label: Text(l10n.wordsListScan),
          ),
          const SizedBox(height: AppSpacing.xs),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(l10n.wordsListAddManual),
          ),
        ],
      ),
    );
  }
}

class _WordsError extends StatelessWidget {
  const _WordsError({required this.onRetry});

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
          Text(l10n.wordsListError,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}