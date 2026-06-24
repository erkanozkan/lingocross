import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../subscription/domain/entitlement.dart';
import '../../../subscription/presentation/subscription_notifier.dart';
import '../lessons_notifier.dart';
import '../widgets/lesson_list_card.dart';
import '../widgets/skeleton_card.dart';

/// Derslerim (Stitch `930ab2e6…`) — "Sınıflar" sekmesinin gövdesi.
///
/// "+ Yeni Ders Oluştur" 3D primary butonu + ders listesi (tarih, kelime sayısı,
/// status rozeti). Boş/yükleniyor/hata durumları. Karta dokununca Ders Detayı.
class LessonsListScreen extends ConsumerWidget {
  const LessonsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lessonsAsync = ref.watch(lessonsNotifierProvider);

    // Ders oluşturma proaktif kilidi (F8.2): ücretsiz ders limiti aşılırsa
    // oluşturma paywall'a yönlenir. Durum/sayı belirsizse kilitsiz (reaktif
    // 402 güvenlik ağı).
    final lessonCount =
        lessonsAsync.maybeWhen(data: (l) => l.length, orElse: () => 0);
    final createLocked = ref.watch(subscriptionNotifierProvider).maybeWhen(
          data: (sub) => !sub.canCreateLesson(lessonCount),
          orElse: () => false,
        );
    void openCreate() {
      context.push(
        createLocked ? AppRoutes.paywallFor('lesson_limit') : AppRoutes.lessonNew,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.marginMobile,
        title: Text(
          l10n.lessonsListTitle,
          style: AppTypography.headlineLg.copyWith(color: AppColors.primary),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(lessonsNotifierProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.md,
            AppSpacing.marginMobile,
            AppSpacing.xl,
          ),
          children: [
            _CreateButton(onTap: openCreate, locked: createLocked),
            const SizedBox(height: AppSpacing.lg),
            lessonsAsync.when(
              loading: () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: l10n.lessonsListSectionTitle,
                    countLabel: null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const SkeletonList(count: 3, height: 96),
                ],
              ),
              error: (_, __) => _ErrorState(
                onRetry: () =>
                    ref.read(lessonsNotifierProvider.notifier).refresh(),
              ),
              data: (lessons) {
                if (lessons.isEmpty) {
                  return _EmptyState(onCreate: openCreate);
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                      title: l10n.lessonsListSectionTitle,
                      countLabel: l10n.lessonsListTotal(lessons.length),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    for (final lesson in lessons) ...[
                      LessonListCard(
                        lesson: lesson,
                        onTap: () =>
                            context.push(AppRoutes.lessonDetail(lesson.id)),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    _FooterHint(text: l10n.lessonsListFooterHint),
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

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.onTap, this.locked = false});

  final VoidCallback onTap;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          // Stitch 3D: 2px daha koyu alt kenar his.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: const Border(
              bottom: BorderSide(color: AppColors.primaryShadow, width: 4),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(locked ? Icons.lock : Icons.add_circle,
                  color: AppColors.onPrimary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                l10n.lessonsListCreate,
                style:
                    AppTypography.headlineMd.copyWith(color: AppColors.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.countLabel});

  final String title;
  final String? countLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              AppTypography.headlineMd.copyWith(color: AppColors.onSurfaceVariant),
        ),
        if (countLabel != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.base,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              countLabel!,
              style: AppTypography.labelSm.copyWith(color: AppColors.primary),
            ),
          ),
      ],
    );
  }
}

class _FooterHint extends StatelessWidget {
  const _FooterHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          children: [
            const Icon(Icons.school, color: AppColors.primary, size: 48),
            const SizedBox(height: AppSpacing.xs),
            Text(text, style: AppTypography.bodyMd, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});

  final VoidCallback onCreate;

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
          const Icon(Icons.menu_book, color: AppColors.primary, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.lessonsListEmptyTitle,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.base),
          Text(
            l10n.lessonsListEmptyDesc,
            textAlign: TextAlign.center,
            style:
                AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: onCreate,
            child: Text(l10n.teacherDashboardActionNewLessonTitle),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

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
          Text(l10n.lessonsListError,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}
