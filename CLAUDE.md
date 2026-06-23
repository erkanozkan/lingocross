# LingoCross — Proje Bağlamı (tüm agent'lar için)

> Bu dosya projenin paylaşılan bağlamıdır. Her agent (PM, UX, API dev, Mobil dev) ve ana oturum
> işe başlamadan önce bunu ve `docs/DESIGN.md`'yi okur.

## Ürün

Dil eğitmenleri (İngilizce/yabancı dil) ile öğrencileri bir araya getiren mobil uygulama.
Öğretmenler ders bazında kelime girer → bu kelimelerden oyunlar üretilir → öğrenci oynar,
sonucunu (süre + başarı) görür ve öğretmeniyle paylaşır → öğretmen ilerlemeyi takip eder.
UI çok dilli olacak şekilde hazırlanır ama **sadece Türkçe** ile başlanır (i18n hazır).

## Kapsam (MVP) — ne VAR, ne YOK

**MVP'de VAR:**
- Auth: giriş, hesap oluşturma (rol: öğretmen/öğrenci), şifremi unuttum
- Öğretmen: ders CRUD, kelime girişi **(OCR kameradan + manuel düzenleme)**, kelime listeleri
- Kelime girişi → **kelime eşleştirme oyunu** (İngilizce ↔ Türkçe)
- Öğrenci: oyun oynama, **oyun sonu raporu** (süre + başarı), sonucu öğretmenle paylaşma
- Enrollment (öğretmen-öğrenci eşleşmesi, invite code)
- Öğretmen takip paneli, profil

**MVP'de YOK (Faz 2):**
- **Crossword** oyunu
- **Çıkmış Sorular Listesi** ve **Soru Çözüm Ekranı**
- Bu ekranlara dokunulmaz; veri modelinde yalnızca ileriye dönük "dikiş" bırakılır.

> ⚠️ **OCR MVP'dedir.** Öğretmen kelimeleri kâğıda yazıp kameradan okutur; cihaz-içi
> Google ML Kit ile metin tanınır, öğretmen gözden geçirip kaydeder. Manuel giriş hem OCR
> sonrası düzenleme hem de doğrudan ekleme için her zaman mevcuttur. Ayrıntı: `docs/DESIGN.md`.

## Teknoloji

- **Backend (`api/`):** .NET 10, ASP.NET Core Web API, EF Core + Npgsql, PostgreSQL.
  4 katman: `Api` / `Application` / `Domain` / `Infrastructure` (+ `tests`). MediatR/CQRS YOK —
  Application servisleri düz injectable sınıflar. EF, Domain'e sızmaz. Paket kaynağı yalnızca
  `nuget.org` (`api/NuGet.config` — kurumsal Nexus bilinçli olarak devre dışı).
- **Mobil (`mobile/lingo_cross_app/`):** Flutter (Dart 3.7 / Flutter 3.29). **Riverpod 2.x**
  (codegen — Dart 3.7 nedeniyle 3.x/4.x kullanılmaz), go_router, Dio, freezed + json_serializable,
  flutter_secure_storage. Feature-first klasörleme. i18n: `.arb`, başlangıçta yalnız `tr`.
- **Auth:** Kendi API'mizde JWT (access ~15dk + refresh ~30g rotasyon), BCrypt.Net-Next.
  ASP.NET Identity YOK.
- **Deploy:** Railway (Docker). API + managed Postgres.

## Tasarım — `docs/DESIGN.md` TEK DOĞRULUK KAYNAĞI

- Design system: **"Lumina Learning"** (Stitch projesi `13138966371134318763`).
- Renk/tipografi/spacing/şekil token'ları ve 13 ekranın envanteri orada.
- **Hiçbir UI bu token'ların ve ekran tasarımlarının dışına çıkamaz.** Sapma gerekiyorsa önce
  UX Designer onayı + `docs/DESIGN.md` güncellemesi. Ekran çekmek: `mcp__stitch__get_screen`.

## Çalıştırma

```bash
# Backend
docker compose up -d postgres
dotnet run --project api/src/LingoCross.Api        # GET /health → {status:"ok"}; /swagger (dev)
dotnet build api/LingoCross.slnx
dotnet test  api/LingoCross.slnx

# EF migration (M1+)
dotnet ef migrations add <Name> --project api/src/LingoCross.Infrastructure --startup-project api/src/LingoCross.Api
dotnet ef database update      --project api/src/LingoCross.Infrastructure --startup-project api/src/LingoCross.Api

# Mobil
cd mobile/lingo_cross_app && flutter pub get && flutter run
dart run build_runner build --delete-conflicting-outputs   # codegen (riverpod/freezed/json)
flutter analyze
```

> Not (ortam): Bu makinede NuGet/pub restore için ağ, sandbox kapalıyken çalışır. Docker daemon'ı
> kullanıcı başlatır. NuGet yalnız nuget.org'a gider.

## Ekip & İş Akışı

Ana oturum = **takım lideri/orchestrator**. Özel agent'lar `.claude/agents/` altında:
`product-manager`, `ux-designer`, `api-developer`, `mobile-developer`.

Akış (her milestone bir artım): PM kabul kriteri yazar → (gerekirse) UX ekran spec'i üretir →
API & Mobil dev paralel uygular → PM + UX review → düzeltme task'ları. Devler DESIGN.md / UX
spec dışına çıkamaz; Faz 2 işine girilmez.

## Git (lokal, geri alınabilirlik)

- Her artım kendi **feature branch**'inde (`feat/m1-auth` gibi), `main`'den açılır.
- Anlamlı, küçük, **conventional-commits** (İngilizce) commit'ler. Review onayında `main`'e merge.
- Push/uzak repo **yalnız kullanıcı isteyince**. Sorun → `git revert`/`reset` veya branch'i at.

## Yol haritası

`M0` ✅ iskelet · `M0.5` ekip · `M1` auth · `M2` ders+kelime (OCR) · `M3` enrollment ·
`M4` eşleştirme oyunu · `M5` sonuç/özet · `M6` öğretmen takip · `M7` cila. Detay: onaylı plan dosyası.
