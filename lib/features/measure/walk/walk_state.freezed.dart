// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walk_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalkState {

 MapStyle get mapStyle;/// False until `prepare()` has loaded the draft and checked permission.
 bool get ready; WalkRunState get runState;/// Draft id; null until Start Walking.
 String? get measurementId; List<MeasurePoint> get points; MeasurementStats get stats;/// Segment new points go to (incremented on every Resume).
 int get segmentIndex;/// Total recorded time, seconds (updated every second while recording).
 int get elapsedSec; GpsStatus get gps;/// Latest raw fix (blue dot, accuracy halo) — recorded or not.
 LocationFix? get lastFix;/// A mocked location was seen: those fixes are never recorded.
 bool get mockDetected; AreaUnit? get displayAreaUnit; DistanceUnit? get displayDistanceUnit;/// The last write failed; retried on the next flush.
 bool get saveFailed;
/// Create a copy of WalkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalkStateCopyWith<WalkState> get copyWith => _$WalkStateCopyWithImpl<WalkState>(this as WalkState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalkState&&(identical(other.mapStyle, mapStyle) || other.mapStyle == mapStyle)&&(identical(other.ready, ready) || other.ready == ready)&&(identical(other.runState, runState) || other.runState == runState)&&(identical(other.measurementId, measurementId) || other.measurementId == measurementId)&&const DeepCollectionEquality().equals(other.points, points)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.segmentIndex, segmentIndex) || other.segmentIndex == segmentIndex)&&(identical(other.elapsedSec, elapsedSec) || other.elapsedSec == elapsedSec)&&(identical(other.gps, gps) || other.gps == gps)&&(identical(other.lastFix, lastFix) || other.lastFix == lastFix)&&(identical(other.mockDetected, mockDetected) || other.mockDetected == mockDetected)&&(identical(other.displayAreaUnit, displayAreaUnit) || other.displayAreaUnit == displayAreaUnit)&&(identical(other.displayDistanceUnit, displayDistanceUnit) || other.displayDistanceUnit == displayDistanceUnit)&&(identical(other.saveFailed, saveFailed) || other.saveFailed == saveFailed));
}


@override
int get hashCode => Object.hash(runtimeType,mapStyle,ready,runState,measurementId,const DeepCollectionEquality().hash(points),stats,segmentIndex,elapsedSec,gps,lastFix,mockDetected,displayAreaUnit,displayDistanceUnit,saveFailed);

@override
String toString() {
  return 'WalkState(mapStyle: $mapStyle, ready: $ready, runState: $runState, measurementId: $measurementId, points: $points, stats: $stats, segmentIndex: $segmentIndex, elapsedSec: $elapsedSec, gps: $gps, lastFix: $lastFix, mockDetected: $mockDetected, displayAreaUnit: $displayAreaUnit, displayDistanceUnit: $displayDistanceUnit, saveFailed: $saveFailed)';
}


}

