import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_details.freezed.dart';
part 'server_details.g.dart';

@freezed
sealed class ServerDetails with _$ServerDetails {
  const factory ServerDetails({
    @Default(false) bool isAppUnderMaintenance,
    @Default('') String version,
  }) = _ServerDetails;

  factory ServerDetails.fromJson(Map<String, dynamic> json) =>
      _$ServerDetailsFromJson(json);
}
