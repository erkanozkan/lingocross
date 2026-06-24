# LingoCross

Dil eğitmenleri ile öğrencileri bir araya getiren mobil uygulama. Öğretmenler ders
bazında kelime girer, bu kelimelerden oyunlar (MVP: kelime eşleştirme) üretilir;
öğrenciler oynar, sonuçlarını öğretmenleriyle paylaşır, öğretmenler ilerlemeyi takip eder.

## Monorepo yapısı

```
lingo-cross/
├── api/      → .NET (ASP.NET Core Web API) + EF Core + PostgreSQL
└── mobile/   → Flutter uygulaması
```

## Teknoloji

| Katman   | Seçim |
|----------|-------|
| Mobil    | Flutter, Riverpod, go_router, Dio, freezed |
| Backend  | .NET 10 (ASP.NET Core), EF Core, Npgsql |
| Veritabanı | PostgreSQL |
| Auth     | Kendi API'mizde JWT (access + refresh), BCrypt |
| Deploy   | Railway (Docker) |

## Geliştirme

### Önkoşullar
- .NET SDK 10
- Flutter SDK 3.29+
- Docker (lokal PostgreSQL için)

### API'yi lokalde çalıştırma

```bash
# 1) PostgreSQL'i ayağa kaldır
docker compose up -d postgres

# 2) (M1+) Migration'ları uygula — ilk migration eklendikten sonra
#    dotnet ef database update --project api/src/LingoCross.Infrastructure --startup-project api/src/LingoCross.Api

# 3) API'yi çalıştır
dotnet run --project api/src/LingoCross.Api
```

Health kontrolü: `GET http://localhost:5xxx/health` → `{ "status": "ok" }`
Swagger (Development): `/swagger`

> Not: NuGet paketleri yalnızca `nuget.org`'dan çekilir (`api/NuGet.config`). Kurumsal
> Nexus kaynağı bu projede bilinçli olarak devre dışıdır.

### Mobil uygulamayı çalıştırma

```bash
cd mobile/lingo_cross_app
flutter pub get
flutter run
```

## Deploy — API + PostgreSQL (Railway)

1. Railway'de **PostgreSQL** servisi oluştur.
2. API servisini bu repo'dan ekle, **Root Directory = `api/`** (multi-stage `Dockerfile` otomatik kullanılır: `sdk:10.0` → `aspnet:10.0`).
3. API servisi **ortam değişkenleri**:
   ```
   ConnectionStrings__Default = Host=${{Postgres.PGHOST}};Port=${{Postgres.PGPORT}};Database=${{Postgres.PGDATABASE}};Username=${{Postgres.PGUSER}};Password=${{Postgres.PGPASSWORD}};SSL Mode=Require;Trust Server Certificate=true
   Jwt__Secret           = <güçlü rastgele ≥32 char>   # üret: openssl rand -base64 48
   Jwt__Issuer           = lingocross
   Jwt__Audience         = lingocross
   Jwt__AccessTokenMinutes = 15
   Jwt__RefreshTokenDays   = 30
   ASPNETCORE_ENVIRONMENT  = Production
   # Email__Host/Port/Username/Password/FromAddress/FromName  (opsiyonel)
   Anthropic__ApiKey       = <anthropic key>   # opsiyonel — OCR AI zenginleştirme için
   Firebase__ServiceAccountJson = <gizli service account JSON>   # opsiyonel — push için
   ```
   > `PORT` Railway tarafından otomatik verilir; `Program.cs` okur. `Email__*` ayarlanmazsa
   > şifre-sıfırlama e-postası gönderilmez (stub log'a yazar) — beta için kabul edilebilir.
   > `Anthropic__ApiKey` ayarlanmazsa `POST /api/ocr/enrich` **503** döner ve mobil istemci
   > yerel (cihaz-içi) ayrıştırmaya düşer; gerçek anahtar **repoya yazılmaz**.
   > `Firebase__ServiceAccountJson` ayarlanmazsa push bildirim gönderimi **devre dışıdır** (no-op,
   > başlangıçta uyarı loglanır); cihaz kaydı/tercih API'leri yine çalışır. Gerçek JSON **repoya yazılmaz**.
4. Migration'lar uygulama başlangıcında otomatik uygulanır (`Database.MigrateAsync()`).
5. **Doğrula:** `https://<railway-domain>/health` → `{ "status": "ok" }`. (Swagger yalnız Development'ta açık.)

## Deploy — Mobil (iOS TestFlight)

> Önce Railway canlı olmalı; mobil build prod API domainine işaret eder.

```bash
cd mobile/lingo_cross_app
flutter pub get
flutter build ipa --release \
  --dart-define=API_BASE_URL=https://lingocross-production.up.railway.app
```
> `API_BASE_URL` yalnızca host'tur; `/api` ön eki kodda eklenir (`AppConfig.apiPrefix`).

- Bundle id: `com.lingocross.lingoCrossApp` · min iOS **15.5** (ML Kit gereği). Görünen ad: **LingoCross**.
- Xcode'da: Apple Developer Team + otomatik signing. App Store Connect'te aynı bundle id ile uygulama kaydı.
- `.ipa`'yı Xcode Organizer / Transporter ile yükle → TestFlight'ta dağıt.
- **Not:** OCR (ML Kit) yalnız gerçek cihazda; ilk build'de `pod install` gerekir.

Ayrıntılı plan/runbook: `.claude/plans/` altındaki plan dosyası, bölüm 7.
