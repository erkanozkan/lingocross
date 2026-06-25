# LingoCross Yönetim Paneli (Admin)

Tek yöneticinin izlediği salt-okur dashboard: kullanıcı büyümesi, etkileşim
(oyun/sonuç), abonelik ve içerik metrikleri. Vite + React + TypeScript, Tailwind v3,
ShadCN tarzı bileşenler, Recharts grafikleri, TanStack Query + axios.

## Lokal Çalıştırma

```bash
cd admin
npm install
cp .env.example .env          # VITE_API_BASE_URL'i ayarla
npm run dev                   # http://localhost:5173
```

Build:

```bash
npm run build                 # tsc + vite → dist/
npm run preview               # dist'i lokal önizle
```

## Ortam Değişkeni

| Değişken            | Açıklama                          | Örnek                                            |
| ------------------- | --------------------------------- | ------------------------------------------------ |
| `VITE_API_BASE_URL` | .NET API kök adresi (Bearer auth) | `https://lingocross-production.up.railway.app`   |

`VITE_*` değişkenleri **build zamanında** gömülür; değişince yeniden build gerekir.

## Auth Akışı

- `/login` → `POST /api/admin/login` `{ email, password }` → `{ token, expiresAt }`.
- Token + son kullanma tarihi `localStorage`'da tutulur.
- Axios request interceptor `Authorization: Bearer <token>` ekler.
- Response interceptor `401` → token temizler ve `/login`'e yönlendirir.
- `ProtectedRoute` token yoksa (veya süresi geçmişse) `/login`'e atar. Çıkış butonu token siler.

## Sayfalar / Sekmeler

`/` (korumalı) altında 5 sekme:

1. **Genel Bakış** — KPI kartları (`/api/admin/overview`).
2. **Kullanıcılar** — kayıt zaman serisi (`timeseries?metric=signups`, 30/90 gün) + aktif öğrenci.
3. **Etkileşim** — `sessions` + `results` zaman serileri, `engagement` oyun türü bar + skor/paylaşım.
4. **Abonelik** — `subscriptions` durum donut, kaynak bar, yeni abonelik çizgisi.
5. **İçerik & Son Aktivite** — içerik KPI'ları + `recent` kullanıcı ve sonuç tabloları.

## Railway Dağıtımı

- **Root Directory:** `admin/`
- **Builder:** Dockerfile (çok aşamalı). Build aşamasında `npm ci && npm run build`,
  çalışma aşamasında `serve -s dist -l ${PORT}`.
- **Env:** `VITE_API_BASE_URL` (build arg olarak da geçirilir; Railway env'i Dockerfile'a
  `ARG`/`ENV` ile aktarılır). Railway `PORT` env'ini otomatik sağlar; `serve` onu okur.
- SPA fallback `serve -s` ile sağlanır (derin route'lar `index.html`'e döner).
