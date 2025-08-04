import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../core/config/api_config.dart';
import '../models/reminder_simple.dart';
import '../../../core/services/user_profile_service.dart';
import '../../../core/services/notification_service.dart';

class RemindersNotifier extends StateNotifier<AsyncValue<List<ReminderSimple>>> {
  RemindersNotifier() : super(const AsyncValue.loading()) {
    _initialize();
  }
  
  final _logger = Logger();
  final _dio = Dio();
  final _profileService = UserProfileService();
  


  void _initialize() async {
    try {
      final reminders = await _fetchReminders();
      state = AsyncValue.data(reminders);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Method to manually refresh reminders
  Future<void> refreshReminders() async {
    state = const AsyncValue.loading();
    try {
      final reminders = await _fetchReminders();
      state = AsyncValue.data(reminders);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Get device-based profile ID using shared service
  Future<String> _getDeviceProfileId() async {
    return await _profileService.getProfileId();
  }

  Future<List<ReminderSimple>> _fetchReminders({String? plantId, String? status}) async {
    try {
      // Get current user's profile ID
      final profileId = await _getDeviceProfileId();
      _logger.i('📅 [REMINDERS] 👤 Fetching reminders for profile: $profileId');
      
      // Build query parameters
      final queryParams = <String, dynamic>{
        'profileId': profileId,
      };
      
      if (plantId != null) queryParams['plantId'] = plantId;
      if (status != null) queryParams['status'] = status;
      
      final response = await _dio.get(
        ApiConfig.remindersList,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          final remindersList = responseData['reminders'] as List;
          _logger.i('📅 [REMINDERS] 📊 Query results: ${remindersList.length} reminders found');
          
          final reminders = <ReminderSimple>[];
          for (final json in remindersList) {
            try {
              final reminder = ReminderSimple.fromJson(json as Map<String, dynamic>);
              reminders.add(reminder);
            } catch (reminderError) {
              _logger.w('📅 [REMINDERS] Failed to parse reminder: $reminderError, data: $json');
              // Skip invalid reminders but continue processing others
            }
          }
          
          // Sort by priority and due date
          reminders.sort((a, b) {
            final priorityCompare = b.priority.compareTo(a.priority);
            if (priorityCompare != 0) return priorityCompare;
            return a.dueDate.compareTo(b.dueDate);
          });
          
          _logger.i('📅 [REMINDERS] Successfully loaded ${reminders.length} reminders');
          return reminders;
        } else {
          throw Exception('Backend returned error: ${responseData['error']}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.statusMessage}');
      }
    } catch (e) {
      _logger.e('Error fetching reminders: $e');
      throw Exception('Failed to load reminders: $e');
    }
  }

  Future<ReminderSimple> createReminder({
    required String plantId,
    required String type,
    required String title,
    String? description,
    required DateTime dueDate,
    bool recurring = false,
    String? recurringInterval,
  }) async {
    try {
      final profileId = await _getDeviceProfileId();
      _logger.i('📅 [REMINDERS] 💾 Creating reminder: $title for plant: $plantId');
      
      final requestBody = {
        'profileId': profileId,
        'plantId': plantId,
        'type': type,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'recurring': recurring,
        'recurringInterval': recurringInterval,
      };

      final response = await _dio.post(
        ApiConfig.remindersCreate,
        data: requestBody,
      );

      if (response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          final reminder = ReminderSimple.fromJson(responseData['reminder']);
          _logger.i('📅 [REMINDERS] ✅ Reminder created successfully: ${reminder.id}');
          
          // Schedule notification for the reminder
          try {
            await NotificationService.scheduleReminderNotification(reminder);
            _logger.i('📅 [REMINDERS] 🔔 Notification scheduled for: ${reminder.title}');
          } catch (e) {
            _logger.w('📅 [REMINDERS] ⚠️ Failed to schedule notification: $e');
          }
          
          // Refresh the state
          refreshReminders();
          return reminder;
        } else {
          throw Exception('Backend returned error: ${responseData['error']}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.statusMessage}');
      }
    } catch (e) {
      _logger.e('Error creating reminder: $e');
      throw Exception('Failed to create reminder: $e');
    }
  }

  Future<ReminderSimple> completeReminder(String reminderId) async {
    try {
      final profileId = await _getDeviceProfileId();
      _logger.i('📅 [REMINDERS] ✅ Completing reminder: $reminderId');
      
      final requestBody = {
        'reminderId': reminderId,
        'profileId': profileId,
      };

      final response = await _dio.post(
        ApiConfig.remindersComplete,
        data: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          final reminder = ReminderSimple.fromJson(responseData['reminder']);
          _logger.i('📅 [REMINDERS] ✅ Reminder completed successfully: ${reminder.id}');
          
          // Cancel the scheduled notification
          try {
            await NotificationService.cancelReminderNotification(reminder.id);
            _logger.i('📅 [REMINDERS] 🔕 Notification cancelled for: ${reminder.title}');
          } catch (e) {
            _logger.w('📅 [REMINDERS] ⚠️ Failed to cancel notification: $e');
          }
          
          // Refresh the state
          refreshReminders();
          return reminder;
        } else {
          throw Exception('Backend returned error: ${responseData['error']}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.statusMessage}');
      }
    } catch (e) {
      _logger.e('Error completing reminder: $e');
      throw Exception('Failed to complete reminder: $e');
    }
  }

  // Get reminders for a specific plant
  Future<List<ReminderSimple>> getPlantReminders(String plantId) async {
    return await _fetchReminders(plantId: plantId);
  }

  // Get only pending reminders
  Future<List<ReminderSimple>> getPendingReminders() async {
    return await _fetchReminders(status: 'pending');
  }
}

// Provider for the reminders notifier
final remindersNotifierProvider = StateNotifierProvider<RemindersNotifier, AsyncValue<List<ReminderSimple>>>((ref) {
  return RemindersNotifier();
});

// Provider to get pending reminders only
final pendingRemindersProvider = Provider<AsyncValue<List<ReminderSimple>>>((ref) {
  final reminders = ref.watch(remindersNotifierProvider);
  return reminders.when(
    data: (remindersList) {
      final pending = remindersList.where((reminder) => !reminder.completed).toList();
      return AsyncValue.data(pending);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Provider to get overdue reminders
final overdueRemindersProvider = Provider<AsyncValue<List<ReminderSimple>>>((ref) {
  final reminders = ref.watch(remindersNotifierProvider);
  return reminders.when(
    data: (remindersList) {
      final overdue = remindersList.where((reminder) => reminder.isOverdue).toList();
      return AsyncValue.data(overdue);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Provider to get reminders for a specific plant
final plantRemindersProvider = Provider.family<AsyncValue<List<ReminderSimple>>, String>((ref, plantId) {
  final reminders = ref.watch(remindersNotifierProvider);
  return reminders.when(
    data: (remindersList) {
      final plantReminders = remindersList.where((reminder) => reminder.plantId == plantId).toList();
      return AsyncValue.data(plantReminders);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});