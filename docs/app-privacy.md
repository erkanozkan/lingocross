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
| **Identifiers → User ID** (hesap kimliği) | Hesap işleyişi | Yes | No |
| **Identifiers → Device ID** (FCM push jetonu) | Anlık bildirim gönderimi | Yes | No |

## 3. Toplamadığımız / "No" denecekler
- Location, Financial Info, Health, Sensitive Info, Contacts, Browsing/Search History — **toplanmıyor**.
- **Photos/Camera:** fotoğraf cihazda işlenir, **toplanmaz/yüklenmez** (yalnız tanınan METİN sunucuya/Anthropic'e gider → bu zaten "User Content" altında). Bu yüzden "Photos" veri tipi **işaretlenmez**.
- **Purchases:** gerçek Apple IAP henüz yok → **işaretleme** (S3 geldiğinde "Purchases → Purchase History" eklenir).
- **Usage Data / Diagnostics:** analitik/crash SDK yok → **işaretleme**.
- **Tracking (ATT):** hiçbir veri başka şirketlerin uygulama/sitelerindeki veriyle ilişkilendirilmiyor → **App Tracking Transparency izni gerekmez**.

## 4. Üçüncü taraf SDK notu
- **Firebase Cloud Messaging** (Google): yalnız push iletimi; cihaz jetonu (Device ID) işler. Analytics dahil edilmedi.
- **Anthropic:** yalnız kelime tarama kullanılınca tanınan metni işler (sunucu üzerinden).
- **Google ML Kit:** cihaz-içi; veri dışarı çıkmaz.

## 5. Hatırlatma
Bu beyan privacy-policy.html ile **tutarlı** olmalı. İçerik değişirse (örn. S3'te IAP eklenince Purchases) hem politikayı hem bu beyanı güncelle.
