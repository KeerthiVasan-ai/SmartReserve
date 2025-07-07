import "dart:async";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:smart_reserve/screens/app_blocked_screen.dart";
import "package:smart_reserve/services/fetch_server_details.dart";
import "package:smart_reserve/widgets/ui/background_shapes.dart";

import "../core/app_constants.dart";
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
    _checkAppStatus();
  }

  void _checkAppStatus() async {
    final serverDetails = await FetchServerDetails.checkIsAppUnderMaintenance();

    if (serverDetails.isAppUnderMaintenance) {
      Timer(
        const Duration(seconds: 10),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AppBlockedScreen(state: AppBlockState.underMaintenance),
          ),
        ),
      );
    } else if (!serverDetails.isAppUnderMaintenance &&
        (serverDetails.version != AppConstants.APP_VERSION)) {
      Timer(
        const Duration(seconds: 10),
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
        const Duration(seconds: 10),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Auth(),
          ),
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
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
                Text(
                  "v1.4.0-Stable",
                  style: GoogleFonts.firaSans(
                      fontWeight: FontWeight.bold, fontSize: 12.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
