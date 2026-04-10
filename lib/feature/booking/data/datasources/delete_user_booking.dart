import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:developer" as dev;
import 'package:smart_reserve/core/services/gcp_logging_service.dart';
import 'package:smart_reserve/feature/booking/data/datasources/fetch_user_name.dart';
import 'package:smart_reserve/feature/notification/data/datasources/admin_notification_service.dart';

class DeleteUserBooking {
  static Future<void> deleteUserBookingSlots(
    String userId,
    String bookingId,
    List<dynamic> slotsToRemove,
  ) async {
    try {
      DocumentReference bookingReference = FirebaseFirestore.instance
          .collection('bookingUserDetails')
          .doc(userId)
          .collection('bookings')
          .doc(bookingId);

      // Check current slots to decide: delete doc or just remove slots
      DocumentSnapshot snapshot = await bookingReference.get();
      if (snapshot.exists) {
        List<dynamic> currentSlots =
            (snapshot.data() as Map<String, dynamic>)['slots'] ?? [];
        // If removing all remaining slots, delete the whole document at once
        final remainingSlots =
            currentSlots.where((s) => !slotsToRemove.contains(s)).toList();
        if (remainingSlots.isEmpty) {
          await bookingReference.delete();
          dev.log('Document deleted as all slots removed!', name: "Info");
          GCPLog.info('User booking document deleted: $bookingId');
        } else {
          await bookingReference.update({
            'slots': FieldValue.arrayRemove(slotsToRemove),
          });
          dev.log('Slots removed successfully!', name: "Success");
          GCPLog.info(
            'User booking slots removed: $bookingId, slots: $slotsToRemove',
          );
        }

        // Notify admins
        try {
          final userName = await FetchName.fetchName() ?? 'A User';
          final data = snapshot.data() as Map<String, dynamic>;
          final hall = data['hall'] ?? 'Unknown Hall';
          final date = data['date'] ?? 'Unknown Date';

          await AdminNotificationService.notifyAdminOnCancellation(
            userName: userName,
            hall: hall,
            date: date,
            slots: slotsToRemove,
          );
        } catch (e) {
          dev.log('Failed to send admin notification: $e', name: 'DeleteUserBooking');
        }
      }
    } catch (error) {
      dev.log(error.toString(), name: "Error");
      GCPLog.error('Failed to delete user booking slots', error: error);
    }
  }

  static Future<void> deleteBookingSlots(
    String date,
    String bookingId,
    List<dynamic> slotsToRemove,
  ) async {
    try {
      DocumentReference bookingReference = FirebaseFirestore.instance
          .collection('bookingDetails')
          .doc(date)
          .collection('booking')
          .doc(bookingId);

      // Check current slots to decide: delete doc or just remove slots
      DocumentSnapshot snapshot = await bookingReference.get();
      if (snapshot.exists) {
        List<dynamic> currentSlots =
            (snapshot.data() as Map<String, dynamic>)['slots'] ?? [];
        final remainingSlots =
            currentSlots.where((s) => !slotsToRemove.contains(s)).toList();
        if (remainingSlots.isEmpty) {
          await bookingReference.delete();
          dev.log('Document deleted as all slots removed!', name: "Info");
          GCPLog.info(
            'Global booking document deleted: $bookingId on $date',
          );
        } else {
          await bookingReference.update({
            'slots': FieldValue.arrayRemove(slotsToRemove),
          });
          dev.log('Slots removed successfully!', name: "Success");
          GCPLog.info('Global booking slots removed: $bookingId on $date');
        }
      }
    } catch (error) {
      dev.log(error.toString(), name: "Error");
      GCPLog.error('Failed to delete global booking slots', error: error);
    }
  }
}
