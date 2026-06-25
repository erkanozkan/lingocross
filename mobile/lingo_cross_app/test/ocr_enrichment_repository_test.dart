import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/lessons/data/dtos/ocr_enrich_dtos.dart';
import 'package:lingo_cross_app/features/lessons/data/ocr_enrichment_repository.dart';

/// Dio'yu ağ olmadan süren minimal sahte adapter. Verilen [handler] ile her
/// isteğe kanıt yanıt/hata üretilir.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  /// (requestBody) → ResponseBody döndürür ya da fırlatır.
  final ResponseBody Function(String requestBody) handler;

  String? lastRequestBody;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequestBody = options.data == null ? '' : jsonEncode(options.data);
    return handler(lastRequestBody!);
  }
}

ResponseBody _json(int status, Map<String, dynamic> body) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

Dio _dioWith(_FakeAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'http://test.local'));
  dio.httpClientAdapter = adapter;
  return dio;
}

void main() {
  group('OcrEnrichmentRepository.enrich', () {
    test('başarıda (200) zenginleştirilmiş kelimeleri döndürür', () async {
      late String captured;
      final adapter = _FakeAdapter((body) {
        captured = body;
        return _json(200, {
          'words': [
            {
              'term': 'apple',
              'meaning': 'elma',
              'synonyms': ['pome'],
            },
            {'term': 'book', 'meaning': 'kitap'},
          ],
        });
      });
      final repo = OcrEnrichmentRepository(_dioWith(adapter));

      final words = await repo.enrich(
        imageBase64: 'AAAA',
        mediaType: 'image/jpeg',
        sourceLanguage: 'en',
        targetLanguage: 'tr',
      );

      expect(words, isNotNull);
      expect(words!.length, 2);
      expect(words[0].term, 'apple');
      expect(words[0].meaning, 'elma');
      expect(words[0].synonyms, ['pome']);
      expect(words[1].term, 'book');
      expect(words[1].synonyms, isEmpty);

      // İstek gövdesi sözleşmeyle uyumlu olmalı (görüntü gönderilir).
      final sent = jsonDecode(captured) as Map<String, dynamic>;
      expect(sent['imageBase64'], 'AAAA');
      expect(sent['mediaType'], 'image/jpeg');
      expect(sent['sourceLanguage'], 'en');
      expect(sent['targetLanguage'], 'tr');
    });

    test('503 (anahtar yok/upstream) → null', () async {
      final adapter = _FakeAdapter(
        (_) => _json(503, {'title': 'Service Unavailable'}),
      );
      final repo = OcrEnrichmentRepository(_dioWith(adapter));

      final words = await repo.enrich(
        imageBase64: 'AAAA',
        mediaType: 'image/jpeg',
        sourceLanguage: 'en',
        targetLanguage: 'tr',
      );

      expect(words, isNull);
    });

    test('ağ hatası → null', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://test.local'));
      dio.httpClientAdapter = _ThrowingAdapter();
      final repo = OcrEnrichmentRepository(dio);

      final words = await repo.enrich(
        imageBase64: 'AAAA',
        mediaType: 'image/jpeg',
        sourceLanguage: 'en',
        targetLanguage: 'tr',
      );

      expect(words, isNull);
    });

    test('boş words listesi → null', () async {
      final adapter = _FakeAdapter((_) => _json(200, {'words': <dynamic>[]}));
      final repo = OcrEnrichmentRepository(_dioWith(adapter));

      final words = await repo.enrich(
        imageBase64: 'AAAA',
        mediaType: 'image/jpeg',
        sourceLanguage: 'en',
        targetLanguage: 'tr',
      );

      expect(words, isNull);
    });

    test('boş imageBase64 → istek yapılmadan null', () async {
      var called = false;
      final adapter = _FakeAdapter((_) {
        called = true;
        return _json(200, {'words': <dynamic>[]});
      });
      final repo = OcrEnrichmentRepository(_dioWith(adapter));

      final words = await repo.enrich(
        imageBase64: '   ',
        mediaType: 'image/jpeg',
        sourceLanguage: 'en',
        targetLanguage: 'tr',
      );

      expect(words, isNull);
      expect(called, isFalse);
    });
  });

  group('enrichedWordsToCandidates', () {
    test('term/meaning/synonyms gözden geçirme adaylarına taşınır', () {
      final candidates = enrichedWordsToCandidates(const [
        OcrEnrichedWord(
          term: 'apple',
          meaning: 'elma',
          synonyms: ['pome', ' '],
        ),
        OcrEnrichedWord(term: 'a'),
      ]);

      expect(candidates.length, 2);
      expect(candidates[0].term, 'apple');
      expect(candidates[0].meaning, 'elma');
      expect(candidates[0].synonyms, ['pome']); // boş eşanlam budanır
      expect(candidates[0].tooShort, isFalse);
      // meaning boşsa null'a indirgenir; tek harf tooShort işaretlenir
      expect(candidates[1].meaning, isNull);
      expect(candidates[1].tooShort, isTrue);
    });

    test('boş term elenir', () {
      final candidates = enrichedWordsToCandidates(const [
        OcrEnrichedWord(term: '  '),
        OcrEnrichedWord(term: 'book', meaning: 'kitap'),
      ]);
      expect(candidates.length, 1);
      expect(candidates.single.term, 'book');
    });
  });
}

class _ThrowingAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    throw DioException(
      requestOptions: options,
      type: DioExceptionType.connectionError,
      error: 'offline',
    );
  }
}
