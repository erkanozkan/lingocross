import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Doğruluk radyal grafiği (game-result-report.md §3.3).
///
/// 220×220 SVG-benzeri progress-ring: track halka (surface-container, 16px) +
/// dolgu halka (primary, 16px, yuvarlak uç). -90°'den başlar, açılışta hedefe
/// `1s ease-in-out` ile dolar. Ortada yüzde (display-lg, primary) + "Doğruluk".
class AccuracyRing extends StatefulWidget {
  const AccuracyRing({
    super.key,
    required this.percent,
    required this.valueText,
    required this.label,
    required this.semanticLabel,
    this.animate = true,
  });

  /// 0–100 doğruluk yüzdesi.
  final int percent;

  /// Ortadaki yüzde metni (örn "%85").
  final String valueText;

  /// Alt etiket ("Doğruluk").
  final String label;

  /// Ekran okuyucu metni ("Doğruluk yüzde 85").
  final String semanticLabel;

  /// Açılış dolum animasyonu (reduced-motion'da kapatılır).
  final bool animate;

  @override
  State<AccuracyRing> createState() => _AccuracyRingState();
}

class _AccuracyRingState extends State<AccuracyRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  late final Animation<double> _fill = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final target = (widget.percent.clamp(0, 100)) / 100;
    return Semantics(
      label: widget.semanticLabel,
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _fill,
              builder:
                  (context, _) => CustomPaint(
                    size: const Size(220, 220),
                    painter: _RingPainter(progress: target * _fill.value),
                  ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(
                  child: Text(
                    widget.valueText,
                    style: AppTypography.displayLg.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                ExcludeSemantics(
                  child: Text(
                    widget.label,
                    style: AppTypography.labelLg.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress});

  /// 0–1 dolum oranı.
  final double progress;

  static const double _strokeWidth = 16;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - _strokeWidth) / 2;

    final track =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _strokeWidth
          ..color = AppColors.surfaceContainerHighest;
    canvas.drawCircle(center, radius, track);

    if (progress <= 0) return;

    final fill =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _strokeWidth
          ..strokeCap = StrokeCap.round
          ..color = AppColors.primary;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // -90°
      2 * math.pi * progress,
      false,
      fill,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
