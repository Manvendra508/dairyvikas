import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// -------------------------------
/// BACKGROUND HANDLER
/// -------------------------------
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// -------------------------------
  /// INIT NOTIFICATIONS
  /// -------------------------------
  Future<void> init() async {
    /// Request Permission
    await _requestPermission();

    /// Get FCM Token
    await getDeviceToken();

    /// Listen Foreground Notification
    _foregroundListener();

    /// Listen Notification Click
    _notificationClickListener();

    /// Background Handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    /// Handle App Opened From Terminated State
    _handleTerminatedState();
    await _initLocalNotifications();
  }

  /// -------------------------------
  /// REQUEST PERMISSION
  /// -------------------------------
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    log(
      "🔔 Notification Permission: "
      "${settings.authorizationStatus}",
    );
  }

  /// -------------------------------
  /// GET DEVICE TOKEN
  /// -------------------------------
  Future<String?> getDeviceToken() async {
    String? token = await _messaging.getToken();

    log("📱 FCM TOKEN: $token");
    //  await updateFcmTokenApi(token);
    return token;
  }

  /// -------------------------------
  /// FOREGROUND LISTENER
  /// -------------------------------
  void _foregroundListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',

        channelDescription: 'This channel is used for important notifications.',

        importance: Importance.max,
        priority: Priority.high,

        playSound: true,

        sound: RawResourceAndroidNotificationSound('notification_sound'),

        icon: '@mipmap/ic_launcher',

        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),

        styleInformation: const BigTextStyleInformation(''),
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        title: message.notification?.title ?? 'Notification',

        body: message.notification?.body ?? '',
        payload: 'milk_collection',
        notificationDetails: notificationDetails,
        id: message.hashCode,
      );
    });
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.initialize(settings: settings);
  }

  /// -------------------------------
  /// NOTIFICATION CLICK LISTENER
  /// -------------------------------
  void _notificationClickListener() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log(
        "🟢 Notification Clicked: "
        "${message.notification?.title}",
      );

      /// Example:
      ///
      /// final type = message.data['type'];
      ///
      /// if (type == 'order') {
      ///   AppNavigation.goToOrdersPage();
      /// }
    });
  }

  /// -------------------------------
  /// HANDLE TERMINATED STATE
  /// -------------------------------
  Future<void> _handleTerminatedState() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      log(
        "🚀 App Opened From Terminated State: "
        "${initialMessage.notification?.title}",
      );

      /// Handle Navigation
    }
  }

  /// -------------------------------
  /// SUBSCRIBE TO TOPIC
  /// -------------------------------
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);

    log("✅ Subscribed to: $topic");
  }

  /// -------------------------------
  /// UNSUBSCRIBE TOPIC
  /// -------------------------------
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);

    log("❌ Unsubscribed from: $topic");
  }

  /// -------------------------------
  /// REFRESH TOKEN LISTENER
  /// -------------------------------
  void tokenRefreshListener() {
    _messaging.onTokenRefresh.listen((newToken) {
      log("♻️ New FCM Token: $newToken");

      /// TODO:

      /// Send to backend
      //  await updateFcmTokenApi(newToken);
    });
  }
}
