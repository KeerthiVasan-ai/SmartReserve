import 'package:cloud_firestore/cloud_firestore.dart';

class FetchUserBooking {
  static Stream<QuerySnapshot> fetchBookingDetails(String userUid) {
    return FirebaseFirestore.instance
        .collection('bookingUserDetails')
        .doc(userUid)
        .collection('bookings')
        .snapshots();
  }
}
