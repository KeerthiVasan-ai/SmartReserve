import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:developer" as dev;
import 'package:smart_reserve/core/services/gcp_logging_service.dart';

class FetchTimeSlots {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Map<String, bool>> fetchTimeSlots(String date) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection("timeSlots")
        .doc(date)
        .collection("availability")
        .doc("slots")
        .get();
    Map<String, bool> timeSlots = {};
    if (documentSnapshot.exists) {
      timeSlots = Map<String, bool>.from(documentSnapshot.data() as Map);
    } else {
      dev.log("No Slots Found", name: "Error");
      GCPLog.warning('No time slots found for date: $date');
    }
    return timeSlots;
  }

  static Future<Map<String, String>> fetchTimeSlotReasons(String date) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection("slotConfigurations")
          .doc("globalSlots")
          .get();
          
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          final Map<String, String> reasons = {};
          data.forEach((key, value) {
            if (value is Map && value['reason'] != null && value['reason'].toString().isNotEmpty) {
              reasons[key] = value['reason'].toString();
            }
          });
          return reasons;
        }
      }
    } catch (e) {
      dev.log("Error fetching global reasons: $e", name: "FetchTimeSlots");
    }
    return {}; // Safely default to an empty map
  }
}
