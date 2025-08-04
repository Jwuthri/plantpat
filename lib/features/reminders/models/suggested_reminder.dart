import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggested_reminder.freezed.dart';
part 'suggested_reminder.g.dart';

@freezed
class SuggestedReminder with _$SuggestedReminder {
  const factory SuggestedReminder({
    required String type,
    required String title, 
    required String description,
    required String frequency,
    required int daysInterval,
    required bool recurring,
    required String priority,
  }) = _SuggestedReminder;

  factory SuggestedReminder.fromJson(Map<String, dynamic> json) =>
      _$SuggestedReminderFromJson(json);
}

@freezed
class SuggestedRemindersResponse with _$SuggestedRemindersResponse {
  const factory SuggestedRemindersResponse({
    required List<SuggestedReminder> suggestedReminders,
  }) = _SuggestedRemindersResponse;

  factory SuggestedRemindersResponse.fromJson(Map<String, dynamic> json) =>
      _$SuggestedRemindersResponseFromJson(json);
}