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
import '../../data/dtos/result_dtos.dart';
import '../result_report_controller.dart';
import '../results_failure_messages.dart';
import '../widgets/accuracy_ring.dart';
import '../widgets/result_items_breakdown.dart';

/// Oyun Sonu Raporu ekranı (game-result-report.md — Stitch `4786e952…` birebir).
///
/// İki giriş yolu: oyun-sonu (sonuç [seedResult] ile gelir) ve geçmiş/tamamlanan
/// bulmaca (`resultId` ile `GET /results/me`'den yüklenir). İçerik: doğruluk
/// radyali (skor%), Geçen Süre, Bulunan Kelime. Sonuç gönderimde otomatik olarak
/// öğretmene paylaşıldığı için elle "Öğretmene Gönder" + "Tekrar Oyna" yoktur;
/// yerine statik "Öğretmeninle paylaşıldı" bilgi notu gösterilir.
/// Streak/XP statik/gizli (Sapma 1). Yükleniyor/hata durumları (§5).
class GameResultReportScreen extends ConsumerStatefulWidget {
  const GameResultReportScreen({
    super.key,
    required this.resultId,
    this.seedResult,
  });

  final String resultId;

  /// Oyun-sonu yolunda hazır gelen sonuç (varsa ağ çağrısı yapılmaz).
  final GameResultDto? seedResult;

  @override
  ConsumerState<GameResultReportScreen> createState() =>
      _GameResultReportScreenState();
}

class _GameResultReportScreenState
    extends ConsumerState<GameResultReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(
        resultReportControllerProvider(widget.resultId).notifier,
      );
      if (widget.seedResult != null) {
        notifier.seed(widget.seedResult!);
      } else {
        notifier.load();
      }
    });
  }

  void _exitToDashboard() {
    context.go(AppRoutes.student);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(resultReportControllerProvider(widget.resultId));
    final name = ref.watch(authNotifierProvider).user?.displayName ?? '';

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: ResultTopAppBar(
        userName: name,
        onBack: _exitToDashboard,
        onAvatar: () => context.push(AppRoutes.profile),
      ),
      bottomNavigationBar: StudentBottomNav(
        currentIndex: 1, // Raporlar aktif.
        onTap: (i) {
          switch (i) {
            case 0:
              context.go(AppRoutes.student);
            case 1:
              context.go(AppRoutes.studentResults);
            case 2:
              context.push(AppRoutes.profile);
          }
        },
      ),
      body: SafeArea(
        bottom: false,
        child: state.result.when(
          loading: () => const _ReportSkeleton(),
          error:
              (error, _) => _ReportError(
                message: resultsFailureMessage(error, l10n),
                onRetry:
                    () =>
                        ref
                            .read(
                              resultReportControllerProvider(
                                widget.resultId,
                              ).notifier,
                            )
                            .load(),
              ),
          data: (result) => _ReportBody(result: result, items: state.items),
        ),
      ),
    );
  }
}

