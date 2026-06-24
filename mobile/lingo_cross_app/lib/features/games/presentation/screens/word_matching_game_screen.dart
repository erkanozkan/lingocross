import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/dtos/game_dtos.dart';
import '../../domain/word_matching_engine.dart';
import '../widgets/completion_overlay.dart';
import '../widgets/game_card.dart';
import '../widgets/match_progress_header.dart';

/// Kelime Eşleştirme Oyun ekranı (game-word-matching.md — Stitch birebir).
///
/// İki sütun tap-eşleştirme: sol = İngilizce terimler, sağ = karışık Türkçe
/// karşılıklar (doğru çeviriler + çeldiriciler). Count-up timer, ilerleme
/// pill + sayaç. Footer "Vazgeç" (çıkış onayı). M4: streak rozeti ve "İpucu"
/// gizli; tamamlanınca minimal overlay (süre + doğru/toplam) → "Bitir" panele.
class WordMatchingGameScreen extends StatefulWidget {
  const WordMatchingGameScreen({super.key, required this.content});

  final WordMatchingContent content;

  @override
  State<WordMatchingGameScreen> createState() => _WordMatchingGameScreenState();
}

class _WordMatchingGameScreenState extends State<WordMatchingGameScreen> {
  late WordMatchingEngine _engine;
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _completed = false;
  bool _locked = false; // yanlış flaş sırasında girişleri kilitle

  @override
  void initState() {
    super.initState();
    _engine = WordMatchingEngine.fromContent(widget.content);
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
    if (_locked || _completed) return;
    setState(() => _engine = _engine.selectTerm(index));
  }

  Future<void> _onTranslationTap(int index) async {
    if (_locked || _completed) return;
    final outcome = _engine.evaluateTranslation(index);
    switch (outcome) {
      case MatchOutcome.none:
        return;
      case MatchOutcome.correct:
        setState(() => _engine = _engine.applyCorrect(index));
        if (_engine.isComplete) _finish();
      case MatchOutcome.wrong:
        // Kırmızı flaş + shake; ~400ms sonra seçim sıfırlanır.
        setState(() {
          _engine = _engine.markWrong(index);
          _locked = true;
        });
        await Future<void>.delayed(const Duration(milliseconds: 450));
        if (!mounted) return;
        setState(() {
          _engine = _engine.resetSelection();
          _locked = false;
        });
    }
  }

  void _finish() {
    _timer?.cancel();
    setState(() => _completed = true);
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
        title: Text(l10n.gameMatchingQuitConfirmTitle,
            style: AppTypography.headlineMd),
        content: Text(l10n.gameMatchingQuitConfirmDesc,
            style: AppTypography.bodyMd
                .copyWith(color: AppColors.onSurfaceVariant)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.gameMatchingQuitConfirmCancel,
                style: AppTypography.labelLg
                    .copyWith(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.gameMatchingQuitConfirmConfirm,
                style:
                    AppTypography.labelLg.copyWith(color: AppColors.error)),
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
        bottomNavigationBar: _QuitBar(
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
                        _engine.matched, _engine.total),
                    progress: _engine.progress,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _Board(
                    engine: _engine,
                    matchedLabel: l10n.gameMatchingA11yMatched,
                    wrongLabel: l10n.gameMatchingA11yWrong,
                    onTermTap: _onTermTap,
                    onTranslationTap: _onTranslationTap,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _EncouragementPanel(text: l10n.gameMatchingEncouragement),
                ],
              ),
            ),
            if (_completed)
              CompletionOverlay(
                title: l10n.gameMatchingCompleteTitle,
                message: l10n.gameMatchingCompleteMessage(
                  _engine.matched,
                  _engine.total,
                  _formattedTime,
                ),
                finishLabel: l10n.gameMatchingCompleteFinish,
                onFinish: _exit,
              ),
          ],
        ),
      ),
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
                horizontal: AppSpacing.marginMobile),
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
                  style: AppTypography.headlineLg
                      .copyWith(color: AppColors.primary),
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
            horizontal: AppSpacing.sm, vertical: AppSpacing.base),
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
              style: AppTypography.labelLg
                  .copyWith(color: AppColors.onSurfaceVariant),
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
    required this.wrongLabel,
    required this.onTermTap,
    required this.onTranslationTap,
  });

  final WordMatchingEngine engine;
  final String matchedLabel;
  final String wrongLabel;
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
                    matchedLabel: matchedLabel,
                    wrongLabel: wrongLabel,
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

/// Alt aksiyon çubuğu — yalnız "Vazgeç" (M4: "İpucu" gösterilmez).
class _QuitBar extends StatelessWidget {
  const _QuitBar({required this.onQuit});

  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          child: OutlinedButton.icon(
            onPressed: onQuit,
            icon: const Icon(Icons.close, color: AppColors.outline),
            label: Text(
              l10n.gameMatchingQuit,
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
      ),
    );
  }
}
