// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerDetails _$ServerDetailsFromJson(Map<String, dynamic> json) =>
    _ServerDetails(
      isAppUnderMaintenance: json['isAppUnderMaintenance'] as bool? ?? false,
      version: json['version'] as String? ?? '',
      allowedUserVersions:
          (json['allowed_user_version'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ServerDetailsToJson(_ServerDetails instance) =>
    <String, dynamic>{
      'isAppUnderMaintenance': instance.isAppUnderMaintenance,
      'version': instance.version,
      'allowed_user_version': instance.allowedUserVersions,
    };
