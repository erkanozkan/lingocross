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
import '../../../results/presentation/submit_result_controller.dart';
import '../../data/dtos/game_dtos.dart';
import '../../../results/presentation/results_failure_messages.dart';
import '../../domain/scrambled_engine.dart';
import '../widgets/completion_overlay.dart';
import '../widgets/match_progress_header.dart';

/// Scrambled (Karışık Harfler) oyun ekranı — Kelime Eşleştirme deseninin eşi.
///
/// Her kelime için çeviri ipucu + karışık harf havuzu gösterilir; öğrenci
/// **dokunarak** (tap-to-build) harfleri doğru sıraya dizer. Oyun boyunca
/// serbest; doğruluk OYUN SIRASINDA gösterilmez (nötr renkler). "Bitir" her
/// zaman aktiftir → topluca değerlendirilir, sonuç `POST /game-sessions/{id}/result`
/// ile gönderilir (yükleniyor overlay'i; hata → tekrar dene) ve dönen sonuçla
/// Oyun Sonu Raporu ekranına geçilir.
class ScrambledGameScreen extends ConsumerStatefulWidget {
  const ScrambledGameScreen({
    super.key,
    required this.sessionId,
    required this.content,
  });

  /// Sonuç gönderiminde kullanılan oyun oturumu kimliği.
  final String sessionId;
  final ScrambledContent content;

  @override
  ConsumerState<ScrambledGameScreen> createState() =>
      _ScrambledGameScreenState();
}

class _ScrambledGameScreenState extends ConsumerState<ScrambledGameScreen> {
  late ScrambledEngine _engine;
  Timer? _timer;
  int _elapsedSeconds = 0;
  int _durationMs = 0; // bitince ölçülen kesin süre (ms).
  bool _completed = false;
  bool _submitFailed = false; // sonuç gönderimi hatası (tekrar dene).
  int _correctItems = 0; // "Bitir" anında ölçülen doğru kelime sayısı.
  DateTime? _startedAt;

  @override
  void initState() {
    super.initState();
    _engine = ScrambledEngine.fromContent(widget.content);
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

  void _onLetterTap(int letterIndex) {
    if (_completed) return;
    setState(() => _engine = _engine.placeLetter(letterIndex));
  }

  void _onAnswerSlotTap(int answerPos) {
    if (_completed) return;
    setState(() => _engine = _engine.removeAt(answerPos));
  }

  void _onSelectWord(int index) {
    if (_completed) return;
    setState(() => _engine = _engine.selectWord(index));
  }

  /// "Bitir" — dizilen harfleri doğru cevapla karşılaştırır, skoru ölçer ve
  /// sonuç akışına gönderir. Her zaman çağrılabilir (boş/eksik kelime yanlış).
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
    final result = await ref
        .read(submitResultControllerProvider.notifier)
        .submit(
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
                    title: l10n.gameScrambledTitle,
                    counter: l10n.gameMatchingCounter(
                      _engine.filledCount,
                      _engine.total,
                    ),
                    progress: _engine.progress,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (card != null) ...[
                    _WordNav(
                      activeIndex: _engine.activeIndex,
                      total: _engine.total,
                      previousLabel: l10n.gameScrambledPrevious,
                      nextLabel: l10n.gameScrambledNext,
                      onSelect: _onSelectWord,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ScrambledCardView(
                      card: card,
                      clueLabel: l10n.gameScrambledClueLabel,
                      instruction: l10n.gameScrambledInstruction,
                      slotLabel: l10n.gameScrambledSlotSemantic,
                      letterLabel: l10n.gameScrambledLetterSemantic,
                      emptySlotLabel: l10n.gameScrambledEmptySlot,
                      onLetterTap: _onLetterTap,
                      onAnswerSlotTap: _onAnswerSlotTap,
                    ),
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

/// Kelimeler arası ileri/geri gezinme (örn. "2 / 6").
class _WordNav extends StatelessWidget {
  const _WordNav({
    required this.activeIndex,
    required this.total,
    required this.previousLabel,
    required this.nextLabel,
    required this.onSelect,
  });

  final int activeIndex;
  final int total;
  final String previousLabel;
  final String nextLabel;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: activeIndex > 0 ? () => onSelect(activeIndex - 1) : null,
          icon: const Icon(Icons.chevron_left),
          color: AppColors.primary,
          tooltip: previousLabel,
        ),
        Text(
          '${activeIndex + 1} / $total',
          style: AppTypography.labelLg.copyWith(color: AppColors.onSurfaceVariant),
        ),
        IconButton(
          onPressed:
              activeIndex < total - 1 ? () => onSelect(activeIndex + 1) : null,
          icon: const Icon(Icons.chevron_right),
          color: AppColors.primary,
          tooltip: nextLabel,
        ),
      ],
    );
  }
}

/// Aktif kelime kartı: çeviri ipucu (üstte), cevap yuvaları (dizilen harfler),
/// karışık harf havuzu (kalan harfler). Doğruluk renkleri YOK — nötr.
class _ScrambledCardView extends StatelessWidget {
  const _ScrambledCardView({
    required this.card,
    required this.clueLabel,
    required this.instruction,
    required this.slotLabel,
    required this.letterLabel,
    required this.emptySlotLabel,
    required this.onLetterTap,
    required this.onAnswerSlotTap,
  });

