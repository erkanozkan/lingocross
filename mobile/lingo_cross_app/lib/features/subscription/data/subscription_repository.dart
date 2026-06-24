import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../domain/subscription_failure.dart';
import 'dtos/subscription_dtos.dart';

/// Abonelik/entitlement uçlarıyla konuşan repository (Bearer token interceptor
/// tarafından eklenir):
/// - `GET  /api/subscription/me`        → mevcut entitlement durumu
/// - `POST /api/subscription/activate`  → stub satın alma (period|trial)
/// - `POST /api/subscription/cancel`    → aboneliği iptal et
class SubscriptionRepository {
  SubscriptionRepository(this._dio);

  final Dio _dio;

  String get _base => AppConfig.apiPrefix;

  /// Kullanıcının abonelik durumu (`GET /api/subscription/me`).
  Future<SubscriptionDto> getMine() async {
    try {
      final res =
          await _dio.get<Map<String, dynamic>>('$_base/subscription/me');
      return SubscriptionDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Stub satın alma (`POST /api/subscription/activate`). Premium döner.
  Future<SubscriptionDto> activateStub(ActivateStubRequest request) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_base/subscription/activate',
        data: request.toJson(),
      );
      return SubscriptionDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Aboneliği iptal eder (`POST /api/subscription/cancel`). Güncel durumu döner.
  Future<SubscriptionDto> cancel() async {
    try {
      final res = await _dio
          .post<Map<String, dynamic>>('$_base/subscription/cancel');
      return SubscriptionDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  SubscriptionFailure _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const SubscriptionFailure.network();
      default:
        final status = e.response?.statusCode;
        if (status == null) return const SubscriptionFailure.network();
        return switch (status) {
          503 => const SubscriptionFailure.purchaseDisabled(),
          401 || 403 => const SubscriptionFailure.forbidden(),
          _ => const SubscriptionFailure.unexpected(),
        };
    }
  }
}

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(ref.watch(dioProvider));
});
