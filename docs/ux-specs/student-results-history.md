# UX Spec — Öğrenci Geçmiş Sonuçları (Student Results History)

> **Stitch'te yok.** Bu ekranın Stitch projesinde (`13138966371134318763`) birebir karşılığı
> **yoktur**. Tasarım, **Lumina Learning** design system'i (`docs/DESIGN.md` tek doğruluk kaynağı)
> ve mevcut spec'lerin (özellikle `student-dashboard.md` bento/kart kalıbı + `game-result-report.md`
> radyal/istatistik dili) **türevidir**. Yeni token/bileşen icat edilmez; var olan kalıplar kullanılır.
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.

## 0. Neden bu ekran var (kapsam)

- M5'te öğrenci, biten her oyunun sonucunu `game_results`'a yazar (Task #41) ve listeleyebilir
  (`GET /results/me`, Task #43; mobil Task #47).
- Bu ekran, öğrencinin **alt nav "Raporlar"** sekmesinin hedefidir (bkz. `student-dashboard.md`
  BottomNav + `game-result-report.md` §3.5 — "Reports" aktif sekme aynı kabuğa işaret eder).
- **VAR (M5):** Öğrencinin **kendi** geçmiş sonuç listesi (ders adı, tarih, doğruluk, süre,
  doğru/toplam, paylaşıldı rozeti) + bir satıra dokununca **Oyun Sonu Raporu** (`game-result-report.md`)
  detayına gidiş.
- **YOK:** Öğretmenin öğrenci sonuçlarını görmesi/filtrelemesi → **M6** (öğretmen takip paneli). Bu
  ekran yalnız **öğrenci** içindir.

## 1. Layout (yukarıdan aşağıya — Lumina kalıbı)

| # | Bölüm | Not |
|---|---|---|
| 0 | **TopAppBar** (`fixed top-0 z-50`) | `game-result-report.md` §3.1 ile **birebir aynı kabuk**: sol `arrow_back` (`primary`), orta wordmark "LingoCross" (`headline-lg-mobile`, `primary`), sağ profil avatarı (32×32 `rounded-full`). |
| 1 | **Sayfa başlığı** | "Sonuçlarım" (`headline-lg`, `on-surface`) + alt etiket "Tüm oyun geçmişin" (`body-md`, `on-surface-variant`). `mb-lg`. |
| 2 | **Özet şeridi** (opsiyonel, `grid grid-cols-2 gap-md mb-lg`) | İki `bento-card`: **Toplam Oyun** (`{count}`, `analytics`/`primary`) + **Ortalama Doğruluk** (`%{avg}`, `track_changes`/`secondary`). Değerler `headline-md`. `student-dashboard.md` "Gelişim Özeti" ile tutarlı. |
| 3 | **Sonuç listesi** (`flex-col gap-sm`) | Her oyun bir **sonuç kartı** (bkz. §3.3). En yeni üstte (tarihe göre desc). |
| 4 | **Alt navigasyon** | `game-result-report.md` §3.5 ile aynı kabuk; burada **"Raporlar" sekmesi aktif**. |

`main`: `pt-24 pb-32 px-margin-mobile`, `max-w-md mx-auto`.

## 2. Token eşlemesi

Tüm renk/tipografi/spacing/gölge **`docs/DESIGN.md`** ve mevcut spec'lerle aynı: `bento-card`
(beyaz, 1px `outline-variant`, gölge `0 4px 12px rgba(59,130,246,0.08)`, `rounded-xl p-md`),
`active:scale(0.98)`. Yüzde/skor dili `game-result-report.md` ile birebir (primary mavi metrik,
streak/oyunlaştırma **akademik skordan ayrı** — burada gösterilmez).

## 3. Öğeler

### 3.1 TopAppBar & 3.2 Başlık
- TopAppBar: `game-result-report.md` §3.1 birebir.
- "Sonuçlarım": **headline-lg** (Quicksand 24/700) `on-surface`. Alt etiket **body-md**
  `on-surface-variant`.

### 3.3 Sonuç kartı (liste öğesi)
`bento-card rounded-xl p-md` + `flex items-center justify-between`, `active:scale(0.98)`,
tıklanabilir (→ §4 detaya gidiş). Sol→sağ:

- **Sol blok (içerik):**
  - Ders adı: **headline-md** (Quicksand 20/600), `on-surface`, tek satır `truncate`.
  - Meta satırı (`label-sm`, `on-surface-variant`, `flex items-center gap-sm`):
    `schedule` ikon + süre `MM:SS` · `menu_book` ikon + "{found}/{total}" · tarih (örn "12 Haz").
- **Sağ blok (skor + durum):**
  - **Mini doğruluk rozeti:** küçük yüzde (`label-lg` bold). Renk: nötr `primary`. (İsteğe bağlı küçük
    halka/yay görseli — `game-result-report.md` radyalinin minyatürü; metin yeterli, görsel opsiyonel.)
  - **Paylaşıldı rozeti** (yalnız paylaşılmışsa): küçük chip `tertiary-container` zemin +
    `on-tertiary-container` metin + `check_circle` (FILL 1, 14px), etiket "Gönderildi". `rounded-full`
    `px-xs py-[2px]` `label-sm`. Paylaşılmamışsa rozet **yok** (chip render edilmez).

### 3.4 Özet şeridi (opsiyonel)
- İki `bento-card` (Toplam Oyun, Ortalama Doğruluk). Veri `GET /results/me` toplamından türetilir
  (sunucu vermezse istemci hesaplar). M5'te veri azsa gizlenebilir.

### 3.5 Alt navigasyon
`game-result-report.md` §3.5 birebir; **"Raporlar" aktif**. Etiketler i18n (`nav.home`/`nav.reports`/
`nav.profile` → Ana Sayfa/Raporlar/Profil — bkz. o spec Sapma 6).

## 4. Davranış

- **Satıra dokunma →** ilgili sonucun **Oyun Sonu Raporu** detayına (`game-result-report.md`,
  `game.result` ekranı) `resultId` ile gidiş. Detayda "Tekrar Oyna" aynı dersi başlatır; paylaş butonu
  paylaşılmışsa **yeşil-paylaşıldı** render edilir (o spec §6 tek-yön kilit).
- **Sıralama:** tarihe göre azalan (en yeni üstte). M5'te sayfalama gerekmez; çok kayıtta basit
  lazy-load/scroll yeterli (opsiyonel).
- **Press feedback:** kart `active:scale(0.98)`; dokunma hedefi ≥ 48px (kart `p-md` + min yükseklik).

## 5. Durumlar

| Durum | Görünüm |
|---|---|
| **Yükleniyor** | 3–4 adet **skeleton sonuç kartı** (shimmer blok, `bento-card` ölçüsünde). Özet şeridi shimmer. |
| **Dolu (varsayılan)** | Özet şeridi + sonuç kartları listesi. |
| **Boş — hiç sonuç yok** | Ortalı boş durum: ikon `sports_esports`/`history` (`primary`, yumuşak daire zemin), başlık "Henüz oyun oynamadın" (`headline-md`), açıklama "Bir ders oyununu bitirince sonucun burada görünür." (`body-md`, `on-surface-variant`) + **birincil CTA "Oyuna Başla"** (3D primary) → öğrenci paneline/ders listesine. |
| **Hata** | Hata kartı: `cloud_off` (`error`), "Sonuçlar yüklenemedi" + "Tekrar Dene" (ikincil stroke). |

## 6. Erişilebilirlik

- Sonuç kartı tek dokunma hedefi (`button`/`ListTile` semantiği) ≥ 48px; içerik metinle okunur:
  "{ders}, doğruluk yüzde {n}, süre {time}, {found} / {total}{, gönderildi}".
- Doğruluk yalnız renge değil **% sayısına**; paylaşıldı durumu yeşil **+ "Gönderildi" + tik**.
- Başlık hiyerarşisi: wordmark h1, "Sonuçlarım" h2, kart ders adı h3.
- Kontrast: chip/rozet zeminleri DESIGN.md token'larıyla AA çiftleri.

## 7. Türkçe metinler + i18n anahtarları

| Anahtar | TR |
|---|---|
| `results.history.title` | "Sonuçlarım" |
| `results.history.subtitle` | "Tüm oyun geçmişin" |
| `results.history.summary.totalGames` | "Toplam Oyun" |
| `results.history.summary.avgAccuracy` | "Ortalama Doğruluk" |
| `results.history.item.shared` | "Gönderildi" |
| `results.history.item.a11y` | "{lesson}, doğruluk yüzde {percent}, süre {time}, {found} / {total}" |
| `results.history.empty.title` | "Henüz oyun oynamadın" |
| `results.history.empty.desc` | "Bir ders oyununu bitirince sonucun burada görünür." |
| `results.history.empty.cta` | "Oyuna Başla" |
| `results.history.error.title` | "Sonuçlar yüklenemedi" |
| `common.retry` | "Tekrar Dene" |
| `nav.reports` | "Raporlar" *(alt nav — `game-result-report.md` ile paylaşılır)* |

---

## Sapma / not listesi

- **Stitch'te yok:** Bu ekranın Stitch karşılığı yoktur; tüm tasarım Lumina design system + mevcut
  spec'lerin (`student-dashboard.md`, `game-result-report.md`) türevidir. Yeni token icat edilmedi.
- **Kapsam:** Yalnız **öğrenci** geçmişi. Öğretmenin öğrenci sonuçlarını görmesi/filtrelemesi **M6**'dır.
- **Oyunlaştırma ayrımı:** Liste **akademik** metrikleri (doğruluk/süre/doğru-toplam) gösterir;
  streak/XP **gösterilmez** (`game-result-report.md` Sapma 1 ile tutarlı).
- **Detay kaynağı:** Satır detayı ayrı ekran değil; mevcut **Oyun Sonu Raporu** ekranını `resultId`
  ile yeniden kullanır (tek tasarım, iki giriş yolu: oyun-sonu + geçmiş).
