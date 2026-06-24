# UX Spec — Oyun Sonu Raporu (Game Result Report)

> Kaynak: Stitch `projects/13138966371134318763/screens/4786e952cc504b9c8247865e80ab7daf`
> (başlık: "Oyun Sonu Raporu").
> Design system: **Lumina Learning** (`docs/DESIGN.md` tek doğruluk kaynağı).
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.
> **Reprodüksiyon kuralı:** Stitch tasarım dili (layout, kart, renk, tipografi, gölge,
> micro-interaction) **birebir** korunur. M5 kapsamı dışına çıkan veya Stitch'te eksik kalan
> içerik **Sapma (gerekçe)** maddeleriyle işaretlenir (aşağıda).

## 0. Kapsam (M5) — net sınır

- **VAR (M5):** Bu ekran (oyun sonu raporu). Oyun bitince (tüm çiftler eşleşince — bkz.
  `game-word-matching.md` §5.1, "Bitir" → M5) bu ekrana gelinir. İçerik: **süre**, **başarı/skor**
  (yüzde + radyal görsel), **doğru/toplam**, **öğretmenle paylaş** aksiyonu + durumları, **tekrar oyna**.
- **Veri (M5):** Rapor, biten oyun oturumundan (`game_session`) okunur: `accuracyPercent`,
  `correct`/`total`, `elapsedSeconds` (M4'te count-up timer'dan; bkz. `game-word-matching.md` Sapma 3).
  "Öğretmene gönder" → öğretmen-öğrenci enrollment'ı üzerinden sonucu paylaşan endpoint (M5 backend
  görevinde netleşir; bu spec yalnız UX'tir).
- **YOK (M5 değil):** Öğretmenin sonucu görmesi/takip paneli **M6**'dır — bu ekran yalnız öğrencinin
  paylaşımı **tetiklediği** uçtur. Geçmiş sonuçlar listesi → `student-results-history.md` (ayrı dosya,
  Stitch'te yok; aşağıda not).

## 1. Layout (yukarıdan aşağıya — Stitch birebir)

| # | Bölüm | Not (Stitch) |
|---|---|---|
| 0 | **TopAppBar** (`fixed top-0 z-50`) | Sol: `arrow_back` ikonu (`primary`). Orta: wordmark "LingoCross" (`headline-lg-mobile`, `primary`, bold). Sağ: 32×32 yuvarlak **profil avatarı** (`rounded-full`, `surface-container` zemin, `object-cover`). Zemin `surface`, `px-margin-mobile py-sm`. |
| 1 | **Başarı başlığı** (`text-center mb-lg`) | Üstte yüzen kutlama ikon kutusu (`auto_awesome` FILL 1, 40px, `bg-secondary-container` yuvarlak, `animate-float`) + arkada hafif **konfeti** dekoru (%20 opak, `pointer-events-none`). Başlık "Oyun Özeti" (`headline-lg`). Alt metin "Harika bir iş çıkardın!" (`body-md`, `on-surface-variant`). |
| 2 | **Doğruluk radyal grafiği** (`chart-container 220×220 mb-xl`) | SVG progress-ring: track halka (`stroke-surface-container`, 16px) + dolgu halka (`stroke-primary`, 16px, `stroke-linecap:round`, `-90°` döndürülmüş, animasyonlu dolum). Ortada: yüzde **display-lg** `primary` (örn "%85") + altında "Doğruluk" (`label-lg`, `on-surface-variant`). |
| 3 | **İstatistik bento ızgarası** (`grid grid-cols-2 gap-md mb-xl`) | 2 küçük kart yan yana + 1 tam-genişlik streak kartı altta. Bkz. §3.3. |
| 4 | **Aksiyon butonları** (`w-full max-w-md px-xs`) | **Birincil: "Öğretmene Gönder"** (3D primary, `send` ikonu, `mb-lg`). **İkincil: "Tekrar Oyna"** (yumuşak gri, `replay` ikonu). Bkz. §3.4. |
| 5 | **Alt navigasyon** (`fixed bottom-0 z-50`) | 3 sekme: Home / **Reports (aktif)** / Profile. Bkz. §3.5 + Sapma 6. |

`main`: `pt-24 pb-32 px-margin-mobile flex flex-col items-center`. (`pt-24` TopAppBar, `pb-32` alt
nav için boşluk.) Bölümler ortalı, kart blokları `max-w-md w-full`.

## 2. Renk & tipografi token eşlemesi (Stitch config birebir)

Stitch'in tailwind config'i `docs/DESIGN.md` token'larıyla **birebir** örtüşür (primary `#0058be`,
secondary-container `#fea619`, tertiary `#006947`, surface `#f8f9ff`, on-surface `#0b1c30` …).
Spacing token'ları aynı (`xs:8 sm:12 md:16 lg:24 xl:32 margin-mobile:20`). Köşe yarıçapı: Stitch
`rounded-xl = 0.75rem` (12px) kart/buton için, `rounded-full` halka/avatar/streak-pill için.

