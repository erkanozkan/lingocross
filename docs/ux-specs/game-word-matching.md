# UX Spec — Kelime Eşleştirme Oyunu (Word Matching Game)

> Kaynak: Stitch `projects/13138966371134318763/screens/27338ce47339494f9785df101d50892c`
> (başlık: "Kelime Eşleştirme Oyunu").
> Design system: **Lumina Learning** (`docs/DESIGN.md` tek doğruluk kaynağı).
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.
> **Reprodüksiyon kuralı:** Stitch tasarım dili (layout, kart, renk, tipografi, gölge,
> micro-interaction) **birebir** korunur. M4 kapsamı dışına çıkan içerik (oyun-sonu raporu,
> streak verisi vb.) **Sapma (gerekçe)** maddeleriyle işaretlenir (aşağıda).

## 0. Kapsam (M4) — net sınır

- **VAR (M4):** Bu ekran (oynanış) + **minimal "tamamlandı" durumu** — yalnız süre + doğru/toplam
  ("Tüm kelimeleri eşleştirdin"). Stitch'teki tamamlanma overlay'i bu minimal hâle indirgenir.
- **YOK (M5):** **Oyun Sonu Raporu** (detaylı özet + paylaş; Stitch `4786e952…`). Bu ekranın spec'i
  **bu dosyada üretilmez**. M4 tamamlanma overlay'i yalnız bir köprü/teşekkürdür; "Sıradaki Bölüm"
  yerine "Bitir" → panele/M5 raporuna gidiş M5'te bağlanır.
- **Veri (M4):** Oyun, bir dersin yayınlanmış kelimelerinden üretilir (terim = İngilizce, karşılık =
  Türkçe primary translation). API kontratı M4 backend görevinde netleşir; bu spec yalnız UX'tir.

## 1. Oyun mekaniği (Stitch'te ne varsa)

**İki sütun + tap-eşleştirme.** (Sürükle-bırak DEĞİL.) Stitch HTML'i bunu kesin gösteriyor:

