/// App Store Connect / Google Play'de tanımlı abonelik ürün kimlikleri (S3).
///
/// Bu sabitler mağazadaki ürün ID'leriyle **birebir** aynı olmalıdır. Ürün
/// detayları (fiyat/başlık) `queryProductDetails` ile bu ID'ler üzerinden çekilir.
library;

/// Premium abonelik ürün kimlikleri (StoreKit/BillingClient).
abstract final class IapProducts {
  /// Aylık premium abonelik.
  static const String monthly = 'com.lingocross.premium.monthly';

  /// Yıllık premium abonelik.
  static const String yearly = 'com.lingocross.premium.yearly';

  /// Mağazadan sorgulanacak tüm ürün kimlikleri.
  static const Set<String> all = {monthly, yearly};
}