> **Köşe-yarıçapı notu (DESIGN.md ile fark):** DESIGN.md'de buton/input için `lg = 1rem (16px)`,
> `xl = 1.5rem (24px)` tanımlı; Stitch bu ekranda kart ve butonlarda `rounded-xl = 12px` kullanmış.
> **Stitch birebir** esas (12px). Bu, token-adı çakışmasıdır (DESIGN.md `xl`=24px ≠ Tailwind
> `xl`=12px) ve mevcut açık konu Task #10 ile uyumludur — kodda `AppRadius.md (12px)` kullanılmalı.
> *(Sapma değil; köşe sözleşmesi netleştirmesi.)*

## 3. Öğeler (tipografi + renk token'ı + davranış)

### 3.1 TopAppBar
- `arrow_back`: `material-symbols-outlined`, `primary`. Geri → öğrenci paneline döner (oyun bitti,
  onay diyaloğu gerekmez; veri zaten kaydedildi). Dokunma hedefi ≥ 48px (padding ile).
- Wordmark "LingoCross": **headline-lg-mobile** (Quicksand, `primary`, bold).
- Profil avatarı: 32×32 `rounded-full`, `surface-container` zemin, kullanıcı fotoğrafı `object-cover`.
  Foto yoksa baş harf/placeholder. Dokunma → profil (tasarım sisteminde tutarlı). Hedef ≥ 48px.

### 3.2 Başarı başlığı
- **Kutlama ikon kutusu:** `inline-flex p-md bg-secondary-container rounded-full
  text-on-secondary-container`, içinde `auto_awesome` (FILL 1, 40px). `animate-float`
  (3s ease-in-out sonsuz; ±10px dikey salınım). Kutlama vurgusu = secondary turuncu (DESIGN.md ödül).
- **Konfeti dekoru:** `absolute -top-12`, 5 renkli parça (`primary`, `secondary-container`,
  `tertiary`, `error`, `secondary`), JS ile yüklemede 30 parça düşürülür (`animate` API, 1–3s).
  Dekoratiftir → `aria-hidden`. (Bkz. §4 micro-interaction + §5 koşullu render.)
- Başlık "Oyun Özeti": **headline-lg** (Quicksand 24/700), `on-surface`, `mb-xs`.
- Alt metin "Harika bir iş çıkardın!": **body-md** (Inter 16/400), `on-surface-variant`.

### 3.3 Doğruluk radyal grafiği (başarı/skor — görsel)
- Kapsayıcı: `chart-container` 220×220, `relative`, içerik ortalı.
- SVG `progress-ring` (`height/width 220`, `transform: rotate(-90deg)`):
  - **Track halkası:** `circle r=90 stroke-width=16 fill=transparent`, renk `stroke-surface-container`
    (`#e5eeff`).
  - **Dolgu halkası:** `circle r=90 stroke-width=16`, renk `stroke-primary`. `stroke-linecap:round`.
    Çevre = 2πr = **565.48**. `stroke-dasharray="565.48"`; `stroke-dashoffset = 565.48 × (1 − yüzde)`
    (Stitch %85 → offset `84.82`). `transition: stroke-dashoffset 1s ease-in-out` ile **soldan dolar**
    (yükleme animasyonu).
