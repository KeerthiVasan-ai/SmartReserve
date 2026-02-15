import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:developer" as dev;
import 'package:smart_reserve/core/services/gcp_logging_service.dart';

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
      GCPLog.info('Individual booking added: $ticketId for user $uid');
    } catch (error) {
      dev.log(error.toString(), name: "Error");
      GCPLog.error('Failed to add individual booking', error: error);
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
      GCPLog.info('Global booking added: $ticketId on $date');
    } catch (error){
      dev.log(error.toString(), name: "Error");
      GCPLog.error('Failed to add global booking', error: error);
    }
  }
}
