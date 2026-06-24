# LingoCross — Sürüm Notları

## v0.3 (2026-06-24) — Faz 3 (ilk parti): Öğrenci Profil + Bulmacalarım

- **Öğrenci Profil (F3.1):** avatar+ad, **gerçek** oyun sayısı + %doğruluk (`GET /students/me/stats`),
  Günlük Seri/Haftalık Hedef/Başarımlar placeholder, menü + gerçek çıkış.
- **Bulmacalarım (F3.2, öğretmen):** öğretmenin tüm bulmacaları (tür, ders, atanan öğrenci, çözüm sayısı),
  **Paylaş** (idempotent yeniden-yayın), alt istatistik. `GET /teachers/me/games`, `POST /games/{id}/share`.
- Karar: bulmaca oluşturunca anında yayınlanır (kalıcı Taslak yok); Word Search ertelendi.
- API 152 test, mobil 105 test yeşil; iOS simülatör build doğrulandı.

## v0.2 (2026-06-24) — Faz 2: Öğretmen otoring + bulmaca atama + takip

MVP (v0.1) üzerine öğretmen iş akışını ve ikinci oyun türünü ekler.

### Yenilikler
- **Öğretmen navigasyonu (F2.1):** 4 sekmeli yapı (Ana Sayfa / Sınıflar / Raporlar / Profil).
  Derslerim listesi (tarih + durum AKTİF/TAMAMLANDI), Ders Oluşturma (tarih/hafta), Ders Detayı,
  Profil ekranı. Ders durumu yaşam döngüsü: Draft → Active → Completed (+ unpublish).
- **Bulmaca oluşturma + atama (F2.2):** Öğretmen tür (Kelime Eşleştirme / Crossword) + ders seçer →
  "Oluştur ve Yayınla" → dersin kelimelerinden bulmaca üretilir ve **aktif öğrencilere atanır**.
  Öğrenci panelinde atanan bulmacalar; oyna → sonuç.
- **Öğretmen takip / Raporlar (F2.3):** Öğretmen, öğrencilerin paylaştığı sonuçları ve özet
  ilerlemeyi (paylaşılan sayısı, ortalama skor, son aktivite) görür.
- **Crossword (F2.4):** Dersin kelimelerinden kesişimli ızgara üretimi (cevap=İngilizce terim,
  ipucu=Türkçe karşılık) + interaktif crossword oynanış ekranı (ızgara, ipucu listeleri, klavye, timer).
- **Cila (F2.5):** köşe-yarıçapı sözleşmesi netleştirildi, erişilebilirlik (≥48px), OCR kamera
  fallback'i, sonuç süresi makullük sınırı, ölü metin temizliği.

### Düzeltmeler
- Ders Oluşturma boş ekranı (PrimaryButton3D bottomNavigationBar'ı şişiriyordu).
- Açılışta yanlış role yönlenme / boş isim (`/me` ile oturum geri yükleme).

### Teknik
- API: 136 test yeşil; yeni: lesson status/schedule, game publishing + assignment, teacher tracking,
  crossword generator. Mobil: Riverpod 2.x, ~95 test; iOS simülatör build doğrulandı.
- **Railway deploy** henüz yapılmadı (kullanıcı aksiyonu).

### Sonraki (Faz 3+)
Adlandırılmış sınıf/grup (6-A/6-B), Çıkmış Sorular + Soru Çözüm ekranları, push bildirim, OAuth.

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
