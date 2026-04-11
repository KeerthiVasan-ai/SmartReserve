// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServerDetails {

 bool get isAppUnderMaintenance; String get version;@JsonKey(name: 'allowed_user_version') List<String> get allowedUserVersions;
/// Create a copy of ServerDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerDetailsCopyWith<ServerDetails> get copyWith => _$ServerDetailsCopyWithImpl<ServerDetails>(this as ServerDetails, _$identity);

  /// Serializes this ServerDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerDetails&&(identical(other.isAppUnderMaintenance, isAppUnderMaintenance) || other.isAppUnderMaintenance == isAppUnderMaintenance)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.allowedUserVersions, allowedUserVersions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isAppUnderMaintenance,version,const DeepCollectionEquality().hash(allowedUserVersions));

@override
String toString() {
  return 'ServerDetails(isAppUnderMaintenance: $isAppUnderMaintenance, version: $version, allowedUserVersions: $allowedUserVersions)';
}


}

/// @nodoc
abstract mixin class $ServerDetailsCopyWith<$Res>  {
  factory $ServerDetailsCopyWith(ServerDetails value, $Res Function(ServerDetails) _then) = _$ServerDetailsCopyWithImpl;
@useResult
$Res call({
 bool isAppUnderMaintenance, String version,@JsonKey(name: 'allowed_user_version') List<String> allowedUserVersions
});




}
/// @nodoc
class _$ServerDetailsCopyWithImpl<$Res>
    implements $ServerDetailsCopyWith<$Res> {
  _$ServerDetailsCopyWithImpl(this._self, this._then);

  final ServerDetails _self;
  final $Res Function(ServerDetails) _then;

/// Create a copy of ServerDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isAppUnderMaintenance = null,Object? version = null,Object? allowedUserVersions = null,}) {
  return _then(_self.copyWith(
isAppUnderMaintenance: null == isAppUnderMaintenance ? _self.isAppUnderMaintenance : isAppUnderMaintenance // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,allowedUserVersions: null == allowedUserVersions ? _self.allowedUserVersions : allowedUserVersions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerDetails].
extension ServerDetailsPatterns on ServerDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerDetails value)  $default,){
final _that = this;
switch (_that) {
case _ServerDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerDetails value)?  $default,){
final _that = this;
switch (_that) {
case _ServerDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isAppUnderMaintenance,  String version, @JsonKey(name: 'allowed_user_version')  List<String> allowedUserVersions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerDetails() when $default != null:
return $default(_that.isAppUnderMaintenance,_that.version,_that.allowedUserVersions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isAppUnderMaintenance,  String version, @JsonKey(name: 'allowed_user_version')  List<String> allowedUserVersions)  $default,) {final _that = this;
switch (_that) {
case _ServerDetails():
return $default(_that.isAppUnderMaintenance,_that.version,_that.allowedUserVersions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isAppUnderMaintenance,  String version, @JsonKey(name: 'allowed_user_version')  List<String> allowedUserVersions)?  $default,) {final _that = this;
switch (_that) {
case _ServerDetails() when $default != null:
return $default(_that.isAppUnderMaintenance,_that.version,_that.allowedUserVersions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerDetails implements ServerDetails {
  const _ServerDetails({this.isAppUnderMaintenance = false, this.version = '', @JsonKey(name: 'allowed_user_version') final  List<String> allowedUserVersions = const []}): _allowedUserVersions = allowedUserVersions;
  factory _ServerDetails.fromJson(Map<String, dynamic> json) => _$ServerDetailsFromJson(json);

@override@JsonKey() final  bool isAppUnderMaintenance;
@override@JsonKey() final  String version;
 final  List<String> _allowedUserVersions;
@override@JsonKey(name: 'allowed_user_version') List<String> get allowedUserVersions {
  if (_allowedUserVersions is EqualUnmodifiableListView) return _allowedUserVersions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allowedUserVersions);
}


/// Create a copy of ServerDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerDetailsCopyWith<_ServerDetails> get copyWith => __$ServerDetailsCopyWithImpl<_ServerDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerDetails&&(identical(other.isAppUnderMaintenance, isAppUnderMaintenance) || other.isAppUnderMaintenance == isAppUnderMaintenance)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._allowedUserVersions, _allowedUserVersions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isAppUnderMaintenance,version,const DeepCollectionEquality().hash(_allowedUserVersions));

@override
String toString() {
  return 'ServerDetails(isAppUnderMaintenance: $isAppUnderMaintenance, version: $version, allowedUserVersions: $allowedUserVersions)';
}


}

/// @nodoc
abstract mixin class _$ServerDetailsCopyWith<$Res> implements $ServerDetailsCopyWith<$Res> {
  factory _$ServerDetailsCopyWith(_ServerDetails value, $Res Function(_ServerDetails) _then) = __$ServerDetailsCopyWithImpl;
@override @useResult
$Res call({
 bool isAppUnderMaintenance, String version,@JsonKey(name: 'allowed_user_version') List<String> allowedUserVersions
});




}
/// @nodoc
class __$ServerDetailsCopyWithImpl<$Res>
    implements _$ServerDetailsCopyWith<$Res> {
  __$ServerDetailsCopyWithImpl(this._self, this._then);

  final _ServerDetails _self;
  final $Res Function(_ServerDetails) _then;

/// Create a copy of ServerDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isAppUnderMaintenance = null,Object? version = null,Object? allowedUserVersions = null,}) {
  return _then(_ServerDetails(
isAppUnderMaintenance: null == isAppUnderMaintenance ? _self.isAppUnderMaintenance : isAppUnderMaintenance // ignore: cast_nullable_to_non_nullable
as bool,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,allowedUserVersions: null == allowedUserVersions ? _self._allowedUserVersions : allowedUserVersions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
