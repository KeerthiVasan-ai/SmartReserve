import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:smart_reserve/firebase_options.dart";
import 'package:smart_reserve/feature/auth/presentation/screens/splash_screen.dart';
import 'package:smart_reserve/core/services/gcp_logging_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GCPLog.instance.setupLoggingApi();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      title: "Smart Reserve",
      home: const SplashScreen(),
    );
  }
}
