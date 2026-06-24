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
import '../../../auth/presentation/auth_notifier.dart';
import '../../../lessons/presentation/widgets/skeleton_card.dart';
import '../../data/dtos/class_dtos.dart';
import '../classes_notifier.dart';
import '../widgets/class_badge.dart';

/// Sınıflarım (Stitch `0a9044bf…` birebir) — "Sınıflar" sekmesinin gövdesi.
///
/// Mavi hero kart + iki istatistik (Toplam Öğrenci gerçek, Aktiflik statik) +
/// "Aktif Sınıflar" başlık + renkli rozetli sınıf kartları (davet kodu chip,
/// ileri ok → ClassDetail) + "Yeni Sınıf Oluştur" 3D buton. Boş durum CTA.
class ClassesListScreen extends ConsumerWidget {
  const ClassesListScreen({super.key});

  /// Aktiflik istatistiği için statik placeholder (gerçek veri Faz 2'de).
  static const int _activityPercent = 85;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final classesAsync = ref.watch(classesNotifierProvider);
    final name = ref.watch(authNotifierProvider).user?.displayName ?? '';

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.marginMobile,
        title: Text(
          l10n.classesTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.marginMobile),
            child: _Avatar(
              name: name,
              onTap: () => context.push(AppRoutes.accountSettings),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(classesNotifierProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.md,
            AppSpacing.marginMobile,
            AppSpacing.xl,
          ),
          children: [
            classesAsync.when(
              loading: () => const Column(
                children: [
                  SkeletonCard(height: 140),
                  SizedBox(height: AppSpacing.md),
                  SkeletonList(count: 3, height: 88),
                ],
              ),
              error: (_, __) => _ErrorState(
                onRetry: () =>
                    ref.read(classesNotifierProvider.notifier).refresh(),
              ),
              data: (classes) => _Content(
                classes: classes,
                activityPercent: _activityPercent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.classes, required this.activityPercent});

  final List<ClassDto> classes;
  final int activityPercent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final totalStudents =
        classes.fold<int>(0, (sum, c) => sum + c.studentCount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroCard(count: classes.length),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.group,
                iconBg: AppColors.tertiaryFixed,
                iconColor: AppColors.tertiary,
                label: l10n.classesStatTotalStudents,
                value: '$totalStudents',
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatCard(
                icon: Icons.local_fire_department,
                iconBg: AppColors.secondaryFixed,
                iconColor: AppColors.secondary,
                label: l10n.classesStatActivity,
                value: l10n.classesStatActivityValue(activityPercent),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.classesActiveSectionTitle,
                  style: AppTypography.headlineMd),
              Text(
                l10n.classesSeeAll,
                style: AppTypography.labelLg.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (classes.isEmpty)
          const _EmptyState()
        else
          for (final c in classes) ...[
            _ClassCard(
              classDto: c,
              onTap: () => context.push(AppRoutes.classDetail(c.id)),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton3D(
          label: l10n.classesCreateButton,
          onPressed: () => context.push(AppRoutes.classNew),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.level2,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -16,
            bottom: -16,
            child: Icon(
              Icons.school,
              size: 120,
              color: AppColors.onPrimaryContainer.withValues(alpha: 0.15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.classesHeroTitle,
                  style: AppTypography.headlineLg
                      .copyWith(color: AppColors.onPrimaryContainer),
                ),
                const SizedBox(height: AppSpacing.xs),
                SizedBox(
                  width: 260,
                  child: Text(
                    l10n.classesHeroSubtitle(count),
                    style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onPrimaryContainer
                            .withValues(alpha: 0.9)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBg.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(value, style: AppTypography.headlineMd),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({required this.classDto, required this.onTap});

  final ClassDto classDto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = ClassBadgePalette.forName(classDto.name);
    final code = classDto.inviteCode;

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
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: palette.background,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Text(
                  classBadgeLabel(classDto.name),
                  style: AppTypography.headlineMd
                      .copyWith(color: palette.foreground),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classDto.name,
                      style: AppTypography.headlineMd,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Row(
                      children: [
                        const Icon(Icons.person,
                            size: 16, color: AppColors.outline),
                        const SizedBox(width: AppSpacing.base),
                        Text(
                          l10n.classesStudentCount(classDto.studentCount),
                          style: AppTypography.bodyMd
                              .copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                    if (code != null && code.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: AppSpacing.base),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.classesInviteCodeChipLabel,
                              style: AppTypography.labelSm
                                  .copyWith(color: AppColors.outline),
                            ),
                            const SizedBox(width: AppSpacing.base),
                            Text(
                              code,
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.chevron_right, color: AppColors.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

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
          const Icon(Icons.groups, color: AppColors.primary, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.classesEmptyTitle,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.base),
          Text(
            l10n.classesEmptyDesc,
            textAlign: TextAlign.center,
            style:
                AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
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
          Text(l10n.classesError,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';
    return InkResponse(
      onTap: onTap,
      radius: 28,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryFixed, width: 2),
        ),
        child: Text(
          initial,
          style: AppTypography.labelLg.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
