// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measure_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MeasureSessionState {

 MeasurementType get type; MapStyle get mapStyle;/// Draft id; null until the first point creates the draft.
 String? get measurementId; List<MeasurePoint> get points; bool get isClosed; String? get selectedPointId; MeasurementStats get stats; bool get canUndo; AreaUnit? get displayAreaUnit; DistanceUnit? get displayDistanceUnit;/// The last autosave failed; retried on the next change / flush.
 bool get saveFailed;/// Edit of a saved measurement (`plan.md` P7-08): nothing is written
/// until "Save Changes".
 bool get editing;/// Editing: the geometry differs from the saved one.
 bool get geometryChanged;
/// Create a copy of MeasureSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasureSessionStateCopyWith<MeasureSessionState> get copyWith => _$MeasureSessionStateCopyWithImpl<MeasureSessionState>(this as MeasureSessionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasureSessionState&&(identical(other.type, type) || other.type == type)&&(identical(other.mapStyle, mapStyle) || other.mapStyle == mapStyle)&&(identical(other.measurementId, measurementId) || other.measurementId == measurementId)&&const DeepCollectionEquality().equals(other.points, points)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed)&&(identical(other.selectedPointId, selectedPointId) || other.selectedPointId == selectedPointId)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.canUndo, canUndo) || other.canUndo == canUndo)&&(identical(other.displayAreaUnit, displayAreaUnit) || other.displayAreaUnit == displayAreaUnit)&&(identical(other.displayDistanceUnit, displayDistanceUnit) || other.displayDistanceUnit == displayDistanceUnit)&&(identical(other.saveFailed, saveFailed) || other.saveFailed == saveFailed)&&(identical(other.editing, editing) || other.editing == editing)&&(identical(other.geometryChanged, geometryChanged) || other.geometryChanged == geometryChanged));
}


@override
int get hashCode => Object.hash(runtimeType,type,mapStyle,measurementId,const DeepCollectionEquality().hash(points),isClosed,selectedPointId,stats,canUndo,displayAreaUnit,displayDistanceUnit,saveFailed,editing,geometryChanged);

@override
String toString() {
  return 'MeasureSessionState(type: $type, mapStyle: $mapStyle, measurementId: $measurementId, points: $points, isClosed: $isClosed, selectedPointId: $selectedPointId, stats: $stats, canUndo: $canUndo, displayAreaUnit: $displayAreaUnit, displayDistanceUnit: $displayDistanceUnit, saveFailed: $saveFailed, editing: $editing, geometryChanged: $geometryChanged)';
}


}

