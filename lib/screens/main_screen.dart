import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:smart_reserve/screens/previous_booking.dart";
import "package:smart_reserve/services/delete_user_booking.dart";
import "package:smart_reserve/widgets/build_list_builder.dart";
import "package:smart_reserve/widgets/ui/background_shapes.dart";
import "dart:developer" as dev;

import "../services/fetch_user_booking.dart";
import "../services/update_time_slots.dart";
import "booking_screen.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  void _signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> deleteDetails(String uid, String ticketId, String date,
      List<dynamic> selectedSlots) async {
    dev.log(selectedSlots.first, name: "Slots From Call");
    await DeleteUserBooking.deleteUserBooking(uid, ticketId);
    await DeleteUserBooking.deleteBooking(date, ticketId);
    await UpdateTimeSlots.deleteSlot(date, selectedSlots, true);
  }

  void bookSlotRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const BookingScreen();
        },
      ),
    );
  }

  void deleteBooking(
      String uid, String ticketId, String date, List<dynamic> selectedSlots) {
    dev.log(selectedSlots.first, name: "Slots");
    deleteDetails(uid, ticketId, date, selectedSlots);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundShapes(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: bookSlotRoute,
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(
            "Smart Reserve",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OlderBookingScreen()));
                },
                icon: const Icon(Icons.history, color: Colors.black)),
            IconButton(
                onPressed: _signOut,
                icon: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ))
          ],
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: FetchUserBooking.fetchBookingDetails(uid),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No Booking available.'),
                );
              }

              var sortedDocs = snapshot.data!.docs.toList()
                ..sort((a, b) {
                  var aDate = DateFormat("dd-MM-yyyy")
                      .parse((a.data() as Map<String, dynamic>)['date']);
                  var bDate = DateFormat("dd-MM-yyyy")
                      .parse((b.data() as Map<String, dynamic>)['date']);
                  return aDate.compareTo(bDate);
                });

              List<DocumentSnapshot> bookings = [];
              DateTime today = DateTime.now();
              dev.log(today.toString());

              for (var doc in sortedDocs) {
                DateTime bookingDate =
                    DateFormat("dd-MM-yyyy").parse(doc['date']);
                if ((bookingDate.year == today.year &&
                        bookingDate.month == today.month &&
                        bookingDate.day == today.day) ||
                    bookingDate.isAfter(today)) {
                  bookings.add(doc);
                }
              }
              dev.log(bookings.length.toString());

              return BuildListBuilder(bookings: bookings);
            },
          ),
        ),
      ),
    );
  }
}
