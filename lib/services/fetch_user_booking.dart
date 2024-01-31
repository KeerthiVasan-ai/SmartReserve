import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_reserve/services/validation.dart';

class FetchUserBooking {
  static Stream<QuerySnapshot> fetchBookingDetails(String userUid) {
    return FirebaseFirestore.instance
        .collection('bookingUserDetails')
        .doc(userUid)
        .collection('bookings')
        .snapshots();
  }

  static void validate(String userUid) {

  }
}
