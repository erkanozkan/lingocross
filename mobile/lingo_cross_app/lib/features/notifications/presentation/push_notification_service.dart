import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_messenger.dart';
import '../../auth/presentation/auth_notifier.dart';
import '../../auth/presentation/auth_state.dart';
import '../data/device_repository.dart';
import '../data/push_messaging_client.dart';

part 'push_notification_service.g.dart';

/// Push bildirim kaydını oturum durumuna bağlayan servis.
///
/// - Oturum AÇILDIĞINDA: izin ister → foreground gösterimini ayarlar → FCM
///   token alır → `POST /api/devices` ile kaydeder → `onTokenRefresh` dinler →
///   `onMessage` (foreground) ile SnackBar gösterir.
/// - Oturum KAPANDIĞINDA: `DELETE /api/devices/{token}` (best-effort) + token'ı
///   siler ki bir sonraki kullanıcı yeni token alsın.
///
/// Tüm ağ çağrıları best-effort'tur: hata yutulur + log'lanır, UI bozulmaz.
/// `keepAlive`: oturum boyunca yaşar, dinleyicileri korur.
@Riverpod(keepAlive: true)
class PushNotificationService extends _$PushNotificationService {
  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _messageSub;
  String? _currentToken;
  bool _registeredForSession = false;

  PushMessagingClient get _client => ref.read(pushMessagingClientProvider);
  DeviceRepository get _devices => ref.read(deviceRepositoryProvider);

  @override
  void build() {
    // Auth durumunu izle; authenticated → kayıt, unauthenticated → temizlik.
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      final wasAuth = previous?.isAuthenticated ?? false;
      final isAuth = next.isAuthenticated;
      if (isAuth && !wasAuth) {
        unawaited(_onAuthenticated());
      } else if (!isAuth && wasAuth) {
        unawaited(_onUnauthenticated());
      }
    });

    // İlk durum zaten authenticated ise (uygulama açılışı + restore) kaydet.
    final current = ref.read(authNotifierProvider);
    if (current.isAuthenticated) {
      unawaited(_onAuthenticated());
    }

    ref.onDispose(() {
      _tokenRefreshSub?.cancel();
      _messageSub?.cancel();
    });
  }

  /// Servisin başlatılmasını garanti eden no-op (main/açılışta `read` için).
  void ensureInitialized() {}

  Future<void> _onAuthenticated() async {
    if (_registeredForSession) return;
    _registeredForSession = true;
    try {
      final granted = await _client.requestPermission();
      await _client.setForegroundPresentationOptions();

      // Foreground mesajları dinle (izin olmasa bile zararsız).
      _messageSub ??= _client.onMessage.listen(_showForegroundMessage);

      if (!granted) {
        debugPrint('[push] permission not granted; skipping token register');
        return;
      }

      final token = await _client.getToken();
      if (token != null && token.isNotEmpty) {
        _currentToken = token;
        await _registerToken(token);
      }

      _tokenRefreshSub ??= _client.onTokenRefresh.listen((token) {
        _currentToken = token;
        unawaited(_registerToken(token));
      });
    } catch (e) {
      debugPrint('[push] onAuthenticated failed: $e');
    }
  }

  Future<void> _onUnauthenticated() async {
    _registeredForSession = false;
    final token = _currentToken;
    try {
      await _tokenRefreshSub?.cancel();
      _tokenRefreshSub = null;
      await _messageSub?.cancel();
      _messageSub = null;

      if (token != null && token.isNotEmpty) {
        await _devices.unregister(token);
      }
      // Yerel token'ı sil → bir sonraki kullanıcı yeni token alır.
      await _client.deleteToken();
    } catch (e) {
      debugPrint('[push] onUnauthenticated cleanup failed: $e');
    } finally {
      _currentToken = null;
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      await _devices.register(token: token, platform: 'ios');
    } catch (e) {
      debugPrint('[push] device register failed: $e');
    }
  }

  void _showForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    final title = notification?.title;
    final body = notification?.body;
    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }
    final messenger = appMessengerKey.currentState;
    final context = appMessengerKey.currentContext;
    if (messenger == null) return;

    final l10n = context != null ? AppLocalizations.of(context) : null;
    final fallbackTitle = l10n?.pushNotificationTitle ?? 'Bildirim';

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceContainer,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (title != null && title.isNotEmpty) ? title : fallbackTitle,
                style: AppTypography.labelLg.copyWith(color: AppColors.primary),
              ),
              if (body != null && body.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.base),
                Text(
                  body,
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.onSurface),
                ),
              ],
            ],
          ),
        ),
      );
  }
}
