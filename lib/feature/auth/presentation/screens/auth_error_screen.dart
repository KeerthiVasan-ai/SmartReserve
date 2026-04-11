import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reserve/core/theme/app_fonts.dart';
import 'package:smart_reserve/core/presentation/widgets/background_shapes.dart';
import 'package:smart_reserve/feature/auth/presentation/providers/auth_providers.dart';

class AuthErrorScreen extends ConsumerWidget {
  final Object error;
  final StackTrace? stackTrace;

  const AuthErrorScreen({
    super.key,
    required this.error,
    this.stackTrace,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackgroundShapes(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wifi_off_rounded,
                          color: Color(0xFFE6A4B4),
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Authentication Failed',
                        textAlign: TextAlign.center,
                        style: AppFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getErrorMessage(error),
                        textAlign: TextAlign.center,
                        style: AppFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            // Invalidate the auth provider to trigger a fresh check
                            ref.invalidate(authStateProvider);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF124076).withOpacity(0.8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Try Again',
                            style: AppFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          // Could add detailed report or go back to login flow
                        },
                        child: Text(
                          'View Technical Details',
                          style: AppFonts.firaSans(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getErrorMessage(Object error) {
    // Customize error messages based on the error type
    final errorStr = error.toString().toLowerCase();
    if (errorStr.contains('network') || errorStr.contains('socket')) {
      return 'Please check your internet connection and try again.';
    } else if (errorStr.contains('timeout')) {
      return 'The request timed out. Please verify your connection.';
    }
    return 'An unexpected error occurred while verifying your account.';
  }
}
