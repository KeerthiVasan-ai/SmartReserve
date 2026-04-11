import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
sealed class BookingDetails with _$BookingDetails {
  const factory BookingDetails({
    @Default('') String ticketId,
    @Default('') String tokenNumber,
    @Default('') String name,
    @Default('') String uid,
    @Default('') String week,
    @Default('') String courseCode,
    @Default('') String date,
    @Default([]) List<String> slots,
    @Default('') String slotKey,
    @Default('2216-Hall') String hall,
    @Default('') String startTime,
    @Default('') String endTime,
  }) = _BookingDetails;

  factory BookingDetails.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailsFromJson(json);
}

extension BookingDetailsX on BookingDetails {
  Map<String, dynamic> getBookingDetails() {
    return toJson();
  }
}
