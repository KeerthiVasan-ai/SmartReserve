import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;
import 'package:smart_reserve/core/services/gcp_logging_service.dart';
import 'package:smart_reserve/feature/booking/domain/models/booking_model.dart';

class FetchHallBookings {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches all booking documents for a specific date and hall.
  /// Returns a list of [BookingDetails] to be used for overlap checking.
  static Future<List<BookingDetails>> fetchBookings(
    String date,
    String hall,
  ) async {
    try {
      // Query the global booking collection for that date
      final querySnapshot = await _firestore
          .collection('bookingDetails')
          .doc(date)
          .collection('booking')
          .where('hall', isEqualTo: hall)
          .get();

      final bookings = querySnapshot.docs.map((doc) {
        return BookingDetails.fromJson(doc.data());
      }).toList();

      return bookings;
    } catch (e) {
      dev.log("Failed to fetch hall bookings: $e", name: "FetchHallBookings");
      GCPLog.error(
        'Failed to fetch hall bookings for $hall on $date',
        error: e,
      );
      return [];
    }
  }
}
