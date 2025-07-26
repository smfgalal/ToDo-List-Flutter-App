import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController.broadcast();

  static void onTap(NotificationResponse response) {
    streamController.add(response);
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
  // Show Notifications
  //========================================
  Future<void> showNotifications({
    required int id,
    String? title,
    String? body,
  }) async {
    return notificationPlugin.show(id, title, body, notificationsDetails());
  }

  //========================================
  // Show Repeated Daily Notifications
  //========================================
  Future<void> showRepeatedDailyNotifications({
    required int id,
    String? title,
    String? body,
  }) async {
    return notificationPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.daily,
      notificationsDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  //========================================
  // Show Scheduled Notifications
  //========================================
  Future<void> showScheduledNotifications({
    required int id,
    String? title,
    String? body,
    required DateTime date,
  }) async {
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
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationsDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: id.toString(), // Store note ID in payload
    );
  }

  Future<void> cancelAllNotifications() async {
    await notificationPlugin.cancelAll();
  }

  Future<void> cancelNotifications(int id) async {
    await notificationPlugin.cancel(id);
  }
}
