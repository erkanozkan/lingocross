import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/auth_notifier.dart';
import '../../data/dtos/lesson_dtos.dart';
import '../lessons_notifier.dart';
import '../widgets/lesson_card.dart';
import '../widgets/skeleton_card.dart';

/// Öğretmen Paneli (teacher-dashboard.md). Giriş sonrası öğretmenin ana ekranı:
/// karşılama, birincil aksiyon kartları (bento), "Derslerim" listesi (boş/
/// yükleniyor/hata durumları) ve M2 iskelet "Yeni Öğrenci Raporları" bölümü.
class TeacherDashboardScreen extends ConsumerWidget {
  const TeacherDashboardScreen({super.key, this.onOpenReports, this.onOpenProfile});

  /// "Öğrenci Gelişimi" kartına dokununca Raporlar sekmesine geçer (kabuk verir).
  /// Verilmezse (örn. doğrudan bağlantı) öğrenci listesine `push` ile gider.
  final VoidCallback? onOpenReports;

  /// Üst bardaki avatara dokununca Profil sekmesine geçer (kabuk verir).
  /// Verilmezse avatar dekoratif kalır (no-op).
  final VoidCallback? onOpenProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lessonsAsync = ref.watch(lessonsNotifierProvider);
    final name = ref.watch(authNotifierProvider).user?.displayName ?? '';

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.marginMobile,
        title: Text(
          l10n.appName,
          style: AppTypography.headlineLg.copyWith(color: AppColors.primary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.marginMobile),
            child: _Avatar(name: name, onTap: onOpenProfile),
          ),
        ],
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
            _Greeting(name: name),
            const SizedBox(height: AppSpacing.xl),
            _PrimaryActions(
              onNewLesson: () => context.push(AppRoutes.lessonNew),
              onNewPuzzle: () => context.push(AppRoutes.gameNew),
              onMyPuzzles: () => context.push(AppRoutes.teacherPuzzles),
              onProgress: onOpenReports ??
                  () => context.push(AppRoutes.teacherStudents),
            ),
            const SizedBox(height: AppSpacing.xl),
            _LessonsSection(lessonsAsync: lessonsAsync),
            const SizedBox(height: AppSpacing.xl),
            _ReportsSection(),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.onTap});

  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';
    final avatar = Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryContainer, width: 2),
      ),
      child: Text(
        initial,
        style: AppTypography.labelLg.copyWith(color: AppColors.primary),
      ),
    );
    if (onTap == null) return avatar;
    // ≥48px dokunma hedefi için InkResponse'u büyüt; avatar 40px ortalı kalır.
    return Semantics(
      button: true,
      label: l10n.teacherDashboardOpenProfile,
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: avatar,
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.teacherDashboardGreeting(name), style: AppTypography.headlineLg),
        const SizedBox(height: AppSpacing.base),
        Text(
          l10n.teacherDashboardSubtitleEmpty,
          style:
              AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _PrimaryActions extends StatelessWidget {
  const _PrimaryActions({
    required this.onNewLesson,
    required this.onNewPuzzle,
    required this.onMyPuzzles,
    required this.onProgress,
  });

  final VoidCallback onNewLesson;
  final VoidCallback onNewPuzzle;
  final VoidCallback onMyPuzzles;
  final VoidCallback onProgress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        _BentoCard(
          background: AppColors.primaryContainer,
          foreground: AppColors.onPrimary,
          iconBoxColor: AppColors.surfaceContainerLowest,
          icon: Icons.add_circle,
          iconColor: AppColors.primary,
          decorIcon: Icons.grid_view,
          title: l10n.teacherDashboardActionNewLessonTitle,
          desc: l10n.teacherDashboardActionNewLessonDesc,
          onTap: onNewLesson,
        ),
        const SizedBox(height: AppSpacing.md),
        _BentoCard(
          background: AppColors.tertiary,
          foreground: AppColors.onTertiary,
          iconBoxColor: AppColors.surfaceContainerLowest,
          icon: Icons.extension,
          iconColor: AppColors.tertiary,
          decorIcon: Icons.auto_awesome,
          title: l10n.teacherDashboardActionNewPuzzleTitle,
          desc: l10n.teacherDashboardActionNewPuzzleDesc,
          onTap: onNewPuzzle,
        ),
        const SizedBox(height: AppSpacing.md),
        _BentoCard(
          background: AppColors.secondaryContainer,
          foreground: AppColors.onSurface,
          descColor: AppColors.onSurfaceVariant,
          iconBoxColor: AppColors.surfaceContainerLowest,
          icon: Icons.extension,
          iconColor: AppColors.secondary,
          decorIcon: Icons.grid_view,
          title: l10n.teacherDashboardActionMyPuzzlesTitle,
          desc: l10n.teacherDashboardActionMyPuzzlesDesc,
          onTap: onMyPuzzles,
        ),
        const SizedBox(height: AppSpacing.md),
        _BentoCard(
          background: AppColors.surfaceContainerHighest,
          foreground: AppColors.onSurface,
          descColor: AppColors.onSurfaceVariant,
          border: true,
          iconBoxColor: AppColors.primaryContainer,
          icon: Icons.analytics,
          iconColor: AppColors.onPrimary,
          decorIcon: Icons.insights,
          title: l10n.teacherDashboardActionProgressTitle,
          desc: l10n.teacherDashboardActionProgressDesc,
          onTap: onProgress,
        ),
      ],
    );
  }
}

