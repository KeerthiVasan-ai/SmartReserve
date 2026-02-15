import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;

class FetchSlotBooker {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches the booking details for a specific slot on a given date.
  /// Returns a map with 'name', 'tokenNumber', and 'courseCode' if found,
  /// or null if no booking exists for that slot.
  static Future<Map<String, String>?> fetchBooker(
      String date, String slot) async {
    try {
      final querySnapshot = await _firestore
          .collection('bookingDetails')
          .doc(date)
          .collection('booking')
          .where('slots', arrayContains: slot)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        dev.log('No booker found for slot $slot on $date',
            name: 'FetchSlotBooker');
        return null;
      }

      final data = querySnapshot.docs.first.data();
      return {
        'name': data['name']?.toString() ?? 'Unknown',
        'tokenNumber': data['tokenNumber']?.toString() ?? 'Unknown',
        'courseCode': data['courseCode']?.toString() ?? 'Unknown',
      };
    } catch (e) {
      dev.log('Failed to fetch slot booker: $e', name: 'FetchSlotBooker');
      return null;
    }
  }
}
