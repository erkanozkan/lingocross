# UX Spec — Hoşgeldiniz / Giriş (Welcome / Landing)

> Kaynak: Stitch `projects/13138966371134318763/screens/401622fe1fb94433969185ca4f6c139b`
> Design system: **Lumina Learning** (`docs/DESIGN.md` tek doğruluk kaynağı).
> Cihaz: MOBILE, tasarım genişliği 390px. Yatay güvenli alan (margin): **20px** (`margin-mobile`).
> Bu ekran **linear/transactional** kabuktur: TopAppBar ve BottomNav **yoktur**.

## 1. Amaç & Akış

Uygulamanın ilk açılış / onboarding-landing ekranı. Kullanıcı buradan rolüne göre giriş yapar
(Öğrenci / Eğitmen), ya da yardımcı linklerden "Şifremi Unuttum" / "Hesap Oluştur" akışına geçer.
Sosyal devam (Google/Apple) ileride bağlanacak; MVP'de **görsel olarak yer alır ama opsiyoneldir**
(bkz. Açık Konular).

- Öğrenci Girişi kartı → `route: /login?role=student`
- Eğitmen Girişi kartı → `route: /login?role=teacher`
- Şifremi Unuttum → `route: /forgot-password`
- Hesap Oluştur → `route: /register`

## 2. Layout (bölüm sırası, yukarıdan aşağıya)

İçerik dikeyde **ortalanır** (`justify-center`), tek kolon, `max-width: 440px`, yatay padding 20px.
Arka plan düz `surface` (`#f8f9ff`) + dekoratif yumuşak blur daireler (opsiyonel, pointer-events yok).

| # | Bölüm | İçerik | Alt boşluk |
|---|---|---|---|
| 1 | Logo/İllüstrasyon bloğu | Daire mascot + iki floaty rozet + başlık + alt metin | `mb = xl (32px)` |
| 2 | Rol seçim kartları | Öğrenci kartı, Eğitmen kartı (dikey, aralarında `space-y = md/16px`) | `mb = xl (32px)` |
| 3 | Hızlı aksiyonlar | "Şifremi Unuttum" • "Hesap Oluştur" (yatay, ortada, ayraç nokta) | — |
| 4 | Footer / sosyal | Üst kenarlık ayraç + "Veya şunlarla devam et:" + Google/Apple yuvarlak buton | `mt = xl (32px)`, `pt = lg (24px)` |

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

### 3.2 Rol seçim kartları (2 adet, dikey)
Her kart: tam genişlik, `bg = surface-container-lowest` (`#ffffff`), 1px `outline-variant`
(`#c2c6d6`) kenarlık, `rounded-xl (12px)`, Level-2 gölge `0 4px 12px rgba(59,130,246,0.08)`,
**3D etki için 4px renkli alt kenar** (`btn-3d`), iç padding `sm (12px)`, sol ikon kutusu + metin
bloğu + sağ chevron. Min yükseklik ≥ 56px (ikon kutusu 56px → dokunma hedefi ≥ 48px karşılanır).

| Kart | İkon kutusu | İkon | 3D alt kenar | Başlık (headline-md) | Açıklama (label-sm) |
|---|---|---|---|---|---|
| **Öğrenci Girişi** | 56×56, `rounded-lg`, zemin `primary-fixed` (`#d8e2ff`) | `school`, renk `primary` | `border-b-primary-container` (`#2170e4`) | "Öğrenci Girişi", renk `on-surface` | "Öğrenmeye ve puan kazanmaya başla", renk `on-surface-variant` |
| **Eğitmen Girişi** | 56×56, `rounded-lg`, zemin `tertiary-fixed` (`#6ffbbe`) | `account_balance`, renk `tertiary` | `border-b-tertiary` (`#006947`) | "Eğitmen Girişi", renk `on-surface` | "Sınıflarını ve materyallerini yönet", renk `on-surface-variant` |

Sağ chevron (`chevron_right`): idle'da gizli; hover/press'te görünür + 4px sağa kayar (mobilde press
durumunda göstermek yeterli). Renk Öğrenci'de `primary-container`, Eğitmen'de `tertiary`.

### 3.3 Hızlı aksiyonlar
- "Şifremi Unuttum" ve "Hesap Oluştur" — tipo **label-lg** (Inter 14/600), renk `primary`, ortalı,
  aralarında `gutter (16px)` ve 4px yuvarlak `outline-variant` ayraç nokta. Press'te alt çizgi.

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
| **idle** | Yukarıdaki yerleşim. Kartlar tıklanabilir. |
| **loading** | Bu ekran navigasyon hub'ı; kendi loading'i yok. Karta basınca hedef route'a geçiş (anlık). İstenirse press feedback yeterli. |
| **error** | Yok (ağ çağrısı yapmaz). |
| **success** | Yok. |

> Not: Mascot, floaty rozetler ve arka plan blur daireleri **dekoratiftir**; asset yoksa ekran
> bozulmamalı (graceful fallback — daire + ikon ya da sade başlık).

## 6. Erişilebilirlik

- Rol kartları gerçek `button`/`InkWell` ile tüm kart tıklanabilir; dokunma hedefi ≥ 48px (56px ikon
  kutusu sayesinde karşılanır).
- Sosyal butonlar 48×48 (sınırda) — Flutter'da min 48×48 dokunma hedefi koru.
- Mascot/floaty görselleri dekoratif → semantik olarak `excludeSemantics` / boş label.
- Kontrast: `primary` başlık `surface` üstünde yeterli; `on-surface-variant` alt metin AA.

## 7. Türkçe metinler + i18n anahtarları

| Anahtar | Türkçe metin |
|---|---|
| `auth.welcome.title` | LingoCross'a Hoş Geldiniz |
| `auth.welcome.subtitle` | Dil yolculuğuna bugün başla, sınırları ortadan kaldır. |
| `auth.welcome.role.student.title` | Öğrenci Girişi |
| `auth.welcome.role.student.subtitle` | Öğrenmeye ve puan kazanmaya başla |
| `auth.welcome.role.teacher.title` | Eğitmen Girişi |
| `auth.welcome.role.teacher.subtitle` | Sınıflarını ve materyallerini yönet |
| `auth.welcome.forgotPassword` | Şifremi Unuttum |
| `auth.welcome.createAccount` | Hesap Oluştur |
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