/// @nodoc
abstract mixin class $WalkStateCopyWith<$Res>  {
  factory $WalkStateCopyWith(WalkState value, $Res Function(WalkState) _then) = _$WalkStateCopyWithImpl;
@useResult
$Res call({
 MapStyle mapStyle, bool ready, WalkRunState runState, String? measurementId, List<MeasurePoint> points, MeasurementStats stats, int segmentIndex, int elapsedSec, GpsStatus gps, LocationFix? lastFix, bool mockDetected, AreaUnit? displayAreaUnit, DistanceUnit? displayDistanceUnit, bool saveFailed
});


$MeasurementStatsCopyWith<$Res> get stats;$LocationFixCopyWith<$Res>? get lastFix;

}
/// @nodoc
class _$WalkStateCopyWithImpl<$Res>
    implements $WalkStateCopyWith<$Res> {
  _$WalkStateCopyWithImpl(this._self, this._then);

  final WalkState _self;
  final $Res Function(WalkState) _then;

/// Create a copy of WalkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mapStyle = null,Object? ready = null,Object? runState = null,Object? measurementId = freezed,Object? points = null,Object? stats = null,Object? segmentIndex = null,Object? elapsedSec = null,Object? gps = null,Object? lastFix = freezed,Object? mockDetected = null,Object? displayAreaUnit = freezed,Object? displayDistanceUnit = freezed,Object? saveFailed = null,}) {
  return _then(_self.copyWith(
mapStyle: null == mapStyle ? _self.mapStyle : mapStyle // ignore: cast_nullable_to_non_nullable
as MapStyle,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,runState: null == runState ? _self.runState : runState // ignore: cast_nullable_to_non_nullable
as WalkRunState,measurementId: freezed == measurementId ? _self.measurementId : measurementId // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<MeasurePoint>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as MeasurementStats,segmentIndex: null == segmentIndex ? _self.segmentIndex : segmentIndex // ignore: cast_nullable_to_non_nullable
as int,elapsedSec: null == elapsedSec ? _self.elapsedSec : elapsedSec // ignore: cast_nullable_to_non_nullable
as int,gps: null == gps ? _self.gps : gps // ignore: cast_nullable_to_non_nullable
as GpsStatus,lastFix: freezed == lastFix ? _self.lastFix : lastFix // ignore: cast_nullable_to_non_nullable
as LocationFix?,mockDetected: null == mockDetected ? _self.mockDetected : mockDetected // ignore: cast_nullable_to_non_nullable
as bool,displayAreaUnit: freezed == displayAreaUnit ? _self.displayAreaUnit : displayAreaUnit // ignore: cast_nullable_to_non_nullable
as AreaUnit?,displayDistanceUnit: freezed == displayDistanceUnit ? _self.displayDistanceUnit : displayDistanceUnit // ignore: cast_nullable_to_non_nullable
as DistanceUnit?,saveFailed: null == saveFailed ? _self.saveFailed : saveFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of WalkState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeasurementStatsCopyWith<$Res> get stats {
  
  return $MeasurementStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of WalkState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationFixCopyWith<$Res>? get lastFix {
    if (_self.lastFix == null) {
    return null;
  }

  return $LocationFixCopyWith<$Res>(_self.lastFix!, (value) {
    return _then(_self.copyWith(lastFix: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalkState].
extension WalkStatePatterns on WalkState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalkState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalkState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalkState value)  $default,){
final _that = this;
switch (_that) {
case _WalkState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalkState value)?  $default,){
final _that = this;
switch (_that) {
case _WalkState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MapStyle mapStyle,  bool ready,  WalkRunState runState,  String? measurementId,  List<MeasurePoint> points,  MeasurementStats stats,  int segmentIndex,  int elapsedSec,  GpsStatus gps,  LocationFix? lastFix,  bool mockDetected,  AreaUnit? displayAreaUnit,  DistanceUnit? displayDistanceUnit,  bool saveFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalkState() when $default != null:
return $default(_that.mapStyle,_that.ready,_that.runState,_that.measurementId,_that.points,_that.stats,_that.segmentIndex,_that.elapsedSec,_that.gps,_that.lastFix,_that.mockDetected,_that.displayAreaUnit,_that.displayDistanceUnit,_that.saveFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MapStyle mapStyle,  bool ready,  WalkRunState runState,  String? measurementId,  List<MeasurePoint> points,  MeasurementStats stats,  int segmentIndex,  int elapsedSec,  GpsStatus gps,  LocationFix? lastFix,  bool mockDetected,  AreaUnit? displayAreaUnit,  DistanceUnit? displayDistanceUnit,  bool saveFailed)  $default,) {final _that = this;
switch (_that) {
case _WalkState():
return $default(_that.mapStyle,_that.ready,_that.runState,_that.measurementId,_that.points,_that.stats,_that.segmentIndex,_that.elapsedSec,_that.gps,_that.lastFix,_that.mockDetected,_that.displayAreaUnit,_that.displayDistanceUnit,_that.saveFailed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MapStyle mapStyle,  bool ready,  WalkRunState runState,  String? measurementId,  List<MeasurePoint> points,  MeasurementStats stats,  int segmentIndex,  int elapsedSec,  GpsStatus gps,  LocationFix? lastFix,  bool mockDetected,  AreaUnit? displayAreaUnit,  DistanceUnit? displayDistanceUnit,  bool saveFailed)?  $default,) {final _that = this;
switch (_that) {
case _WalkState() when $default != null:
return $default(_that.mapStyle,_that.ready,_that.runState,_that.measurementId,_that.points,_that.stats,_that.segmentIndex,_that.elapsedSec,_that.gps,_that.lastFix,_that.mockDetected,_that.displayAreaUnit,_that.displayDistanceUnit,_that.saveFailed);case _:
  return null;

}
}

}

/// @nodoc


class _WalkState extends WalkState {
  const _WalkState({required this.mapStyle, this.ready = false, this.runState = WalkRunState.idle, this.measurementId, final  List<MeasurePoint> points = const <MeasurePoint>[], this.stats = MeasurementStats.empty, this.segmentIndex = 0, this.elapsedSec = 0, this.gps = GpsStatus.searching, this.lastFix, this.mockDetected = false, this.displayAreaUnit, this.displayDistanceUnit, this.saveFailed = false}): _points = points,super._();
  

@override final  MapStyle mapStyle;
/// False until `prepare()` has loaded the draft and checked permission.
@override@JsonKey() final  bool ready;
@override@JsonKey() final  WalkRunState runState;
/// Draft id; null until Start Walking.
@override final  String? measurementId;
 final  List<MeasurePoint> _points;
@override@JsonKey() List<MeasurePoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

@override@JsonKey() final  MeasurementStats stats;
/// Segment new points go to (incremented on every Resume).
@override@JsonKey() final  int segmentIndex;
/// Total recorded time, seconds (updated every second while recording).
@override@JsonKey() final  int elapsedSec;
@override@JsonKey() final  GpsStatus gps;
/// Latest raw fix (blue dot, accuracy halo) — recorded or not.
@override final  LocationFix? lastFix;
/// A mocked location was seen: those fixes are never recorded.
@override@JsonKey() final  bool mockDetected;
@override final  AreaUnit? displayAreaUnit;
@override final  DistanceUnit? displayDistanceUnit;
/// The last write failed; retried on the next flush.
@override@JsonKey() final  bool saveFailed;

/// Create a copy of WalkState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalkStateCopyWith<_WalkState> get copyWith => __$WalkStateCopyWithImpl<_WalkState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalkState&&(identical(other.mapStyle, mapStyle) || other.mapStyle == mapStyle)&&(identical(other.ready, ready) || other.ready == ready)&&(identical(other.runState, runState) || other.runState == runState)&&(identical(other.measurementId, measurementId) || other.measurementId == measurementId)&&const DeepCollectionEquality().equals(other._points, _points)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.segmentIndex, segmentIndex) || other.segmentIndex == segmentIndex)&&(identical(other.elapsedSec, elapsedSec) || other.elapsedSec == elapsedSec)&&(identical(other.gps, gps) || other.gps == gps)&&(identical(other.lastFix, lastFix) || other.lastFix == lastFix)&&(identical(other.mockDetected, mockDetected) || other.mockDetected == mockDetected)&&(identical(other.displayAreaUnit, displayAreaUnit) || other.displayAreaUnit == displayAreaUnit)&&(identical(other.displayDistanceUnit, displayDistanceUnit) || other.displayDistanceUnit == displayDistanceUnit)&&(identical(other.saveFailed, saveFailed) || other.saveFailed == saveFailed));
}


@override
int get hashCode => Object.hash(runtimeType,mapStyle,ready,runState,measurementId,const DeepCollectionEquality().hash(_points),stats,segmentIndex,elapsedSec,gps,lastFix,mockDetected,displayAreaUnit,displayDistanceUnit,saveFailed);

@override
String toString() {
  return 'WalkState(mapStyle: $mapStyle, ready: $ready, runState: $runState, measurementId: $measurementId, points: $points, stats: $stats, segmentIndex: $segmentIndex, elapsedSec: $elapsedSec, gps: $gps, lastFix: $lastFix, mockDetected: $mockDetected, displayAreaUnit: $displayAreaUnit, displayDistanceUnit: $displayDistanceUnit, saveFailed: $saveFailed)';
}


}

/// @nodoc
abstract mixin class _$WalkStateCopyWith<$Res> implements $WalkStateCopyWith<$Res> {
  factory _$WalkStateCopyWith(_WalkState value, $Res Function(_WalkState) _then) = __$WalkStateCopyWithImpl;
@override @useResult
$Res call({
 MapStyle mapStyle, bool ready, WalkRunState runState, String? measurementId, List<MeasurePoint> points, MeasurementStats stats, int segmentIndex, int elapsedSec, GpsStatus gps, LocationFix? lastFix, bool mockDetected, AreaUnit? displayAreaUnit, DistanceUnit? displayDistanceUnit, bool saveFailed
});


@override $MeasurementStatsCopyWith<$Res> get stats;@override $LocationFixCopyWith<$Res>? get lastFix;

}
/// @nodoc
class __$WalkStateCopyWithImpl<$Res>
    implements _$WalkStateCopyWith<$Res> {
  __$WalkStateCopyWithImpl(this._self, this._then);

  final _WalkState _self;
  final $Res Function(_WalkState) _then;

/// Create a copy of WalkState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mapStyle = null,Object? ready = null,Object? runState = null,Object? measurementId = freezed,Object? points = null,Object? stats = null,Object? segmentIndex = null,Object? elapsedSec = null,Object? gps = null,Object? lastFix = freezed,Object? mockDetected = null,Object? displayAreaUnit = freezed,Object? displayDistanceUnit = freezed,Object? saveFailed = null,}) {
  return _then(_WalkState(
mapStyle: null == mapStyle ? _self.mapStyle : mapStyle // ignore: cast_nullable_to_non_nullable
as MapStyle,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,runState: null == runState ? _self.runState : runState // ignore: cast_nullable_to_non_nullable
as WalkRunState,measurementId: freezed == measurementId ? _self.measurementId : measurementId // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<MeasurePoint>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as MeasurementStats,segmentIndex: null == segmentIndex ? _self.segmentIndex : segmentIndex // ignore: cast_nullable_to_non_nullable
as int,elapsedSec: null == elapsedSec ? _self.elapsedSec : elapsedSec // ignore: cast_nullable_to_non_nullable
as int,gps: null == gps ? _self.gps : gps // ignore: cast_nullable_to_non_nullable
as GpsStatus,lastFix: freezed == lastFix ? _self.lastFix : lastFix // ignore: cast_nullable_to_non_nullable
as LocationFix?,mockDetected: null == mockDetected ? _self.mockDetected : mockDetected // ignore: cast_nullable_to_non_nullable
as bool,displayAreaUnit: freezed == displayAreaUnit ? _self.displayAreaUnit : displayAreaUnit // ignore: cast_nullable_to_non_nullable
as AreaUnit?,displayDistanceUnit: freezed == displayDistanceUnit ? _self.displayDistanceUnit : displayDistanceUnit // ignore: cast_nullable_to_non_nullable
as DistanceUnit?,saveFailed: null == saveFailed ? _self.saveFailed : saveFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of WalkState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeasurementStatsCopyWith<$Res> get stats {
  
  return $MeasurementStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of WalkState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationFixCopyWith<$Res>? get lastFix {
    if (_self.lastFix == null) {
    return null;
  }

  return $LocationFixCopyWith<$Res>(_self.lastFix!, (value) {
    return _then(_self.copyWith(lastFix: value));
  });
}
}

// dart format on
