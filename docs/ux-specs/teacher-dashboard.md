# UX Spec — Öğretmen Paneli (Teacher Dashboard)

> Kaynak: Stitch `projects/13138966371134318763/screens/5d57f8977cfd48728550f4272af72ac7`
> Design system: **Lumina Learning** (`docs/DESIGN.md` tek doğruluk kaynağı).
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.

## 1. Amaç & Akış

Öğretmenin giriş sonrası ana ekranı. Buradan öğretmen: (a) **yeni ders** oluşturur, (b) **aktif
derslerini** listeler ve birine girer, (c) öğrenci raporlarına/gelişimine erişir. M2 kapsamı:
dersler listesi + "yeni ders" aksiyonu + özet. Raporlar/gelişim bölümleri ekranda görünür ama
**içerikleri M5/M6'da doldurulur** — M2'de yalnız iskelet + boş/örnek durum.

- Giriş: go_router guard, `user.role == teacher` → bu ekran (`/teacher`).
- "Yeni Ders Oluştur" → `/teacher/lessons/new` (bkz. `lesson-create-edit.md`).
- Ders kartı tıklama → `/teacher/lessons/{id}` (ders detayı / kelimeler — bkz. `word-list-entry.md`).
- API (M2): `GET /lessons` (öğretmenin dersleri). Özet sayıları derslerden türetilir.
- Sağ üst avatar → `/profile`.

> **Stitch uyarlama notu:** Stitch ekranında birincil aksiyon "Yeni **Bulmaca** Oluştur" ve liste
> başlığı "Aktif **Sınıflar**" olarak geçer. Ürün dili (`CLAUDE.md`) **ders** + **kelime** odaklı;
> bulmaca/crossword **Faz 2**'dir. Bu spec'te metinler ürün diline çevrildi: "Yeni Ders Oluştur" ve
> "Derslerim". Tasarım dili (bento kart, renkler, tipografi) birebir korunur.

## 2. Layout (yukarıdan aşağıya)

| # | Bölüm | Not |
|---|---|---|
| 0 | **TopAppBar** (sticky, `fixed top-0`) | Sol: wordmark "LingoCross". Sağ: yuvarlak avatar (40×40). Geri butonu **yok** (kök ekran). Zemin `surface`. `px = margin-mobile`, `py = sm`. |
| 1 | **Karşılama** | "Hoş Geldiniz, {Ad}" + streak rozeti (sağ). Altında özet satırı. `mb = xl`. |
| 2 | **Birincil aksiyonlar (bento)** | 2 kart: "Yeni Ders Oluştur" (dolu primary) + "Öğrenci Gelişimi" (tonal). 1 sütun mobil, `gap = md`. `mb = xl`. |
| 3 | **Derslerim** | Başlık + "Tümünü Gör". Altında ders kartları listesi (`flex-col gap-sm`). `mb = xl`. |
| 4 | **Yeni Öğrenci Raporları** | Başlık + bildirim kartları (glass-card). M2'de boş/örnek. `mb = xl`. |
| 5 | **BottomNavBar** (sticky, `fixed bottom-0`) | 3 sekme: Ana Sayfa (aktif) / Raporlar / Profil. |

`main`: `pt-24 pb-32 px-margin-mobile`, `max-w-4xl mx-auto` (geniş ekranda ortalanır; mobilde tam genişlik).

## 3. Öğeler (tipografi + renk token'ı)

### 3.1 TopAppBar
- Wordmark "LingoCross": **headline-lg** (Quicksand 24/700), renk `primary`, `font-bold`.
- Avatar: 40×40, `rounded-full`, 2px `primary-container` kenarlık, `bouncy-hover`. Görsel yoksa
  baş harf rozeti (zemin `surface-container`, metin `primary`). Dokunma hedefi ≥ 48px (padding ile).

### 3.2 Karşılama
- Selamlama "Hoş Geldiniz, {Ad}": **headline-lg** (Quicksand 24/700), renk `on-surface`.
- Streak rozeti: pill (`rounded-full`), zemin `secondary-fixed` (`#ffddb8`), metin `on-secondary-fixed`
  (`#2a1700`), ikon `local_fire_department` (FILL 1) + "{n} Gün" (**label-lg**). Streak/ödül = secondary
  turuncu (DESIGN.md). M2'de streak verisi yoksa rozet gizlenir (graceful).
- Özet satırı: "Öğretmen Paneli • Bugün {n} yeni raporunuz var." — **body-md** (Inter 16/400),
  `on-surface-variant`. Rapor sayısı 0 ise "Öğretmen Paneli • Yeni rapor yok." göster.

