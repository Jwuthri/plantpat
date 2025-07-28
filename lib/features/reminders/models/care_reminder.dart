import 'package:freezed_annotation/freezed_annotation.dart';

part 'care_reminder.freezed.dart';
part 'care_reminder.g.dart';

@freezed
class CareReminder with _$CareReminder {
  const factory CareReminder({
    required String id,
    required String plantId,
    required String title,
    required String description,
    required ReminderType type,
    required DateTime scheduledDate,
    required ReminderFrequency frequency,
    required ReminderStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDeleted,
    @Default(true) bool isActive,
    DateTime? completedAt,
    DateTime? nextReminderDate,
    String? notes,
    List<String>? instructions,
  }) = _CareReminder;

  factory CareReminder.fromJson(Map<String, dynamic> json) => 
      _$CareReminderFromJson(json);
}

@freezed
class ReminderFrequency with _$ReminderFrequency {
  const factory ReminderFrequency({
    required int interval,
    required FrequencyUnit unit,
    List<int>? daysOfWeek, // 1-7 for Mon-Sun
    int? dayOfMonth, // 1-31
    String? customDescription,
  }) = _ReminderFrequency;

  factory ReminderFrequency.fromJson(Map<String, dynamic> json) => 
      _$ReminderFrequencyFromJson(json);
}

@JsonEnum()
enum ReminderType {
  @JsonValue('watering')
  watering,
  @JsonValue('fertilizing')
  fertilizing,
  @JsonValue('repotting')
  repotting,
  @JsonValue('pruning')
  pruning,
  @JsonValue('misting')
  misting,
  @JsonValue('rotation')
  rotation,
  @JsonValue('inspection')
  inspection,
  @JsonValue('pest_check')
  pestCheck,
  @JsonValue('custom')
  custom,
}

@JsonEnum()
enum ReminderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed,
  @JsonValue('overdue')
  overdue,
  @JsonValue('skipped')
  skipped,
  @JsonValue('snoozed')
  snoozed,
}

@JsonEnum()
enum FrequencyUnit {
  @JsonValue('days')
  days,
  @JsonValue('weeks')
  weeks,
  @JsonValue('months')
  months,
  @JsonValue('years')
  years,
} 