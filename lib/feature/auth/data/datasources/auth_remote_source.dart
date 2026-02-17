import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "dart:developer" as dev;
import 'package:smart_reserve/core/services/gcp_logging_service.dart';

class FetchToken {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String?> fetchToken() async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection("tokenNumber")
          .doc(uid)
          .get();
      String? name = snapshot.data()?['token'];
      dev.log(name!, name: "TokenNumber");
      GCPLog.info('Token fetched successfully');
      return name;
    } catch (error) {
      dev.log(error.toString(), name: "Error");
      GCPLog.error('Failed to fetch token', error: error);
      return null;
    }
  }
}
