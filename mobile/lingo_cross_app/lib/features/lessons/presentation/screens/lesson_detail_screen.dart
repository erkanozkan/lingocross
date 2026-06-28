import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/refresh_on_mount.dart';
import '../../../enrollment/presentation/enrollments_notifier.dart';
import '../../../subscription/domain/entitlement.dart';
import '../../../subscription/presentation/subscription_notifier.dart';
import '../../data/dtos/lesson_dtos.dart';
import '../../data/dtos/word_dtos.dart';
import '../../domain/lesson_status.dart';
import '../lesson_form_controller.dart';
import '../lessons_notifier.dart';
import '../words_notifier.dart';
import '../widgets/lesson_status_badge.dart';
import '../widgets/skeleton_card.dart';

/// Ders Detayı (Stitch `ca812b92…`).
///
/// Başlık + durum rozeti + tarih, "Paylaşılan Sınıflar" (atanan öğrenci sayısı —
/// enrollment'tan), ders içeriği (description), kelime önizleme (ilk birkaç +
/// "Tümünü Gör" → word_list), aksiyonlar (Dersi Düzenle + "Ödev Ataması Yap").
/// Dersler oluşturulurken otomatik yayımlanır; manuel yayın/tamamla aksiyonu yok.
/// Durum rozeti yalnızca bilgi amaçlı gösterilir.
class LessonDetailScreen extends ConsumerWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final String lessonId;

  static const int _previewCount = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lessonAsync = ref.watch(lessonProvider(lessonId));

    return RefreshOnMount(
      onMount: () {
        // DÜZELTME 3: ekrana girişte ders + kelimeleri tazele.
        ref.invalidate(lessonProvider(lessonId));
        ref.invalidate(wordsNotifierProvider(lessonId));
      },
      child: Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.lessonDetailTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
      ),
      body: lessonAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.marginMobile),
          child: SkeletonList(count: 4, height: 80),
        ),
        error: (_, __) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, color: AppColors.error, size: 40),
                const SizedBox(height: AppSpacing.sm),
                Text(l10n.lessonDetailError, style: AppTypography.headlineMd),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton(
                  onPressed: () => ref.invalidate(lessonProvider(lessonId)),
                  child: Text(l10n.commonRetry),
                ),
              ],
            ),
          ),
        ),
        data: (lesson) => _Content(lesson: lesson),
      ),
      bottomNavigationBar: lessonAsync.maybeWhen(
        data: (lesson) => _ActionsBar(lesson: lesson),
        orElse: () => null,
      ),
    ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.lesson});

  final LessonDto lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final wordsAsync = ref.watch(wordsNotifierProvider(lesson.id));
    final studentCount = ref.watch(enrollmentsNotifierProvider).maybeWhen(
          data: (list) => list.length,
          orElse: () => 0,
        );
    final scheduled = (lesson.scheduledLabel?.trim().isNotEmpty ?? false)
        ? lesson.scheduledLabel!.trim()
        : l10n.lessonDetailScheduleNone;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.md,
        AppSpacing.marginMobile,
        AppSpacing.xl,
      ),
      children: [
        _SummaryCard(lesson: lesson, scheduled: scheduled),
        const SizedBox(height: AppSpacing.lg),
        _SharedSection(lesson: lesson, studentCount: studentCount),
        const SizedBox(height: AppSpacing.lg),
        _ContentSection(description: lesson.description),
        const SizedBox(height: AppSpacing.lg),
        _WordsPreview(lessonId: lesson.id, wordsAsync: wordsAsync),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.lesson, required this.scheduled});

  final LessonDto lesson;
  final String scheduled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LessonStatusBadge(status: lesson.status),
                const SizedBox(height: AppSpacing.xs),
                Text(lesson.title, style: AppTypography.headlineLg),
                const SizedBox(height: AppSpacing.base),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 18, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.base),
                    Expanded(
                      child: Text(
                        scheduled,
                        style: AppTypography.bodyMd
                            .copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(Icons.menu_book,
                color: AppColors.primary, size: 32),
          ),
        ],
      ),
    );
  }
}

class _SharedSection extends StatelessWidget {
  const _SharedSection({required this.lesson, required this.studentCount});

