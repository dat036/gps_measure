// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurement_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MeasurementStats {

 double? get areaM2; double? get perimeterM; double? get distanceM; int? get durationSec; int get pointCount; int get segmentCount; bool get isClosed; bool get selfIntersects;
/// Create a copy of MeasurementStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasurementStatsCopyWith<MeasurementStats> get copyWith => _$MeasurementStatsCopyWithImpl<MeasurementStats>(this as MeasurementStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasurementStats&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.perimeterM, perimeterM) || other.perimeterM == perimeterM)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.durationSec, durationSec) || other.durationSec == durationSec)&&(identical(other.pointCount, pointCount) || other.pointCount == pointCount)&&(identical(other.segmentCount, segmentCount) || other.segmentCount == segmentCount)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed)&&(identical(other.selfIntersects, selfIntersects) || other.selfIntersects == selfIntersects));
}


@override
int get hashCode => Object.hash(runtimeType,areaM2,perimeterM,distanceM,durationSec,pointCount,segmentCount,isClosed,selfIntersects);

@override
String toString() {
  return 'MeasurementStats(areaM2: $areaM2, perimeterM: $perimeterM, distanceM: $distanceM, durationSec: $durationSec, pointCount: $pointCount, segmentCount: $segmentCount, isClosed: $isClosed, selfIntersects: $selfIntersects)';
}


}

/// @nodoc
abstract mixin class $MeasurementStatsCopyWith<$Res>  {
  factory $MeasurementStatsCopyWith(MeasurementStats value, $Res Function(MeasurementStats) _then) = _$MeasurementStatsCopyWithImpl;
@useResult
$Res call({
 double? areaM2, double? perimeterM, double? distanceM, int? durationSec, int pointCount, int segmentCount, bool isClosed, bool selfIntersects
});




}
/// @nodoc
class _$MeasurementStatsCopyWithImpl<$Res>
    implements $MeasurementStatsCopyWith<$Res> {
  _$MeasurementStatsCopyWithImpl(this._self, this._then);

  final MeasurementStats _self;
  final $Res Function(MeasurementStats) _then;

/// Create a copy of MeasurementStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? areaM2 = freezed,Object? perimeterM = freezed,Object? distanceM = freezed,Object? durationSec = freezed,Object? pointCount = null,Object? segmentCount = null,Object? isClosed = null,Object? selfIntersects = null,}) {
  return _then(_self.copyWith(
areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,perimeterM: freezed == perimeterM ? _self.perimeterM : perimeterM // ignore: cast_nullable_to_non_nullable
as double?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as double?,durationSec: freezed == durationSec ? _self.durationSec : durationSec // ignore: cast_nullable_to_non_nullable
as int?,pointCount: null == pointCount ? _self.pointCount : pointCount // ignore: cast_nullable_to_non_nullable
as int,segmentCount: null == segmentCount ? _self.segmentCount : segmentCount // ignore: cast_nullable_to_non_nullable
as int,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,selfIntersects: null == selfIntersects ? _self.selfIntersects : selfIntersects // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MeasurementStats].
extension MeasurementStatsPatterns on MeasurementStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeasurementStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeasurementStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeasurementStats value)  $default,){
final _that = this;
switch (_that) {
case _MeasurementStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeasurementStats value)?  $default,){
final _that = this;
switch (_that) {
case _MeasurementStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? areaM2,  double? perimeterM,  double? distanceM,  int? durationSec,  int pointCount,  int segmentCount,  bool isClosed,  bool selfIntersects)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeasurementStats() when $default != null:
return $default(_that.areaM2,_that.perimeterM,_that.distanceM,_that.durationSec,_that.pointCount,_that.segmentCount,_that.isClosed,_that.selfIntersects);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? areaM2,  double? perimeterM,  double? distanceM,  int? durationSec,  int pointCount,  int segmentCount,  bool isClosed,  bool selfIntersects)  $default,) {final _that = this;
switch (_that) {
case _MeasurementStats():
return $default(_that.areaM2,_that.perimeterM,_that.distanceM,_that.durationSec,_that.pointCount,_that.segmentCount,_that.isClosed,_that.selfIntersects);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? areaM2,  double? perimeterM,  double? distanceM,  int? durationSec,  int pointCount,  int segmentCount,  bool isClosed,  bool selfIntersects)?  $default,) {final _that = this;
switch (_that) {
case _MeasurementStats() when $default != null:
return $default(_that.areaM2,_that.perimeterM,_that.distanceM,_that.durationSec,_that.pointCount,_that.segmentCount,_that.isClosed,_that.selfIntersects);case _:
  return null;

}
}

}

