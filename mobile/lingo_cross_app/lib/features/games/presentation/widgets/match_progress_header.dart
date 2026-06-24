import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Oyun ilerleme başlığı: üst etiket + başlık + sayaç + pill progress bar.
class MatchProgressHeader extends StatelessWidget {
  const MatchProgressHeader({
    super.key,
    required this.label,
    required this.title,
    required this.counter,
    required this.progress,
  });

  final String label;
  final String title;
  final String counter;

  /// 0–1 arası ilerleme oranı.
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.outline,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  Text(title, style: AppTypography.headlineLg),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Text(
                counter,
                style:
                    AppTypography.labelLg.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _PillProgress(value: progress),
      ],
    );
  }
}

/// Kalın pill progress (track highest, dolgu primary, transition).
class _PillProgress extends StatelessWidget {
  const _PillProgress({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        height: 12,
        color: AppColors.surfaceContainerHighest,
        child: Align(
          alignment: Alignment.centerLeft,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                width: constraints.maxWidth * value.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
