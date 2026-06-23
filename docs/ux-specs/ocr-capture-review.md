# UX Spec — OCR Yakalama & Gözden Geçirme (OCR Capture & Review)

> Kaynak (yakalama ekranı): Stitch `projects/13138966371134318763/screens/85e0bc3add444813b62a730b9b311292`
> ("Kelime Listesi Yükle (OCR)"). **Gözden geçirme/düzenleme ekranı Stitch'te yok — tasarım
> sistemine göre tasarlandı**; Lumina Learning dili ve `word-list-entry.md` form bileşenleri
> birebir korunarak türetildi.
> Design system: **Lumina Learning** (`docs/DESIGN.md` tek doğruluk kaynağı).
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.

## 1. Amaç & Akış

Öğretmen kelimeleri kâğıda yazar, **kamera veya galeriden** fotoğraf alır; cihaz-içi **Google ML Kit
Text Recognition** metni satırlara böler; öğretmen **satır bazında gözden geçirir/düzenler**, her
satırı terim + Türkçe karşılık(lar) + opsiyonel eşanlama eşler ve **kaydeder**.

**Akış adımları:**
1. **Yakalama** (Stitch ekranı): "Kameradan Tara" veya "Galeriden Seç" → önizleme → "Kelimeleri Çıkart".
2. **Tanıma (ML Kit, istemci tarafında):** spinner; metin satırlara ayrılır.
3. **Gözden geçirme** (yeni ekran): satır-bazlı düzenleme; terim/karşılık/eşanlam eşleme; satır sil/ekle.
4. **Kaydet:** onaylanan satırlar `POST /lessons/{id}/words` ile `source = Ocr` olarak kaydedilir.
5. Her aşamadan **manuel girişe geçiş** mümkün (bkz. 3.2 ve `word-list-entry.md`).

> ⚠️ **ML Kit tamamen istemci tarafında** çalışır (cihaz-içi, ağ gerektirmez). API'ye yalnız
> nihai kelimeler gider.
> ⚠️ **Kamera simülatörde çalışmaz** — iOS Simulator / Android Emulator kamerası yoktur.
> Geliştirme/test'te **galeriden seçim** kullanılır (galeri çalışır). UI bu yüzden galeriyi
> birinci sınıf alternatif olarak sunar; kamera yoksa graceful fallback (bkz. 5).
> İzinler: iOS `Info.plist` (NSCameraUsageDescription, NSPhotoLibraryUsageDescription),
> Android `AndroidManifest.xml` (CAMERA + medya).

---

## 2. Ekran A — Yakalama (Stitch'e birebir)

### 2.1 Layout (yukarıdan aşağıya)

| # | Bölüm | Not |
|---|---|---|
| 0 | **TopAppBar** (sticky) | Sol: geri (`arrow_back` `primary`) + başlık "Kelime Listesi Yükle". Sağ: avatar 40×40. |
| 1 | **Bilgi kartı "Nasıl Çalışır?"** | glass-card, 3 adımlı mini akış. |
| 2 | **Yakalama alanı** | Büyük kesik-kenarlıklı kamera tetikleyici / fotoğraf önizleme. |
| 3 | **İkincil aksiyonlar** | "Kelimeleri Çıkart" (önce pasif) + "VEYA" ayraç + "Manuel Giriş". |
| 4 | **BottomNavBar** | Home / Raporlar / Profil. |

`main`: `pt-24 pb-32 px-margin-mobile flex-col gap-lg`.

### 2.2 Öğeler (tipografi + renk token'ı)

