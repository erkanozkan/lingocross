# UX Spec — Hoşgeldiniz / Giriş (Welcome / Landing)

> Kaynak: Stitch `projects/13138966371134318763/screens/401622fe1fb94433969185ca4f6c139b`
> Design system: **Lumina Learning** (`docs/DESIGN.md` tek doğruluk kaynağı).
> Cihaz: MOBILE, tasarım genişliği 390px. Yatay güvenli alan (margin): **20px** (`margin-mobile`).
> Bu ekran **linear/transactional** kabuktur: TopAppBar ve BottomNav **yoktur**.

## 1. Amaç & Akış

Uygulamanın ilk açılış / onboarding-landing ekranı. **Rol burada belirlenmez — rol yalnız HESAP
OLUŞTUR (register) akışında belirlenir.** İki rol kartı (Öğrenci / Eğitmen) artık **yeni hesap
oluşturma** akışına yönlendirir; ilgili rol register ekranında ön-seçili gelir. Mevcut kullanıcılar
için ekranda **tek, belirgin "Zaten hesabın var mı? Giriş Yap"** aksiyonu vardır → rolsüz `/login`.
Sosyal devam (Google/Apple) ileride bağlanacak; MVP'de **görsel olarak yer alır ama opsiyoneldir**
(bkz. Açık Konular).