  final ScrambledCard card;
  final String clueLabel;
  final String instruction;
  final String slotLabel;
  final String letterLabel;
  final String emptySlotLabel;
  final ValueChanged<int> onLetterTap;
  final ValueChanged<int> onAnswerSlotTap;

  @override
  Widget build(BuildContext context) {
    final length = card.scrambledLetters.length;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Çeviri ipucu (üstte).
          Text(
            clueLabel,
            style: AppTypography.labelSm.copyWith(
              color: AppColors.outline,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(card.clue, style: AppTypography.headlineMd),
          const SizedBox(height: AppSpacing.lg),
          // Cevap yuvaları (dizilen harfler).
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (var pos = 0; pos < length; pos++)
                if (pos < card.built.length)
                  _AnswerSlot(
                    letter: card.scrambledLetters[card.built[pos]],
                    semanticLabel: slotLabel,
                    onTap: () => onAnswerSlotTap(pos),
                  )
                else
                  _EmptySlot(semanticLabel: emptySlotLabel),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            instruction,
            style: AppTypography.bodyMd
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Karışık harf havuzu (kalan harfler).
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (var i = 0; i < length; i++)
                _PoolLetter(
                  letter: card.scrambledLetters[i],
                  used: card.isLetterUsed(i),
                  semanticLabel: letterLabel,
                  onTap: () => onLetterTap(i),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Dolu cevap yuvası — dokununca harfi havuza geri alır. Nötr (primaryContainer).
class _AnswerSlot extends StatelessWidget {
  const _AnswerSlot({
    required this.letter,
    required this.semanticLabel,
    required this.onTap,
  });

  final String letter;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$letter, $semanticLabel',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Text(
            letter,
            style: AppTypography.headlineMd
                .copyWith(color: AppColors.onPrimaryContainer),
          ),
        ),
      ),
    );
  }
}

/// Boş cevap yuvası (henüz harf yerleştirilmemiş) — dashed-benzeri nötr kutu.
class _EmptySlot extends StatelessWidget {
  const _EmptySlot({required this.semanticLabel});

  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Container(
        width: 44,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.outlineVariant, width: 2),
        ),
      ),
    );
  }
}

/// Havuzdaki tek bir karışık harf chip'i. Kullanıldıysa soluk + dokunulamaz.
class _PoolLetter extends StatelessWidget {
  const _PoolLetter({
    required this.letter,
    required this.used,
    required this.semanticLabel,
    required this.onTap,
  });

  final String letter;
  final bool used;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (used) {
      // Yerleştirilmiş harf — havuzda yer tutar ama soluk, etkileşimsiz.
      return ExcludeSemantics(
        child: Container(
          width: 44,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Text(
            letter,
            style: AppTypography.headlineMd
                .copyWith(color: AppColors.outlineVariant),
          ),
        ),
      );
    }
    return Semantics(
      button: true,
      label: '$letter, $semanticLabel',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Text(
            letter,
            style: AppTypography.headlineMd
                .copyWith(color: AppColors.onPrimaryContainer),
          ),
        ),
      ),
    );
  }
}

/// Alt aksiyon çubuğu — "Bitir" (primary) + "Vazgeç" (outlined).
/// "Bitir" her zaman aktif (serbest oyun; eksik/yanlış kelimeler skorda yanlış).
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
                    style:
                        AppTypography.labelLg.copyWith(color: AppColors.outline),
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
