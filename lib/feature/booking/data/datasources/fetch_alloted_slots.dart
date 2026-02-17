import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:developer" as dev;
import 'package:smart_reserve/core/services/gcp_logging_service.dart';

class FetchAllottedSlots {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<int> getAllottedSlots(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _firestore
          .collection("allottedSlots")
          .doc(uid)
          .get();
      int slot = documentSnapshot.data()?['allottedSlots'];
      return slot;
    } catch (error) {
      dev.log(error.toString(), name: "Error");
      GCPLog.error(
        'Failed to fetch allotted slots for user $uid',
        error: error,
      );
      return 0;
    }
  }
}
