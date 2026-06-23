# LingoCross — Tasarım Sistemi (Source of Truth)

> **Bu doküman tasarımın tek doğruluk kaynağıdır (source of truth).**
> Kaynak: Stitch projesi `13138966371134318763` — design system adı **"Lumina Learning"**.
> Tüm UI işleri bu tokenlara ve ekran tasarımlarına **birebir** uymalıdır. Sapma gerekiyorsa
> önce UX Designer onayı alınır ve bu doküman güncellenir.

## Marka & Stil

**Enthusiastic Professionalism** — eğitimin ciddiyeti ile mobil oyunun dopamin odaklı
bağlılığı arasında denge. Modern Corporate + Soft Minimalism. Ferah yerleşim, yüksek
okunabilirlik, yumuşak gölgeler ve bilinçli renk vurgularıyla "gamified" ama çocuksu olmayan
bir his. Keskin 90° köşelerden tamamen kaçınılır.

## Renkler (named tokens)

| Token | Hex | Kullanım |
|---|---|---|
| primary | `#0058be` | Ana aksiyonlar, ilerleme, fonksiyonel öğeler |
| primary-container | `#2170e4` | |
| on-primary | `#ffffff` | |
| primary-fixed | `#d8e2ff` / dim `#adc6ff` | |
| secondary | `#855300` | (orange ailesi) ödül/streak vurguları |
| secondary-container | `#fea619` | "Playful Orange" — ödül, streak, doğru cevap vurgusu |
| tertiary | `#006947` | Başarı/validation (yeşil) |
| tertiary-container | `#00855b` | |
| error | `#ba1a1a` / container `#ffdad6` | Hata |
| background / surface | `#f8f9ff` | Arka plan |
| surface-container-lowest | `#ffffff` | Kart yüzeyi |
| surface-container-low/…/highest | `#eff4ff` → `#d3e4fe` | Tonal katmanlar |
| on-surface | `#0b1c30` | Ana metin |
| on-surface-variant | `#424754` | İkincil metin |
| outline | `#727785` / variant `#c2c6d6` | Kenarlık |

> Override referans renkleri (Stitch): primary `#3b82f6`, secondary `#f59e0b`,
> tertiary `#10b981`, neutral `#64748b`. Üretimde yukarıdaki named token'lar esastır.

## Tipografi

Çift tipli yaklaşım: **Quicksand** (başlıklar — yuvarlak, samimi), **Inter** (gövde, input, label).

| Stil | Font | Boyut | Ağırlık | Satır | Not |
|---|---|---|---|---|---|
| display-lg | Quicksand | 32px | 700 | 40px | letter-spacing -0.02em |
| display-lg-mobile | Quicksand | 28px | 700 | 36px | mobilde başlıkları %15 küçült |
| headline-lg | Quicksand | 24px | 700 | 32px | |
| headline-md | Quicksand | 20px | 600 | 28px | |
| body-lg | Inter | 18px | 400 | 28px | |
| body-md | Inter | 16px | 400 | 24px | |
| label-lg | Inter | 14px | 600 | 20px | letter-spacing 0.01em |
| label-sm | Inter | 12px | 500 | 16px | |

## Yerleşim & Boşluk (8pt grid)

Tüm boşluk/yükseklik 4px'in katı; ana ritim 8px ve 16px.

| Token | Değer |
|---|---|
| base | 4px |
| xs | 8px |
| sm | 12px (kart içi ilgili öğeler) |
| md / gutter | 16px |
| lg | 24px (ayrı içerik blokları arası) |
| xl | 32px |
| margin-mobile | 20px (yatay güvenli alan) |

## Köşe Yarıçapı

| Token | Değer | Kullanım |
|---|---|---|
| sm | 0.25rem (4px) | |
| DEFAULT | 0.5rem (8px) | |
| md | 0.75rem (12px) | |
| lg | 1rem (16px) | Buton, input, küçük kart |
| xl | 1.5rem (24px) | Büyük modül / profil kartı |
| full | 9999px | Progress bar (pill), rozet |

## Yükseklik & Derinlik (Tonal Layers + Soft Ambient Shadow)

- **Level 0 (arka plan):** düz `#f8f9ff`.
- **Level 1 (kart):** beyaz yüzey + 1px açık nötr kenarlık (`outline-variant`).
- **Level 2 (interaktif):** Level 1 + difüz gölge `Y:4px, Blur:12px, rgba(59,130,246,0.08)` (mavi tonlu).
- **Basılı durum:** gölge kalkar, 1px aşağı kayma / hafif iç parıltı ile "batma" hissi.

