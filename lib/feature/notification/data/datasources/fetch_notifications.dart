import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;
import 'package:smart_reserve/core/services/gcp_logging_service.dart';

class FetchNotifications {
  /// Streams the user's received notifications, newest first.
  static Stream<QuerySnapshot> fetchReceivedNotifications(String uid) {
    dev.log('Streaming received notifications for $uid',
        name: 'FetchNotifications');
    GCPLog.info('Fetching received notifications for user: $uid');

    return FirebaseFirestore.instance
        .collection('notification')
        .doc(uid)
        .collection('received')
        .orderBy('notificationInitiatedAt', descending: true)
        .snapshots();
  }

  /// Streams the user's sent notifications, newest first.
  static Stream<QuerySnapshot> fetchSentNotifications(String uid) {
    dev.log('Streaming sent notifications for $uid',
        name: 'FetchNotifications');
    GCPLog.info('Fetching sent notifications for user: $uid');

    return FirebaseFirestore.instance
        .collection('notification')
        .doc(uid)
        .collection('sent')
        .orderBy('notificationInitiatedAt', descending: true)
        .snapshots();
  }
}
