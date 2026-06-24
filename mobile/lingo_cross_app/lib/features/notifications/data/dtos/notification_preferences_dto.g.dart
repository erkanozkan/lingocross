// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationPreferencesDtoImpl _$$NotificationPreferencesDtoImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationPreferencesDtoImpl(
  master: json['master'] as bool? ?? true,
  assigned: json['assigned'] as bool? ?? true,
  reminder: json['reminder'] as bool? ?? true,
  results: json['results'] as bool? ?? true,
  announcements: json['announcements'] as bool? ?? false,
);

Map<String, dynamic> _$$NotificationPreferencesDtoImplToJson(
  _$NotificationPreferencesDtoImpl instance,
) => <String, dynamic>{
  'master': instance.master,
  'assigned': instance.assigned,
  'reminder': instance.reminder,
  'results': instance.results,
  'announcements': instance.announcements,
};
