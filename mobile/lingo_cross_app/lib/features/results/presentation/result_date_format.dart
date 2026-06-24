/// Türkçe kısa tarih biçimi (örn "12 Haz") — geçmiş sonuç kartı meta satırı.
///
/// `intl` locale init'ine bağımlı olmadan deterministik kısa biçim. Sonuç
/// tarihi yerel saate çevrilir.
String formatShortDate(DateTime date) {
  const months = [
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
  final local = date.toLocal();
  return '${local.day} ${months[local.month - 1]}';
}
