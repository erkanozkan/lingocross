# UX Spec — Öğretmen Davet Kodu & Öğrenci Listesi (Teacher — Invite Code / Students)

> **Stitch'te YOK.** Bu ekranın Stitch projesinde (`13138966371134318763`) doğrudan karşılığı
> bulunmuyor. Tasarım, **Lumina Learning** design system'ine (`docs/DESIGN.md`) göre üretildi ve
> öğretmen panelindeki ("Öğretmen Paneli", `5d57f8977cfd48728550f4272af72ac7`) **"Öğrenci Gelişimi"**
> kartının açtığı yüzeyle ilişkilidir. Burada yalnız **davet kodu + öğrenci listesi/onay** vardır;
> **detaylı istatistik M6'dır** (bu ekranda yok).
> Cihaz: MOBILE, tasarım 390px. Yatay margin: **20px** (`margin-mobile`). 8pt grid.

## 1. Amaç & Akış

Öğretmenin (a) sınıfının/dersinin **davet kodunu görüntülemesi ve paylaşması**, (b) **katılan
öğrencileri listelemesi**, gerekiyorsa (c) **bekleyen katılım isteklerini onaylaması/reddetmesi**.

- Giriş: Öğretmen panelinde "Öğrenci Gelişimi" kartı veya ders detayında "Öğrenciler" sekmesi →
  `/teacher/students` (veya `/teacher/lessons/{id}/students`). Davet kodu öğretmen/sınıf düzeyinde.
- API (M3): `GET /enrollments/code` (öğretmenin aktif davet kodu) · `POST /enrollments/code/regenerate`
  (yeni kod) · `GET /enrollments/students` (katılan + bekleyen liste) · `POST /enrollments/{id}/accept`
  · `POST /enrollments/{id}/reject`. (Akış otomatik-onaysa "bekleyen" durumu boş kalır.)
- Erişim: yalnız `role == teacher`, sahiplik kontrolü.

> **Kapsam notu:** Bu ekran **liste + davet** odaklı. Öğrenci başına oyun sayısı, doğruluk, süre vb.
> **istatistik M6'dadır** ve burada **gösterilmez** (yalnız ad + durum + katılım tarihi).

## 2. Layout (yukarıdan aşağıya)

| # | Bölüm | Not |
|---|---|---|
| 0 | **TopAppBar** | Sol: `arrow_back` (`primary`). Başlık "Öğrencilerim" (`headline-md`). Sağ: opsiyonel `share` aksiyonu (davet kodunu paylaş). Zemin `surface`. |
| 1 | **Davet kodu kartı** | Büyük bento kart: kod + "Paylaş" + "Yeni Kod". `mb=lg`. |
| 2 | **Bekleyen istekler** (varsa) | Başlık + onay bekleyen öğrenci satırları (Kabul/Reddet). Onay-gerekmiyorsa **gizli**. |
| 3 | **Katılan öğrenciler** | Başlık + sayım + öğrenci satır listesi. |
| 4 | **(BottomNav)** | Panel sekmeleri korunur (Ana Sayfa/Raporlar/Profil). Alt-ekran ise gizlenebilir. |

`main`: `px-margin-mobile pt-lg space-y-lg`, `max-w-2xl mx-auto`.

## 3. Öğeler (tipografi + renk token'ı)

### 3.1 TopAppBar
- `arrow_back` `primary`; başlık "Öğrencilerim" **headline-md** (Quicksand 20/600) `on-surface`.
- Sağ `share` ikonu (`primary`) → sistem paylaş sayfası (kod + davet metni). Dokunma hedefi ≥ 48px.

### 3.2 Davet kodu kartı (bento)
- Kart: zemin `primary-container` (`#2170e4`), metin `on-primary-container`, `rounded-xl`, `p-lg`,
  `custom-shadow` (Y4 Blur12 `rgba(59,130,246,0.08)`), `relative overflow-hidden`. Sağ-üst dekoratif
  `bg-white/5` blur daire (panel bento diliyle tutarlı).
