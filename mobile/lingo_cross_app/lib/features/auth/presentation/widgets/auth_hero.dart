import 'package:flutter/material.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Birleşik giriş ekranının "hero" bloğu: maskot dairesi + Hi!/Merhaba!
/// rozetleri + "LingoCross'a Hoş Geldiniz" başlığı + alt yazı.
///
/// (Eski WelcomeScreen'in maskot bloğundan taşındı; Stitch screenId
/// `c6188f694eea4fc3966753bd2c3a262c` ile birebir.)
class AuthHero extends StatelessWidget {
  const AuthHero({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        // Maskot görseli yok → graceful fallback: daire + ikon.
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            ExcludeSemantics(
              child: Container(
                width: 128,
                height: 128,
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.school,
                    color: AppColors.onPrimary, size: 56),
              ),
            ),
            Positioned(
              top: -8,
              right: 4,
              child: _FloatyBadge(
                text: l10n.authWelcomeBadgeHi,
                background: AppColors.secondaryContainer,
                angle: 0.21,
              ),
            ),
            Positioned(
              bottom: -8,
              left: 4,
              child: _FloatyBadge(
                text: l10n.authWelcomeBadgeMerhaba,
                background: AppColors.tertiaryContainer,
                angle: -0.21,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.authWelcomeTitle,
          textAlign: TextAlign.center,
          style:
              AppTypography.displayLgMobile.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.authWelcomeSubtitle,
          textAlign: TextAlign.center,
          style:
              AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _FloatyBadge extends StatelessWidget {
  const _FloatyBadge({
    required this.text,
    required this.background,
    required this.angle,
  });

  final String text;
  final Color background;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.base,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Text(
            text,
            style: AppTypography.headlineMd.copyWith(color: AppColors.onPrimary),
          ),
        ),
      ),
    );
  }
}
