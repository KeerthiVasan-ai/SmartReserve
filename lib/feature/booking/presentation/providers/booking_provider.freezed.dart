// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingState {

 BookingDetails get bookingDetails; Map<String, bool> get timeSlots; Map<String, String> get timeKeys; int get slotCount; bool get isLoading; bool get isSubmitting; String? get errorMessage; String? get successMessage; String? get courseCodeError; String? get dateError; bool get isEditing; BookingDetails? get originalBooking; String? get editingSlot;
/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingStateCopyWith<BookingState> get copyWith => _$BookingStateCopyWithImpl<BookingState>(this as BookingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingState&&(identical(other.bookingDetails, bookingDetails) || other.bookingDetails == bookingDetails)&&const DeepCollectionEquality().equals(other.timeSlots, timeSlots)&&const DeepCollectionEquality().equals(other.timeKeys, timeKeys)&&(identical(other.slotCount, slotCount) || other.slotCount == slotCount)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage)&&(identical(other.courseCodeError, courseCodeError) || other.courseCodeError == courseCodeError)&&(identical(other.dateError, dateError) || other.dateError == dateError)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing)&&(identical(other.originalBooking, originalBooking) || other.originalBooking == originalBooking)&&(identical(other.editingSlot, editingSlot) || other.editingSlot == editingSlot));
}


@override
int get hashCode => Object.hash(runtimeType,bookingDetails,const DeepCollectionEquality().hash(timeSlots),const DeepCollectionEquality().hash(timeKeys),slotCount,isLoading,isSubmitting,errorMessage,successMessage,courseCodeError,dateError,isEditing,originalBooking,editingSlot);

@override
String toString() {
  return 'BookingState(bookingDetails: $bookingDetails, timeSlots: $timeSlots, timeKeys: $timeKeys, slotCount: $slotCount, isLoading: $isLoading, isSubmitting: $isSubmitting, errorMessage: $errorMessage, successMessage: $successMessage, courseCodeError: $courseCodeError, dateError: $dateError, isEditing: $isEditing, originalBooking: $originalBooking, editingSlot: $editingSlot)';
}


}

