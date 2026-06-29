// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameDtoImpl _$$GameDtoImplFromJson(Map<String, dynamic> json) =>
    _$GameDtoImpl(
      id: json['id'] as String,
      lessonId: json['lessonId'] as String?,
      type: const GameTypeConverter().fromJson((json['type'] as num).toInt()),
      title: json['title'] as String,
      isPublished: json['isPublished'] as bool,
      publishedAt:
          json['publishedAt'] == null
              ? null
              : DateTime.parse(json['publishedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$GameDtoImplToJson(_$GameDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lessonId': instance.lessonId,
      'type': const GameTypeConverter().toJson(instance.type),
      'title': instance.title,
      'isPublished': instance.isPublished,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$AssignedGameDtoImpl _$$AssignedGameDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AssignedGameDtoImpl(
  id: json['id'] as String,
  lessonId: json['lessonId'] as String?,
  questionTopicId: json['questionTopicId'] as String?,
  lessonTitle: json['lessonTitle'] as String,
  type: const GameTypeConverter().fromJson((json['type'] as num).toInt()),
  title: json['title'] as String,
  wordCount: (json['wordCount'] as num).toInt(),
  teacherName: json['teacherName'] as String,
  publishedAt:
      json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
  isCompleted: json['isCompleted'] as bool? ?? false,
  resultId: json['resultId'] as String?,
  score: (json['score'] as num?)?.toInt(),
  completedAt:
      json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$$AssignedGameDtoImplToJson(
  _$AssignedGameDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'lessonId': instance.lessonId,
  'questionTopicId': instance.questionTopicId,
  'lessonTitle': instance.lessonTitle,
  'type': const GameTypeConverter().toJson(instance.type),
  'title': instance.title,
  'wordCount': instance.wordCount,
  'teacherName': instance.teacherName,
  'publishedAt': instance.publishedAt?.toIso8601String(),
  'isCompleted': instance.isCompleted,
  'resultId': instance.resultId,
  'score': instance.score,
  'completedAt': instance.completedAt?.toIso8601String(),
};

_$TeacherPuzzleDtoImpl _$$TeacherPuzzleDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TeacherPuzzleDtoImpl(
  id: json['id'] as String,
  lessonId: json['lessonId'] as String?,
  lessonTitle: json['lessonTitle'] as String,
  type: const GameTypeConverter().fromJson((json['type'] as num).toInt()),
  isPublished: json['isPublished'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  assignedStudentCount: (json['assignedStudentCount'] as num).toInt(),
  solveCount: (json['solveCount'] as num).toInt(),
);

Map<String, dynamic> _$$TeacherPuzzleDtoImplToJson(
  _$TeacherPuzzleDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'lessonId': instance.lessonId,
  'lessonTitle': instance.lessonTitle,
  'type': const GameTypeConverter().toJson(instance.type),
  'isPublished': instance.isPublished,
  'createdAt': instance.createdAt.toIso8601String(),
  'assignedStudentCount': instance.assignedStudentCount,
  'solveCount': instance.solveCount,
};

_$CreateGameRequestImpl _$$CreateGameRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateGameRequestImpl(
  type: const GameTypeConverter().fromJson((json['type'] as num).toInt()),
  title: json['title'] as String?,
  classIds:
      (json['classIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$$CreateGameRequestImplToJson(
  _$CreateGameRequestImpl instance,
) => <String, dynamic>{
  'type': const GameTypeConverter().toJson(instance.type),
  'title': instance.title,
  'classIds': instance.classIds,
};

_$GameSessionDtoImpl _$$GameSessionDtoImplFromJson(Map<String, dynamic> json) =>
    _$GameSessionDtoImpl(
      id: json['id'] as String,
      gameId: json['gameId'] as String,
      studentId: json['studentId'] as String,
      status: const GameSessionStatusConverter().fromJson(
        (json['status'] as num).toInt(),
      ),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt:
          json['completedAt'] == null
              ? null
              : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$GameSessionDtoImplToJson(
  _$GameSessionDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'gameId': instance.gameId,
  'studentId': instance.studentId,
  'status': const GameSessionStatusConverter().toJson(instance.status),
  'startedAt': instance.startedAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
};

_$MatchingPairImpl _$$MatchingPairImplFromJson(Map<String, dynamic> json) =>
    _$MatchingPairImpl(
      wordId: json['wordId'] as String,
      term: json['term'] as String,
      correctTranslation: json['correctTranslation'] as String,
    );

Map<String, dynamic> _$$MatchingPairImplToJson(_$MatchingPairImpl instance) =>
    <String, dynamic>{
      'wordId': instance.wordId,
      'term': instance.term,
      'correctTranslation': instance.correctTranslation,
    };

_$WordMatchingContentImpl _$$WordMatchingContentImplFromJson(
  Map<String, dynamic> json,
) => _$WordMatchingContentImpl(
  pairs:
      (json['pairs'] as List<dynamic>)
          .map((e) => MatchingPair.fromJson(e as Map<String, dynamic>))
          .toList(),
  distractors:
      (json['distractors'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$$WordMatchingContentImplToJson(
  _$WordMatchingContentImpl instance,
) => <String, dynamic>{
  'pairs': instance.pairs.map((e) => e.toJson()).toList(),
  'distractors': instance.distractors,
};

_$ScrambledItemImpl _$$ScrambledItemImplFromJson(Map<String, dynamic> json) =>
    _$ScrambledItemImpl(
      wordId: json['wordId'] as String,
      answer: json['answer'] as String,
      scrambledLetters: json['scrambledLetters'] as String,
      clue: json['clue'] as String,
    );

Map<String, dynamic> _$$ScrambledItemImplToJson(_$ScrambledItemImpl instance) =>
    <String, dynamic>{
      'wordId': instance.wordId,
      'answer': instance.answer,
      'scrambledLetters': instance.scrambledLetters,
      'clue': instance.clue,
    };

_$ScrambledContentImpl _$$ScrambledContentImplFromJson(
  Map<String, dynamic> json,
) => _$ScrambledContentImpl(
  items:
      (json['items'] as List<dynamic>)
          .map((e) => ScrambledItem.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$$ScrambledContentImplToJson(
  _$ScrambledContentImpl instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};

_$QuestionChoiceImpl _$$QuestionChoiceImplFromJson(Map<String, dynamic> json) =>
    _$QuestionChoiceImpl(
      optionId: json['optionId'] as String,
      label: json['label'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$$QuestionChoiceImplToJson(
  _$QuestionChoiceImpl instance,
) => <String, dynamic>{
  'optionId': instance.optionId,
  'label': instance.label,
  'text': instance.text,
};

_$QuestionItemImpl _$$QuestionItemImplFromJson(Map<String, dynamic> json) =>
    _$QuestionItemImpl(
      questionId: json['questionId'] as String,
      stem: json['stem'] as String,
      choices:
          (json['choices'] as List<dynamic>)
              .map((e) => QuestionChoice.fromJson(e as Map<String, dynamic>))
              .toList(),
      correctOptionId: json['correctOptionId'] as String,
      explanation: json['explanation'] as String?,
    );

Map<String, dynamic> _$$QuestionItemImplToJson(_$QuestionItemImpl instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'stem': instance.stem,
      'choices': instance.choices.map((e) => e.toJson()).toList(),
      'correctOptionId': instance.correctOptionId,
      'explanation': instance.explanation,
    };

_$QuestionSetContentImpl _$$QuestionSetContentImplFromJson(
  Map<String, dynamic> json,
) => _$QuestionSetContentImpl(
  questions:
      (json['questions'] as List<dynamic>)
          .map((e) => QuestionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$$QuestionSetContentImplToJson(
  _$QuestionSetContentImpl instance,
) => <String, dynamic>{
  'questions': instance.questions.map((e) => e.toJson()).toList(),
};

_$QuestionTopicDtoImpl _$$QuestionTopicDtoImplFromJson(
  Map<String, dynamic> json,
) => _$QuestionTopicDtoImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  questionCount: (json['questionCount'] as num).toInt(),
);

Map<String, dynamic> _$$QuestionTopicDtoImplToJson(
  _$QuestionTopicDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'questionCount': instance.questionCount,
};

_$GameAssignmentsDtoImpl _$$GameAssignmentsDtoImplFromJson(
  Map<String, dynamic> json,
) => _$GameAssignmentsDtoImpl(
  classIds:
      (json['classIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$$GameAssignmentsDtoImplToJson(
  _$GameAssignmentsDtoImpl instance,
) => <String, dynamic>{'classIds': instance.classIds};

_$CrosswordEntryImpl _$$CrosswordEntryImplFromJson(Map<String, dynamic> json) =>
    _$CrosswordEntryImpl(
      number: (json['number'] as num).toInt(),
      answer: json['answer'] as String,
      clue: json['clue'] as String,
      row: (json['row'] as num).toInt(),
      col: (json['col'] as num).toInt(),
      direction: const CrosswordDirectionConverter().fromJson(
        (json['direction'] as num).toInt(),
      ),
      length: (json['length'] as num).toInt(),
    );

Map<String, dynamic> _$$CrosswordEntryImplToJson(
  _$CrosswordEntryImpl instance,
) => <String, dynamic>{
  'number': instance.number,
  'answer': instance.answer,
  'clue': instance.clue,
  'row': instance.row,
  'col': instance.col,
  'direction': const CrosswordDirectionConverter().toJson(instance.direction),
  'length': instance.length,
};

_$CrosswordContentImpl _$$CrosswordContentImplFromJson(
  Map<String, dynamic> json,
) => _$CrosswordContentImpl(
  rows: (json['rows'] as num).toInt(),
  cols: (json['cols'] as num).toInt(),
  entries:
      (json['entries'] as List<dynamic>)
          .map((e) => CrosswordEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$$CrosswordContentImplToJson(
  _$CrosswordContentImpl instance,
) => <String, dynamic>{
  'rows': instance.rows,
  'cols': instance.cols,
  'entries': instance.entries.map((e) => e.toJson()).toList(),
};

_$GamePreviewResponseImpl _$$GamePreviewResponseImplFromJson(
  Map<String, dynamic> json,
) => _$GamePreviewResponseImpl(
  type: const GameTypeConverter().fromJson((json['type'] as num).toInt()),
  wordMatching:
      json['wordMatching'] == null
          ? null
          : WordMatchingContent.fromJson(
            json['wordMatching'] as Map<String, dynamic>,
          ),
  crossword:
      json['crossword'] == null
          ? null
          : CrosswordContent.fromJson(
            json['crossword'] as Map<String, dynamic>,
          ),
  scrambled:
      json['scrambled'] == null
          ? null
          : ScrambledContent.fromJson(
            json['scrambled'] as Map<String, dynamic>,
          ),
  questionSet:
      json['questionSet'] == null
          ? null
          : QuestionSetContent.fromJson(
            json['questionSet'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$$GamePreviewResponseImplToJson(
  _$GamePreviewResponseImpl instance,
) => <String, dynamic>{
  'type': const GameTypeConverter().toJson(instance.type),
  'wordMatching': instance.wordMatching?.toJson(),
  'crossword': instance.crossword?.toJson(),
  'scrambled': instance.scrambled?.toJson(),
  'questionSet': instance.questionSet?.toJson(),
};

_$StartGameSessionResponseImpl _$$StartGameSessionResponseImplFromJson(
  Map<String, dynamic> json,
) => _$StartGameSessionResponseImpl(
  session: GameSessionDto.fromJson(json['session'] as Map<String, dynamic>),
  type: const GameTypeConverter().fromJson((json['type'] as num).toInt()),
  wordMatching:
      json['wordMatching'] == null
          ? null
          : WordMatchingContent.fromJson(
            json['wordMatching'] as Map<String, dynamic>,
          ),
  crossword:
      json['crossword'] == null
          ? null
          : CrosswordContent.fromJson(
            json['crossword'] as Map<String, dynamic>,
          ),
  scrambled:
      json['scrambled'] == null
          ? null
          : ScrambledContent.fromJson(
            json['scrambled'] as Map<String, dynamic>,
          ),
  questionSet:
      json['questionSet'] == null
          ? null
          : QuestionSetContent.fromJson(
            json['questionSet'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$$StartGameSessionResponseImplToJson(
  _$StartGameSessionResponseImpl instance,
) => <String, dynamic>{
  'session': instance.session.toJson(),
  'type': const GameTypeConverter().toJson(instance.type),
  'wordMatching': instance.wordMatching?.toJson(),
  'crossword': instance.crossword?.toJson(),
  'scrambled': instance.scrambled?.toJson(),
  'questionSet': instance.questionSet?.toJson(),
};
