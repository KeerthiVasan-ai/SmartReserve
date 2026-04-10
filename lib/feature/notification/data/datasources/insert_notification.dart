import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;
import 'package:smart_reserve/core/services/gcp_logging_service.dart';

class InsertNotification {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Atomically writes the notification to both sender's "sent"
  /// and receiver's "received" sub-collections.
  static Future<void> insertNotification({
    required String notificationId,
    required Map<String, dynamic> data,
    required String senderUid,
    required String receiverUid,
  }) async {
    try {
      final batch = _firestore.batch();

      final sentRef = _firestore
          .collection('notification')
          .doc(senderUid)
          .collection('sent')
          .doc(notificationId);

      final receivedRef = _firestore
          .collection('notification')
          .doc(receiverUid)
          .collection('received')
          .doc(notificationId);

      batch.set(sentRef, data);
      batch.set(receivedRef, data);

      await batch.commit();

      dev.log(
        'Notification $notificationId inserted for sender=$senderUid, receiver=$receiverUid',
        name: 'InsertNotification',
      );
      GCPLog.info('Notification inserted: $notificationId');
    } catch (e) {
      dev.log('Failed to insert notification: $e', name: 'InsertNotification');
      GCPLog.error('Failed to insert notification', error: e);
      rethrow;
    }
  }
  
  /// Atomically writes the notification to the user's "admin" sub-collection.
  /// Used for record-keeping of notifications sent to administrators.
  static Future<void> insertAdminNotification({
    required String notificationId,
    required Map<String, dynamic> data,
    required String userUid,
  }) async {
    try {
      final adminRef = _firestore
          .collection('notification')
          .doc(userUid)
          .collection('admin')
          .doc(notificationId);

      await adminRef.set(data);

      dev.log(
        'Admin Notification $notificationId inserted for user=$userUid',
        name: 'InsertNotification',
      );
      GCPLog.info('Admin notification inserted for user: $userUid');
    } catch (e) {
      dev.log('Failed to insert admin notification: $e', name: 'InsertNotification');
      GCPLog.error('Failed to insert admin notification', error: e);
      rethrow;
    }
  }
}
