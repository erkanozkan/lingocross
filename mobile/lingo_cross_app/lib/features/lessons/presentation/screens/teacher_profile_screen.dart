import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/auth_notifier.dart';
import '../../../enrollment/presentation/enrollments_notifier.dart';

/// Öğretmen Profil (Stitch `b557deed…`) — "Profil" sekmesinin gövdesi.
///
/// Avatar + ad + rol; istatistik kartları (sınıf/öğrenci/katılım — şimdilik
/// iskelet, öğrenci sayısı enrollment'tan gerçek); haftalık ilerleme (iskelet);
/// rozetler (statik); menü (Sınıf Yönetimi→Derslerim, İstatistik→Raporlar,
/// Hesap Ayarları→placeholder, **Çıkış Yap → gerçek logout**).
class TeacherProfileScreen extends ConsumerWidget {
  const TeacherProfileScreen({
    super.key,
    required this.onOpenClasses,
    required this.onOpenReports,
  });

  /// Menü "Sınıf Yönetimi" → Derslerim sekmesi.
  final VoidCallback onOpenClasses;

  /// Menü "İstatistikler ve Raporlar" → Raporlar sekmesi.
  final VoidCallback onOpenReports;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authNotifierProvider).user;
    final name = user?.displayName ?? '';
    // Öğrenci sayısı enrollment'tan (gerçek); diğer istatistikler iskelet.
    final studentCount = ref.watch(enrollmentsNotifierProvider).maybeWhen(
          data: (list) => list.length,
          orElse: () => 0,
        );

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
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.marginMobile,
          AppSpacing.md,
          AppSpacing.marginMobile,
          AppSpacing.xl,
        ),
        children: [
          _Header(name: name),
          const SizedBox(height: AppSpacing.lg),
          _StatsRow(studentCount: studentCount),
          const SizedBox(height: AppSpacing.lg),
          const _WeeklyCard(),
          const SizedBox(height: AppSpacing.lg),
          const _Badges(),
          const SizedBox(height: AppSpacing.lg),
          _Menu(
            onOpenClasses: onOpenClasses,
            onOpenReports: onOpenReports,
            onSettings: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.commonComingSoon)),
            ),
            onLogout: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 96,
              height: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryContainer, width: 4),
                boxShadow: AppShadows.level2,
              ),
              child: Text(
                initial,
                style: AppTypography.displayLgMobile
                    .copyWith(color: AppColors.onPrimaryContainer),
              ),
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.base),
                decoration: const BoxDecoration(
                  color: AppColors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified,
                    size: 16, color: AppColors.onSecondaryFixedVariant),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(name, style: AppTypography.displayLgMobile),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            l10n.teacherProfileRoleLabel,
            style: AppTypography.labelLg
                .copyWith(color: AppColors.onPrimaryContainer),
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.studentCount});

  final int studentCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.class_,
            iconBg: AppColors.secondaryContainer,
            iconColor: AppColors.onSecondaryFixedVariant,
            value: '—',
            valueColor: AppColors.secondary,
            label: l10n.teacherProfileStatClasses,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.people,
            iconBg: AppColors.primaryFixed,
            iconColor: AppColors.primary,
            value: '$studentCount',
            valueColor: AppColors.primary,
            label: l10n.teacherProfileStatStudents,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle,
            iconBg: AppColors.tertiaryFixed,
            iconColor: AppColors.tertiary,
            value: '—',
            valueColor: AppColors.tertiary,
            label: l10n.teacherProfileStatParticipation,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.valueColor,
    required this.label,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final Color valueColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBg.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(value,
              style: AppTypography.headlineMd.copyWith(color: valueColor)),
          Text(
            label,
            style:
                AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _WeeklyCard extends StatelessWidget {
  const _WeeklyCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.teacherProfileWeeklyTitle, style: AppTypography.headlineMd),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.teacherProfileStatsSoon,
            style:
                AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: const LinearProgressIndicator(
              value: 0,
              minHeight: 16,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badges extends StatelessWidget {
  const _Badges();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final badges = <_BadgeData>[
      _BadgeData(Icons.star, AppColors.secondaryFixed,
          AppColors.onSecondaryFixedVariant, l10n.teacherProfileBadgePopular),
      _BadgeData(Icons.bolt, AppColors.tertiaryFixed, AppColors.onTertiaryFixed,
          l10n.teacherProfileBadgeFast),
      _BadgeData(Icons.lightbulb, AppColors.primaryFixed, AppColors.primary,
          l10n.teacherProfileBadgeInspiring),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.teacherProfileBadgesTitle, style: AppTypography.headlineMd),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final b in badges) ...[
                _Badge(data: b),
                const SizedBox(width: AppSpacing.md),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _BadgeData {
  const _BadgeData(this.icon, this.bg, this.fg, this.label);

  final IconData icon;
  final Color bg;
  final Color fg;
  final String label;
}

class _Badge extends StatelessWidget {
  const _Badge({required this.data});

  final _BadgeData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: data.bg,
              shape: BoxShape.circle,
              boxShadow: AppShadows.level2,
            ),
            child: Icon(data.icon, color: data.fg, size: 32),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            data.label,
            style:
                AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Menu extends StatelessWidget {
  const _Menu({
    required this.onOpenClasses,
    required this.onOpenReports,
    required this.onSettings,
    required this.onLogout,
  });

  final VoidCallback onOpenClasses;
  final VoidCallback onOpenReports;
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _MenuRow(
            icon: Icons.groups,
            label: l10n.teacherProfileMenuClasses,
            onTap: onOpenClasses,
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          _MenuRow(
            icon: Icons.bar_chart,
            label: l10n.teacherProfileMenuReports,
            onTap: onOpenReports,
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          _MenuRow(
            icon: Icons.settings,
            label: l10n.teacherProfileMenuSettings,
            onTap: onSettings,
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          _MenuRow(
            icon: Icons.logout,
            label: l10n.teacherProfileMenuLogout,
            destructive: true,
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final fg = destructive ? AppColors.error : AppColors.onSurface;
    final iconBg = destructive ? AppColors.errorContainer : AppColors.primaryFixed;
    final iconFg = destructive ? AppColors.error : AppColors.primary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
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
              child: Icon(icon, color: iconFg, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.headlineMd.copyWith(color: fg),
              ),
            ),
            Icon(Icons.chevron_right,
                color: destructive
                    ? AppColors.error.withValues(alpha: 0.6)
                    : AppColors.outline),
          ],
        ),
      ),
    );
  }
}
