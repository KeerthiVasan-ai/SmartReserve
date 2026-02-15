import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:developer" as dev;

class UpdateBookingSlots {
  /// Swaps a single slot in an existing booking document.
  /// Removes [oldSlot] and adds [newSlot] in the slots array.
  /// Also updates courseCode and slotKey if provided.
  static Future<void> swapSlotInUserBooking({
    required String userId,
    required String ticketId,
    required String oldSlot,
    required String newSlot,
    String? courseCode,
    String? slotKey,
  }) async {
    try {
      final bookingRef = FirebaseFirestore.instance
          .collection('bookingUserDetails')
          .doc(userId)
          .collection('bookings')
          .doc(ticketId);

      Map<String, dynamic> updateData = {
        'slots': FieldValue.arrayRemove([oldSlot]),
      };
      if (courseCode != null) {
        updateData['courseCode'] = courseCode;
      }
      if (slotKey != null) {
        updateData['slotKey'] = slotKey;
      }

      // First remove the old slot and update other fields
      await bookingRef.update(updateData);

      // Then add the new slot
      await bookingRef.update({
        'slots': FieldValue.arrayUnion([newSlot]),
      });

      dev.log('Slot swapped successfully in user booking!', name: "Success");
    } catch (error) {
      dev.log(error.toString(), name: "Error");
      rethrow;
    }
  }

  static Future<void> swapSlotInGlobalBooking({
    required String date,
    required String ticketId,
    required String oldSlot,
    required String newSlot,
    String? courseCode,
    String? slotKey,
  }) async {
    try {
      final bookingRef = FirebaseFirestore.instance
          .collection('bookingDetails')
          .doc(date)
          .collection('booking')
          .doc(ticketId);

      final docSnapshot = await bookingRef.get();
      if (!docSnapshot.exists) {
        dev.log('Global booking doc not found at $date/$ticketId, skipping global swap.', name: "Warning");
        return;
      }

      Map<String, dynamic> updateData = {
        'slots': FieldValue.arrayRemove([oldSlot]),
      };
      if (courseCode != null) {
        updateData['courseCode'] = courseCode;
      }
      if (slotKey != null) {
        updateData['slotKey'] = slotKey;
      }

      await bookingRef.update(updateData);
      await bookingRef.update({
        'slots': FieldValue.arrayUnion([newSlot]),
      });

      dev.log('Slot swapped successfully in global booking!', name: "Success");
    } catch (error) {
      dev.log(error.toString(), name: "Error");
      rethrow;
    }
  }

  /// Moves a slot from one date to another in global bookings.
  /// This removes the old slot from oldDate doc and creates/adds to newDate doc.
  static Future<void> moveSlotToNewDate({
    required String userId,
    required String ticketId,
    required String oldDate,
    required String newDate,
    required String oldSlot,
    required String newSlot,
    required Map<String, dynamic> fullBookingData,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // 1. Remove old slot from user booking
      final userBookingRef = firestore
          .collection('bookingUserDetails')
          .doc(userId)
          .collection('bookings')
          .doc(ticketId);

      await userBookingRef.update({
        'slots': FieldValue.arrayRemove([oldSlot]),
      });

      // Check if user booking doc still has slots
      final userSnapshot = await userBookingRef.get();
      if (userSnapshot.exists) {
        final remainingSlots =
            (userSnapshot.data() as Map<String, dynamic>)['slots'] as List? ?? [];
        if (remainingSlots.isEmpty) {
          await userBookingRef.delete();
        }
      }

      // 2. Remove old slot from global booking on old date
      final oldGlobalRef = firestore
          .collection('bookingDetails')
          .doc(oldDate)
          .collection('booking')
          .doc(ticketId);

      final globalDocSnapshot = await oldGlobalRef.get();
      if (globalDocSnapshot.exists) {
        await oldGlobalRef.update({
          'slots': FieldValue.arrayRemove([oldSlot]),
        });

        // Check if global doc still has slots
        final globalSnapshot = await oldGlobalRef.get();
        if (globalSnapshot.exists) {
          final remainingSlots =
              (globalSnapshot.data() as Map<String, dynamic>)['slots'] as List? ?? [];
          if (remainingSlots.isEmpty) {
            await oldGlobalRef.delete();
          }
        }
      } else {
        dev.log('Global booking doc not found at $oldDate/$ticketId, skipping.', name: "Warning");
      }

      // 3. Create new booking entry for the new date
      await InsertNewSlotBooking.addSlotBooking(
        uid: userId,
        date: newDate,
        ticketId: '${ticketId}_${newSlot.replaceAll(' ', '').replaceAll(':', '')}',
        bookingData: fullBookingData,
      );

      dev.log('Slot moved to new date successfully!', name: "Success");
    } catch (error) {
      dev.log(error.toString(), name: "Error");
      rethrow;
    }
  }
}

/// Helper to create a new booking entry for a moved slot
class InsertNewSlotBooking {
  static Future<void> addSlotBooking({
    required String uid,
    required String date,
    required String ticketId,
    required Map<String, dynamic> bookingData,
  }) async {
    final firestore = FirebaseFirestore.instance;

    // Add to user bookings
    await firestore
        .collection('bookingUserDetails')
        .doc(uid)
        .collection('bookings')
        .doc(ticketId)
        .set(bookingData);

    // Add to global bookings
    await firestore
        .collection('bookingDetails')
        .doc(date)
        .collection('booking')
        .doc(ticketId)
        .set(bookingData);
  }
}
