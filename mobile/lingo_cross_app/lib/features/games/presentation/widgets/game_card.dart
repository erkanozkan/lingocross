import 'package:flutter/material.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/game_type.dart';
import '../../domain/word_matching_engine.dart';

/// Oyun türüne göre liste/kart ikonu. QuestionSet (Çıkmış Sorular) ayrı dallanır;
/// diğerleri mevcut ikonlarını korur (eşleştirme varsayılan).
IconData gameTypeIcon(GameType type) => switch (type) {
      GameType.crossword => Icons.grid_on,
      GameType.scrambled => Icons.shuffle,
      GameType.questionSet => Icons.history_edu,
      GameType.wordMatching => Icons.extension,
    };

/// Oyun türünün i18n etiketi (öğrenci panelindeki atanan oyun kartı vb.).
String gameTypeLabel(GameType type, AppLocalizations l10n) => switch (type) {
      GameType.crossword => l10n.myPuzzlesTypeCrossword,
      GameType.scrambled => l10n.createGameTypeScrambledTitle,
      GameType.questionSet => l10n.gameCardQuestionSet,
      GameType.wordMatching => l10n.myPuzzlesTypeWordMatching,
    };

/// Kart taban kalıbı: min-h 80, köşe lg (16), ortalı body-lg semibold.
const double _kCardMinHeight = 80;

/// Sol sütun terim kartı (nötr / seçili / eşleştirildi).
///
/// Serbest eşleştirmede doğruluk renkleri YOK: "eşleştirildi" durumu da nötr
/// (tonal) gösterilir; yeşil/kırmızı geri bildirim oyun sırasında verilmez.
class TermGameCard extends StatelessWidget {
  const TermGameCard({
    super.key,
    required this.card,
    required this.matchedLabel,
    required this.onTap,
  });

  final TermCard card;
  final String matchedLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final matched = card.status == TermCardStatus.matched;
    final selected = card.status == TermCardStatus.selected;

    final Color bg;
    final Color border;
    final Color fg;
    if (selected) {
      bg = AppColors.primaryContainer;
      border = AppColors.primary;
      fg = AppColors.onPrimaryContainer;
    } else if (matched) {
      // Eşleştirildi — nötr tonal (doğruluk gizli).
      bg = AppColors.surfaceContainerHigh;
      border = AppColors.outline;
      fg = AppColors.onSurface;
    } else {
      bg = AppColors.surfaceContainerLowest;
      border = AppColors.outlineVariant;
      fg = AppColors.onSurface;
    }

    return Semantics(
      button: true,
      label: matched ? '${card.term}, $matchedLabel' : card.term,
      child: _CardSurface(
        bg: bg,
        border: border,
        borderWidth: (selected || matched) ? 2 : 1,
        selected: selected,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              card.term,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLg
                  .copyWith(color: fg, fontWeight: FontWeight.w600),
            ),
            if (matched) ...[
              const SizedBox(height: AppSpacing.base),
              const Icon(Icons.link, size: 18, color: AppColors.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }
}

/// Sağ sütun karşılık kartı (nötr / eşleştirildi). Doğruluk renkleri YOK.
class TranslationGameCard extends StatelessWidget {
  const TranslationGameCard({
    super.key,
    required this.card,
    required this.matched,
    required this.matchedLabel,
    required this.onTap,
  });

  final TranslationCard card;

  /// Bu karşılık şu an bir terime bağlı mı (görünür eşleştirme durumu).
  final bool matched;
  final String matchedLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color border;
    final Color fg;
    if (matched) {
      bg = AppColors.surfaceContainerHigh;
      border = AppColors.outline;
      fg = AppColors.onSurface;
    } else {
      bg = AppColors.surfaceContainerLowest;
      border = AppColors.outlineVariant;
      fg = AppColors.onSurface;
    }

    final label =
        matched ? '${card.text}, $matchedLabel' : card.text;

    return Semantics(
      button: true,
      label: label,
      child: _CardSurface(
        bg: bg,
        border: border,
        borderWidth: matched ? 2 : 1,
        selected: false,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              card.text,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLg
                  .copyWith(color: fg, fontWeight: FontWeight.w600),
            ),
            if (matched) ...[
              const SizedBox(height: AppSpacing.base),
              const Icon(Icons.link, size: 18, color: AppColors.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }
}

/// Ortak kart yüzeyi: min yükseklik, köşe, kenarlık, press feedback.
class _CardSurface extends StatefulWidget {
  const _CardSurface({
    required this.bg,
    required this.border,
    required this.borderWidth,
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final Color bg;
  final Color border;
  final double borderWidth;
  final bool selected;
  final VoidCallback? onTap;
  final Widget child;

  @override
  State<_CardSurface> createState() => _CardSurfaceState();
}

class _CardSurfaceState extends State<_CardSurface> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = widget.selected
        ? 1.05
        : (_pressed && widget.onTap != null ? 0.95 : 1.0);
    return GestureDetector(
      onTapDown:
          widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp:
          widget.onTap != null ? (_) => setState(() => _pressed = false) : null,
      onTapCancel:
          widget.onTap != null ? () => setState(() => _pressed = false) : null,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(minHeight: _kCardMinHeight),
          padding: const EdgeInsets.all(AppSpacing.md),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.bg,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: widget.border, width: widget.borderWidth),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