- Orta etiket (`absolute flex-col items-center`):
  - Yüzde: **display-lg** (Quicksand 32/700, `-0.02em`), `primary`. Format `%{n}` (örn "%85").
  - Alt etiket "Doğruluk": **label-lg** (Inter 14/600), `on-surface-variant`.
- **Renk eşiği (öneri, davranışsal):** Stitch tek renk (primary mavi) gösterir → **birebir mavi**
  esas. Başarıya göre renk değişimi (düşük=error, yüksek=tertiary) Stitch'te **yok**; eklenmez.
  *(Sapma değil; Stitch'i esas alma kararı.)*

> **Başarı/skor = doğruluk yüzdesi** (`correct/total` üzerinden). Bu, oyunlaştırma puanı (streak/XP)
> ile **karıştırılmaz** — bkz. §3.3.1 ve Sapma 1.

#### 3.3.1 "Skor" ≠ "oyunlaştırma puanı" (kavram ayrımı)
- **Başarı skoru (bu ekranın metriği):** doğruluk yüzdesi + doğru/toplam. Ölçülebilir, öğretmenle
  paylaşılan **akademik** metrik. Radyal grafik ve bento bunu gösterir.
- **Oyunlaştırma (streak/XP):** motivasyon öğesi; akademik başarı değildir. Stitch'te yalnız
  **streak kartı** var (XP yok). Paylaşılan rapor verisi streak/XP **içermez** (yalnız süre + doğruluk
  + doğru/toplam). Detay → Sapma 1.

### 3.3.2 İstatistik bento ızgarası
`grid grid-cols-2 gap-md w-full max-w-md mb-xl`. Kart taban kalıbı (`bento-card`):
`bg-surface-container-lowest` (beyaz), 1px `#e2e8f0` (≈`outline-variant`) kenarlık,
gölge `0 4px 12px rgba(59,130,246,0.08)` (DESIGN.md Level 2 mavi-tonlu), `rounded-xl p-md`,
`active:scale(0.98)`, hover'da `translateY(-4px)` (spring `cubic-bezier(.34,1.56,.64,1)`).

| Kart | İçerik (Stitch) | Token |
|---|---|---|
| **Geçen Süre** | `timer` ikonu (`primary`) + etiket "Geçen Süre" (`label-sm`, `on-surface-variant`) + değer "04:12" (`headline-md`) | süre `MM:SS` |
| **Bulunan Kelime** | `menu_book` ikonu (`secondary`) + etiket "Bulunan Kelime" (`label-sm`) + değer "17 / 20" (`headline-md`) | doğru/toplam |
| **Streak (tam genişlik)** | `col-span-2`, `border-secondary-fixed bg-secondary-fixed/10`. Sol: `local_fire_department` (FILL 1, `secondary`, 32px) + "{n} Günlük Seri!" (`headline-md`, `secondary`) + "Hız kesmeden devam ediyorsun." (`label-sm`, `on-secondary-fixed-variant`). Sağ: yuvarlak `chevron_right` rozeti (`bg-secondary p-xs rounded-full text-on-secondary`). | oyunlaştırma — bkz. Sapma 1 |

- İkon/değer hizası: küçük kartlar `flex-col items-center text-center`; streak kartı
  `flex items-center justify-between`.

### 3.4 Aksiyon butonları
- **Birincil — "Öğretmene Gönder"** (öğretmenle paylaş aksiyonu):
  `w-full bg-primary-container text-on-primary-container py-md rounded-xl font-headline-md`,
  **3D alt kenar** `box-shadow: 0 4px 0 #004395`; press'te `0 0 0` + `translateY(4px)` (DESIGN.md
  buton 3D) + `active:scale-95`. `send` ikonu + etiket. `mb-lg`. → §6 paylaşım durumları.
  - *Not (Stitch):* zemin `primary-container` (`#2170e4`), `on-primary-container` metin — Stitch
    birebir. (DESIGN.md birincil buton "canlı mavi"; bu ton ailesi içinde, birebir korunur.)
- **İkincil — "Tekrar Oyna":**
  `w-full bg-surface-container-high text-on-surface-variant py-md rounded-xl font-label-lg`,
  gölgesiz, `replay` ikonu + etiket, `hover:bg-surface-variant`. → aynı dersin oyununu yeniden başlatır
  (yeni `game_session`).
