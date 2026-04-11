import "dart:async";

import "package:flutter/material.dart";
import 'package:smart_reserve/core/theme/app_fonts.dart';
import 'package:smart_reserve/core/constants/app_constants.dart';
import 'package:smart_reserve/core/presentation/screens/app_blocked_screen.dart';
import 'package:smart_reserve/core/services/server_service.dart';
import 'package:smart_reserve/core/presentation/widgets/background_shapes.dart';
import 'package:smart_reserve/feature/auth/presentation/wrappers/auth_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAppStatus();
  }

  void _checkAppStatus() async {
    final serverDetails = await FetchServerDetails.checkIsAppUnderMaintenance();

    if (serverDetails.isAppUnderMaintenance) {
      Timer(
        const Duration(seconds: 1),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AppBlockedScreen(state: AppBlockState.underMaintenance),
          ),
        ),
      );
    } else if (!serverDetails.isAppUnderMaintenance &&
        (!serverDetails.allowedUserVersions.contains(
          AppConstants.APP_VERSION,
        ))) {
      Timer(
        const Duration(seconds: 1),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppBlockedScreen(
              state: AppBlockState.updateRequired,
              version: serverDetails.version,
            ),
          ),
        ),
      );
    } else {
      Timer(
        const Duration(seconds: 1),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Auth()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundShapes(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Smart Reserve",
                  style: AppFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                Text(
                  "v${AppConstants.APP_VERSION}-Stable",
                  style: AppFonts.firaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
