import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  static final FlutterLocalNotificationsPlugin _pluginInstance = FlutterLocalNotificationsPlugin();

  static Future backgroundMessageHandler(RemoteMessage msg) async {
    print('messageHandler');
    print('background message ${msg.notification!.body}');
  }

  static Future onClickHandler(RemoteMessage msg) async {
    print('messageHandler');
    print('background message ${msg.notification!.body}');
  }

  static Future foregroundMessageHandler(RemoteMessage msg, AndroidNotificationChannel channel) async {
    print('messageHandler foreground');
  }

  static void initialize(FirebaseMessaging firebaseMessaging) async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((msg) => PushNotificationService.foregroundMessageHandler(msg, channel));
      FirebaseMessaging.onBackgroundMessage(PushNotificationService.backgroundMessageHandler);
      FirebaseMessaging.onMessageOpenedApp.listen(PushNotificationService.onClickHandler);
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    }
  }
}
