import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/auth_notifier.dart';
import '../../data/dtos/student_stats_dto.dart';
import '../student_stats_notifier.dart';

/// Öğrenci Profil ekranı (Stitch `21e40177…` — birebir).
///
/// Üst bar (LingoCross + ayar ikonu) + avatar (baş harf placeholder) + ad +
/// "Öğrenci"; istatistik kartları (Günlük Seri = placeholder, Oyun =
/// `gamesPlayed` GERÇEK, Doğruluk = `%averageAccuracy` GERÇEK); Haftalık Hedef
/// progress (placeholder/iskelet); Başarılarım rozetleri (statik, kilitli);
/// menü (Hesap Ayarları / Bildirim Tercihleri / Yardım ve Destek → "Yakında",
/// **Çıkış Yap → gerçek logout()**).
///
/// Gerçek metrikler `GET /students/me/stats`'ten gelir; yükleniyor/hata
/// durumları stat kartlarında ele alınır. Stitch'teki "Questions" alt-nav sekmesi
/// Faz 3+ olduğu için bu fazda eklenmez (öğrenci nav'ı 3 sekme kalır).
class StudentProfileScreen extends ConsumerWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final name = ref.watch(authNotifierProvider).user?.displayName ?? '';
    final statsAsync = ref.watch(studentStatsNotifierProvider);

    void comingSoon() => ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.commonComingSoon)));

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
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: IconButton(
              tooltip: l10n.studentProfileSettingsTooltip,
              icon: const Icon(Icons.settings, color: AppColors.outline),
              onPressed: comingSoon,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.marginMobile,
          AppSpacing.xs,
          AppSpacing.marginMobile,
          AppSpacing.xl,
        ),
        children: [
          _Header(name: name),
          const SizedBox(height: AppSpacing.lg),
          _StatsGrid(statsAsync: statsAsync, onRetry: () {
            ref.read(studentStatsNotifierProvider.notifier).refresh();
          }),
          const SizedBox(height: AppSpacing.lg),
          const _WeeklyGoalCard(),
          const SizedBox(height: AppSpacing.lg),
          const _Achievements(),
          const SizedBox(height: AppSpacing.lg),
          _Menu(
            onAccountSettings: comingSoon,
            onNotifications: comingSoon,
            onHelp: comingSoon,
            onLogout: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }
}

/// Avatar (baş harf placeholder) + ad + "Öğrenci" rol etiketi.
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
                border: Border.all(color: AppColors.surfaceContainer, width: 4),
                boxShadow: AppShadows.level2,
              ),
              child: Text(
                initial,
                style: AppTypography.displayLgMobile
                    .copyWith(color: AppColors.onPrimaryContainer),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.base),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2),
                ),
                child: const Icon(Icons.edit, size: 16, color: AppColors.onPrimary),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(name, style: AppTypography.headlineLg),
        const SizedBox(height: AppSpacing.base),
        Text(
          l10n.studentProfileRoleLabel,
          style: AppTypography.labelLg.copyWith(color: AppColors.outline),
        ),
      ],
    );
  }
}

