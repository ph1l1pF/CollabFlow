import 'dart:io';
import 'package:collabflow/models/collaboration.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsRepository {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> scheduleNotification(Collaboration collaboration) async {
    if (collaboration.deadline.notifyDaysBefore == null) {
      throw Exception("No notification date set for this collaboration");
    }
    final notificationDate = collaboration.deadline.date.subtract(
      Duration(days: collaboration.deadline.notifyDaysBefore!),
    ).add(Duration(hours: 9)); // notification should not come at night
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      _toInt(collaboration.id),
      "Deine Collaboration: ${collaboration.title} ist bald fällig!",
      "Deine Deadline läuft ab",
      tz.TZDateTime.from(notificationDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails('collab_channel', 'Collaborations'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> cancelNotification(Collaboration collab) async {
    await _flutterLocalNotificationsPlugin.cancel(_toInt(collab.id));
  }

  Future<bool> notificationsEnabled() async {
    if (Platform.isAndroid) {
      return true;
    }
    final bool? granted = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions();

    return granted ?? false;
  }

  Future<bool> requestPermission() async {
    final result = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    if (result == true) {
      return true;
    } else {
      return false;
    }
  }

  static int _toInt(String uuid) {
    return uuid.hashCode;
  }
}
