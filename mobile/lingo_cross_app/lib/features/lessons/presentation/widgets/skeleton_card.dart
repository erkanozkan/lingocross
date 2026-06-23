import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Yükleniyor durumu için basit shimmer-benzeri iskelet kart bloğu
/// (teacher-dashboard.md §5, word-list-entry.md §5).
class SkeletonCard extends StatefulWidget {
  const SkeletonCard({super.key, this.height = 72});

  final double height;

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = 0.4 + (_controller.value * 0.4);
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: t),
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
        );
      },
    );
  }
}

/// Birden çok iskelet kartı dikey listeler.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 3, this.height = 72});

  final int count;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < count; i++) ...[
          SkeletonCard(height: height),
          if (i != count - 1) const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
