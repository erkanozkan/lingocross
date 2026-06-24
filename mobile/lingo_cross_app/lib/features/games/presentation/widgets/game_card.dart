import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/word_matching_engine.dart';

/// Kart taban kalıbı: min-h 80, rounded-xl, ortalı body-lg semibold.
const double _kCardMinHeight = 80;

/// Sol sütun terim kartı (nötr / seçili / eşleşti).
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
    if (matched) {
      bg = AppColors.tertiaryContainer.withValues(alpha: 0.1);
      border = AppColors.tertiary;
      fg = AppColors.tertiary;
    } else if (selected) {
      bg = AppColors.primaryContainer;
      border = AppColors.primary;
      fg = AppColors.onPrimaryContainer;
    } else {
      bg = AppColors.surfaceContainerLowest;
      border = AppColors.outlineVariant;
      fg = AppColors.onSurface;
    }

    return Semantics(
      button: !matched,
      enabled: !matched,
      label: matched ? '${card.term}, $matchedLabel' : card.term,
      child: _CardSurface(
        bg: bg,
        border: border,
        borderWidth: (selected || matched) ? 2 : 1,
        selected: selected,
        onTap: matched ? null : onTap,
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
              const Icon(Icons.check_circle,
                  size: 18, color: AppColors.tertiary),
            ],
          ],
        ),
      ),
    );
  }
}

/// Sağ sütun karşılık kartı (nötr / eşleşti / yanlış). Yanlışta shake.
class TranslationGameCard extends StatefulWidget {
  const TranslationGameCard({
    super.key,
    required this.card,
    required this.matchedLabel,
    required this.wrongLabel,
    required this.onTap,
  });

  final TranslationCard card;
  final String matchedLabel;
  final String wrongLabel;
  final VoidCallback onTap;

  @override
  State<TranslationGameCard> createState() => _TranslationGameCardState();
}

class _TranslationGameCardState extends State<TranslationGameCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void didUpdateWidget(covariant TranslationGameCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card.status == TranslationCardStatus.wrong &&
        oldWidget.card.status != TranslationCardStatus.wrong) {
      _shake.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.card.status;
    final matched = status == TranslationCardStatus.matched;
    final wrong = status == TranslationCardStatus.wrong;

    final Color bg;
    final Color border;
    final Color fg;
    if (matched) {
      bg = AppColors.tertiaryContainer.withValues(alpha: 0.1);
      border = AppColors.tertiary;
      fg = AppColors.tertiary;
    } else if (wrong) {
      bg = AppColors.errorContainer;
      border = AppColors.error;
      fg = AppColors.onErrorContainer;
    } else {
      bg = AppColors.surfaceContainerLowest;
      border = AppColors.outlineVariant;
      fg = AppColors.onSurface;
    }

    final card = _CardSurface(
      bg: bg,
      border: border,
      borderWidth: (matched || wrong) ? 2 : 1,
      selected: false,
      onTap: matched ? null : widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.card.text,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLg
                .copyWith(color: fg, fontWeight: FontWeight.w600),
          ),
          if (matched) ...[
            const SizedBox(height: AppSpacing.base),
            const Icon(Icons.check_circle,
                size: 18, color: AppColors.tertiary),
          ],
        ],
      ),
    );

    final label = matched
        ? '${widget.card.text}, ${widget.matchedLabel}'
        : wrong
            ? '${widget.card.text}, ${widget.wrongLabel}'
            : widget.card.text;

    return Semantics(
      button: !matched,
      enabled: !matched,
      label: label,
      child: AnimatedBuilder(
        animation: _shake,
        builder: (context, child) {
          // Yatay titreme (card-shake).
          final dx = sin(_shake.value * pi * 8) * 8 * (1 - _shake.value);
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: card,
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
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: widget.border, width: widget.borderWidth),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
