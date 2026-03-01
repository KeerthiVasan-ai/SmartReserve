import 'dart:io';

import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:smart_reserve/firebase_options.dart";
import 'package:smart_reserve/feature/auth/presentation/screens/splash_screen.dart';
import 'package:smart_reserve/core/services/gcp_credentials.dart';
import 'package:smart_reserve/core/services/gcp_logging_service.dart';
import 'package:smart_reserve/core/services/local_notification_service.dart';
import 'package:smart_reserve/feature/notification/presentation/screens/notification_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global navigator key for navigating from background message handlers.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Background message handler – must be a top-level function.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalNotificationService.instance.init();

  final notification = message.notification;
  if (notification != null) {
    await LocalNotificationService.instance.show(
      title: notification.title ?? 'Smart Reserve',
      body: notification.body ?? 'New notification',
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable edge-to-edge display
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
    );
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GCPCredentials.instance.load();
  await GCPLog.instance.setupLoggingApi();

  // Initialise local notification plugin (creates channel + handles taps).
  await LocalNotificationService.instance.init();

  // Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request notification permissions
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(alert: true, badge: true, sound: true);

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('[FCM] onMessage received: ${message.messageId}');
    debugPrint('[FCM] notification: ${message.notification?.title} - ${message.notification?.body}');
    debugPrint('[FCM] data: ${message.data}');
    final notification = message.notification;
    if (notification != null) {
      // System heads-up notification
      LocalNotificationService.instance.show(
        title: notification.title ?? 'Smart Reserve',
        body: notification.body ?? 'New notification',
      );
    }
  });

  // Handle background message tap (app was in background)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const NotificationScreen()),
    );
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: "Smart Reserve",
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}