- **Sapma 2 (bitir butonu):** Görev "tekrar oyna / **bitir** butonları" istiyor; Stitch'te ayrı bir
  "Bitir" butonu **yok** (ikincil aksiyon yalnız "Tekrar Oyna"). **Stitch birebir** korunur: "Bitir"
  görevini **TopAppBar `arrow_back`** + alt nav "Home" üstlenir (panele dönüş). Ayrı "Bitir" butonu
  **eklenmez**. *(Sapma — gerekçe: Stitch reprodüksiyonu; "bitir" zaten geri/Home ile karşılanıyor.)*

### 3.5 Alt navigasyon (TabBar)
3 sekme: **Home** (`home`), **Reports** (`analytics`, FILL 1 — **aktif**, `bg-primary-container`
pill + `on-primary-container`), **Profile** (`person`). Zemin `surface-container-low`,
`rounded-t-xl`, üst gölge `0 -4px 12px rgba(59,130,246,0.08)`. Etiketler `label-sm`.
- **Sapma 6 (etiket dili):** Stitch sekme etiketleri **İngilizce** (Home/Reports/Profile). Lumina
  ürün dili Türkçe → üretimde **i18n** ile çevrilir: **Ana Sayfa / Raporlar / Profil**. Görsel/ikon/
  yerleşim birebir. *(Sapma — gerekçe: tek dil Türkçe; i18n-hazır.)*
- **Sapma 7 (nav tutarlılığı):** Alt nav bu ekrana özgü değil, uygulama kabuğudur. Diğer M2–M4
  ekranlarında alt nav farklı/eksik kurgulanmışsa, kabuk-düzeyi nav birleştirme **M7 cila**'ya
  bırakılır; bu spec yalnız bu ekrandaki render'ı tanımlar. *(Sapma — gerekçe: kapsam; kabuk M7.)*

## 4. Micro-interaction (Stitch script birebir)

- **`animate-float`:** kutlama ikonu sürekli yüzme (3s, ±10px).
- **Konfeti:** `DOMContentLoaded` + 500ms gecikme → 30 parça, rastgele renk/şekil (yuvarlak/kare),
  rastgele yön ve süre (1–3s), `cubic-bezier(0,.9,.57,1)`, biten parça DOM'dan silinir.
  - **Koşullu (öneri):** Konfeti yalnız **iyi sonuçta** (örn. doğruluk ≥ %70) oynatılır; düşük
    sonuçta bastırılır (ton uyumu). M5'te basit eşik yeterli. *(Davranışsal netleştirme; görsel birebir.)*
- **Radyal dolum:** açılışta `stroke-dashoffset` 0'dan hedefe `1s ease-in-out` ile dolar (yüzde say-up
  ile eşlenebilir — opsiyonel).
- **Bento kart:** hover `translateY(-4px)` (spring), `active:scale(0.98)`.
- **Buton 3D (Öğretmene Gönder):** alt kenar `0 4px 0 #004395`; press `translateY(4px)` + `0 0 0`.
- **Press feedback:** birincil buton `active:scale-95`.

## 5. Durumlar (rapor yüklenmesi)

| Durum | Görünüm |
|---|---|
| **Yükleniyor** | Rapor verisi gelene kadar **skeleton**: radyal yerinde gri halka shimmer; bento kartlar `min-h` shimmer blok; başlık statik; butonlar pasif (opak). Konfeti **çalışmaz**. |
| **Başarı (varsayılan)** | Bu spec'in ana hâli — tüm metrikler dolu, konfeti (koşullu) oynar, paylaş butonu **boşta (idle)**. |
| **Hata (rapor yüklenemedi)** | Metrik bloğu yerine hata kartı: `cloud_off` (`error`), "Sonuç yüklenemedi" + "Tekrar Dene" (ikincil stroke). Paylaş gizli/pasif. |

