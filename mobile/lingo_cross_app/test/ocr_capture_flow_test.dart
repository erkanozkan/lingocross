import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/lessons/data/dtos/ocr_enrich_dtos.dart';
import 'package:lingo_cross_app/features/lessons/data/ocr_enrichment_repository.dart';
import 'package:lingo_cross_app/features/lessons/data/ocr_service.dart';
import 'package:lingo_cross_app/features/lessons/presentation/ocr_capture_controller.dart';

/// Görüntü seçimi + kodlamayı taklit eden sahte servis (image_picker/dosya yok).
class _FakeOcrService extends OcrService {
  @override
  Future<String?> pickImage(OcrImageSource source) async => '/tmp/list.jpg';

  @override
  Future<OcrImagePayload> encode(String imagePath) async =>
      const OcrImagePayload(base64: 'AAAA', mediaType: 'image/jpeg');
}

/// `/api/ocr/enrich` çağrısını taklit eden sahte repository (Dio kullanmaz).
class _FakeEnrichmentRepository implements OcrEnrichmentRepository {
  _FakeEnrichmentRepository(this.response);

  /// `enrich` çağrısının döndüreceği değer (null → AI okuyamadı).
  final List<OcrEnrichedWord>? response;

  String? lastImageBase64;
  String? lastMediaType;
  String? lastSource;
  String? lastTarget;

  @override
  Future<List<OcrEnrichedWord>?> enrich({
    required String imageBase64,
    required String mediaType,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    lastImageBase64 = imageBase64;
    lastMediaType = mediaType;
    lastSource = sourceLanguage;
    lastTarget = targetLanguage;
    return response;
  }
}

ProviderContainer _container(
  OcrService service,
  OcrEnrichmentRepository repo,
) {
  final container = ProviderContainer(
    overrides: [
      ocrServiceProvider.overrideWithValue(service),
      ocrEnrichmentRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('OcrCaptureController.scan (görüntü → AI → kelimeler)', () {
    test('foto seçilir, görüntü gönderilir, kelimeler review adaylarına döner',
        () async {
      final repo = _FakeEnrichmentRepository(const [
        OcrEnrichedWord(term: 'apple', meaning: 'elma', synonyms: ['pome']),
        OcrEnrichedWord(term: 'book', meaning: 'kitap'),
      ]);
      final container = _container(_FakeOcrService(), repo);
      final controller =
          container.read(ocrCaptureControllerProvider.notifier);

      await controller.pick(OcrImageSource.gallery);
      expect(container.read(ocrCaptureControllerProvider).hasImage, isTrue);

      final result = await controller.scan(
        sourceLanguage: 'en',
        targetLanguage: 'tr',
      );

      // Görüntü base64 olarak ders diliyle birlikte gönderildi.
      expect(repo.lastImageBase64, 'AAAA');
      expect(repo.lastMediaType, 'image/jpeg');
      expect(repo.lastSource, 'en');
      expect(repo.lastTarget, 'tr');

      // AI kelimeleri review adaylarına çevrildi.
      expect(result, isNotNull);
      expect(result!.candidates.length, 2);
      expect(result.candidates[0].term, 'apple');
      expect(result.candidates[0].meaning, 'elma');
      expect(result.candidates[0].synonyms, ['pome']);
      expect(result.candidates[1].term, 'book');

      // İşlem bitince idle'a döner.
      expect(container.read(ocrCaptureControllerProvider).isBusy, isFalse);
    });

    test('AI okuyamazsa (null) → scan null (hata durumu)', () async {
      final repo = _FakeEnrichmentRepository(null);
      final container = _container(_FakeOcrService(), repo);
      final controller =
          container.read(ocrCaptureControllerProvider.notifier);

      await controller.pick(OcrImageSource.camera);
      final result = await controller.scan(
        sourceLanguage: 'en',
        targetLanguage: 'tr',
      );

      expect(result, isNull);
      expect(repo.lastImageBase64, 'AAAA');
      expect(container.read(ocrCaptureControllerProvider).isBusy, isFalse);
    });

    test('foto seçilmemişse scan null (enrich çağrılmaz)', () async {
      final repo = _FakeEnrichmentRepository(const []);
      final container = _container(_FakeOcrService(), repo);
      final controller =
          container.read(ocrCaptureControllerProvider.notifier);

      final result = await controller.scan(
        sourceLanguage: 'en',
        targetLanguage: 'tr',
      );

      expect(result, isNull);
      expect(repo.lastImageBase64, isNull);
    });
  });
}
