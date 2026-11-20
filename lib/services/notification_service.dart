import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'reminder_channel';
  static const String channelName = 'Reminder Notifications';

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    if (!Platform.isAndroid) {
      _isInitialized = true;
      return;
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification clicked: ${details.payload}');
      },
    );

    final androidImplementation = notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        channelId,
        channelName,
        description: 'Channel untuk reminder notifikasi',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );
      await androidImplementation.createNotificationChannel(channel);
      await androidImplementation.requestNotificationsPermission();
    }

    _isInitialized = true;
  }

  Future<bool?> requestPermission() async {
    if (!Platform.isAndroid) return null;
    try {
      final androidImplementation = notificationPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        return await androidImplementation.requestNotificationsPermission();
      }
    } catch (e) {
      debugPrint('Request permission error: $e');
    }
    return null;
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    if (!Platform.isAndroid) return;

    try {
      if (!_isInitialized) {
        await init();
      }

      final androidImplementation = notificationPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? areEnabled =
            await androidImplementation.areNotificationsEnabled();
        if (areEnabled == false) {
          await androidImplementation.requestNotificationsPermission();
        }
      }

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: 'Channel untuk reminder notifikasi',
        importance: Importance.max,
        priority: Priority.max,
        icon: '@mipmap/ic_launcher',
        playSound: true,
        enableVibration: true,
      );

      const NotificationDetails notifDetails = NotificationDetails(
        android: androidDetails,
      );

      await notificationPlugin.show(0, title, body, notifDetails);
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }
}
