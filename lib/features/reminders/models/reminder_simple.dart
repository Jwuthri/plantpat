import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_simple.freezed.dart';
part 'reminder_simple.g.dart';

@freezed
class ReminderSimple with _$ReminderSimple {
  const factory ReminderSimple({
    required String id,
    @JsonKey(name: 'profile_id') required String profileId,
    @JsonKey(name: 'plant_id') required String plantId,
    required String type,
    required String title,
    String? description,
    @JsonKey(name: 'due_date') required DateTime dueDate,
    @Default(false) bool completed,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @Default(false) bool recurring,
    @JsonKey(name: 'recurring_interval') String? recurringInterval,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Plant information from join
    Map<String, dynamic>? plants,
  }) = _ReminderSimple;

  factory ReminderSimple.fromJson(Map<String, dynamic> json) => _$ReminderSimpleFromJson(json);
}

// Helper extension for easy access to reminder data
extension ReminderSimpleHelpers on ReminderSimple {
  // Plant information from linked plant record
  String get plantName => plants?['name'] ?? 'Unknown Plant';
  String get plantSpecies => plants?['species'] ?? '';
  List<dynamic> get plantImages => plants?['images'] ?? [];
  String get plantFirstImage => plantImages.isNotEmpty ? plantImages.first : '';
  
  // Status helpers
  bool get isOverdue => !completed && dueDate.isBefore(DateTime.now());
  bool get isDueToday => !completed && _isSameDay(dueDate, DateTime.now());
  bool get isDueTomorrow => !completed && _isSameDay(dueDate, DateTime.now().add(const Duration(days: 1)));
  
  // Type helpers
  String get typeDisplayName {
    switch (type) {
      case 'watering':
        return 'Watering';
      case 'fertilizing':
        return 'Fertilizing';
      case 'health_check':
        return 'Health Check';
      case 'repotting':
        return 'Repotting';
      case 'custom':
        return 'Custom';
      default:
        return type.replaceFirst(type[0], type[0].toUpperCase());
    }
  }
  
  // Priority based on type and due date
  int get priority {
    if (isOverdue) return 3; // High priority
    if (isDueToday) return 2; // Medium priority
    if (isDueTomorrow) return 1; // Low priority
    return 0; // Normal
  }
  
  // Days until due (negative if overdue)
  int get daysUntilDue {
    final now = DateTime.now();
    final difference = dueDate.difference(DateTime(now.year, now.month, now.day));
    return difference.inDays;
  }
  
  // Formatted due date
  String get formattedDueDate {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    
    if (isOverdue) {
      final daysPast = now.difference(dueDate).inDays;
      if (daysPast == 0) return 'Due today';
      return '$daysPast day${daysPast == 1 ? '' : 's'} overdue';
    }
    
    if (isDueToday) return 'Due today';
    if (isDueTomorrow) return 'Due tomorrow';
    
    final days = difference.inDays;
    if (days < 7) {
      return 'Due in $days day${days == 1 ? '' : 's'}';
    } else if (days < 30) {
      final weeks = (days / 7).round();
      return 'Due in $weeks week${weeks == 1 ? '' : 's'}';
    } else {
      return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
    }
  }
  
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}