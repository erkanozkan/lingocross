import 'package:flutter/material.dart';

/// Lumina Learning renk token'ları (docs/DESIGN.md tek doğruluk kaynağı).
///
/// Named token'lar üretimde esastır; sapma için UX Designer onayı gerekir.
abstract final class AppColors {
  AppColors._();

  // Primary (mavi) ailesi
  static const Color primary = Color(0xFF0058BE);
  static const Color primaryContainer = Color(0xFF2170E4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryFixed = Color(0xFFD8E2FF);
  static const Color primaryFixedDim = Color(0xFFADC6FF);

  /// primary-fixed üzerindeki koyu metin (Stitch `on-primary-fixed-variant`).
  static const Color onPrimaryFixedVariant = Color(0xFF004395);

  /// Primary 3D buton alt gölge rengi (on-primary-fixed-variant tonu).
  static const Color primaryShadow = Color(0xFF004395);

  // Secondary (turuncu) ailesi — ödül / streak vurguları
  static const Color secondary = Color(0xFF855300);
  static const Color secondaryContainer = Color(0xFFFEA619);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryFixed = Color(0xFFFFDDB8);
  static const Color secondaryFixedDim = Color(0xFFFFB95F);
  static const Color onSecondaryFixedVariant = Color(0xFF653E00);

  /// Primary container üzerindeki metin (near-white, on-primary-container).
  static const Color onPrimaryContainer = Color(0xFFFEFCFF);

  // Tertiary (yeşil) ailesi — başarı / validation
  static const Color tertiary = Color(0xFF006947);
  static const Color tertiaryContainer = Color(0xFF00855B);
  static const Color tertiaryFixed = Color(0xFF6FFBBE);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryFixed = Color(0xFF002113);

  /// tertiary-container üzerindeki çok açık yeşil zemin (Stitch
  /// `on-tertiary-container`) — doğru kelime kartı arka planı.
  static const Color onTertiaryContainer = Color(0xFFF5FFF6);

  // Error ailesi
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Yüzey / arka plan tonal katmanlar
  static const Color background = Color(0xFFF8F9FF);
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainer = Color(0xFFE9EEFB);
  static const Color surfaceContainerHigh = Color(0xFFE3E8F6);
  static const Color surfaceContainerHighest = Color(0xFFD3E4FE);

  // Metin / kenarlık
  static const Color onSurface = Color(0xFF0B1C30);
  static const Color onSurfaceVariant = Color(0xFF424754);
  static const Color outline = Color(0xFF727785);
  static const Color outlineVariant = Color(0xFFC2C6D6);

  /// Koyu yüzey (crossword boş/"siyah" hücreler) — Stitch `inverse-surface`.
  static const Color inverseSurface = Color(0xFF213145);

  /// Level-2 difüz (mavi tonlu) yumuşak gölge rengi.
  static const Color ambientShadow = Color(0x143B82F6); // rgba(59,130,246,0.08)
}