- Üst etiket "DAVET KODU": **label-lg** uppercase `tracking-wider`, `on-primary-container/80`.
- **Kod gösterimi:** büyük, ortalı/sol, **display-lg** (Quicksand 32/700) `tracking-[0.2em]`,
  `on-primary-container` (ör. "K7P2QX"). Yanında **kopyala** ikonu (`content_copy`, `bg-white/20`
  yuvarlak buton).
- Açıklama: "Bu kodu öğrencilerinle paylaş; girince derslerine katılırlar." **body-md**
  `on-primary-container/80`.
- Aksiyon satırı (`flex gap-sm`):
  - **"Paylaş"** birincil: zemin `surface-container-lowest` (beyaz), metin `primary`, **label-lg**,
    `rounded-lg`, ikon `share`. → sistem paylaş.
  - **"Yeni Kod"** ikincil: ghost/stroke `bg-white/10` + `on-primary-container`, ikon `refresh`.
    Basınca onay diyaloğu (eski kod geçersiz olacağı için — bkz. 4).
- (Opsiyonel) **QR kodu:** kartın sağında küçük QR (`qr_code_2`) — öğrenci `student-join-teacher.md`
  ekranında "QR Tara" ile okur. Yer darsa "QR Göster" linkiyle modal'da büyütülür.

### 3.3 Bekleyen istekler (yalnız manuel-onay akışında)
- Başlık "Onay Bekleyenler ({n})": **headline-md** `on-surface`.
- **İstek satırı:** `flex items-center p-md`, zemin `surface-container-low`, 1px `outline-variant`,
  `rounded-xl`.
  - Sol: avatar/baş harf rozeti 40×40 (`surface-container`, `primary` harf).
  - Orta: öğrenci adı **label-lg** `on-surface` + "katılmak istiyor" **label-sm** `on-surface-variant`.
  - Sağ: **Kabul** butonu (zemin `tertiary`, metin `on-tertiary`, `check`) + **Reddet** ikon butonu
    (`on-surface-variant`, `close`). Dokunma hedefi ≥ 48px.
- Onay-gerekmiyorsa (otomatik katılım) bu bölüm **render edilmez**.

### 3.4 Katılan öğrenciler (liste)
- Başlık satırı: "Öğrenciler" **headline-md** + sağda sayım rozeti/chip ("{n} öğrenci",
  pill `bg-primary-fixed` + `on-primary-fixed-variant`, **label-sm**).
- **Öğrenci satırı:** `flex items-center p-md`, zemin `surface-container-low`, 1px `outline-variant`,
  `rounded-xl`, hover `border-primary` (satıra dokunmak M6'da öğrenci raporunu açacak — M3'te pasif/no-op).
  - Sol: avatar/baş harf rozeti 40×40.
  - Orta: öğrenci adı **label-lg** `on-surface` + meta "Katıldı: {tarih}" **label-sm**
    `on-surface-variant`. *(İstatistik M6 → burada yok.)*
  - Sağ: durum chip (varsa) — "Aktif" `tertiary/10`+`tertiary`; veya `more_vert` menü
    (Çıkar/Kaldır). M3'te en az **Çıkar** aksiyonu (onay diyaloğu ile).

## 4. Bileşen davranışı

- **Kopyala:** kod kopyala → snackbar "Kod kopyalandı" + ikon `check`. Haptik (mobil) opsiyonel.
- **Paylaş:** sistem share sheet; paylaşım metni i18n'den ("LingoCross'ta bana katıl. Davet kodu: {code}").
- **Yeni Kod (regenerate):** onay diyaloğu — "Yeni kod oluştursan eski kod çalışmayı durdurur.
  Devam edilsin mi?" → Onay → `POST regenerate`, kart animasyonla yeni kodu gösterir.
- **Kabul/Reddet:** iyimser (optimistic) güncelleme; satır listeden çıkar; hata olursa geri alınır + snackbar.
- **Pull-to-refresh:** kod + listeleri yeniler.

