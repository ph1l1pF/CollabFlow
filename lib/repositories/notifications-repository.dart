import 'dart:io';

import 'package:collabflow/models/collaboration.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsRepository {

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> scheduleNotification(
    Collaboration collaboration,
  ) async {
    if (collaboration.deadline.notificationDate == null) {
      throw Exception("No notification date set for this collaboration");
    }
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      collaboration.id.hashCode,
      "Deine Collaboration: ${collaboration.title} ist bald fällig!",
      "Deine Deadline läuft ab",
      tz.TZDateTime.from(collaboration.deadline.notificationDate!, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails('collab_channel', 'Collaborations'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode : AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> cancelNotification(Collaboration collab) async {
    await _flutterLocalNotificationsPlugin.cancel(collab.id.hashCode);
  }

  notificationsEnabled() async{
    if(Platform.isAndroid) {
      return true;
    }
    final bool? granted = await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions();
    
    return granted ?? false;
  }


Future<bool> requestPermission() async {
    final result = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    if (result == true) {
      return true;
    } else {
      return false;
    }
  }
}