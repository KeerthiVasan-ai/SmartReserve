import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:smart_reserve/feature/booking/presentation/widgets/ticket_widget.dart';
import 'package:smart_reserve/core/presentation/widgets/background_shapes.dart';
import "package:ticket_widget/ticket_widget.dart";

import 'package:smart_reserve/feature/booking/domain/models/booking_model.dart';
import 'package:smart_reserve/core/presentation/widgets/custom_app_bar.dart';
import 'package:smart_reserve/core/presentation/widgets/custom_button.dart';
import 'package:smart_reserve/feature/booking/presentation/widgets/report_details_widget.dart';
import 'package:smart_reserve/feature/booking/presentation/widgets/ticket_painter.dart';
import 'package:smart_reserve/feature/home/presentation/screens/main_screen.dart';

class VerifyScreen extends StatefulWidget {
  final BookingDetails bookingDetails;

  const VerifyScreen({required this.bookingDetails, super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  void backToHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundShapes(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: "Congratulations"),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Smart Reserve",style: GoogleFonts.poppins(fontWeight:FontWeight.bold,fontSize:20),),
              const SizedBox(height: 10),
              Text("Your Booking was Confirmed",style: GoogleFonts.ebGaramond(fontWeight:FontWeight.bold,fontSize:20),),
              const SizedBox(height: 10),
              TicketUI(bookingDetails: widget.bookingDetails),
              BuildElevatedButton(actionOnButton: backToHome, buttonText: "Home")
            ],
          ),
        ),
      ),
    );
  }
}
