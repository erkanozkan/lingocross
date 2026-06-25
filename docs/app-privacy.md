# App Store Connect — App Privacy (veri toplama anketi) cevap seti

> App Store Connect → uygulama → **App Privacy** bölümünde işaretlenecek cevaplar.
> privacy-policy.html ile uyumludur. Reklam yok, analitik SDK yok, **tracking yok**, veri satışı yok.

## 1. "Do you or your third-party partners collect data from this app?"
**Yes** (veri topluyoruz).

## 2. Toplanan veri tipleri ve ayarları
Her tip için: **Purpose = App Functionality**, **Linked to the user's identity = Yes**, **Used for tracking = No**.
(Hiçbir veri reklam/tracking veya üçüncü-taraf reklamcılık için kullanılmaz.)

| Apple kategorisi → veri tipi | Neden topluyoruz | Linked | Tracking |
|---|---|---|---|
| **Contact Info → Email Address** | Hesap oluşturma/giriş | Yes | No |
| **Contact Info → Name** (görünen ad) | Profil/öğretmen-öğrenci görünürlüğü | Yes | No |
| **User Content → Other User Content** (sınıf/ders/kelime, oyun sonuçları) | Uygulama işlevi (öğretmenle paylaşım, ilerleme) | Yes | No |
| **User Content → Photos or Videos** (kelime tarama fotoğrafı — AI'ya gönderilir, kalıcı saklanmaz) | Kameradan kelime çıkarma | Yes | No |
| **Identifiers → User ID** (hesap kimliği) | Hesap işleyişi | Yes | No |
| **Identifiers → Device ID** (FCM push jetonu) | Anlık bildirim gönderimi | Yes | No |
| **Purchases → Purchase History** (Premium abonelik işlemi) | Abonelik durumu | Yes | No |

## 3. Toplamadığımız / "No" denecekler
- Location, Financial Info, Health, Sensitive Info, Contacts, Browsing/Search History — **toplanmıyor**.
- **Usage Data / Diagnostics:** analitik/crash SDK yok → **işaretleme**.
- **Tracking (ATT):** hiçbir veri başka şirketlerin uygulama/sitelerindeki veriyle ilişkilendirilmiyor → **App Tracking Transparency izni gerekmez**.

## 4. Üçüncü taraf SDK notu
- **Firebase Cloud Messaging** (Google): yalnız push iletimi; cihaz jetonu (Device ID) işler. Analytics dahil edilmedi.
- **Anthropic (yapay zekâ sağlayıcısı):** kelime tarama kullanılınca, taranan **fotoğrafı** işler (kelime çıkarımı; sunucu üzerinden). Foto kalıcı saklanmaz.
- (ML Kit / cihaz-içi OCR kaldırıldı.)

## 5. Hatırlatma
Bu beyan privacy-policy.html ile **tutarlı** olmalı. İçerik değişirse (örn. S3'te IAP eklenince Purchases) hem politikayı hem bu beyanı güncelle.
