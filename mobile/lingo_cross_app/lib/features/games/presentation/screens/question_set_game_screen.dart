import 'dart:async';

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
import '../../../results/presentation/results_failure_messages.dart';
import '../../../results/presentation/submit_result_controller.dart';
import '../../data/dtos/game_dtos.dart';
import '../../domain/question_set_engine.dart';
import '../widgets/completion_overlay.dart';

/// Çıkmış Sorular (Soru Çözüm) ekranı — Stitch `4eebe27dcdc943f2b1fb797832cb7a80`.
///
/// 10 soru tek tek çözülür (A–E tek seçim). Oyun boyunca serbest; doğru/yanlış
/// OYUN SIRASINDA gösterilmez (nötr renkler). Üstte başlık/alt başlık + geri,
/// altında "Soru x/y" + geçen süre + ilerleme çubuğu, ortada soru kartı + şıklar.
/// Alt sabit footer: solda "Önceki" (outlined), sağda son soruda "Bitir",
/// diğerlerinde "Sonraki Soru" (primary 3D buton).
///
/// "Bitir" anında seçimler doğru cevaplarla karşılaştırılır (skorlama istemcide),
/// sonuç `POST /game-sessions/{id}/result` ile gönderilir (yükleniyor overlay'i;
/// hata → tekrar dene) ve dönen sonuçla Oyun Sonu Raporu ekranına geçilir.
///
/// Stitch sapması: seri (streak) rozeti, bookmark, reading görseli, per-soru
/// kategori chip'i ve "Time remaining" geri sayımı — verimiz/özelliğimiz
/// olmadığından uygulanmaz; geçen süre (count-up) gösterilir.
class QuestionSetGameScreen extends ConsumerStatefulWidget {
  const QuestionSetGameScreen({
    super.key,
    required this.sessionId,
    required this.content,
  });

  /// Sonuç gönderiminde kullanılan oyun oturumu kimliği.
  final String sessionId;
  final QuestionSetContent content;

  @override
  ConsumerState<QuestionSetGameScreen> createState() =>
      _QuestionSetGameScreenState();
}

class _QuestionSetGameScreenState extends ConsumerState<QuestionSetGameScreen> {
  late QuestionSetEngine _engine;
  Timer? _timer;
  int _elapsedSeconds = 0;
  int _durationMs = 0; // bitince ölçülen kesin süre (ms).
  bool _completed = false;
  bool _submitFailed = false; // sonuç gönderimi hatası (tekrar dene).
  int _correctItems = 0; // "Bitir" anında ölçülen doğru soru sayısı.
  DateTime? _startedAt;