- Ekran **iki dikey sütun**a bölünür: **sol = İngilizce** (terimler), **sağ = Türkçe** (karşılıklar).
  Her sütunda eşit sayıda kart (Stitch'te 5 satır görünür); kartlar `space-y-sm` ile alt alta.
- Karşılıklar **karışık sıralıdır** (Stitch'te sol "Apple…Silence" ↔ sağ "Yolculuk…Elma"; eşleşmeler
  çapraz). `onclick="selectWord(this, lang, id)"` — her kartın bir `lang` (`en`/`tr`) ve eşleşme `id`'si var.
- **Akış:** Kullanıcı önce bir **İngilizce** karta dokunur → kart **seçili (mavi)** olur (sol sütunda
  tek seçim; yeni seçim öncekini sıfırlar). Sonra bir **Türkçe** karta dokunur → eşleşme kontrol edilir:
  - **id'ler eşleşiyorsa → doğru:** her iki kart **yeşil/eşleşti** durumuna geçer, pasifleşir
    (`pointer-events-none`), ilerleme +1.
  - **id'ler eşleşmiyorsa → yanlış:** seçilen Türkçe kart **kırmızı** olur + **shake** animasyonu;
    kısa süre sonra (≈400ms) nötr (beyaz) durumuna döner, seçim çözülür. *(Stitch mockup'ında yanlış
    durum rastgele tetiklenir; üretimde **id eşleşmesine** bağlanır — bkz. Sapma 1.)*
- **Tamamlanma:** Tüm çiftler doğru eşleşince **tamamlanma overlay'i** açılır (bkz. 5).
- **Bento ızgara:** `grid grid-cols-2 gap-sm` (≥lg `gap-md`). Her hücre tam genişlik buton.

> Stitch'te kartların **tap-toggle seçim** modeli var (önce terim → sonra karşılık). Bir kart-seçilip
> diğerine-dokunma modeli; çizgi-çizme/sürükleme **yok**. Bu birebir korunur.

## 2. Layout (yukarıdan aşağıya — Stitch birebir)

| # | Bölüm | Not (Stitch) |
|---|---|---|
| 0 | **TopAppBar** (`fixed top-0 z-50 h-16`) | Sol: `arrow_back` ikonu (`outline`) + wordmark "LingoCross" (`headline-lg`, `primary`, bold). Sağ: **streak rozeti** (pill, `secondary-container/20`, alev ikonu + "7") + **timer rozeti** (pill, `surface-container-high`, `schedule` ikonu + "MM:SS"). Zemin `surface`, gölge `0 4px 12px rgba(59,130,246,0.08)`, `px-margin-mobile`. |
| 1 | **Oyun ilerleme başlığı** | Sol: üst etiket "MEVCUT OYUN" (uppercase `label-sm`, `outline`) + başlık "Kelime Eşleştirme" (`headline-lg`, `on-surface`). Sağ: eşleşme sayacı "3 / 8" (`label-lg`, `primary`). Altında **pill progress bar**. `mb-lg`. |
| 2 | **Oyun tahtası** (`grid grid-cols-2 gap-sm`) | Sol sütun başlık "İNGİLİZCE" + 5 terim kartı; sağ sütun başlık "TÜRKÇE" + 5 karşılık kartı. Sütun başlıkları ortalı `label-sm` uppercase `tracking-widest` `outline`. |
| 3 | **Teşvik paneli** (illüstrasyon kutusu) | `mt-xl`, `h-40`, `rounded-2xl`, zemin `surface-container`, 1px `outline-variant/30`. Arkada %20 opak yumuşak eğitim deseni (kitap/balon/ampul); önde ortalı italik teşvik metni (`body-md`, `on-surface-variant`). |
| 4 | **Alt aksiyon çubuğu** (`fixed bottom-0 z-50`) | İki buton yan yana (`gap-md`): **"Vazgeç"** (outline + `close` ikonu) ve **"İpucu"** (3D primary + `lightbulb` FILL 1). Zemin `surface`, üst gölge `0 -4px 12px rgba(0,0,0,0.04)`, `py-4`. |
| 5 | **Tamamlanma overlay'i** (`fixed inset-0 z-100`, gizli) | Yarı saydam karartma + glass panel: kutlama ikonu, başlık, mesaj, birincil buton (bkz. 5). |

`main`: `pt-24 pb-32 px-margin-mobile`, `max-w-lg mx-auto`, `min-h-screen`. (`pt-24` TopAppBar,
`pb-32` alt aksiyon çubuğu için boşluk.)

## 3. Öğeler (tipografi + renk token'ı)

### 3.1 TopAppBar
- `arrow_back` ikonu: `material-symbols-outlined`, renk `outline`, `active:scale-95`. → "Vazgeç" ile
  aynı çıkış davranışı (onay diyaloğu — bkz. 4). Dokunma hedefi ≥ 48px (padding ile).
- Wordmark "LingoCross": **headline-lg** (Quicksand 24/700), `primary`, `font-bold`, `tracking-tight`.
- **Streak rozeti:** pill `rounded-full`, zemin `secondary-container/20`, 1px `secondary-container/30`
  kenarlık, `px-3 py-1 gap-1`. İçerik: `local_fire_department` (FILL 1, `secondary`, 20px) + sayı
  **label-lg** bold `secondary`. Streak/ödül = secondary turuncu (DESIGN.md).
  - **Sapma 2 (gerekçe: roadmap — streak M6):** M4'te streak verisi yok → rozet **gizlenir** (graceful).
    Tasarım birebir korunur, yalnız veri gelene kadar render edilmez.
- **Timer rozeti:** pill `rounded-full`, zemin `surface-container-high` (`#dce9ff`), `px-3 py-1 gap-1`.
  İçerik: `schedule` ikonu (`primary`, 20px) + süre **label-lg** medium `on-surface-variant`. Format
  `MM:SS`. **M4'ün asıl metriği** — oyun başlar başlamaz **artan** (count-up) sayaçtır; oyun sonu süresi
  buradan alınır. *(Stitch mockup'ı geri sayım yapıyor; üretimde **geçen süre** ölçülür — bkz. Sapma 3.)*

### 3.2 Oyun ilerleme başlığı
- Üst etiket "MEVCUT OYUN": **label-sm** (Inter 12/500) uppercase `tracking-wider`, `outline`.
- Başlık "Kelime Eşleştirme": **headline-lg** (Quicksand 24/700), `on-surface`.
- Eşleşme sayacı "{matched} / {total}": **label-lg** (Inter 14/600), `primary`, sağ hizalı.
- **Pill progress bar:** `h-3 w-full`, track `bg-surface-container-highest` (`#d3e4fe`),
  `rounded-full overflow-hidden`. Dolgu: `bg-primary`, `rounded-full`, width = `matched/total*100%`,
  `transition-all duration-500`. (DESIGN.md: kalın pill progress, dolgu primary mavi.)
  - **Not (milestone):** DESIGN.md, milestone'da dolgunun `secondary` turuncuya animasyonla geçişini
    önerir; Stitch bu ekranda **uygulamamış** (saf mavi). Stitch birebir korunur → saf `primary` mavi.
    *(Sapma değil; Stitch'i esas alma kararı.)*

### 3.3 Oyun tahtası — terim ve karşılık kartları
İki sütun (`space-y-sm` her biri). Sütun başlıkları: **label-sm** uppercase `tracking-widest`,
`outline`, ortalı, `pb-2`.

Kart taban kalıbı (tüm durumlar ortak): `w-full p-md min-h-[80px] rounded-xl flex items-center
justify-center text-body-lg font-semibold`, `transition-all`. Metin **body-lg** (Inter 18/400, ama
Stitch `font-semibold` uygular → 18/600). Min yükseklik 80px → dokunma hedefi rahat ≥ 48px.

Durum stilleri (DESIGN.md renk eşlemesiyle):

| Durum | Zemin | Kenarlık | Metin | Ek |
|---|---|---|---|---|
| **Nötr (eşlenmemiş)** | `white` (`surface-container-lowest`) | 1px `outline-variant` | `on-surface` | `shadow-sm`, `hover:border-primary`, `active:scale-95` |
| **Seçili (mavi)** | `primary-container` (`#2170e4`) | 2px `primary` | `on-primary-container` | `scale-105`, gölge `0 4px 12px rgba(59,130,246,0.15)` |
| **Eşleşti / Doğru (yeşil)** | `tertiary-container/10` | 2px `tertiary` (`#006947`) | `tertiary` | `check_circle` ikonu (FILL 1, 18px), `pointer-events-none`, `opacity-80`, `flex-col` (metin üstte, ikon altta), `shadow-sm` |
| **Yanlış (kırmızı)** | `error-container` (`#ffdad6`) | 2px `error` (`#ba1a1a`) | `on-error-container` | `card-shake` animasyonu (≈400ms), sonra nötr'e döner, `shadow-sm` |

- **Seçili → mavi**, **doğru → yeşil `tertiary`**, **yanlış → kırmızı `error`** (DESIGN.md ile birebir).
- **Doğru** durumdaki kartlar kalıcıdır (pasif); oyunun geri kalanında yeşil + tik kalır.
- **Yanlış** durum geçicidir: shake biter → seçilen Türkçe kart nötr'e döner; ilgili İngilizce
  seçim de çözülür (kullanıcı yeniden seçebilir). Doğru/eşleşmiş kartlar yanlış denemeden etkilenmez.

### 3.4 Teşvik paneli (illüstrasyon kutusu)
- Kapsayıcı: `mt-xl relative rounded-2xl overflow-hidden h-40`, zemin `surface-container` (`#e5eeff`),
  1px `outline-variant/30`, içerik ortalı.
- Arka plan: `absolute inset-0 opacity-20`, `bg-cover bg-center` — yumuşak, mavi-tonlu, high-key
  eğitim deseni (kitaplar, konuşma balonları, ampuller). Dekoratiftir.
- Önde metin: **body-md** (Inter 16/400) italik, `on-surface-variant`, ortalı, `px-lg`.
  Stitch metni: *"Harika gidiyorsun! Kelimeleri birleştirerek hız kazan."*
- **Davranış (öneri):** Metin oyunun gidişatına göre değişebilir (başlangıç/iyi gidiş/son düzlük).
  M4'te statik tek metin yeterli; çoklu varyant opsiyonel. *(Sapma değil; davranışsal netleştirme.)*

### 3.5 Alt aksiyon çubuğu
- **"Vazgeç" butonu (sol):** `flex-1 py-3 px-4`, 2px `outline-variant` kenarlık, metin `outline`
  **bold**, `rounded-xl`, `close` ikonu + etiket, `active:translate-y-0.5`. → çıkış onayı (bkz. 4).
- **"İpucu" butonu (sağ):** `flex-1 py-3 px-4`, zemin `primary`, metin `on-primary` **bold**,
  `rounded-xl`, **3D alt kenar** `box-shadow: 0 4px 0 #004395`; press'te `translate-y-2` +
  `box-shadow: 0 2px 0 #004395` (DESIGN.md buton 3D). İkon `lightbulb` (FILL 1) + etiket.
  - İpucu davranışı (öneri): bir eşleşmemiş çifti kısa süre vurgular/eşler. M4'te minimal: bir doğru
    çifti otomatik açabilir veya bir terimi işaretleyip karşılığını yanıp-söndürebilir. Mekanik
    detayı M4 mobil görevinde netleşir; **görsel/yerleşim birebir** korunur.

## 4. Bileşen davranışı & micro-interaction (Stitch script birebir)

- **Tap-toggle seçim:** İngilizce sütunda tek seçim — yeni İngilizce dokunuş öncekini sıfırlar
  (`bg-primary-container`, `scale-105` vb. kaldırılır). Türkçe dokunuşta eşleşme değerlendirilir.
- **`card-shake`:** yanlış eşleşmede yatay titreme `0.4s cubic-bezier(.36,.07,.19,.97)`; bitince sınıf
  kaldırılır.
- **`card-pop`:** tamamlanma panelinin giriş animasyonu (`scale 1→1.05→1`, `0.3s`).
- **Buton 3D ("İpucu"):** alt kenar `0 4px 0 #004395`; press `translateY(2px)` + `0 2px 0 #004395`.
- **Press feedback (nötr kart):** `active:scale-95`.
- **Progress geçişi:** `transition-all duration-500` (eşleşme arttıkça dolgu yumuşak büyür).
- **Timer:** `setInterval` 1sn; M4'te **count-up** (geçen süre). `MM:SS`, `padStart(2,'0')`.
- **Çıkış onayı (Vazgeç / geri):** oyun ortasında çıkışta veri kaybı uyarısı (öneri): alt sayfa/dialog
  "Oyundan çıkmak istediğine emin misin? İlerlemen kaydedilmeyecek." — Lumina dialog kalıbı (zemin
  `surface-container-lowest`, `rounded-xl`). Stitch'te buton var, onay diyaloğu çizilmemiş → davranışsal
  ekleme. *(Sapma değil; güvenlik/veri-kaybı netleştirmesi.)*

## 5. Durumlar (yükleniyor / oynanış / tamamlandı)

| Durum | Görünüm |
|---|---|
| **Yükleniyor** | Tahta yerine **skeleton**: iki sütun, her hücre `min-h-[80px] rounded-xl` shimmer (`surface-container` blok). İlerleme başlığı statik, sayaç "— / —", progress %0. Timer 00:00 (henüz başlamaz). Alt aksiyonlar pasif. |
| **Oynanış** | Bu spec'in ana hâli. Kartlar nötr/seçili/doğru/yanlış arası geçer; sayaç ve progress her doğru eşleşmede artar; timer akar. |
| **Tamamlandı — minimal (M4)** | Tüm çiftler doğru → **tamamlanma overlay'i** (bkz. 5.1). |
| **Boş — kelime yok** | Ders yayınlanmış ama yeterli kelime yoksa: oyun tahtası yerine boş durum kartı — ikon `inventory_2`/`hourglass_empty` (`primary`), başlık "Bu derste henüz oyun yok", açıklama "Öğretmen yeterli kelime ekleyince oyun hazır olacak." (**body-md** `on-surface-variant`). Geri butonu görünür. |
| **Hata (yükleme)** | Tahta yerine hata kartı: ikon `cloud_off` (`error`), "Oyun yüklenemedi" + "Tekrar Dene" butonu (secondary stroke). |

### 5.1 Tamamlanma overlay'i — minimal (M4)
Stitch'teki overlay birebir alınır, **içeriği M4'e indirgenir** (bkz. Sapma 4).

- Karartma: `fixed inset-0 z-100 bg-on-background/40 flex items-center justify-center`.
- Panel: **glass-panel** (`rgba(255,255,255,0.8)`, `backdrop-blur(8px)`, 1px `rgba(255,255,255,0.3)`),
  `w-5/6 max-w-sm rounded-3xl p-xl text-center`, giriş `card-pop`.
- İçerik:
  - Yuvarlak ikon kutusu 80×80, zemin `tertiary` (`#006947`), `rounded-full`, gölge; içinde
    `celebration` ikonu (`on-primary`/beyaz, 48px). *(Tebrik = başarı yeşili `tertiary`.)*
  - Başlık "Tebrikler!": **display-lg-mobile** (Quicksand 28/700) `on-surface`, `mb-sm`.
  - **Mesaj (M4 minimal):** süre + doğru/toplam. Örn: "Tüm kelimeleri **{matched}/{total}**
    eşleştirdin. Süre: **{MM:SS}**." (**body-md** `on-surface-variant`, `mb-xl`).
    - **Sapma 4 (gerekçe: CLAUDE.md/roadmap — rapor + XP M5):** Stitch metni "Tüm kelimeleri başarıyla
      eşleştirdin ve **+20 XP** kazandın." M4'te **XP yok**; mesaj **süre + doğru/toplam** ile değiştirilir.
      XP/rozet/streak ve detaylı özet **M5 Oyun Sonu Raporu**'na aittir.
  - **Birincil buton:** `w-full py-4`, zemin `primary`, `on-primary` bold, `rounded-xl`, 3D
    (`btn-3d-primary`). **Etiket: "Bitir"** (Stitch'teki "Sıradaki Bölüm" yerine — bkz. Sapma 5).
    Aksiyon: M4'te paneli kapatır → öğrenci paneline döner. **M5'te** bu buton M5 Oyun Sonu Raporuna
    (`4786e952…`) yönlendirir; M4'te raporu **üretme/yönlendirme yok**.

## 6. Erişilebilirlik

- Tüm kartlar ≥ 48px (zaten `min-h-[80px]`); alt aksiyon butonları `py-3` + padding ≥ 48px.
- **Renk + ikon/metin birlikte:** doğru durum yeşil **+ `check_circle`** ikonu; yanlış durum kırmızı
  **+ shake** hareketi (sadece renge bağlı değil). Ekran okuyucu için kart durumu metinle bildirilir
  ("eşleşti", "yanlış, tekrar dene").
- Kartlar `button` semantiği; eşleşmiş kart `aria-disabled="true"` + "eşleşti" etiketi.
- Timer count-up değişimi ekran okuyucuya **gürültü olmadan** (politeness off / sadece sonunda) iletilir.
- Teşvik panelindeki arka plan deseni dekoratif → `aria-hidden`.
- Başlık hiyerarşisi: wordmark h1, "Kelime Eşleştirme" h2, overlay "Tebrikler!" h3.
- Kontrast: kırmızı/yeşil/mavi durum zeminleri DESIGN.md token'larıyla (AA uyumlu çiftler).

## 7. Türkçe metinler + i18n anahtarları

| Anahtar | TR |
|---|---|
| `game.matching.title` | "Kelime Eşleştirme" |
| `game.matching.currentGameLabel` | "Mevcut Oyun" |
| `game.matching.counter` | "{matched} / {total}" |
| `game.matching.colEnglish` | "İngilizce" |
| `game.matching.colTurkish` | "Türkçe" |
| `game.matching.timer` | "{time}" *(MM:SS; sr-only: "Geçen süre {time}")* |
| `game.matching.streak` | "{days}" *(rozet; M4'te gizli — bkz. Sapma 2)* |
| `game.matching.encouragement` | "Harika gidiyorsun! Kelimeleri birleştirerek hız kazan." |
| `game.matching.hint` | "İpucu" |
| `game.matching.quit` | "Vazgeç" |
| `game.matching.quitConfirm.title` | "Oyundan çık?" |
| `game.matching.quitConfirm.desc` | "Çıkarsan ilerlemen kaydedilmeyecek." |
| `game.matching.quitConfirm.confirm` | "Çık" |
| `game.matching.quitConfirm.cancel` | "Devam Et" |
| `game.matching.a11y.matched` | "eşleşti" |
| `game.matching.a11y.wrong` | "yanlış, tekrar dene" |
| `game.matching.complete.title` | "Tebrikler!" |
| `game.matching.complete.message` | "Tüm kelimeleri {matched}/{total} eşleştirdin. Süre: {time}." |
| `game.matching.complete.finish` | "Bitir" |
| `game.matching.empty.title` | "Bu derste henüz oyun yok" |
| `game.matching.empty.desc` | "Öğretmen yeterli kelime ekleyince oyun hazır olacak." |
| `game.matching.error` | "Oyun yüklenemedi" |
| `common.retry` | "Tekrar Dene" |

> **Eklenmeyen anahtarlar (M5):** XP/ödül metni ("+20 XP kazandın"), "Sıradaki Bölüm", detaylı
> rapor/paylaş metinleri M4'te **yok** (Sapma 4 & 5). Bunlar M5 Oyun Sonu Raporu spec'ine aittir.

---

## Sapma listesi (Stitch ↔ M4 farkları — özet)

- **Sapma 1 (yanlış-durum tetiği):** Stitch mockup'ı yanlış kırmızı durumu **rastgele** (`Math.random`)
  gösterir (görsel çeşitlilik için). Üretimde yanlış durum, kartların **eşleşme id'lerine** bağlanır.
  Görsel stil birebir korunur; yalnız tetik gerçek mantığa bağlanır.
- **Sapma 2 (streak — M6):** TopAppBar streak rozeti M4'te veri olmadığı için **gizlenir**; tasarım
  birebir korunur, veri geldiğinde (M6) görünür.
- **Sapma 3 (timer yönü):** Stitch mockup'ı **geri sayım** yapar (165sn'den azalır). M4'ün metriği
  **geçen süre** olduğu için timer **count-up** çalışır (oyun sonu süresi buradan). Görsel/rozet birebir.
- **Sapma 4 (tamamlanma içeriği — XP M5):** Overlay mesajındaki **"+20 XP kazandın"** kaldırılır; M4
  minimal mesaj = **süre + doğru/toplam**. XP/rozet M5'e ait. Overlay tasarımı birebir korunur.
- **Sapma 5 (overlay CTA hedefi):** Stitch butonu "Sıradaki Bölüm" → `location.reload()`. M4'te etiket
  **"Bitir"** ve aksiyon **panele dönüş**. M5'te bu buton Oyun Sonu Raporuna (`4786e952…`) bağlanır.
- **Kapsam dışı:** **Oyun Sonu Raporu (`4786e952…`) spec'i bu dosyada üretilmedi** — M5'e bırakıldı.
- **Milestone progress rengi (not, sapma değil):** DESIGN.md milestone'da progress'in turuncuya geçişini
  önerir; Stitch bu ekranda saf mavi kullanmış → **Stitch birebir** (saf `primary`) esas alındı.
