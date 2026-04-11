import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:smart_reserve/core/theme/app_fonts.dart';
import 'package:smart_reserve/core/services/gcp_logging_service.dart';
import 'package:smart_reserve/feature/auth/presentation/widgets/forget_password_bottom_sheet.dart';
import 'package:smart_reserve/core/presentation/widgets/background_shapes.dart';

import 'package:smart_reserve/core/presentation/widgets/custom_button.dart';
import 'package:smart_reserve/feature/auth/presentation/widgets/login_text_form.dart';
import 'package:smart_reserve/core/presentation/widgets/smart_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userName.text.trim(),
          password: password.text,
        );
        // Auth state listener in Auth wrapper will navigate to MainScreen.
        // No need to pop or navigate here, but we reset loading just in case.
        GCPLog.info('User logged in successfully');
        if (mounted) setState(() => _isLoading = false);
      } on FirebaseAuthException catch (e) {
        GCPLog.error('Login auth error: ${e.code}', error: e);
        if (!mounted) return;
        setState(() => _isLoading = false);
        if (e.code == 'invalid-email') {
          SmartSnackBar.showError(context, "The email address you entered is invalid.");
        } else if (e.code == 'invalid-credential') {
          SmartSnackBar.showError(context, "Mismatch in credentials. Please check and try again.");
        }
      } catch (e) {
        GCPLog.error('Login unexpected error', error: e);
        if (!mounted) return;
        setState(() => _isLoading = false);
        SmartSnackBar.showError(
          context,
          "An unexpected error occurred. Our team is looking into it.",
          title: "Login Failed",
        );
      }
    }
  }

  void forgetPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ForgetPasswordBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundShapes(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SafeArea(
              child: Center(
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 30.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello,",
                              style: AppFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                            Text(
                              "Welcome Back!",
                              style: AppFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      BuildLoginTextForm(
                        controller: userName,
                        label: "Email",
                        readOnly: false,
                        obscureText: false,
                        isPassword: false,
                      ),
                      const SizedBox(height: 10.0),
                      BuildLoginTextForm(
                        controller: password,
                        label: "Password",
                        readOnly: false,
                        obscureText: true,
                        isPassword: true,
                      ),
                      const SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: forgetPassword,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forget Password?",
                                style: AppFonts.firaSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      AbsorbPointer(
                        absorbing: _isLoading,
                        child: BuildElevatedButton(
                          actionOnButton: _login,
                          buttonText: "Login",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
