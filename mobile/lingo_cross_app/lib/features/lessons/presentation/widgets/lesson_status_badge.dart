import 'package:flutter/material.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/lesson_status.dart';

/// Ders durum rozeti — Taslak / Aktif / Tamamlandı (Stitch `930ab2e6…` rozetleri).
///
/// Aktif → primary tint zemin + koyu primary metin; Tamamlandı → tertiary tint;
/// Taslak → nötr surface tonu.
class LessonStatusBadge extends StatelessWidget {
  const LessonStatusBadge({super.key, required this.status});

  final LessonStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (bg, fg) = switch (status) {
      LessonStatus.active => (
          AppColors.primaryFixed,
          AppColors.primary,
        ),
      LessonStatus.completed => (
          AppColors.tertiaryFixed,
          AppColors.onTertiaryFixed,
        ),
      LessonStatus.draft => (
          AppColors.surfaceContainerHigh,
          AppColors.onSurfaceVariant,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        status.labelUpper(l10n),
        style: AppTypography.labelSm.copyWith(
          color: fg,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
