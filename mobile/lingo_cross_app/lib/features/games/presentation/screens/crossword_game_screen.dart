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
import '../../domain/crossword_engine.dart';
import '../widgets/completion_overlay.dart';
import '../widgets/crossword_keyboard.dart';

/// Crossword Oyun ekranı (Stitch `b00703d2…` birebir).
///
/// Üst bar: geri + LingoCross + count-up timer + ilerleme pill. Izgara
/// `rows×cols`; bulmacaya ait hücreler mavi (doldurulabilir), diğerleri koyu.
/// Başlangıç hücrelerinde küçük numara, aktif kelime vurgulu. Alt sabit özel
/// Türkçe A–Z klavye. İpucu listeleri "Soldan Sağa" / "Yukarıdan Aşağı" —
/// dokununca o kelimeye odaklanır. Tüm hücreler dolunca veya "Bitir" ile süre +
/// doğru/toplam ile `POST /game-sessions/{id}/result` → Oyun Sonu Raporu.
class CrosswordGameScreen extends ConsumerStatefulWidget {
  const CrosswordGameScreen({
    super.key,
    required this.sessionId,
    required this.content,
  });

  /// Sonuç gönderiminde kullanılan oyun oturumu kimliği.
  final String sessionId;
  final CrosswordContent content;

  @override
  ConsumerState<CrosswordGameScreen> createState() =>
      _CrosswordGameScreenState();
}

class _CrosswordGameScreenState extends ConsumerState<CrosswordGameScreen> {
  late CrosswordEngine _engine;
  Timer? _timer;
  int _elapsedSeconds = 0;
  int _durationMs = 0;
  bool _completed = false;
  bool _submitFailed = false;
  int _correctItems = 0; // "Bitir" anında ölçülen doğru kelime sayısı.
  DateTime? _startedAt;

  @override
  void initState() {
    super.initState();
    _engine = CrosswordEngine.fromContent(widget.content);
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

  void _onCellTap(int row, int col) {
    if (_completed) return;
    setState(() => _engine = _engine.selectCell(row, col));
  }

  void _onClueTap(int entryIndex) {
    if (_completed) return;
    setState(() => _engine = _engine.focusEntry(entryIndex));
  }

  void _onKey(String letter) {
    if (_completed) return;
    setState(() => _engine = _engine.enterLetter(letter));
  }

  void _onDelete() {
    if (_completed) return;
    setState(() => _engine = _engine.deleteLetter());
  }

  /// "Bitir" — her zaman aktif. Tüm girişleri doğru cevapla karşılaştırır,
  /// doğru kelime sayısını ölçer (boş/yanlış → o kelime yanlış) ve gönderir.
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
  /// totalItems = giriş sayısı, correctItems = "Bitir" anında doğru çözülen
  /// kelime sayısı. Doğruluk oyun sırasında gösterilmez.
  Future<void> _submitResult() async {
    if (mounted) setState(() => _submitFailed = false);
    final result =
        await ref.read(submitResultControllerProvider.notifier).submit(
              sessionId: widget.sessionId,
              durationMs: _durationMs,
              totalItems: _engine.totalCount,
              correctItems: _correctItems,
            );
    if (!mounted) return;
    if (result == null) {
      setState(() => _submitFailed = true);
      return;
    }
    context.pushReplacement(
      AppRoutes.studentResultDetail(result.id),
      extra: result,
    );
  }

  /// Çıkış onayı (geri) — veri kaybı uyarısı (eşleştirme ile aynı metinler).
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
          style:
              AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.gameMatchingQuitConfirmCancel,
              style: AppTypography.labelLg
                  .copyWith(color: AppColors.onSurfaceVariant),
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
    // "Bitir" her zaman aktif (öğrenci boş bıraksa bile bitirebilir).
    final canFinish = !_completed;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmQuit() && mounted) _exit();
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: _CrosswordAppBar(
          time: _formattedTime,
          onBack: () async {
            if (await _confirmQuit() && mounted) _exit();
          },
        ),
        bottomNavigationBar: CrosswordKeyboard(
          onKey: _onKey,
          onDelete: _onDelete,
          onEnter: _onFinish,
          enterEnabled: canFinish,
        ),
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.marginMobile,
                  AppSpacing.sm,
                  AppSpacing.marginMobile,
                  AppSpacing.lg,
                ),
                children: [
                  _ProgressTitle(
                    title: l10n.gameCrosswordTitle,
                    time: _formattedTime,
                    counter: l10n.gameCrosswordCounter(
                      _engine.filledCount,
                      _engine.totalCount,
                    ),
                    progress: _engine.progress,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _Grid(engine: _engine, onCellTap: _onCellTap),
                  const SizedBox(height: AppSpacing.lg),
                  _ClueColumns(engine: _engine, onClueTap: _onClueTap),
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

/// Tamamlanma kapısı (eşleştirme ekranı ile aynı desen): gönderim sürerken
/// yükleniyor overlay'i, hata olunca tekrar dene.
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
      title: l10n.gameCrosswordCompleteTitle,
      message: l10n.gameResultSubmitting,
    );
  }
}

