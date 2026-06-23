# UX Spec — Şifremi Unuttum (Forgot Password)

> Kaynak: Stitch `projects/13138966371134318763/screens/3a8035bc5a86458c9883edc080ab11ef`
> Design system: **Lumina Learning** (`docs/DESIGN.md` tek doğruluk kaynağı).
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.

## 1. Amaç & Akış

Kullanıcı e-postasını girer, sunucu sıfırlama bağlantısı/kodu gönderir. Bu ekran **yalnız istek**
gönderir; yeni şifre belirleme ayrı bir adımdır (e-posta'daki link → reset ekranı). Güvenlik gereği
e-postanın kayıtlı olup olmadığı sızdırılmaz → her geçerli e-posta için aynı başarı mesajı gösterilir.

- API: `POST /auth/forgot-password` (body: email). (Reset tamamlama: `POST /auth/reset-password`,
  ayrı ekran — bu spec kapsamı dışında.)
- Geri butonu → bir önceki ekran (genelde `/login`).

## 2. Layout (yukarıdan aşağıya)

| # | Bölüm | Not |
|---|---|---|
| 0 | **TopAppBar** (sticky) | Sol: yuvarlak geri butonu (`arrow_back`, `primary`). Orta: "LingoCross" wordmark. Sağ: spacer (logoyu ortalar). |
| 1 | **İllüstrasyon** | Kalkan + anahtar 3D görsel, kare oran, `max-w 280px`, altta `mb = lg`. Dekoratif. |
| 2 | **Başlık + açıklama** (ortalı) | "Şifremi Unuttum" + güven verici açıklama. `mb = xl`. |
| 3 | **Form** | E-posta alanı + "Sıfırlama Bağlantısı Gönder" butonu. `space-y = lg`. |
| 4 | **Footer** | "Hâlâ sorun mu yaşıyorsunuz? Destekle İletişime Geçin". |

İçerik dikeyde ortalı, `max-width: md`, yatay padding 20px. Arka planda yumuşak iki köşe radial
gradient (dekoratif). Form gönderilince form + başlık gizlenir, yerine **başarı bloğu** gelir (bkz. 5).

## 3. Öğeler (tipografi + renk token'ı)

### 3.1 TopAppBar
- Geri butonu: 40×40 yuvarlak, `arrow_back`, renk `primary`, hover zemin `surface-container-low`,
  press scale 0.95. **Dokunma hedefi ≥ 48px'e çıkarılmalı** (Stitch'te 40px — bkz. Erişilebilirlik).
- Wordmark "LingoCross": **display-lg-mobile** (Quicksand 28/700), renk `primary`, ortalı.

### 3.2 İllüstrasyon
- Kalkan + altın anahtar 3D görsel, arkada `primary/5` blur daire. Dekoratif → semantikten hariç.
  Asset yoksa graceful fallback (sade ikon `shield` veya boşluk).

### 3.3 Başlık + açıklama
- Başlık "Şifremi Unuttum": tipo **headline-lg** (Quicksand 24/700), renk `on-surface`.
  > Not: Stitch markup'ında `headline-lg-mobile` sınıfı geçiyor ama bu token DESIGN.md'de tanımlı
  > değil. Üretimde **headline-lg** (Quicksand 24/700) kullanılır.
- Açıklama: "Endişelenmeyin! Hesabınızla ilişkili e-posta adresini girin, size bir kurtarma bağlantısı
  gönderelim." — **body-md** (Inter 16/400), renk `on-surface-variant`, ortalı, `max-w 280px`.

### 3.4 Form
- Label "E-posta Adresi": **label-lg** (Inter 14/600), renk `on-surface-variant`, `mb = xs`, `ml-1`.
- Input: tam genişlik, zemin `surface-container-lowest` (`#ffffff`), 1px `outline-variant` kenarlık,
  `rounded-xl`, padding `py ≈ md (16px)`, sol ikon için `pl-12`. Leading ikon `mail`: renk `outline`,
  focus'ta `primary`. Placeholder "ad@ornek.com" renk `outline/50`. `type=email`, `required`, autofill email.
- **Buton (primary, 3D):** tam genişlik, zemin `primary`, metin `on-primary`, tipo **headline-md**
  (Quicksand 20/600), `rounded-xl`, padding `py ≈ md`. İçerik: "Sıfırlama Bağlantısı Gönder" + `send`
  ikonu (`gap = xs`). 3D: 4px alt gölge `#004395`; press'te aşağı kayma.

### 3.5 Başarı bloğu (idle'da gizli)
- Yuvarlak ikon kutusu 64×64, zemin `tertiary-fixed` (`#6ffbbe`), ikon `check_circle` 32px renk
  `on-tertiary-fixed` (`#002113`). Başarı/validation **yeşil = tertiary** ailesi (DESIGN.md).