  @override
  void initState() {
    super.initState();
    _engine = QuestionSetEngine.fromContent(widget.content);
    _startedAt = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && !_completed) {
        setState(() => _elapsedSeconds++);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _onSelectOption(String optionId) {
    if (_completed) return;
    setState(() => _engine = _engine.selectOption(optionId));
  }

  void _onPrev() {
    if (_completed) return;
    setState(() => _engine = _engine.prev());
  }

  void _onNext() {
    if (_completed) return;
    setState(() => _engine = _engine.next());
  }

  /// "Bitir" — seçimleri doğru cevaplarla karşılaştırır, skoru ölçer ve sonuç
  /// akışına gönderir. Her zaman çağrılabilir (boş/eksik soru yanlış).
  void _onFinish() {
    if (_completed) return;
    _timer?.cancel();
    _durationMs = _startedAt != null
        ? DateTime.now().difference(_startedAt!).inMilliseconds
        : _elapsedSeconds * 1000;
    _correctItems = _engine.correctCount;
    setState(() => _completed = true);
    _submitResult();
  }

  /// Tamamlanınca sonucu gönderir; başarıda Oyun Sonu Raporu ekranına geçer.
  /// Hata durumunda yerel [_submitFailed] ile "tekrar dene" gösterir.
  Future<void> _submitResult() async {
    if (mounted) setState(() => _submitFailed = false);
    final result = await ref.read(submitResultControllerProvider.notifier).submit(
          sessionId: widget.sessionId,
          durationMs: _durationMs,
          totalItems: _engine.total,
          correctItems: _correctItems,
          items: _engine.resultItems(),
        );
    if (!mounted) return;
    if (result == null) {
      setState(() => _submitFailed = true);
      return;
    }
    // Raporu seed ederek aç (ağ çağrısı tekrarlanmaz).
    context.pushReplacement(
      AppRoutes.studentResultDetail(result.id),
      extra: result,
    );
  }

  /// Çıkış onayı (geri / üstteki ok) — veri kaybı uyarısı.
  Future<bool> _confirmQuit() async {
    if (_completed) return true;
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          l10n.gameMatchingQuitConfirmTitle,
          style: AppTypography.headlineMd,
        ),
        content: Text(
          l10n.gameMatchingQuitConfirmDesc,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.gameMatchingQuitConfirmCancel,
              style: AppTypography.labelLg.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.gameMatchingQuitConfirmConfirm,
              style: AppTypography.labelLg.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _exit() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/student');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final card = _engine.activeCard;
    // İlerleme çubuğu: bulunduğumuz sorunun konumuna göre (Stitch §progress).
    final progress =
        _engine.total == 0 ? 0.0 : (_engine.activeIndex + 1) / _engine.total;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmQuit() && mounted) _exit();
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: _GameAppBar(
          title: l10n.questionSetTitle,
          subtitle: l10n.questionSetSubtitle,
          onBack: () async {
            if (await _confirmQuit() && mounted) _exit();
          },
        ),
        bottomNavigationBar: _NavFooter(
          previousLabel: l10n.questionSetPrevious,
          nextLabel: l10n.questionSetNextQuestion,
          finishLabel: l10n.questionSetFinish,
          isLast: _engine.isLast,
          submitting: _completed && !_submitFailed,
          onPrev: (_completed || _engine.isFirst) ? null : _onPrev,
          onNext: _completed ? null : _onNext,
          onFinish: _completed ? null : _onFinish,
        ),
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.marginMobile,
                  AppSpacing.md,
                  AppSpacing.marginMobile,
                  AppSpacing.lg,
                ),
                children: [
                  _ProgressSection(
                    questionLabel: l10n.questionSetQuestionOf(
                      _engine.activeIndex + 1,
                      _engine.total,
                    ),
                    timeLabel: l10n.questionSetElapsed(_formattedTime),
                    timeSemantic:
                        l10n.gameMatchingTimerSemantic(_formattedTime),
                    progress: progress,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (card != null) ...[
                    _QuestionCard(stem: card.stem),
                    const SizedBox(height: AppSpacing.lg),
                    for (final choice in card.choices) ...[
                      _OptionCard(
                        choice: choice,
                        selected: card.selectedOptionId == choice.optionId,
                        onTap: () => _onSelectOption(choice.optionId),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ],
              ),
            ),
            if (_completed)
              _CompletionGate(
                failed: _submitFailed,
                error: ref.read(submitResultControllerProvider).error,
                onRetry: _submitResult,
              ),
          ],
        ),
      ),
    );
  }
}

/// Tamamlanma kapısı: sonuç gönderimi sürerken yükleniyor overlay'i, hata
/// olunca tekrar dene. Başarıda ekran rapora geçtiği için overlay görünmez olur.
class _CompletionGate extends StatelessWidget {
  const _CompletionGate({
    required this.failed,
    required this.error,
    required this.onRetry,
  });

  final bool failed;
  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (failed) {
      return CompletionOverlay.error(
        title: l10n.gameResultSubmitError,
        message: error != null
            ? resultsFailureMessage(error!, l10n)
            : l10n.commonErrorGeneric,
        retryLabel: l10n.commonRetry,
        onRetry: onRetry,
      );
    }
    return CompletionOverlay.submitting(
      title: l10n.gameMatchingCompleteTitle,
      message: l10n.gameResultSubmitting,
    );
  }
}

