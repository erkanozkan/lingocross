import 'dart:async';

import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/token_storage.dart';

/// Erişim token'ı ekleyen + 401'de TEK sefer refresh eden interceptor.
///
/// Davranış (orchestrator gereği):
/// - Her isteğe `Authorization: Bearer <access>` ekler (refresh ucu hariç).
/// - 401 alındığında **tek** bir refresh denemesi başlatır; bu sırada gelen
///   eşzamanlı 401'ler aynı refresh'i bekler (kuyruğa alınır).
/// - Refresh başarılıysa orijinal istek **bir kez** yeni token ile retry edilir.
/// - Refresh başarısızsa token'lar temizlenir ve [onSessionExpired] çağrılır
///   (router welcome'a yönlendirir); hata yukarı taşınır.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.tokenStorage,
    required this.onSessionExpired,
  });

  final TokenStorage tokenStorage;

  /// Refresh kalıcı olarak başarısız olduğunda tetiklenir (token temizliği +
  /// welcome'a yönlendirme için).
  final FutureOr<void> Function() onSessionExpired;

  /// Refresh çağrısı için ayrı, interceptor'sız Dio (sonsuz döngüyü önler).
  late final Dio _refreshDio = Dio(
    BaseOptions(baseUrl: AppConfig.apiBaseUrl),
  );

  static const String _retriedFlag = 'lc_retried';
  static const String _refreshPath = '/api/auth/refresh';

  Completer<bool>? _refreshCompleter;

  bool _isRefreshPath(String? path) =>
      path != null && path.contains(_refreshPath);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isRefreshPath(options.path)) {
      final access = await tokenStorage.readAccessToken();
      if (access != null && access.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $access';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final requestOptions = err.requestOptions;

    final bool isUnauthorized = response?.statusCode == 401;
    final bool alreadyRetried = requestOptions.extra[_retriedFlag] == true;
    final bool isRefreshCall = _isRefreshPath(requestOptions.path);

    // Refresh edilemeyecek durumlar: 401 değil, refresh çağrısı, ya da zaten
    // bir kez retry edilmiş istek → hatayı olduğu gibi geçir.
    if (!isUnauthorized || isRefreshCall || alreadyRetried) {
      return handler.next(err);
    }

    final bool refreshed = await _ensureRefreshed();
    if (!refreshed) {
      return handler.next(err);
    }

    // Yeni access token ile orijinal isteği TEK kez retry et.
    try {
      final access = await tokenStorage.readAccessToken();
      final retryOptions = Options(
        method: requestOptions.method,
        headers: {
          ...requestOptions.headers,
          if (access != null) 'Authorization': 'Bearer $access',
        },
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        extra: {...requestOptions.extra, _retriedFlag: true},
      );

      final retryResponse = await _refreshDio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: retryOptions,
      );
      return handler.resolve(retryResponse);
    } on DioException catch (retryErr) {
      return handler.next(retryErr);
    }
  }

  /// Tek refresh garantisi: ilk çağıran refresh'i başlatır, eşzamanlı çağıranlar
  /// aynı sonucu bekler.
  Future<bool> _ensureRefreshed() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final completer = Completer<bool>();
    _refreshCompleter = completer;

    try {
      final refreshToken = await tokenStorage.readRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _failSession();
        completer.complete(false);
        return false;
      }

      final res = await _refreshDio.post<Map<String, dynamic>>(
        _refreshPath,
        data: {'refreshToken': refreshToken},
      );

      final data = res.data;
      final newAccess = data?['accessToken'] as String?;
      final newRefresh = data?['refreshToken'] as String?;

      if (newAccess == null || newRefresh == null) {
        await _failSession();
        completer.complete(false);
        return false;
      }

      await tokenStorage.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );
      completer.complete(true);
      return true;
    } catch (_) {
      await _failSession();
      completer.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<void> _failSession() async {
    await tokenStorage.clear();
    await onSessionExpired();
  }
}
