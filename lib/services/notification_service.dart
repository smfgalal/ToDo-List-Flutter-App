import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  final bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  //========================================
  //Initializing Notifications
  //========================================
  Future<void> initNotification() async {
    if (_isInitialized) return; // Prevent re-initialization

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    //Prepare Android init settings
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    //Prepare Ios init settings
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

    // Finally Initialize the plugin
    await notificationPlugin.initialize(
      initSettings,
      // onDidReceiveNotificationResponse: (details) {},
      // onDidReceiveBackgroundNotificationResponse: (details) {},
    );
  }

  //========================================
  //Notifications details Setup
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
  //Show Notifications
  //========================================
  Future<void> showNotifications({
    required int id,
    String? title,
    String? body,
  }) async {
    return notificationPlugin.show(id, title, body, notificationsDetails());
  }

  //========================================
  //Show Repeated Daily Notifications
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
  //Show Scheduled Notifications
  //========================================
  Future<void> showScheduledNotifications({
    int? id,
  String? title,
     String? body,
     DateTime? date,
  }) async {
    // final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      date!.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
    );
    return notificationPlugin.zonedSchedule(
      id!,
      title,
      body,
      scheduledDate,
      notificationsDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotifications() async {
    await notificationPlugin.cancelAll();
  }
}
