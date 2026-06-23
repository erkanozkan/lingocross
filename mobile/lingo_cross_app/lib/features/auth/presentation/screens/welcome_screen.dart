import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/role_card.dart';

/// Hoşgeldiniz / Landing ekranı (UX: auth-welcome.md).
///
/// Orchestrator kararı: sosyal giriş (Google/Apple) M1'de GÖSTERİLMEZ.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.marginMobile,
                  vertical: AppSpacing.xl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MascotBlock(l10n: l10n),
                    const SizedBox(height: AppSpacing.xl),
                    RoleCard(
                      icon: Icons.school,
                      iconBoxColor: AppColors.primaryFixed,
                      iconColor: AppColors.primary,
                      accentColor: AppColors.primaryContainer,
                      title: l10n.authWelcomeRoleStudentTitle,
                      subtitle: l10n.authWelcomeRoleStudentSubtitle,
                      onTap: () => context.go('${AppRoutes.login}?role=student'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    RoleCard(
                      icon: Icons.account_balance,
                      iconBoxColor: AppColors.tertiaryFixed,
                      iconColor: AppColors.tertiary,
                      accentColor: AppColors.tertiary,
                      title: l10n.authWelcomeRoleTeacherTitle,
                      subtitle: l10n.authWelcomeRoleTeacherSubtitle,
                      onTap: () => context.go('${AppRoutes.login}?role=teacher'),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _QuickActions(l10n: l10n),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MascotBlock extends StatelessWidget {
  const _MascotBlock({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mascot görseli yok → graceful fallback: daire + ikon.
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
          style: AppTypography.displayLgMobile.copyWith(color: AppColors.primary),
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

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xs,
      children: [
        TextButton(
          onPressed: () => context.go(AppRoutes.forgotPassword),
          child: Text(
            l10n.authWelcomeForgotPassword,
            style: AppTypography.labelLg.copyWith(color: AppColors.primary),
          ),
        ),
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: AppColors.outlineVariant,
            shape: BoxShape.circle,
          ),
        ),
        TextButton(
          onPressed: () => context.go(AppRoutes.register),
          child: Text(
            l10n.authWelcomeCreateAccount,
            style: AppTypography.labelLg.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
