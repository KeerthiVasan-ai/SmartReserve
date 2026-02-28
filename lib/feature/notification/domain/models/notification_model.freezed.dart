// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SlotNotification {

 String get notificationId; String get requestedBy; String get requestedTo; String get requestedByName; String get requestedToName; String get bookingId; String get slotInfo; String get date; String get status; String get notificationInitiatedAt;
/// Create a copy of SlotNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotNotificationCopyWith<SlotNotification> get copyWith => _$SlotNotificationCopyWithImpl<SlotNotification>(this as SlotNotification, _$identity);

  /// Serializes this SlotNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotNotification&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.requestedTo, requestedTo) || other.requestedTo == requestedTo)&&(identical(other.requestedByName, requestedByName) || other.requestedByName == requestedByName)&&(identical(other.requestedToName, requestedToName) || other.requestedToName == requestedToName)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.slotInfo, slotInfo) || other.slotInfo == slotInfo)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.notificationInitiatedAt, notificationInitiatedAt) || other.notificationInitiatedAt == notificationInitiatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationId,requestedBy,requestedTo,requestedByName,requestedToName,bookingId,slotInfo,date,status,notificationInitiatedAt);

@override
String toString() {
  return 'SlotNotification(notificationId: $notificationId, requestedBy: $requestedBy, requestedTo: $requestedTo, requestedByName: $requestedByName, requestedToName: $requestedToName, bookingId: $bookingId, slotInfo: $slotInfo, date: $date, status: $status, notificationInitiatedAt: $notificationInitiatedAt)';
}


}

