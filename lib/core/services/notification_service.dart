import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:go_router/go_router.dart';

import '../../features/reminders/models/reminder_simple.dart';

class NotificationService {
  static final _logger = Logger();
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  static bool _initialized = false;
  static Function(String)? _navigationCallback;

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_initialized) return;

    _logger.i('🔔 [NOTIFICATIONS] Initializing notification service');

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: false,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'plant_care',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain(
              'mark_complete',
              'Mark Complete',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
            DarwinNotificationAction.plain(
              'snooze',
              'Snooze 1h',
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
    _logger.i('🔔 [NOTIFICATIONS] ✅ Initialized successfully');
  }

  /// Set navigation callback for handling notification taps
  static void setNavigationCallback(Function(String) callback) {
    _navigationCallback = callback;
  }

  /// Handle notification tap - navigate to reminder detail
  static void _onNotificationTapped(NotificationResponse response) {
    _logger.i('🔔 [NOTIFICATIONS] 👆 Notification tapped: ${response.payload}');
    
    if (response.payload != null && _navigationCallback != null) {
      final reminderId = response.payload!;
      _logger.i('🔔 [NOTIFICATIONS] 📱 Navigate to reminder: $reminderId');
      _navigationCallback!(reminderId);
    }
  }

  /// Schedule a notification for a reminder
  static Future<void> scheduleReminderNotification(ReminderSimple reminder) async {
    if (!_initialized) await initialize();

    try {
      _logger.i('🔔 [NOTIFICATIONS] 📅 Scheduling notification for: ${reminder.title}');

      // Download and prepare plant image for notification
      Uint8List? imageBytes;
      if (reminder.plantFirstImage.isNotEmpty) {
        try {
          imageBytes = await _downloadImageForNotification(reminder.plantFirstImage);
        } catch (e) {
          _logger.w('🔔 [NOTIFICATIONS] ⚠️ Failed to download plant image: $e');
        }
      }

      // Create notification details
      final androidDetails = AndroidNotificationDetails(
        'plant_care_reminders',
        'Plant Care Reminders',
        channelDescription: 'Notifications for plant care tasks',
        importance: Importance.high,
        priority: Priority.high,
        largeIcon: imageBytes != null ? ByteArrayAndroidBitmap(imageBytes) : null,
        styleInformation: imageBytes != null 
            ? BigPictureStyleInformation(
                ByteArrayAndroidBitmap(imageBytes),
                contentTitle: '🌱 ${reminder.plantName}',
                summaryText: reminder.typeDisplayName,
              )
            : BigTextStyleInformation(
                '${reminder.plantName} needs ${reminder.typeDisplayName.toLowerCase()}',
                contentTitle: '🌱 ${reminder.plantName}',
              ),
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        presentBanner: true,
        presentList: true,
        sound: 'default',
        subtitle: reminder.plantName,
        categoryIdentifier: 'plant_care',
        threadIdentifier: 'plant_care_${reminder.plantId}',
        attachments: imageBytes != null 
            ? [DarwinNotificationAttachment(
                await _saveImageToTemp(imageBytes, reminder.id),
                hideThumbnail: false,
              )]
            : null,
        interruptionLevel: InterruptionLevel.active,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Schedule the notification
      await _notifications.zonedSchedule(
        reminder.id.hashCode, // Use reminder ID hash as notification ID
        '🌱 ${reminder.typeDisplayName} Time!',
        '${reminder.plantName} needs ${reminder.typeDisplayName.toLowerCase()}',
        _convertToTZDateTime(reminder.dueDate),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: 
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: reminder.id, // Pass reminder ID for navigation
      );

      _logger.i('🔔 [NOTIFICATIONS] ✅ Scheduled for: ${reminder.dueDate}');
    } catch (e) {
      _logger.e('🔔 [NOTIFICATIONS] ❌ Failed to schedule: $e');
    }
  }

  /// Cancel a scheduled notification
  static Future<void> cancelReminderNotification(String reminderId) async {
    if (!_initialized) await initialize();

    try {
      await _notifications.cancel(reminderId.hashCode);
      _logger.i('🔔 [NOTIFICATIONS] 🗑️ Cancelled notification for: $reminderId');
    } catch (e) {
      _logger.e('🔔 [NOTIFICATIONS] ❌ Failed to cancel: $e');
    }
  }

  /// Update notification when reminder is completed
  static Future<void> updateReminderNotification(ReminderSimple reminder) async {
    if (reminder.completed) {
      await cancelReminderNotification(reminder.id);
    } else {
      await scheduleReminderNotification(reminder);
    }
  }

  /// Download image for notification display
  static Future<Uint8List?> _downloadImageForNotification(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      _logger.w('🔔 [NOTIFICATIONS] ⚠️ Image download failed: $e');
    }
    return null;
  }

  /// Save image to temporary file for iOS attachments
  static Future<String> _saveImageToTemp(Uint8List imageBytes, String reminderId) async {
    final tempDir = Platform.isIOS ? '/tmp' : '/data/data/com.example.plantpal/cache';
    final fileName = 'plant_${reminderId.substring(0, 8)}.jpg';
    final filePath = '$tempDir/$fileName';
    
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
    return filePath;
  }

  /// Convert DateTime to TZDateTime (simplified for now)
  static tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
    // For now, using a simple conversion
    // In production, you might want to use timezone package
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  /// Request notification permissions (call on app start)
  static Future<bool> requestPermissions() async {
    if (!_initialized) await initialize();

    if (Platform.isIOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: false,
          );
      
      _logger.i('🔔 [NOTIFICATIONS] iOS permissions requested successfully');
      
      return result ?? false;
    } else if (Platform.isAndroid) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return result ?? false;
    }
    
    return true;
  }


}