/// @nodoc
abstract mixin class $BookingStateCopyWith<$Res>  {
  factory $BookingStateCopyWith(BookingState value, $Res Function(BookingState) _then) = _$BookingStateCopyWithImpl;
@useResult
$Res call({
 BookingDetails bookingDetails, Map<String, bool> timeSlots, Map<String, String> timeKeys, int slotCount, bool isLoading, bool isSubmitting, String? errorMessage, String? successMessage, String? courseCodeError, String? dateError, bool isEditing, BookingDetails? originalBooking, String? editingSlot
});


$BookingDetailsCopyWith<$Res> get bookingDetails;$BookingDetailsCopyWith<$Res>? get originalBooking;

}
/// @nodoc
class _$BookingStateCopyWithImpl<$Res>
    implements $BookingStateCopyWith<$Res> {
  _$BookingStateCopyWithImpl(this._self, this._then);

  final BookingState _self;
  final $Res Function(BookingState) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookingDetails = null,Object? timeSlots = null,Object? timeKeys = null,Object? slotCount = null,Object? isLoading = null,Object? isSubmitting = null,Object? errorMessage = freezed,Object? successMessage = freezed,Object? courseCodeError = freezed,Object? dateError = freezed,Object? isEditing = null,Object? originalBooking = freezed,Object? editingSlot = freezed,}) {
  return _then(_self.copyWith(
bookingDetails: null == bookingDetails ? _self.bookingDetails : bookingDetails // ignore: cast_nullable_to_non_nullable
as BookingDetails,timeSlots: null == timeSlots ? _self.timeSlots : timeSlots // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,timeKeys: null == timeKeys ? _self.timeKeys : timeKeys // ignore: cast_nullable_to_non_nullable
as Map<String, String>,slotCount: null == slotCount ? _self.slotCount : slotCount // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,courseCodeError: freezed == courseCodeError ? _self.courseCodeError : courseCodeError // ignore: cast_nullable_to_non_nullable
as String?,dateError: freezed == dateError ? _self.dateError : dateError // ignore: cast_nullable_to_non_nullable
as String?,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,originalBooking: freezed == originalBooking ? _self.originalBooking : originalBooking // ignore: cast_nullable_to_non_nullable
as BookingDetails?,editingSlot: freezed == editingSlot ? _self.editingSlot : editingSlot // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingDetailsCopyWith<$Res> get bookingDetails {
  
  return $BookingDetailsCopyWith<$Res>(_self.bookingDetails, (value) {
    return _then(_self.copyWith(bookingDetails: value));
  });
}/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingDetailsCopyWith<$Res>? get originalBooking {
    if (_self.originalBooking == null) {
    return null;
  }

  return $BookingDetailsCopyWith<$Res>(_self.originalBooking!, (value) {
    return _then(_self.copyWith(originalBooking: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingState].
extension BookingStatePatterns on BookingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingState value)  $default,){
final _that = this;
switch (_that) {
case _BookingState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingState value)?  $default,){
final _that = this;
switch (_that) {
case _BookingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BookingDetails bookingDetails,  Map<String, bool> timeSlots,  Map<String, String> timeKeys,  int slotCount,  bool isLoading,  bool isSubmitting,  String? errorMessage,  String? successMessage,  String? courseCodeError,  String? dateError,  bool isEditing,  BookingDetails? originalBooking,  String? editingSlot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingState() when $default != null:
return $default(_that.bookingDetails,_that.timeSlots,_that.timeKeys,_that.slotCount,_that.isLoading,_that.isSubmitting,_that.errorMessage,_that.successMessage,_that.courseCodeError,_that.dateError,_that.isEditing,_that.originalBooking,_that.editingSlot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BookingDetails bookingDetails,  Map<String, bool> timeSlots,  Map<String, String> timeKeys,  int slotCount,  bool isLoading,  bool isSubmitting,  String? errorMessage,  String? successMessage,  String? courseCodeError,  String? dateError,  bool isEditing,  BookingDetails? originalBooking,  String? editingSlot)  $default,) {final _that = this;
switch (_that) {
case _BookingState():
return $default(_that.bookingDetails,_that.timeSlots,_that.timeKeys,_that.slotCount,_that.isLoading,_that.isSubmitting,_that.errorMessage,_that.successMessage,_that.courseCodeError,_that.dateError,_that.isEditing,_that.originalBooking,_that.editingSlot);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BookingDetails bookingDetails,  Map<String, bool> timeSlots,  Map<String, String> timeKeys,  int slotCount,  bool isLoading,  bool isSubmitting,  String? errorMessage,  String? successMessage,  String? courseCodeError,  String? dateError,  bool isEditing,  BookingDetails? originalBooking,  String? editingSlot)?  $default,) {final _that = this;
switch (_that) {
case _BookingState() when $default != null:
return $default(_that.bookingDetails,_that.timeSlots,_that.timeKeys,_that.slotCount,_that.isLoading,_that.isSubmitting,_that.errorMessage,_that.successMessage,_that.courseCodeError,_that.dateError,_that.isEditing,_that.originalBooking,_that.editingSlot);case _:
  return null;

}
}

}

/// @nodoc


class _BookingState implements BookingState {
  const _BookingState({this.bookingDetails = const BookingDetails(), final  Map<String, bool> timeSlots = const {}, final  Map<String, String> timeKeys = const {}, this.slotCount = 0, this.isLoading = true, this.isSubmitting = false, this.errorMessage, this.successMessage, this.courseCodeError, this.dateError, this.isEditing = false, this.originalBooking, this.editingSlot}): _timeSlots = timeSlots,_timeKeys = timeKeys;
  

@override@JsonKey() final  BookingDetails bookingDetails;
 final  Map<String, bool> _timeSlots;
@override@JsonKey() Map<String, bool> get timeSlots {
  if (_timeSlots is EqualUnmodifiableMapView) return _timeSlots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_timeSlots);
}

 final  Map<String, String> _timeKeys;
@override@JsonKey() Map<String, String> get timeKeys {
  if (_timeKeys is EqualUnmodifiableMapView) return _timeKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_timeKeys);
}

@override@JsonKey() final  int slotCount;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;
@override final  String? errorMessage;
@override final  String? successMessage;
@override final  String? courseCodeError;
@override final  String? dateError;
@override@JsonKey() final  bool isEditing;
@override final  BookingDetails? originalBooking;
@override final  String? editingSlot;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingStateCopyWith<_BookingState> get copyWith => __$BookingStateCopyWithImpl<_BookingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingState&&(identical(other.bookingDetails, bookingDetails) || other.bookingDetails == bookingDetails)&&const DeepCollectionEquality().equals(other._timeSlots, _timeSlots)&&const DeepCollectionEquality().equals(other._timeKeys, _timeKeys)&&(identical(other.slotCount, slotCount) || other.slotCount == slotCount)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage)&&(identical(other.courseCodeError, courseCodeError) || other.courseCodeError == courseCodeError)&&(identical(other.dateError, dateError) || other.dateError == dateError)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing)&&(identical(other.originalBooking, originalBooking) || other.originalBooking == originalBooking)&&(identical(other.editingSlot, editingSlot) || other.editingSlot == editingSlot));
}


