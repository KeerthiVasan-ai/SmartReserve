import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_reserve/feature/notification/data/datasources/insert_notification.dart';
import 'package:smart_reserve/feature/notification/data/datasources/send_fcm_notification.dart';
import 'package:smart_reserve/feature/notification/domain/models/notification_model.dart';
import 'dart:developer' as dev;

class AdminNotificationService {
  static const String _adminTopic = 'admin_notifications';

  /// Notifies admins when a user cancels their booking slots.
  static Future<void> notifyAdminOnCancellation({
    required String userName,
    required String hall,
    required String date,
    required List<dynamic> slots,
  }) async {
    try {
      final userUid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
      final notificationId = FirebaseFirestore.instance.collection('notification').doc().id;
      final timeNow = DateTime.now().toIso8601String();

      final title = 'Slot Cancelled';
      final body = '$userName cancelled $hall slot on $date at ${slots.join(", ")}';

      dev.log('Notifying admin of cancellation: $body', name: 'AdminNotificationService');

      // 1. Send FCM Broadcast to admins
      await SendFCMNotification.sendToTopic(
        topic: _adminTopic,
        title: title,
        body: body,
        data: {
          'type': 'cancel',
          'userUid': userUid,
          'hall': hall,
          'date': date,
        },
      );

      // 2. Store in Firestore under notification/{userUid}/admin/
      final notification = SlotNotification(
        notificationId: notificationId,
        requestedBy: userUid,
        requestedTo: 'admin',
        requestedByName: userName,
        requestedToName: 'Administrator',
        slotInfo: slots.join(", "),
        date: date,
        type: 'cancel',
        status: 'cancelled',
        notificationInitiatedAt: timeNow,
      );

      await InsertNotification.insertAdminNotification(
        notificationId: notificationId,
        userUid: userUid,
        data: notification.toJson(),
      );
    } catch (e) {
      dev.log('Error in notifyAdminOnCancellation: $e', name: 'AdminNotificationService');
    }
  }

  /// Notifies admins when a user updates (moves) their booking slots.
  static Future<void> notifyAdminOnUpdate({
    required String userName,
    required String hall,
    required String oldDate,
    required String oldSlot,
    required String newDate,
    required String newSlot,
  }) async {
    try {
      final userUid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
      final notificationId = FirebaseFirestore.instance.collection('notification').doc().id;
      final timeNow = DateTime.now().toIso8601String();

      final title = 'Slot Updated';
      // Format: XXX updated [hall-name] slot from [OLD DATE/TIME] to [NEW DATE/TIME]
      final body = '$userName updated $hall slot from $oldDate $oldSlot to $newDate $newSlot';

      dev.log('Notifying admin of update: $body', name: 'AdminNotificationService');

      // 1. Send FCM Broadcast to admins
      await SendFCMNotification.sendToTopic(
        topic: _adminTopic,
        title: title,
        body: body,
        data: {
          'type': 'update',
          'userUid': userUid,
          'hall': hall,
          'oldDate': oldDate,
          'newDate': newDate,
        },
      );

      // 2. Store in Firestore under notification/{userUid}/admin/
      final notification = SlotNotification(
        notificationId: notificationId,
        requestedBy: userUid,
        requestedTo: 'admin',
        requestedByName: userName,
        requestedToName: 'Administrator',
        slotInfo: '$oldSlot -> $newSlot',
        date: '$oldDate -> $newDate',
        type: 'update',
        status: 'updated',
        notificationInitiatedAt: timeNow,
      );

      await InsertNotification.insertAdminNotification(
        notificationId: notificationId,
        userUid: userUid,
        data: notification.toJson(),
      );
    } catch (e) {
      dev.log('Error in notifyAdminOnUpdate: $e', name: 'AdminNotificationService');
    }
  }
}
