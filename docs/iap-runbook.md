# LingoCross — Apple IAP (S3) Runbook

Gerçek Apple In-App Purchase ile Premium abonelik. Yaklaşım: **native `in_app_purchase`** (mobil) +
backend **makbuz doğrulama** (`verifyReceipt`). Sunucu-taraflı entitlement (mevcut `Subscription` +
`EntitlementService` + 402 gating) korunur; gerçek satın alma onu besler.

## Ürünler (App Store Connect → Subscriptions)
- Subscription Group: "LingoCross Premium"
- Aylık: **`com.lingocross.premium.monthly`** → Period = Monthly
- Yıllık: **`com.lingocross.premium.yearly`** → Period = Annual
- (Opsiyonel) Yıllıkta 7 gün Introductory Offer (free trial).
> Kodda product ID'ler bu sabitlere bağlı (mobil `IapProducts`, backend `AppleOptions.ProductPeriods`).
> Farklı ID kullanırsan ikisini de güncelle.

## Apple tarafı ön koşullar (kullanıcı)
1. **Paid Apps Agreement** aktif (banka + vergi) — bu olmadan IAP çalışmaz.
2. Yukarıdaki 2 abonelik ürünü (fiyat + TR/EN lokalizasyon).
3. **App-Specific Shared Secret** (Subscriptions sayfası) → Railway env `Apple__SharedSecret`.
4. **Sandbox tester** (Users and Access → Sandbox) — gerçek cihazda test.
5. Xcode: In-App Purchase capability (StoreKit). App ID'de IAP varsayılan açık.

## Backend
- `POST /api/subscription/apple/verify` `{ receiptData }` (Authorize) → `SubscriptionDto`.
  - `IAppleReceiptVerifier` (Infrastructure): `verifyReceipt`'e POST — prod `buy.itunes.apple.com`,
    status **21007** ise sandbox `sandbox.itunes.apple.com`'a düş. `password = Apple:SharedSecret`.
  - `latest_receipt_info`'dan bizim product ID'lere ait en güncel `expires_date_ms` + `original_transaction_id`.
  - `Subscription`: Plan=Premium, Source=AppleIap, Period (product ID'den), ExpiresAt, Status =
    ExpiresAt>now ? Active : Expired, StoreTransactionId = original_transaction_id. Upsert (UserId).
  - `Apple:SharedSecret` yoksa **503** (yapılandırılmamış). Geçersiz makbuz → 400.
- Env: `Apple__SharedSecret` (gizli, Railway). Opsiyonel `Apple__BundleId` (bundle_id doğrulama).
- Stub (`activate`/`cancel`) yalnız dev (`Subscription:StubEnabled`) — değişmez.

## Mobil
- `in_app_purchase` paketi. `IapProducts.monthly/yearly` sabitleri.
- Satın alma akışı: ürünleri çek → satın al → `serverVerificationData` (base64 makbuz) → `apple/verify`
  → başarıda `subscriptionNotifier` tazele → `completePurchase`. Pending/error/cancel ele alınır.
- Paywall: stub yükseltme yerine gerçek satın alma; fiyatlar `ProductDetails`'ten (yer tutucu kalkar).
  **"Satın Alımları Geri Yükle"** butonu (Apple zorunlu) → restore → verify.
- Açılışta/foreground: premium ise mevcut makbuzu yeniden verify ederek expiry tazele.

## Yenileme (v1 kapsam)
- Lazy-expiry (EntitlementService) + açılışta yeniden doğrulama yeterli.
- **App Store Server Notifications V2** (webhook ile otomatik yenileme/iptal) → sonraki iyileştirme.

## Test
- Sandbox tester ile gerçek cihazda: satın al → premium açılır (gating kalkar) → restore çalışır.
- Sandbox aboneliklerinde yenileme hızlandırılmıştır (aylık ~5 dk) — expiry/lazy-expiry doğrula.
- Backend: fake `IAppleReceiptVerifier` ile unit test (Apple'a gerçek istek atılmaz).
