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
import '../../../enrollment/presentation/widgets/student_bottom_nav.dart';
import '../../../lessons/presentation/widgets/skeleton_card.dart';
import '../../data/dtos/result_dtos.dart';
import '../result_date_format.dart';
import '../results_failure_messages.dart';
import '../results_history_notifier.dart';
import 'game_result_report_screen.dart';

/// Öğrenci Geçmiş Sonuçları (student-results-history.md — Lumina türevi).
///
/// Öğrenci panelindeki "Raporlar" sekmesinin hedefi. `GET /results/me` listesi:
/// özet şeridi (toplam oyun + ortalama doğruluk) + sonuç kartları (en yeni üstte).
/// Satıra dokununca Oyun Sonu Raporu (`resultId` ile) yeniden kullanılır.
/// Boş/yükleniyor/hata durumları (§5).
class StudentResultsHistoryScreen extends ConsumerWidget {
  const StudentResultsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final name = ref.watch(authNotifierProvider).user?.displayName ?? '';
    final resultsAsync = ref.watch(resultsHistoryNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: ResultTopAppBar(
        userName: name,
        onBack: () => context.go(AppRoutes.student),
        onAvatar: () => context.push(AppRoutes.profile),
      ),
      bottomNavigationBar: StudentBottomNav(
        currentIndex: 1, // Raporlar aktif.
        onTap: (i) {
          switch (i) {
            case 0:
              context.go(AppRoutes.student);
            case 1:
              break; // Zaten Raporlar.
            case 2:
              context.push(AppRoutes.profile);
          }
        },
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh:
              () => ref.read(resultsHistoryNotifierProvider.notifier).refresh(),
          child: resultsAsync.when(
            loading: () => const _HistoryLoading(),
            error:
                (error, _) => _HistoryStateScroll(
                  child: _HistoryError(
                    message: resultsFailureMessage(error, l10n),
                    onRetry:
                        () =>
                            ref
                                .read(resultsHistoryNotifierProvider.notifier)
                                .refresh(),
                  ),
                ),
            data:
                (results) =>
                    results.isEmpty
                        ? _HistoryStateScroll(
                          child: _HistoryEmpty(
                            onStart: () => context.go(AppRoutes.student),
                          ),
                        )
                        : _HistoryList(results: results),
          ),
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.results});

  final List<GameResultDto> results;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final total = results.length;
    final avg =
        total == 0
            ? 0
            : (results.fold<int>(0, (s, r) => s + r.accuracyPercent) / total)
                .round();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.md,
        AppSpacing.marginMobile,
        AppSpacing.xl,
      ),
      children: [
        Text(l10n.resultsHistoryTitle, style: AppTypography.headlineLg),
        const SizedBox(height: AppSpacing.base),
        Text(
          l10n.resultsHistorySubtitle,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // §3.4 Özet şeridi.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Icons.analytics,
                  iconColor: AppColors.primary,
                  label: l10n.resultsHistorySummaryTotalGames,
                  value: '$total',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.track_changes,
                  iconColor: AppColors.secondary,
                  label: l10n.resultsHistorySummaryAvgAccuracy,
                  value: l10n.gameResultAccuracyValue(avg),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final r in results) ...[
          _ResultCard(
            result: r,
            onTap:
                () =>
                    context.push(AppRoutes.studentResultDetail(r.id), extra: r),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(value, style: AppTypography.headlineMd),
        ],
      ),
    );
  }
}

/// §3.3 Sonuç kartı (liste öğesi) — ders adı + meta + mini doğruluk + rozet.
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, required this.onTap});

  final GameResultDto result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateLabel = formatShortDate(
      result.createdAt,
      localeCode: Localizations.localeOf(context).languageCode,
    );
    final a11y = l10n.resultsHistoryItemDateA11y(
      result.lessonTitle,
      result.accuracyPercent,
      result.formattedDuration,
      result.correctItems,
      result.totalItems,
      dateLabel,
    );

    return Semantics(
      button: true,
      label:
          result.sharedWithTeacher
              ? '$a11y, ${l10n.resultsHistoryItemShared}'
              : a11y,
      child: Material(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            constraints: const BoxConstraints(minHeight: 72),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.outlineVariant),
              boxShadow: AppShadows.level2,
            ),
            child: ExcludeSemantics(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.lessonTitle,
                          style: AppTypography.headlineMd,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: AppSpacing.sm,
                          children: [
                            _Meta(
                              icon: Icons.schedule,
                              text: result.formattedDuration,
                            ),
                            _Meta(
                              icon: Icons.menu_book,
                              text: l10n.gameResultWordsValue(
                                result.correctItems,
                                result.totalItems,
                              ),
                            ),
                            Text(
                              dateLabel,
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.gameResultAccuracyValue(result.accuracyPercent),
                        style: AppTypography.labelLg.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (result.sharedWithTeacher) ...[
                        const SizedBox(height: AppSpacing.xs),
                        _SharedChip(label: l10n.resultsHistoryItemShared),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
        const SizedBox(width: AppSpacing.base),
        Text(
          text,
          style: AppTypography.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Paylaşıldı chip — tertiary tonlu + tik.
class _SharedChip extends StatelessWidget {
  const _SharedChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 14, color: AppColors.onTertiary),
          const SizedBox(width: AppSpacing.base),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(color: AppColors.onTertiary),
          ),
        ],
      ),
    );
  }
}

/// Yükleniyor — özet şeridi + 3-4 skeleton kart.
class _HistoryLoading extends StatelessWidget {
  const _HistoryLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.md,
        AppSpacing.marginMobile,
        AppSpacing.xl,
      ),
      children: const [
        SkeletonCard(height: 28),
        SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(child: SkeletonCard(height: 88)),
            SizedBox(width: AppSpacing.md),
            Expanded(child: SkeletonCard(height: 88)),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        SkeletonList(count: 4, height: 80),
      ],
    );
  }
}

/// Boş/hata durumlarını RefreshIndicator için kaydırılabilir hale getirir.
class _HistoryStateScroll extends StatelessWidget {
  const _HistoryStateScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:
          (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Center(child: child),
              ),
            ),
          ),
    );
  }
}

/// §5 Boş — hiç sonuç yok: ikon + başlık + açıklama + "Oyuna Başla".
class _HistoryEmpty extends StatelessWidget {
  const _HistoryEmpty({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.sports_esports,
            size: 36,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.resultsHistoryEmptyTitle,
          textAlign: TextAlign.center,
          style: AppTypography.headlineMd,
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          l10n.resultsHistoryEmptyDesc,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: InkWell(
              onTap: onStart,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.primaryShadow,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  l10n.resultsHistoryEmptyCta,
                  style: AppTypography.headlineMd.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// §5 Hata kartı + Tekrar Dene.
class _HistoryError extends StatelessWidget {
  const _HistoryError({required this.message, required this.onRetry});

  final String message;
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
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 40, color: AppColors.error),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.resultsHistoryErrorTitle,
            textAlign: TextAlign.center,
            style: AppTypography.headlineMd,
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}
