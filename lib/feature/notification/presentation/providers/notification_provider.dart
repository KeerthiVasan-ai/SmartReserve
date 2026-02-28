import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;

import 'package:smart_reserve/core/services/gcp_logging_service.dart';
import 'package:smart_reserve/feature/booking/data/datasources/fetch_user_name.dart';
import 'package:smart_reserve/feature/notification/data/datasources/check_requester_availability.dart';
import 'package:smart_reserve/feature/notification/data/datasources/insert_notification.dart';
import 'package:smart_reserve/feature/notification/data/datasources/send_fcm_notification.dart';
import 'package:smart_reserve/feature/notification/data/datasources/update_notification_status.dart';
import 'package:smart_reserve/feature/notification/data/datasources/transfer_slot_booking.dart';

/// A simple provider that exposes notification-related actions.
class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sends a slot request notification.
  ///
  /// Returns a message string: success or error description.
  static Future<String> sendRequest({
    required String bookingId,
    required String slotInfo,
    required String date,
    required String requestedToUid,
    required String requestedToName,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return 'User not authenticated';

      final requesterUid = currentUser.uid;

      // 1. Check availability
      final hasSlots = await CheckRequesterAvailability.hasAvailableSlots(
        requesterUid,
      );
      if (!hasSlots) {
        return 'You have no available slots for this week to make a request';
      }

      // 2. Fetch requester's name
      final requesterName = await FetchName.fetchName() ?? 'Unknown';

      // 3. Generate notification ID
      final notificationId =
          'notif_${DateTime.now().millisecondsSinceEpoch}_${requesterUid.substring(0, 6)}';

      final now = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());

      // 4. Build notification data
      final notificationData = {
        'notificationId': notificationId,
        'requestedBy': requesterUid,
        'requestedTo': requestedToUid,
        'requestedByName': requesterName,
        'requestedToName': requestedToName,
        'bookingId': bookingId,
        'slotInfo': slotInfo,
        'date': date,
        'status': 'pending',
        'notificationInitiatedAt': now,
      };

      // 5. Insert into Firestore (both sent & received)
      await InsertNotification.insertNotification(
        notificationId: notificationId,
        data: notificationData,
        senderUid: requesterUid,
        receiverUid: requestedToUid,
      );

      // 6. Send FCM push notification
    final fcmSuccess = await SendFCMNotification.sendToTopic(
      topic: requestedToUid,
      title: 'Slot Request',
      body: '$requesterName is requesting your slot $slotInfo on $date',
      data: {'notificationId': notificationId, 'type': 'slot_request'},
    );

    dev.log(
      'Slot request sent. FCM push: ${fcmSuccess ? "OK" : "FAILED"}. Topic: $requestedToUid',
      name: 'NotificationService',
    );
    GCPLog.info('Slot request sent: $notificationId');

    if (!fcmSuccess) {
      return 'Request saved, but push notification failed to send.';
    }
    return 'Request sent successfully!';
    } catch (e) {
      dev.log('Failed to send slot request: $e', name: 'NotificationService');
      GCPLog.error('Failed to send slot request', error: e);
      return 'Failed to send request. Please try again.';
    }
  }

  /// Responds to a notification (accept or reject).
  ///
  /// On accept, transfers the booking slot from the owner to the requester.
  /// On reject, only updates the notification status.
  static Future<String> respondToRequest({
    required String notificationId,
    required String senderUid,
    required String receiverUid,
    required bool accept,
    String? requesterName,
    String? slotInfo,
    String? date,
    String? bookingId,
  }) async {
    try {
      final newStatus = accept ? 'accepted' : 'rejected';

      // If accepted, transfer the slot from owner (receiverUid) to requester (senderUid)
      if (accept && bookingId != null && bookingId.isNotEmpty) {
        await TransferSlotBooking.transferSlot(
          ownerUid: receiverUid,
          requesterUid: senderUid,
          bookingId: bookingId,
          slotInfo: slotInfo ?? '',
          date: date ?? '',
        );
      }

      // Update notification status in both sender's and receiver's collections
      await UpdateNotificationStatus.updateStatus(
        notificationId: notificationId,
        senderUid: senderUid,
        receiverUid: receiverUid,
        newStatus: newStatus,
      );

      // Send response notification to the requester
      final currentUserName = await FetchName.fetchName() ?? 'Unknown';
      final action = accept ? 'accepted' : 'rejected';

      await SendFCMNotification.sendToTopic(
        topic: senderUid,
        title: 'Slot Request $action',
        body:
            '$currentUserName has $action your request for slot ${slotInfo ?? ''} on ${date ?? ''}',
        data: {'notificationId': notificationId, 'type': 'slot_response'},
      );

      dev.log(
        'Notification $notificationId $newStatus',
        name: 'NotificationService',
      );
      GCPLog.info('Notification response: $notificationId → $newStatus');

      return 'Request ${accept ? 'accepted' : 'rejected'} successfully';
    } catch (e) {
      dev.log('Failed to respond to request: $e', name: 'NotificationService');
      GCPLog.error('Failed to respond to notification', error: e);
      return 'Failed to update. Please try again.';
    }
  }
}

/// Provider for the pending notification count.
final pendingNotificationCountProvider = StreamProvider<int>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value(0);

  return FirebaseFirestore.instance
      .collection('notification')
      .doc(uid)
      .collection('received')
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
});
