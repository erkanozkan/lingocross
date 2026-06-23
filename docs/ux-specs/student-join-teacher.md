# UX Spec — Öğretmene Katıl (Student — Join Teacher via Invite Code)

> **Stitch'te YOK.** Bu ekranın Stitch projesinde (`13138966371134318763`) karşılığı bulunmuyor.
> Tasarım, **Lumina Learning** design system'ine (`docs/DESIGN.md`) göre, mevcut form/auth
> ekranlarının (`auth-login.md`, `auth-register.md`) tek-alan giriş kalıbını esas alarak üretildi.
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.

## 1. Amaç & Akış

Öğrencinin, öğretmeninden aldığı **davet kodunu** girip o öğretmene/sınıfa katıldığı akış. Katılınca
öğretmenin **yayınlanmış dersleri** öğrencinin panelinde görünür (bkz. `student-dashboard.md`).

- Giriş: Öğrenci panelinden "Bir Öğretmene Katıl" kartı/linki → `/student/join`.
- Akış: kod gir → "Katıl" → API doğrular → başarıda paneline dön (snackbar "Derse katıldın").
- API (M3): `POST /enrollments` body `{ code }` (öğrencinin token'ından kimlik). Yanıt: öğretmen
  adı + sınıf/ders bilgisi. Hatalar: 404 geçersiz kod, 409 zaten katılmış, 410 süresi geçmiş kod.
- Erişim: yalnız `role == student`.

## 2. Layout (yukarıdan aşağıya)

| # | Bölüm | Not |
|---|---|---|
| 0 | **TopAppBar** | Sol: `arrow_back` (`primary`) → geri (panele). Başlık ortada/solda "Öğretmene Katıl" (`headline-md`). Zemin `surface`. `px=margin-mobile`, `py=sm`. |
| 1 | **Hero / yönerge** | Ortada illüstratif yuvarlak ikon (`group_add`/`qr_code_2`) + başlık + açıklama. `space-y-sm`, ortalı. |
| 2 | **Kod giriş alanı** | Tek input + label. Opsiyonel "QR ile tara" ikincil aksiyonu. |
| 3 | **Birincil buton** | "Katıl" (full-width, 3D primary). |
| 4 | **Yardımcı not** | "Kodu öğretmeninden alabilirsin." küçük metin. |

`main`: `px-margin-mobile pt-xl space-y-lg`, `max-w-md mx-auto`, dikey akış (BottomNav **yok** —
bu bir alt/modal ekran; tam ekran sayfa veya bottom-sheet olarak da sunulabilir).

## 3. Öğeler (tipografi + renk token'ı)

### 3.1 TopAppBar
- `arrow_back` ikonu `primary`, `active:scale-95`. Başlık "Öğretmene Katıl" **headline-md**
  (Quicksand 20/600) `on-surface`. Dokunma hedefi ≥ 48px.

### 3.2 Hero / yönerge
- Yuvarlak ikon kutusu 72×72, `rounded-full`, zemin `primary/10`, ikon `group_add` (`primary`,
  FILL 1). Ortalı.
- Başlık "Davet Kodunu Gir": **headline-lg** (Quicksand 24/700), `on-surface`, ortalı.
- Açıklama "Öğretmeninden aldığın 6 haneli kodu girerek derslerine katıl." **body-md**
  (Inter 16/400), `on-surface-variant`, ortalı, `max-w-xs`.

### 3.3 Kod giriş alanı (Input — DESIGN.md kuralı)
- Label "Davet Kodu" üstte görünür: **label-lg** (Inter 14/600), `on-surface-variant`.
- Input: büyük dokunma hedefi, `p-md` (16px padding), `rounded-lg`, zemin
  `surface-container-lowest`, 1px `outline` kenarlık; focus'ta **2px `primary` kenarlık** (DESIGN.md).
  - Metin **headline-md** mono benzeri, ortalı, `tracking-[0.3em]` (kod görünümü); `uppercase`,
    otomatik büyük harf; `maxlength` koda göre (ör. 6).
  - `inputType` text/number-uppercase; klavye otomatik açılır; girişte boşluk/tire temizlenir.
  - Yardımcı satır (input altı): hata yoksa "Kodu öğretmeninden alabilirsin." **label-sm**
    `on-surface-variant`; hata varsa kırmızı (bkz. 5).
- **QR alternatifi (opsiyonel):** input sağında veya altında ikincil link "QR Kodu Tara"
  (**label-lg** `primary` + `qr_code_scanner` ikonu) → kamera ile davet QR'ı okur (kod alanına yazar).
  Kamera izni yoksa gizlenir/pasifleşir (graceful — bkz. OCR ekranındaki kamera-fallback dersi).

### 3.4 Birincil buton "Katıl"
- Full-width, zemin `primary`, metin `on-primary`, **label-lg**, `py-md`, `rounded-lg`,
  3D alt kenar `shadow-[0_2px_0_#004395]`, press `active:translate-y-[2px] active:shadow-none`.
- Kod alanı boş/eksik iken **pasif** (`opacity-50`, dokunulamaz). Geçerli uzunlukta → aktif.
- Yükleme sırasında içte spinner + "Katılıyor…", buton kilitli.

### 3.5 Onay (opsiyonel ara adım)
Kod doğrulandıysa fakat anında katılım yerine teyit isteniyorsa: küçük kart "Bu öğretmene
katılmak üzeresin: **{Öğretmen Adı}**" (`label-lg` bold) + "Katıl" / "Vazgeç". MVP'de tek-adım
(doğrudan katılım) tercih edilir; teyit kartı opsiyonel.

## 4. Bileşen davranışı

- Input focus'ta `primary` kenarlık + hafif `primary/5` zemin tint.
- "Katıl" press 3D batma (DESIGN.md).
- Kod tam uzunluğa ulaşınca (ör. 6 hane) butona otomatik **focus** verilebilir (submit edilmez).
- Klavyede "Bitti/Git" → submit tetikler.
- Başarıda ekran kapanır → panele dönüş + snackbar; panel listesi yenilenir.

## 5. Durumlar

| Durum | Görünüm |
|---|---|
| **Boş/başlangıç** | Input boş, buton pasif, yardımcı metin nötr. |
| **Yazılıyor (geçersiz uzunluk)** | Buton pasif kalır; hata gösterilmez (henüz). |
| **Yükleniyor** | Buton içinde spinner + "Katılıyor…"; input düzenlenemez. |
| **Hata — geçersiz kod (404)** | Input kenarlığı `error`, yardımcı satır kırmızı: "Bu kod geçerli değil. Kontrol edip tekrar dene." Buton tekrar aktif. |
| **Hata — zaten katılmış (409)** | Bilgi tonunda satır (`secondary`/`on-secondary-fixed`): "Bu öğretmene zaten katıldın." + "Panele Dön" linki. |
| **Hata — süresi geçmiş (410)** | "Bu kodun süresi dolmuş. Öğretmeninden yeni kod iste." |
| **Hata — ağ/sunucu** | Snackbar/satır: "Bağlanılamadı. Tekrar dene." + "Tekrar Dene". |
| **Başarı** | Ekran kapanır; panelde snackbar "{Öğretmen} dersine katıldın" (zemin `tertiary`/`on-tertiary`). |

## 6. Erişilebilirlik

- Input label görünür ve programatik bağlı (`for`/`aria-label` "Davet Kodu").
- Hata metni `aria-live="polite"` ile okunur; renk **tek başına** değil metinle birlikte.
- Buton ≥ 48px yükseklik; pasifken `aria-disabled`.
- Kod alanı `autocomplete="one-time-code"` benzeri ipucu (mobil paste kolaylığı).

## 7. Türkçe metinler + i18n anahtarları

| Anahtar | TR |
|---|---|
| `student.join.appBarTitle` | "Öğretmene Katıl" |
| `student.join.heroTitle` | "Davet Kodunu Gir" |
| `student.join.heroDesc` | "Öğretmeninden aldığın 6 haneli kodu girerek derslerine katıl." |
| `student.join.codeLabel` | "Davet Kodu" |
| `student.join.codeHint` | "Kodu öğretmeninden alabilirsin." |
| `student.join.scanQr` | "QR Kodu Tara" |
| `student.join.submit` | "Katıl" |
| `student.join.submitting` | "Katılıyor…" |
| `student.join.confirmTitle` | "Bu öğretmene katılmak üzeresin: {teacher}" |
| `common.cancel` | "Vazgeç" |
| `student.join.errorInvalid` | "Bu kod geçerli değil. Kontrol edip tekrar dene." |
| `student.join.errorAlready` | "Bu öğretmene zaten katıldın." |
| `student.join.errorExpired` | "Bu kodun süresi dolmuş. Öğretmeninden yeni kod iste." |
| `student.join.errorNetwork` | "Bağlanılamadı. Tekrar dene." |
| `student.join.backToDashboard` | "Panele Dön" |
| `student.join.success` | "{teacher} dersine katıldın" |
| `common.retry` | "Tekrar Dene" |
