import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/domain/user_role.dart';
import '../../auth/presentation/auth_notifier.dart';

/// M1 placeholder ana sayfa. Gerçek role-bazlı dashboard'lar M2+'da gelir.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authNotifierProvider);
    final role = auth.user?.role;

    final welcome = switch (role) {
      UserRole.teacher => l10n.homeTeacherWelcome,
      UserRole.student => l10n.homeStudentWelcome,
      null => l10n.homeTitle,
    };

    final icon = role == UserRole.teacher ? Icons.co_present : Icons.school;
    final accent =
        role == UserRole.teacher ? AppColors.tertiary : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle, style: AppTypography.headlineMd),
        actions: [
          IconButton(
            tooltip: l10n.homeLogout,
            icon: const Icon(Icons.logout, color: AppColors.onSurfaceVariant),
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accent, size: 44),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(welcome, style: AppTypography.headlineLg),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.homePlaceholderBody,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