- Öğrenci kartı → `route: /register?role=student` (register'da öğrenci rolü ön-seçili)
- Eğitmen kartı → `route: /register?role=teacher` (register'da eğitmen rolü ön-seçili)
- "Zaten hesabın var mı? Giriş Yap" → `route: /login` (**rolsüz**, query param yok)
- Şifremi Unuttum → `route: /forgot-password`

> **Karar notu (PM + kullanıcı onaylı):** Rol HESAP OLUŞTUR'da belirlenir; GİRİŞ rolsüzdür. Welcome
> kartları artık "giriş" değil **kayıt** giriş noktasıdır — yeni kullanıcı kimliğini (öğrenci/eğitmen)
> baştan seçer, böylece kayıt akışı netleşir ve login tek/sade bir alan olarak kalır. Mevcut kullanıcı
> rolünü tekrar seçmez; login yanıtındaki `user.role` doğru home'a yönlendirir. Ayrı bir "Hesap Oluştur"
> linki **kaldırıldı** çünkü iki rol kartı kaydı zaten kapsıyor (tekrarı önler).

## 2. Layout (bölüm sırası, yukarıdan aşağıya)

İçerik dikeyde **ortalanır** (`justify-center`), tek kolon, `max-width: 440px`, yatay padding 20px.
Arka plan düz `surface` (`#f8f9ff`) + dekoratif yumuşak blur daireler (opsiyonel, pointer-events yok).

| # | Bölüm | İçerik | Alt boşluk |
|---|---|---|---|
| 1 | Logo/İllüstrasyon bloğu | Daire mascot + iki floaty rozet + başlık + alt metin | `mb = xl (32px)` |
| 2 | Rol seçim kartları (kayıt) | Öğrenci kartı, Eğitmen kartı (dikey, aralarında `space-y = md/16px`) — **yeni hesap** akışına gider | `mb = lg (24px)` |
| 3 | "Zaten hesabın var mı? Giriş Yap" | Tek, belirgin satır CTA (ortalı) → `/login` (rolsüz) | `mb = xl (32px)` |
| 4 | Hızlı aksiyonlar | Yalnız "Şifremi Unuttum" (ortalı) | — |
| 5 | Footer / sosyal | Üst kenarlık ayraç + "Veya şunlarla devam et:" + Google/Apple yuvarlak buton | `mt = xl (32px)`, `pt = lg (24px)` |

8pt grid: tüm dikey ritim `xs=8 / sm=12 / md=16 / lg=24 / xl=32`. Kart içi padding `sm (12px)`.

## 3. Bölüm bölüm öğeler (tipografi + renk token'ı)

### 3.1 Logo/İllüstrasyon bloğu
- **Mascot dairesi:** 128×128 (`w-32 h-32`), `rounded-full`, zemin `primary-container` (`#2170e4`),
  içte 96×96 mascot görseli, `shadow-xl`. (Görsel asset: graduation-cap'li mavi kuş mascot.)
- **Floaty rozet 1 ("Hi!"):** sağ-üst, zemin `secondary-container` (`#fea619`), metin `on-secondary`
  (`#ffffff`), tipo **headline-md** (Quicksand 20/600), `rounded-xl`, +12° döndürme.
- **Floaty rozet 2 ("Merhaba!"):** sol-alt, zemin `tertiary-container` (`#00855b`), metin `on-tertiary`
  (`#ffffff`), tipo **headline-md**, `rounded-xl`, -12° döndürme.
- **Başlık:** "LingoCross'a Hoş Geldiniz" — tipo **display-lg-mobile** (Quicksand 28/700), renk
  `primary` (`#0058be`), ortalı, `mb = xs (8px)`.
- **Alt metin:** "Dil yolculuğuna bugün başla, sınırları ortadan kaldır." — tipo **body-md**
  (Inter 16/400), renk `on-surface-variant` (`#424754`), ortalı.

### 3.2 Rol seçim kartları (2 adet, dikey) — **kayıt giriş noktası**
Her kart: tam genişlik, `bg = surface-container-lowest` (`#ffffff`), 1px `outline-variant`
(`#c2c6d6`) kenarlık, `rounded-xl (12px)`, Level-2 gölge `0 4px 12px rgba(59,130,246,0.08)`,
**3D etki için 4px renkli alt kenar** (`btn-3d`), iç padding `sm (12px)`, sol ikon kutusu + metin
bloğu + sağ chevron. Min yükseklik ≥ 56px (ikon kutusu 56px → dokunma hedefi ≥ 48px karşılanır).

Her iki kart da **yeni hesap oluşturma** akışına gider; başlık/alt yazı **giriş** değil **yeni hesap**
çağrışımı yapar (alt yazılar "Yeni … hesabı oluştur").

| Kart | Hedef | İkon kutusu | İkon | 3D alt kenar | Başlık (headline-md) | Açıklama (label-sm) |
|---|---|---|---|---|---|---|
| **Öğrenci** | `/register?role=student` | 56×56, `rounded-lg`, zemin `primary-fixed` (`#d8e2ff`) | `school`, renk `primary` | `border-b-primary-container` (`#2170e4`) | "Öğrenci", renk `on-surface` | "Yeni öğrenci hesabı oluştur", renk `on-surface-variant` |
| **Eğitmen** | `/register?role=teacher` | 56×56, `rounded-lg`, zemin `tertiary-fixed` (`#6ffbbe`) | `account_balance`, renk `tertiary` | `border-b-tertiary` (`#006947`) | "Eğitmen", renk `on-surface` | "Yeni eğitmen hesabı oluştur", renk `on-surface-variant` |

Sağ chevron (`chevron_right`): idle'da gizli; hover/press'te görünür + 4px sağa kayar (mobilde press
durumunda göstermek yeterli). Renk Öğrenci'de `primary-container`, Eğitmen'de `tertiary`.

### 3.3 "Zaten hesabın var mı? Giriş Yap" (tek, belirgin CTA)
Rol kartlarının altında, ortalı, **tek satır** CTA: "Zaten hesabın var mı? **Giriş Yap**".
- Düz metin kısmı ("Zaten hesabın var mı?") tipo **body-md** (Inter 16/400), renk `on-surface-variant`.
- Link kısmı ("Giriş Yap") tipo **body-md** ağırlık 600 (bold), renk `primary` (`#0058be`) → `/login`
  (**rolsüz**, query param yok). Press'te alt çizgi.
- Mevcut kullanıcı için ekrandaki **birincil ikincil-yol**; rol kartlarıyla görsel olarak ayrılır
  (üstte `mb = lg (24px)` boşluk). Dokunma hedefi ≥ 48px (satır yüksekliği + padding).

### 3.4 Hızlı aksiyonlar
- Yalnız "Şifremi Unuttum" — tipo **label-lg** (Inter 14/600), renk `primary`, ortalı. Press'te alt
  çizgi. (Ayrı "Hesap Oluştur" linki **kaldırıldı**; kayıt artık rol kartlarıyla yapılır.)

### 3.4 Footer / sosyal devam
- Üst kenarlık: 1px `outline-variant`, üstte `pt = lg (24px)`.
- "Veya şunlarla devam et:" — tipo **label-sm** (Inter 12/500), renk `on-surface-variant`, `mb = md`.
- 2 yuvarlak buton (Google, Apple): 48×48 (`w-12 h-12`), `rounded-full`, 1px `outline-variant`
  kenarlık, içte 24×24 logo, aralarında `md (16px)`. Press'te `bouncy-tap` (scale 0.96).

## 4. Bileşen davranışı

- **Rol kartı 3D etki:** idle'da 4px renkli alt kenar + Level-2 difüz gölge. Basılıyken (`:active`)
  alt kenar 0'a iner ve kart 4px aşağı kayar (`translateY(4px)`) → "batma" hissi. Hover'da zemin
  `surface-container`e geçer (web/tablet; mobilde yalnız press).
- **Sosyal yuvarlak buton:** press'te bouncy-tap (scale 0.96, 0.1s).
- Bu ekranda input/form yok → input focus/hata durumu yok.

## 5. Durumlar (idle / loading / error / success)

| Durum | Davranış |
|---|---|
| **idle** | Yukarıdaki yerleşim. Kartlar (→ register) ve "Giriş Yap" CTA (→ login) tıklanabilir. |
| **loading** | Bu ekran navigasyon hub'ı; kendi loading'i yok. Karta basınca register, "Giriş Yap"a basınca login route'una geçiş (anlık). İstenirse press feedback yeterli. |
| **error** | Yok (ağ çağrısı yapmaz). |
| **success** | Yok. |

> Not: Mascot, floaty rozetler ve arka plan blur daireleri **dekoratiftir**; asset yoksa ekran
> bozulmamalı (graceful fallback — daire + ikon ya da sade başlık).

## 6. Erişilebilirlik

- Rol kartları gerçek `button`/`InkWell` ile tüm kart tıklanabilir; dokunma hedefi ≥ 48px (56px ikon
  kutusu sayesinde karşılanır). Kartların erişilebilir adı kayıt niyetini taşımalı (örn. "Yeni öğrenci
  hesabı oluştur"), salt "Öğrenci" değil.
- "Giriş Yap" CTA gerçek link/buton; dokunma hedefi ≥ 48px.
- Sosyal butonlar 48×48 (sınırda) — Flutter'da min 48×48 dokunma hedefi koru.
- Mascot/floaty görselleri dekoratif → semantik olarak `excludeSemantics` / boş label.
- Kontrast: `primary` başlık `surface` üstünde yeterli; `on-surface-variant` alt metin AA.

## 7. Türkçe metinler + i18n anahtarları

| Anahtar | Türkçe metin |
|---|---|
| `auth.welcome.title` | LingoCross'a Hoş Geldiniz |
| `auth.welcome.subtitle` | Dil yolculuğuna bugün başla, sınırları ortadan kaldır. |
| `auth.welcome.role.student.title` | Öğrenci |
| `auth.welcome.role.student.subtitle` | Yeni öğrenci hesabı oluştur |
| `auth.welcome.role.teacher.title` | Eğitmen |
| `auth.welcome.role.teacher.subtitle` | Yeni eğitmen hesabı oluştur |
| `auth.welcome.haveAccount` | Zaten hesabın var mı? |
| `auth.welcome.loginCta` | Giriş Yap |
| `auth.welcome.forgotPassword` | Şifremi Unuttum |
| `auth.welcome.continueWith` | Veya şunlarla devam et: |
| `auth.social.google` | Google |
| `auth.social.apple` | Apple |
| `auth.welcome.badge.hi` | Hi! |
| `auth.welcome.badge.merhaba` | Merhaba! |

## 8. Açık konular (orchestrator/PM kararı)

- **Sosyal giriş (Google/Apple):** `CLAUDE.md`'ye göre Auth = kendi JWT'miz; sosyal OAuth MVP
  kapsamında **belirtilmemiş**. Öneri: butonları gösterilebilir tut ama M1'de **devre dışı/gizli**
  yap, gerçek bağlama Faz sonrası. Karar PM'e.
- Mascot ve illüstrasyon asseti üretim için ayrıca temin edilmeli (Stitch görselleri placeholder).
