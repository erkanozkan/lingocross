import 'package:flutter/material.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Raporlar sekmesi — F2.3 placeholder ("Yakında").
///
/// Sınıf/öğrenci performans raporları F2.3'te eklenecek; şimdilik iskelet.
class TeacherReportsScreen extends StatelessWidget {
  const TeacherReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.marginMobile,
        title: Text(
          l10n.reportsTitle,
          style: AppTypography.headlineLg.copyWith(color: AppColors.primary),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.assessment_outlined,
                  color: AppColors.primary, size: 64),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.reportsComingSoonTitle,
                style: AppTypography.headlineMd,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.reportsComingSoonDesc,
                style: AppTypography.bodyMd
                    .copyWith(color: AppColors.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  l10n.commonComingSoon,
                  style: AppTypography.labelLg
                      .copyWith(color: AppColors.onSecondaryFixedVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