- **TopAppBar başlık** "Kelime Listesi Yükle": **headline-md** (Quicksand 20/600), `primary`, `font-bold`.
- **Bilgi kartı** (`glass-card`: `rgba(255,255,255,.7)` + `blur(8px)` + 1px `#E2E8F0`), `rounded-xl`,
  `p-md`, `shadow-soft`:
  - İkon kutusu 40×40 `rounded-lg` zemin `primary-container`, ikon `auto_awesome` (FILL 1)
    `on-primary-container`. Başlık "Nasıl Çalışır?" **headline-md** `on-surface`.
  - Açıklama **body-md** `on-surface-variant`: "El yazısı listenizin fotoğrafını çekin. Metin
    tanıma kâğıdı tarar ve kelimeleri otomatik olarak listenize aktarır."
    > Stitch metni "Gelişmiş yapay zekamız…" der. Ürün diline sadık kalmak için **"metin tanıma"**
    > (ML Kit, cihaz-içi) ifadesi tercih edilir; abartılı "AI" söylemi yumuşatılır.
  - 3 adım (`grid grid-cols-3 gap-xs`): numaralı daire 8×8 zemin `surface-container` `primary` rakam +
    etiket **label-sm**: "Fotoğraf Çek" / "Tara" / "Onayla".
    > Stitch "AI Taraması" → ürün dili "Tara".
- **Yakalama tetikleyici** (idle): `w-full aspect-[4/3]`, `rounded-2xl`, 2px **kesik** `primary-container`
  kenarlık, zemin `surface-container-low`. Ortada 64×64 daire `bg-primary` + `camera_alt` (FILL 1,
  `on-primary`) gölgeli. Altında "Kamera ile Tara" **headline-md** `primary` + alt satır "Veya
  galeriden bir fotoğraf seçin" **label-lg** `on-surface-variant`. Press scale .95.
  - Dokunulunca **kaynak seçici** alt sayfa: "Kamera" (`camera_alt`) / "Galeriden Seç" (`photo_library`).
    Simülatörde kamera pasif/gizli (bkz. 5).