@override
int get hashCode => Object.hash(runtimeType,bookingDetails,const DeepCollectionEquality().hash(_timeSlots),const DeepCollectionEquality().hash(_timeKeys),slotCount,isLoading,isSubmitting,errorMessage,successMessage,courseCodeError,dateError,isEditing,originalBooking,editingSlot);

@override
String toString() {
  return 'BookingState(bookingDetails: $bookingDetails, timeSlots: $timeSlots, timeKeys: $timeKeys, slotCount: $slotCount, isLoading: $isLoading, isSubmitting: $isSubmitting, errorMessage: $errorMessage, successMessage: $successMessage, courseCodeError: $courseCodeError, dateError: $dateError, isEditing: $isEditing, originalBooking: $originalBooking, editingSlot: $editingSlot)';
}


}

/// @nodoc
abstract mixin class _$BookingStateCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory _$BookingStateCopyWith(_BookingState value, $Res Function(_BookingState) _then) = __$BookingStateCopyWithImpl;
@override @useResult
$Res call({
 BookingDetails bookingDetails, Map<String, bool> timeSlots, Map<String, String> timeKeys, int slotCount, bool isLoading, bool isSubmitting, String? errorMessage, String? successMessage, String? courseCodeError, String? dateError, bool isEditing, BookingDetails? originalBooking, String? editingSlot
});


@override $BookingDetailsCopyWith<$Res> get bookingDetails;@override $BookingDetailsCopyWith<$Res>? get originalBooking;

}
/// @nodoc
class __$BookingStateCopyWithImpl<$Res>
    implements _$BookingStateCopyWith<$Res> {
  __$BookingStateCopyWithImpl(this._self, this._then);

  final _BookingState _self;
  final $Res Function(_BookingState) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookingDetails = null,Object? timeSlots = null,Object? timeKeys = null,Object? slotCount = null,Object? isLoading = null,Object? isSubmitting = null,Object? errorMessage = freezed,Object? successMessage = freezed,Object? courseCodeError = freezed,Object? dateError = freezed,Object? isEditing = null,Object? originalBooking = freezed,Object? editingSlot = freezed,}) {
  return _then(_BookingState(
bookingDetails: null == bookingDetails ? _self.bookingDetails : bookingDetails // ignore: cast_nullable_to_non_nullable
as BookingDetails,timeSlots: null == timeSlots ? _self._timeSlots : timeSlots // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,timeKeys: null == timeKeys ? _self._timeKeys : timeKeys // ignore: cast_nullable_to_non_nullable
as Map<String, String>,slotCount: null == slotCount ? _self.slotCount : slotCount // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,courseCodeError: freezed == courseCodeError ? _self.courseCodeError : courseCodeError // ignore: cast_nullable_to_non_nullable
as String?,dateError: freezed == dateError ? _self.dateError : dateError // ignore: cast_nullable_to_non_nullable
as String?,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,originalBooking: freezed == originalBooking ? _self.originalBooking : originalBooking // ignore: cast_nullable_to_non_nullable
as BookingDetails?,editingSlot: freezed == editingSlot ? _self.editingSlot : editingSlot // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingDetailsCopyWith<$Res> get bookingDetails {
  
  return $BookingDetailsCopyWith<$Res>(_self.bookingDetails, (value) {
    return _then(_self.copyWith(bookingDetails: value));
  });
}/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingDetailsCopyWith<$Res>? get originalBooking {
    if (_self.originalBooking == null) {
    return null;
  }

  return $BookingDetailsCopyWith<$Res>(_self.originalBooking!, (value) {
    return _then(_self.copyWith(originalBooking: value));
  });
}
}

// dart format on
