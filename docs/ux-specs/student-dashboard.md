# UX Spec — Öğrenci Paneli (Student Dashboard)

> Kaynak: Stitch `projects/13138966371134318763/screens/55a66eca691e46f98af07b426c030ae3`
> (başlık: "Öğrenci Paneli (Netleştirilmiş İçerik Ayrımı)").
> Design system: **Lumina Learning** (`docs/DESIGN.md` tek doğruluk kaynağı).
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.
> **Reprodüksiyon kuralı:** Stitch tasarım dili (layout, bento kart, renk, tipografi, gölge,
> micro-interaction) **birebir** korunur. İçerikte Faz 2 / M6 öğeleri **Sapma** maddeleriyle
> MVP karşılığına eşlenir (aşağıda).

## 1. Amaç & Akış

Öğrencinin giriş sonrası ana ekranı. MVP'de öğrenci buradan: (a) **enrolled olduğu öğretmenlerin
yayınlanmış derslerini** görür, (b) bir dersin oyununa başlar, (c) gelişim özetini/başarımlarını
görür, (d) öğretmene **davet kodu ile katılır** (bkz. `student-join-teacher.md`).

- Giriş: go_router guard, `user.role == student` → bu ekran (`/student`).
- Ders/oyun kartı "Oyna" → M4 eşleştirme oyunu (`/student/games/{lessonId}` — bkz. M4 spec).
- Sağ üst avatar → `/profile`.
- BottomNav: Ana Sayfa (aktif) / (sekme 2) / Raporlar / Profil.
- API (M3): `GET /enrollments/me` (öğrencinin katıldığı öğretmenler) + `GET /students/me/lessons`
  (enrolled öğretmenlerin **yayınlanmış** dersleri). Özet/başarım sayıları M5/M6'da dolar.

### Stitch ↔ MVP eşlemesi (Sapma maddeleri)

Stitch ekranı Faz 2/M6 içeriğiyle dolu. Tasarım birebir korunur; **içerik** MVP'ye eşlenir:

- **Sapma 1 (gerekçe: CLAUDE.md — Crossword Faz 2):** Stitch'teki "Günün Oyunu → Dünya Edebiyatı
  **Bulmacası**" + mini crossword grid görseli, MVP'de **kelime eşleştirme oyunu** kartına eşlenir.
  Aynı bento-large kalıbı, aynı tokenlar; crossword grid yerine **kelime çifti** mini görseli
  (bkz. 3.3). Kart başlığı ders adıdır.
- **Sapma 2 (gerekçe: CLAUDE.md — Çıkmış Sorular Faz 2):** Stitch'teki "Sınavlara Hazırlan → Çıkmış
  Sorular" kartı **MVP'de gizlenir** (Faz 2 dikişi). Yerine boşaltılır; bölüm render edilmez.
  BottomNav'daki "Sorular/school" sekmesi de MVP'de **gizlenir** (bkz. 3.7).
- **Sapma 3 (gerekçe: roadmap — istatistik M6):** "Gelişim Özeti" (Tamamlanan Oyun / Ortalama
  Doğruluk / Haftalık Hedef) ve "Son Başarımlar" bölümleri **iskelet** olarak render edilir; gerçek
  değerler M5/M6'da dolar. M3'te **boş/placeholder durum** gösterilir (bkz. 5). Tasarım birebir korunur.
- **Sapma 4 (gerekçe: M3 enrollment ihtiyacı):** Stitch'te olmayan **"Öğretmene Katıl"** giriş
  noktası eklenir (boş durumda birincil CTA; dolu durumda küçük link/FAB). Tasarım sistemine göre,
  Lumina diliyle (bkz. 3.6). Stitch'te yok.

## 2. Layout (yukarıdan aşağıya — Stitch birebir)

