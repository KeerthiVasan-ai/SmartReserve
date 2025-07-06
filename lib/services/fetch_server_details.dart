import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;

import 'package:smart_reserve/models/server_details.dart';

class FetchServerDetails {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<ServerDetails> checkIsAppUnderMaintenance() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection("constants").doc("server").get();

      final data = snapshot.data();
      if (data == null) {
        throw Exception("Server config is null");
      }

      return ServerDetails.fromMap(data);
    } catch (error) {
      dev.log("Failed to fetch server details: $error", name: "FetchServerDetails");

      return ServerDetails(
        isAppUnderMaintenance: false,
        version: "unknown",
      );
    }
  }
}