/// Üst başlık (Stitch §header): geri ok (sol) + başlık (headline-md, primary) +
/// alt başlık (label-sm, onSurfaceVariant). Seri rozeti uygulanmaz (sapma).
class _GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _GameAppBar({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(color: AppColors.surface),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 68,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  tooltip: l10n.gameMatchingQuit,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineMd.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
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

/// İlerleme başlığı (Stitch §progress header): solda "Soru x / y" (label-lg,
/// primary), sağda geçen süre "Süre MM:SS" (label-sm, onSurfaceVariant);
/// altında pill ilerleme çubuğu (track surfaceContainerHighest, dolu primary).
class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.questionLabel,
    required this.timeLabel,
    required this.timeSemantic,
    required this.progress,
  });

  final String questionLabel;
  final String timeLabel;
  final String timeSemantic;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                questionLabel,
                style: AppTypography.labelLg.copyWith(color: AppColors.primary),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Semantics(
              liveRegion: false,
              label: timeSemantic,
              child: ExcludeSemantics(
                child: Text(
                  timeLabel,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: Container(
            height: 12,
            color: AppColors.surfaceContainerHighest,
            child: Align(
              alignment: Alignment.centerLeft,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Soru kartı (Stitch §question card — bento, köşe xl, soft shadow).
class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.stem});

  final String stem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.soft,
      ),
      child: Text(
        stem,
        style: AppTypography.headlineLg.copyWith(height: 1.3),
      ),
    );
  }
}

/// Tek bir şık kartı (A–E). Seçili → 2px primary kenarlık + surfaceContainerHighest
/// zemin + rozet primary/onPrimary. Nötr → outlineVariant kenarlık + rozet
/// surfaceContainerHigh/primary. Doğruluk YOK — oyun sırasında nötr
/// (Stitch §option-card.selected).
class _OptionCard extends StatefulWidget {
  const _OptionCard({
    required this.choice,
    required this.selected,
    required this.onTap,
  });

  final QuestionChoice choice;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<_OptionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    return Semantics(
      button: true,
      selected: selected,
      label: '${widget.choice.label}, ${widget.choice.text}',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.surfaceContainerHighest
                  : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.outlineVariant,
                width: 2,
              ),
              boxShadow: selected ? AppShadows.level2 : AppShadows.soft,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _OptionBadge(label: widget.choice.label, selected: selected),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    widget.choice.text,
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.onSurface),
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

/// Şık harf rozeti (A–E) — 40x40, köşe lg. Seçiliyse primary dolu/onPrimary
/// yazı; nötrse surfaceContainerHigh zemin/primary yazı (Stitch §option badge).
class _OptionBadge extends StatelessWidget {
  const _OptionBadge({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary
            : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Text(
        label,
        style: AppTypography.headlineMd.copyWith(
          color: selected ? AppColors.onPrimary : AppColors.primary,
        ),
      ),
    );
  }
}

/// Alt sabit footer (Stitch §navigation footer): solda "Önceki" (outlined,
/// chevron_left, ilk soruda pasif), sağda son soruda "Bitir", diğerlerinde
/// "Sonraki Soru" (primary 3D buton). Gönderiliyor → Bitir spinner.
class _NavFooter extends StatelessWidget {
  const _NavFooter({
    required this.previousLabel,
    required this.nextLabel,
    required this.finishLabel,
    required this.isLast,
    required this.submitting,
    required this.onPrev,
    required this.onNext,
    required this.onFinish,
  });

  final String previousLabel;
  final String nextLabel;
  final String finishLabel;
  final bool isLast;
  final bool submitting;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onFinish;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.md,
            AppSpacing.marginMobile,
            AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPrev,
                  icon: const Icon(Icons.chevron_left, size: 20),
                  label: Text(previousLabel, style: AppTypography.labelLg),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    foregroundColor: AppColors.onSurfaceVariant,
                    side: const BorderSide(
                      color: AppColors.surfaceContainerHighest,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: isLast
                    ? PrimaryButton3D(
                        label: finishLabel,
                        isLoading: submitting,
                        onPressed: onFinish,
                      )
                    : PrimaryButton3D(
                        label: nextLabel,
                        trailingIcon: Icons.chevron_right,
                        onPressed: onNext,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
