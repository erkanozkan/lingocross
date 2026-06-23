# UX Spec — Ders Oluştur / Düzenle (Lesson Create / Edit)

> **Stitch'te yok — tasarım sistemine göre tasarlandı.** Bu ekranın Stitch karşılığı bulunmuyor.
> Lumina Learning dilini (token, tipografi, buton 3D etkisi, input davranışı) birebir koruyarak,
> mevcut auth form ekranları (`auth-register.md`) ve "Kelime Listesi Yükle" stiliyle uyumlu tasarlandı.
> Design system: **Lumina Learning** (`docs/DESIGN.md` tek doğruluk kaynağı).
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.

## 1. Amaç & Akış

Öğretmen yeni bir ders oluşturur veya mevcut dersi düzenler. **Aynı ekran iki moda hizmet eder**
(create / edit) — alanlar ortak, fark başlık + buton metni + ilk veri.

- Create: dashboard → "Yeni Ders Oluştur" → `/teacher/lessons/new`.
- Edit: ders detayı → "Düzenle" → `/teacher/lessons/{id}/edit` (alanlar mevcut veriyle dolu).
- Kaydet → API:
  - Create: `POST /lessons` (body: title, description, sourceLang, targetLang, status).
  - Edit: `PUT /lessons/{id}`.
- Başarı (create): kelime girişine geçiş — `/teacher/lessons/{id}` (bkz. `word-list-entry.md`),
  çünkü yeni ders kelimesiz anlamsızdır.
- Başarı (edit): geri ders detayına döner + snackbar.
- İptal / geri: değişiklik varsa onay diyaloğu (bkz. 4).

**Dil seçimi:** Ürün İngilizce↔Türkçe odaklıdır ama veri modeli çok dilliye hazırdır. M2'de
kaynak dil varsayılan **İngilizce**, hedef dil **Türkçe**; her ikisi seçilebilir görünür ama
varsayılanlarla gelir (öğretmen genelde değiştirmez).

## 2. Layout (yukarıdan aşağıya)

| # | Bölüm | Not |
|---|---|---|
| 0 | **TopAppBar** (sticky) | Sol: geri butonu (`arrow_back`, `primary`) + başlık. Sağ: avatar veya spacer. `px = margin-mobile`, `py = sm`. |
| 1 | **Form** | Alanlar dikey, `flex-col gap-lg`. Bkz. 3.2–3.5. |
| 2 | **Yayın durumu** | Taslak / Yayında segmenti veya switch. |
| 3 | **Sticky alt aksiyon** | Birincil "Kaydet" butonu (3D primary). `fixed bottom-0` üstü güvenli alan. |

`main`: `pt-24 pb-28 px-margin-mobile`, içerik `flex-col gap-lg`.

## 3. Öğeler (tipografi + renk token'ı)

### 3.1 TopAppBar
- Geri butonu: `arrow_back`, renk `primary`, press scale .95, dokunma hedefi ≥ 48px.
- Başlık: create → "Yeni Ders", edit → "Dersi Düzenle". **headline-md** (Quicksand 20/600), `primary`.

### 3.2 Başlık alanı (zorunlu)
- Label "Ders Başlığı": **label-lg** (Inter 14/600), `on-surface-variant`, `mb = xs`, `ml-1`.
- Input: tam genişlik, zemin `surface-container-lowest` (`#ffffff`), 1px `outline-variant`,
  `rounded-xl`, padding 16px. Placeholder "Örn. 9-A İngilizce Ünite 3" renk `outline/50`.
  Focus'ta 1px → `primary` kenarlık. `required`, max 80 karakter, sayaç sağ altta `label-sm`.
- Hata: boşsa "Ders başlığı gerekli", kenarlık `error`, altında `error` metin **label-sm**.

### 3.3 Açıklama alanı (opsiyonel)
- Label "Açıklama (isteğe bağlı)": **label-lg** `on-surface-variant`.
- Textarea: aynı input stili, min 3 satır, `rounded-xl`. Placeholder "Bu ders hakkında kısa bir not…".
  max 280 karakter + sayaç.

### 3.4 Dil seçimi (kaynak / hedef)
İki açılır seçici yan yana (`grid grid-cols-2 gap-md`), aralarında küçük `swap_horiz` ikonu (dekoratif).
- Label "Kaynak Dil" / "Hedef Dil": **label-lg** `on-surface-variant`.
- Seçici: input stili + sağda `expand_more`. Açılınca bottom-sheet dil listesi (bayrak + ad).
  Varsayılan: Kaynak **İngilizce**, Hedef **Türkçe**.
- Seçili dil metni **body-md** `on-surface`. Aynı dil iki tarafta seçilirse hata "Kaynak ve hedef dil
  aynı olamaz".
> M2'de liste kısa (İngilizce, Türkçe). Veri modeli ISO kodu (`en`, `tr`) saklar; UI dilden bağımsız.

### 3.5 Yayın durumu
İki seçenekli segment kontrol (pill grup, `bg-surface-container-low`, `rounded-full`, aktif segment
`bg-primary-container`/`on-primary-container`):
- **Taslak**: yalnız öğretmen görür; öğrenci/oyun erişemez. (Varsayılan — yeni ders.)
- **Yayında**: öğrenciler erişebilir / oyun üretilebilir.
- Altında açıklama **label-sm** `on-surface-variant`: seçime göre değişir
  ("Taslak dersi yalnız siz görürsünüz." / "Yayındaki ders öğrencilerinizle paylaşılır.").
> Kelimesiz bir ders "Yayında" seçilse de uyarı gösterilir: "Önce kelime ekleyin" (bkz. 5).