/// @nodoc


class _MeasurementStats implements MeasurementStats {
  const _MeasurementStats({this.areaM2, this.perimeterM, this.distanceM, this.durationSec, this.pointCount = 0, this.segmentCount = 0, this.isClosed = false, this.selfIntersects = false});
  

@override final  double? areaM2;
@override final  double? perimeterM;
@override final  double? distanceM;
@override final  int? durationSec;
@override@JsonKey() final  int pointCount;
@override@JsonKey() final  int segmentCount;
@override@JsonKey() final  bool isClosed;
@override@JsonKey() final  bool selfIntersects;

/// Create a copy of MeasurementStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasurementStatsCopyWith<_MeasurementStats> get copyWith => __$MeasurementStatsCopyWithImpl<_MeasurementStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeasurementStats&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.perimeterM, perimeterM) || other.perimeterM == perimeterM)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.durationSec, durationSec) || other.durationSec == durationSec)&&(identical(other.pointCount, pointCount) || other.pointCount == pointCount)&&(identical(other.segmentCount, segmentCount) || other.segmentCount == segmentCount)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed)&&(identical(other.selfIntersects, selfIntersects) || other.selfIntersects == selfIntersects));
}


@override
int get hashCode => Object.hash(runtimeType,areaM2,perimeterM,distanceM,durationSec,pointCount,segmentCount,isClosed,selfIntersects);

@override
String toString() {
  return 'MeasurementStats(areaM2: $areaM2, perimeterM: $perimeterM, distanceM: $distanceM, durationSec: $durationSec, pointCount: $pointCount, segmentCount: $segmentCount, isClosed: $isClosed, selfIntersects: $selfIntersects)';
}


}

/// @nodoc
abstract mixin class _$MeasurementStatsCopyWith<$Res> implements $MeasurementStatsCopyWith<$Res> {
  factory _$MeasurementStatsCopyWith(_MeasurementStats value, $Res Function(_MeasurementStats) _then) = __$MeasurementStatsCopyWithImpl;
@override @useResult
$Res call({
 double? areaM2, double? perimeterM, double? distanceM, int? durationSec, int pointCount, int segmentCount, bool isClosed, bool selfIntersects
});




}
/// @nodoc
class __$MeasurementStatsCopyWithImpl<$Res>
    implements _$MeasurementStatsCopyWith<$Res> {
  __$MeasurementStatsCopyWithImpl(this._self, this._then);

  final _MeasurementStats _self;
  final $Res Function(_MeasurementStats) _then;

/// Create a copy of MeasurementStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? areaM2 = freezed,Object? perimeterM = freezed,Object? distanceM = freezed,Object? durationSec = freezed,Object? pointCount = null,Object? segmentCount = null,Object? isClosed = null,Object? selfIntersects = null,}) {
  return _then(_MeasurementStats(
areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,perimeterM: freezed == perimeterM ? _self.perimeterM : perimeterM // ignore: cast_nullable_to_non_nullable
as double?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as double?,durationSec: freezed == durationSec ? _self.durationSec : durationSec // ignore: cast_nullable_to_non_nullable
as int?,pointCount: null == pointCount ? _self.pointCount : pointCount // ignore: cast_nullable_to_non_nullable
as int,segmentCount: null == segmentCount ? _self.segmentCount : segmentCount // ignore: cast_nullable_to_non_nullable
as int,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,selfIntersects: null == selfIntersects ? _self.selfIntersects : selfIntersects // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
