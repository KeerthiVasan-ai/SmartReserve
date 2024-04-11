import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "dart:developer" as dev;
import "package:smart_reserve/widgets/build_app_bar.dart";
import "package:smart_reserve/widgets/build_list_builder.dart";
import "package:smart_reserve/widgets/ui/background_shapes.dart";

import "../services/fetch_user_booking.dart";

class OlderBookingScreen extends StatefulWidget {

  const OlderBookingScreen({super.key});

  @override
  State<OlderBookingScreen> createState() => _OlderBookingScreenState();
}

class _OlderBookingScreenState extends State<OlderBookingScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return BackgroundShapes(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar("Previous Bookings"),
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

              var sortedDocs = snapshot.data!.docs.toList()
                ..sort((a, b) {
                  var aDate = DateFormat("dd-MM-yyyy")
                      .parse((a.data() as Map<String, dynamic>)['date']);
                  var bDate = DateFormat("dd-MM-yyyy")
                      .parse((b.data() as Map<String, dynamic>)['date']);
                  return aDate.compareTo(bDate);
                });

              List<DocumentSnapshot> previousBooking = [];
              DateTime today = DateTime.now();
              dev.log(today.toString());

              for (var doc in sortedDocs) {
                DateTime bookingDate =
                DateFormat("dd-MM-yyyy").parse(doc['date']);
                if (!(bookingDate.year == today.year &&
                    bookingDate.month == today.month &&
                    bookingDate.day == today.day) &&
                    !bookingDate.isAfter(today)) {
                  previousBooking.add(doc);
                }
              }
              dev.log(previousBooking.length.toString());

              if (previousBooking.isEmpty) {
                return const Center(
                  child: Text('No Booking available.'),
                );
              }

              return BuildListBuilder(bookings: previousBooking,isDelete: false,uid: uid);
            },
          ),
        ),
      ),
    );
  }
}