### 3.6 Sticky alt aksiyon
- **Kaydet butonu (primary, 3D):** tam genişlik, zemin `primary`, metin `on-primary`,
  **headline-md** (Quicksand 20/600), `rounded-xl`, padding 16px. 4px alt gölge `#004395`,
  press'te kayma. Metin: create → "Dersi Oluştur", edit → "Değişiklikleri Kaydet".
  - Geçersiz form → pasif (zemin `outline-variant`, metin `on-surface-variant`, `cursor-not-allowed`).
- Üstte ince ayraç çizgisi `outline-variant`; bar zemini `surface` + üst gölge.

## 4. Bileşen davranışı

- Buton 3D: aktifken alt kenar 4px koyu; basılınca alt kenar kaybolur + 1px aşağı kayma.
- Validasyon: başlık dolu olunca Kaydet aktifleşir (canlı). Diller her zaman geçerli (varsayılanlı).
- Geri / iptal kirli form: "Kaydedilmemiş değişiklikler" onay diyaloğu — "Çık" (`error` metin) /
  "Düzenlemeye Dön" (primary).
- Edit modunda alt barda ikinci, yıkıcı aksiyon: "Dersi Sil" (yalnız edit) → onay diyaloğu
  (`DELETE /lessons/{id}`). Metin `error`, ghost stil.

## 5. Durumlar

| Durum | Görünüm |
|---|---|
| **Boş (create)** | Tüm alanlar boş/varsayılan; Kaydet pasif (başlık boş). Diller İngilizce/Türkçe ön-dolu. |
| **Dolu (edit)** | Alanlar mevcut veriyle; Kaydet pasif kalır ta ki bir alan değişene dek (dirty-check). |
| **Yükleniyor (edit fetch)** | Form yerine 3–4 skeleton alan (shimmer, `surface-container`, `rounded-xl`). |
| **Gönderiliyor** | Kaydet butonunda inline spinner + "Kaydediliyor…", buton pasif, alanlar kilitli. |
| **Hata (kaydetme)** | Üstte error banner: zemin `error-container`, metin `on-error-container`, ikon `error`, "Ders kaydedilemedi, tekrar deneyin." Alan-bazlı hatalar input altında. |
| **Başarı** | create → kelime girişine yönlendir + snackbar "Ders oluşturuldu". edit → ders detayına dön + "Ders güncellendi". Snackbar zemin `tertiary`/`on-tertiary`. |
| **Uyarı (kelimesiz yayın)** | "Yayında" + 0 kelime → kaydet öncesi diyalog: "Bu derste henüz kelime yok. Yine de yayınlansın mı?" — "Yayınla" / "Kelime Ekle". |

## 6. Erişilebilirlik

- Tüm input/label görünür eşleşmeli (label `for`/aria-label). Dokunma hedefi ≥ 48px.
- Segment kontrol seçili durumu yalnız renkle değil; aktif segment kalın metin + `aria-pressed`.
- Hata mesajları renk + metin + ikon (renk-körü güvenli). Sayaçlar ekran okuyucuya gizli (`aria-hidden`).
- Sticky bar içerik üstünü örtmesin: `main` alt padding ≥ bar yüksekliği.

## 7. Türkçe metinler + i18n anahtarları

| Anahtar | TR |
|---|---|
| `lesson.form.titleCreate` | "Yeni Ders" |
| `lesson.form.titleEdit` | "Dersi Düzenle" |
| `lesson.form.field.title.label` | "Ders Başlığı" |
| `lesson.form.field.title.placeholder` | "Örn. 9-A İngilizce Ünite 3" |
| `lesson.form.field.title.required` | "Ders başlığı gerekli" |
| `lesson.form.field.description.label` | "Açıklama (isteğe bağlı)" |
| `lesson.form.field.description.placeholder` | "Bu ders hakkında kısa bir not…" |
| `lesson.form.field.sourceLang.label` | "Kaynak Dil" |
| `lesson.form.field.targetLang.label` | "Hedef Dil" |
| `lesson.form.field.lang.sameError` | "Kaynak ve hedef dil aynı olamaz" |
| `lesson.form.status.label` | "Yayın Durumu" |
| `lesson.form.status.draft` | "Taslak" |
| `lesson.form.status.published` | "Yayında" |
| `lesson.form.status.draftHint` | "Taslak dersi yalnız siz görürsünüz." |
| `lesson.form.status.publishedHint` | "Yayındaki ders öğrencilerinizle paylaşılır." |
| `lesson.form.submitCreate` | "Dersi Oluştur" |
| `lesson.form.submitEdit` | "Değişiklikleri Kaydet" |
| `lesson.form.submitting` | "Kaydediliyor…" |
| `lesson.form.delete` | "Dersi Sil" |
| `lesson.form.deleteConfirm` | "Bu ders ve içindeki tüm kelimeler silinecek. Emin misiniz?" |
| `lesson.form.discardTitle` | "Kaydedilmemiş değişiklikler" |
| `lesson.form.discardConfirm` | "Çık" |
| `lesson.form.discardCancel` | "Düzenlemeye Dön" |
| `lesson.form.error` | "Ders kaydedilemedi, tekrar deneyin." |
| `lesson.form.createdSnack` | "Ders oluşturuldu" |
| `lesson.form.updatedSnack` | "Ders güncellendi" |
| `lesson.form.publishNoWordsTitle` | "Bu derste henüz kelime yok." |
| `lesson.form.publishNoWordsConfirm` | "Yine de yayınlansın mı?" |
| `lesson.form.publishNoWordsAddWords` | "Kelime Ekle" |
