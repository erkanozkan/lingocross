// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionDtoImpl _$$SubscriptionDtoImplFromJson(
  Map<String, dynamic> json,
) => _$SubscriptionDtoImpl(
  plan: const SubscriptionPlanConverter().fromJson(
    (json['plan'] as num).toInt(),
  ),
  status: const SubscriptionStatusConverter().fromJson(
    (json['status'] as num).toInt(),
  ),
  period: const SubscriptionPeriodConverter().fromJson(
    (json['period'] as num).toInt(),
  ),
  expiresAt:
      json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
  isPremium: json['isPremium'] as bool,
  maxClasses: (json['maxClasses'] as num).toInt(),
  maxLessons: (json['maxLessons'] as num).toInt(),
  maxTeachers: (json['maxTeachers'] as num).toInt(),
  ocrEnabled: json['ocrEnabled'] as bool,
);

Map<String, dynamic> _$$SubscriptionDtoImplToJson(
  _$SubscriptionDtoImpl instance,
) => <String, dynamic>{
  'plan': const SubscriptionPlanConverter().toJson(instance.plan),
  'status': const SubscriptionStatusConverter().toJson(instance.status),
  'period': const SubscriptionPeriodConverter().toJson(instance.period),
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'isPremium': instance.isPremium,
  'maxClasses': instance.maxClasses,
  'maxLessons': instance.maxLessons,
  'maxTeachers': instance.maxTeachers,
  'ocrEnabled': instance.ocrEnabled,
};

_$ActivateStubRequestImpl _$$ActivateStubRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ActivateStubRequestImpl(
  period: (json['period'] as num?)?.toInt(),
  trial: json['trial'] as bool? ?? false,
);

Map<String, dynamic> _$$ActivateStubRequestImplToJson(
  _$ActivateStubRequestImpl instance,
) => <String, dynamic>{'period': instance.period, 'trial': instance.trial};
