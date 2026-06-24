import 'package:flutter/material.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Crossword alt klavyesi (Stitch §interactive keyboard, birebir).
///
/// Üç satır Türkçe A–Z tuş: ERTYUIOPĞ / ASDFGHJKL / [sil] ZCVBNM [bitir].
/// Tuşlar "3D" his (alt gölge + basınca 2px aşağı). Sol özel tuş geri-sil,
/// sağ özel tuş "Bitir" (yalnız tüm hücreler dolunca aktif).
class CrosswordKeyboard extends StatelessWidget {
  const CrosswordKeyboard({
    super.key,
    required this.onKey,
    required this.onDelete,
    required this.onEnter,
    required this.enterEnabled,
  });

  final ValueChanged<String> onKey;
  final VoidCallback onDelete;
  final VoidCallback onEnter;

  /// "Bitir" (enter) tuşu aktif mi (tüm hücreler dolunca).
  final bool enterEnabled;

  static const _row1 = ['E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 'Ğ'];
  static const _row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
  static const _row3 = ['Z', 'C', 'V', 'B', 'N', 'M'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xs,
            AppSpacing.sm,
            AppSpacing.xs,
            AppSpacing.xs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _KeyRow(
                children: [
                  for (final k in _row1)
                    _LetterKey(letter: k, onTap: () => onKey(k)),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              _KeyRow(
                children: [
                  for (final k in _row2)
                    _LetterKey(letter: k, onTap: () => onKey(k)),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              _KeyRow(
                children: [
                  _SpecialKey(
                    flex: 3,
                    onTap: onDelete,
                    background: AppColors.surfaceContainerHighest,
                    foreground: AppColors.primary,
                    tooltip: l10n.gameCrosswordKeyDelete,
                    child: const Icon(Icons.backspace_outlined, size: 20),
                  ),
                  for (final k in _row3)
                    _LetterKey(letter: k, onTap: () => onKey(k)),
                  _SpecialKey(
                    flex: 3,
                    onTap: enterEnabled ? onEnter : null,
                    background: AppColors.primary,
                    foreground: AppColors.onPrimary,
                    tooltip: l10n.gameCrosswordFinish,
                    child: const Icon(Icons.check, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeyRow extends StatelessWidget {
  const _KeyRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 4),
          children[i],
        ],
      ],
    );
  }
}

/// Tek harf tuşu (3D his). Basınca 2px aşağı, alt gölge kaybolur.
class _LetterKey extends StatefulWidget {
  _LetterKey({required this.letter, required this.onTap})
      : super(key: ValueKey('crossword-key-$letter'));

  final String letter;
  final VoidCallback onTap;

  @override
  State<_LetterKey> createState() => _LetterKeyState();
}

class _LetterKeyState extends State<_LetterKey> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          transform: Matrix4.translationValues(0, _pressed ? 2 : 0, 0),
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.4),
            ),
            boxShadow: _pressed
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x330058BE),
                      offset: Offset(0, 3),
                    ),
                  ],
          ),
          child: Text(
            widget.letter,
            style: AppTypography.labelLg.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// Özel tuş (geri-sil / bitir). [onTap] null ise pasif görünür.
class _SpecialKey extends StatefulWidget {
  const _SpecialKey({
    required this.flex,
    required this.onTap,
    required this.background,
    required this.foreground,
    required this.tooltip,
    required this.child,
  });

  final int flex;
  final VoidCallback? onTap;
  final Color background;
  final Color foreground;
  final String tooltip;
  final Widget child;

  @override
  State<_SpecialKey> createState() => _SpecialKeyState();
}

class _SpecialKeyState extends State<_SpecialKey> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return Expanded(
      flex: widget.flex,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: GestureDetector(
          onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
          onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
          onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
          onTap: widget.onTap,
          child: Tooltip(
            message: widget.tooltip,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 60),
              transform: Matrix4.translationValues(0, _pressed ? 2 : 0, 0),
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.background,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: _pressed
                    ? null
                    : const [
                        BoxShadow(
                          color: Color(0x330058BE),
                          offset: Offset(0, 3),
                        ),
                      ],
              ),
              child: IconTheme(
                data: IconThemeData(color: widget.foreground),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
