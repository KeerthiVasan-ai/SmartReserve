import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_reserve/core/theme/app_fonts.dart';
import 'package:smart_reserve/core/services/gcp_logging_service.dart';
import 'package:smart_reserve/feature/auth/presentation/widgets/login_text_form.dart';
import 'package:smart_reserve/core/presentation/widgets/smart_snackbar.dart';
import 'package:smart_reserve/core/presentation/widgets/custom_button.dart';

class ForgetPasswordBottomSheet extends StatefulWidget {
  const ForgetPasswordBottomSheet({super.key});

  @override
  State<ForgetPasswordBottomSheet> createState() => _ForgetPasswordBottomSheetState();
}

class _ForgetPasswordBottomSheetState extends State<ForgetPasswordBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mailController = TextEditingController();
  bool _isLoading = false;

  void _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: mailController.text.trim(),
      );
      
      GCPLog.info('Password reset email sent to ${mailController.text}');
      
      if (!mounted) return;
      
      // Success feedback
      SmartSnackBar.showSuccess(
        context,
        "A password reset link has been sent to your email.",
        title: "Mail Sent",
      );
      
      // Close the bottom sheet
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      GCPLog.error('Password reset error: ${e.code}', error: e);
      if (!mounted) return;
      
      if (e.code == 'invalid-email') {
        SmartSnackBar.showError(
          context, 
          "Please enter a valid email address.", 
          title: "Invalid Email"
        );
      } else if (e.code == 'user-not-found') {
        SmartSnackBar.showError(
          context, 
          "No account found with this email.", 
          title: "Not Found"
        );
      } else {
        SmartSnackBar.showError(
          context, 
          "An error occurred. Please try again later.", 
          title: "Error"
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          top: 32,
          left: 24,
          right: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle/Indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Reset Password",
                style: AppFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: const Color(0xFF124076),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Enter your email to receive a recovery link.",
                style: AppFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 32),
              BuildLoginTextForm(
                controller: mailController,
                label: "Email Address",
                readOnly: _isLoading,
                obscureText: false,
                isPassword: false,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: BuildElevatedButton(
                  actionOnButton: _isLoading ? () {} : _sendResetLink,
                  buttonText: _isLoading ? "Sending..." : "Get Reset Link",
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
