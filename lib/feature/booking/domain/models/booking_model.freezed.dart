// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingDetails {

 String get ticketId; String get tokenNumber; String get name; String get week; String get courseCode; String get date; List<String> get slots; String get slotKey; String get hall; String get startTime; String get endTime;
/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingDetailsCopyWith<BookingDetails> get copyWith => _$BookingDetailsCopyWithImpl<BookingDetails>(this as BookingDetails, _$identity);

  /// Serializes this BookingDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingDetails&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.tokenNumber, tokenNumber) || other.tokenNumber == tokenNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.week, week) || other.week == week)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.slots, slots)&&(identical(other.slotKey, slotKey) || other.slotKey == slotKey)&&(identical(other.hall, hall) || other.hall == hall)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ticketId,tokenNumber,name,week,courseCode,date,const DeepCollectionEquality().hash(slots),slotKey,hall,startTime,endTime);

@override
String toString() {
  return 'BookingDetails(ticketId: $ticketId, tokenNumber: $tokenNumber, name: $name, week: $week, courseCode: $courseCode, date: $date, slots: $slots, slotKey: $slotKey, hall: $hall, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $BookingDetailsCopyWith<$Res>  {
  factory $BookingDetailsCopyWith(BookingDetails value, $Res Function(BookingDetails) _then) = _$BookingDetailsCopyWithImpl;
@useResult
$Res call({
 String ticketId, String tokenNumber, String name, String week, String courseCode, String date, List<String> slots, String slotKey, String hall, String startTime, String endTime
});




}
/// @nodoc
class _$BookingDetailsCopyWithImpl<$Res>
    implements $BookingDetailsCopyWith<$Res> {
  _$BookingDetailsCopyWithImpl(this._self, this._then);

  final BookingDetails _self;
  final $Res Function(BookingDetails) _then;

/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ticketId = null,Object? tokenNumber = null,Object? name = null,Object? week = null,Object? courseCode = null,Object? date = null,Object? slots = null,Object? slotKey = null,Object? hall = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_self.copyWith(
ticketId: null == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String,tokenNumber: null == tokenNumber ? _self.tokenNumber : tokenNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<String>,slotKey: null == slotKey ? _self.slotKey : slotKey // ignore: cast_nullable_to_non_nullable
as String,hall: null == hall ? _self.hall : hall // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingDetails].
extension BookingDetailsPatterns on BookingDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingDetails value)  $default,){
final _that = this;
switch (_that) {
case _BookingDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingDetails value)?  $default,){
final _that = this;
switch (_that) {
case _BookingDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ticketId,  String tokenNumber,  String name,  String week,  String courseCode,  String date,  List<String> slots,  String slotKey,  String hall,  String startTime,  String endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingDetails() when $default != null:
return $default(_that.ticketId,_that.tokenNumber,_that.name,_that.week,_that.courseCode,_that.date,_that.slots,_that.slotKey,_that.hall,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ticketId,  String tokenNumber,  String name,  String week,  String courseCode,  String date,  List<String> slots,  String slotKey,  String hall,  String startTime,  String endTime)  $default,) {final _that = this;
switch (_that) {
case _BookingDetails():
return $default(_that.ticketId,_that.tokenNumber,_that.name,_that.week,_that.courseCode,_that.date,_that.slots,_that.slotKey,_that.hall,_that.startTime,_that.endTime);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ticketId,  String tokenNumber,  String name,  String week,  String courseCode,  String date,  List<String> slots,  String slotKey,  String hall,  String startTime,  String endTime)?  $default,) {final _that = this;
switch (_that) {
case _BookingDetails() when $default != null:
return $default(_that.ticketId,_that.tokenNumber,_that.name,_that.week,_that.courseCode,_that.date,_that.slots,_that.slotKey,_that.hall,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingDetails implements BookingDetails {
  const _BookingDetails({this.ticketId = '', this.tokenNumber = '', this.name = '', this.week = '', this.courseCode = '', this.date = '', final  List<String> slots = const [], this.slotKey = '', this.hall = '2216-Hall', this.startTime = '', this.endTime = ''}): _slots = slots;
  factory _BookingDetails.fromJson(Map<String, dynamic> json) => _$BookingDetailsFromJson(json);

@override@JsonKey() final  String ticketId;
@override@JsonKey() final  String tokenNumber;
@override@JsonKey() final  String name;
@override@JsonKey() final  String week;
@override@JsonKey() final  String courseCode;
@override@JsonKey() final  String date;
 final  List<String> _slots;
@override@JsonKey() List<String> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}

@override@JsonKey() final  String slotKey;
@override@JsonKey() final  String hall;
@override@JsonKey() final  String startTime;
@override@JsonKey() final  String endTime;

/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingDetailsCopyWith<_BookingDetails> get copyWith => __$BookingDetailsCopyWithImpl<_BookingDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingDetails&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.tokenNumber, tokenNumber) || other.tokenNumber == tokenNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.week, week) || other.week == week)&&(identical(other.courseCode, courseCode) || other.courseCode == courseCode)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._slots, _slots)&&(identical(other.slotKey, slotKey) || other.slotKey == slotKey)&&(identical(other.hall, hall) || other.hall == hall)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ticketId,tokenNumber,name,week,courseCode,date,const DeepCollectionEquality().hash(_slots),slotKey,hall,startTime,endTime);

@override
String toString() {
  return 'BookingDetails(ticketId: $ticketId, tokenNumber: $tokenNumber, name: $name, week: $week, courseCode: $courseCode, date: $date, slots: $slots, slotKey: $slotKey, hall: $hall, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$BookingDetailsCopyWith<$Res> implements $BookingDetailsCopyWith<$Res> {
  factory _$BookingDetailsCopyWith(_BookingDetails value, $Res Function(_BookingDetails) _then) = __$BookingDetailsCopyWithImpl;
@override @useResult
$Res call({
 String ticketId, String tokenNumber, String name, String week, String courseCode, String date, List<String> slots, String slotKey, String hall, String startTime, String endTime
});




}
/// @nodoc
class __$BookingDetailsCopyWithImpl<$Res>
    implements _$BookingDetailsCopyWith<$Res> {
  __$BookingDetailsCopyWithImpl(this._self, this._then);

  final _BookingDetails _self;
  final $Res Function(_BookingDetails) _then;

/// Create a copy of BookingDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ticketId = null,Object? tokenNumber = null,Object? name = null,Object? week = null,Object? courseCode = null,Object? date = null,Object? slots = null,Object? slotKey = null,Object? hall = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_BookingDetails(
ticketId: null == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String,tokenNumber: null == tokenNumber ? _self.tokenNumber : tokenNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as String,courseCode: null == courseCode ? _self.courseCode : courseCode // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<String>,slotKey: null == slotKey ? _self.slotKey : slotKey // ignore: cast_nullable_to_non_nullable
as String,hall: null == hall ? _self.hall : hall // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
