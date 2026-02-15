import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;
import 'package:smart_reserve/core/services/gcp_logging_service.dart';

import 'package:smart_reserve/core/models/server_details.dart';

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

      return ServerDetails.fromJson(data);
    } catch (error) {
      dev.log("Failed to fetch server details: $error", name: "FetchServerDetails");
      GCPLog.error('Failed to fetch server details', error: error);

      return const ServerDetails(
        isAppUnderMaintenance: false,
        version: "unknown",
      );
    }
  }
}
