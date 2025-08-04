// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_simple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReminderSimpleImpl _$$ReminderSimpleImplFromJson(Map<String, dynamic> json) =>
    _$ReminderSimpleImpl(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      plantId: json['plant_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: DateTime.parse(json['due_date'] as String),
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      recurring: json['recurring'] as bool? ?? false,
      recurringInterval: json['recurring_interval'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      plants: json['plants'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ReminderSimpleImplToJson(
        _$ReminderSimpleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profile_id': instance.profileId,
      'plant_id': instance.plantId,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'due_date': instance.dueDate.toIso8601String(),
      'completed': instance.completed,
      'completed_at': instance.completedAt?.toIso8601String(),
      'recurring': instance.recurring,
      'recurring_interval': instance.recurringInterval,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'plants': instance.plants,
    };