- **Fotoğraf önizleme** (foto alındıktan sonra, tetikleyici yerine): `aspect-[4/3]` `rounded-2xl`
  resim + sağ üstte 40×40 daire `bg-error`/`on-error` `close` (foto sil → idle'a dön).
- **"Kelimeleri Çıkart" butonu:** tam genişlik, yükseklik 56, `rounded-xl`, **headline-md** + ikon
  `data_exploration`.
  - **Pasif (foto yok):** zemin `outline-variant`, metin `on-surface-variant`, `cursor-not-allowed`.
  - **Aktif (foto var):** zemin `primary`, metin `on-primary`, 3D alt gölge.
- **Ayraç:** ince çizgi `outline-variant` + ortada "VEYA" **label-sm** `outline` uppercase tracking.
- **"Manuel Giriş" butonu:** tam genişlik 56, 2px `primary` stroke, metin `primary`, zemin `surface`,
  ikon `keyboard`, `rounded-xl`. → `word-list-entry.md` ekle bottom-sheet (OCR atlanır).

### 2.3 Davranış
- "Kelimeleri Çıkart" → ML Kit (cihaz-içi) çalışır → **Ekran B**'ye geçiş. Spinner + "Taranıyor…"
  buton içinde (Stitch'teki gibi), buton pasif.
- Stitch'teki `alert()` mock yerine üretimde doğrudan gözden geçirme ekranına navigasyon olur.

---

## 3. Ekran B — Gözden Geçirme & Düzenleme (Stitch'te yok)

ML Kit'in döndürdüğü ham satırlar burada **kelime adaylarına** dönüşür. Her satır düzenlenebilir,
silinebilir; yeni satır eklenebilir. Lumina form bileşenleri (`word-list-entry.md` 3.4) yeniden kullanılır.

### 3.1 Layout

| # | Bölüm | Not |
|---|---|---|
| 0 | **TopAppBar** | Geri + başlık "Tanınan Kelimeler". Sağ: "Tümünü Temizle" overflow. |
| 1 | **Özet şeridi** | "{n} kelime tanındı • {m} seçili" + güven uyarısı. |
| 2 | **Aday satır listesi** | Düzenlenebilir kelime kartları. |
| 3 | **Sticky alt aksiyon** | "Seçilenleri Kaydet ({m})" primary 3D. |

### 3.2 Öğeler

- **Başlık** "Tanınan Kelimeler": **headline-md** `primary`.
- **Özet şeridi:** "{n} kelime tanındı" **body-md** `on-surface` + seçili sayaç chip
  (`primary-fixed`/`on-primary-fixed`). Bilgi notu **label-sm** `on-surface-variant`:
  "Metin tanıma hatalı olabilir; kaydetmeden önce kontrol edin."
- **Aday kelime kartı** (`surface-container-lowest`, 1px `outline-variant`, `rounded-xl`, `p-md`):
  - **Seçim onay kutusu** (sol): satırı kaydetmeye dahil/hariç. Varsayılan işaretli. ≥ 48px hedef.
  - **Terim input'u:** ML Kit satırından ön-dolu (`environment`), düzenlenebilir; **headline-md**
    görünümlü inline input. Boşsa satır otomatik hariç + uyarı.
  - **Türkçe karşılık satırları:** `word-list-entry.md` 3.4 ile aynı (≥ 1 zorunlu, biri primary,
    "+ Karşılık Ekle"). OCR genelde yalnız terimi yakalar → karşılıklar **boş gelir**; öğretmen
    doldurur. Karşılığı boş satır kaydedilemez (uyarı/hariç).
    > İsteğe bağlı kolaylık: kâğıtta "term = karşılık" formatı varsa ML Kit ayracı (`-`, `:`, `=`,
    > tab) ile bölünüp karşılık otomatik ön-doldurulabilir; öğretmen düzeltir.
  - **Eşanlam chip input'u:** opsiyonel (aynı bileşen).
  - **Satır sil** (`delete` `error`, sağ üst): adayı listeden çıkarır.
- **"+ Satır Ekle"** (liste sonu): ML Kit'in kaçırdığı kelime için boş aday kart ekler.
- **Sticky alt aksiyon:** "Seçilenleri Kaydet ({m})" primary 3D, tam genişlik. Yanında ghost
  "İptal". Tümü hariç ise pasif.

### 3.3 Davranış
- Satır onay kutusu kaydetme kapsamını belirler; başlık sayacı canlı güncellenir.
- Geçersiz satır (terim boş veya hiç karşılık yok) işaretliyse: kaydet öncesi uyarı + o satırlar
  vurgulanır; öğretmen düzeltir veya hariç bırakır.
- Kaydet → seçili+geçerli satırlar tek tek/batch `POST /lessons/{id}/words` (`source = Ocr`).
  Başarıda kelime listesine (`word-list-entry.md`) döner + snackbar "{m} kelime eklendi".

---

## 4. Bileşen davranışı (ortak)

- Buton 3D etkisi, input focus `primary` kenarlık, chip/primary-toggle davranışı `word-list-entry.md`
  ile birebir aynı.
- Primary karşılık tekliği, eşanlam chip ekleme/silme aynı kurallarla.

## 5. Durumlar

| Durum | Görünüm |
|---|---|
| **İzin reddedildi (kamera/galeri)** | Açıklayıcı kart: "Kamera/galeri erişimi gerekli" + "Ayarları Aç" (sistem ayarları) + "Manuel Giriş" alternatifi. |
| **Kamera yok (simülatör)** | Kaynak seçicide "Kamera" pasif/gri + ipucu "Bu cihazda kamera yok — galeriden seçin." Galeri her zaman aktif. |
| **Tanınıyor (ML Kit)** | "Kelimeleri Çıkart" butonu içinde spinner + "Taranıyor…", buton pasif. |
| **Tanıma sonucu boş** | Ekran B yerine boş durum: ikon `image_search` (`on-surface-variant`), "Hiç kelime tanınamadı" + "Net, iyi aydınlatılmış bir fotoğraf deneyin." + "Tekrar Tara" / "Manuel Giriş". |
| **Tanıma hatası** | Hata kartı `error-container`/`on-error-container`, ikon `error`, "Tarama başarısız oldu" + "Tekrar Dene" / "Manuel Giriş". |
| **Gözden geçirme — eksik satırlar** | Geçersiz satırlar `error` ince kenarlık + alt uyarı; kaydet uyarı diyaloğu. |
| **Kaydediliyor** | Sticky buton spinner + "Kaydediliyor…", liste kilitli. |
| **Kaydetme kısmi hatası** | Bazı satır başarısızsa: başarılılar eklenir, başarısızlar listede `error` rozetli kalır + "Başarısız satırları tekrar dene". |
| **Başarı** | Kelime listesine dön + snackbar "{m} kelime eklendi" (zemin `tertiary`/`on-tertiary`). |

## 6. Erişilebilirlik

- Kamera/galeri tetikleyici ve onay kutuları ≥ 48px; onay kutusu durumu metinle de ("kaydedilecek").
- ML Kit güven uyarısı görünür metin (yalnız ikon değil).
- Tanıma sırasında "Taranıyor" ekran okuyucuya bildirilir (`aria-live`).
- Yakalama alanı kesik kenarlık + "Kamera ile Tara" metni; salt görsele güvenilmez.

## 7. Teknik notlar (UX → mobil dev'e)

- ML Kit Text Recognition **on-device**; sonuç `List<TextLine>` → her satır bir aday.
- Satır temizliği: baş/son boşluk kırp, boş satır at, çok kısa (< 2 karakter) satırları işaretle.
- `words.source = Ocr`; manuel eklenen/araya sokulan satır `Manual`.
- Kamera **emülatörde yok** → test akışı galeri üzerinden; CI/demo için galeri zorunlu yol.

## 8. Türkçe metinler + i18n anahtarları

| Anahtar | TR |
|---|---|
| `ocr.capture.title` | "Kelime Listesi Yükle" |
| `ocr.capture.howTitle` | "Nasıl Çalışır?" |
| `ocr.capture.howDesc` | "El yazısı listenizin fotoğrafını çekin. Metin tanıma kâğıdı tarar ve kelimeleri otomatik olarak listenize aktarır." |
| `ocr.capture.step1` | "Fotoğraf Çek" |
| `ocr.capture.step2` | "Tara" |
| `ocr.capture.step3` | "Onayla" |
| `ocr.capture.trigger.title` | "Kamera ile Tara" |
| `ocr.capture.trigger.subtitle` | "Veya galeriden bir fotoğraf seçin" |
| `ocr.capture.sourceCamera` | "Kamera" |
| `ocr.capture.sourceGallery` | "Galeriden Seç" |
| `ocr.capture.extract` | "Kelimeleri Çıkart" |
| `ocr.capture.scanning` | "Taranıyor…" |
| `ocr.capture.or` | "VEYA" |
| `ocr.capture.manual` | "Manuel Giriş" |
| `ocr.capture.noCamera` | "Bu cihazda kamera yok — galeriden seçin." |
| `ocr.capture.permissionTitle` | "Kamera/galeri erişimi gerekli" |
| `ocr.capture.openSettings` | "Ayarları Aç" |
| `ocr.review.title` | "Tanınan Kelimeler" |
| `ocr.review.summary` | "{count} kelime tanındı" |
| `ocr.review.selected` | "{count} seçili" |
| `ocr.review.confidenceNote` | "Metin tanıma hatalı olabilir; kaydetmeden önce kontrol edin." |
| `ocr.review.addRow` | "Satır Ekle" |
| `ocr.review.clearAll` | "Tümünü Temizle" |
| `ocr.review.save` | "Seçilenleri Kaydet ({count})" |
| `ocr.review.empty.title` | "Hiç kelime tanınamadı" |
| `ocr.review.empty.desc` | "Net, iyi aydınlatılmış bir fotoğraf deneyin." |
| `ocr.review.retry` | "Tekrar Tara" |
| `ocr.review.error` | "Tarama başarısız oldu" |
| `ocr.review.invalidRows` | "Eksik satırları doldurun veya kaldırın." |
| `ocr.review.saving` | "Kaydediliyor…" |
| `ocr.review.partialError` | "Başarısız satırları tekrar dene" |
| `ocr.review.savedSnack` | "{count} kelime eklendi" |
