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

/// Oyun Sonu Raporu ekranı (game-result-report.md — Stitch `4786e952…` birebir).
///
/// İki giriş yolu: oyun-sonu (sonuç [seed] ile gelir) ve geçmiş (`resultId` ile
/// `GET /results/me`'den yüklenir). İçerik: doğruluk radyali (skor%), Geçen Süre,
/// Bulunan Kelime, "Öğretmene Gönder" (3D, tek-yön kilit) + "Tekrar Oyna".
/// Streak/XP statik/gizli (Sapma 1). Yükleniyor/hata + paylaşım durumları (§5–6).
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
  ProviderSubscription<ResultReportState>? _shareSub;

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

    // Paylaşım durum değişimlerini dinleyip toast göster (başarı/hata).
    _shareSub = ref.listenManual<ResultReportState>(
      resultReportControllerProvider(widget.resultId),
      (prev, next) {
        if (prev?.shareStatus == next.shareStatus) return;
        final l10n = AppLocalizations.of(context);
        // Yalnız kullanıcı tetiklemeli paylaşımda (sending → shared) toast;
        // zaten-paylaşılmış sonuç yüklendiğinde toast gösterme.
        if (next.shareStatus == ShareStatus.shared &&
            prev?.shareStatus == ShareStatus.sending) {
          _showToast(l10n.gameResultShareToastSuccess, success: true);
        } else if (next.shareStatus == ShareStatus.error) {
          _showToast(l10n.gameResultShareToastError, success: false);
          // Toast gösterildi → buton yeniden denenebilir idle'a döner.
          ref
              .read(resultReportControllerProvider(widget.resultId).notifier)
              .acknowledgeShareError();
        }
      },
    );
  }

  @override
  void dispose() {
    _shareSub?.close();
    super.dispose();
  }

  void _showToast(String message, {required bool success}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              success ? AppColors.tertiaryContainer : AppColors.errorContainer,
          content: Text(
            message,
            style: AppTypography.labelLg.copyWith(
              color:
                  success ? AppColors.onTertiary : AppColors.onErrorContainer,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      );
  }

  void _exitToDashboard() {
    context.go(AppRoutes.student);
  }

  /// "Tekrar Oyna" — aynı oyun için yeni oturum (oyun launcher'ı yeniden).
  /// Route gameId bekler; lessonId değil (aksi halde StartSession 404 döner).
  void _playAgain(String gameId) {
    context.go(AppRoutes.studentGame(gameId));
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
          data:
              (result) => _ReportBody(
                result: result,
                shareStatus: state.shareStatus,
                onShare:
                    () =>
                        ref
                            .read(
                              resultReportControllerProvider(
                                widget.resultId,
                              ).notifier,
                            )
                            .share(),
                onPlayAgain: () => _playAgain(result.gameId),
              ),
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

/// Rapor gövdesi (başarı hâli) — başlık + radyal + bento + aksiyonlar.
class _ReportBody extends StatelessWidget {
  const _ReportBody({
    required this.result,
    required this.shareStatus,
    required this.onShare,
    required this.onPlayAgain,
  });

  final GameResultDto result;
  final ShareStatus shareStatus;
  final VoidCallback onShare;
  final VoidCallback onPlayAgain;

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
        // §3.4 Aksiyonlar.
        _ShareButton(status: shareStatus, onShare: onShare),
        const SizedBox(height: AppSpacing.lg),
        _PlayAgainButton(onTap: onPlayAgain),
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

/// "Öğretmene Gönder" 3D primary buton — idle/gönderiliyor/paylaşıldı (§6).
///
/// Buton yerinde durum değiştirir: paylaşıldı → tertiary yeşil + tik, pasif
/// (tek-yön kilit). Gönderiliyor → spinner + pasif. Hata durumu idle'a dönüp
/// toast ile bildirilir (üst seviyede ele alınır).
class _ShareButton extends StatefulWidget {
  const _ShareButton({required this.status, required this.onShare});

  final ShareStatus status;
  final VoidCallback onShare;

  @override
  State<_ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<_ShareButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sending = widget.status == ShareStatus.sending;
    final shared = widget.status == ShareStatus.shared;
    final interactive = !sending && !shared;

    final bgColor = shared ? AppColors.tertiary : AppColors.primaryContainer;
    final shadowColor =
        shared ? AppColors.tertiaryContainer : AppColors.primaryShadow;
    final sunk = _pressed && interactive;

    final liveLabel =
        sending
            ? l10n.gameResultA11ySending
            : shared
            ? l10n.gameResultA11yShared
            : '';

    return Semantics(
      button: true,
      enabled: interactive,
      liveRegion: sending || shared,
      label: liveLabel.isEmpty ? null : liveLabel,
      child: Opacity(
        opacity: sending ? 0.7 : 1,
        child: GestureDetector(
          onTapDown:
              interactive ? (_) => setState(() => _pressed = true) : null,
          onTapUp: interactive ? (_) => setState(() => _pressed = false) : null,
          onTapCancel:
              interactive ? () => setState(() => _pressed = false) : null,
          onTap: interactive ? widget.onShare : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            transform: Matrix4.translationValues(0, sunk ? 4 : 0, 0),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: [
                BoxShadow(color: shadowColor, offset: Offset(0, sunk ? 0 : 4)),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Center(
              child:
                  sending
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.onPrimaryContainer,
                          ),
                        ),
                      )
                      : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            shared ? Icons.check_circle : Icons.send,
                            color:
                                shared
                                    ? AppColors.onTertiary
                                    : AppColors.onPrimaryContainer,
                            size: 22,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            shared
                                ? l10n.gameResultShareShared
                                : l10n.gameResultShare,
                            style: AppTypography.headlineMd.copyWith(
                              color:
                                  shared
                                      ? AppColors.onTertiary
                                      : AppColors.onPrimaryContainer,
                            ),
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

/// "Tekrar Oyna" ikincil buton (yumuşak gri).
class _PlayAgainButton extends StatelessWidget {
  const _PlayAgainButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.replay, color: AppColors.onSurfaceVariant),
              const SizedBox(width: AppSpacing.xs),
              Text(
                l10n.gameResultPlayAgain,
                style: AppTypography.labelLg.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// §5 Yükleniyor — skeleton (radyal + bento + butonlar shimmer/pasif).
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
        const SizedBox(height: AppSpacing.lg),
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
