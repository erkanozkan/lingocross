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

**Tek kanonik ölçek.** Stitch'in **render edilen** ekranları esastır; tasarım-sistemi
YAML'ındaki `xl=24` ile çakışma, render edilen Stitch lehine çözülmüştür. Aşağıdaki ölçek
tüm UI için bağlayıcıdır; bileşen tipine göre tek bir token seçilir (keyfi ara değer yok).

| Token | Değer | Kullanım |
|---|---|---|
| sm | 8px | Chip / Badge |
| md | 12px | Input, küçük kart |
| lg | 16px | Buton, standart kart, oyun kartı |
| xl | 20–24px | Büyük modül / hero / bottom-sheet / profil kartı |
| full | 9999px | Progress bar (pill), rozet |

> Eşleme kuralları:
> - **chip/badge → sm (8)**
> - **input + küçük kart → md (12)** (form input fill `surface-container-low`, kenarlık `outline-variant`)
> - **buton + standart kart + oyun kartı → lg (16)**
> - **büyük modül / hero / sheet / profil kartı → xl (20–24)**
>
> Kod tarafı `AppRadius` sabitleri bu ölçekle bire bir uyumludur
> (`sm=8, md=12, lg=16, xl=24, full=9999`). Eski 4px köşe kullanımı kaldırılmıştır.

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
| Karşılama + Giriş (birleşik) | `c6188f694eea4fc3966753bd2c3a262c` | **Onboarding + Login tek ekran** (Stitch: "Giriş Yap (Marka Güncellenmiş)"). Hero (maskot + Hi!/Merhaba! rozetleri + hoş geldiniz) + giriş formu (e-posta/şifre/şifremi unuttum/giriş) + kayıt CTA. Rolsüz giriş; yönlendirme `user.role`'a göre. Sosyal giriş + "VEYA" divider **gizli** (OAuth yok). Telif "© 2026 LingoCross". Spec: `docs/ux-specs/auth-login.md` |
| ~~Hoşgeldiniz (Kayıt Odaklı)~~ | ~~`301bfb0772794b30884fd261d36b293c`~~ | **KALDIRILDI / BİRLEŞTİRİLDİ** → `c6188f69…`. Eski Welcome sürümleri de kaldırıldı: `401622fe1fb94433969185ca4f6c139b`. Eski spec `auth-welcome.md` silindi (içerik `auth-login.md`'ye taşındı). |
| ~~Giriş Yap~~ | ~~`4d9957e6df9745db8ddf21e61b6e3737`~~ | **KALDIRILDI / BİRLEŞTİRİLDİ** → `c6188f69…` (birleşik karşılama + giriş ekranı). |
| Hesap Oluştur | `c9cc078da3414805bdf36385cbf832ba` | Register (rol seçimi: öğretmen/öğrenci) |
| Şifremi Unuttum | `3a8035bc5a86458c9883edc080ab11ef` | Reset isteği |
| Öğretmen Paneli | `5d57f8977cfd48728550f4272af72ac7` | Dashboard |
| Öğrenci Paneli | `55a66eca691e46f98af07b426c030ae3` | Dashboard |
| Profil Sayfası | `21e40177d31a47e2ad963e7228d56adc` | |
| Kelime Listesi Yükle | `85e0bc3add444813b62a730b9b311292` | OCR yakalama + gözden geçirme/manuel düzenleme (aşağıya bakın) |
| Kelime Eşleştirme Oyunu | `27338ce47339494f9785df101d50892c` | MVP oyunu |
| Oyun Sonu Raporu | `4786e952cc504b9c8247865e80ab7daf` | Süre + başarı + paylaş |
| Ünite Kelime Listesi | `2ec4360ad6cc4a6395255fa6298905e1` | Kelime listeleme (OCR/MANUEL rozet, primary chip) |

### Faz 2 ekranları (öğretmen otoring + bulmaca — F2.1/F2.2/F2.4)
| Ekran | screenId | Not |
|---|---|---|
| Derslerim (Öğretmen Listesi) | `930ab2e69b19449498c285a5927a8070` | F2.1 — "Sınıflar" sekmesi; ders listesi (tarih, kelime sayısı, durum AKTİF/TAMAMLANDI) + "Yeni Ders Oluştur". 4 sekmeli alt nav (Ana Sayfa/Sınıflar/Raporlar/Profil) |
| Ders Oluşturma Sayfası | `81d6e173025e4d748f474078720d6f8c` | F2.1 — tarih/hafta + ünite adı + konular + kelime listesi bağlantısı |
| Ders Detay Sayfası | `ca812b92a43a446ca3478cdd9b7ad39b` | F2.1 — başlık/durum/tarih, kelime önizleme, "Ödev Ataması Yap". "Paylaşılan Sınıflar" → **atanan öğrenci sayısı** (sınıf/grup yok) |
| Öğretmen Profil | `b557deed825c4ccb9f48efeb5a0a7d36` | F2.1 — Profil sekmesi (istatistik/rozet/menü; çıkış) |
| Yeni Bulmaca Oluştur | `73fefb5692274f28a37aa74085267f1d` | F2.2 — oyun türü (Eşleştirme/Crossword) + ders → oluştur & yayınla → aktif öğrencilere atanır |
| Crossword Oyunu | `b00703d2221c4bde9c7fb943db1be314` | F2.4 — ızgara üretimi + oynanış |

> Öğretmen Paneli (`5d57f8…`): F2.2'de "Yeni Bulmaca Oluştur" girişi "Öğrenci Gelişimi"nin üstüne eklenir.

### Faz 3+ ekranları (ertelendi)
| Ekran | screenId |
|---|---|
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