/// @nodoc
abstract mixin class $MeasureSessionStateCopyWith<$Res>  {
  factory $MeasureSessionStateCopyWith(MeasureSessionState value, $Res Function(MeasureSessionState) _then) = _$MeasureSessionStateCopyWithImpl;
@useResult
$Res call({
 MeasurementType type, MapStyle mapStyle, String? measurementId, List<MeasurePoint> points, bool isClosed, String? selectedPointId, MeasurementStats stats, bool canUndo, AreaUnit? displayAreaUnit, DistanceUnit? displayDistanceUnit, bool saveFailed, bool editing, bool geometryChanged
});


$MeasurementStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$MeasureSessionStateCopyWithImpl<$Res>
    implements $MeasureSessionStateCopyWith<$Res> {
  _$MeasureSessionStateCopyWithImpl(this._self, this._then);

  final MeasureSessionState _self;
  final $Res Function(MeasureSessionState) _then;

/// Create a copy of MeasureSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? mapStyle = null,Object? measurementId = freezed,Object? points = null,Object? isClosed = null,Object? selectedPointId = freezed,Object? stats = null,Object? canUndo = null,Object? displayAreaUnit = freezed,Object? displayDistanceUnit = freezed,Object? saveFailed = null,Object? editing = null,Object? geometryChanged = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MeasurementType,mapStyle: null == mapStyle ? _self.mapStyle : mapStyle // ignore: cast_nullable_to_non_nullable
as MapStyle,measurementId: freezed == measurementId ? _self.measurementId : measurementId // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<MeasurePoint>,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,selectedPointId: freezed == selectedPointId ? _self.selectedPointId : selectedPointId // ignore: cast_nullable_to_non_nullable
as String?,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as MeasurementStats,canUndo: null == canUndo ? _self.canUndo : canUndo // ignore: cast_nullable_to_non_nullable
as bool,displayAreaUnit: freezed == displayAreaUnit ? _self.displayAreaUnit : displayAreaUnit // ignore: cast_nullable_to_non_nullable
as AreaUnit?,displayDistanceUnit: freezed == displayDistanceUnit ? _self.displayDistanceUnit : displayDistanceUnit // ignore: cast_nullable_to_non_nullable
as DistanceUnit?,saveFailed: null == saveFailed ? _self.saveFailed : saveFailed // ignore: cast_nullable_to_non_nullable
as bool,editing: null == editing ? _self.editing : editing // ignore: cast_nullable_to_non_nullable
as bool,geometryChanged: null == geometryChanged ? _self.geometryChanged : geometryChanged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MeasureSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeasurementStatsCopyWith<$Res> get stats {
  
  return $MeasurementStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeasureSessionState].
extension MeasureSessionStatePatterns on MeasureSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeasureSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeasureSessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeasureSessionState value)  $default,){
final _that = this;
switch (_that) {
case _MeasureSessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeasureSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _MeasureSessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MeasurementType type,  MapStyle mapStyle,  String? measurementId,  List<MeasurePoint> points,  bool isClosed,  String? selectedPointId,  MeasurementStats stats,  bool canUndo,  AreaUnit? displayAreaUnit,  DistanceUnit? displayDistanceUnit,  bool saveFailed,  bool editing,  bool geometryChanged)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeasureSessionState() when $default != null:
return $default(_that.type,_that.mapStyle,_that.measurementId,_that.points,_that.isClosed,_that.selectedPointId,_that.stats,_that.canUndo,_that.displayAreaUnit,_that.displayDistanceUnit,_that.saveFailed,_that.editing,_that.geometryChanged);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MeasurementType type,  MapStyle mapStyle,  String? measurementId,  List<MeasurePoint> points,  bool isClosed,  String? selectedPointId,  MeasurementStats stats,  bool canUndo,  AreaUnit? displayAreaUnit,  DistanceUnit? displayDistanceUnit,  bool saveFailed,  bool editing,  bool geometryChanged)  $default,) {final _that = this;
switch (_that) {
case _MeasureSessionState():
return $default(_that.type,_that.mapStyle,_that.measurementId,_that.points,_that.isClosed,_that.selectedPointId,_that.stats,_that.canUndo,_that.displayAreaUnit,_that.displayDistanceUnit,_that.saveFailed,_that.editing,_that.geometryChanged);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MeasurementType type,  MapStyle mapStyle,  String? measurementId,  List<MeasurePoint> points,  bool isClosed,  String? selectedPointId,  MeasurementStats stats,  bool canUndo,  AreaUnit? displayAreaUnit,  DistanceUnit? displayDistanceUnit,  bool saveFailed,  bool editing,  bool geometryChanged)?  $default,) {final _that = this;
switch (_that) {
case _MeasureSessionState() when $default != null:
return $default(_that.type,_that.mapStyle,_that.measurementId,_that.points,_that.isClosed,_that.selectedPointId,_that.stats,_that.canUndo,_that.displayAreaUnit,_that.displayDistanceUnit,_that.saveFailed,_that.editing,_that.geometryChanged);case _:
  return null;

}
}

}

/// @nodoc


class _MeasureSessionState extends MeasureSessionState {
  const _MeasureSessionState({required this.type, required this.mapStyle, this.measurementId, final  List<MeasurePoint> points = const <MeasurePoint>[], this.isClosed = false, this.selectedPointId, this.stats = MeasurementStats.empty, this.canUndo = false, this.displayAreaUnit, this.displayDistanceUnit, this.saveFailed = false, this.editing = false, this.geometryChanged = false}): _points = points,super._();
  

@override final  MeasurementType type;
@override final  MapStyle mapStyle;
/// Draft id; null until the first point creates the draft.
@override final  String? measurementId;
 final  List<MeasurePoint> _points;
@override@JsonKey() List<MeasurePoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

@override@JsonKey() final  bool isClosed;
@override final  String? selectedPointId;
@override@JsonKey() final  MeasurementStats stats;
@override@JsonKey() final  bool canUndo;
@override final  AreaUnit? displayAreaUnit;
@override final  DistanceUnit? displayDistanceUnit;
/// The last autosave failed; retried on the next change / flush.
@override@JsonKey() final  bool saveFailed;
/// Edit of a saved measurement (`plan.md` P7-08): nothing is written
/// until "Save Changes".
@override@JsonKey() final  bool editing;
/// Editing: the geometry differs from the saved one.
@override@JsonKey() final  bool geometryChanged;

/// Create a copy of MeasureSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasureSessionStateCopyWith<_MeasureSessionState> get copyWith => __$MeasureSessionStateCopyWithImpl<_MeasureSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeasureSessionState&&(identical(other.type, type) || other.type == type)&&(identical(other.mapStyle, mapStyle) || other.mapStyle == mapStyle)&&(identical(other.measurementId, measurementId) || other.measurementId == measurementId)&&const DeepCollectionEquality().equals(other._points, _points)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed)&&(identical(other.selectedPointId, selectedPointId) || other.selectedPointId == selectedPointId)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.canUndo, canUndo) || other.canUndo == canUndo)&&(identical(other.displayAreaUnit, displayAreaUnit) || other.displayAreaUnit == displayAreaUnit)&&(identical(other.displayDistanceUnit, displayDistanceUnit) || other.displayDistanceUnit == displayDistanceUnit)&&(identical(other.saveFailed, saveFailed) || other.saveFailed == saveFailed)&&(identical(other.editing, editing) || other.editing == editing)&&(identical(other.geometryChanged, geometryChanged) || other.geometryChanged == geometryChanged));
}


