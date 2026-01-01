import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "dart:developer" as dev;

class FetchName {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String?> fetchName() async {
    try{
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot<Map<String,dynamic>> snapshot = await _firestore.collection("userName").doc(uid).get();
      String? name = snapshot.data()?['name'];
      dev.log(name!,name: "UserName");
      return name;
    } catch(error){
      dev.log(error.toString(),name:"Error");
      return null;
    }
  }
}