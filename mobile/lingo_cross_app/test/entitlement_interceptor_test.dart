import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/network/entitlement_interceptor.dart';
import 'package:lingo_cross_app/core/network/paywall_events.dart';

/// 402'de hatayı yine geçirip geçirmediğini doğrulayan basit handler.
class _RecordingHandler extends ErrorInterceptorHandler {
  bool nextCalled = false;
  @override
  void next(DioException err) {
    nextCalled = true;
  }
}

DioException _error(int statusCode, {Object? data}) {
  final options = RequestOptions(path: '/api/words');
  return DioException(
    requestOptions: options,
    response: Response(
      requestOptions: options,
      statusCode: statusCode,
      data: data,
    ),
  );
}

void main() {
  group('EntitlementInterceptor 402 köprüsü', () {
    test('402 + feature → paywallEvents.trigger(feature) + hata geçirilir',
        () async {
      final events = PaywallEvents();
      addTearDown(events.dispose);
      final emitted = <String>[];
      final sub = events.stream.listen(emitted.add);
      addTearDown(sub.cancel);

      final interceptor = EntitlementInterceptor(events);
      final handler = _RecordingHandler();

      interceptor.onError(
        _error(402, data: {
          'code': 'subscription_required',
          'feature': 'ocr',
        }),
        handler,
      );

      // Akış asenkron yayar; bir mikrotask bekle.
      await Future<void>.delayed(Duration.zero);
      expect(emitted, ['ocr']);
      expect(handler.nextCalled, true);
    });

    test('402 + feature yok → "unknown" tetiklenir', () async {
      final events = PaywallEvents();
      addTearDown(events.dispose);
      final emitted = <String>[];
      final sub = events.stream.listen(emitted.add);
      addTearDown(sub.cancel);

      EntitlementInterceptor(events).onError(
        _error(402, data: {'code': 'subscription_required'}),
        _RecordingHandler(),
      );

      await Future<void>.delayed(Duration.zero);
      expect(emitted, ['unknown']);
    });

    test('402 değil (404) → tetiklenmez, hata geçirilir', () async {
      final events = PaywallEvents();
      addTearDown(events.dispose);
      final emitted = <String>[];
      final sub = events.stream.listen(emitted.add);
      addTearDown(sub.cancel);

      final handler = _RecordingHandler();
      EntitlementInterceptor(events).onError(_error(404), handler);

      await Future<void>.delayed(Duration.zero);
      expect(emitted, isEmpty);
      expect(handler.nextCalled, true);
    });
  });
}
