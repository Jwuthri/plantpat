import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/suggested_reminder.dart';
import '../providers/reminders_provider.dart';
import '../../../core/services/user_profile_service.dart';

/// Service to automatically create reminders from AI suggestions
class AutoReminderService {
  static final _logger = Logger();
  static final _profileService = UserProfileService();

  /// Automatically create reminders from suggested reminders for a specific plant
  static Future<List<String>> createRemindersFromSuggestions(
    WidgetRef ref,
    String plantId,
    List<SuggestedReminder> suggestedReminders,
  ) async {
    if (suggestedReminders.isEmpty) {
      _logger.i('🤖 [AUTO-REMINDER] No suggested reminders to process');
      return [];
    }

    _logger.i('🤖 [AUTO-REMINDER] Creating ${suggestedReminders.length} reminders for plant $plantId');
    
    final remindersNotifier = ref.read(remindersNotifierProvider.notifier);
    final createdReminderIds = <String>[];

    try {
      final profileId = await _profileService.getProfileId();
      
      for (final suggestion in suggestedReminders) {
        try {
          // Calculate the first due date based on the interval
          final now = DateTime.now();
          final dueDate = now.add(Duration(days: suggestion.daysInterval));
          
          _logger.i('🤖 [AUTO-REMINDER] Creating ${suggestion.type} reminder: ${suggestion.title}');
          
          final reminderData = {
            'title': suggestion.title,
            'description': suggestion.description,
            'type': suggestion.type,
            'dueDate': dueDate,
            'recurring': suggestion.recurring,
            'recurringInterval': _mapFrequencyToInterval(suggestion.frequency),
            'priority': suggestion.priority,
          };

          final createdReminder = await remindersNotifier.createReminder(
            profileId: profileId,
            plantId: plantId,
            reminderData: reminderData,
          );

          if (createdReminder != null) {
            createdReminderIds.add(createdReminder.id);
            _logger.i('🤖 [AUTO-REMINDER] ✅ Created reminder: ${createdReminder.title}');
          }
        } catch (e) {
          _logger.e('🤖 [AUTO-REMINDER] ❌ Failed to create reminder ${suggestion.title}: $e');
        }
      }

      _logger.i('🤖 [AUTO-REMINDER] ✅ Successfully created ${createdReminderIds.length} reminders');
      return createdReminderIds;
    } catch (e) {
      _logger.e('🤖 [AUTO-REMINDER] ❌ Failed to create reminders: $e');
      return [];
    }
  }

  /// Map frequency string to interval for recurring reminders
  static String _mapFrequencyToInterval(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return 'daily';
      case 'weekly':
        return 'weekly';
      case 'monthly':
        return 'monthly';
      case 'yearly':
        return 'yearly';
      default:
        return 'weekly'; // Default fallback
    }
  }

  /// Get a user-friendly summary of created reminders
  static String getCreatedRemindersSummary(List<SuggestedReminder> suggestions) {
    if (suggestions.isEmpty) return 'No reminders created';
    
    final reminderTypes = suggestions.map((s) => s.type).toSet();
    final typeCount = reminderTypes.length;
    
    if (typeCount == 1) {
      return '${suggestions.length} ${reminderTypes.first} reminder${suggestions.length > 1 ? 's' : ''} created';
    } else {
      return '${suggestions.length} reminders created (${reminderTypes.join(', ')})';
    }
  }

  /// Check if any of the suggested reminders are high priority
  static bool hasHighPriorityReminders(List<SuggestedReminder> suggestions) {
    return suggestions.any((reminder) => reminder.priority.toLowerCase() == 'high');
  }

  /// Filter suggestions by type
  static List<SuggestedReminder> filterSuggestionsByType(
    List<SuggestedReminder> suggestions,
    String type,
  ) {
    return suggestions.where((reminder) => reminder.type == type).toList();
  }

  /// Group suggestions by priority
  static Map<String, List<SuggestedReminder>> groupSuggestionsByPriority(
    List<SuggestedReminder> suggestions,
  ) {
    final grouped = <String, List<SuggestedReminder>>{};
    
    for (final suggestion in suggestions) {
      final priority = suggestion.priority.toLowerCase();
      grouped.putIfAbsent(priority, () => []).add(suggestion);
    }
    
    return grouped;
  }
}