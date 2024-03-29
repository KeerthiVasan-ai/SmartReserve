import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:smart_reserve/firebase_options.dart";
import "package:smart_reserve/screens/splash_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
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
