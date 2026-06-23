import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tonal + soft ambient shadow token'ları (docs/DESIGN.md "Yükseklik & Derinlik").
abstract final class AppShadows {
  AppShadows._();

  /// Level-2 (interaktif) difüz mavi tonlu gölge: Y:4px, Blur:12px,
  /// rgba(59,130,246,0.08).
  static const List<BoxShadow> level2 = [
    BoxShadow(
      color: AppColors.ambientShadow,
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];

  /// Daha hafif kart gölgesi (register rol kartları — opacity 0.04).
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0A3B82F6), // rgba(59,130,246,0.04)
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];
}
