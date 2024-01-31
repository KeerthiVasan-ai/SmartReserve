import "package:flutter/material.dart";
import "package:ticket_widget/ticket_widget.dart";

import "../models/booking_model.dart";
import "../widgets/build_app_bar.dart";
import "../widgets/build_elevated_button.dart";
import "../widgets/build_report_details.dart";
import "main_screen.dart";

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar("Congratulation"),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background/check2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10.0),
                const Text(
                  "SmartReserve",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w200,
                      color: Colors.black),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  "Your Booking is Confirmed",
                  style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.black),
                ),
                const SizedBox(height: 15.0),
                TicketWidget(
                  width: 350,
                  height: 550,
                  isCornerRounded: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Congratulations",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Report for the Booking !",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      BuildReportDetails(
                          title: "Token Number",
                          data: widget.bookingDetails.tokenNumber),
                      BuildReportDetails(
                          title: "Name", data: widget.bookingDetails.name),
                      BuildReportDetails(
                          title: "Course Code",
                          data: widget.bookingDetails.courseCode),
                      BuildReportDetails(
                          title: "Date", data: widget.bookingDetails.date),
                      BuildReportDetails(
                          title: "Time Slots",
                          data: widget.bookingDetails.slots.toString()),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                BuildElevatedButton(actionOnButton: backToHome, buttonText: "Home"),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
