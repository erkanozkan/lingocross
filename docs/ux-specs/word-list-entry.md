# UX Spec — Ders Kelimeleri: Liste + Manuel Ekle/Düzenle (Word List Entry)

> **Stitch'te yok — tasarım sistemine göre tasarlandı.** Bu ekranın (kelime listesi + manuel
> ekle/düzenle formu) doğrudan Stitch karşılığı yoktur. Lumina Learning dilini birebir koruyarak,
> "Kelime Listesi Yükle (OCR)" ve auth form ekranlarının stiliyle uyumlu tasarlandı.
> OCR gözden geçirme akışı ayrı spec'tedir: bkz. `ocr-capture-review.md`.
> Design system: **Lumina Learning** (`docs/DESIGN.md` tek doğruluk kaynağı).
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.

## 1. Amaç & Akış

Bir dersin kelime listesi ekranı. Öğretmen: kelimeleri **listeler**, **manuel ekler/düzenler/siler**,
ve OCR akışına geçer. Her kelime: **terim (kaynak dil, İngilizce)** + bir veya birden çok **Türkçe
karşılık** (biri **primary**) + opsiyonel **eşanlam**.

- Giriş: ders detayı / yeni ders sonrası → `/teacher/lessons/{id}`.
- API:
  - Liste: `GET /lessons/{id}/words`.
  - Ekle: `POST /lessons/{id}/words` (`source` = `Manual` veya `Ocr`).
  - Düzenle: `PUT /lessons/{id}/words/{wordId}`. Sil: `DELETE /lessons/{id}/words/{wordId}`.
- "Kameradan Tara" → OCR akışı (`ocr-capture-review.md`). OCR sonucu bu listeye eklenir.
- "Manuel Ekle" / kart düzenleme → **alt sayfa (bottom-sheet) form** (bkz. 3.4).

## 2. Layout (yukarıdan aşağıya)

| # | Bölüm | Not |
|---|---|---|
| 0 | **TopAppBar** (sticky) | Sol: geri + ders adı. Sağ: avatar/overflow (`more_vert` → dersi düzenle/sil). |
| 1 | **Özet + giriş aksiyonları** | Kelime sayısı + dil yönü chip + iki buton: "Kameradan Tara" + "Manuel Ekle". |
| 2 | **Arama / filtre** (≥ 10 kelime) | Arama input'u; opsiyonel. |
| 3 | **Kelime listesi** | Kelime kartları, `flex-col gap-sm`. |
| 4 | **FAB / sticky ekle** | "Manuel Ekle" FAB (liste uzun olduğunda hep erişilebilir). |

`main`: `pt-24 pb-28 px-margin-mobile`, `flex-col gap-lg`.

## 3. Öğeler (tipografi + renk token'ı)

### 3.1 TopAppBar
- Geri butonu `arrow_back` `primary`, ≥ 48px hedef.
- Başlık: ders adı, **headline-md** (Quicksand 20/600), `primary`, tek satır ellipsis.
- Sağ overflow `more_vert` → menü: "Dersi Düzenle" (→ `lesson-create-edit.md` edit), "Dersi Sil".

### 3.2 Özet + giriş aksiyonları
- Sayı satırı: "{n} kelime" **headline-md** `on-surface` + dil yönü chip
  "EN → TR" (pill, zemin `primary-fixed` `#d8e2ff`, metin `on-primary-fixed` `#001a42`, **label-sm**).
- İki aksiyon (`grid grid-cols-2 gap-md`):
  - **Kameradan Tara (birincil):** zemin `primary`, metin `on-primary`, ikon `camera_alt`,
    **label-lg**, `rounded-xl`, 3D alt gölge. → OCR akışı.
  - **Manuel Ekle (ikincil):** 2px `primary` stroke, metin `primary`, zemin `surface`, ikon `add`,
    `rounded-xl`. → ekle bottom-sheet.

### 3.3 Kelime kartı (liste öğesi)
`flex items-start p-md`, zemin `surface-container-lowest` (`#ffffff`), 1px `outline-variant`,
`rounded-xl`, `custom-shadow` hafif. Yapı:
- **Sol blok (terim):** terim metni **headline-md** (Quicksand 20/600) `on-surface`. Altında küçük
  kaynak rozeti: OCR ise `document_scanner` ikonlu chip "OCR" (zemin `surface-container`, `label-sm`);
  manuel ise rozet yok veya `edit` ikonlu "Manuel".
