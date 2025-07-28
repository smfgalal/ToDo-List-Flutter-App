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
        return currentDate;
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
        date.second,
      );

      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        scheduledDate = tz.TZDateTime(
          tz.local,
          date.year,
          date.month,
          date.day,
          date.hour,
          date.minute,
          date.second,
        ).add(const Duration(days: 1));
      }

      final pending = await notificationPlugin.pendingNotificationRequests();
      if (pending.length >= 60) {
        debugPrint(
          'Warning: Approaching iOS notification limit (${pending.length}/64)',
        );
      }

      await notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationsDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: null,
        payload: '$id|$repeatInterval',
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
            } else {
              debugPrint(
                'Note ID: $noteId not found or finished, no reschedule',
              );
            }
          } catch (e, stack) {
            debugPrint(
              'Error rescheduling notification ID: $noteId: $e\n$stack',
            );
          }
        } else {
          debugPrint(
            'No rescheduling for ID: $noteId, repeat: $repeatInterval',
          );
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
