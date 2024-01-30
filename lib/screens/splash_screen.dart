import "dart:async";

import "package:flutter/material.dart";

import "../services/auth.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
        ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Auth()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Smart Class Room Booking"),
              Text("v1.0.0"),
            ],
          ),
        ),
      ),
    );
  }
}
