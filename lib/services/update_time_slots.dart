import "package:cloud_firestore/cloud_firestore.dart";
import 'dart:developer' as dev;
import 'package:intl/intl.dart';


class UpdateTimeSlots {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> insertSlots(String date,List<String> selectedSlots,bool available) async {
    try {
      DocumentReference documentReference = _firestore.collection("timeSlots")
          .doc(date)
          .collection("availability")
          .doc("slots");
      DocumentSnapshot snapshot = await documentReference.get();
      Map<String,dynamic> data = snapshot.data() as Map<String,dynamic>;

      for(String slots in selectedSlots){
        data[slots] = available;
      }

      await documentReference.update(data);
      dev.log("Success",name:"Message");
    } catch (e){
      dev.log(e.toString(),name:"Error");
    }
  }

  static Future<void> deleteSlot(String dateFromActivity,List<dynamic> selectedSlots,bool available) async {

    try {

      DateTime myDate = DateFormat("dd-MM-yyyy").parse(dateFromActivity);
      String date = DateFormat('yyyy-MM-dd').format(myDate);
      dev.log(date,name: "Date");

      DocumentReference documentReference = _firestore.collection("timeSlots")
          .doc(date)
          .collection("availability")
          .doc("slots");

      DocumentSnapshot snapshot = await documentReference.get();
      Map<String,dynamic> data = snapshot.data() as Map<String,dynamic>;

      for(String slots in selectedSlots){
        data[slots] = available;
      }

      await documentReference.update(data);
      dev.log("Success",name:"Message");
    } catch (e){
      dev.log(e.toString(),name:"Error");
    }
  }
}