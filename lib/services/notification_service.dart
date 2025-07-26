// import 'dart:async';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   final notificationPlugin = FlutterLocalNotificationsPlugin();
//   static StreamController<NotificationResponse> streamController =
//       StreamController.broadcast();

//   static void onTap(NotificationResponse response) {
//     streamController.add(response);
//   }

//   //========================================
//   // Initializing Notifications
//   //========================================
//   Future<void> initNotification() async {
//     tz.initializeTimeZones();
//     final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(currentTimeZone));

//     // Prepare Android init settings
//     const initSettingsAndroid = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );

//     // Prepare iOS init settings
//     const initSettingsIos = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     // Init Settings
//     const initSettings = InitializationSettings(
//       android: initSettingsAndroid,
//       iOS: initSettingsIos,
//     );

//     // Initialize the plugin
//     await notificationPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: onTap,
//       onDidReceiveBackgroundNotificationResponse: onTap,
//     );
//   }

//   //========================================
//   // Notifications details Setup
//   //========================================
//   NotificationDetails notificationsDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'tasks_channel_id',
//         'Tasks Notification',
//         channelDescription: 'Tasks notifications Channel',
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//   }

//   //================================================
//   // Show Repeated Daily and Weekly Notifications
//   //================================================
//   Future<void> showRepeatedDailyWeeklyNotifications({
//     required int id,
//     String? title,
//     String? body,
//     required bool isDaily,
//   }) async {
//     return notificationPlugin.periodicallyShow(
//       id,
//       title,
//       body,
//       isDaily ? RepeatInterval.daily : RepeatInterval.weekly,
//       notificationsDetails(),
//       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//       payload: id.toString(),
//     );
//   }

//   //====================================================
//   // Show Repeated Monthly and Yearly Notifications
//   //====================================================
//   Future<void> showRepeatedMonthlyYearlyNotifications({
//     required int id,
//     String? title,
//     String? body,
//     required bool isMonthly,
//   }) async {
//     return notificationPlugin.periodicallyShowWithDuration(
//       id,
//       title,
//       body,
//       isMonthly ? const Duration(days: 30) : const Duration(days: 365),
//       notificationsDetails(),
//       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//       payload: id.toString(),
//     );
//   }

//   //========================================
//   // Show Scheduled Notifications
//   //========================================
//   Future<void> showScheduledNotifications({
//     required int id,
//     String? title,
//     String? body,
//     required DateTime date,
//   }) async {
//     var scheduledDate = tz.TZDateTime(
//       tz.local,
//       date.year,
//       date.month,
//       date.day,
//       date.hour,
//       date.minute,
//     );

//     // Ensure the scheduled date is in the future
//     if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }

//     return notificationPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduledDate,
//       notificationsDetails(),
//       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//       matchDateTimeComponents: DateTimeComponents.time,
//       payload: id.toString(), // Store note ID in payload
//     );
//   }

//   Future<void> cancelAllNotifications() async {
//     await notificationPlugin.cancelAll();
//   }

//   Future<void> cancelNotifications(int id) async {
//     await notificationPlugin.cancel(id);
//   }
// }

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app/main.dart';

class NotificationService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController.broadcast();

  static void onTap(NotificationResponse response) {
    streamController.add(response);
  }

  NotificationService() {
    _listenForNotificationTriggers();
  }

  //========================================
  // Initializing Notifications
  //========================================
  Future<void> initNotification() async {
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    // Prepare Android init settings
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // Prepare iOS init settings
    const initSettingsIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Init Settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIos,
    );

    // Initialize the plugin
    await notificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    // Request permissions
    final androidPlugin = notificationPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final iosPlugin = notificationPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
  }

  //========================================
  // Notifications details Setup
  //========================================
  NotificationDetails notificationsDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'tasks_channel_id',
        'Tasks Notification',
        channelDescription: 'Tasks notifications Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  //========================================
  // Calculate Next Notification Date
  //========================================
  DateTime calculateNextNotificationDate(
    DateTime currentDate,
    String repeatInterval,
  ) {
    switch (repeatInterval) {
      case 'Once a day':
        return currentDate.add(const Duration(days: 1));
      case 'Once a week':
        return currentDate.add(const Duration(days: 7));
      case 'Once a month':
        // Handle edge cases (e.g., Jan 31 -> Feb 28/29)
        final nextMonth = currentDate.month == 12 ? 1 : currentDate.month + 1;
        final nextYear = currentDate.month == 12
            ? currentDate.year + 1
            : currentDate.year;
        final daysInNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        final day = currentDate.day > daysInNextMonth
            ? daysInNextMonth
            : currentDate.day;
        return DateTime(
          nextYear,
          nextMonth,
          day,
          currentDate.hour,
          currentDate.minute,
        );
      case 'Once a year':
        return DateTime(
          currentDate.year + 1,
          currentDate.month,
          currentDate.day,
          currentDate.hour,
          currentDate.minute,
        );
      default:
        return currentDate; // No repeat, return same date (won't be used)
    }
  }

  //========================================
  // Show Scheduled Notifications
  //========================================
  Future<void> showScheduledNotifications({
    required int id,
    String? title,
    String? body,
    required DateTime date,
    String? repeatInterval,
  }) async {
    try {
      var scheduledDate = tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
      );

      // Ensure the scheduled date is in the future
      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        scheduledDate = tz.TZDateTime(
          tz.local,
          date.year,
          date.month,
          date.day,
          date.hour,
          date.minute,
        ).add(const Duration(days: 1));
      }

      await notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationsDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: repeatInterval == 'No repeat'
            ? DateTimeComponents.time
            : null,
        payload:
            '$id|$repeatInterval', // Store ID and repeat interval in payload
      );
    } catch (e, stack) {
      debugPrint('Error scheduling notification ID: $id: $e\n$stack');
      rethrow;
    }
  }

  //========================================
  // Listen for Notification Triggers
  //========================================
  void _listenForNotificationTriggers() {
    streamController.stream.listen((response) async {
      if (response.payload != null) {
        final parts = response.payload!.split('|');
        final noteId = int.tryParse(parts[0]);
        final repeatInterval = parts.length > 1 ? parts[1] : 'No repeat';
        if (noteId != null && repeatInterval != 'No repeat') {
          try {
            // Fetch the note to verify it still exists and is not finished
            final note = await databaseProvider.getNoteById(noteId);
            if (note != null && !(note.isFinished ?? false)) {
              final currentDate = DateTime.now();
              final nextDate = calculateNextNotificationDate(
                currentDate,
                repeatInterval,
              );
              await showScheduledNotifications(
                id: noteId,
                title: note.note,
                body: 'Your task is ready To Do',
                date: nextDate,
                repeatInterval: repeatInterval,
              );
            }
          } catch (e, stack) {
            debugPrint(
              'Error rescheduling notification ID: $noteId: $e\n$stack',
            );
          }
        }
      }
    });
  }

  //========================================
  // Cancel Notifications
  //========================================
  Future<void> cancelNotifications(int id) async {
    try {
      await notificationPlugin.cancel(id);
    } catch (e, stack) {
      debugPrint('Error canceling notification ID: $id: $e\n$stack');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await notificationPlugin.cancelAll();
    } catch (e, stack) {
      debugPrint('Error canceling all notifications: $e\n$stack');
    }
  }
}
