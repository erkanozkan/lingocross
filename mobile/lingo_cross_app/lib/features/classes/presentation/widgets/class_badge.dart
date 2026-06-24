import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Sınıf rozeti için (zemin, metin) renk çiftini sınıf adından deterministik
/// türetir (Stitch: primary-fixed/secondary-fixed/tertiary-fixed döngüsü).
class ClassBadgePalette {
  const ClassBadgePalette(this.background, this.foreground);

  final Color background;
  final Color foreground;

  static const List<ClassBadgePalette> _palettes = [
    ClassBadgePalette(AppColors.primaryFixed, AppColors.primary),
    ClassBadgePalette(AppColors.secondaryFixed, AppColors.secondary),
    ClassBadgePalette(AppColors.tertiaryFixed, AppColors.tertiary),
  ];

  /// Sınıf adına göre kararlı bir palet seçer.
  factory ClassBadgePalette.forName(String name) {
    if (name.isEmpty) return _palettes.first;
    final hash = name.codeUnits.fold<int>(0, (a, c) => a + c);
    return _palettes[hash % _palettes.length];
  }
}

/// Sınıf adından kısa rozet etiketi türetir (örn. "6-A Sınıfı" → "6-A").
/// İlk kelime (boşluğa kadar) en fazla 4 karakter olacak şekilde alınır.
String classBadgeLabel(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '?';
  final firstWord = trimmed.split(RegExp(r'\s+')).first;
  return firstWord.length <= 4
      ? firstWord.toUpperCase()
      : firstWord.substring(0, 4).toUpperCase();
}
