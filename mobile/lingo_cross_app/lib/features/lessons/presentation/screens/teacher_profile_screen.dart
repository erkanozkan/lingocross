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
import '../../../profile/data/dtos/teacher_stats_dto.dart';
import '../../../profile/presentation/teacher_stats_notifier.dart';

/// Öğretmen Profil (Stitch `b557deed…`) — "Profil" sekmesinin gövdesi.
///
/// Avatar + ad + rol; istatistik kartları (sınıf/öğrenci/katılım — `GET
/// /teachers/me/stats` gerçek veriden); haftalık ödev tamamlama (gerçek
/// ilerleme); rozetler (statik); menü (Sınıf Yönetimi→Derslerim,
/// İstatistik→Raporlar, Hesap Ayarları→placeholder, **Çıkış Yap → gerçek
/// logout**).
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
    final statsAsync = ref.watch(teacherStatsNotifierProvider);

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
          _StatsRow(
            statsAsync: statsAsync,
            onRetry: () =>
                ref.read(teacherStatsNotifierProvider.notifier).refresh(),
          ),
          const SizedBox(height: AppSpacing.lg),
          _WeeklyCard(statsAsync: statsAsync),
          const SizedBox(height: AppSpacing.lg),
          const _Badges(),
          const SizedBox(height: AppSpacing.lg),
          _Menu(
            onOpenClasses: onOpenClasses,
            onOpenLessons: () => context.push(AppRoutes.lessons),
            onOpenReports: onOpenReports,
            onSettings: () => context.push(AppRoutes.accountSettings),
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

/// İstatistik kartları (Sınıf / Öğrenci / Katılım) — `GET /teachers/me/stats`
/// gerçek verisinden. Yükleniyor "·", hata "—" gösterir; hata satırında
/// Tekrar Dene bulunur.
class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.statsAsync, required this.onRetry});

  final AsyncValue<TeacherStatsDto> statsAsync;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loading = statsAsync.isLoading;
    final hasError = statsAsync.hasError;
    final stats = statsAsync.valueOrNull;

    String classes;
    String students;
    String participation;
    if (loading) {
      classes = students = participation = '·';
    } else if (hasError || stats == null) {
      classes = students = participation = '—';
    } else {
      classes = '${stats.classCount}';
      students = '${stats.studentCount}';
      participation = l10n.teacherProfileStatValue(stats.completionPercent);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.class_,
                iconBg: AppColors.secondaryContainer,
                iconColor: AppColors.onSecondaryFixedVariant,
                value: classes,
                valueColor: AppColors.secondary,
                label: l10n.teacherProfileStatClasses,
                loading: loading,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _StatCard(
                icon: Icons.people,
                iconBg: AppColors.primaryFixed,
                iconColor: AppColors.primary,
                value: students,
                valueColor: AppColors.primary,
                label: l10n.teacherProfileStatStudents,
                loading: loading,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle,
                iconBg: AppColors.tertiaryFixed,
                iconColor: AppColors.tertiary,
                value: participation,
                valueColor: AppColors.tertiary,
                label: l10n.teacherProfileStatParticipation,
                loading: loading,
              ),
            ),
          ],
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.cloud_off, size: 16, color: AppColors.error),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  l10n.teacherProfileStatsError,
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
              TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
            ],
          ),
        ],
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
    this.loading = false,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final Color valueColor;
  final String label;

  /// Gerçek metrik yüklenirken ince ilerleme göstergesi.
  final bool loading;

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
          if (loading)
            const SizedBox(
              height: 28,
              width: 24,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            )
          else
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

/// Haftalık Ödev Tamamlama — `GET /teachers/me/stats` gerçek verisinden.
/// Atanmış ödev varsa `completed/assigned` ilerleme + "{done}/{total} ödev
/// tamamlandı"; atanmış ödev yoksa nazik boş metin. Yükleniyor/hata
/// durumlarında ilerleme gizli, açıklayıcı metin gösterilir.
class _WeeklyCard extends StatelessWidget {
  const _WeeklyCard({required this.statsAsync});

  final AsyncValue<TeacherStatsDto> statsAsync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loading = statsAsync.isLoading;
    final hasError = statsAsync.hasError;
    final stats = statsAsync.valueOrNull;
    final hasData = !loading && !hasError && stats != null;
    final hasAssignments = hasData && stats.hasWeeklyAssignments;

    final String desc;
    if (loading) {
      desc = l10n.teacherProfileStatsSoon;
    } else if (hasError || stats == null) {
      desc = l10n.teacherProfileStatsError;
    } else if (!stats.hasWeeklyAssignments) {
      desc = l10n.teacherProfileWeeklyEmpty;
    } else {
      desc = l10n.teacherProfileWeeklyDesc(
        stats.weeklyCompletedCount,
        stats.weeklyAssignedCount,
      );
    }

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
            desc,
            style:
                AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          if (hasAssignments) ...[
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: stats.weeklyProgress,
                minHeight: 16,
                backgroundColor: AppColors.surfaceContainerHigh,
                valueColor:
                    const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ],
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
    required this.onOpenLessons,
    required this.onOpenReports,
    required this.onSettings,
    required this.onLogout,
  });

  final VoidCallback onOpenClasses;
  final VoidCallback onOpenLessons;
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
            icon: Icons.menu_book,
            label: l10n.teacherProfileMenuLessons,
            onTap: onOpenLessons,
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
