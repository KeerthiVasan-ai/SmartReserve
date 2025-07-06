import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;

class FetchTimes {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<String>> fetchTime() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection("time").get();

      List<String> timeSlots = querySnapshot.docs.map((doc) => doc["slot"].toString()).toList();

      return timeSlots;
    } catch (e) {
      dev.log("Failed to fetch time slots: $e", name: "FetchTimes");
      return [];
    }
  }
}
