import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lingo_cross_app/features/subscription/data/iap_service.dart';
import 'package:lingo_cross_app/features/subscription/domain/iap_products.dart';
import 'package:lingo_cross_app/features/subscription/domain/subscription_failure.dart';

import 'helpers/fake_iap_client.dart';
import 'helpers/fake_subscription_repository.dart';

IapService _service(
  FakeIapClient client,
  FakeSubscriptionRepository repo, {
  void Function()? onVerified,
}) {
  final service = IapService(
    client: client,
    repository: repo,
    onEntitlementVerified: () async => onVerified?.call(),
  )..start();
  addTearDown(service.dispose);
  return service;
}

void main() {
  group('loadProducts', () {
    test('mağaza kullanılamıyorsa unavailable', () async {
      final client = FakeIapClient(available: false);
      addTearDown(client.dispose);
      final service = _service(client, FakeSubscriptionRepository());

      await service.loadProducts();

      expect(service.productsState.unavailable, isTrue);
      expect(service.productsState.products, isEmpty);
    });

    test('ürünler gelince fiyatlar dolu, hata yok', () async {
      final client = FakeIapClient();
      addTearDown(client.dispose);
      final service = _service(client, FakeSubscriptionRepository());

      await service.loadProducts();

      expect(service.productsState.queryError, isFalse);
      expect(service.productsState.byId(IapProducts.monthly)?.price, '₺49,99');
      expect(service.productsState.byId(IapProducts.yearly)?.price, '₺399,99');
    });

    test('sorgu hatasında queryError', () async {
      final client = FakeIapClient(
        products: const [],
        queryError: IAPError(
          source: 'app_store',
          code: 'err',
          message: 'boom',
        ),
      );
      addTearDown(client.dispose);
      final service = _service(client, FakeSubscriptionRepository());

      await service.loadProducts();

      expect(service.productsState.queryError, isTrue);
    });
  });

  group('purchaseStream → verify → complete', () {
    test('purchased + verify başarılı → success + entitlement tazelenir + complete',
        () async {
      final client = FakeIapClient();
      addTearDown(client.dispose);
      final repo = FakeSubscriptionRepository();
      var verifiedCalls = 0;
      final service = _service(client, repo, onVerified: () => verifiedCalls++);

      final events = <IapPurchaseOutcome>[];
      service.purchaseEvents.listen((e) => events.add(e.outcome));

      client.emit([
        fakePurchase(
          productId: IapProducts.yearly,
          status: PurchaseStatus.purchased,
          receipt: 'receipt-123',
        ),
      ]);
      await Future<void>.delayed(Duration.zero);

      expect(repo.verifyAppleCount, 1);
      expect(repo.lastReceiptData, 'receipt-123');
      expect(verifiedCalls, 1);
      expect(client.completeCount, 1);
      expect(events, contains(IapPurchaseOutcome.success));
    });

    test('restored + verify başarılı → success', () async {
      final client = FakeIapClient();
      addTearDown(client.dispose);
      final repo = FakeSubscriptionRepository();
      final service = _service(client, repo);
      final events = <IapPurchaseOutcome>[];
      service.purchaseEvents.listen((e) => events.add(e.outcome));

      client.emit([
        fakePurchase(
          productId: IapProducts.monthly,
          status: PurchaseStatus.restored,
        ),
      ]);
      await Future<void>.delayed(Duration.zero);

      expect(repo.verifyAppleCount, 1);
      expect(events, contains(IapPurchaseOutcome.success));
    });

    test('verify başarısız → premium verilmez ama complete YİNE çağrılır + error',
        () async {
      final client = FakeIapClient();
      addTearDown(client.dispose);
      final repo = FakeSubscriptionRepository()
        ..verifyAppleError = const SubscriptionFailure.unexpected();
      var verifiedCalls = 0;
      final service = _service(client, repo, onVerified: () => verifiedCalls++);
      final events = <IapPurchaseOutcome>[];
      service.purchaseEvents.listen((e) => events.add(e.outcome));

      client.emit([
        fakePurchase(
          productId: IapProducts.yearly,
          status: PurchaseStatus.purchased,
        ),
      ]);
      await Future<void>.delayed(Duration.zero);

      expect(repo.verifyAppleCount, 1);
      expect(verifiedCalls, 0); // entitlement tazelenmez
      expect(client.completeCount, 1); // takılmasın diye yine complete
      expect(events, contains(IapPurchaseOutcome.error));
    });

    test('canceled → canceled olayı + complete', () async {
      final client = FakeIapClient();
      addTearDown(client.dispose);
      final repo = FakeSubscriptionRepository();
      final service = _service(client, repo);
      final events = <IapPurchaseOutcome>[];
      service.purchaseEvents.listen((e) => events.add(e.outcome));

      client.emit([
        fakePurchase(
          productId: IapProducts.yearly,
          status: PurchaseStatus.canceled,
        ),
      ]);
      await Future<void>.delayed(Duration.zero);

      expect(repo.verifyAppleCount, 0);
      expect(events, contains(IapPurchaseOutcome.canceled));
      expect(client.completeCount, 1);
    });

    test('pending → pending olayı, verify yok', () async {
      final client = FakeIapClient();
      addTearDown(client.dispose);
      final repo = FakeSubscriptionRepository();
      final service = _service(client, repo);
      final events = <IapPurchaseOutcome>[];
      service.purchaseEvents.listen((e) => events.add(e.outcome));

      client.emit([
        fakePurchase(
          productId: IapProducts.monthly,
          status: PurchaseStatus.pending,
        ),
      ]);
      await Future<void>.delayed(Duration.zero);

      expect(repo.verifyAppleCount, 0);
      expect(events, contains(IapPurchaseOutcome.pending));
    });
  });

  group('buy / restore', () {
    test('buy → buyNonConsumable çağrılır', () async {
      final client = FakeIapClient();
      addTearDown(client.dispose);
      final service = _service(client, FakeSubscriptionRepository());
      await service.loadProducts();

      await service.buy(service.productsState.byId(IapProducts.yearly)!);

      expect(client.buyCount, 1);
    });

    test('restore → restorePurchases çağrılır', () async {
      final client = FakeIapClient();
      addTearDown(client.dispose);
      final service = _service(client, FakeSubscriptionRepository());

      await service.restore();

      expect(client.restoreCount, 1);
    });
  });
}
