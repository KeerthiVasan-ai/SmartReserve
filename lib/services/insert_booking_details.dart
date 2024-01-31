import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:developer" as dev;

class InsertBookingDetails {
  static Future<void> addIndividualBookingDetails({
    required String uid,
    required String ticketId,
    required Map<String, dynamic> bookingData,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookingUserDetails')
          .doc(uid)
          .collection('bookings')
          .doc(ticketId)
          .set(bookingData);
      dev.log('Data added to Firestore successfully!', name: "Success");
    } catch (error) {
      dev.log(error.toString(), name: "Error");
    }
  }

  static Future<void> addBookingDetails(
      {required String date,required String ticketId, required Map<String, dynamic> bookingData,
      }) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookingDetails')
          .doc(date)
          .collection('booking')
          .doc(ticketId)
          .set(bookingData);
      dev.log('Data added to Firestore successfully!', name: "Success");
    } catch (error){
      dev.log(error.toString(), name: "Error");
    }
  }
}