## Bileşenler

- **Buton (primary):** yüksek kontrast canlı mavi + beyaz metin, 2px daha koyu alt kenar
  ("3D" his), basınca alt kenar kaybolur. **Secondary:** açık mavi ghost veya gri stroke.
- **Progress:** kalın, pill (rounded-full). Track soluk gri, dolgu primary mavi; milestone'da
  dolgu secondary turuncuya animasyonla geçer.
- **Kart:** 1px nötr kenarlık. Çoktan seçmelide seçili → mavi kenarlık+tint; feedback → yeşil/kırmızı.
- **Input:** büyük dokunma hedefi, 16px padding, label alan üstünde görünür, focus'ta primary mavi kenarlık.
- **Chip/Badge:** primary'nin açık tonu zemin + koyu tonu metin (okunabilirlik).
- **Streak/Ödül:** her zaman secondary turuncu + alev ikonu + Quicksand Bold.

---

## Ekran Envanteri & Kapsam

Proje: `projects/13138966371134318763`. Cihaz: MOBILE (390px genişlik tasarım).
Ekran HTML/screenshot'ı `mcp__stitch__get_screen` ile `projects/{id}/screens/{screenId}` üzerinden çekilir.

### MVP ekranları
| Ekran | screenId | Not |
|---|---|---|
| Hoşgeldiniz (Kayıt Odaklı) | `301bfb0772794b30884fd261d36b293c` | Onboarding/landing — kayıt-odaklı güncel sürüm (rol kartları → kayıt, ayrı "Giriş Yap"). Eski sürüm: `401622fe1fb94433969185ca4f6c139b` |
| Giriş Yap | `4d9957e6df9745db8ddf21e61b6e3737` | Login |
| Hesap Oluştur | `c9cc078da3414805bdf36385cbf832ba` | Register (rol seçimi: öğretmen/öğrenci) |
| Şifremi Unuttum | `3a8035bc5a86458c9883edc080ab11ef` | Reset isteği |
| Öğretmen Paneli | `5d57f8977cfd48728550f4272af72ac7` | Dashboard |
| Öğrenci Paneli | `55a66eca691e46f98af07b426c030ae3` | Dashboard |
| Profil Sayfası | `21e40177d31a47e2ad963e7228d56adc` | |
| Kelime Listesi Yükle | `85e0bc3add444813b62a730b9b311292` | OCR yakalama + gözden geçirme/manuel düzenleme (aşağıya bakın) |
| Kelime Eşleştirme Oyunu | `27338ce47339494f9785df101d50892c` | MVP oyunu |
| Oyun Sonu Raporu | `4786e952cc504b9c8247865e80ab7daf` | Süre + başarı + paylaş |

### Faz 2 ekranları (MVP'de YOK)
| Ekran | screenId |
|---|---|
| Crossword Oyunu | `b00703d2221c4bde9c7fb943db1be314` |
| Çıkmış Sorular Listesi | `67ea9b5809574ceaa637510683b8a1e3` |
| Soru Çözüm Ekranı | `4eebe27dcdc943f2b1fb797832cb7a80` |

---

## Kelime Girişi: OCR + Manuel (MVP)

Stitch'teki **"Kelime Listesi Yükle (OCR)"** ekranı esas alınır. Öğretmenler kelimeleri iki
yolla girer:

1. **OCR (kameradan):** Öğretmen kelimeleri kâğıda yazar, kameradan/galeriden okutur. Cihaz-içi
   **Google ML Kit Text Recognition** metni satırlara ayırır. OCR tamamen istemci tarafında çalışır.
2. **Manuel:** OCR sonucunu düzenleme **ve** OCR'sız doğrudan ekleme aynı formdan yapılır.

**Gözden geçirme/düzenleme ekranı** (UX Designer tasarlar, Lumina Learning dilini birebir korur):
- OCR'dan gelen her satır bir **kelime adayı**; öğretmen düzeltir/siler/ekler.
- Her kelime için: **terim (İngilizce)** + bir veya birden çok **Türkçe karşılık** (biri primary)
  + opsiyonel **eşanlam**.
- Onaylanınca mevcut **Words API** (`POST /lessons/{id}/words`) ile kaydedilir; `words.source`
  alanı `Ocr`/`Manual` olarak işaretlenir.

Kamera/galeri izinleri iOS `Info.plist` ve Android `AndroidManifest.xml`'e eklenir.