/// TopAppBar: geri + wordmark (sol), timer pill (sağ).
class _CrosswordAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CrosswordAppBar({required this.time, required this.onBack});

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
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  tooltip: l10n.gameMatchingQuit,
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    l10n.appName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineLg
                        .copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                _TimerPill(time: time),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimerPill extends StatelessWidget {
  const _TimerPill({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.gameMatchingTimerSemantic(time),
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
              style: AppTypography.labelLg
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// Başlık + ilerleme bölümü (Stitch §progress & title): başlık + zaman + pill.
class _ProgressTitle extends StatelessWidget {
  const _ProgressTitle({
    required this.title,
    required this.time,
    required this.counter,
    required this.progress,
  });

  final String title;
  final String time;
  final String counter;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(title, style: AppTypography.headlineLg),
            ),
            Text(
              counter,
              style: AppTypography.labelLg
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 16,
            backgroundColor: AppColors.surfaceContainer,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

/// Bulmaca ızgarası (Stitch §puzzle-grid): kare, `cols` sütun, 2px boşluk.
class _Grid extends StatelessWidget {
  const _Grid({required this.engine, required this.onCellTap});

  final CrosswordEngine engine;
  final void Function(int row, int col) onCellTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: AppShadows.level2,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: engine.rows * engine.cols,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: engine.cols,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            final row = index ~/ engine.cols;
            final col = index % engine.cols;
            return _Cell(
              engine: engine,
              row: row,
              col: col,
              onTap: () => onCellTap(row, col),
            );
          },
        ),
      ),
    );
  }
}

/// Tek ızgara hücresi. Koyu = bulmacaya ait değil; mavi = doldurulabilir.
/// Aktif hücre = primary inset çerçeve + tonal zemin; aktif kelime = açık tonal.
class _Cell extends StatelessWidget {
  const _Cell({
    required this.engine,
    required this.row,
    required this.col,
    required this.onTap,
  });

  final CrosswordEngine engine;
  final int row;
  final int col;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cell = engine.cellAt(row, col);
    final l10n = AppLocalizations.of(context);

    if (cell.isBlock) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.inverseSurface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      );
    }

    final isActive = engine.activeRow == row && engine.activeCol == col;
    final inWord = engine.isInActiveWord(row, col);
    final letter = engine.letterAt(row, col);

    Color bg;
    BoxBorder? border;
    if (isActive) {
      bg = AppColors.surfaceContainer;
      border = Border.all(color: AppColors.primaryContainer, width: 2);
    } else if (inWord) {
      bg = AppColors.surfaceContainerHighest;
    } else {
      bg = AppColors.surfaceContainerHighest;
    }

    return Semantics(
      button: true,
      selected: isActive,
      label: cell.number != null
          ? l10n.gameCrosswordCellNumberedSemantic(cell.number!)
          : l10n.gameCrosswordCellSemantic,
      value: letter.isEmpty ? l10n.gameCrosswordCellEmpty : letter,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: border,
          ),
          child: Stack(
            children: [
              if (cell.number != null)
                Positioned(
                  top: 1,
                  left: 2,
                  child: Text(
                    '${cell.number}',
                    style: const TextStyle(
                      fontSize: 8,
                      height: 1,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              Center(
                child: FittedBox(
                  child: Text(
                    letter,
                    style: AppTypography.headlineMd.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
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

/// İpucu sütunları (Stitch §clue list): "Soldan Sağa" / "Yukarıdan Aşağı".
class _ClueColumns extends StatelessWidget {
  const _ClueColumns({required this.engine, required this.onClueTap});

  final CrosswordEngine engine;
  final void Function(int entryIndex) onClueTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final activeIdx = engine.activeEntryIndex;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _ClueGroup(
            icon: Icons.swap_horiz,
            color: AppColors.primary,
            heading: l10n.gameCrosswordAcross,
            indices: engine.acrossIndices,
            engine: engine,
            activeIndex: activeIdx,
            onClueTap: onClueTap,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _ClueGroup(
            icon: Icons.swap_vert,
            color: AppColors.tertiary,
            heading: l10n.gameCrosswordDown,
            indices: engine.downIndices,
            engine: engine,
            activeIndex: activeIdx,
            onClueTap: onClueTap,
          ),
        ),
      ],
    );
  }
}

class _ClueGroup extends StatelessWidget {
  const _ClueGroup({
    required this.icon,
    required this.color,
    required this.heading,
    required this.indices,
    required this.engine,
    required this.activeIndex,
    required this.onClueTap,
  });

  final IconData icon;
  final Color color;
  final String heading;
  final List<int> indices;
  final CrosswordEngine engine;
  final int? activeIndex;
  final void Function(int entryIndex) onClueTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                heading,
                style: AppTypography.labelLg
                    .copyWith(color: color, letterSpacing: 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final idx in indices)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _ClueItem(
              number: engine.entries[idx].number,
              clue: engine.entries[idx].clue,
              active: idx == activeIndex,
              onTap: () => onClueTap(idx),
            ),
          ),
      ],
    );
  }
}

/// İpucu satırı. Doğruluk OYUN SIRASINDA gösterilmez; yalnız aktif kelime
/// vurgulanır (serbest oyun — yeşil/check geri bildirimi yok).
class _ClueItem extends StatelessWidget {
  const _ClueItem({
    required this.number,
    required this.clue,
    required this.active,
    required this.onTap,
  });

  final int number;
  final String clue;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bg = active
        ? AppColors.primaryContainer
        : AppColors.surfaceContainerLowest;
    final Color fg =
        active ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant;
    final Color borderColor =
        active ? AppColors.primaryContainer : AppColors.outlineVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: borderColor.withValues(alpha: active ? 1 : 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number.',
                style: AppTypography.bodyMd.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Text(
                  clue,
                  style: AppTypography.bodyMd.copyWith(color: fg),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
