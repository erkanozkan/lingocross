# AGENTS.md

Bu proje için ajan/araç bağlamı **`CLAUDE.md`** dosyasında tutulur ve tasarımın tek doğruluk
kaynağı **`docs/DESIGN.md`** dosyasıdır. Lütfen işe başlamadan önce her ikisini de okuyun.

Özet kurallar:
- Kapsam: MVP. **Crossword, Çıkmış Sorular, Soru Çözüm Ekranı = Faz 2, dokunma.**
- **OCR MVP'dedir** (cihaz-içi ML Kit, kameradan); manuel giriş/düzenleme de var.
- Backend: .NET 10, 4 katman, EF Core + Postgres, JWT (BCrypt), NuGet yalnız nuget.org.
- Mobil: Flutter, **Riverpod 2.x**, go_router, Dio, freezed; i18n `tr`.
- UI, `docs/DESIGN.md` token'ları + Stitch ekranları dışına çıkamaz (UX Designer onayı şart).
- Git: feature branch + conventional commits; push yalnız kullanıcı isteyince.

Ayrıntı, çalıştırma komutları ve ekip iş akışı için → `CLAUDE.md`.
