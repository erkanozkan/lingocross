import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_exam_dtos.freezed.dart';
part 'ai_exam_dtos.g.dart';

/// Yapay zekâ ile sınav soruları üretme isteği (AiExamGenerateRequest).
///
/// `POST /api/lessons/{lessonId}/ai-questions` body'si — API ile birebir
/// (camelCase JSON). [grade] 1–12 sınıf seviyesi, [count] 1–10 soru sayısı,
/// [types] soru türü kodları ("word_meaning" | "fill_blank" | "synonym"); en az
/// bir tür zorunludur (UI bunu garanti eder).
@freezed
class AiExamGenerateRequest with _$AiExamGenerateRequest {
  const factory AiExamGenerateRequest({
    required int grade,
    required int count,
    required List<String> types,
  }) = _AiExamGenerateRequest;

  factory AiExamGenerateRequest.fromJson(Map<String, dynamic> json) =>
      _$AiExamGenerateRequestFromJson(json);
}

/// Üretilen bir çoktan seçmeli sorunun tek şıkkı (AiGeneratedQuestionOption) —
/// API ile birebir.
///
/// [position] 0–3 (A–D sırası). [isCorrect] doğru şıkkı işaretler (review
/// ekranında yeşil zemin + onay simgesiyle vurgulanır).
@freezed
class AiGeneratedQuestionOption with _$AiGeneratedQuestionOption {
  const factory AiGeneratedQuestionOption({
    required String id,
    required int position,
    required String text,
    required bool isCorrect,
  }) = _AiGeneratedQuestionOption;

  factory AiGeneratedQuestionOption.fromJson(Map<String, dynamic> json) =>
      _$AiGeneratedQuestionOptionFromJson(json);
}

/// Üretilen tek bir çoktan seçmeli soru (AiGeneratedQuestion) — API ile birebir.
///
/// [type] soru türü kodu ("word_meaning" | "fill_blank" | "synonym"). [stem]
/// soru kökü. [explanation] opsiyonel açıklama (review'da "Açıklama:" satırı).
/// [options] A–D şıkları ([AiGeneratedQuestionOption.position] sırasında).
@freezed
class AiGeneratedQuestion with _$AiGeneratedQuestion {
  const factory AiGeneratedQuestion({
    required String id,
    required String type,
    required String stem,
    String? explanation,
    required List<AiGeneratedQuestionOption> options,
  }) = _AiGeneratedQuestion;

  factory AiGeneratedQuestion.fromJson(Map<String, dynamic> json) =>
      _$AiGeneratedQuestionFromJson(json);
}

/// Üretim sonucu (AiExamResultDto) — `POST /api/lessons/{lessonId}/ai-questions`
/// yanıtı; API ile birebir.
///
/// [topicId] oluşturulan soru konusunun kimliğidir (atama + soru silme bununla
/// yapılır). [questions] üretilen sorular.
@freezed
class AiExamResultDto with _$AiExamResultDto {
  const factory AiExamResultDto({
    required String topicId,
    required String title,
    required int grade,
    required String lessonId,
    required List<AiGeneratedQuestion> questions,
  }) = _AiExamResultDto;

  factory AiExamResultDto.fromJson(Map<String, dynamic> json) =>
      _$AiExamResultDtoFromJson(json);
}
