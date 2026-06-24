// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameDtoImpl _$$GameDtoImplFromJson(Map<String, dynamic> json) =>
    _$GameDtoImpl(
      id: json['id'] as String,
      lessonId: json['lessonId'] as String,
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
  lessonId: json['lessonId'] as String,
  lessonTitle: json['lessonTitle'] as String,
  type: const GameTypeConverter().fromJson((json['type'] as num).toInt()),
  title: json['title'] as String,
  wordCount: (json['wordCount'] as num).toInt(),
  teacherName: json['teacherName'] as String,
  publishedAt:
      json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
);

Map<String, dynamic> _$$AssignedGameDtoImplToJson(
  _$AssignedGameDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'lessonId': instance.lessonId,
  'lessonTitle': instance.lessonTitle,
  'type': const GameTypeConverter().toJson(instance.type),
  'title': instance.title,
  'wordCount': instance.wordCount,
  'teacherName': instance.teacherName,
  'publishedAt': instance.publishedAt?.toIso8601String(),
};

_$CreateGameRequestImpl _$$CreateGameRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateGameRequestImpl(
  type: const GameTypeConverter().fromJson((json['type'] as num).toInt()),
  title: json['title'] as String?,
);

Map<String, dynamic> _$$CreateGameRequestImplToJson(
  _$CreateGameRequestImpl instance,
) => <String, dynamic>{
  'type': const GameTypeConverter().toJson(instance.type),
  'title': instance.title,
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

_$StartGameSessionResponseImpl _$$StartGameSessionResponseImplFromJson(
  Map<String, dynamic> json,
) => _$StartGameSessionResponseImpl(
  session: GameSessionDto.fromJson(json['session'] as Map<String, dynamic>),
  content: WordMatchingContent.fromJson(
    json['content'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$StartGameSessionResponseImplToJson(
  _$StartGameSessionResponseImpl instance,
) => <String, dynamic>{
  'session': instance.session.toJson(),
  'content': instance.content.toJson(),
};