/// İstatistik bento ızgarası (3 sütun): Günlük Seri (placeholder) /
/// Oyun (gerçek) / Doğruluk (gerçek). Stitch'te Streak ilk sırada ve turuncu
/// gradient kart; gerçek veri olmadığı için "—" placeholder olarak gösterilir.
class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.statsAsync, required this.onRetry});

  final AsyncValue<StudentStatsDto> statsAsync;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Gerçek iki metrik için yükleniyor/hata/veri durumu.
    final loading = statsAsync.isLoading;
    final hasError = statsAsync.hasError;
    // `value` AsyncError'da hatayı yeniden fırlatır; güvenli erişim için
    // `valueOrNull` kullanılır.
    final stats = statsAsync.valueOrNull;

    String gamesValue;
    String accuracyValue;
    if (loading) {
      gamesValue = '·';
      accuracyValue = '·';
    } else if (hasError || stats == null) {
      gamesValue = '—';
      accuracyValue = '—';
    } else {
      gamesValue = '${stats.gamesPlayed}';
      accuracyValue = '%${stats.accuracyPercent}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Günlük Seri — placeholder (gerçek streak Faz 3+; "yakında").
            Expanded(
              child: _StatCard(
                icon: Icons.local_fire_department,
                iconColor: AppColors.onPrimary,
                iconBg: AppColors.secondaryContainer,
                value: '—',
                valueColor: AppColors.onPrimary,
                label: l10n.studentProfileStatStreak,
                highlighted: true,
                placeholder: true,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            // Oyun — GERÇEK (gamesPlayed).
            Expanded(
              child: _StatCard(
                icon: Icons.extension,
                iconColor: AppColors.primary,
                iconBg: AppColors.primaryFixed,
                value: gamesValue,
                valueColor: AppColors.onSurface,
                label: l10n.studentProfileStatGames,
                loading: loading,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            // Doğruluk — GERÇEK (%averageAccuracy).
            Expanded(
              child: _StatCard(
                icon: Icons.verified,
                iconColor: AppColors.tertiary,
                iconBg: AppColors.tertiaryFixed,
                value: accuracyValue,
                valueColor: AppColors.onSurface,
                label: l10n.studentProfileStatAccuracy,
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
                  l10n.studentProfileStatsError,
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
              TextButton(
                onPressed: onRetry,
                child: Text(l10n.commonRetry),
              ),
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
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.valueColor,
    required this.label,
    this.highlighted = false,
    this.placeholder = false,
    this.loading = false,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final Color valueColor;
  final String label;

  /// Stitch'teki turuncu "streak" kartı görünümü (gradient/dolu zemin).
  final bool highlighted;

  /// Gerçek veri olmayan (yakında) placeholder kart — soluk değer.
  final bool placeholder;

  /// Gerçek metrik yüklenirken ince ilerleme göstergesi.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final labelColor =
        highlighted ? AppColors.onPrimary.withValues(alpha: 0.9) : AppColors.outline;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: highlighted
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFEA619), Color(0xFFFF8C00)],
              )
            : null,
        color: highlighted ? null : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: highlighted
            ? null
            : Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: AppSpacing.xs),
          if (loading)
            const SizedBox(
              height: 24,
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
            Text(
              value,
              style: AppTypography.headlineMd.copyWith(
                color: placeholder
                    ? valueColor.withValues(alpha: 0.7)
                    : valueColor,
              ),
            ),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(color: labelColor),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Haftalık Hedef — placeholder/iskelet (gerçek hedef takibi bu fazda yok).
class _WeeklyGoalCard extends StatelessWidget {
  const _WeeklyGoalCard();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.studentProfileWeeklyGoalTitle,
                  style: AppTypography.headlineMd),
              Text(
                l10n.commonComingSoon,
                style: AppTypography.labelLg.copyWith(color: AppColors.outline),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: const LinearProgressIndicator(
              value: 0,
              minHeight: 16,
              backgroundColor: AppColors.surfaceContainer,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.studentProfileWeeklyGoalSoon,
            style:
                AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Başarılarım — statik/placeholder rozetler (sonu kilitli görünüm).
class _Achievements extends StatelessWidget {
  const _Achievements();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final badges = <_BadgeData>[
      _BadgeData(Icons.bolt, AppColors.tertiaryFixed, AppColors.onTertiaryFixed,
          AppColors.tertiary, l10n.studentProfileBadgeFastStart),
      _BadgeData(Icons.search, AppColors.secondaryFixed,
          AppColors.onSecondaryFixedVariant, AppColors.secondaryContainer,
          l10n.studentProfileBadgeWordHunter),
      _BadgeData(Icons.military_tech, AppColors.primaryFixed, AppColors.primary,
          AppColors.primary, l10n.studentProfileBadgeQuizMaster),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.studentProfileAchievementsTitle,
            style: AppTypography.headlineMd),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final b in badges) ...[
                _Badge(data: b),
                const SizedBox(width: AppSpacing.md),
              ],
              // Kilitli rozet (soluk/gri) — "yakında" çağrışımı.
              _LockedBadge(label: l10n.studentProfileBadgeLocked),
            ],
          ),
        ),
      ],
    );
  }
}

class _BadgeData {
  const _BadgeData(this.icon, this.bg, this.fg, this.border, this.label);

  final IconData icon;
  final Color bg;
  final Color fg;
  final Color border;
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
              border: Border.all(color: data.border, width: 2),
              boxShadow: AppShadows.soft,
            ),
            child: Icon(data.icon, color: data.fg, size: 32),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            data.label,
            style: AppTypography.labelSm.copyWith(color: AppColors.onSurface),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LockedBadge extends StatelessWidget {
  const _LockedBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.outlineVariant, width: 2),
                boxShadow: AppShadows.soft,
              ),
              child: const Icon(Icons.lock, color: AppColors.outline, size: 32),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelSm.copyWith(color: AppColors.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Menü: Hesap Ayarları / Bildirim Tercihleri / Yardım ve Destek →
/// "Yakında" (no-op); Çıkış Yap → gerçek logout.
class _Menu extends StatelessWidget {
  const _Menu({
    required this.onAccountSettings,
    required this.onNotifications,
    required this.onHelp,
    required this.onLogout,
  });

  final VoidCallback onAccountSettings;
  final VoidCallback onNotifications;
  final VoidCallback onHelp;
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
            icon: Icons.person,
            label: l10n.studentProfileMenuAccount,
            onTap: onAccountSettings,
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          _MenuRow(
            icon: Icons.notifications,
            label: l10n.studentProfileMenuNotifications,
            onTap: onNotifications,
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          _MenuRow(
            icon: Icons.help,
            label: l10n.studentProfileMenuHelp,
            onTap: onHelp,
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          _MenuRow(
            icon: Icons.logout,
            label: l10n.studentProfileMenuLogout,
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
    final iconFg = destructive ? AppColors.error : AppColors.primary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, color: iconFg, size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(label, style: AppTypography.bodyMd.copyWith(color: fg)),
            ),
            Icon(
              Icons.chevron_right,
              color: destructive
                  ? AppColors.error.withValues(alpha: 0.4)
                  : AppColors.outline,
            ),
          ],
        ),
      ),
    );
  }
}
