import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "../screens/login_screen.dart";
import "../screens/main_screen.dart";


class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return const MainScreen();
          } else{
            return const LoginScreen();
          }
        },
      )
    );
  }
}