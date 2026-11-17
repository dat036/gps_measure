// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_fix.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocationFix {

 double get lat; double get lng;/// Horizontal accuracy (meters, 68% radius).
 double get accuracy; DateTime get timestamp; double? get altitude; double? get speed; double? get bearing; bool get isMocked;
/// Create a copy of LocationFix
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationFixCopyWith<LocationFix> get copyWith => _$LocationFixCopyWithImpl<LocationFix>(this as LocationFix, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationFix&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.bearing, bearing) || other.bearing == bearing)&&(identical(other.isMocked, isMocked) || other.isMocked == isMocked));
}


@override
int get hashCode => Object.hash(runtimeType,lat,lng,accuracy,timestamp,altitude,speed,bearing,isMocked);

@override
String toString() {
  return 'LocationFix(lat: $lat, lng: $lng, accuracy: $accuracy, timestamp: $timestamp, altitude: $altitude, speed: $speed, bearing: $bearing, isMocked: $isMocked)';
}


}

/// @nodoc
abstract mixin class $LocationFixCopyWith<$Res>  {
  factory $LocationFixCopyWith(LocationFix value, $Res Function(LocationFix) _then) = _$LocationFixCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, double accuracy, DateTime timestamp, double? altitude, double? speed, double? bearing, bool isMocked
});




}
/// @nodoc
class _$LocationFixCopyWithImpl<$Res>
    implements $LocationFixCopyWith<$Res> {
  _$LocationFixCopyWithImpl(this._self, this._then);

  final LocationFix _self;
  final $Res Function(LocationFix) _then;

/// Create a copy of LocationFix
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? accuracy = null,Object? timestamp = null,Object? altitude = freezed,Object? speed = freezed,Object? bearing = freezed,Object? isMocked = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,altitude: freezed == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,bearing: freezed == bearing ? _self.bearing : bearing // ignore: cast_nullable_to_non_nullable
as double?,isMocked: null == isMocked ? _self.isMocked : isMocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationFix].
extension LocationFixPatterns on LocationFix {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationFix value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationFix() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationFix value)  $default,){
final _that = this;
switch (_that) {
case _LocationFix():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationFix value)?  $default,){
final _that = this;
switch (_that) {
case _LocationFix() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  double accuracy,  DateTime timestamp,  double? altitude,  double? speed,  double? bearing,  bool isMocked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationFix() when $default != null:
return $default(_that.lat,_that.lng,_that.accuracy,_that.timestamp,_that.altitude,_that.speed,_that.bearing,_that.isMocked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  double accuracy,  DateTime timestamp,  double? altitude,  double? speed,  double? bearing,  bool isMocked)  $default,) {final _that = this;
switch (_that) {
case _LocationFix():
return $default(_that.lat,_that.lng,_that.accuracy,_that.timestamp,_that.altitude,_that.speed,_that.bearing,_that.isMocked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  double accuracy,  DateTime timestamp,  double? altitude,  double? speed,  double? bearing,  bool isMocked)?  $default,) {final _that = this;
switch (_that) {
case _LocationFix() when $default != null:
return $default(_that.lat,_that.lng,_that.accuracy,_that.timestamp,_that.altitude,_that.speed,_that.bearing,_that.isMocked);case _:
  return null;

}
}

}

/// @nodoc


class _LocationFix extends LocationFix {
  const _LocationFix({required this.lat, required this.lng, required this.accuracy, required this.timestamp, this.altitude, this.speed, this.bearing, this.isMocked = false}): super._();
  

@override final  double lat;
@override final  double lng;
/// Horizontal accuracy (meters, 68% radius).
@override final  double accuracy;
@override final  DateTime timestamp;
@override final  double? altitude;
@override final  double? speed;
@override final  double? bearing;
@override@JsonKey() final  bool isMocked;

/// Create a copy of LocationFix
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationFixCopyWith<_LocationFix> get copyWith => __$LocationFixCopyWithImpl<_LocationFix>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationFix&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.bearing, bearing) || other.bearing == bearing)&&(identical(other.isMocked, isMocked) || other.isMocked == isMocked));
}


@override
int get hashCode => Object.hash(runtimeType,lat,lng,accuracy,timestamp,altitude,speed,bearing,isMocked);

@override
String toString() {
  return 'LocationFix(lat: $lat, lng: $lng, accuracy: $accuracy, timestamp: $timestamp, altitude: $altitude, speed: $speed, bearing: $bearing, isMocked: $isMocked)';
}


}

/// @nodoc
abstract mixin class _$LocationFixCopyWith<$Res> implements $LocationFixCopyWith<$Res> {
  factory _$LocationFixCopyWith(_LocationFix value, $Res Function(_LocationFix) _then) = __$LocationFixCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, double accuracy, DateTime timestamp, double? altitude, double? speed, double? bearing, bool isMocked
});




}
/// @nodoc
class __$LocationFixCopyWithImpl<$Res>
    implements _$LocationFixCopyWith<$Res> {
  __$LocationFixCopyWithImpl(this._self, this._then);

  final _LocationFix _self;
  final $Res Function(_LocationFix) _then;

/// Create a copy of LocationFix
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? accuracy = null,Object? timestamp = null,Object? altitude = freezed,Object? speed = freezed,Object? bearing = freezed,Object? isMocked = null,}) {
  return _then(_LocationFix(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,altitude: freezed == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,bearing: freezed == bearing ? _self.bearing : bearing // ignore: cast_nullable_to_non_nullable
as double?,isMocked: null == isMocked ? _self.isMocked : isMocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
