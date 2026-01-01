import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:developer" as dev;

class FetchAllottedSlots {

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<int> getAllottedSlots(String uid) async {
    try{
      DocumentSnapshot<Map<String,dynamic>> documentSnapshot =
          await _firestore.collection("allottedSlots").doc(uid).get();
      int slot = documentSnapshot.data()?['allottedSlots'];
      return slot;
    } catch(error){
      dev.log(error.toString(),name:"Error");
      return 0;
    }
  }
}
