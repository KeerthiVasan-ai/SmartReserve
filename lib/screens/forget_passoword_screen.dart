import "package:firebase_auth/firebase_auth.dart";
import "dart:developer" as dev;
import "package:flutter/material.dart";
import "package:smart_reserve/screens/login_screen.dart";

import "../widgets/build_app_bar.dart";
import "/widgets/build_elevated_button.dart";
import "/widgets/build_login_text_form.dart";

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreen();
}

class _ForgetPasswordScreen extends State<ForgetPasswordScreen> {
  final _forgetPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController mail = TextEditingController();

  void _sendMail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: mail.text);
      dev.log("Mail Sent", name: "Success");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Mail Sent")));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your Email")));
      dev.log(e.toString(), name: "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Login"),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background/check2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Form(
              key: _forgetPasswordFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Get Back your Account!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  BuildLoginTextForm(
                    controller: mail,
                    label: "UserName",
                    readOnly: false,
                    obscureText: false,
                    isPassword: false,
                  ),
                  const SizedBox(height: 10.0),
                  BuildElevatedButton(
                    actionOnButton: _sendMail,
                    buttonText: "Send Mail",
                  )
                  // buildElevatedButton(onClick, "Login"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
