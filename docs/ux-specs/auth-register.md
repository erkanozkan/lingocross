# UX Spec — Hesap Oluştur (Register)

> Kaynak: Stitch `projects/13138966371134318763/screens/c9cc078da3414805bdf36385cbf832ba`
> Design system: **Lumina Learning** (`docs/DESIGN.md` tek doğruluk kaynağı).
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.

## 1. Amaç & Akış

Yeni hesap oluşturma. **Rol seçimi zorunludur (öğrenci / öğretmen)** — kullanıcı kayıt olurken
rolünü seçer. Ad Soyad + e-posta + şifre + koşul onayı ile kayıt.

- API: `POST /auth/register` (body: fullName, email, password, **role**). `role` enum: `Student` /
  `Teacher`. Başarıda doğrudan oturum açılır (token döner) veya login'e yönlendirilir (PM kararı —
  bkz. Açık Konular).
- "Giriş Yap" linkleri (TopAppBar + alt) → `/login`.

## 2. Layout (yukarıdan aşağıya)

| # | Bölüm | Not |
|---|---|---|
| 0 | **TopAppBar** (sticky) | Sol: `language` ikonu (FILL 1, `primary`) + "LingoCross" wordmark. Sağ: "Giriş Yap" link. |
| 1 | **Başlık bloğu** (ortalı) | "Yolculuğuna Başla" + alt metin. `mb = xl (32px)`. |
| 2 | **Form** | Rol seçimi → Ad Soyad → E-posta → Şifre → Koşul onayı → Hesap Oluştur butonu. Bloklar arası `space-y = lg (24px)`; input bloğu içi `space-y = md (16px)`. |
| 3 | **Sosyal divider + butonlar** | "VEYA ŞUNUNLA KAYIT OL" + Google/Apple. |
| 4 | **Alt link** | "Zaten bir hesabın var mı? Giriş Yap". |

İçerik dikeyde ortalı, `max-width: md`, yatay padding 20px.

## 3. Öğeler (tipografi + renk token'ı)

### 3.1 TopAppBar
- Wordmark "LingoCross": **display-lg-mobile** (Quicksand 28/700), renk `primary`. `language` ikonu
  `primary` FILL 1.
- "Giriş Yap": **label-lg** (Inter 14/600), renk `primary`, hover alt çizgi → `/login`.

### 3.2 Başlık bloğu
- "Yolculuğuna Başla": **display-lg-mobile** (Quicksand 28/700), renk `on-surface`, `mb = xs`.
- "Binlerce dil öğrenicisine hemen katıl.": **body-md** (Inter 16/400), renk `on-surface-variant`.

### 3.3 Rol seçimi (ZORUNLU — 2'li grid, `gap = sm`)
İki seçilebilir kart (radio grubu, `name=role`). Varsayılan seçili: **Öğrenci**. Her kart dikey
yığın: ikon + etiket, ortalı, padding `md (16px)`, zemin `surface-container-lowest`, 1px
`outline-variant` kenarlık, `rounded-xl`, hafif gölge `0 4px 12px rgba(59,130,246,0.04)`.

| Kart | İkon (FILL 1) | İkon rengi | Etiket (label-lg) | value |
|---|---|---|---|---|
| **Öğrenci** | `school` | `primary` | "Öğrenci" (`on-surface`) | `student` |
| **Öğretmen** | `co_present` | `tertiary` | "Öğretmen" (`on-surface`) | `teacher` |

**Seçili durum (DESIGN.md "kart seçim" kuralı):** seçili kartta `primary` (2px) kenarlık + hafif
`primary` tint zemin (`primary-fixed` / `#d8e2ff` tonu). Seçili olmayan kart nötr kalır. Geçiş
animasyonlu. Seçim radio mantığı: tek seçim, mutlaka biri seçili.

> Not: Stitch'te Öğretmen ikonu `co_present`. Welcome ekranında Eğitmen ikonu `account_balance` ve
> renk `tertiary`. Tutarlılık için **rol = tertiary yeşil ailesi** korunur; ikon farkı kabul edilebilir
> (register kartında `co_present` daha uygun). Sapma değil, ekran-içi tercih.

### 3.4 Input alanları (`space-y = md`)
Her alan: üstte görünür label **label-lg** (Inter 14/600) renk `on-surface-variant` (`ml-1`),
altında input. Input: tam genişlik, zemin `surface-container-lowest` (`#ffffff`), 1px
`outline-variant` kenarlık, `rounded-xl (12px)`, padding `px = md (16px), py = sm (12px)`,
placeholder rengi `outline-variant`, metin `on-surface`.

| Alan | Label | Placeholder | type / autofill |
|---|---|---|---|
| Ad Soyad | "Ad Soyad" | "Alex Rivera" | text / name |
| E-posta | "E-posta Adresi" | "alex@ornek.com" | email / email |
| Şifre | "Şifre Oluştur" | "••••••••" | password / new-password |

> Öneri: Şifre alanına login'deki gibi göster/gizle göz butonu eklenebilir (tutarlılık). Stitch
> register'da yok; eklenmesi UX iyileştirmesi, zorunlu değil.

### 3.5 Koşul onayı (zorunlu)
Checkbox + metin (`gap = xs`, sola hizalı): checkbox `rounded`, seçili renk `primary`, focus ring
`primary`. Metin **label-sm** (Inter 12/500) renk `on-surface-variant`, "Kullanım Koşulları" ve
"Gizlilik Politikası" link kısımları `primary`. **Buton bu kutu işaretli değilken pasif** (bkz.
Durumlar).

