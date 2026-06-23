import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Register ekranı rol seçim kartı (radio mantığı). Seçili: 2px primary kenarlık
/// + primary tint zemin. UX: auth-register.md §3.3.
class RoleSelectCard extends StatelessWidget {
  const RoleSelectCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.all(AppSpacing.md),
          constraints: const BoxConstraints(minHeight: 48),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primaryFixed
                : AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.outlineVariant,
              width: selected ? 2 : 1,
            ),
            boxShadow: selected ? null : AppShadows.soft,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(height: AppSpacing.xs),
              Text(label, style: AppTypography.labelLg),
            ],
          ),
        ),
      ),
    );
  }
}
