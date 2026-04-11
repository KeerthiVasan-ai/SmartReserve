import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
sealed class SlotNotification with _$SlotNotification {
  const factory SlotNotification({
    @Default('') String notificationId,
    @Default('') String requestedBy,
    @Default('') String requestedTo,
    @Default('') String requestedByName,
    @Default('') String requestedToName,
    @Default('') String bookingId,
    @Default('') String slotInfo,
    @Default('') String date,
    @Default('pending') String status,
    @Default('booking') String type,
    @Default('') String notificationInitiatedAt,
  }) = _SlotNotification;

  factory SlotNotification.fromJson(Map<String, dynamic> json) =>
      _$SlotNotificationFromJson(json);
}
