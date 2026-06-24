import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Kilitli (Premium) bir özelliğin yanında gösterilen küçük rozet.
///
/// Secondary (turuncu) tonlu zemin + kilit ikonu + "Premium" etiketi. Proaktif
/// kilit giriş noktalarında butonun trailing'ine konur. Lumina token'ları;
/// minimal tutulur. Etiketsiz (yalnız ikon) kullanım için [showLabel]=false.
class LockedFeatureBadge extends StatelessWidget {
  const LockedFeatureBadge({super.key, this.showLabel = true});

  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: showLabel ? AppSpacing.xs : AppSpacing.base,
        vertical: AppSpacing.base,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondaryFixed,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock, size: 14, color: AppColors.secondary),
          if (showLabel) ...[
            const SizedBox(width: AppSpacing.base),
            Text(
              l10n.lockedFeatureLabel,
              style: AppTypography.labelSm.copyWith(color: AppColors.secondary),
            ),
          ],
        ],
      ),
    );
  }
}