- Başlık "Bağlantı Gönderildi!": **headline-md** (Quicksand 20/600), `on-surface`.
- Açıklama "Sıfırlama bağlantısı için gelen kutunuzu kontrol edin. Göremezseniz spam klasörüne bakın."
  — **body-md**, `on-surface-variant`.
- "Tekrar gönder" butonu: metin buton, renk `primary`, **label-lg**, hover zemin `primary/5`.

### 3.6 Footer
"Hâlâ sorun mu yaşıyorsunuz? **Destekle İletişime Geçin**" — **label-sm** `on-surface-variant`,
link `primary` bold. Üst boşluk `mt = xl`.

## 4. Bileşen davranışı

- **Input focus:** 2px `primary` ring + `primary` kenarlık; leading ikon `outline` → `primary`.
- **Input hata:** kenarlık + ring `error`; alan altı **label-sm** `error` mesaj.
- **Buton 3D:** idle 4px alt gölge; press aşağı kayma; loading'te disabled + spinner.
- **Form → başarı geçişi:** başarı yanıtında form + başlık bloğu gizlenir, başarı bloğu fade/zoom-in
  ile görünür.

## 5. Durumlar (idle / loading / error / success)

| Durum | Davranış |
|---|---|
| **idle** | İllüstrasyon + başlık + boş form. Buton aktif. |
| **validation** | E-posta boş/geçersiz → alan altı hata, submit engellenir. |
| **loading** | Buton disabled, içerik `progress_activity` spinner (animate-spin), input disabled. |
| **error (ağ/sunucu)** | Buton üstü `error-container` (`#ffdad6`) banner, metin `on-error-container`, ikon `error`. (Kayıtlı olmayan e-posta için **hata gösterilmez** — güvenlik; success akışına gider.) |
| **success** | Form gizlenir, **başarı bloğu** gösterilir (yeşil check + "Bağlantı Gönderildi!" + spam notu + "Tekrar gönder"). |

> Güvenlik: E-postanın sistemde olup olmadığı açığa çıkarılmaz; geçerli formatta her e-posta aynı
> başarı ekranını döndürür. "Tekrar gönder" makul bir cooldown ile (örn. 30sn) yeniden istek atar.

## 6. Erişilebilirlik

- **Geri butonu Stitch'te 40×40 — üretimde ≥ 48×48 dokunma hedefi** (görsel daire 40px kalabilir,
  hit alanı büyütülür).
- E-posta input görünür label'a sahip; hata `errorText` ile ilişkili.
- İllüstrasyon dekoratif → `excludeSemantics`.
- Başarı bloğunda check ikonu yeterli kontrast; durum değişimi screen reader'a duyurulmalı
  (Flutter `Semantics(liveRegion: true)`).
- Parallax/mouse efekti web-içindir; mobilde gerekmez (atlanabilir).

## 7. Türkçe metinler + i18n anahtarları

| Anahtar | Türkçe metin |
|---|---|
| `auth.forgot.title` | Şifremi Unuttum |
| `auth.forgot.description` | Endişelenmeyin! Hesabınızla ilişkili e-posta adresini girin, size bir kurtarma bağlantısı gönderelim. |
| `auth.forgot.email.label` | E-posta Adresi |
| `auth.forgot.email.placeholder` | ad@ornek.com |
| `auth.forgot.submit` | Sıfırlama Bağlantısı Gönder |
| `auth.forgot.success.title` | Bağlantı Gönderildi! |
| `auth.forgot.success.description` | Sıfırlama bağlantısı için gelen kutunuzu kontrol edin. Göremezseniz spam klasörüne bakın. |
| `auth.forgot.success.resend` | Tekrar gönder |
| `auth.forgot.support.prefix` | Hâlâ sorun mu yaşıyorsunuz? |
| `auth.forgot.support.contact` | Destekle İletişime Geçin |
| `auth.forgot.error.network` | Bağlantı hatası. Lütfen tekrar deneyin. |
| `auth.validation.email.required` | E-posta adresi gerekli. |
| `auth.validation.email.invalid` | Geçerli bir e-posta adresi girin. |

## 8. Açık konular

- **Sıfırlama yöntemi:** E-posta'daki link mi, OTP kodu mu? Reset-tamamlama ekranı bu spec
  kapsamı dışında; API `POST /auth/reset-password` sözleşmesine göre ayrı spec gerekebilir. PM/API teyidi.
- **"Tekrar gönder" cooldown:** süresi (öneri 30sn) ürün kararı.
- **Destek linki hedefi:** e-posta/`mailto` mı, yardım sayfası mı? PM kararı.
