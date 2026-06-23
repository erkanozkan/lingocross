import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Hata banner'ı: zemin `error-container`, metin `on-error-container`, `error`
/// ikonu (docs UX spec'ler — login/register/forgot "error" durumu).
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.errorContainer,
          borderRadius: BorderRadius.circular(AppRadius.base),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline,
                color: AppColors.onErrorContainer, size: 20),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                message,
                style: AppTypography.labelLg
                    .copyWith(color: AppColors.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
