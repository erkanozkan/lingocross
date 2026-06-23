# UX Spec — Ünite Kelime Listesi: Liste + Manuel Ekle/Düzenle (Word List Entry)

> **Kaynak: Stitch ekranı `2ec4360ad6cc4a6395255fa6298905e1` — "Ünite Kelime Listesi"**
> (proje `13138966371134318763`). Bu spec, Stitch HTML'ine **birebir** uyumlandı.
> Önceki "Stitch'te yok / sistemden türetildi" notu **geçersizdir** — kaldırıldı.
> OCR gözden geçirme akışı ayrı spec'tedir: bkz. `ocr-capture-review.md`.
> Design system: **Lumina Learning** (`docs/DESIGN.md` tek doğruluk kaynağı).
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.

## 1. Amaç & Akış

Bir ünitenin/dersin kelime listesi ekranı. Öğretmen: kelimeleri **listeler**, **kameradan tarar**,
**manuel ekler/düzenler/siler**. Her kelime: **terim (kaynak dil, İngilizce)** + bir veya birden
çok **Türkçe karşılık** (biri **primary**) + opsiyonel **eşanlam**.

- Giriş: ders detayı / yeni ders sonrası → `/teacher/lessons/{id}`.
- API:
  - Liste: `GET /lessons/{id}/words`.
  - Ekle: `POST /lessons/{id}/words` (`source` = `Manual` veya `Ocr`).
  - Düzenle: `PUT /lessons/{id}/words/{wordId}`. Sil: `DELETE /lessons/{id}/words/{wordId}`.
- "Kameradan Tara" → OCR akışı (`ocr-capture-review.md`). OCR sonucu bu listeye eklenir.
- "Manuel Ekle" / kart düzenleme → **alt sayfa (bottom-sheet) form** (bkz. 3.5; davranış mevcut, korunur).

## 2. Layout (Stitch yapısı, yukarıdan aşağıya)

`body`: `bg-background text-on-surface min-h-screen pb-32`.
`main`: `px-margin-mobile pt-md space-y-lg`.

| # | Bölüm | Stitch karşılığı |
|---|---|---|
| 0 | **TopAppBar** (sticky) | `sticky top-0 z-50 bg-surface ... px-margin-mobile py-sm h-16`. Sol: geri + ders adı. Sağ: overflow `more_vert`. |
| 1 | **Özet satırı** | `flex items-center justify-between`: "{n} kelime" (sol) + "EN → TR" pill (sağ). |
| 2 | **Aksiyon satırı** | `flex gap-gutter`: "Kameradan Tara" (dolu primary) + "Manuel Ekle" (outline). |
| 3 | **Kelime listesi** | `section.space-y-md`: kelime kartları. |

> **Sapma (gerekçe): derin ekran, global alt nav gösterilmez.** Stitch HTML'inde sayfa altında
> sabit bir global `BottomNavBar` (Home / Reports / Profile) bulunur. LingoCross'ta bu ekran
> derin bir ekrandır (ders → kelime listesi); shell kuralı gereği derin ekranlarda global alt
> navigasyon **gösterilmez** — geri navigasyonu AppBar'daki `arrow_back` üstünden yapılır.
> Stitch'in kendi HTML yorumu da bunu kabul eder ("logic says suppress"). `pb-32` boşluğu da bu
> doğrultuda gerekmez; alt güvenli alan kadar (`pb-md`) padding yeterlidir.

## 3. Öğeler (Stitch sınıfları + tipografi + renk token'ı)

### 3.1 TopAppBar
- Kapsayıcı: `sticky top-0 z-50 bg-surface flex justify-between items-center px-margin-mobile py-sm h-16`.
- Sol grup (`flex items-center gap-4`):
  - Geri butonu: `material-symbols-outlined text-primary`, ikon `arrow_back`, `active:scale-95`. ≥ 48px hedef.
  - Başlık: ders adı, **headline-md** (Quicksand 20/600), `text-primary`, tek satır **ellipsis**
    (Stitch: "Ünite 1 - Temel Kelimeler").
- Sağ: overflow butonu `material-symbols-outlined text-on-surface-variant`, ikon `more_vert`,
  `active:scale-95` → menü: "Dersi Düzenle" (→ `lesson-create-edit.md` edit), "Dersi Sil".

