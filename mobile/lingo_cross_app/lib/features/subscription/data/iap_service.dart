import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../domain/iap_products.dart';
import 'iap_client.dart';
import 'subscription_repository.dart';

/// Mağaza ürünlerinin yüklenme sonucu.
@immutable
class IapProductsState {
  const IapProductsState({
    this.loading = false,
    this.products = const [],
    this.unavailable = false,
    this.queryError = false,
  });

  /// Ürünler yükleniyor.
  final bool loading;

  /// Mağazadan dönen ürün detayları (fiyat/başlık).
  final List<ProductDetails> products;

  /// Mağaza hiç kullanılamıyor (StoreKit hazır değil / cihaz desteklemiyor).
  final bool unavailable;

  /// Ürün sorgusu hata döndürdü / hiç ürün bulunamadı.
  final bool queryError;

  ProductDetails? byId(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  IapProductsState copyWith({
    bool? loading,
    List<ProductDetails>? products,
    bool? unavailable,
    bool? queryError,
  }) {
    return IapProductsState(
      loading: loading ?? this.loading,
      products: products ?? this.products,
      unavailable: unavailable ?? this.unavailable,
      queryError: queryError ?? this.queryError,
    );
  }
}

/// Bir satın alma/geri yükleme akışının sonucu (paywall'a bildirilir).
enum IapPurchaseOutcome {
  /// Satın alma akışı sürüyor (mağaza onay penceresi / pending).
  pending,

  /// Backend doğrulaması başarılı → premium açıldı.
  success,

  /// Kullanıcı iptal etti.
  canceled,

  /// Satın alma veya doğrulama hatası.
  error,
}

/// Satın alma akışı boyunca paywall'a iletilen olay.
@immutable
class IapPurchaseEvent {
  const IapPurchaseEvent(this.outcome);

  final IapPurchaseOutcome outcome;
}

/// StoreKit satın alma akışını yöneten servis (S3).
///
/// Sorumluluklar:
/// - `purchaseStream`'i dinler; `purchased`/`restored` → makbuzu backend ile
///   doğrular (`verifyApple`) → başarıda entitlement tazeler → her durumda
///   `completePurchase` çağırır (yoksa işlem kuyruğa takılı kalır).
/// - Ürün detaylarını ([loadProducts]) ve satın alma/geri yükleme akışlarını
///   ([buy]/[restore]) yönetir.
/// - Akış olaylarını [purchaseEvents] stream'i ile yayınlar (paywall dinler).
///
/// `InAppPurchase` doğrudan test edilemediğinden mağaza erişimi
/// [IapClient] arkasına alınmıştır.
class IapService {
  IapService({
    required IapClient client,
    required SubscriptionRepository repository,
    required Future<void> Function() onEntitlementVerified,
  })  : _client = client,
        _repository = repository,
        _onEntitlementVerified = onEntitlementVerified;

  final IapClient _client;
  final SubscriptionRepository _repository;
  final Future<void> Function() _onEntitlementVerified;

  StreamSubscription<List<PurchaseDetails>>? _sub;

  final StreamController<IapProductsState> _productsController =
      StreamController<IapProductsState>.broadcast();
  final StreamController<IapPurchaseEvent> _purchaseController =
      StreamController<IapPurchaseEvent>.broadcast();

  IapProductsState _productsState = const IapProductsState();

  /// Ürün yükleme durumu akışı (ilk değer hemen yayınlanır).
  Stream<IapProductsState> get productsStream => _productsController.stream;

  /// Anlık ürün durumu.
  IapProductsState get productsState => _productsState;

  /// Satın alma/geri yükleme sonuç olayları akışı.
  Stream<IapPurchaseEvent> get purchaseEvents => _purchaseController.stream;

  /// `purchaseStream` aboneliğini başlatır. Bir kez çağrılmalıdır.
  void start() {
    _sub ??= _client.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (Object _) => _emitPurchase(IapPurchaseOutcome.error),
    );
  }

  /// Mağaza kullanılabilirliğini kontrol eder ve ürün detaylarını çeker.
  Future<void> loadProducts() async {
    _setProducts(_productsState.copyWith(
      loading: true,
      unavailable: false,
      queryError: false,
    ));
    final available = await _client.isAvailable();
    if (!available) {
      _setProducts(const IapProductsState(unavailable: true));
      return;
    }
    final response = await _client.queryProductDetails(IapProducts.all);
    if (response.error != null || response.productDetails.isEmpty) {
      _setProducts(IapProductsState(
        products: response.productDetails,
        queryError: true,
      ));
      return;
    }
    _setProducts(IapProductsState(products: response.productDetails));
  }

  /// Verilen ürünü satın alır (abonelik → non-consumable akış). Sonuç
  /// [purchaseEvents]'e düşer.
  Future<void> buy(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);
    await _client.buyNonConsumable(purchaseParam: param);
  }

  /// Geçmiş satın alımları geri yükler; sonuçlar [purchaseStream] üzerinden
  /// doğrulanır.
  Future<void> restore() => _client.restorePurchases();

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      await _handle(purchase);
    }
  }

  Future<void> _handle(PurchaseDetails purchase) async {
    switch (purchase.status) {
      case PurchaseStatus.pending:
        _emitPurchase(IapPurchaseOutcome.pending);
        return;
      case PurchaseStatus.canceled:
        _emitPurchase(IapPurchaseOutcome.canceled);
        await _completeIfNeeded(purchase);
        return;
      case PurchaseStatus.error:
        _emitPurchase(IapPurchaseOutcome.error);
        await _completeIfNeeded(purchase);
        return;
      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        await _verifyAndComplete(purchase);
        return;
    }
  }

  Future<void> _verifyAndComplete(PurchaseDetails purchase) async {
    final receipt = purchase.verificationData.serverVerificationData;
    var verified = false;
    try {
      // Platforma göre doğrulama: iOS Apple makbuzu, Android'de
      // serverVerificationData Google Play satın alma token'ıdır.
      if (Platform.isAndroid) {
        await _repository.verifyGoogle(receipt, purchase.productID);
      } else {
        await _repository.verifyApple(receipt);
      }
      verified = true;
    } catch (_) {
      verified = false;
    }
    // Doğrulama başarısız olsa bile completePurchase çağrılmalı, aksi halde
    // işlem mağaza kuyruğunda takılı kalır ve tekrar gelir.
    await _completeIfNeeded(purchase);
    if (verified) {
      await _onEntitlementVerified();
      _emitPurchase(IapPurchaseOutcome.success);
    } else {
      _emitPurchase(IapPurchaseOutcome.error);
    }
  }

  Future<void> _completeIfNeeded(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await _client.completePurchase(purchase);
    }
  }

  void _setProducts(IapProductsState state) {
    _productsState = state;
    if (!_productsController.isClosed) _productsController.add(state);
  }

  void _emitPurchase(IapPurchaseOutcome outcome) {
    if (!_purchaseController.isClosed) {
      _purchaseController.add(IapPurchaseEvent(outcome));
    }
  }

  /// Stream aboneliğini ve controller'ları kapatır.
  void dispose() {
    _sub?.cancel();
    _sub = null;
    _productsController.close();
    _purchaseController.close();
  }
}
