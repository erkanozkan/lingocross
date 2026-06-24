# LingoCross — Sürüm Notları

## v0.1-mvp (2026-06-24) — MVP (Faz 1)

İlk uçtan uca MVP. Dil öğretmenleri ile öğrencileri buluşturan, kelime tabanlı oyunlaştırılmış
öğrenme uygulaması. Backend (.NET 10 / EF Core / PostgreSQL) + Mobil (Flutter).

### Özellikler
- **Auth (M1):** Kendi JWT'miz (access + refresh rotasyon, reuse-detection), BCrypt; tek birleşik
  giriş ekranı, kayıt (rol seçimi), şifremi unuttum. Rolsüz giriş — rol hesaptan gelir.
- **Dersler & Kelimeler (M2):** Öğretmen ders CRUD + yayınlama; kelime + çoklu Türkçe karşılık
  (biri primary) + eşanlam. Kelime girişi **OCR** (cihaz-içi Google ML Kit, kameradan/galeriden →
  gözden geçirme) **ve manuel**.
- **Enrollment (M3):** Öğretmen davet kodu; öğrenci kodla katılır (doğrudan aktif); öğrenci yalnız
  kayıtlı olduğu öğretmenlerin yayınlanmış derslerini görür.
- **Kelime Eşleştirme Oyunu (M4):** Dersin kelimelerinden üretilen iki sütun tap-eşleştirme;
  count-up timer, anlık doğru/yanlış geri bildirim.
- **Sonuç & Özet (M5):** Oyun sonu raporu (doğruluk skoru, süre, doğru/toplam), öğretmenle paylaşım,
  öğrenci geçmiş sonuçları.

### Teknik
- API: 4 katmanlı .NET 10, EF Core + Npgsql, 81 birim/servis testi yeşil.
- Mobil: Flutter (Riverpod 2.x, go_router, Dio, freezed), Türkçe i18n, iOS simülatör build doğrulandı.
- Tasarım: Stitch "Lumina Learning" tasarım sistemine sadık (`docs/DESIGN.md`).

### Bilinen sınırlar / sonraki faz
- **Railway deploy** henüz yapılmadı (kullanıcı aksiyonu).
- **Faz 2** (sonraki): öğretmenin açıkça **bulmaca oluşturup ataması** (Kelime Eşleştirme → Crossword),
  zenginleşen ders ekranları (Derslerim/Ders Oluşturma/Ders Detayı + 4 sekmeli nav + Profil),
  öğretmen takip paneli (Raporlar). Ayrıntı: onaylı plan dosyası, bölüm 6.
- Açık cila kalemleri: köşe-yarıçapı sözleşmesi, OCR kamera fallback metni, ders unpublish ucu vb.
