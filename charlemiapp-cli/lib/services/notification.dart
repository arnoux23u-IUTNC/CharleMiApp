import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationApi{
  static final _notifications = FlutterLocalNotificationsPlugin();
  
  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',                       //a renseigner
        'channel name',                     //a renseigner
        channelDescription: 'description',  //a renseigner
        importance: Importance.max,
        priority: Priority.high,
        icon: "app_icon",
        color: Colors.blue,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future showNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );
}