class _BentoCard extends StatelessWidget {
  const _BentoCard({
    required this.background,
    required this.foreground,
    required this.iconBoxColor,
    required this.icon,
    required this.iconColor,
    required this.decorIcon,
    required this.title,
    required this.desc,
    required this.onTap,
    this.descColor,
    this.border = false,
  });

  final Color background;
  final Color foreground;
  final Color? descColor;
  final Color iconBoxColor;
  final IconData icon;
  final Color iconColor;
  final IconData decorIcon;
  final String title;
  final String desc;
  final VoidCallback onTap;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppShadows.level2,
            border: border
                ? Border.all(color: AppColors.outlineVariant)
                : null,
          ),
          child: Stack(
            children: [
              Positioned(
                right: AppSpacing.xs,
                top: AppSpacing.xs,
                child: Icon(decorIcon,
                    size: 64, color: foreground.withValues(alpha: 0.1)),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: iconBoxColor,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(icon, color: iconColor),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      title,
                      style:
                          AppTypography.headlineMd.copyWith(color: foreground),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      desc,
                      style: AppTypography.labelSm
                          .copyWith(color: descColor ?? foreground),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonsSection extends ConsumerWidget {
  const _LessonsSection({required this.lessonsAsync});

  final AsyncValue<List<LessonDto>> lessonsAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: l10n.teacherDashboardLessonsTitle,
          actionLabel: l10n.teacherDashboardSeeAll,
          onAction: () => context.push(AppRoutes.lessons),
        ),
        const SizedBox(height: AppSpacing.sm),
        lessonsAsync.when(
          loading: () => const SkeletonList(count: 3),
          error: (_, __) => _LessonsError(
            onRetry: () => ref.read(lessonsNotifierProvider.notifier).refresh(),
          ),
          data: (lessons) {
            if (lessons.isEmpty) {
              return _EmptyLessons(
                onCreate: () => context.push(AppRoutes.lessonNew),
              );
            }
            // ≥ 5 ders varsa ilk 4'ü göster (teacher-dashboard.md §4).
            final visible = lessons.length > 4 ? lessons.take(4) : lessons;
            return Column(
              children: [
                for (final lesson in visible) ...[
                  LessonCard(
                    lesson: lesson,
                    onTap: () =>
                        context.push(AppRoutes.lessonDetail(lesson.id)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.headlineMd),
        if (actionLabel != null)
          InkWell(
            onTap: onAction,
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs, vertical: AppSpacing.base),
              child: Row(
                children: [
                  Text(
                    actionLabel!,
                    style:
                        AppTypography.labelLg.copyWith(color: AppColors.primary),
                  ),
                  const Icon(Icons.chevron_right,
                      color: AppColors.primary, size: 18),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyLessons extends StatelessWidget {
  const _EmptyLessons({required this.onCreate});

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
          Text(l10n.teacherDashboardEmptyLessonsTitle,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.base),
          Text(
            l10n.teacherDashboardEmptyLessonsDesc,
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

class _LessonsError extends StatelessWidget {
  const _LessonsError({required this.onRetry});

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
          Text(l10n.teacherDashboardError,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}

class _ReportsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.teacherDashboardReportsTitle),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Row(
            children: [
              const Icon(Icons.notifications_off,
                  color: AppColors.onSurfaceVariant),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.teacherDashboardEmptyReports,
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