/// @nodoc
abstract mixin class $SlotNotificationCopyWith<$Res>  {
  factory $SlotNotificationCopyWith(SlotNotification value, $Res Function(SlotNotification) _then) = _$SlotNotificationCopyWithImpl;
@useResult
$Res call({
 String notificationId, String requestedBy, String requestedTo, String requestedByName, String requestedToName, String bookingId, String slotInfo, String date, String status, String notificationInitiatedAt
});




}
/// @nodoc
class _$SlotNotificationCopyWithImpl<$Res>
    implements $SlotNotificationCopyWith<$Res> {
  _$SlotNotificationCopyWithImpl(this._self, this._then);

  final SlotNotification _self;
  final $Res Function(SlotNotification) _then;

/// Create a copy of SlotNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notificationId = null,Object? requestedBy = null,Object? requestedTo = null,Object? requestedByName = null,Object? requestedToName = null,Object? bookingId = null,Object? slotInfo = null,Object? date = null,Object? status = null,Object? notificationInitiatedAt = null,}) {
  return _then(_self.copyWith(
notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as String,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String,requestedTo: null == requestedTo ? _self.requestedTo : requestedTo // ignore: cast_nullable_to_non_nullable
as String,requestedByName: null == requestedByName ? _self.requestedByName : requestedByName // ignore: cast_nullable_to_non_nullable
as String,requestedToName: null == requestedToName ? _self.requestedToName : requestedToName // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,slotInfo: null == slotInfo ? _self.slotInfo : slotInfo // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notificationInitiatedAt: null == notificationInitiatedAt ? _self.notificationInitiatedAt : notificationInitiatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SlotNotification].
extension SlotNotificationPatterns on SlotNotification {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlotNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlotNotification() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlotNotification value)  $default,){
final _that = this;
switch (_that) {
case _SlotNotification():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlotNotification value)?  $default,){
final _that = this;
switch (_that) {
case _SlotNotification() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String notificationId,  String requestedBy,  String requestedTo,  String requestedByName,  String requestedToName,  String bookingId,  String slotInfo,  String date,  String status,  String notificationInitiatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlotNotification() when $default != null:
return $default(_that.notificationId,_that.requestedBy,_that.requestedTo,_that.requestedByName,_that.requestedToName,_that.bookingId,_that.slotInfo,_that.date,_that.status,_that.notificationInitiatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String notificationId,  String requestedBy,  String requestedTo,  String requestedByName,  String requestedToName,  String bookingId,  String slotInfo,  String date,  String status,  String notificationInitiatedAt)  $default,) {final _that = this;
switch (_that) {
case _SlotNotification():
return $default(_that.notificationId,_that.requestedBy,_that.requestedTo,_that.requestedByName,_that.requestedToName,_that.bookingId,_that.slotInfo,_that.date,_that.status,_that.notificationInitiatedAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String notificationId,  String requestedBy,  String requestedTo,  String requestedByName,  String requestedToName,  String bookingId,  String slotInfo,  String date,  String status,  String notificationInitiatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SlotNotification() when $default != null:
return $default(_that.notificationId,_that.requestedBy,_that.requestedTo,_that.requestedByName,_that.requestedToName,_that.bookingId,_that.slotInfo,_that.date,_that.status,_that.notificationInitiatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SlotNotification implements SlotNotification {
  const _SlotNotification({this.notificationId = '', this.requestedBy = '', this.requestedTo = '', this.requestedByName = '', this.requestedToName = '', this.bookingId = '', this.slotInfo = '', this.date = '', this.status = 'pending', this.notificationInitiatedAt = ''});
  factory _SlotNotification.fromJson(Map<String, dynamic> json) => _$SlotNotificationFromJson(json);

@override@JsonKey() final  String notificationId;
@override@JsonKey() final  String requestedBy;
@override@JsonKey() final  String requestedTo;
@override@JsonKey() final  String requestedByName;
@override@JsonKey() final  String requestedToName;
@override@JsonKey() final  String bookingId;
@override@JsonKey() final  String slotInfo;
@override@JsonKey() final  String date;
@override@JsonKey() final  String status;
@override@JsonKey() final  String notificationInitiatedAt;

/// Create a copy of SlotNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotNotificationCopyWith<_SlotNotification> get copyWith => __$SlotNotificationCopyWithImpl<_SlotNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlotNotification&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.requestedTo, requestedTo) || other.requestedTo == requestedTo)&&(identical(other.requestedByName, requestedByName) || other.requestedByName == requestedByName)&&(identical(other.requestedToName, requestedToName) || other.requestedToName == requestedToName)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.slotInfo, slotInfo) || other.slotInfo == slotInfo)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.notificationInitiatedAt, notificationInitiatedAt) || other.notificationInitiatedAt == notificationInitiatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationId,requestedBy,requestedTo,requestedByName,requestedToName,bookingId,slotInfo,date,status,notificationInitiatedAt);

@override
String toString() {
  return 'SlotNotification(notificationId: $notificationId, requestedBy: $requestedBy, requestedTo: $requestedTo, requestedByName: $requestedByName, requestedToName: $requestedToName, bookingId: $bookingId, slotInfo: $slotInfo, date: $date, status: $status, notificationInitiatedAt: $notificationInitiatedAt)';
}


}

/// @nodoc
abstract mixin class _$SlotNotificationCopyWith<$Res> implements $SlotNotificationCopyWith<$Res> {
  factory _$SlotNotificationCopyWith(_SlotNotification value, $Res Function(_SlotNotification) _then) = __$SlotNotificationCopyWithImpl;
@override @useResult
$Res call({
 String notificationId, String requestedBy, String requestedTo, String requestedByName, String requestedToName, String bookingId, String slotInfo, String date, String status, String notificationInitiatedAt
});




}
/// @nodoc
class __$SlotNotificationCopyWithImpl<$Res>
    implements _$SlotNotificationCopyWith<$Res> {
  __$SlotNotificationCopyWithImpl(this._self, this._then);

  final _SlotNotification _self;
  final $Res Function(_SlotNotification) _then;

/// Create a copy of SlotNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notificationId = null,Object? requestedBy = null,Object? requestedTo = null,Object? requestedByName = null,Object? requestedToName = null,Object? bookingId = null,Object? slotInfo = null,Object? date = null,Object? status = null,Object? notificationInitiatedAt = null,}) {
  return _then(_SlotNotification(
notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as String,requestedBy: null == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String,requestedTo: null == requestedTo ? _self.requestedTo : requestedTo // ignore: cast_nullable_to_non_nullable
as String,requestedByName: null == requestedByName ? _self.requestedByName : requestedByName // ignore: cast_nullable_to_non_nullable
as String,requestedToName: null == requestedToName ? _self.requestedToName : requestedToName // ignore: cast_nullable_to_non_nullable
as String,bookingId: null == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String,slotInfo: null == slotInfo ? _self.slotInfo : slotInfo // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notificationInitiatedAt: null == notificationInitiatedAt ? _self.notificationInitiatedAt : notificationInitiatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
