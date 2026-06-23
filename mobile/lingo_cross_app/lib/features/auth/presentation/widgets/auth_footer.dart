import 'package:flutter/material.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Gizlilik • Kullanım • Telif footer'ı (opacity 60%). Telif: "© 2026 LingoCross".
class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style =
        AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant);

    return Opacity(
      opacity: 0.6,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.base,
        children: [
          Text(l10n.authFooterPrivacy, style: style),
          Text('•', style: style),
          Text(l10n.authFooterTerms, style: style),
          Text('•', style: style),
          Text(l10n.authFooterCopyright, style: style),
        ],
      ),
    );
  }
}