@override
int get hashCode => Object.hash(runtimeType,type,mapStyle,measurementId,const DeepCollectionEquality().hash(_points),isClosed,selectedPointId,stats,canUndo,displayAreaUnit,displayDistanceUnit,saveFailed,editing,geometryChanged);

@override
String toString() {
  return 'MeasureSessionState(type: $type, mapStyle: $mapStyle, measurementId: $measurementId, points: $points, isClosed: $isClosed, selectedPointId: $selectedPointId, stats: $stats, canUndo: $canUndo, displayAreaUnit: $displayAreaUnit, displayDistanceUnit: $displayDistanceUnit, saveFailed: $saveFailed, editing: $editing, geometryChanged: $geometryChanged)';
}


}

/// @nodoc
abstract mixin class _$MeasureSessionStateCopyWith<$Res> implements $MeasureSessionStateCopyWith<$Res> {
  factory _$MeasureSessionStateCopyWith(_MeasureSessionState value, $Res Function(_MeasureSessionState) _then) = __$MeasureSessionStateCopyWithImpl;
@override @useResult
$Res call({
 MeasurementType type, MapStyle mapStyle, String? measurementId, List<MeasurePoint> points, bool isClosed, String? selectedPointId, MeasurementStats stats, bool canUndo, AreaUnit? displayAreaUnit, DistanceUnit? displayDistanceUnit, bool saveFailed, bool editing, bool geometryChanged
});


@override $MeasurementStatsCopyWith<$Res> get stats;

}
/// @nodoc
class __$MeasureSessionStateCopyWithImpl<$Res>
    implements _$MeasureSessionStateCopyWith<$Res> {
  __$MeasureSessionStateCopyWithImpl(this._self, this._then);

  final _MeasureSessionState _self;
  final $Res Function(_MeasureSessionState) _then;

/// Create a copy of MeasureSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? mapStyle = null,Object? measurementId = freezed,Object? points = null,Object? isClosed = null,Object? selectedPointId = freezed,Object? stats = null,Object? canUndo = null,Object? displayAreaUnit = freezed,Object? displayDistanceUnit = freezed,Object? saveFailed = null,Object? editing = null,Object? geometryChanged = null,}) {
  return _then(_MeasureSessionState(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MeasurementType,mapStyle: null == mapStyle ? _self.mapStyle : mapStyle // ignore: cast_nullable_to_non_nullable
as MapStyle,measurementId: freezed == measurementId ? _self.measurementId : measurementId // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<MeasurePoint>,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,selectedPointId: freezed == selectedPointId ? _self.selectedPointId : selectedPointId // ignore: cast_nullable_to_non_nullable
as String?,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as MeasurementStats,canUndo: null == canUndo ? _self.canUndo : canUndo // ignore: cast_nullable_to_non_nullable
as bool,displayAreaUnit: freezed == displayAreaUnit ? _self.displayAreaUnit : displayAreaUnit // ignore: cast_nullable_to_non_nullable
as AreaUnit?,displayDistanceUnit: freezed == displayDistanceUnit ? _self.displayDistanceUnit : displayDistanceUnit // ignore: cast_nullable_to_non_nullable
as DistanceUnit?,saveFailed: null == saveFailed ? _self.saveFailed : saveFailed // ignore: cast_nullable_to_non_nullable
as bool,editing: null == editing ? _self.editing : editing // ignore: cast_nullable_to_non_nullable
as bool,geometryChanged: null == geometryChanged ? _self.geometryChanged : geometryChanged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MeasureSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeasurementStatsCopyWith<$Res> get stats {
  
  return $MeasurementStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}

// dart format on
