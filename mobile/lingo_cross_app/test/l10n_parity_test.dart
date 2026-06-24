import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/l10n/locale_controller.dart';

/// `@`-prefixed metadata anahtarlarını eler — yalnız çevrilebilir mesaj
/// anahtarlarını döndürür.
Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).toSet();

Map<String, dynamic> _loadArb(String fileName) {
  // Testler proje kök dizininden çalışır.
  final file = File('lib/core/l10n/arb/$fileName');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

void main() {
  group('ARB anahtar paritesi (tr ↔ en)', () {
    late Map<String, dynamic> tr;
    late Map<String, dynamic> en;

    setUpAll(() {
      tr = _loadArb('app_tr.arb');
      en = _loadArb('app_en.arb');
    });

    test('iki dosya da aynı mesaj anahtar setine sahip (eksik/fazla yok)', () {
      final trKeys = _messageKeys(tr);
      final enKeys = _messageKeys(en);

      final missingInEn = trKeys.difference(enKeys);
      final extraInEn = enKeys.difference(trKeys);

      expect(missingInEn, isEmpty,
          reason: 'EN dosyasında eksik anahtarlar: $missingInEn');
      expect(extraInEn, isEmpty,
          reason: 'EN dosyasında fazla anahtarlar: $extraInEn');
    });

    test('hiçbir EN çevirisi boş değil', () {
      for (final key in _messageKeys(en)) {
        final value = en[key];
        if (value is String) {
          expect(value.trim().isNotEmpty, isTrue,
              reason: 'EN anahtarı boş: $key');
        }
      }
    });

    test('@@locale değerleri doğru', () {
      expect(tr['@@locale'], 'tr');
      expect(en['@@locale'], 'en');
    });
  });

  group('resolveInitialLocale', () {
    test('saklı override her şeyin önündedir', () {
      final locale = resolveInitialLocale(
        storedOverride: 'tr',
        backendLocale: 'en',
        deviceLocale: const Locale('en'),
      );
      expect(locale.languageCode, 'tr');
    });

    test('override yoksa backend tercihi kullanılır', () {
      final locale = resolveInitialLocale(
        storedOverride: null,
        backendLocale: 'tr',
        deviceLocale: const Locale('en'),
      );
      expect(locale.languageCode, 'tr');
    });

    test('override + backend yoksa cihaz dili: tr korunur', () {
      final locale = resolveInitialLocale(
        deviceLocale: const Locale('tr'),
      );
      expect(locale.languageCode, 'tr');
    });

    test('cihaz dili en korunur', () {
      final locale = resolveInitialLocale(
        deviceLocale: const Locale('en'),
      );
      expect(locale.languageCode, 'en');
    });

    test('desteklenmeyen cihaz dilleri (de/fr) en fallback', () {
      expect(
        resolveInitialLocale(deviceLocale: const Locale('de')).languageCode,
        'en',
      );
      expect(
        resolveInitialLocale(deviceLocale: const Locale('fr')).languageCode,
        'en',
      );
    });

    test('bölge ekli kod (en-US) dil koduna indirgenir', () {
      final locale = resolveInitialLocale(storedOverride: 'en-US');
      expect(locale.languageCode, 'en');
    });

    test('desteklenmeyen override yok sayılır, sonraki kaynağa düşer', () {
      final locale = resolveInitialLocale(
        storedOverride: 'de',
        backendLocale: 'tr',
      );
      expect(locale.languageCode, 'tr');
    });

    test('hiçbir kaynak yoksa en fallback', () {
      expect(resolveInitialLocale().languageCode, 'en');
    });
  });
}
