import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../models/reminder.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle notification tap
    // You can navigate to specific screens or perform actions here
  }

  Future<void> scheduleReminder(Reminder reminder) async {
    if (!reminder.isActive) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'blood_pressure_reminders',
      'Blood Pressure Reminders',
      channelDescription: 'Reminders to measure blood pressure',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    switch (reminder.frequency) {
      case ReminderFrequency.daily:
        await _scheduleDailyReminder(reminder, platformChannelSpecifics);
        break;
      case ReminderFrequency.weekly:
        await _scheduleWeeklyReminder(reminder, platformChannelSpecifics);
        break;
      case ReminderFrequency.custom:
        await _scheduleCustomReminder(reminder, platformChannelSpecifics);
        break;
    }
  }

  Future<void> _scheduleDailyReminder(
      Reminder reminder, NotificationDetails platformChannelSpecifics) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      reminder.id ?? 0,
      reminder.title,
      reminder.description ?? 'Time to measure your blood pressure',
      _nextInstanceOfTime(reminder.time),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleWeeklyReminder(
      Reminder reminder, NotificationDetails platformChannelSpecifics) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      reminder.id ?? 0,
      reminder.title,
      reminder.description ?? 'Time to measure your blood pressure',
      _nextInstanceOfTime(reminder.time),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> _scheduleCustomReminder(
      Reminder reminder, NotificationDetails platformChannelSpecifics) async {
    // For custom reminders, schedule for each specified day of the week
    for (int dayOfWeek in reminder.daysOfWeek) {
      final nextInstance = _nextInstanceOfDayAndTime(dayOfWeek, reminder.time);
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        (reminder.id ?? 0) * 10 + dayOfWeek, // Unique ID for each day
        reminder.title,
        reminder.description ?? 'Time to measure your blood pressure',
        nextInstance,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  TZDateTime _nextInstanceOfTime(DateTime time) {
    final now = TZDateTime.now(local);
    TZDateTime scheduledDate = TZDateTime(
      local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  TZDateTime _nextInstanceOfDayAndTime(int dayOfWeek, DateTime time) {
    final now = TZDateTime.now(local);
    int daysUntilTarget = (dayOfWeek - now.weekday) % 7;
    if (daysUntilTarget == 0 && now.hour >= time.hour && now.minute >= time.minute) {
      daysUntilTarget = 7; // Schedule for next week if time has passed today
    }
    
    return TZDateTime(
      local,
      now.year,
      now.month,
      now.day + daysUntilTarget,
      time.hour,
      time.minute,
    );
  }

  Future<void> cancelReminder(int reminderId) async {
    await _flutterLocalNotificationsPlugin.cancel(reminderId);
    
    // Cancel custom reminder notifications for all days
    for (int i = 1; i <= 7; i++) {
      await _flutterLocalNotificationsPlugin.cancel(reminderId * 10 + i);
    }
  }

  Future<void> cancelAllReminders() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'instant_notifications',
      'Instant Notifications',
      channelDescription: 'Instant notifications for the app',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}

// Add this to the top of the file after other imports
final tz.Location local = tz.getLocation('America/Sao_Paulo');

// Initialize timezone data
Future<void> initializeTimeZone() async {
  tz_data.initializeTimeZones();
}

// Type alias for TZDateTime
typedef TZDateTime = tz.TZDateTime;