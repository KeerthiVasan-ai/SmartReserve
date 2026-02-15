import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_reserve/core/utils/generate_token.dart';
import 'package:smart_reserve/core/utils/generate_week.dart';
import 'package:smart_reserve/feature/auth/data/datasources/auth_remote_source.dart';
import 'package:smart_reserve/feature/booking/data/datasources/fetch_alloted_slots.dart';
import 'package:smart_reserve/feature/booking/data/datasources/fetch_time_slots.dart';
import 'package:smart_reserve/feature/booking/data/datasources/fetch_times.dart';
import 'package:smart_reserve/feature/booking/data/datasources/fetch_user_booking.dart';
import 'package:smart_reserve/feature/booking/data/datasources/fetch_user_name.dart';
import 'package:smart_reserve/feature/booking/data/datasources/insert_booking_details.dart';
import 'package:smart_reserve/feature/booking/data/datasources/update_time_slots.dart';
import 'package:smart_reserve/feature/booking/data/datasources/update_booking_slots.dart';
import 'package:smart_reserve/feature/booking/data/datasources/delete_user_booking.dart';
import 'package:smart_reserve/feature/booking/domain/models/booking_model.dart';

part 'booking_provider.freezed.dart';
part 'booking_provider.g.dart';

@freezed
abstract class BookingState with _$BookingState {
  const factory BookingState({
    @Default(BookingDetails()) BookingDetails bookingDetails,
    @Default({}) Map<String, bool> timeSlots,
    @Default({}) Map<String, String> timeKeys,
    @Default(0) int slotCount,
    @Default(true) bool isLoading,
    @Default(false) bool isSubmitting,
    String? errorMessage,
    String? successMessage,
    String? courseCodeError,
    String? dateError,
    @Default(false) bool isEditing,
    BookingDetails? originalBooking,
    String? editingSlot,
  }) = _BookingState;
}

