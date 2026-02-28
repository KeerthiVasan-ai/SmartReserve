// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SlotNotification _$SlotNotificationFromJson(Map<String, dynamic> json) =>
    _SlotNotification(
      notificationId: json['notificationId'] as String? ?? '',
      requestedBy: json['requestedBy'] as String? ?? '',
      requestedTo: json['requestedTo'] as String? ?? '',
      requestedByName: json['requestedByName'] as String? ?? '',
      requestedToName: json['requestedToName'] as String? ?? '',
      bookingId: json['bookingId'] as String? ?? '',
      slotInfo: json['slotInfo'] as String? ?? '',
      date: json['date'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      notificationInitiatedAt: json['notificationInitiatedAt'] as String? ?? '',
    );

Map<String, dynamic> _$SlotNotificationToJson(_SlotNotification instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'requestedBy': instance.requestedBy,
      'requestedTo': instance.requestedTo,
      'requestedByName': instance.requestedByName,
      'requestedToName': instance.requestedToName,
      'bookingId': instance.bookingId,
      'slotInfo': instance.slotInfo,
      'date': instance.date,
      'status': instance.status,
      'notificationInitiatedAt': instance.notificationInitiatedAt,
    };
