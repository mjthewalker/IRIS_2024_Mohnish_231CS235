import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications(BuildContext context) async {
    var androidInitialization = AndroidInitializationSettings('@mipmap/ic_launcher');


    var initializationSettings = InitializationSettings(
      android: androidInitialization,

    );

    await _flutterNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (kDebugMode) {
          print('Notification payload: ${response.payload}');
        }
        handleMessage(context, response.payload);
      },
    );

    await _createNotificationChannel();
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      '2',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _flutterNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void firebaseInit(BuildContext context) {
    initLocalNotifications(context);
    FirebaseMessaging.onMessage.listen((message) {
      showNotifications(message);
    });
  }

  Future<void> showNotifications(RemoteMessage message) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      '2',
      'High Importance Notifications',
      channelDescription: 'Your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterNotificationsPlugin.show(
      Random().nextInt(10000),
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: 'your_custom_payload',
    );
  }

  Future<void> requestNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Notifications are authorized");
    } else {
      print("Notifications are not authorized");
    }
  }

  Future<String?> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    print("Device Token: $token");
    return token;
  }

  void isTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((event) {
      print("Token refreshed: $event");
    });
  }

  void handleMessage(BuildContext context, String? payload) {
    if (kDebugMode) {
      print("Notification tapped with payload: $payload");
    }
  }
}
