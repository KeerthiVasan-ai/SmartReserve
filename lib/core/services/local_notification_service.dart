import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_reserve/feature/notification/presentation/screens/notification_screen.dart';
import 'package:smart_reserve/main.dart';

/// Singleton service to show local (on-device) notification banners
/// when the app is in the foreground.
class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance =
      LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// The Android notification channel used for heads-up display.
  static const _channel = AndroidNotificationChannel(
    'smart_reserve_channel', // id
    'Smart Reserve Notifications', // name
    description: 'Slot request and response notifications',
    importance: Importance.high,
  );

  /// Must be called once before [show].
  Future<void> init() async {
    // Create the notification channel on Android.
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    const androidSettings = AndroidInitializationSettings(
      '@drawable/ic_notification',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onTap,
    );
  }

  /// Show a heads-up notification banner.
  Future<void> show({required String title, required String body}) async {
    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique id
      title,
      body,
      NotificationDetails(android: androidDetails),
    );
  }

  /// Called when the user taps the notification banner.
  void _onTap(NotificationResponse response) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const NotificationScreen()),
    );
  }
}
