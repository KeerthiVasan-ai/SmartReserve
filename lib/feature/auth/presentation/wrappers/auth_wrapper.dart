import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reserve/feature/auth/presentation/providers/auth_providers.dart';
import 'package:smart_reserve/feature/auth/presentation/screens/login_screen.dart';
import 'package:smart_reserve/feature/auth/presentation/screens/auth_error_screen.dart';
import 'package:smart_reserve/feature/home/presentation/screens/main_screen.dart';

class Auth extends ConsumerWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: authState.when(
        data: (user) {
          if (user != null) {
            return const MainScreen();
          }
          return const LoginScreen();
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => AuthErrorScreen(
          error: error,
          stackTrace: stack,
        ),
      ),
    );
  }
}
