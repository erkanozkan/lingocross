# UX Spec — Karşılama + Giriş (birleşik) / Welcome + Login

> Kaynak: Stitch `projects/13138966371134318763/screens/c6188f694eea4fc3966753bd2c3a262c`
> ("Giriş Yap (Marka Güncellenmiş)"). Design system: **Lumina Learning** (`docs/DESIGN.md` tek
> doğruluk kaynağı). Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.
> Bu ekran **linear/transactional** kabuktur: BottomNav yoktur.

## 0. Birleştirme notu (kullanıcı onaylı)

Eski **Karşılama (Welcome)** ve **Giriş (Login)** ekranları **tek ekrana birleştirildi**. Eski
ekranlar kaldırıldı (Welcome: `301bfb07…`, `401622fe…`; Login: `4d9957e6…`) ve eski
`auth-welcome.md` spec'i silindi. Bu doküman birleşik ekranın tek spec'idir.

Birleştirmeyle gelen kararlar:
- Hero (maskot + "Hi!/Merhaba!" rozetleri + hoş geldiniz başlığı) ile giriş formu **aynı ekranda**.
- **Sosyal giriş (Google/Apple) ve "VEYA ŞUNUNLA DEVAM ET" divider GİZLİ** — projede OAuth yok
  (kullanıcı onaylı). Stitch HTML'inde görsel olarak dururlar; üretimde render edilmezler.
