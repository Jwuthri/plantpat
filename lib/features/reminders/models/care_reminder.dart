class CareReminder {
  final String id;
  final String plantId;
  final String title;
  final String description;
  final ReminderType type;
  final DateTime scheduledDate;
  final ReminderFrequency frequency;
  final ReminderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final bool isActive;
  final DateTime? completedAt;
  final DateTime? nextReminderDate;
  final String? notes;
  final List<String>? instructions;

  const CareReminder({
    required this.id,
    required this.plantId,
    required this.title,
    required this.description,
    required this.type,
    required this.scheduledDate,
    required this.frequency,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    this.isActive = true,
    this.completedAt,
    this.nextReminderDate,
    this.notes,
    this.instructions,
  });

  factory CareReminder.fromJson(Map<String, dynamic> json) => CareReminder(
        id: json['id'] as String,
        plantId: json['plant_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        type: ReminderType.values.firstWhere(
          (e) => e.toString().split('.').last == json['type'],
        ),
        scheduledDate: DateTime.parse(json['scheduled_date'] as String),
        frequency: ReminderFrequency.fromJson(json['frequency'] as Map<String, dynamic>),
        status: ReminderStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status'],
        ),
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        isDeleted: json['is_deleted'] as bool? ?? false,
        isActive: json['is_active'] as bool? ?? true,
        completedAt: json['completed_at'] != null
            ? DateTime.parse(json['completed_at'] as String)
            : null,
        nextReminderDate: json['next_reminder_date'] != null
            ? DateTime.parse(json['next_reminder_date'] as String)
            : null,
        notes: json['notes'] as String?,
        instructions: (json['instructions'] as List?)?.cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'plant_id': plantId,
        'title': title,
        'description': description,
        'type': type.toString().split('.').last,
        'scheduled_date': scheduledDate.toIso8601String(),
        'frequency': frequency.toJson(),
        'status': status.toString().split('.').last,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'is_deleted': isDeleted,
        'is_active': isActive,
        'completed_at': completedAt?.toIso8601String(),
        'next_reminder_date': nextReminderDate?.toIso8601String(),
        'notes': notes,
        'instructions': instructions,
      };
}

class ReminderFrequency {
  final int interval;
  final FrequencyUnit unit;
  final List<int>? daysOfWeek; // 1-7 for Mon-Sun
  final int? dayOfMonth; // 1-31
  final String? customDescription;

  const ReminderFrequency({
    required this.interval,
    required this.unit,
    this.daysOfWeek,
    this.dayOfMonth,
    this.customDescription,
  });

  factory ReminderFrequency.fromJson(Map<String, dynamic> json) =>
      ReminderFrequency(
        interval: json['interval'] as int,
        unit: FrequencyUnit.values.firstWhere(
          (e) => e.toString().split('.').last == json['unit'],
        ),
        daysOfWeek: (json['days_of_week'] as List?)?.cast<int>(),
        dayOfMonth: json['day_of_month'] as int?,
        customDescription: json['custom_description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'interval': interval,
        'unit': unit.toString().split('.').last,
        'days_of_week': daysOfWeek,
        'day_of_month': dayOfMonth,
        'custom_description': customDescription,
      };
}

enum ReminderType {
  watering,
  fertilizing,
  repotting,
  pruning,
  misting,
  rotation,
  inspection,
  pestCheck,
  custom,
}

enum ReminderStatus {
  pending,
  completed,
  overdue,
  skipped,
  snoozed,
}

enum FrequencyUnit {
  days,
  weeks,
  months,
  years,
} 