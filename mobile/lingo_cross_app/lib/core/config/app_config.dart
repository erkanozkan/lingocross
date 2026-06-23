/// Çalışma-zamanı yapılandırması (build-time --dart-define ile geçersiz kılınır).
///
/// Örnek:
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5093
///
/// Not: Android emülatöründe host makine `10.0.2.2` üzerinden erişilir; iOS
/// simülatöründe `http://localhost:5093` kullanılır. Varsayılan, en sık
/// kullanılan Android emülatör adresidir.
abstract final class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5093',
  );

  /// Tüm auth uçları `/api` altında (bkz. LingoCross.Api.http).
  static String get apiPrefix => '/api';
}
