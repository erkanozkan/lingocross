/// 8pt grid boşluk token'ları (docs/DESIGN.md).
abstract final class AppSpacing {
  AppSpacing._();

  static const double base = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16; // gutter
  static const double lg = 24;
  static const double xl = 32;

  /// Mobilde yatay güvenli alan (margin-mobile).
  static const double marginMobile = 20;
}

/// Köşe yarıçapı token'ları (docs/DESIGN.md — tek kanonik ölçek).
///
/// sm=8 (chip/badge), md=12 (input/küçük kart), lg=16 (buton/standart kart),
/// xl=24 (büyük modül/hero/sheet), full=9999 (pill/rozet).
abstract final class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 9999;

  /// Geriye dönük alias (sm ile aynı). Yeni kodda `sm` kullanın.
  static const double base = sm;
}
