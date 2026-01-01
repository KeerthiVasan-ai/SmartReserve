// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingDetails _$BookingDetailsFromJson(Map<String, dynamic> json) =>
    _BookingDetails(
      ticketId: json['ticketId'] as String? ?? '',
      tokenNumber: json['tokenNumber'] as String? ?? '',
      name: json['name'] as String? ?? '',
      week: json['week'] as String? ?? '',
      courseCode: json['courseCode'] as String? ?? '',
      date: json['date'] as String? ?? '',
      slots:
          (json['slots'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      slotKey: json['slotKey'] as String? ?? '',
    );

Map<String, dynamic> _$BookingDetailsToJson(_BookingDetails instance) =>
    <String, dynamic>{
      'ticketId': instance.ticketId,
      'tokenNumber': instance.tokenNumber,
      'name': instance.name,
      'week': instance.week,
      'courseCode': instance.courseCode,
      'date': instance.date,
      'slots': instance.slots,
      'slotKey': instance.slotKey,
    };
