import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;
import 'package:smart_reserve/core/services/gcp_logging_service.dart';

class UpdateNotificationStatus {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Updates the status of a notification in both the sender's "sent"
  /// and receiver's "received" sub-collections.
  static Future<void> updateStatus({
    required String notificationId,
    required String senderUid,
    required String receiverUid,
    required String newStatus,
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

      batch.update(sentRef, {'status': newStatus});
      batch.update(receivedRef, {'status': newStatus});

      await batch.commit();

      dev.log(
        'Notification $notificationId status updated to $newStatus',
        name: 'UpdateNotificationStatus',
      );
      GCPLog.info('Notification $notificationId status → $newStatus');
    } catch (e) {
      dev.log(
        'Failed to update notification status: $e',
        name: 'UpdateNotificationStatus',
      );
      GCPLog.error('Failed to update notification status', error: e);
      rethrow;
    }
  }
}