- **Karşılıklar bloğu:** chip dizisi (`flex-wrap gap-xs`):
  - **Primary karşılık:** dolu chip, zemin `primary-container` (`#2170e4`), metin
    `on-primary-container`, başında `star` (FILL 1) ikonu. **label-lg**.
  - **Diğer karşılıklar:** açık chip, zemin `surface-container`, metin `on-surface-variant`. **label-sm**.
- **Eşanlam (varsa):** ayrı satır, ön ek "eş anlamlı:" **label-sm** `outline` + virgülle ayrık değerler
  `on-surface-variant`.
- **Sağ:** `more_vert` veya satır kaydırınca "Düzenle" (`primary`) / "Sil" (`error`) aksiyonları
  (swipe-to-action). Tek dokunma kartın tamamı → düzenle bottom-sheet.

### 3.4 Manuel Ekle / Düzenle formu (bottom-sheet)
Modal alt sayfa, üstte `rounded-t-xl`, zemin `surface-container-lowest`, tutamaç çubuğu (`outline-variant`).
Başlık "Kelime Ekle" / "Kelimeyi Düzenle" **headline-md** `on-surface`.

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

- Chip primary toggle: tek primary; star tıkı diğerlerinden alır. Primary chip her zaman ilk sırada.
- Düzenle bottom-sheet: kart verisiyle ön-dolu; Kaydet dirty olunca aktif.
- Sil: onay (snackbar-undo tercih edilir) — "Kelime silindi" + "Geri Al" (5sn). Geri al yoksa
  `DELETE` kalıcı.
- Arama: terim + karşılıklarda canlı filtre (debounce 200ms).
- Liste sıralaması: en son eklenen üstte; opsiyonel A→Z toggle.

## 5. Durumlar

| Durum | Görünüm |
|---|---|
| **Yükleniyor** | 4–5 skeleton kelime kartı (shimmer). Aksiyon butonları görünür. |
| **Boş — kelime yok** | Boş durum: ikon `text_fields`/`spellcheck` (`primary`), başlık "Henüz kelime yok" **headline-md**, açıklama "Kameradan tarayın veya elle ekleyin." **body-md** `on-surface-variant`. İki büyük buton: "Kameradan Tara" (primary) + "Manuel Ekle" (stroke). |
| **Form hata** | Alan-bazlı: terim/karşılık eksik → ilgili input `error` kenarlık + metin. |
| **Kaydediliyor** | Sheet Kaydet butonunda spinner + "Kaydediliyor…", alanlar kilitli. |
| **Kaydetme hatası** | Sheet üstünde error banner (`error-container`/`on-error-container`) "Kelime kaydedilemedi, tekrar deneyin." |
| **Başarı (ekle)** | Sheet kapanır (veya "Kaydet ve Yeni Ekle"de sıfırlanır); yeni kart listenin başında 1sn `surface-container-high` flash; snackbar "Kelime eklendi". |
| **Başarı (sil)** | Kart kaybolur + undo snackbar. |

## 6. Erişilebilirlik

- Primary karşılık yalnız renkle değil; `star` ikonu + "birincil karşılık" etiketi.
- Dinamik karşılık satırlarında sil/ekle butonları ≥ 48px; ekran okuyucuya "karşılık {n}, sil" gibi etiket.
- Chip dizisi `aria-label` ile düz metin alternatifi sunar.
- Kaynak rozeti (OCR/Manuel) bilgilendirme amaçlı, dekoratif değil → metin etiketli.

## 7. Veri ↔ UI eşlemesi (API uyumu)

| API alanı | UI |
|---|---|
| `term` | Terim input'u (kaynak dil) |
| `meanings[]` (Türkçe karşılıklar) | Karşılık satırları; `isPrimary` → star toggle |
| `synonyms[]` (opsiyonel) | Eşanlam chip input'u |
| `source` (`Manual` / `Ocr`) | Kaynak rozeti; manuel formdan ekleme = `Manual`, OCR akışı = `Ocr` |

## 8. Türkçe metinler + i18n anahtarları

| Anahtar | TR |
|---|---|
| `words.list.count` | "{count} kelime" |
| `words.list.langDir` | "{source} → {target}" |
| `words.list.scan` | "Kameradan Tara" |
| `words.list.addManual` | "Manuel Ekle" |
| `words.list.sourceOcr` | "OCR" |
| `words.list.sourceManual` | "Manuel" |
| `words.list.synonymPrefix` | "eş anlamlı:" |
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
