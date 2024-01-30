import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "dart:developer" as dev;

class FetchToken {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String?> fetchToken() async {
    try{
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot<Map<String,dynamic>> snapshot = await _firestore.collection("tokenNumber").doc(uid).get();
      String? name = snapshot.data()?['token'];
      dev.log(name!,name: "TokenNumber");
      return name;
    } catch(error){
      dev.log(error.toString(),name:"Error");
      return null;
    }
  }
}