### 3.3 Birincil aksiyon kartları (bento)
İki büyük buton kart, `p-lg`, `rounded-xl`, `custom-shadow` (Y4 Blur12 `rgba(59,130,246,0.08)`),
`bouncy-hover` + `bouncy-press`. Sağ üstte büyük dekoratif ikon `opacity-10`.

- **Kart 1 — Yeni Ders Oluştur (birincil):** zemin `primary-container` (`#2170e4`), metin
  `on-primary-container`. İkon kutusu: zemin `surface-container-lowest`, ikon `add_circle` renk
  `primary`. Başlık "Yeni Ders Oluştur" **headline-md** (Quicksand 20/600); açıklama "Kendi kelime
  listenizle dakikalar içinde yeni bir ders hazırlayın." **label-sm** `opacity-90`. Dekoratif ikon `grid_view`.
  → `/teacher/lessons/new`.
- **Kart 2 — Öğrenci Gelişimi (tonal):** zemin `surface-container-highest` (`#d3e4fe`), metin
  `on-surface`, 1px `outline-variant` kenarlık. İkon kutusu zemin `primary-container`, ikon `analytics`
  renk `on-primary-container`. Başlık "Öğrenci Gelişimi"; açıklama "Sınıfların performansını ve bireysel
  öğrenci raporlarını inceleyin." renk `on-surface-variant`. Dekoratif ikon `monitoring`. **M6 hedefi** →
  M2'de "Yakında" pasif görünümü veya boş rapor ekranına yönlendirme.

### 3.4 Derslerim (liste)
- Bölüm başlığı "Derslerim": **headline-md** (Quicksand 20/600), `on-surface`.
- "Tümünü Gör" linki: **label-lg** (Inter 14/600) renk `primary` + `chevron_right`. → tam ders listesi.
- **Ders kartı** (her ders): `flex items-center p-md`, zemin `surface-container-low` (`#eff4ff`),
  `rounded-xl`, 1px `outline-variant` kenarlık, hover `border-primary`, tıklanabilir.
  - Sol ikon kutusu 48×48 (`rounded-lg`): dil/konu temalı. Varsayılan zemin `tertiary-container`
    (`#00855b`) + `on-tertiary-container` ikon `school`; alternatif `translate`/`menu_book`.
  - Orta: ders adı **label-lg** (`on-surface`) + meta "{n} Öğrenci • Son aktivite: {x}" **label-sm**
    `on-surface-variant`. M2'de öğrenci sayısı 0 ise "Henüz öğrenci yok".
  - Sağ: başarı yüzdesi **label-lg** `font-bold` + ince pill progress (genişlik 64, yükseklik 6,
    `rounded-full`). Track `outline-variant`, dolgu `tertiary` (≥%70) / `secondary` turuncu (<%70).
    M2'de oyun verisi yoksa progress + yüzde gizlenir.

### 3.5 Yeni Öğrenci Raporları (M2'de iskelet)
- Bölüm başlığı "Yeni Öğrenci Raporları": **headline-md**.
- **Bildirim kartı** (`glass-card`: `rgba(255,255,255,.7)` + `blur(8px)` + 1px `#E2E8F0`), `p-md`,
  `rounded-xl`. Sol kenarda 1px renkli şerit: uyarı `error`, başarı `tertiary`.
  - Yuvarlak ikon 40×40: uyarı `error-container`/`error` `priority_high`; başarı `surface-container-high`/
    `tertiary` `emoji_events`.
  - Başlık **label-lg** + zaman damgası (10px uppercase, `on-surface-variant`).
  - Açıklama **label-sm** `on-surface-variant`; öğrenci adı `font-bold on-surface` ile vurgulu.
  - Aksiyon linkleri: birincil **label-lg** `primary` underline ("Yardım Gönder"/"Tebrik Et"),
    ikincil `on-surface-variant` ("Yoksay").
> M2'de gerçek rapor verisi yok → bu bölüm **boş durum** gösterir (bkz. 5). Örnek kartlar yalnız M5/M6'da dolar.

### 3.6 BottomNavBar
- Zemin `surface-container-low`, `rounded-t-xl`, üst gölge `0 -4px 12px rgba(59,130,246,0.08)`.
- Aktif sekme: pill `bg-primary-container` + `on-primary-container`, ikon FILL 1, `scale-95`.
- Pasif: `on-surface-variant`, hover `surface-container-high`. Etiketler **label-sm**.
- Sekmeler: **Ana Sayfa** (`home`, aktif) / **Raporlar** (`analytics`) / **Profil** (`person`).
  Dokunma hedefi ≥ 48px.

