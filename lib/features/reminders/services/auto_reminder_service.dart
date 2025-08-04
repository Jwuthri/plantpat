import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/suggested_reminder.dart';
import '../providers/reminders_provider.dart';
/// Service to automatically create reminders from AI suggestions
class AutoReminderService {
  static final _logger = Logger();

  /// Automatically create reminders from suggested reminders for a specific plant
  static Future<List<String>> createRemindersFromSuggestions(
    Ref ref,
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
      // Group suggestions by type to create only one reminder per type
      final groupedSuggestions = _groupSuggestionsByType(suggestedReminders);
      
      for (final entry in groupedSuggestions.entries) {
        final type = entry.key;
        final suggestions = entry.value;
        
        // Combine suggestions of the same type into one optimized reminder
        final combinedReminder = _combineSuggestionsOfSameType(suggestions);
        final validType = _mapToValidReminderType(combinedReminder.type);
        
        try {
          // Calculate the first due date based on the interval
          final now = DateTime.now();
          final dueDate = now.add(Duration(days: combinedReminder.daysInterval));
          
          if (validType != combinedReminder.type) {
            _logger.i('🤖 [AUTO-REMINDER] Mapped "${combinedReminder.type}" → "$validType"');
          }
          _logger.i('🤖 [AUTO-REMINDER] Creating $validType reminder: ${combinedReminder.title}');
          
          final createdReminder = await remindersNotifier.createReminder(
            plantId: plantId,
            type: validType,
            title: combinedReminder.title,
            description: combinedReminder.description,
            dueDate: dueDate,
            recurring: combinedReminder.recurring,
            recurringInterval: _mapFrequencyToInterval(combinedReminder.frequency),
          );

          if (createdReminder != null) {
            createdReminderIds.add(createdReminder.id);
            _logger.i('🤖 [AUTO-REMINDER] ✅ Created $validType reminder: ${createdReminder.title}');
          }
        } catch (e) {
          _logger.e('🤖 [AUTO-REMINDER] ❌ Failed to create $validType reminder: $e');
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
      return '1 ${reminderTypes.first} reminder created';
    } else {
      return '$typeCount reminders created (${reminderTypes.join(', ')})';
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

  /// Group suggestions by type (internal helper)
  static Map<String, List<SuggestedReminder>> _groupSuggestionsByType(
    List<SuggestedReminder> suggestions,
  ) {
    final grouped = <String, List<SuggestedReminder>>{};
    
    for (final suggestion in suggestions) {
      grouped.putIfAbsent(suggestion.type, () => []).add(suggestion);
    }
    
    return grouped;
  }

  /// Combine multiple suggestions of the same type into one optimized reminder
  static SuggestedReminder _combineSuggestionsOfSameType(
    List<SuggestedReminder> suggestions,
  ) {
    if (suggestions.length == 1) {
      return suggestions.first;
    }

    // Use the highest priority suggestion as base
    final sortedByPriority = suggestions.toList()
      ..sort((a, b) => _priorityValue(b.priority).compareTo(_priorityValue(a.priority)));
    
    final primary = sortedByPriority.first;
    
    // Use the most conservative (shortest) interval for safety
    final shortestInterval = suggestions
        .map((s) => s.daysInterval)
        .reduce((a, b) => a < b ? a : b);
    
    // Combine descriptions for better context
    final descriptions = suggestions
        .map((s) => s.description)
        .where((desc) => desc.isNotEmpty)
        .toSet()
        .join('. ');
    
    return SuggestedReminder(
      type: primary.type,
      title: primary.title,
      description: descriptions.isNotEmpty ? descriptions : primary.description,
      daysInterval: shortestInterval,
      frequency: primary.frequency,
      priority: primary.priority,
      recurring: primary.recurring,
    );
  }

  /// Convert priority string to numeric value for sorting
  static int _priorityValue(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 1;
    }
  }

  /// Map AI-suggested reminder types to valid backend types
  static String _mapToValidReminderType(String aiType) {
    switch (aiType.toLowerCase()) {
      case 'watering':
      case 'water':
        return 'watering';
      case 'fertilizing':
      case 'fertilizer':
      case 'feeding':
      case 'nutrients':
        return 'fertilizing';
      case 'health_check':
      case 'health check':
      case 'inspection':
      case 'monitoring':
        return 'health_check';
      case 'repotting':
      case 'repot':
      case 'transplanting':
        return 'repotting';
      case 'humidity':
      case 'misting':
      case 'air_humidity':
      case 'environment':
      case 'lighting':
      case 'light':
      case 'pruning':
      case 'trimming':
      case 'deadheading':
      case 'cleaning':
      case 'rotation':
      case 'positioning':
        return 'custom'; // Map environmental/care tasks to custom
      default:
        return 'custom'; // Default fallback for unknown types
    }
  }
}