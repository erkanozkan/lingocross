# UX Spec — Giriş Yap (Login)

> Kaynak: Stitch `projects/13138966371134318763/screens/4d9957e6df9745db8ddf21e61b6e3737`
> Design system: **Lumina Learning** (`docs/DESIGN.md` tek doğruluk kaynağı).
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.

## 1. Amaç & Akış

E-posta + şifre ile giriş. **Bu ekran tamamen rolsüzdür**: rol seçimi/göstergesi, roleHint veya rola
bağlı herhangi bir UI yoktur. Kullanıcı yalnız e-posta + şifre girer. Rol, login yanıtındaki
`user.role` alanından gelir ve uygulama bu role göre doğru home'a yönlendirir. Welcome ekranından
buraya **rolsüz** `/login` ile gelinir (query param taşınmaz).

- API: `POST /auth/login` (body: email, password) → access + refresh token + `user.role`
  (bkz. `CLAUDE.md` JWT).
- Başarı → token'lar `flutter_secure_storage`'a kaydedilir; ardından `redirect`, **yanıttaki
  `user.role`'a göre**: öğretmen → öğretmen paneli, öğrenci → öğrenci paneli (go_router guard).
- "Şifremi Unuttum?" → `/forgot-password`. "Ücretsiz kayıt ol" → `/register` (rol register'da seçilir).

> **Karar notu (PM + kullanıcı onaylı):** Rol HESAP OLUŞTUR'da belirlenir; GİRİŞ rolsüzdür. Login'de
> rol göstermek gereksiz ve yanıltıcıdır — kimliğin rolü zaten sunucu tarafında kayıtlıdır ve login
> yanıtındaki `user.role` ile gelir. Bu yüzden welcome'dan rol bağlamı (`?role=`) **taşınmaz**, login
> formu tek/sade kalır ve yönlendirme tamamen yanıta dayanır.

## 2. Layout (yukarıdan aşağıya)

| # | Bölüm | Not |
|---|---|---|
| 0 | **TopAppBar** (sticky) | Sol: `language` ikonu (FILL 1, `primary`) + "Lumina" wordmark. Sağ: "Yardım" metin butonu. Padding `px=20, py=sm(12)`. Zemin `background`. |
| 1 | **Başlık bloğu** (ortalı) | "Tekrar Hoş Geldin" + alt metin. `mb = xl (32px)`. |
| 2 | **Login kartı** | Beyaz kart (glass), form + divider + sosyal + kayıt CTA. Padding `lg (24px)`. |
| 3 | **Footer** | Gizlilik • Kullanım + telif. `opacity 60%`. |

İçerik dikeyde ortalanır, `max-width: md (28rem)`, yatay padding 20px. Arka planda iki yumuşak blur
daire (dekoratif, pointer-events yok).

## 3. Öğeler (tipografi + renk token'ı)

### 3.1 TopAppBar
- Wordmark "Lumina": tipo **display-lg-mobile** (Quicksand 28/700), renk `primary` (`#0058be`).
- `language` ikonu: `primary`, FILL 1, 30px (`text-3xl`).
- "Yardım": tipo **label-lg** (Inter 14/600), renk `on-surface-variant`, hover `primary`.

### 3.2 Başlık bloğu
- "Tekrar Hoş Geldin": tipo **display-lg-mobile** (Quicksand 28/700), renk `on-surface` (`#0b1c30`),
  `mb = xs (8px)`.
- "LingoCross ile yolculuğuna devam et": tipo **body-md** (Inter 16/400), renk `on-surface-variant`.

### 3.3 Login kartı
Zemin `surface-container-lowest` (`#ffffff`) + glass blur, 1px `outline-variant` kenarlık,
`rounded-xl (12px)`, Level-2 gölge `0 4px 12px rgba(59,130,246,0.08)`, padding `lg (24px)`.
Form alanları arası `space-y = md (16px)`.

**E-posta alanı:**
- Label "E-posta Adresi": **label-lg** (Inter 14/600), renk `on-surface-variant`, sol `ml-1`.
- Input: tam genişlik, zemin `surface-container-low` (`#eff4ff`), `rounded-lg (8px)`, iç padding
  `py = md (16px)`, sol ikon için `pl-xl`. Sol leading ikon `mail`: `outline-variant`, focus'ta
  `primary`. Placeholder "isim@ornek.com" renk `outline`. Metin `on-surface`. `type=email`,
  klavye email, autofill `username/email`.

**Şifre alanı:**
- Üst satır: Label "Şifre" (**label-lg**, `on-surface-variant`) solda; sağda "Şifremi Unuttum?"
  link **label-sm** (Inter 12/500), renk `primary` → `/forgot-password`.
- Input: e-posta ile aynı stil. Sol leading ikon `lock`. Placeholder "••••••••". Sağda göz
  butonu (`visibility` ↔ `visibility_off`) renk `outline-variant`, parolayı göster/gizle.
  `type=password`, autofill `password`.

**Giriş Yap butonu (primary, 3D):**
- Tam genişlik, zemin `primary` (`#0058be`), metin `on-primary` (`#ffffff`), tipo **headline-md**
  (Quicksand 20/600), padding `py = md (16px)`, `rounded-xl`, üst boşluk `mt = md`.
- 3D etki: alt gölge `0 4px 0 0 #004395` (= `on-primary-fixed-variant`). Press'te `translateY(2px)`
  + gölge `0 2px 0 0 #004395`.
- İçerikte metin + `arrow_forward` ikonu, `gap = sm`.

**Divider:** çizgi `outline-variant`, ortada "VEYA ŞUNUNLA DEVAM ET" — **label-sm**,
`on-surface-variant`. Dikey margin `my = lg (24px)`.

**Sosyal butonlar (2'li grid, `gap = md`):** Google, Apple. 1px `outline-variant` kenarlık,
zemin `surface-container-low`, `rounded-lg`, padding `py = sm`, logo + metin **label-lg**.
Hover zemin `surface-container-high`.

**Kayıt CTA:** "Hesabın yok mu? **Ücretsiz kayıt ol**" — **body-md** `on-surface-variant`, link
kısmı `primary` bold → `/register`. Üst boşluk `mt = xl`.

### 3.4 Footer
"Gizlilik Politikası" • "Kullanım Koşulları" • "© 2024 Lumina Learning A.Ş." — **label-sm**,
`opacity 60%`. (Telif metni güncel yıl/şirket adıyla teyit edilmeli — bkz. Açık Konular.)

## 4. Bileşen davranışı

- **Input focus:** focus'ta 2px `primary` ring + `primary` kenarlık; leading ikon `outline-variant`
  → `primary`. Geçiş `transition-all`.
- **Input hata:** kenarlık + ring `error` (`#ba1a1a`); alanın altına hata metni **label-sm** `error`.
  Leading ikon `error` rengine döner.
- **Şifre göster/gizle:** göz butonu parola tipini değiştirir, ikon `visibility`↔`visibility_off`.
  Dokunma hedefi ≥ 48px.
- **Giriş butonu 3D:** yukarıdaki press davranışı; loading'te disabled + spinner.

## 5. Durumlar (idle / loading / error / success)

| Durum | Davranış |
|---|---|
| **idle** | Form boş/dolu, buton aktif. Alanlar boşken buton yine basılabilir → submit'te validasyon. |
| **validation** | Boş/format hatası: e-posta boş veya geçersiz → alan altı hata; şifre boş → alan altı hata. Submit engellenir. |
| **loading** | Giriş butonu disabled, içerikte `progress_activity` spinner (animate-spin), metin gizli. Inputlar disabled. |
| **error (401/ağ)** | Kartın üstünde / butonun üstünde hata banner'ı: zemin `error-container` (`#ffdad6`), metin `on-error-container` (`#93000a`), `rounded-lg`, ikon `error`. Genel mesaj (kimlik bilgisi sızdırma yok). |
| **success** | Token kaydedilir; yanıttaki `user.role`'a göre dashboard'a yönlendirme (UI rol sormaz). Buton kısa "başarılı" hali opsiyonel. |

## 6. Erişilebilirlik

- Tüm input'larda görünür label (üstte). Placeholder label yerine geçmez.
- Göz butonu ve sosyal butonlar ≥ 48px dokunma hedefi.
- Hata mesajları input ile ilişkilendirilir (Flutter `Semantics` / `errorText`).
- Focus ring kontrastı yeterli (`primary` on `surface-container-low`).

## 7. Türkçe metinler + i18n anahtarları

| Anahtar | Türkçe metin |
|---|---|
| `auth.login.appbar.help` | Yardım |
| `auth.login.title` | Tekrar Hoş Geldin |
| `auth.login.subtitle` | LingoCross ile yolculuğuna devam et |
| `auth.login.email.label` | E-posta Adresi |
| `auth.login.email.placeholder` | isim@ornek.com |
| `auth.login.password.label` | Şifre |
| `auth.login.password.placeholder` | •••••••• |
| `auth.login.forgotPassword` | Şifremi Unuttum? |
| `auth.login.submit` | Giriş Yap |
| `auth.login.dividerOr` | VEYA ŞUNUNLA DEVAM ET |
| `auth.login.noAccount` | Hesabın yok mu? |
| `auth.login.signupCta` | Ücretsiz kayıt ol |
| `auth.login.error.invalidCredentials` | E-posta veya şifre hatalı. |
| `auth.login.error.network` | Bağlantı hatası. Lütfen tekrar deneyin. |
| `auth.validation.email.required` | E-posta adresi gerekli. |
| `auth.validation.email.invalid` | Geçerli bir e-posta adresi girin. |
| `auth.validation.password.required` | Şifre gerekli. |
| `auth.social.google` | Google |
| `auth.social.apple` | Apple |
| `auth.footer.privacy` | Gizlilik Politikası |
| `auth.footer.terms` | Kullanım Koşulları |
| `auth.footer.copyright` | © 2026 LingoCross |

## 8. Açık konular

- **Sosyal giriş:** MVP'de kendi JWT auth'umuz var; OAuth belirtilmemiş. Öneri: butonları
  M1'de devre dışı/gizli tut. Karar PM'e.
- **Footer telifi:** Stitch'te "© 2024 Lumina Learning A.Ş." yazıyor; ürün adı **LingoCross**.
  Üretimde `© 2026 LingoCross` önerilir (anahtar `auth.footer.copyright`). PM teyidi.