## 5. Durumlar

| Durum | Görünüm |
|---|---|
| **Yükleniyor** | Davet kartı skeleton (kod yerinde shimmer blok); liste 2–3 skeleton satır. |
| **Boş — hiç öğrenci yok** | Liste yerine boş durum: ikon `group` (`primary`), başlık "Henüz öğrencin yok", açıklama "Yukarıdaki davet kodunu öğrencilerinle paylaş." **body-md** `on-surface-variant` + "Paylaş" butonu. |
| **Boş — bekleyen istek yok** | "Onay Bekleyenler" bölümü gizlenir (başlık dahil). |
| **Hata — kod alınamadı** | Davet kartı yerine hata kartı: `cloud_off` (`error`), "Davet kodu yüklenemedi" + "Tekrar Dene". |
| **Hata — liste** | Liste yerine hata kartı + "Tekrar Dene". Davet kartı bağımsız çalışır. |
| **Başarı — kabul edildi** | Snackbar "{öğrenci} eklendi" (`tertiary`/`on-tertiary`); öğrenci katılanlar listesine taşınır (flash). |
| **Başarı — yeni kod** | Snackbar "Yeni davet kodu oluşturuldu"; kod alanı kısa flash. |

## 6. Erişilebilirlik

- Kod metni ekran okuyucu için harf harf okunabilir etiketle (`aria-label` "Davet kodu: K 7 P 2 Q X").
- Kopyala/Paylaş/Yeni Kod butonları ≥ 48px; ikon-only butonlarda `aria-label`.
- Kabul/Reddet renk + ikon + metin birlikte (yalnız renge bağlı değil).
- Durum chip'leri (Aktif/Bekliyor) metinle de ifade edilir.

## 7. Türkçe metinler + i18n anahtarları

| Anahtar | TR |
|---|---|
| `teacher.students.appBarTitle` | "Öğrencilerim" |
| `teacher.students.codeLabel` | "Davet Kodu" |
| `teacher.students.codeDesc` | "Bu kodu öğrencilerinle paylaş; girince derslerine katılırlar." |
| `teacher.students.copy` | "Kopyala" |
| `teacher.students.copied` | "Kod kopyalandı" |
| `teacher.students.share` | "Paylaş" |
| `teacher.students.shareMessage` | "LingoCross'ta bana katıl. Davet kodu: {code}" |
| `teacher.students.regenerate` | "Yeni Kod" |
| `teacher.students.regenerateConfirm` | "Yeni kod oluşturursan eski kod çalışmayı durdurur. Devam edilsin mi?" |
| `teacher.students.regenerated` | "Yeni davet kodu oluşturuldu" |
| `teacher.students.pendingTitle` | "Onay Bekleyenler ({count})" |
| `teacher.students.wantsToJoin` | "katılmak istiyor" |
| `teacher.students.accept` | "Kabul Et" |
| `teacher.students.reject` | "Reddet" |
| `teacher.students.accepted` | "{name} eklendi" |
| `teacher.students.listTitle` | "Öğrenciler" |
| `teacher.students.count` | "{count} öğrenci" |
| `teacher.students.joinedAt` | "Katıldı: {date}" |
| `teacher.students.statusActive` | "Aktif" |
| `teacher.students.remove` | "Çıkar" |
| `teacher.students.removeConfirm` | "{name} dersinden çıkarılsın mı?" |
| `teacher.students.emptyTitle` | "Henüz öğrencin yok" |
| `teacher.students.emptyDesc` | "Yukarıdaki davet kodunu öğrencilerinle paylaş." |
| `teacher.students.errorCode` | "Davet kodu yüklenemedi" |
| `teacher.students.errorList` | "Öğrenciler yüklenemedi" |
| `common.retry` | "Tekrar Dene" |
| `common.cancel` | "Vazgeç" |
| `common.continue` | "Devam Et" |
