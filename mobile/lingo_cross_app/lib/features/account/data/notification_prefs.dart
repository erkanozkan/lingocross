/// Bildirim Ayarları toggle anahtarları.
///
/// Veri kaynağı F7.4'te backend'e taşındı
/// (`GET|PUT /api/me/notification-preferences` — bkz.
/// `features/notifications/`). Bu enum yalnızca ekran/notifier'da hangi
/// anahtarın değiştiğini tanımlamak için kullanılır.
enum NotificationToggle {
  /// Ana anahtar — kapalıyken alt satırlar pasif.
  master,

  /// ÖDEV & BULMACA: yeni ödev/bulmaca atandığında.
  assigned,

  /// ÖDEV & BULMACA: ödev hatırlatması.
  reminder,

  /// SONUÇLAR: öğrenci/öğretmen sonuç bildirimi.
  results,

  /// GENEL: duyurular ve güncellemeler.
  announcements;

  /// Varsayılan değer (backend ile aynı: "Duyurular" hariç hepsi açık).
  bool get defaultValue => this != NotificationToggle.announcements;
}
