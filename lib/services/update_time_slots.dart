import "package:cloud_firestore/cloud_firestore.dart";
import 'dart:developer' as dev;


class UpdateTimeSlots {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> updateData(String date,List<String> selectedSlots) async {
    try {
      DocumentReference documentReference = _firestore.collection("timeSlots")
          .doc(date)
          .collection("availability")
          .doc("slots");
      DocumentSnapshot snapshot = await documentReference.get();
      Map<String,dynamic> data = snapshot.data() as Map<String,dynamic>;

      for(String slots in selectedSlots){
        data[slots] = false;
      }

      await documentReference.update(data);
      dev.log("Success",name:"Message");
    } catch (e){
      dev.log(e.toString(),name:"Error");
    }
  }

}