import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:developer" as dev;


class DeleteUserBooking {

  static Future<void> deleteUserBooking(String userId, String bookingId) async {
    try {
      DocumentReference bookingReference = FirebaseFirestore.instance
          .collection('bookingUserDetails')
          .doc(userId)
          .collection('bookings')
          .doc(bookingId);

      await bookingReference.delete();

      dev.log('Document deleted successfully!', name: "Success");
    } catch (error) {
      dev.log(error.toString(), name: "Error");
    }
  }

  static Future<void> deleteBooking(String date, String bookingId) async {
    try {
      DocumentReference bookingReference = FirebaseFirestore.instance
          .collection('bookingDetails')
          .doc(date)
          .collection('booking')
          .doc(bookingId);

      await bookingReference.delete();

      dev.log('Document deleted successfully!', name: "Success");
    } catch (error) {
      dev.log(error.toString(), name: "Error");
    }
  }
}
