import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button_3d.dart';

/// Tamamlanma overlay'i — minimal (M4): kutlama + süre + doğru/toplam + "Bitir".
///
/// XP/rapor/paylaşım YOK (M5). Glass panel, card-pop giriş animasyonu.
class CompletionOverlay extends StatefulWidget {
  const CompletionOverlay({
    super.key,
    required this.title,
    required this.message,
    required this.finishLabel,
    required this.onFinish,
  });

  final String title;
  final String message;
  final String finishLabel;
  final VoidCallback onFinish;

  @override
  State<CompletionOverlay> createState() => _CompletionOverlayState();
}

class _CompletionOverlayState extends State<CompletionOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  )..forward();

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.05), weight: 50),
    TweenSequenceItem(tween: Tween(begin: 1.05, end: 1), weight: 50),
  ]).animate(CurvedAnimation(parent: _pop, curve: Curves.easeOut));

  @override
  void dispose() {
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Semantics(
        container: true,
        child: ColoredBox(
          color: AppColors.onSurface.withValues(alpha: 0.4),
          child: Center(
            child: ScaleTransition(
              scale: _scale,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 5 / 6,
                    constraints: const BoxConstraints(maxWidth: 360),
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.tertiary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x33006947),
                                offset: Offset(0, 4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.celebration,
                              size: 48, color: AppColors.onPrimary),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: AppTypography.displayLgMobile,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          widget.message,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMd
                              .copyWith(color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        PrimaryButton3D(
                          label: widget.finishLabel,
                          onPressed: widget.onFinish,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