@riverpod
class BookingNotifier extends _$BookingNotifier {
  @override
  BookingState build() {
    return const BookingState();
  }

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    try {
      final ticketId = generateToken();
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final token = await FetchToken.fetchToken() ?? '';
      final name = await FetchName.fetchName() ?? '';
      final slotCount = await FetchAllottedSlots.getAllottedSlots(uid);
      final timeKeys = await FetchTimes.fetchTimeKey();

      state = state.copyWith(
        bookingDetails: state.bookingDetails.copyWith(
          ticketId: ticketId,
          tokenNumber: token,
          name: name,
        ),
        slotCount: slotCount,
        timeKeys: timeKeys,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void updateCourseCode(String code) {
    state = state.copyWith(
      bookingDetails: state.bookingDetails.copyWith(courseCode: code),
      courseCodeError: null,
    );
  }

  void setDate(DateTime date) async {
    final dateString = DateFormat('dd-MM-yyyy').format(date);
    final dateForFetch = date.toString().split(" ")[0];

    state = state.copyWith(
      bookingDetails: state.bookingDetails.copyWith(
        date: dateString,
        slots: [], // Clear slots
      ),
      timeSlots: {},
      dateError: null,
    );

    try {
      final slots = await FetchTimeSlots.fetchTimeSlots(dateForFetch);

      // If editing and same date as original, free the slot being edited
      if (state.isEditing && state.originalBooking != null) {
        final origDate = state.originalBooking!.date;
        final selectedDateStr = DateFormat('dd-MM-yyyy').format(date);
        if (origDate == selectedDateStr) {
          if (state.editingSlot != null) {
            // Partial edit: only free the slot being swapped
            if (slots.containsKey(state.editingSlot!)) {
              slots[state.editingSlot!] = true;
            }
          } else {
            // Full edit: free all original slots
            for (final slot in state.originalBooking!.slots) {
              if (slots.containsKey(slot)) {
                slots[slot] = true;
              }
            }
          }
        }
      }

      state = state.copyWith(timeSlots: slots);
    } catch (e) {
      state = state.copyWith(errorMessage: "Failed to fetch time slots");
    }
  }

  void toggleSlot(String slot) {
    final currentSlots = List<String>.from(state.bookingDetails.slots);
    // When editing, only allow 1 slot (editing one slot at a time)
    final maxSlots = state.isEditing ? 1 : 2;
    if (currentSlots.contains(slot)) {
      currentSlots.remove(slot);
    } else if (currentSlots.length < maxSlots) {
      currentSlots.add(slot);
    } else {
      return;
    }
    state = state.copyWith(
      bookingDetails: state.bookingDetails.copyWith(slots: currentSlots),
    );
  }

  Future<void> initializeForEdit(BookingDetails existingBooking, {String? editingSlot}) async {
    state = state.copyWith(isLoading: true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final slotCount = await FetchAllottedSlots.getAllottedSlots(uid);
      final timeKeys = await FetchTimes.fetchTimeKey();

      final dateForFetch = existingBooking.date.split("-").reversed.join("-"); // yyyy-MM-dd

      Map<String, bool> slots = {};
      try {
        slots = await FetchTimeSlots.fetchTimeSlots(dateForFetch);
      } catch (e) {
        // limit fetch failure?
      }

      // Only free the slot being edited (not all slots)
      final slotToFree = editingSlot ?? existingBooking.slots.firstOrNull;
      if (slotToFree != null && slots.containsKey(slotToFree)) {
        slots[slotToFree] = true;
      }

      state = state.copyWith(
        bookingDetails: existingBooking.copyWith(slots: []),
        originalBooking: existingBooking,
        editingSlot: editingSlot,
        isEditing: true,
        slotCount: slotCount,
        timeKeys: timeKeys,
        timeSlots: slots,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> verifyAndSubmit() async {
    final details = state.bookingDetails;
    
    // Specific Field Validation
    String? courseError;
    String? dateErr;

    if (details.courseCode.isEmpty) {
      courseError = "Enter Course Code";
    }
    if (details.date.isEmpty) {
      dateErr = "Select a Date";
    }
    
    if (courseError != null || dateErr != null) {
      state = state.copyWith(
        courseCodeError: courseError,
        dateError: dateErr,
      );
      return;
    }

    if (details.slots.isEmpty) {
      state = state.copyWith(errorMessage: "Please select at least one slot to book");
      return;
    }

    // If editing, check if user actually changed anything
    if (state.isEditing && state.originalBooking != null) {
      final orig = state.originalBooking!;
      final sameDate = orig.date == details.date;
      final sameSlots = orig.slots.length == details.slots.length &&
          orig.slots.toSet().containsAll(details.slots);
      final sameCourse = orig.courseCode == details.courseCode;
      
      if (sameDate && sameSlots && sameCourse) {
        state = state.copyWith(errorMessage: "No changes made. Select a different slot or date to update.");
        return;
      }
    }

    // Verify selected slots are actually available
    for (final slot in details.slots) {
      final isAvailable = state.timeSlots[slot];
      if (isAvailable == null || isAvailable == false) {
        state = state.copyWith(errorMessage: "Slot '$slot' is no longer available. Please select a different slot.");
        return;
      }
    }

    state = state.copyWith(
      isSubmitting: true,
      errorMessage: null,
      successMessage: null,
      courseCodeError: null,
      dateError: null,
    );

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await FetchUserBooking.fetchBookingDetails(uid).first;

      if (snapshot.docs.isEmpty) {
        await _performSubmission();
      } else {
        String currentWeek = getWeekNumber(details.date);

        List<QueryDocumentSnapshot> filteredSnapshots = snapshot.docs
            .where((doc) => doc['week'] == currentWeek)
            .toList();

        // Calculate currently booked slots for the target week
        int bookedSlotsCount = 0;
        for (var doc in filteredSnapshots) {
          bookedSlotsCount += (doc['slots'] as List).length;
        }

        // If Editing...
        if (state.isEditing && state.originalBooking != null) {
          final originalWeek = getWeekNumber(state.originalBooking!.date);
          
          // If we are rescheduling to the SAME week, we don't count the ORIGINAL slots
          if (originalWeek == currentWeek) {
             bookedSlotsCount -= state.originalBooking!.slots.length;
          }
        }

        final remaining = state.slotCount - bookedSlotsCount;

        // Check Limit
        if (details.slots.length <= remaining) {
             await _performSubmission();
        } else {
             state = state.copyWith(
                isSubmitting: false,
                errorMessage: "Weekly slot limit reached. You can book $remaining more slot(s) this week, but you selected ${details.slots.length}.",
             );
        }
      }
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: "Something went wrong: ${e.toString()}");
    }
  }

  Future<void> _performSubmission() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final details = state.bookingDetails;
      final newSlot = details.slots[0];
      final newSlotKey = state.timeKeys[newSlot] ?? '';
      final week = getWeekNumber(details.date);

      if (state.isEditing && state.originalBooking != null && state.editingSlot != null) {
        // PARTIAL EDIT: swapping one slot in a multi-slot booking
        final old = state.originalBooking!;
        final oldSlot = state.editingSlot!;
        final sameDate = old.date == details.date;

        if (sameDate) {
          // Same date: swap the slot in existing booking doc
          await UpdateBookingSlots.swapSlotInUserBooking(
            userId: uid,
            ticketId: old.ticketId,
            oldSlot: oldSlot,
            newSlot: newSlot,
            courseCode: details.courseCode,
            slotKey: newSlotKey,
          );
          await UpdateBookingSlots.swapSlotInGlobalBooking(
            date: old.date,
            ticketId: old.ticketId,
            oldSlot: oldSlot,
            newSlot: newSlot,
            courseCode: details.courseCode,
            slotKey: newSlotKey,
          );
        } else {
          // Different date: remove old slot from existing doc, create new booking for new date
          final newBookingData = details.copyWith(
            week: week,
            slotKey: newSlotKey,
            slots: [newSlot],
          ).getBookingDetails();

          await UpdateBookingSlots.moveSlotToNewDate(
            userId: uid,
            ticketId: old.ticketId,
            oldDate: old.date,
            newDate: details.date,
            oldSlot: oldSlot,
            newSlot: newSlot,
            fullBookingData: newBookingData,
          );
        }

        // Update time slot availability
        final oldDate = DateFormat("dd-MM-yyyy").parse(old.date);
        await UpdateTimeSlots.deleteSlot(
          DateFormat('yyyy-MM-dd').format(oldDate),
          [oldSlot],
          true,
        );
        final newDate = DateFormat("dd-MM-yyyy").parse(details.date);
        await UpdateTimeSlots.insertSlots(
          DateFormat('yyyy-MM-dd').format(newDate),
          [newSlot],
          false,
        );

        state = state.copyWith(
          isSubmitting: false,
          successMessage: "Slot updated: $oldSlot → $newSlot",
          bookingDetails: details.copyWith(week: week, slotKey: newSlotKey),
        );
      } else if (state.isEditing && state.originalBooking != null) {
        // FULL EDIT: single-slot booking, delete old and create new
        final old = state.originalBooking!;

        await DeleteUserBooking.deleteUserBookingSlots(uid, old.ticketId, old.slots);
        await DeleteUserBooking.deleteBookingSlots(old.date, old.ticketId, old.slots);

        final oldDate = DateFormat("dd-MM-yyyy").parse(old.date);
        await UpdateTimeSlots.deleteSlot(
          DateFormat('yyyy-MM-dd').format(oldDate),
          old.slots,
          true,
        );

        final updatedDetails = details.copyWith(
          week: week,
          slotKey: newSlotKey,
        );

        final bookingData = updatedDetails.getBookingDetails();

        await InsertBookingDetails.addIndividualBookingDetails(
          uid: uid,
          bookingData: bookingData,
          ticketId: updatedDetails.ticketId,
        );
        await InsertBookingDetails.addBookingDetails(
          date: updatedDetails.date,
          ticketId: updatedDetails.ticketId,
          bookingData: bookingData,
        );

        final newDate = DateFormat("dd-MM-yyyy").parse(updatedDetails.date);
        await UpdateTimeSlots.insertSlots(
          DateFormat('yyyy-MM-dd').format(newDate),
          updatedDetails.slots,
          false,
        );

        state = state.copyWith(
          isSubmitting: false,
          successMessage: "Booking Updated Successfully",
          bookingDetails: updatedDetails,
        );
      } else {
        // NEW BOOKING
        final updatedDetails = details.copyWith(
          week: week,
          slotKey: newSlotKey,
        );

        final bookingData = updatedDetails.getBookingDetails();

        await InsertBookingDetails.addIndividualBookingDetails(
          uid: uid,
          bookingData: bookingData,
          ticketId: updatedDetails.ticketId,
        );
        await InsertBookingDetails.addBookingDetails(
          date: updatedDetails.date,
          ticketId: updatedDetails.ticketId,
          bookingData: bookingData,
        );

        final newDate = DateFormat("dd-MM-yyyy").parse(updatedDetails.date);
        await UpdateTimeSlots.insertSlots(
          DateFormat('yyyy-MM-dd').format(newDate),
          updatedDetails.slots,
          false,
        );

        state = state.copyWith(
          isSubmitting: false,
          successMessage: "Booked Successfully",
          bookingDetails: updatedDetails,
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: "Submission Failed: ${e.toString()}",
      );
    }
  }

  void resetMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }

  Future<void> deleteBooking(String uid, String ticketId, String date, List<dynamic> slotsToRemove) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null, successMessage: null);
    try {
      // 1. Delete slots from user bookings
      await DeleteUserBooking.deleteUserBookingSlots(uid, ticketId, slotsToRemove);
      if (!ref.mounted) return;

      // 2. Delete slots from global bookings
      await DeleteUserBooking.deleteBookingSlots(date, ticketId, slotsToRemove);
      if (!ref.mounted) return;

      // 3. Update availability (make slots available again)
      final myDate = DateFormat("dd-MM-yyyy").parse(date);
      await UpdateTimeSlots.deleteSlot(
        DateFormat('yyyy-MM-dd').format(myDate),
        slotsToRemove,
        true,
      );
      if (!ref.mounted) return;

      state = state.copyWith(
        isSubmitting: false,
        successMessage: "Booking deleted successfully",
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: "Failed to delete booking: ${e.toString()}",
      );
    }
  }
}
