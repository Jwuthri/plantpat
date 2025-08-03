// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnosis_database.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiagnosisRecordImpl _$$DiagnosisRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$DiagnosisRecordImpl(
      id: json['id'] as String,
      profileId: json['profile_id'] as String?,
      plantId: json['plant_id'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      aiAnalysis: json['ai_analysis'] as Map<String, dynamic>,
      userFeedback: json['user_feedback'] as Map<String, dynamic>?,
      status: json['status'] as String? ?? 'completed',
      error: json['error'] as Map<String, dynamic>?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      plants: json['plants'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$DiagnosisRecordImplToJson(
        _$DiagnosisRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profile_id': instance.profileId,
      'plant_id': instance.plantId,
      'images': instance.images,
      'ai_analysis': instance.aiAnalysis,
      'user_feedback': instance.userFeedback,
      'status': instance.status,
      'error': instance.error,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'plants': instance.plants,
    };
