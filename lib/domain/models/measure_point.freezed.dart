// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measure_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MeasurePoint {

 String get id; int get orderIndex; double get lat; double get lng; DateTime get timestamp;/// Walk: incremented after each Resume. Area/Distance: always 0.
 int get segmentIndex; double? get altitude;/// Horizontal accuracy in meters (GPS points only).
 double? get accuracy; double? get speed; double? get bearing;
/// Create a copy of MeasurePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasurePointCopyWith<MeasurePoint> get copyWith => _$MeasurePointCopyWithImpl<MeasurePoint>(this as MeasurePoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasurePoint&&(identical(other.id, id) || other.id == id)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.segmentIndex, segmentIndex) || other.segmentIndex == segmentIndex)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.bearing, bearing) || other.bearing == bearing));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderIndex,lat,lng,timestamp,segmentIndex,altitude,accuracy,speed,bearing);

@override
String toString() {
  return 'MeasurePoint(id: $id, orderIndex: $orderIndex, lat: $lat, lng: $lng, timestamp: $timestamp, segmentIndex: $segmentIndex, altitude: $altitude, accuracy: $accuracy, speed: $speed, bearing: $bearing)';
}


}

/// @nodoc
abstract mixin class $MeasurePointCopyWith<$Res>  {
  factory $MeasurePointCopyWith(MeasurePoint value, $Res Function(MeasurePoint) _then) = _$MeasurePointCopyWithImpl;
@useResult
$Res call({
 String id, int orderIndex, double lat, double lng, DateTime timestamp, int segmentIndex, double? altitude, double? accuracy, double? speed, double? bearing
});




}
/// @nodoc
class _$MeasurePointCopyWithImpl<$Res>
    implements $MeasurePointCopyWith<$Res> {
  _$MeasurePointCopyWithImpl(this._self, this._then);

  final MeasurePoint _self;
  final $Res Function(MeasurePoint) _then;

/// Create a copy of MeasurePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderIndex = null,Object? lat = null,Object? lng = null,Object? timestamp = null,Object? segmentIndex = null,Object? altitude = freezed,Object? accuracy = freezed,Object? speed = freezed,Object? bearing = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,segmentIndex: null == segmentIndex ? _self.segmentIndex : segmentIndex // ignore: cast_nullable_to_non_nullable
as int,altitude: freezed == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as double?,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,bearing: freezed == bearing ? _self.bearing : bearing // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeasurePoint].
extension MeasurePointPatterns on MeasurePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeasurePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeasurePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeasurePoint value)  $default,){
final _that = this;
switch (_that) {
case _MeasurePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeasurePoint value)?  $default,){
final _that = this;
switch (_that) {
case _MeasurePoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int orderIndex,  double lat,  double lng,  DateTime timestamp,  int segmentIndex,  double? altitude,  double? accuracy,  double? speed,  double? bearing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeasurePoint() when $default != null:
return $default(_that.id,_that.orderIndex,_that.lat,_that.lng,_that.timestamp,_that.segmentIndex,_that.altitude,_that.accuracy,_that.speed,_that.bearing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int orderIndex,  double lat,  double lng,  DateTime timestamp,  int segmentIndex,  double? altitude,  double? accuracy,  double? speed,  double? bearing)  $default,) {final _that = this;
switch (_that) {
case _MeasurePoint():
return $default(_that.id,_that.orderIndex,_that.lat,_that.lng,_that.timestamp,_that.segmentIndex,_that.altitude,_that.accuracy,_that.speed,_that.bearing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int orderIndex,  double lat,  double lng,  DateTime timestamp,  int segmentIndex,  double? altitude,  double? accuracy,  double? speed,  double? bearing)?  $default,) {final _that = this;
switch (_that) {
case _MeasurePoint() when $default != null:
return $default(_that.id,_that.orderIndex,_that.lat,_that.lng,_that.timestamp,_that.segmentIndex,_that.altitude,_that.accuracy,_that.speed,_that.bearing);case _:
  return null;

}
}

}

/// @nodoc


class _MeasurePoint extends MeasurePoint {
  const _MeasurePoint({required this.id, required this.orderIndex, required this.lat, required this.lng, required this.timestamp, this.segmentIndex = 0, this.altitude, this.accuracy, this.speed, this.bearing}): super._();
  

@override final  String id;
@override final  int orderIndex;
@override final  double lat;
@override final  double lng;
@override final  DateTime timestamp;
/// Walk: incremented after each Resume. Area/Distance: always 0.
@override@JsonKey() final  int segmentIndex;
@override final  double? altitude;
/// Horizontal accuracy in meters (GPS points only).
@override final  double? accuracy;
@override final  double? speed;
@override final  double? bearing;

/// Create a copy of MeasurePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasurePointCopyWith<_MeasurePoint> get copyWith => __$MeasurePointCopyWithImpl<_MeasurePoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeasurePoint&&(identical(other.id, id) || other.id == id)&&(identical(other.orderIndex, orderIndex) || other.orderIndex == orderIndex)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.segmentIndex, segmentIndex) || other.segmentIndex == segmentIndex)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.bearing, bearing) || other.bearing == bearing));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderIndex,lat,lng,timestamp,segmentIndex,altitude,accuracy,speed,bearing);

@override
String toString() {
  return 'MeasurePoint(id: $id, orderIndex: $orderIndex, lat: $lat, lng: $lng, timestamp: $timestamp, segmentIndex: $segmentIndex, altitude: $altitude, accuracy: $accuracy, speed: $speed, bearing: $bearing)';
}


}

/// @nodoc
abstract mixin class _$MeasurePointCopyWith<$Res> implements $MeasurePointCopyWith<$Res> {
  factory _$MeasurePointCopyWith(_MeasurePoint value, $Res Function(_MeasurePoint) _then) = __$MeasurePointCopyWithImpl;
@override @useResult
$Res call({
 String id, int orderIndex, double lat, double lng, DateTime timestamp, int segmentIndex, double? altitude, double? accuracy, double? speed, double? bearing
});




}
/// @nodoc
class __$MeasurePointCopyWithImpl<$Res>
    implements _$MeasurePointCopyWith<$Res> {
  __$MeasurePointCopyWithImpl(this._self, this._then);

  final _MeasurePoint _self;
  final $Res Function(_MeasurePoint) _then;

/// Create a copy of MeasurePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderIndex = null,Object? lat = null,Object? lng = null,Object? timestamp = null,Object? segmentIndex = null,Object? altitude = freezed,Object? accuracy = freezed,Object? speed = freezed,Object? bearing = freezed,}) {
  return _then(_MeasurePoint(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderIndex: null == orderIndex ? _self.orderIndex : orderIndex // ignore: cast_nullable_to_non_nullable
as int,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,segmentIndex: null == segmentIndex ? _self.segmentIndex : segmentIndex // ignore: cast_nullable_to_non_nullable
as int,altitude: freezed == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as double?,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double?,speed: freezed == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double?,bearing: freezed == bearing ? _self.bearing : bearing // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