### 3.2 Özet satırı
`section.flex items-center justify-between`.
- **Sayı (sol):** `flex items-center gap-2`:
  - Sayı "{n}" — **headline-md** `text-on-surface` (Stitch: "2").
  - "kelime" — **body-md** `text-on-surface-variant`.
- **Dil yönü pill (sağ):** `bg-surface-container-high px-3 py-1 rounded-full border border-outline-variant`;
  metin "EN → TR" **label-sm** `text-primary tracking-wider`.
  > **Sapma (gerekçe): önceki spec'teki pill stili Stitch'e uyarlandı.** Eski spec pill zeminini
  > `primary-fixed` (`#d8e2ff`) + metin `on-primary-fixed` öneriyordu. Stitch gerçek tasarımı açık
  > mavi tonlu `surface-container-high` (`#dce9ff`) zemin + `primary` metin + `outline-variant`
  > kenarlık kullanır. Stitch esas alındı.

### 3.3 Aksiyon satırı
`section.flex gap-gutter` — iki buton yan yana, `flex-1` ile eşit genişlik. Her ikisi `py-3 rounded-xl font-label-lg`.
- **Kameradan Tara (birincil, dolu):** `btn-3d flex-1 bg-primary text-on-primary flex items-center
  justify-center gap-2`; ikon `material-symbols-outlined text-xl` `photo_camera`; metin "Kameradan Tara".
  3D alt gölge: `box-shadow: 0 4px 0 0 rgba(0,67,149,0.5)`, `:active` → `translateY(2px)` + gölge küçülür. → OCR akışı.
  > **Sapma (gerekçe): kamera ikonu adı.** Önceki spec `camera_alt` diyordu; Stitch `photo_camera`
  > kullanır. Stitch esas alındı.
- **Manuel Ekle (ikincil, outline):** `btn-3d-secondary flex-1 bg-surface-container-lowest text-primary
  border border-outline-variant flex items-center justify-center gap-2`; ikon `add` (`text-xl`);
  metin "Manuel Ekle". Yumuşak 3D gölge: `0 4px 0 0 rgba(114,119,133,0.2)`, `:active` benzer. → ekle bottom-sheet.
  > **Sapma (gerekçe): outline rengi.** Önceki spec "2px `primary` stroke" diyordu; Stitch 1px
  > `outline-variant` kenarlık + `surface-container-lowest` (beyaz) zemin + `primary` metin
  > kullanır (görev metnindeki "outline" tanımıyla uyumlu). Stitch esas alındı.

### 3.4 Kelime kartı (liste öğesi)
`div.word-card bg-surface-container-lowest border border-outline-variant rounded-xl p-md relative overflow-hidden`.
Gölge: `box-shadow: 0 4px 12px rgba(59,130,246,0.08)` (mavi tonlu, Lumina Level 2); `:active` → `scale(0.98)`.
Kartlar arası `space-y-md` (16px).

**Üst satır** (`flex justify-between items-start mb-sm`):
- **Sol (`flex items-center gap-2`):**
  - **Terim:** `h3.font-headline-md text-on-surface` (Quicksand 20/600). Örn. "apple", "book".
  - **Kaynak rozeti** (terimin yanında):
    - **OCR:** `bg-surface-container-low px-2 py-0.5 rounded text-[10px] font-bold text-outline uppercase
      flex items-center gap-1 border border-outline-variant` + ikon `document_scanner` (`text-[12px]`) + metin "OCR".
      Nötr/açık rozet.
      > **Sapma (gerekçe): OCR rozet ikonu.** Görev metni makas/`content_cut` öneriyordu; gerçek
      > Stitch HTML `document_scanner` ikonunu kullanıyor. Stitch (source of truth) esas alındı.
    - **MANUEL:** `bg-secondary-fixed text-on-secondary-fixed-variant px-2 py-0.5 rounded text-[10px]
      font-bold uppercase flex items-center gap-1 border border-secondary-container` + ikon `edit`
      (`text-[12px]`) + metin "Manuel". Amber/secondary rozet (`secondary-fixed` `#ffddb8` zemin,
      `on-secondary-fixed-variant` `#653e00` metin, `secondary-container` `#fea619` kenarlık).
- **Sağ (sil):** `button.text-error active:scale-90 transition-transform p-1` + ikon `delete`
  (`material-symbols-outlined`). **Kırmızı çöp ikonu** sağ üstte. Dokunma → sil (bkz. 4. davranış).

