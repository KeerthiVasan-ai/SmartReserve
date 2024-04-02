import "package:firebase_auth/firebase_auth.dart";
import "dart:developer" as dev;
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:smart_reserve/screens/login_screen.dart";
import "package:smart_reserve/widgets/ui/background_shapes.dart";

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
      if(e.code == 'invalid-email'){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid Email")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundShapes(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar("Forget Password"),
        body: SafeArea(
          child: Center(
            child: Form(
              key: _forgetPasswordFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Get Back your Account!",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  BuildLoginTextForm(
                    controller: mail,
                    label: "Email",
                    readOnly: false,
                    obscureText: false,
                    isPassword: false,
                  ),
                  const SizedBox(height: 10.0),
                  BuildElevatedButton(
                    actionOnButton: _sendMail,
                    buttonText: "Get Password Reset Link",
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
