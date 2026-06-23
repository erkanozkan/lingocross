import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Lumina Learning "3D" primary buton (docs/DESIGN.md + UX spec'ler).
///
/// idle: zemin primary + 4px alt gölge `#004395`. Press'te 2px aşağı kayar ve
/// alt gölge küçülür ("batma" hissi). loading: disabled + spinner, metin gizli.
class PrimaryButton3D extends StatefulWidget {
  const PrimaryButton3D({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingIcon,
    this.isLoading = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool enabled;

  @override
  State<PrimaryButton3D> createState() => _PrimaryButton3DState();
}

class _PrimaryButton3DState extends State<PrimaryButton3D> {
  bool _pressed = false;

  bool get _interactive =>
      widget.enabled && !widget.isLoading && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final bool sunk = _pressed && _interactive;

    return Opacity(
      opacity: widget.enabled ? 1 : 0.5,
      child: GestureDetector(
        onTapDown: _interactive ? (_) => setState(() => _pressed = true) : null,
        onTapUp: _interactive ? (_) => setState(() => _pressed = false) : null,
        onTapCancel:
            _interactive ? () => setState(() => _pressed = false) : null,
        onTap: _interactive ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          transform: Matrix4.translationValues(0, sunk ? 2 : 0, 0),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryShadow,
                offset: Offset(0, sunk ? 2 : 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label,
                        style: AppTypography.headlineMd
                            .copyWith(color: AppColors.onPrimary),
                      ),
                      if (widget.trailingIcon != null) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Icon(widget.trailingIcon,
                            color: AppColors.onPrimary, size: 22),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
