import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:developer" as dev;

class FetchTimeSlots {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Map<String, bool>> fetchTimeSlots(String date) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection("timeSlots")
        .doc(date)
        .collection("availability")
        .doc("slots")
        .get();
    Map<String,bool> timeSlots = {};
    if(documentSnapshot.exists) {
      timeSlots = Map<String,bool>.from(documentSnapshot.data() as Map);
    } else {
      dev.log("No Slots Found",name:"Error");
    }
    return timeSlots;
  }
}