- Redundant sağ-üst **"Giriş Yap" linki kaldırıldı** (zaten giriş ekranındayız).
- Footer telif **"© 2026 LingoCross"** (Stitch'teki "© 2024 Lumina Learning A.Ş." değil).
- Rol **bu ekranda seçilmez**; giriş rolsüzdür, yönlendirme yanıttaki `user.role`'a göre yapılır.
  Rol seçimi **kayıt** ekranında kalır (değişmedi).

## 1. Amaç & Akış

İlk açılış + e-posta/şifre ile giriş aynı ekranda. **Ekran tamamen rolsüzdür**: rol seçimi/göstergesi,
roleHint veya rola bağlı UI yoktur. Kullanıcı e-posta + şifre girer; rol login yanıtındaki `user.role`
alanından gelir ve uygulama doğru home'a yönlendirir.

- API: `POST /auth/login` (body: email, password) → access + refresh token + `user.role`
  (bkz. `CLAUDE.md` JWT).
- Başarı → token'lar `flutter_secure_storage`'a kaydedilir; ardından `redirect`, **yanıttaki
  `user.role`'a göre**: öğretmen → öğretmen paneli, öğrenci → öğrenci paneli (go_router guard).
- "Şifremi Unuttum?" → `/forgot-password`.
- "Hesabın yok mu? **Ücretsiz kayıt ol**" → `/register` (rol register'da seçilir).

> **Karar notu (PM + kullanıcı onaylı):** Rol HESAP OLUŞTUR'da belirlenir; GİRİŞ rolsüzdür. Login'de
> rol göstermek gereksiz ve yanıltıcıdır — kimliğin rolü zaten sunucu tarafında kayıtlıdır ve login
> yanıtındaki `user.role` ile gelir. Bu yüzden login formu tek/sade kalır, yönlendirme tamamen yanıta
> dayanır, kayıttan rol bağlamı (`?role=`) **taşınmaz**.

## 2. Layout (yukarıdan aşağıya)

İçerik dikeyde ortalanır, tek kolon, `max-width: md (28rem / 440px)`, yatay padding 20px. Arka plan
düz `surface` (`#f8f9ff`) + dekoratif iki yumuşak blur daire (pointer-events yok).

| # | Bölüm | İçerik | Alt boşluk |
|---|---|---|---|
| 0 | **Üst marka satırı** | Sol: "LingoCross" wordmark. Sağ: ~~"Giriş Yap" linki~~ **KALDIRILDI** (boş bırak / yalnız wordmark ortalanır). Padding `px=20, py=sm(12)`. | — |
| 1 | **Hero / illüstrasyon bloğu** | Maskot dairesi + iki floaty rozet ("Hi!" / "Merhaba!") + başlık + alt metin | `mb = xl (32px)` |
| 2 | **Giriş kartı** | E-posta + Şifre (göster/gizle + Şifremi Unuttum?) + "Giriş Yap" 3D buton. ~~Divider + sosyal~~ **GİZLİ**. | `mb = lg (24px)` |
| 3 | **Kayıt CTA** | "Hesabın yok mu? Ücretsiz kayıt ol" (ortalı) → `/register` | `mb = xl (32px)` |
| 4 | **Footer** | Gizlilik • Kullanım Koşulları + telif "© 2026 LingoCross". `opacity 60%`. | — |

## 3. Öğeler (tipografi + renk token'ı)

### 3.0 Üst marka satırı
- Wordmark "LingoCross": tipo **display-lg-mobile** (Quicksand 28/700), renk `primary` (`#0058be`).
- Sağ-üst "Giriş Yap" linki **render edilmez** (kaldırıldı — zaten giriş ekranı). Alanı boş bırak;
  istenirse yalnız sol wordmark veya ortalanmış wordmark.

### 3.1 Hero / illüstrasyon bloğu
- **Mascot dairesi:** 128×128 (`w-32 h-32`), `rounded-full`, zemin `primary-container` (`#2170e4`),
  içte ~96×96 mascot görseli, `shadow-xl`. (Graduation-cap'li mavi kuş mascot.)
- **Floaty rozet 1 ("Hi!"):** sağ-üst, zemin `secondary-container` (`#fea619`), metin `on-secondary`
  (`#ffffff`), tipo **headline-md** (Quicksand 20/600), `rounded-xl`, +12° döndürme.
- **Floaty rozet 2 ("Merhaba!"):** sol-alt, zemin `tertiary-container` (`#00855b`), metin `on-tertiary`
  (`#ffffff`), tipo **headline-md**, `rounded-xl`, -12° döndürme.
- **Başlık:** "LingoCross'a Hoş Geldiniz" — tipo **display-lg-mobile** (Quicksand 28/700), renk
  `primary` (`#0058be`), ortalı, `mb = xs (8px)`.
- **Alt metin:** "Dil yolculuğuna bugün başla, sınırları ortadan kaldır." — tipo **body-md**
  (Inter 16/400), renk `on-surface-variant` (`#424754`), ortalı.

### 3.2 Giriş kartı
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
- 3D etki: alt gölge `0 4px 0 0 #004395`. Press'te `translateY(2px)` + gölge `0 2px 0 0 #004395`.
- İçerikte metin + `arrow_forward` ikonu, `gap = sm`.

**Sosyal giriş + divider — GİZLİ (render edilmez):**
- ~~Divider "VEYA ŞUNUNLA DEVAM ET"~~ ve ~~Google/Apple butonları~~ üretimde **yer almaz**
  (OAuth kapsam dışı, kullanıcı onaylı). Stitch HTML'inde görsel olarak bulunur; Flutter çıktısında
  bu blok atlanır. İlerideki bir fazda OAuth gelirse bu spec güncellenerek geri eklenir.

### 3.3 Kayıt CTA
"Hesabın yok mu? **Ücretsiz kayıt ol**" — **body-md** (Inter 16/400) `on-surface-variant`; link
kısmı `primary` (bold) → `/register`. Ortalı, üst boşluk `mt = xl`. Press'te alt çizgi.
Dokunma hedefi ≥ 48px. (Rol register'da seçilir — bu ekrandan rol bağlamı taşınmaz.)

### 3.4 Footer
"Gizlilik Politikası" • "Kullanım Koşulları" • "© 2026 LingoCross" — **label-sm**, `opacity 60%`.
Telif Stitch'teki "© 2024 Lumina Learning A.Ş." değil; üretimde **© 2026 LingoCross** (anahtar
`auth.footer.copyright`).

## 4. Bileşen davranışı

- **Input focus:** 2px `primary` ring + `primary` kenarlık; leading ikon `outline-variant` → `primary`.
  Geçiş `transition-all`.
- **Input hata:** kenarlık + ring `error` (`#ba1a1a`); alan altına hata metni **label-sm** `error`.
  Leading ikon `error` rengine döner.
- **Şifre göster/gizle:** göz butonu parola tipini değiştirir, ikon `visibility`↔`visibility_off`.
  Dokunma hedefi ≥ 48px.
- **Giriş butonu 3D:** yukarıdaki press davranışı; loading'te disabled + spinner.
- Hero (mascot, rozetler, blur daireler) **dekoratiftir**; asset yoksa ekran bozulmamalı (graceful
  fallback — daire + ikon ya da sade başlık).

## 5. Durumlar (idle / validation / loading / error / success)

| Durum | Davranış |
|---|---|
| **idle** | Hero + form görünür, buton aktif. Alanlar boşken buton yine basılabilir → submit'te validasyon. |
| **validation** | E-posta boş/geçersiz → alan altı hata; şifre boş → alan altı hata. Submit engellenir. |
| **loading** | Giriş butonu disabled, içerikte `progress_activity` spinner (animate-spin), metin gizli. Inputlar disabled. |
| **error (401/ağ)** | Butonun/kartın üstünde hata banner'ı: zemin `error-container` (`#ffdad6`), metin `on-error-container` (`#93000a`), `rounded-lg`, ikon `error`. Genel mesaj (kimlik bilgisi sızdırma yok). |
| **success** | Token kaydedilir; yanıttaki `user.role`'a göre dashboard'a yönlendirme (UI rol sormaz). |

## 6. Erişilebilirlik

- Tüm input'larda görünür label (üstte). Placeholder label yerine geçmez.
- Göz butonu, kayıt CTA ve şifremi unuttum linki ≥ 48px dokunma hedefi.
- Hata mesajları input ile ilişkilendirilir (Flutter `Semantics` / `errorText`).
- Focus ring kontrastı yeterli (`primary` on `surface-container-low`).
- Mascot/floaty görselleri dekoratif → `excludeSemantics` / boş label.

## 7. Türkçe metinler + i18n anahtarları

| Anahtar | Türkçe metin |
|---|---|
| `auth.login.brand` | LingoCross |
| `auth.login.hero.title` | LingoCross'a Hoş Geldiniz |
| `auth.login.hero.subtitle` | Dil yolculuğuna bugün başla, sınırları ortadan kaldır. |
| `auth.login.badge.hi` | Hi! |
| `auth.login.badge.merhaba` | Merhaba! |
| `auth.login.email.label` | E-posta Adresi |
| `auth.login.email.placeholder` | isim@ornek.com |
| `auth.login.password.label` | Şifre |
| `auth.login.password.placeholder` | •••••••• |
| `auth.login.forgotPassword` | Şifremi Unuttum? |
| `auth.login.submit` | Giriş Yap |
| `auth.login.noAccount` | Hesabın yok mu? |
| `auth.login.signupCta` | Ücretsiz kayıt ol |
| `auth.login.error.invalidCredentials` | E-posta veya şifre hatalı. |
| `auth.login.error.network` | Bağlantı hatası. Lütfen tekrar deneyin. |
| `auth.validation.email.required` | E-posta adresi gerekli. |
| `auth.validation.email.invalid` | Geçerli bir e-posta adresi girin. |
| `auth.validation.password.required` | Şifre gerekli. |
| `auth.footer.privacy` | Gizlilik Politikası |
| `auth.footer.terms` | Kullanım Koşulları |
| `auth.footer.copyright` | © 2026 LingoCross |

> Sosyal giriş anahtarları (`auth.login.dividerOr`, `auth.social.google`, `auth.social.apple`)
> **gizli olduğu için bu MVP'de kullanılmaz**; OAuth ileride gelirse geri eklenir.

## 8. Açık konular

- **Sosyal giriş (Google/Apple):** OAuth kapsam dışı — bu MVP'de **gizli** (kullanıcı onaylı).
  İleride eklenirse divider + butonlar bu spec'e geri alınır.
- **Sağ-üst "Giriş Yap" linki:** kaldırıldı (redundant). Üst satır yalnız wordmark taşır.
- Mascot ve illüstrasyon asseti üretim için ayrıca temin edilmeli (Stitch görselleri placeholder).
