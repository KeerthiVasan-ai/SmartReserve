import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_reserve/core/services/gcp_logging_service.dart';
import 'package:smart_reserve/core/utils/generate_token.dart';
import 'dart:developer' as dev;

/// Handles transferring a slot booking from one user (owner) to another
/// (requester) when a slot request is accepted.
class TransferSlotBooking {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Transfers a slot from [ownerUid] to [requesterUid].
  ///
  /// 1. Fetches the owner's booking document to get full booking data.
  /// 2. Removes the requested slot from the owner's booking.
  /// 3. Creates a new booking for the requester with the transferred slot.
  ///
  /// All operations are done in a Firestore batch for atomicity.
  static Future<void> transferSlot({
    required String ownerUid,
    required String requesterUid,
    required String bookingId,
    required String slotInfo,
    required String date,
  }) async {
    try {
      // 1. Fetch owner's booking document
      final ownerBookingRef = _firestore
          .collection('bookingUserDetails')
          .doc(ownerUid)
          .collection('bookings')
          .doc(bookingId);

      final ownerBookingSnapshot = await ownerBookingRef.get();
      if (!ownerBookingSnapshot.exists) {
        throw Exception(
          'Owner booking document not found: $bookingId',
        );
      }

      final ownerBookingData =
          ownerBookingSnapshot.data() as Map<String, dynamic>;

      // 2. Fetch requester's name and token number
      final requesterNameDoc =
          await _firestore.collection('userName').doc(requesterUid).get();
      final requesterName =
          (requesterNameDoc.data()?['name'] as String?) ?? 'Unknown';

      final requesterTokenDoc =
          await _firestore.collection('tokenNumber').doc(requesterUid).get();
      final requesterToken =
          (requesterTokenDoc.data()?['token'] as String?) ?? '';

      // 3. Build the new booking data for the requester
      final newTicketId = generateToken();
      final newBookingData = <String, dynamic>{
        ...ownerBookingData,
        'ticketId': newTicketId,
        'name': requesterName,
        'tokenNumber': requesterToken,
        'uid': requesterUid,
        'slots': [slotInfo], // Only the transferred slot
      };

      // 4. Determine the owner's remaining slots
      final ownerSlots =
          List<String>.from(ownerBookingData['slots'] as List? ?? []);
      ownerSlots.remove(slotInfo);
      final ownerHasRemainingSlots = ownerSlots.isNotEmpty;

      // Convert date from dd-MM-yyyy → the format used in bookingDetails doc key
      // bookingDetails collection uses the date string as-is from the booking
      final bookingDate = ownerBookingData['date'] as String? ?? date;

      // 5. Locate the global booking document
      final globalBookingRef = _firestore
          .collection('bookingDetails')
          .doc(bookingDate)
          .collection('booking')
          .doc(bookingId);

      // 6. Perform all operations in a batch
      final batch = _firestore.batch();

      // 6a. Remove slot from owner's user booking (or delete doc if no slots remain)
      if (ownerHasRemainingSlots) {
        batch.update(ownerBookingRef, {
          'slots': FieldValue.arrayRemove([slotInfo]),
        });
      } else {
        batch.delete(ownerBookingRef);
      }

      // 6b. Remove slot from global booking (or delete doc if no slots remain)
      final globalSnapshot = await globalBookingRef.get();
      if (globalSnapshot.exists) {
        if (ownerHasRemainingSlots) {
          batch.update(globalBookingRef, {
            'slots': FieldValue.arrayRemove([slotInfo]),
          });
        } else {
          batch.delete(globalBookingRef);
        }
      }

      // 6c. Create new booking for requester in user bookings
      final requesterBookingRef = _firestore
          .collection('bookingUserDetails')
          .doc(requesterUid)
          .collection('bookings')
          .doc(newTicketId);
      batch.set(requesterBookingRef, newBookingData);

      // 6d. Create new global booking entry for requester
      final newGlobalBookingRef = _firestore
          .collection('bookingDetails')
          .doc(bookingDate)
          .collection('booking')
          .doc(newTicketId);
      batch.set(newGlobalBookingRef, newBookingData);

      // 7. Commit all changes atomically
      await batch.commit();

      dev.log(
        'Slot "$slotInfo" transferred from $ownerUid to $requesterUid. '
        'Old ticket: $bookingId, New ticket: $newTicketId',
        name: 'TransferSlotBooking',
      );
      GCPLog.info(
        'Slot transferred: $slotInfo ($bookingId → $newTicketId)',
      );
    } catch (e, st) {
      dev.log(
        'Failed to transfer slot: $e\n$st',
        name: 'TransferSlotBooking',
      );
      GCPLog.error('Failed to transfer slot booking', error: e);
      rethrow;
    }
  }
}