### 3.6 Hesap Oluştur butonu (primary, 3D)
Tam genişlik, zemin `primary`, metin `on-primary`, tipo **headline-md** (Quicksand 20/600), padding
`py = md`, `rounded-xl`. 3D etki: 4px alt gölge `#004395`, press'te `translateY` + scale `0.98`.

### 3.7 Sosyal divider + butonlar
- Divider: çizgi `outline-variant`, ortada "VEYA ŞUNUNLA KAYIT OL" **label-sm** `on-surface-variant`
  uppercase, dikey margin `my = xl`.
- Google / Apple: 2'li grid `gap = md`, zemin `surface-container-lowest`, 1px `outline-variant`,
  `rounded-xl`, padding `py = sm`, logo + metin **label-lg**.

### 3.8 Alt link
"Zaten bir hesabın var mı? **Giriş Yap**" — **body-md** `on-surface-variant`, link `primary`
semibold → `/login`. Üst boşluk `mt = xl`.

## 4. Bileşen davranışı

- **Rol kartı seçimi:** dokununca o kart seçili (primary kenarlık + tint), diğeri nötre döner.
  Tüm kart tıklanabilir; dokunma hedefi ≥ 48px.
- **Input focus:** focus'ta `primary` kenarlık + 1px `primary` ring (`focus:ring-1`).
- **Input hata:** kenarlık `error`, alan altı **label-sm** `error` mesaj.
- **Buton 3D + disabled:** koşul onayı işaretli değilken buton **disabled** (opacity düşük, press yok).
- **Loading:** submit'te buton içeriği `progress_activity` spinner (animate-spin), buton disabled.

## 5. Durumlar (idle / loading / error / success)

| Durum | Davranış |
|---|---|
| **idle** | Rol = Öğrenci seçili. Koşul kutusu boş → buton disabled. |
| **validation** | Ad Soyad boş, e-posta boş/geçersiz, şifre kısa (min kural), koşul onaysız → ilgili alan/checkbox hatası, submit engellenir. |
| **loading** | Buton disabled + spinner; inputlar disabled. |
| **error** | E-posta zaten kayıtlı (409) → e-posta alanı altı hata "Bu e-posta zaten kullanımda."; ağ/sunucu → buton üstü `error-container` banner. |
| **success** | Hesap oluşturuldu → (PM kararına göre) doğrudan dashboard veya login'e "Hesabın hazır, giriş yap" mesajıyla yönlendirme. |

## 6. Erişilebilirlik

- Rol kartları radio grubu olarak erişilebilir (Flutter `Radio`/`Semantics`, grup etiketi "Rol").
- Tüm input'larda görünür label; hata `errorText` ile ilişkili.
- Checkbox + link metni: linkler ayrı dokunulabilir, geri kalan metin checkbox'ı toggle eder.
- Dokunma hedefleri ≥ 48px.

## 7. Türkçe metinler + i18n anahtarları

| Anahtar | Türkçe metin |
|---|---|
| `auth.register.appbar.login` | Giriş Yap |
| `auth.register.title` | Yolculuğuna Başla |
| `auth.register.subtitle` | Binlerce dil öğrenicisine hemen katıl. |
| `auth.register.role.student` | Öğrenci |
| `auth.register.role.teacher` | Öğretmen |
| `auth.register.fullName.label` | Ad Soyad |
| `auth.register.fullName.placeholder` | Alex Rivera |
| `auth.register.email.label` | E-posta Adresi |
| `auth.register.email.placeholder` | alex@ornek.com |
| `auth.register.password.label` | Şifre Oluştur |
| `auth.register.password.placeholder` | •••••••• |
| `auth.register.terms.prefix` | Kabul ediyorum: |
| `auth.register.terms.terms` | Kullanım Koşulları |
| `auth.register.terms.and` | ve |
| `auth.register.terms.privacy` | Gizlilik Politikası |
| `auth.register.submit` | Hesap Oluştur |
| `auth.register.dividerOr` | VEYA ŞUNUNLA KAYIT OL |
| `auth.register.haveAccount` | Zaten bir hesabın var mı? |
| `auth.register.loginCta` | Giriş Yap |
| `auth.register.error.emailTaken` | Bu e-posta zaten kullanımda. |
| `auth.validation.fullName.required` | Ad soyad gerekli. |
| `auth.validation.password.tooShort` | Şifre en az 8 karakter olmalı. |
| `auth.validation.terms.required` | Devam etmek için koşulları kabul edin. |

> Not: Stitch'teki onay metni "Kullanım Koşulları ve Gizlilik Politikası'nı kabul ediyorum."
> Türkçe ek-çekim (...'nı) i18n'de tek string olarak değil, link parçalı kurulduğu için anahtarlar
> ayrı tutuldu; mobil dev cümleyi `prefix + link + and + link` sırasıyla birleştirir.

## 8. Açık konular

- **Kayıt sonrası akış:** Otomatik giriş (token döner) mı, login'e yönlendirme mi? API
  `POST /auth/register` davranışına göre belirlenir — PM/API dev ile teyit.
- **Şifre kuralı:** min uzunluk/karmaşıklık API tarafıyla hizalanmalı (validation mesajları buna göre).
- **Sosyal kayıt:** Login ile aynı karar (M1'de gizli/devre dışı önerilir).