> Stitch yalnız "başarı" hâlini çizer; yükleniyor/hata, tasarım sistemine göre eklenir
> (diğer spec'lerle tutarlı). *(Davranışsal ekleme; görsel dil birebir.)*

## 6. Paylaşım durumları — "Öğretmene Gönder" (idle / gönderiliyor / başarı / hata / paylaşıldı)

Stitch butonu yalnız **boşta (idle)** hâlini çizer; aksiyon durumları tasarım sistemine göre
eklenir (Sapma 3). Buton **yerinde** durum değiştirir (layout sabit kalır):

| Durum | Buton görünümü | Yardımcı UI |
|---|---|---|
| **idle** | "Öğretmene Gönder" + `send` ikonu, 3D primary aktif. | — |
| **gönderiliyor** | Etiket "Gönderiliyor…", `send` yerine **dönen spinner** (`progress_activity` / CircularProgressIndicator, `on-primary-container`), buton **pasif** (`pointer-events-none`, hafif opak), 3D gölge sabit. | İkincil buton da pasif. |
| **başarı / paylaşıldı** | Buton **tertiary** yeşile geçer (`bg-tertiary text-on-tertiary`), etiket **"Öğretmene Gönderildi"** + `check_circle` (FILL 1). **Pasif** (tekrar gönderim engellenir), gölge `0 4px 0` tertiary-koyu tonu. | Üstte kısa **snackbar/toast**: "Sonucun öğretmenine gönderildi." (`tertiary-container` zemin, `on-tertiary-container` metin, `rounded-lg`). Toast 3sn sonra kaybolur; buton yeşil-paylaşıldı hâlinde **kalıcı**. |
| **hata** | Buton idle'a döner (yeniden denenebilir), kısa **kırmızı toast/inline**: "Gönderilemedi, tekrar dene." (`error-container` zemin, `on-error-container` metin). İsteğe bağlı `error` ikonu. | Tekrar dokunulabilir. |

- **Tek-yön kilit:** "paylaşıldı" kalıcıdır (oturum içinde) — çift gönderim önlenir; sayfa yeniden
  yüklenirse sunucudan `shared=true` gelirse buton doğrudan yeşil-paylaşıldı render edilir.
- **Erişilebilirlik:** durum değişimi `aria-live="polite"` ile bildirilir ("Gönderiliyor",
  "Gönderildi", "Gönderilemedi"). Spinner'a `aria-label="Gönderiliyor"`.

## 7. Erişilebilirlik

- Dokunma hedefleri ≥ 48px: butonlar `py-md` + padding; TopAppBar ikon/avatar padding ile ≥ 48px;
  alt nav sekmeleri `px-5 py-1` (ikon+etiket bloğu ≥ 48px).
- **Renk + metin birlikte:** doğruluk yalnız renge değil, **% sayısı + "Doğruluk"** etiketine bağlı;
  paylaşım başarısı yeşil **+ "Gönderildi" metni + tik ikonu**.
- Konfeti ve arka plan dekoru `aria-hidden`. `animate-float` `prefers-reduced-motion`'da durdurulur
  (konfeti ve radyal dolum animasyonu da reduced-motion'da bastırılır).
- Başlık hiyerarşisi: wordmark h1, "Oyun Özeti" h2.
- Radyal grafik ekran okuyucuya metinle: "Doğruluk yüzde {n}". Bento değerleri etiket+değer çiftiyle.
- Kontrast: tüm durum zeminleri (primary/tertiary/error/secondary) DESIGN.md token'larıyla AA çiftleri.

## 8. Türkçe metinler + i18n anahtarları

| Anahtar | TR |
|---|---|
| `game.result.title` | "Oyun Özeti" |
| `game.result.subtitle` | "Harika bir iş çıkardın!" |
| `game.result.accuracyValue` | "%{percent}" |
| `game.result.accuracyLabel` | "Doğruluk" |
| `game.result.a11y.accuracy` | "Doğruluk yüzde {percent}" |
| `game.result.timeLabel` | "Geçen Süre" |
| `game.result.timeValue` | "{time}" *(MM:SS)* |
| `game.result.wordsLabel` | "Bulunan Kelime" |
| `game.result.wordsValue` | "{found} / {total}" |
| `game.result.streakTitle` | "{days} Günlük Seri!" *(oyunlaştırma — bkz. Sapma 1)* |
| `game.result.streakDesc` | "Hız kesmeden devam ediyorsun." |
| `game.result.share` | "Öğretmene Gönder" |
| `game.result.share.sending` | "Gönderiliyor…" |
| `game.result.share.shared` | "Öğretmene Gönderildi" |
| `game.result.share.toastSuccess` | "Sonucun öğretmenine gönderildi." |
| `game.result.share.toastError` | "Gönderilemedi, tekrar dene." |
| `game.result.playAgain` | "Tekrar Oyna" |
| `game.result.error.title` | "Sonuç yüklenemedi" |
| `common.retry` | "Tekrar Dene" |
| `nav.home` | "Ana Sayfa" *(alt nav — bkz. Sapma 6)* |
| `nav.reports` | "Raporlar" |
| `nav.profile` | "Profil" |

> **Eklenmeyen (kapsam):** "Bitir" ayrı anahtarı yok (geri/Home karşılıyor — Sapma 2). XP metni yok
> (Sapma 1). Öğretmenin gördüğü ekranlar **M6**'ya aittir.

---

## Sapma listesi (Stitch ↔ M5 farkları — özet)

- **Sapma 1 (oyunlaştırma ≠ başarı skoru — streak/XP ele alışı):** Stitch'te bir **statik 5 Günlük
  Seri (streak) kartı** var; **XP yoktur** (M4 overlay'inde geçen "+20 XP" buraya taşınmamış). Karar:
  - **XP:** Stitch'te bu ekranda yok → **eklenmez** (gizli).
  - **Streak kartı:** Tasarım birebir korunur, fakat **oyunlaştırma puanıdır, başarı skoru değildir**.
    M5'te streak verisi henüz **yok** (streak takibi roadmap'te ileridedir) → kart **gizlenir**
    (graceful; veri gelince görünür). Gösterildiğinde değer dinamiktir (`{days}`), statik "5" değil.
  - **Paylaşılan rapor verisi** yalnız **süre + doğruluk + doğru/toplam** içerir; streak/XP paylaşıma
    dahil **edilmez** (akademik metrik ile oyunlaştırma ayrı tutulur).
  *(Gerekçe: CLAUDE.md/roadmap — oyunlaştırma puanı ≠ akademik başarı; veri-yokken graceful gizleme.)*
- **Sapma 2 (bitir butonu):** Stitch'te ayrı "Bitir" butonu yok; "bitir" görevi TopAppBar geri +
  alt nav "Home" ile karşılanır. Ayrı buton eklenmez. *(Gerekçe: Stitch birebir reprodüksiyon.)*
- **Sapma 3 (paylaşım durumları):** Stitch paylaş butonunun yalnız **idle** hâlini çizer.
  gönderiliyor/başarı/hata/paylaşıldı durumları (§6) tasarım sistemine göre eklenir; buton **yerinde**
  durum değiştirir. *(Gerekçe: Stitch statik mockup; gerçek async aksiyon davranışı gerekli.)*
- **Sapma 4 (yükleniyor/hata durumları):** Stitch yalnız "başarı" hâlini çizer; rapor yükleniyor/hata
  durumları (§5) tasarım sistemine göre eklenir. *(Gerekçe: gerçek veri-çekme; diğer spec'lerle tutarlı.)*
- **Sapma 5 (konfeti koşulu):** Stitch konfetiyi koşulsuz oynatır; üretimde **iyi sonuçta** (eşik)
  oynatılır, düşük sonuçta bastırılır (ton uyumu). Görsel/animasyon birebir. *(Davranışsal netleştirme.)*
- **Sapma 6 (alt nav etiket dili):** Stitch etiketleri İngilizce → i18n ile **Ana Sayfa/Raporlar/
  Profil**. Görsel/ikon birebir. *(Gerekçe: tek dil TR, i18n-hazır.)*
- **Sapma 7 (alt nav kabuk tutarlılığı):** Alt nav uygulama kabuğudur; ekranlar-arası birleştirme
  M7 cila'ya aittir; bu spec yalnız bu ekrandaki render'ı tanımlar. *(Gerekçe: kapsam.)*
- **Köşe-yarıçapı (not, sapma değil):** Stitch kart/buton `rounded-xl = 12px`; DESIGN.md token
  adlandırması farklı (`lg`=16px/`xl`=24px). Stitch birebir (12px) esas; kodda `AppRadius.md` — Task #10.
