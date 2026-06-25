import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lingo_cross_app/features/subscription/data/iap_client.dart';
import 'package:lingo_cross_app/features/subscription/domain/iap_products.dart';

/// Testlerde gerçek StoreKit yerine kullanılan sahte [IapClient].
///
/// Satın alma/geri yükleme olayları [emit] ile manuel olarak akıtılır;
/// böylece `purchased`/`canceled`/`error` durumları deterministik test edilir.
class FakeIapClient implements IapClient {
  FakeIapClient({
    this.available = true,
    List<ProductDetails>? products,
    this.queryError,
  }) : products = products ?? _defaultProducts();

  bool available;
  List<ProductDetails> products;
  IAPError? queryError;

  int buyCount = 0;
  int restoreCount = 0;
  int completeCount = 0;
  final List<PurchaseDetails> completed = [];

  final StreamController<List<PurchaseDetails>> _controller =
      StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _controller.stream;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<ProductDetailsResponse> queryProductDetails(
    Set<String> identifiers,
  ) async {
    return ProductDetailsResponse(
      productDetails: products,
      notFoundIDs: const [],
      error: queryError,
    );
  }

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    buyCount++;
    return true;
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    completeCount++;
    completed.add(purchase);
  }

  @override
  Future<void> restorePurchases() async {
    restoreCount++;
  }

  /// Test sürücüsü: bir satın alma olayını akışa iter.
  void emit(List<PurchaseDetails> purchases) => _controller.add(purchases);

  void dispose() => _controller.close();
}

List<ProductDetails> _defaultProducts() => [
      ProductDetails(
        id: IapProducts.monthly,
        title: 'Monthly',
        description: 'Monthly premium',
        price: '₺49,99',
        rawPrice: 49.99,
        currencyCode: 'TRY',
      ),
      ProductDetails(
        id: IapProducts.yearly,
        title: 'Yearly',
        description: 'Yearly premium',
        price: '₺399,99',
        rawPrice: 399.99,
        currencyCode: 'TRY',
      ),
    ];

/// Belirtilen durumda bir [PurchaseDetails] üretir (test yardımcı).
PurchaseDetails fakePurchase({
  required String productId,
  required PurchaseStatus status,
  String receipt = 'base64-receipt',
  bool pendingComplete = true,
}) {
  return PurchaseDetails(
    productID: productId,
    verificationData: PurchaseVerificationData(
      localVerificationData: receipt,
      serverVerificationData: receipt,
      source: 'app_store',
    ),
    transactionDate: null,
    status: status,
  )..pendingCompletePurchase = pendingComplete;
}