| # | Bölüm | Not (Stitch) |
|---|---|---|
| 0 | **TopAppBar** (`sticky top-0 z-50`) | Sol: `arrow_back` ikonu (`primary`) + wordmark "LingoCross" (`headline-lg`, `primary`, bold). Sağ: yuvarlak avatar 40×40, 2px `primary` kenarlık. Zemin `surface`. `px = margin-mobile`, `py = sm`. |
| 1 | **Karşılama** | Sol: "Merhaba, {Ad}! 👋" (`headline-md`) + alt satır "Günün kelime avına hazır mısın?" (`body-md`, `on-surface-variant`). Sağ: **streak rozeti** (pill, `secondary-container`, alev ikonu FILL 1 + sayı). `space-y-xs`. |
| 2 | **Günün Oyunu** (bento-large) | Bölüm etiketi (uppercase `label-lg`, `outline`) + büyük bento kart (bkz. 3.3). |
| 3 | ~~Sınavlara Hazırlan / Çıkmış Sorular~~ | **Sapma 2 — MVP'de gizli** (Faz 2). |
| 4 | **Gelişim Özeti** (asimetrik bento grid) | Etiket + 2×2 grid (2 kare kart + 1 tam-genişlik kart). **Sapma 3 — iskelet.** |
| 5 | **Son Başarımlar** | Etiket + yatay kaydırılan rozet şeridi. **Sapma 3 — iskelet.** |
| 6 | **BottomNavBar** (`fixed bottom-0 z-50`) | Stitch'te 4 sekme; MVP'de 3 (bkz. 3.7). |

`main`: `px-margin-mobile pt-lg space-y-lg`, `max-w-2xl mx-auto` (geniş ekranda ortalanır; mobilde
tam genişlik). `body`: `pb-32` (BottomNav için alt boşluk).

## 3. Öğeler (tipografi + renk token'ı)

### 3.1 TopAppBar
- `arrow_back` ikonu: `material-symbols-outlined`, renk `primary`, `active:scale-95`. **Not:** kök
  ekranda geri butonu mantıken gereksiz; Stitch'te var → birebir korunur ama **kök ekranda gizlenir**
  (alt-ekrandan dönüşte görünür). *(Sapma değil; davranışsal netleştirme.)*
- Wordmark "LingoCross": **headline-lg** (Quicksand 24/700), renk `primary`, `font-bold`.
- Avatar: 40×40, `rounded-full`, **2px `primary` kenarlık**, `object-cover`. Görsel yoksa baş harf
  rozeti (zemin `surface-container`, metin `primary`). Dokunma hedefi ≥ 48px (padding ile) → `/profile`.

### 3.2 Karşılama
- Selamlama "Merhaba, {Ad}! 👋": **headline-md** (Quicksand 20/600), renk `on-surface`.
- Alt satır "Günün kelime avına hazır mısın?": **body-md** (Inter 16/400), `on-surface-variant`.
- **Streak rozeti** (sağ, `items-end` hizalı): pill `rounded-xl`, zemin `secondary-container`
  (`#fea619`), metin `on-secondary-container`, `px-sm py-xs`, `gap-xs`. İçerik: ikon
  `local_fire_department` (FILL 1) + sayı **headline-md**. Efekt `streak-glow`
  (`drop-shadow(0 0 8px rgba(254,166,25,0.4))`). Streak/ödül = secondary turuncu (DESIGN.md).
  M3'te streak verisi yoksa rozet **gizlenir** (graceful).

### 3.3 Günün Oyunu — bento-large (Sapma 1 ile MVP içeriği)
Bölüm etiketi "GÜNÜN OYUNU": **label-lg** uppercase `tracking-wider`, renk `outline`.

Kart: `bento-card`, zemin `surface-container-lowest` (beyaz), 1px `outline-variant` kenarlık,
`rounded-xl`, `p-lg`, `custom-shadow` (Y4 Blur12 `rgba(59,130,246,0.08)`), `relative overflow-hidden`.
Press: `active:scale-97` (`cubic-bezier(.34,1.56,.64,1)`). Sağ-alt dekoratif `bg-primary/5` blur daire.

