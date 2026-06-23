import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Welcome ekranı rol seçim kartı: sol ikon kutusu + metin + sağ chevron,
/// 3D renkli alt kenar (press'te batma). UX spec: auth-welcome §3.2/§4.
class RoleCard extends StatefulWidget {
  const RoleCard({
    super.key,
    required this.icon,
    required this.iconBoxColor,
    required this.iconColor,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBoxColor;
  final Color iconColor;
  final Color accentColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${widget.title}. ${widget.subtitle}',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          transform: Matrix4.translationValues(0, _pressed ? 4 : 0, 0),
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.outlineVariant),
            boxShadow: _pressed ? null : AppShadows.level2,
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border(
              bottom: BorderSide(
                color: widget.accentColor,
                width: _pressed ? 0 : 4,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: widget.iconBoxColor,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 28),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.title, style: AppTypography.headlineMd),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      widget.subtitle,
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (_pressed)
                Icon(Icons.chevron_right, color: widget.accentColor),
            ],
          ),
        ),
      ),
    );
  }
}
