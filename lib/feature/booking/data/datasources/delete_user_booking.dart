import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:developer" as dev;


class DeleteUserBooking {

  static Future<void> deleteUserBookingSlots(
      String userId, String bookingId, List<dynamic> slotsToRemove) async {
    try {
      DocumentReference bookingReference = FirebaseFirestore.instance
          .collection('bookingUserDetails')
          .doc(userId)
          .collection('bookings')
          .doc(bookingId);

      await bookingReference.update({
        'slots': FieldValue.arrayRemove(slotsToRemove),
      });

      // Check if slots are empty, if so, delete the document
      DocumentSnapshot snapshot = await bookingReference.get();
      if (snapshot.exists) {
        List<dynamic> currentSlots =
            (snapshot.data() as Map<String, dynamic>)['slots'] ?? [];
        if (currentSlots.isEmpty) {
          await bookingReference.delete();
          dev.log('Document deleted as no slots remain!', name: "Info");
        }
      }

      dev.log('Slots removed successfully!', name: "Success");
    } catch (error) {
      dev.log(error.toString(), name: "Error");
    }
  }

  static Future<void> deleteBookingSlots(
      String date, String bookingId, List<dynamic> slotsToRemove) async {
    try {
      DocumentReference bookingReference = FirebaseFirestore.instance
          .collection('bookingDetails')
          .doc(date)
          .collection('booking')
          .doc(bookingId);

      await bookingReference.update({
        'slots': FieldValue.arrayRemove(slotsToRemove),
      });

      // Check if slots are empty, if so, delete the document
      DocumentSnapshot snapshot = await bookingReference.get();
      if (snapshot.exists) {
        List<dynamic> currentSlots =
            (snapshot.data() as Map<String, dynamic>)['slots'] ?? [];
        if (currentSlots.isEmpty) {
          await bookingReference.delete();
          dev.log('Document deleted as no slots remain!', name: "Info");
        }
      }

      dev.log('Slots removed successfully!', name: "Success");
    } catch (error) {
      dev.log(error.toString(), name: "Error");
    }
  }
}