**Karşılıklar bloğu** (`flex flex-wrap gap-2`; eşanlam varsa `mb-md`):
- **Primary karşılık (yıldızlı chip):** `bg-primary-container text-on-primary-container px-3 py-1
  rounded-full font-label-lg flex items-center gap-1.5` + başında dolu yıldız:
  `material-symbols-outlined text-[16px]` ikon `star`, `font-variation-settings: 'FILL' 1`.
  Örn. "⭐ elma", "⭐ kitap".
- **Diğer karşılıklar (nötr chip):** `bg-surface-container text-on-surface-variant px-3 py-1
  rounded-full font-label-lg`. Yıldız yok. Örn. "defter".

**Eşanlam (varsa):** ayrı `p` satırı, üstte ince ayraç: `text-on-surface-variant font-body-md italic
border-t border-outline-variant/30 pt-sm`. İçinde ön ek `span.text-outline font-medium` "eş anlamlı:"
+ değer(ler) (italik). Örn. "eş anlamlı: tome".

### 3.5 Manuel Ekle / Düzenle formu (bottom-sheet — mevcut davranış, korunur)
Stitch bu ekranda formu göstermez (liste görünümü); ekle/düzenle akışı **mevcut bottom-sheet**
davranışıyla korunur. Modal alt sayfa, üstte `rounded-t-xl`, zemin `surface-container-lowest`,
tutamaç çubuğu (`outline-variant`). Başlık "Kelime Ekle" / "Kelimeyi Düzenle" **headline-md** `on-surface`.

- **Terim (zorunlu):** label "Terim ({kaynak dil})" **label-lg** `on-surface-variant`. Input stili
  standart (zemin `#ffffff`, 1px `outline-variant`, `rounded-xl`, 16px padding, focus `primary`).
  Placeholder "Örn. environment". Boşsa hata "Terim gerekli".
- **Türkçe karşılıklar (zorunlu, ≥ 1):** dinamik liste. Her satır:
  - Karşılık input'u (`çevre`, `ortam`…) + sağda **primary işareti** (radio/`star` toggle) + sil ikonu (`error`).
  - İlk karşılık varsayılan **primary**; başka satırın star'ına basınca primary oraya taşınır
    (tek primary garanti). Primary satır silinemez ta ki başka primary atanana dek.
  - "+ Karşılık Ekle" linki (**label-lg** `primary`, ikon `add`) yeni satır ekler.
  - En az 1 karşılık zorunlu; hata "En az bir Türkçe karşılık girin".
- **Eşanlam (opsiyonel):** label "Eş anlamlılar (isteğe bağlı)". Etiket (tag/chip) input'u:
  yazıp Enter/virgül → chip. Chip silinebilir (`close`). Açıklama **label-sm** `on-surface-variant`:
  "Aynı anlama gelen başka terimler. Oyunda ipucu olarak kullanılır."
- **Aksiyonlar (sticky alt):** "Kaydet" (primary 3D, tam genişlik) + "İptal" (ghost). Ekle modunda
  ikincil "Kaydet ve Yeni Ekle" → form sıfırlanır, sheet açık kalır (hızlı toplu giriş).

## 4. Bileşen davranışı

- **Sil (kart):** Stitch'te `delete` butonu kartı `opacity 0.5` + `translateX(20px)` ile soldurup
  300ms sonra gizler. Üretimde onay + **snackbar-undo** tercih edilir — "Kelime silindi" + "Geri Al" (5sn);
  geri al yoksa `DELETE` kalıcı. Görsel kaybolma animasyonu Stitch'le aynı.
- **Kart dokunma:** kart `:active` → `scale(0.98)`. Tek dokunma kartın tamamı → düzenle bottom-sheet
  (kart verisiyle ön-dolu; Kaydet dirty olunca aktif).
- **Chip primary toggle (form):** tek primary; star tıkı diğerlerinden alır. Primary chip her zaman ilk sırada.
- **Liste sıralaması:** en son eklenen üstte; opsiyonel A→Z toggle.

## 5. Durumlar

