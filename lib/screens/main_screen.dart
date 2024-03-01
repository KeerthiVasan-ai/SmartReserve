import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:smart_reserve/services/delete_user_booking.dart";
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

  Future<void> deleteDetails(String uid,String ticketId, String date,List<dynamic> selectedSlots) async {
    dev.log(selectedSlots.first,name: "Slots From Call");
    await DeleteUserBooking.deleteUserBooking(uid, ticketId);
    await DeleteUserBooking.deleteBooking(date, ticketId);
    await UpdateTimeSlots.deleteSlot(date, selectedSlots,true);
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

  void deleteBooking(String uid, String ticketId,String date,List<dynamic> selectedSlots) {
      dev.log(selectedSlots.first,name: "Slots");
      deleteDetails(uid,ticketId,date,selectedSlots);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: bookSlotRoute,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Smart Reserve"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _signOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background/check2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
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

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.bookmark),
                            const SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${data['tokenNumber']}"),
                                Text("${data['courseCode']}"),
                                Text("${data['date']}"),
                                Text("Slots: ${data['slots'].join(', ')}"),
                              ],
                            ),
                            // const Spacer(),
                            // // Add this spacer to push the delete button to the end
                            // IconButton(
                            //   icon: const Icon(Icons.delete),
                            //   onPressed: () {
                            //     deleteBooking(uid,data['ticketId'],data['date'],data['slots']);
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