/// Paylaşılan TopAppBar (game-result-report.md §3.1) — geri + wordmark + avatar.
class ResultTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResultTopAppBar({
    super.key,
    required this.userName,
    required this.onBack,
    required this.onAvatar,
  });

  final String userName;
  final VoidCallback onBack;
  final VoidCallback onAvatar;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final initial =
        userName.isNotEmpty ? userName.characters.first.toUpperCase() : '?';
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.level2,
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.appName,
                  style: AppTypography.headlineLg.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onAvatar,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: Semantics(
                    button: true,
                    label: l10n.navProfile,
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          initial,
                          style: AppTypography.labelLg.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Rapor gövdesi (başarı hâli) — başlık + radyal + bento + paylaşıldı notu.
class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.result, required this.items});

  final GameResultDto result;
  final List<ResultItemModel> items;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final percent = result.accuracyPercent;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.lg,
        AppSpacing.marginMobile,
        AppSpacing.xl,
      ),
      children: [
        // §3.2 Başarı başlığı.
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: const BoxDecoration(
                  color: AppColors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 40,
                  color: AppColors.onSecondaryFixedVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.gameResultTitle,
                style: AppTypography.headlineLg,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                l10n.gameResultSubtitle,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // §3.3 Doğruluk radyali.
        Center(
          child: AccuracyRing(
            percent: percent,
            valueText: l10n.gameResultAccuracyValue(percent),
            label: l10n.gameResultAccuracyLabel,
            semanticLabel: l10n.gameResultAccuracyA11y(percent),
            animate: !reduceMotion,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        // §3.3.2 İstatistik bento ızgarası (streak kartı Sapma 1: gizli).
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _BentoStat(
                  icon: Icons.timer,
                  iconColor: AppColors.primary,
                  label: l10n.gameResultTimeLabel,
                  value: result.formattedDuration,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _BentoStat(
                  icon: Icons.menu_book,
                  iconColor: AppColors.secondary,
                  label: l10n.gameResultWordsLabel,
                  value: l10n.gameResultWordsValue(
                    result.correctItems,
                    result.totalItems,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        // §3.4 Paylaşıldı bilgi notu (sonuç otomatik öğretmene paylaşıldı).
        const _SharedNote(),
        // Cevap Dökümü — öğretmenin gördüğü kırılımın aynısı (doğru=yeşil,
        // yanlış=kırmızı). Kırılım yoksa (eski sonuç) bölüm gizli.
        if (items.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.resultBreakdownTitle,
            style: AppTypography.headlineMd,
          ),
          const SizedBox(height: AppSpacing.md),
          ResultItemsBreakdown(
            items: [
              for (final item in items)
                ResultBreakdownItemData(
                  term: item.term,
                  expectedAnswer: item.expectedAnswer,
                  studentAnswer: item.studentAnswer,
                  isCorrect: item.isCorrect,
                ),
            ],
            labels: ResultBreakdownLabels(
              badgeCorrect: l10n.resultDetailBadgeCorrect,
              badgeWrong: l10n.resultDetailBadgeWrong,
              correctAnswer: l10n.resultDetailCorrectAnswer,
              studentAnswer: l10n.resultBreakdownYourAnswer,
              studentAnswerEmpty: l10n.resultBreakdownYourAnswerEmpty,
              itemCorrectA11y: l10n.resultDetailItemCorrectA11y,
              itemWrongA11y: l10n.resultBreakdownItemWrongA11y,
            ),
          ),
        ],
      ],
    );
  }
}

/// Bento istatistik kartı (Geçen Süre / Bulunan Kelime).
class _BentoStat extends StatelessWidget {
  const _BentoStat({
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
    return Semantics(
      label: '$label $value',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.outlineVariant),
          boxShadow: AppShadows.level2,
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: AppSpacing.xs),
            ExcludeSemantics(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            ExcludeSemantics(
              child: Text(value, style: AppTypography.headlineMd),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Öğretmeninle paylaşıldı" statik bilgi notu (tertiary/onaylı stil).
///
/// Sonuç gönderimde otomatik olarak öğretmenle paylaşıldığı için artık elle
/// gönderme butonu yoktur; bu yalnız bilgilendirme amaçlı, etkileşimsizdir.
class _SharedNote extends StatelessWidget {
  const _SharedNote();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.gameResultSharedNote,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.tertiary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: AppColors.tertiary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.tertiary,
              size: 22,
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: ExcludeSemantics(
                child: Text(
                  l10n.gameResultSharedNote,
                  textAlign: TextAlign.center,
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.tertiary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// §5 Yükleniyor — skeleton (radyal + bento + not shimmer/pasif).
class _ReportSkeleton extends StatelessWidget {
  const _ReportSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget block(double h, {double? w, double radius = AppRadius.md}) =>
        Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(radius),
          ),
        );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.lg,
        AppSpacing.marginMobile,
        AppSpacing.xl,
      ),
      children: [
        Center(child: block(80, w: 80, radius: AppRadius.full)),
        const SizedBox(height: AppSpacing.md),
        Center(child: block(28, w: 180)),
        const SizedBox(height: AppSpacing.lg),
        Center(child: block(220, w: 220, radius: AppRadius.full)),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(child: block(100)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: block(100)),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        block(52),
      ],
    );
  }
}

/// §5 Hata — rapor yüklenemedi kartı + Tekrar Dene.
class _ReportError extends StatelessWidget {
  const _ReportError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Container(
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
                l10n.gameResultErrorTitle,
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
        ),
      ),
    );
  }
}