İçerik 2 sütun (mobilde alt alta `flex-col`, ≥md yan yana):
- **Sol (içerik):** `space-y-md`
  - Üst etiket satırı (`flex gap-sm`):
    - Seviye chip: pill `bg-primary-fixed` + `on-primary-fixed-variant`, `label-sm` (ör. "İleri Seviye").
    - "Paylaşan: {Öğretmen}" — `label-sm`, `on-surface-variant`.
    - **"Öğretmenin Atadığı Oyun" chip:** pill `bg-tertiary/10` + `text-tertiary`, ikon `chat_bubble`
      16px + metin `label-sm`. *(MVP'de ders enrolled öğretmenden geldiği için anlamlı korunur.)*
  - Başlık: ders adı, **headline-lg** (Quicksand 24/700), `on-surface`. *(Sapma 1: Stitch'teki
    "Dünya Edebiyatı Bulmacası" yerine **ders adı**.)*
  - Açıklama: **body-md** `on-surface-variant`. MVP metni: "{n} kelimeyi eşleştir, doğruluk ve
    süreni geliştir." *(Sapma 1: Stitch'teki crossword/liderlik metni yerine eşleştirme oyunu metni.)*
  - **Birincil buton "Oyuna Başla":** zemin `primary`, metin `on-primary`, **label-lg**, `px-xl py-md`,
    `rounded-lg`, 3D alt kenar `shadow-[0_2px_0_#004395]`, press `active:translate-y-[2px]
    active:shadow-none` (DESIGN.md buton 3D). Sağında `play_arrow` ikonu. → M4 oyun.
- **Sağ (mini görsel kutusu):** `w-full md:w-48 aspect-square`, zemin `surface-container`,
  `rounded-xl`, `p-md`, ortalı.
  - **Sapma 1:** Stitch'teki 5×5 **crossword grid** (dolu harf hücreleri `bg-white` + `primary` harf;
    boş hücreler `bg-on-background/10`) MVP'de **kelime-çifti mini görseli** ile değiştirilir:
    2–3 satır "İngilizce ↔ Türkçe" eşleşmiş çift rozeti (ör. `apple ↔ elma`), her satır
    `bg-white rounded` + `primary` metin, ortada `↔`/`compare_arrows` ikonu. Hücre boyutu/gap aynı
    ritmi korur (7×7 hücre yerine satır kalıbı). Crossword grid'i **render edilmez** (Faz 2 dikişi).

### 3.4 (Gizli) Çıkmış Sorular — Sapma 2
Stitch'teki `primary-container` zeminli "Çıkmış Sorular" kartı **MVP'de render edilmez**. İlgili
i18n anahtarları eklenmez. Faz 2'de geri açılabilir (dikiş).

### 3.5 Gelişim Özeti — asimetrik bento grid (Sapma 3 — iskelet)
Bölüm etiketi "GELİŞİM ÖZETİ": **label-lg** uppercase, `outline`. Grid `grid-cols-2 gap-md`:
- **Kart A — Tamamlanan Oyun:** `col-span-1`, zemin `surface-container-low`, 1px `outline-variant`,
  `rounded-xl`, `p-md`, `aspect-square` (mobil). İkon kutusu 40×40 `bg-primary/10` `rounded-lg` +
  `sports_esports` (`primary`). Sayı **display-lg** (`primary`) + etiket "Tamamlanan Oyun" **label-sm**.
- **Kart B — Ortalama Doğruluk:** `col-span-1`, aynı kalıp; ikon kutusu `bg-tertiary/10` +
  `track_changes` (`tertiary`). "%{n}" **display-lg** (`tertiary`) + trend "↑ {x}%" `label-sm` bold
  `tertiary` + etiket "Ortalama Doğruluk".
- **Kart C — Haftalık Hedef (tam genişlik):** `col-span-2`, zemin `surface-container-highest`
  (`#d3e4fe`), 1px `outline-variant`, `flex items-center gap-lg`. Sol yuvarlak ikon 64×64
  `bg-secondary-container/20` + `timer` (FILL 1, `secondary`). Sağ: başlık "Haftalık Hedef"
  **label-lg** + "{x} / {y} dk" **label-sm** sağda; altında **pill progress** (`h-3 rounded-full`,
  track `outline-variant/30`, dolgu `primary`, width = orana göre, `transition-all duration-1000`);
  altında teşvik metni **label-sm** `on-surface-variant`.
- **Mikro-etkileşim:** progress bar yüklemede 0%'dan hedef orana animasyonla dolar (Stitch script).

> **Sapma 3:** M3'te bu sayılar **yok**. Bölüm iskelet olarak render edilir; değerler placeholder
> ("—") veya 0 ve progress 0% ile gösterilir, ya da bölüm tamamen "Yakında" boş durumuyla gizlenir
> (ürün kararı — bkz. 5). Tasarım birebir korunur.

