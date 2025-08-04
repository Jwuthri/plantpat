// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggested_reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SuggestedReminderImpl _$$SuggestedReminderImplFromJson(
        Map<String, dynamic> json) =>
    _$SuggestedReminderImpl(
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      frequency: json['frequency'] as String,
      daysInterval: (json['daysInterval'] as num).toInt(),
      recurring: json['recurring'] as bool,
      priority: json['priority'] as String,
    );

Map<String, dynamic> _$$SuggestedReminderImplToJson(
        _$SuggestedReminderImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'frequency': instance.frequency,
      'daysInterval': instance.daysInterval,
      'recurring': instance.recurring,
      'priority': instance.priority,
    };

_$SuggestedRemindersResponseImpl _$$SuggestedRemindersResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SuggestedRemindersResponseImpl(
      suggestedReminders: (json['suggestedReminders'] as List<dynamic>)
          .map((e) => SuggestedReminder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SuggestedRemindersResponseImplToJson(
        _$SuggestedRemindersResponseImpl instance) =>
    <String, dynamic>{
      'suggestedReminders': instance.suggestedReminders,
    };
