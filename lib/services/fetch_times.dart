import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;

class FetchTimes {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<String>> fetchTime() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection("time").get();

      List<String> timeSlots =
          querySnapshot.docs.map((doc) => doc["slot"].toString()).toList();

      return timeSlots;
    } catch (e) {
      dev.log("Failed to fetch time slots: $e", name: "FetchTimes");
      return [];
    }
  }

  static Future<Map<String, String>> fetchTimeKey() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection("time").get();

      Map<String, String> timeSlots = {};

      for (var doc in querySnapshot.docs) {
        final slot = doc["slot"]?.toString();
        if (slot != null) {
          timeSlots[slot] = doc.id;
        }
      }

      return timeSlots;
    } catch (e) {
      dev.log("Failed to fetch time slots: $e", name: "FetchTimes");
      return {};
    }
  }
}
