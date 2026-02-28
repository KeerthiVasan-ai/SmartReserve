import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:week_number/iso.dart';
import 'dart:developer' as dev;
import 'package:smart_reserve/core/services/gcp_logging_service.dart';
import 'package:smart_reserve/feature/booking/data/datasources/fetch_alloted_slots.dart';

class CheckRequesterAvailability {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns true if the requesting user still has slots available for this week.
  static Future<bool> hasAvailableSlots(String uid) async {
    try {
      // 1. Get allotted slots for the user
      final allottedSlots = await FetchAllottedSlots.getAllottedSlots(uid);

      // 2. Count bookings for the current week
      final now = DateTime.now();
      final currentWeek = 'W${now.weekNumber.toString().padLeft(2, '0')}';

      final querySnapshot = await _firestore
          .collection('bookingUserDetails')
          .doc(uid)
          .collection('bookings')
          .where('week', isEqualTo: currentWeek)
          .get();

      // Count total slots used this week (each booking may have multiple slots)
      int usedSlots = 0;
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final slots = data['slots'] as List<dynamic>?;
        usedSlots += slots?.length ?? 1;
      }

      dev.log(
        'User $uid: allotted=$allottedSlots, used=$usedSlots',
        name: 'CheckRequesterAvailability',
      );
      GCPLog.info(
        'Availability check: allotted=$allottedSlots, used=$usedSlots',
      );

      return usedSlots < allottedSlots;
    } catch (e) {
      dev.log(
        'Failed to check availability: $e',
        name: 'CheckRequesterAvailability',
      );
      GCPLog.error('Failed to check requester availability', error: e);
      return false;
    }
  }
}