  final LessonDto lesson;
  final int studentCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Sınıf/grup yok → atanan öğrenci sayısı (basit "N öğrenciye açık").
    final String body;
    if (lesson.status == LessonStatus.draft) {
      body = l10n.lessonDetailSharedDraft;
    } else if (studentCount == 0) {
      body = l10n.lessonDetailSharedNone;
    } else {
      body = l10n.lessonDetailSharedCount(studentCount);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.groups, color: AppColors.primary),
            const SizedBox(width: AppSpacing.xs),
            Text(l10n.lessonDetailSharedTitle, style: AppTypography.headlineMd),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: Text('$studentCount',
                    style: AppTypography.labelLg
                        .copyWith(color: AppColors.primary)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(body, style: AppTypography.bodyMd),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({required this.description});

  final String? description;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = (description?.trim().isNotEmpty ?? false)
        ? description!.trim()
        : l10n.lessonDetailContentEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.lessonDetailContentTitle, style: AppTypography.headlineMd),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Text(
            text,
            style:
                AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _WordsPreview extends StatelessWidget {
  const _WordsPreview({required this.lessonId, required this.wordsAsync});

  final String lessonId;
  final AsyncValue<List<WordDto>> wordsAsync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.lessonDetailWordsTitle, style: AppTypography.headlineMd),
            wordsAsync.maybeWhen(
              data: (words) => words.isEmpty
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () =>
                          context.push(AppRoutes.lessonWords(lessonId)),
                      child: Text(
                        l10n.lessonDetailWordsSeeAll,
                        style: AppTypography.labelLg
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        wordsAsync.when(
          loading: () => const SkeletonList(count: 2, height: 56),
          error: (_, __) => Text(
            l10n.wordsListError,
            style: AppTypography.bodyMd.copyWith(color: AppColors.error),
          ),
          data: (words) {
            if (words.isEmpty) {
              return _EmptyWords(lessonId: lessonId);
            }
            final preview =
                words.take(LessonDetailScreen._previewCount).toList();
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpacing.xs,
              mainAxisSpacing: AppSpacing.xs,
              childAspectRatio: 3,
              children: [
                for (final w in preview) _WordChip(word: w),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _WordChip extends StatelessWidget {
  const _WordChip({required this.word});

  final WordDto word;

  @override
  Widget build(BuildContext context) {
    final primary = word.translations.where((t) => t.isPrimary);
    final meaning = primary.isNotEmpty
        ? primary.first.text
        : (word.translations.isNotEmpty ? word.translations.first.text : '');
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            word.term,
            style: AppTypography.labelLg.copyWith(color: AppColors.primary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            meaning,
            style:
                AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _EmptyWords extends StatelessWidget {
  const _EmptyWords({required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          Text(
            l10n.lessonDetailWordsEmpty,
            style:
                AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () =>
                context.push(AppRoutes.lessonWords(lessonId)),
            icon: const Icon(Icons.add),
            label: Text(l10n.lessonDetailAddWords),
          ),
        ],
      ),
    );
  }
}

class _ActionsBar extends ConsumerWidget {
  const _ActionsBar({required this.lesson});

  final LessonDto lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final busy = ref.watch(lessonFormControllerProvider).isLoading;
    // Bulmaca oluşturma Premium-only (puzzle_create). Free → paywall.
    final puzzleCreateLocked =
        ref.watch(subscriptionNotifierProvider).maybeWhen(
              data: (sub) => sub.puzzleCreateLocked,
              orElse: () => false,
            );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: busy
                      ? null
                      : () => context.push(AppRoutes.lessonEdit(lesson.id)),
                  icon: const Icon(Icons.edit),
                  label: Text(l10n.lessonDetailEdit),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton.icon(
                  onPressed: busy
                      ? null
                      : () => context.push(
                            puzzleCreateLocked
                                ? AppRoutes.paywallFor('puzzle_create')
                                : AppRoutes.gameNewForLesson(lesson.id),
                          ),
                  icon: Icon(
                    puzzleCreateLocked ? Icons.lock : Icons.assignment_add,
                  ),
                  label: Text(
                    l10n.lessonDetailAssignHomework,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