### 3.6 Öğretmene Katıl — giriş noktası (Stitch'te YOK — Sapma 4)
Stitch'te bu öğe **yok**; M3 enrollment için tasarım sistemine göre eklenir (Lumina dili):
- **Boş durumda** (enrolled öğretmen yok): Karşılama altında **birincil bento kart** — zemin
  `primary-container`, metin `on-primary-container`, ikon kutusu `bg-white/20` + `group_add`, başlık
  "Bir Öğretmene Katıl" **headline-md**, açıklama "Öğretmeninden aldığın davet kodunu girerek
  derslerine eriş." **body-md** `opacity-90`, sağda `chevron_right`. → `/student/join`.
- **Dolu durumda:** "Gelişim Özeti" üstünde küçük tonal satır-link "Yeni öğretmene katıl"
  (**label-lg** `primary` + `add` ikonu) → `/student/join`. Alternatif: TopAppBar yanında `add` aksiyonu.

### 3.7 BottomNavBar
- Zemin `surface-container-low`, `rounded-t-xl`, üst gölge `0 -4px 12px rgba(59,130,246,0.08)`,
  `fixed bottom-0`. Sekmeler `flex justify-around`.
- Aktif sekme: pill `bg-primary-container` + `on-primary-container`, ikon FILL 1, `scale-95`.
- Pasif: `on-surface-variant`, hover `surface-container-high`. Etiketler **label-sm**.
- **Stitch sekmeleri:** Home / **Sorular** (`school`) / Reports / Profile.
- **Sapma 2:** "Sorular" (`school`) sekmesi Faz 2 → **MVP'de gizlenir**. MVP sekmeleri:
  **Ana Sayfa** (`home`, aktif) / **Raporlar** (`analytics`) / **Profil** (`person`). Etiketler
  Türkçeleştirilir (Stitch'te İngilizce "Home/Reports/Profile" → "Ana Sayfa/Raporlar/Profil").
  Dokunma hedefi ≥ 48px.

## 4. Bileşen davranışı

- **bento-card:** `transition-transform cubic-bezier(.34,1.56,.64,1)`, `active:scale-97` (basınca
  yaylı küçülme). Tam yüzey tek dokunma hedefi.
- **Buton 3D:** "Oyuna Başla" alt kenar `shadow-[0_2px_0_#004395]`; press'te `translate-y-[2px]` +
  `shadow-none` (batma hissi — DESIGN.md).
- **Progress animasyonu:** ekran açılışında width 0% → hedef oran (`setTimeout 300ms`, `duration-1000`).
- **Streak glow:** her zaman `secondary-container` turuncu + alev ikonu.
- **Başarım şeridi:** `overflow-x-auto`, kenar boşluğu negatif margin ile ekran kenarına taşar
  (`-mx-margin-mobile px-margin-mobile`), `scrollbar-hide`.
- **Pull-to-refresh:** ders/oyun listesini ve özetleri yeniler (`GET /students/me/lessons`).

## 5. Durumlar

| Durum | Görünüm |
|---|---|
| **Yükleniyor** | Karşılama statik; "Günün Oyunu" yerine bento-large **skeleton** (shimmer `surface-container` blok, `rounded-xl`). Gelişim Özeti kartları skeleton. |
| **Boş — hiç öğretmene katılmamış** | "Günün Oyunu" ve Gelişim Özeti **gizlenir**; bunun yerine **Öğretmene Katıl** birincil kartı (bkz. 3.6) + kısa boş durum: ikon `group_add` (`primary`), başlık "Henüz bir derse katılmadın", açıklama "Öğretmeninden aldığın davet koduyla başla." **body-md** `on-surface-variant`. |
| **Boş — öğretmen var, yayınlanmış ders yok** | "Günün Oyunu" yerine boş durum kartı: ikon `hourglass_empty` (`primary`), "Öğretmenin henüz ders yayınlamadı", "Yeni dersler burada görünecek." **body-md** `on-surface-variant`. |
| **Boş — istatistik yok (M3)** | Gelişim Özeti & Son Başarımlar: değerler "—"/0, progress 0%; ya da bölüm "Yakında — ilk oyununu oynayınca burada görünecek." (**body-md** `on-surface-variant`) tek satırıyla gösterilir. |
| **Hata (ders listesi)** | "Günün Oyunu" yerine hata kartı: ikon `cloud_off` (`error`), "Dersler yüklenemedi" + "Tekrar Dene" butonu (secondary stroke). Diğer bölümler bağımsız. |
| **Başarı (öğretmene katıldı)** | `/student/join`'den dönüşte snackbar "Derse katıldın" (zemin `tertiary`/`on-tertiary`); liste başında yeni öğretmenin dersi 1sn `surface-container-high` flash ile vurgulu. |

## 6. Erişilebilirlik

- Avatar ve nav sekmelerinde dokunma hedefi ≥ 48px (görsel 40px → padding ile).
- Renk + metin birlikte: doğruluk "%88" hem renk hem metinle; başarım kilitli/açık durumu
  `grayscale opacity-50` **yanında** ekran okuyucu etiketiyle ("kilitli rozet").
- Streak rozeti dekoratif değil → "{n} günlük seri" semantik etiketi.
- Başlık hiyerarşisi: wordmark h1, karşılama h2, bölüm başlıkları h3.
- Emoji (👋) dekoratif → ekran okuyucudan gizlenir (`aria-hidden`).

## 7. Türkçe metinler + i18n anahtarları

| Anahtar | TR |
|---|---|
| `student.dashboard.greeting` | "Merhaba, {name}! 👋" |
| `student.dashboard.subtitle` | "Günün kelime avına hazır mısın?" |
| `student.dashboard.streak` | "{days}" *(rozet içeriği; sr-only: "{days} günlük seri")* |
| `student.dashboard.gameOfDay` | "Günün Oyunu" |
| `student.dashboard.gameSharedBy` | "Paylaşan: {teacher}" |
| `student.dashboard.gameAssigned` | "Öğretmenin Atadığı Oyun" |
| `student.dashboard.gameDesc` | "{count} kelimeyi eşleştir, doğruluk ve süreni geliştir." |
| `student.dashboard.playGame` | "Oyuna Başla" |
| `student.dashboard.progressTitle` | "Gelişim Özeti" |
| `student.dashboard.statGames` | "Tamamlanan Oyun" |
| `student.dashboard.statAccuracy` | "Ortalama Doğruluk" |
| `student.dashboard.weeklyGoal` | "Haftalık Hedef" |
| `student.dashboard.weeklyGoalValue` | "{done} / {target} dk" |
| `student.dashboard.weeklyGoalHint` | "Harika gidiyorsun! Hedefine sadece {left} dakika kaldı." |
| `student.dashboard.achievementsTitle` | "Son Başarımlar" |
| `student.dashboard.joinTeacher.title` | "Bir Öğretmene Katıl" |
| `student.dashboard.joinTeacher.desc` | "Öğretmeninden aldığın davet kodunu girerek derslerine eriş." |
| `student.dashboard.joinTeacher.linkShort` | "Yeni öğretmene katıl" |
| `student.dashboard.emptyNoTeacher.title` | "Henüz bir derse katılmadın" |
| `student.dashboard.emptyNoTeacher.desc` | "Öğretmeninden aldığın davet koduyla başla." |
| `student.dashboard.emptyNoLessons.title` | "Öğretmenin henüz ders yayınlamadı" |
| `student.dashboard.emptyNoLessons.desc` | "Yeni dersler burada görünecek." |
| `student.dashboard.statsSoon` | "Yakında — ilk oyununu oynayınca burada görünecek." |
| `student.dashboard.error` | "Dersler yüklenemedi" |
| `student.dashboard.joined` | "Derse katıldın" |
| `common.retry` | "Tekrar Dene" |
| `nav.home` | "Ana Sayfa" |
| `nav.reports` | "Raporlar" |
| `nav.profile` | "Profil" |

> **Eklenmeyen anahtarlar (Faz 2):** "Çıkmış Sorular", "Sınavlara Hazırlan", crossword/liderlik
> metinleri ve "Sorular" nav sekmesi MVP'de **yok** (Sapma 2).