## 4. Bileşen davranışı

- Bento kart & ders kartı: `bouncy-hover` (y -2px) + `bouncy-press` (scale .95). Press'te 3D alt
  gölge kalkar / hafif batma (DESIGN.md Level 2 → basılı).
- Ders kartı tüm yüzeyi tek dokunma hedefi; tek tıkla ders detayına gider.
- Pull-to-refresh: listeyi yeniler (`GET /lessons`).
- "Tümünü Gör": M2'de derslerin tamamı zaten kısa olabilir; ≥ 5 ders varsa ilk 4'ü göster + link aktif.

## 5. Durumlar

| Durum | Görünüm |
|---|---|
| **Yükleniyor** | Karşılama statik; Derslerim ve Raporlar bölümünde 2–3 **skeleton** kart (shimmer, `surface-container` blok, `rounded-xl`). Bento kartlar her zaman görünür. |
| **Boş — hiç ders yok** | Derslerim bölümünde illüstrasyonsuz boş durum kartı: ikon `menu_book` (`primary`), başlık "Henüz dersiniz yok" **headline-md**, açıklama "İlk dersinizi oluşturarak başlayın." **body-md** `on-surface-variant`, birincil buton "Yeni Ders Oluştur". |
| **Boş — rapor yok** | Raporlar bölümünde tek satır: "Henüz yeni rapor yok. Öğrenciler oyun oynadıkça burada görünecek." **body-md** `on-surface-variant`, ikon `notifications_off`. |
| **Hata (liste)** | Derslerim yerine hata kartı: ikon `cloud_off` `error`, "Dersler yüklenemedi" + "Tekrar Dene" butonu (secondary stroke). Diğer bölümler bağımsız. |
| **Başarı (ders oluşturuldu)** | Geri dönüşte snackbar: "Ders oluşturuldu" (zemin `tertiary`/`on-tertiary`); liste başında yeni ders vurgulu (1sn `surface-container-high` flash). |

## 6. Erişilebilirlik

- Avatar ve nav sekmelerinde dokunma hedefi ≥ 48px (görsel 40px olsa da padding ile).
- Renk + metin birlikte: başarı yüzdesi yalnız renkle değil "%82 Başarı" metniyle de anlatılır.
- Başlık hiyerarşisi: wordmark h1, karşılama h2, bölüm başlıkları h3 (ekran okuyucu sırası).
- Streak rozeti dekoratif değil → "14 günlük seri" semantik etiketi.

## 7. Türkçe metinler + i18n anahtarları

| Anahtar | TR |
|---|---|
| `teacher.dashboard.greeting` | "Hoş Geldiniz, {name}" |
| `teacher.dashboard.subtitle` | "Öğretmen Paneli • Bugün {count} yeni raporunuz var." |
| `teacher.dashboard.subtitleEmpty` | "Öğretmen Paneli • Yeni rapor yok." |
| `teacher.dashboard.streak` | "{days} Gün" |
| `teacher.dashboard.actionNewLesson.title` | "Yeni Ders Oluştur" |
| `teacher.dashboard.actionNewLesson.desc` | "Kendi kelime listenizle dakikalar içinde yeni bir ders hazırlayın." |
| `teacher.dashboard.actionProgress.title` | "Öğrenci Gelişimi" |
| `teacher.dashboard.actionProgress.desc` | "Sınıfların performansını ve bireysel öğrenci raporlarını inceleyin." |
| `teacher.dashboard.lessonsTitle` | "Derslerim" |
| `teacher.dashboard.seeAll` | "Tümünü Gör" |
| `teacher.dashboard.lessonMeta` | "{count} Öğrenci • Son aktivite: {when}" |
| `teacher.dashboard.lessonNoStudents` | "Henüz öğrenci yok" |
| `teacher.dashboard.successRate` | "%{rate} Başarı" |
| `teacher.dashboard.reportsTitle` | "Yeni Öğrenci Raporları" |
| `teacher.dashboard.emptyLessons.title` | "Henüz dersiniz yok" |
| `teacher.dashboard.emptyLessons.desc` | "İlk dersinizi oluşturarak başlayın." |
| `teacher.dashboard.emptyReports` | "Henüz yeni rapor yok. Öğrenciler oyun oynadıkça burada görünecek." |
| `teacher.dashboard.error` | "Dersler yüklenemedi" |
| `common.retry` | "Tekrar Dene" |
| `nav.home` | "Ana Sayfa" |
| `nav.reports` | "Raporlar" |
| `nav.profile` | "Profil" |
| `teacher.dashboard.lessonCreated` | "Ders oluşturuldu" |