| Durum | Görünüm |
|---|---|
| **Yükleniyor** | 4–5 skeleton kelime kartı (shimmer), kart şekli (`word-card`) korunur. Özet satırı + aksiyon butonları görünür. |
| **Boş — kelime yok** | Boş durum: ikon `spellcheck`/`text_fields` (`primary`), başlık "Henüz kelime yok" **headline-md**, açıklama "Kameradan tarayın veya elle ekleyin." **body-md** `on-surface-variant`. Aksiyon satırı (3.3) görünür kalır. |
| **Form hata** | Alan-bazlı: terim/karşılık eksik → ilgili input `error` kenarlık + metin. |
| **Kaydediliyor** | Sheet Kaydet butonunda spinner + "Kaydediliyor…", alanlar kilitli. |
| **Kaydetme hatası** | Sheet üstünde error banner (`error-container`/`on-error-container`) "Kelime kaydedilemedi, tekrar deneyin." |
| **Başarı (ekle)** | Sheet kapanır (veya "Kaydet ve Yeni Ekle"de sıfırlanır); yeni kart listenin başında 1sn `surface-container-high` flash; snackbar "Kelime eklendi". |
| **Başarı (sil)** | Kart soldurma animasyonu + undo snackbar. |

## 6. Erişilebilirlik

- Primary karşılık yalnız renkle değil; dolu `star` ikonu + "birincil karşılık" etiketi taşır.
- Sil butonu (`delete`) ≥ 48px dokunma hedefi; ekran okuyucuya "{terim} kelimesini sil" etiketi.
- Kaynak rozeti (OCR/Manuel) bilgilendirme amaçlı, dekoratif değil → metin etiketli ("OCR" / "Manuel").
- Geri / overflow butonları ≥ 48px; dil yönü pill metni ("EN → TR") yeterli kontrast (`primary` üstü açık zemin).
- Chip dizisi `aria-label` ile düz metin alternatifi sunar.

## 7. Veri ↔ UI eşlemesi (API uyumu)

| API alanı | UI |
|---|---|
| `term` | Kart başlığı / Terim input'u (kaynak dil) |
| `meanings[]` (Türkçe karşılıklar) | Karşılık chip'leri; `isPrimary` → dolu yıldızlı `primary-container` chip |
| `synonyms[]` (opsiyonel) | "eş anlamlı:" satırı / form eşanlam chip input'u |
| `source` (`Manual` / `Ocr`) | Kaynak rozeti: `Ocr` → "OCR" (nötr, `document_scanner`); `Manual` → "Manuel" (amber, `edit`) |

## 8. Türkçe metinler + i18n anahtarları

| Anahtar | TR |
|---|---|
| `words.list.count` | "{count} kelime" |
| `words.list.langDir` | "EN → TR" |
| `words.list.scan` | "Kameradan Tara" |
| `words.list.addManual` | "Manuel Ekle" |
| `words.list.sourceOcr` | "OCR" |
| `words.list.sourceManual` | "Manuel" |
| `words.list.synonymPrefix` | "eş anlamlı:" |
| `words.list.deleteLabel` | "{term} kelimesini sil" |
| `words.list.empty.title` | "Henüz kelime yok" |
| `words.list.empty.desc` | "Kameradan tarayın veya elle ekleyin." |
| `words.list.deleted` | "Kelime silindi" |
| `common.undo` | "Geri Al" |
| `words.form.titleAdd` | "Kelime Ekle" |
| `words.form.titleEdit` | "Kelimeyi Düzenle" |
| `words.form.term.label` | "Terim ({sourceLang})" |
| `words.form.term.placeholder` | "Örn. environment" |
| `words.form.term.required` | "Terim gerekli" |
| `words.form.meaning.label` | "Türkçe Karşılık(lar)" |
| `words.form.meaning.placeholder` | "Örn. çevre" |
| `words.form.meaning.addMore` | "Karşılık Ekle" |
| `words.form.meaning.required` | "En az bir Türkçe karşılık girin" |
| `words.form.meaning.primaryLabel` | "Birincil karşılık" |
| `words.form.synonyms.label` | "Eş anlamlılar (isteğe bağlı)" |
| `words.form.synonyms.hint` | "Aynı anlama gelen başka terimler. Oyunda ipucu olarak kullanılır." |
| `words.form.save` | "Kaydet" |
| `words.form.saveAndNew` | "Kaydet ve Yeni Ekle" |
| `words.form.cancel` | "İptal" |
| `words.form.saving` | "Kaydediliyor…" |
| `words.form.error` | "Kelime kaydedilemedi, tekrar deneyin." |
| `words.form.addedSnack` | "Kelime eklendi" |
