import 'package:in_app_purchase/in_app_purchase.dart';

/// `InAppPurchase` mağaza API'sinin test edilebilir ince soyutlaması.
///
/// Gerçek StoreKit/BillingClient erişimi [StoreKitIapClient] üzerinden yapılır;
/// testlerde sahte bir uygulama enjekte edilebilir. Sadece servisimizin
/// kullandığı yüzeyi açar.
abstract interface class IapClient {
  /// Satın alma olayları akışı (`purchased`/`restored`/`pending`/`error`).
  Stream<List<PurchaseDetails>> get purchaseStream;

  /// Mağaza kullanılabilir mi (StoreKit/BillingClient hazır mı).
  Future<bool> isAvailable();

  /// Verilen ürün kimlikleri için fiyat/başlık detaylarını çeker.
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers);

  /// Abonelik (non-consumable akış) satın alır. Sonuç [purchaseStream]'e düşer.
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam});

  /// İşlemi tamamlar (kuyruğtan düşürür). Çağrılmazsa işlem tekrar gelir.
  Future<void> completePurchase(PurchaseDetails purchase);

  /// Geçmiş satın alımları geri yükler; sonuçlar [purchaseStream]'e düşer.
  Future<void> restorePurchases();
}

/// [IapClient]'in gerçek `InAppPurchase.instance` üzerine kurulu uygulaması.
class StoreKitIapClient implements IapClient {
  StoreKitIapClient([InAppPurchase? iap])
      : _iap = iap ?? InAppPurchase.instance;

  final InAppPurchase _iap;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) =>
      _iap.queryProductDetails(identifiers);

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) =>
      _iap.buyNonConsumable(purchaseParam: purchaseParam);

  @override
  Future<void> completePurchase(PurchaseDetails purchase) =>
      _iap.completePurchase(purchase);

  @override
  Future<void> restorePurchases() => _iap.restorePurchases();
}
