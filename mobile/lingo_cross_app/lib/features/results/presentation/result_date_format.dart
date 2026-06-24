import 'package:intl/intl.dart';

/// Kısa tarih biçimi (örn TR "12 Haz", EN "Jun 12") — geçmiş sonuç kartı meta
/// satırı. `intl` locale init'ine bağımlı olmadan deterministik kısa biçim;
/// aktif UI diline göre ay kısaltması ve sıralama seçilir.
///
/// [localeCode] verilmezse [Intl.getCurrentLocale] (yoksa 'en') kullanılır.
/// Sonuç tarihi yerel saate çevrilir.
String formatShortDate(DateTime date, {String? localeCode}) {
  final code = _resolveLocale(localeCode);
  final local = date.toLocal();
  final month = _monthsFor(code)[local.month - 1];
  // TR: "12 Haz" (gün ay) — EN: "Jun 12" (ay gün).
  return code == 'tr' ? '${local.day} $month' : '$month ${local.day}';
}

/// Aktif dili 'tr'/'en'e indirger; bilinmiyorsa 'en'.
String _resolveLocale(String? localeCode) {
  final raw = (localeCode ?? Intl.getCurrentLocale()).toLowerCase();
  return raw.startsWith('tr') ? 'tr' : 'en';
}

const List<String> _monthsTr = [
  'Oca',
  'Şub',
  'Mar',
  'Nis',
  'May',
  'Haz',
  'Tem',
  'Ağu',
  'Eyl',
  'Eki',
  'Kas',
  'Ara',
];

const List<String> _monthsEn = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

List<String> _monthsFor(String code) => code == 'tr' ? _monthsTr : _monthsEn;
