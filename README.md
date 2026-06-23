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

## Deploy (Railway)

1. Railway'de **PostgreSQL** servisi oluştur.
2. API servisini repo'dan ekle, **Root Directory = `api/`** (Dockerfile otomatik kullanılır).
3. Ortam değişkenleri:
   - `ConnectionStrings__Default` (Npgsql formatı, Postgres servis değişkenlerine referansla)
   - `Jwt__Secret`, `Jwt__Issuer`, `Jwt__Audience`, `Jwt__AccessTokenMinutes`, `Jwt__RefreshTokenDays`
   - `Email__*` (SMTP)
   - `ASPNETCORE_ENVIRONMENT=Production`
4. Migration'lar uygulama başlangıcında otomatik uygulanır (`Database.Migrate()`).

Ayrıntılı plan: `../.claude/plans/` altındaki MVP planı.
