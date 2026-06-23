import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Lumina Learning tipografi token'ları (docs/DESIGN.md).
///
/// Çift tipli yaklaşım: Quicksand (başlıklar), Inter (gövde/input/label).
abstract final class AppTypography {
  AppTypography._();

  // --- Başlık (Quicksand) ---

  static TextStyle get displayLg => GoogleFonts.quicksand(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.02 * 32,
        color: AppColors.onSurface,
      );

  /// Mobilde başlıklar %15 küçültülür.
  static TextStyle get displayLgMobile => GoogleFonts.quicksand(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 36 / 28,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineLg => GoogleFonts.quicksand(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineMd => GoogleFonts.quicksand(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: AppColors.onSurface,
      );

  // --- Gövde / label (Inter) ---

  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.onSurface,
      );

  static TextStyle get labelLg => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.01 * 14,
        color: AppColors.onSurface,
      );

  static TextStyle get labelSm => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: AppColors.onSurface,
      );

  /// MaterialTextTheme eşlemesi (ThemeData.textTheme için).
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLg,
        displayMedium: displayLgMobile,
        headlineLarge: headlineLg,
        headlineMedium: headlineMd,
        titleLarge: headlineMd,
        bodyLarge: bodyLg,
        bodyMedium: bodyMd,
        labelLarge: labelLg,
        labelSmall: labelSm,
      );
}
