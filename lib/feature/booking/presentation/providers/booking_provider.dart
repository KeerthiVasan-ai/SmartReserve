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
      state = state.copyWith(timeSlots: slots);
    } catch (e) {
      state = state.copyWith(errorMessage: "Failed to fetch time slots");
    }
  }

  void toggleSlot(String slot) {
    final currentSlots = List<String>.from(state.bookingDetails.slots);
    if (currentSlots.contains(slot)) {
      currentSlots.remove(slot);
    } else if (currentSlots.length < 2) {
      currentSlots.add(slot);
    } else {
      return;
    }
    state = state.copyWith(
      bookingDetails: state.bookingDetails.copyWith(slots: currentSlots),
    );
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
      state = state.copyWith(errorMessage: "Select at least one slot");
      return;
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

        if (filteredSnapshots.isEmpty) {
          await _performSubmission();
        } else if (filteredSnapshots.length == state.slotCount) {
          state = state.copyWith(
            isSubmitting: false,
            errorMessage: "Limit Reached For this Week",
          );
        } else {
          int bookedSlots = filteredSnapshots.length;
          int slotCounter = 0;
          for (int i = 0; i < bookedSlots; i++) {
            int slotsLength = (filteredSnapshots[i]['slots'] as List).length;
            slotCounter += slotsLength;
          }

          if (slotCounter < state.slotCount) {
            if (((state.slotCount - slotCounter) >= details.slots.length)) {
              await _performSubmission();
            } else {
              state = state.copyWith(
                isSubmitting: false,
                errorMessage:
                    "Remaining Slots available for this week is ${state.slotCount - slotCounter}",
              );
            }
          } else {
            state = state.copyWith(
              isSubmitting: false,
              errorMessage: "Limit Reached For this Week",
            );
          }
        }
      }
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
    }
  }

  Future<void> _performSubmission() async {
    try {
      final week = getWeekNumber(state.bookingDetails.date);

      final updatedDetails = state.bookingDetails.copyWith(
        week: week,
        slotKey: state.timeKeys[state.bookingDetails.slots[0]] ?? '',
      );

      final uid = FirebaseAuth.instance.currentUser!.uid;
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

      final myDate = DateFormat("dd-MM-yyyy").parse(updatedDetails.date);
      await UpdateTimeSlots.insertSlots(
        DateFormat('yyyy-MM-dd').format(myDate),
        updatedDetails.slots,
        false,
      );

      state = state.copyWith(
        isSubmitting: false,
        successMessage: "Booked Successfully",
        bookingDetails:
            updatedDetails, // Ensure state has the final details (with week/key)
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: "Submission Failed: ${e.toString()}",
      );
    }
  }

  void resetMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}
