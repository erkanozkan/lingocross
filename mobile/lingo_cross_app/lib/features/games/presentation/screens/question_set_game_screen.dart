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
import '../../../results/presentation/results_failure_messages.dart';
import '../../../results/presentation/submit_result_controller.dart';
import '../../data/dtos/game_dtos.dart';
import '../../domain/question_set_engine.dart';
import '../widgets/completion_overlay.dart';
import '../widgets/match_progress_header.dart';

/// Çıkmış Sorular (Soru Çözüm) ekranı — Karışık Harfler deseninin eşi.
///
/// 10 soru tek tek çözülür (A–E tek seçim). Oyun boyunca serbest; doğru/yanlış
/// OYUN SIRASINDA gösterilmez (nötr renkler). Stem + A–E şık listesi gösterilir;
/// Önceki/Sonraki ile gezilir. "Bitir" her zaman aktiftir → topluca değerlendirilir
/// (skorlama istemcide), sonuç `POST /game-sessions/{id}/result` ile gönderilir
/// (yükleniyor overlay'i; hata → tekrar dene) ve dönen sonuçla Oyun Sonu Raporu
/// ekranına geçilir.
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

  /// Çıkış onayı (Vazgeç / geri) — veri kaybı uyarısı.
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmQuit() && mounted) _exit();
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: _GameAppBar(
          time: _formattedTime,
          onBack: () async {
            if (await _confirmQuit() && mounted) _exit();
          },
        ),
        bottomNavigationBar: _ActionBar(
          finishLabel: l10n.gameMatchingCompleteFinish,
          quitLabel: l10n.gameMatchingQuit,
          onFinish: _completed ? null : _onFinish,
          onQuit: () async {
            if (await _confirmQuit() && mounted) _exit();
          },
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
                  MatchProgressHeader(
                    label: l10n.gameMatchingCurrentGameLabelUpper,
                    title: l10n.questionSetTitle,
                    counter: l10n.gameMatchingCounter(
                      _engine.answeredCount,
                      _engine.total,
                    ),
                    progress: _engine.progress,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (card != null) ...[
                    _QuestionNav(
                      label: l10n.questionSetQuestionOf(
                        _engine.activeIndex + 1,
                        _engine.total,
                      ),
                      previousLabel: l10n.gameScrambledPrevious,
                      nextLabel: l10n.gameScrambledNext,
                      onPrev: _engine.isFirst ? null : _onPrev,
                      onNext: _engine.isLast ? null : _onNext,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _QuestionCard(stem: card.stem),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.questionSetSelectAnswer,
                      style: AppTypography.labelLg
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.sm),
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

/// TopAppBar: geri + wordmark (sol), timer pill (sağ).
class _GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _GameAppBar({required this.time, required this.onBack});

  final String time;
  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                  icon: const Icon(Icons.arrow_back, color: AppColors.outline),
                  tooltip: l10n.gameMatchingQuit,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.appName,
                  style: AppTypography.headlineLg.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                _TimerPill(time: time),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Count-up timer pill (MM:SS).
class _TimerPill extends StatelessWidget {
  const _TimerPill({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.gameMatchingTimerSemantic(time),
      liveRegion: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.base,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.schedule, size: 20, color: AppColors.primary),
            const SizedBox(width: AppSpacing.base),
            Text(
              time,
              style: AppTypography.labelLg.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sorular arası ileri/geri gezinme (örn. "Soru 4 / 10").
class _QuestionNav extends StatelessWidget {
  const _QuestionNav({
    required this.label,
    required this.previousLabel,
    required this.nextLabel,
    required this.onPrev,
    required this.onNext,
  });

  final String label;
  final String previousLabel;
  final String nextLabel;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left),
          color: AppColors.primary,
          tooltip: previousLabel,
        ),
        Text(
          label,
          style:
              AppTypography.labelLg.copyWith(color: AppColors.onSurfaceVariant),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          color: AppColors.primary,
          tooltip: nextLabel,
        ),
      ],
    );
  }
}

/// Soru kartı: soru kökü (Stitch §question card — bento, köşe xl, soft shadow).
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
        style: AppTypography.headlineMd.copyWith(height: 1.3),
      ),
    );
  }
}

/// Tek bir şık kartı (A–E). Seçili → primary kenarlık + tint; nötr → outline.
/// Doğruluk renkleri YOK — oyun sırasında nötr (Stitch §option-card.selected).
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

/// Şık harf rozeti (A–E) — seçiliyse primary dolu, nötrse tonal.
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

/// Alt aksiyon çubuğu — "Bitir" (primary) + "Vazgeç" (outlined).
/// "Bitir" her zaman aktif (serbest oyun; boş/yanlış sorular skorda yanlış).
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.finishLabel,
    required this.quitLabel,
    required this.onFinish,
    required this.onQuit,
  });

  final String finishLabel;
  final String quitLabel;
  final VoidCallback? onFinish;
  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.sm,
            AppSpacing.marginMobile,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onQuit,
                  icon: const Icon(Icons.close, color: AppColors.outline),
                  label: Text(
                    quitLabel,
                    style: AppTypography.labelLg
                        .copyWith(color: AppColors.outline),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    side: const BorderSide(
                        color: AppColors.outlineVariant, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onFinish,
                  icon: const Icon(Icons.check),
                  label: Text(finishLabel, style: AppTypography.labelLg),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
