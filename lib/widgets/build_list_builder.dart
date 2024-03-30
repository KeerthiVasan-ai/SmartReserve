import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "dart:developer" as dev;
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_reserve/widgets/ui/frosted_glass.dart';

import '../services/delete_user_booking.dart';
import '../services/update_time_slots.dart';

class BuildListBuilder extends StatelessWidget {
  final List<DocumentSnapshot> bookings;
  final bool isDelete;
  final String uid;

  const BuildListBuilder(
      {required this.bookings,
      required this.isDelete,
      required this.uid,
      super.key});

  Future<void> deleteDetails(String uid, String ticketId, String date,
      List<dynamic> selectedSlots) async {
    dev.log(selectedSlots.first, name: "Slots From Call");
    await DeleteUserBooking.deleteUserBooking(uid, ticketId);
    await DeleteUserBooking.deleteBooking(date, ticketId);
    await UpdateTimeSlots.deleteSlot(date, selectedSlots, true);
  }

  void deleteBooking(
      String uid, String ticketId, String date, List<dynamic> selectedSlots) {
    dev.log(selectedSlots.first, name: "Slots");
    deleteDetails(uid, ticketId, date, selectedSlots);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        var data = bookings[index].data() as Map<String, dynamic>;
        return FrostedGlassUI(
          theHeight: 110.0,
          theWidth: 200.0,
          theChild: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.bookmark),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${data['tokenNumber']}",
                      style: GoogleFonts.ebGaramond(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "${data['courseCode']}",
                      style: GoogleFonts.ebGaramond(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text("${data['date']}",
                        style: GoogleFonts.ebGaramond(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Slots: ${data['slots'].join(', ')}",
                        style: GoogleFonts.ebGaramond(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                if (isDelete) const Spacer(),
                if (isDelete) IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteBooking(
                        uid, data['ticketId'], data['date'], data['slots']);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
