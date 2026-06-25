import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/subscription_notifier.dart';
import 'iap_client.dart';
import 'iap_service.dart';
import 'subscription_repository.dart';

/// Mağaza erişim istemcisi (gerçek StoreKit). Testlerde override edilir.
final iapClientProvider = Provider<IapClient>((ref) => StoreKitIapClient());

/// Satın alma akışını yöneten servis. Oturum boyunca tek örnek; dispose'ta
/// stream aboneliği kapatılır.
final iapServiceProvider = Provider<IapService>((ref) {
  final service = IapService(
    client: ref.watch(iapClientProvider),
    repository: ref.watch(subscriptionRepositoryProvider),
    onEntitlementVerified: () =>
        ref.read(subscriptionNotifierProvider.notifier).refresh(),
  );
  service.start();
  ref.onDispose(service.dispose);
  return service;
});
