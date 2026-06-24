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
import '../../domain/word_matching_engine.dart';
import '../widgets/completion_overlay.dart';
import '../widgets/game_card.dart';
import '../widgets/match_progress_header.dart';

/// Kelime Eşleştirme Oyun ekranı (game-word-matching.md — Stitch birebir).
///
/// İki sütun tap-eşleştirme: sol = İngilizce terimler, sağ = karışık Türkçe
/// karşılıklar (doğru çeviriler + çeldiriciler). Count-up timer, ilerleme
/// pill + sayaç. Footer "Vazgeç" (çıkış onayı). M4: streak rozeti ve "İpucu"
/// gizli. M5: tüm çiftler eşleşince `POST /game-sessions/{id}/result` ile sonuç
/// gönderilir (yükleniyor overlay'i; hata → tekrar dene) ve dönen sonuçla Oyun
/// Sonu Raporu ekranına geçilir.
class WordMatchingGameScreen extends ConsumerStatefulWidget {
  const WordMatchingGameScreen({
    super.key,
    required this.sessionId,
    required this.content,
  });

  /// Sonuç gönderiminde kullanılan oyun oturumu kimliği.
  final String sessionId;
  final WordMatchingContent content;

  @override
  ConsumerState<WordMatchingGameScreen> createState() =>
      _WordMatchingGameScreenState();
}

class _WordMatchingGameScreenState
    extends ConsumerState<WordMatchingGameScreen> {
  late WordMatchingEngine _engine;
  Timer? _timer;
  int _elapsedSeconds = 0;
  int _durationMs = 0; // bitince ölçülen kesin süre (ms).
  bool _completed = false;
  bool _submitFailed = false; // sonuç gönderimi hatası (tekrar dene).
  int _correctItems = 0; // "Bitir" anında ölçülen doğru eşleşme sayısı.
  DateTime? _startedAt;

  @override
  void initState() {
    super.initState();
    _engine = WordMatchingEngine.fromContent(widget.content);
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

  void _onTermTap(int index) {
    if (_completed) return;
    setState(() => _engine = _engine.selectTerm(index));
  }

  /// Karşılığa dokunuş: seçili terim varsa eşleştir; yoksa (zaten bağlıysa)
  /// eşleştirmeyi geri al. Doğruluk OYUN SIRASINDA gösterilmez.
  void _onTranslationTap(int index) {
    if (_completed) return;
    setState(() {
      if (_engine.selectedTermWordId != null) {
        _engine = _engine.matchTranslation(index);
      } else {
        _engine = _engine.unmatchTranslation(index);
      }
    });
  }

  /// "Bitir" — serbest eşleştirmeleri doğru cevapla karşılaştırır, skoru ölçer
  /// ve sonuç akışına gönderir. Her zaman çağrılabilir (boş bırakılan çift yanlış).
  void _onFinish() {
    if (_completed) return;
    _timer?.cancel();
    _durationMs = _startedAt != null
        ? DateTime.now().difference(_startedAt!).inMilliseconds
        : _elapsedSeconds * 1000;
    _correctItems = _engine.score;
    setState(() => _completed = true);
    _submitResult();
  }

  /// Tamamlanınca sonucu gönderir; başarıda Oyun Sonu Raporu ekranına geçer.
  /// correctItems = "Bitir" anında ölçülen doğru eşleşme sayısı, totalItems =
  /// toplam çift. Hata durumunda yerel [_submitFailed] ile "tekrar dene" gösterir.
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
      builder:
          (ctx) => AlertDialog(
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
                    title: l10n.gameMatchingTitle,
                    counter: l10n.gameMatchingCounter(
                      _engine.matched,
                      _engine.total,
                    ),
                    progress: _engine.progress,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _Board(
                    engine: _engine,
                    matchedLabel: l10n.gameMatchingA11yMatched,
                    onTermTap: _onTermTap,
                    onTranslationTap: _onTranslationTap,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _EncouragementPanel(text: l10n.gameMatchingEncouragement),
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

  /// Sonuç gönderimi başarısız oldu mu (yerel durum).
  final bool failed;

  /// Gönderim hatası (mesaj için); başarısızken dolu.
  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (failed) {
      return CompletionOverlay.error(
        title: l10n.gameResultSubmitError,
        message:
            error != null
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

/// TopAppBar: geri + wordmark (sol), timer pill (sağ). Streak rozeti M4'te gizli.
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

/// Count-up timer pill (MM:SS). Sapma 3: geçen süre ölçülür.
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

/// İki sütun oyun tahtası (grid-cols-2).
class _Board extends StatelessWidget {
  const _Board({
    required this.engine,
    required this.matchedLabel,
    required this.onTermTap,
    required this.onTranslationTap,
  });

  final WordMatchingEngine engine;
  final String matchedLabel;
  final ValueChanged<int> onTermTap;
  final ValueChanged<int> onTranslationTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _Column(
            heading: l10n.gameMatchingColEnglishUpper,
            children: [
              for (var i = 0; i < engine.terms.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: TermGameCard(
                    card: engine.terms[i],
                    matchedLabel: matchedLabel,
                    onTap: () => onTermTap(i),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _Column(
            heading: l10n.gameMatchingColTurkishUpper,
            children: [
              for (var i = 0; i < engine.translations.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: TranslationGameCard(
                    card: engine.translations[i],
                    matched: engine.isTranslationMatched(i),
                    matchedLabel: matchedLabel,
                    onTap: () => onTranslationTap(i),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Column extends StatelessWidget {
  const _Column({required this.heading, required this.children});

  final String heading;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Text(
            heading,
            textAlign: TextAlign.center,
            style: AppTypography.labelSm.copyWith(
              color: AppColors.outline,
              letterSpacing: 2,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

/// Teşvik paneli (illüstrasyon kutusu) — dekoratif + ortalı italik metin.
class _EncouragementPanel extends StatelessWidget {
  const _EncouragementPanel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dekoratif arka plan deseni (a11y: gizli).
          Positioned.fill(
            child: ExcludeSemantics(
              child: Opacity(
                opacity: 0.2,
                child: Icon(
                  Icons.auto_stories,
                  size: 96,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Alt aksiyon çubuğu — "Bitir" (primary) + "Vazgeç" (outlined).
///
/// "Bitir" her zaman aktif: serbestçe eşleştirip istediği an bitirebilir
/// (eksik/yanlış çiftler skorda yanlış sayılır). M4: "İpucu" gösterilmez.
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
