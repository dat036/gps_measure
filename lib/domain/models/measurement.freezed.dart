// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Measurement {

 String get id; MeasurementType get type; MeasurementStatus get status; MapStyle get mapStyle; DateTime get createdAt; DateTime get updatedAt; String? get name; List<MeasurePoint> get points; List<Photo> get photos; String? get notes; MeasurementStats get stats; AreaUnit? get displayAreaUnit; DistanceUnit? get displayDistanceUnit;/// Land value: price per [unitPriceArea] in [unitPriceCurrency].
 double? get unitPrice; String? get unitPriceCurrency; AreaUnit? get unitPriceArea; String? get thumbnailPath; DateTime? get savedAt; WalkRunState? get walkState; DateTime? get walkStartedAt; int? get walkElapsedSec; DateTime? get walkLastResumeAt;
/// Create a copy of Measurement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasurementCopyWith<Measurement> get copyWith => _$MeasurementCopyWithImpl<Measurement>(this as Measurement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Measurement&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.mapStyle, mapStyle) || other.mapStyle == mapStyle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.points, points)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.displayAreaUnit, displayAreaUnit) || other.displayAreaUnit == displayAreaUnit)&&(identical(other.displayDistanceUnit, displayDistanceUnit) || other.displayDistanceUnit == displayDistanceUnit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.unitPriceCurrency, unitPriceCurrency) || other.unitPriceCurrency == unitPriceCurrency)&&(identical(other.unitPriceArea, unitPriceArea) || other.unitPriceArea == unitPriceArea)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.walkState, walkState) || other.walkState == walkState)&&(identical(other.walkStartedAt, walkStartedAt) || other.walkStartedAt == walkStartedAt)&&(identical(other.walkElapsedSec, walkElapsedSec) || other.walkElapsedSec == walkElapsedSec)&&(identical(other.walkLastResumeAt, walkLastResumeAt) || other.walkLastResumeAt == walkLastResumeAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,type,status,mapStyle,createdAt,updatedAt,name,const DeepCollectionEquality().hash(points),const DeepCollectionEquality().hash(photos),notes,stats,displayAreaUnit,displayDistanceUnit,unitPrice,unitPriceCurrency,unitPriceArea,thumbnailPath,savedAt,walkState,walkStartedAt,walkElapsedSec,walkLastResumeAt]);

@override
String toString() {
  return 'Measurement(id: $id, type: $type, status: $status, mapStyle: $mapStyle, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, points: $points, photos: $photos, notes: $notes, stats: $stats, displayAreaUnit: $displayAreaUnit, displayDistanceUnit: $displayDistanceUnit, unitPrice: $unitPrice, unitPriceCurrency: $unitPriceCurrency, unitPriceArea: $unitPriceArea, thumbnailPath: $thumbnailPath, savedAt: $savedAt, walkState: $walkState, walkStartedAt: $walkStartedAt, walkElapsedSec: $walkElapsedSec, walkLastResumeAt: $walkLastResumeAt)';
}


}

/// @nodoc
abstract mixin class $MeasurementCopyWith<$Res>  {
  factory $MeasurementCopyWith(Measurement value, $Res Function(Measurement) _then) = _$MeasurementCopyWithImpl;
@useResult
$Res call({
 String id, MeasurementType type, MeasurementStatus status, MapStyle mapStyle, DateTime createdAt, DateTime updatedAt, String? name, List<MeasurePoint> points, List<Photo> photos, String? notes, MeasurementStats stats, AreaUnit? displayAreaUnit, DistanceUnit? displayDistanceUnit, double? unitPrice, String? unitPriceCurrency, AreaUnit? unitPriceArea, String? thumbnailPath, DateTime? savedAt, WalkRunState? walkState, DateTime? walkStartedAt, int? walkElapsedSec, DateTime? walkLastResumeAt
});


$MeasurementStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$MeasurementCopyWithImpl<$Res>
    implements $MeasurementCopyWith<$Res> {
  _$MeasurementCopyWithImpl(this._self, this._then);

  final Measurement _self;
  final $Res Function(Measurement) _then;

/// Create a copy of Measurement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? status = null,Object? mapStyle = null,Object? createdAt = null,Object? updatedAt = null,Object? name = freezed,Object? points = null,Object? photos = null,Object? notes = freezed,Object? stats = null,Object? displayAreaUnit = freezed,Object? displayDistanceUnit = freezed,Object? unitPrice = freezed,Object? unitPriceCurrency = freezed,Object? unitPriceArea = freezed,Object? thumbnailPath = freezed,Object? savedAt = freezed,Object? walkState = freezed,Object? walkStartedAt = freezed,Object? walkElapsedSec = freezed,Object? walkLastResumeAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MeasurementType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MeasurementStatus,mapStyle: null == mapStyle ? _self.mapStyle : mapStyle // ignore: cast_nullable_to_non_nullable
as MapStyle,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<MeasurePoint>,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<Photo>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as MeasurementStats,displayAreaUnit: freezed == displayAreaUnit ? _self.displayAreaUnit : displayAreaUnit // ignore: cast_nullable_to_non_nullable
as AreaUnit?,displayDistanceUnit: freezed == displayDistanceUnit ? _self.displayDistanceUnit : displayDistanceUnit // ignore: cast_nullable_to_non_nullable
as DistanceUnit?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,unitPriceCurrency: freezed == unitPriceCurrency ? _self.unitPriceCurrency : unitPriceCurrency // ignore: cast_nullable_to_non_nullable
as String?,unitPriceArea: freezed == unitPriceArea ? _self.unitPriceArea : unitPriceArea // ignore: cast_nullable_to_non_nullable
as AreaUnit?,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,savedAt: freezed == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,walkState: freezed == walkState ? _self.walkState : walkState // ignore: cast_nullable_to_non_nullable
as WalkRunState?,walkStartedAt: freezed == walkStartedAt ? _self.walkStartedAt : walkStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,walkElapsedSec: freezed == walkElapsedSec ? _self.walkElapsedSec : walkElapsedSec // ignore: cast_nullable_to_non_nullable
as int?,walkLastResumeAt: freezed == walkLastResumeAt ? _self.walkLastResumeAt : walkLastResumeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Measurement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeasurementStatsCopyWith<$Res> get stats {
  
  return $MeasurementStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [Measurement].
extension MeasurementPatterns on Measurement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Measurement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Measurement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Measurement value)  $default,){
final _that = this;
switch (_that) {
case _Measurement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Measurement value)?  $default,){
final _that = this;
switch (_that) {
case _Measurement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MeasurementType type,  MeasurementStatus status,  MapStyle mapStyle,  DateTime createdAt,  DateTime updatedAt,  String? name,  List<MeasurePoint> points,  List<Photo> photos,  String? notes,  MeasurementStats stats,  AreaUnit? displayAreaUnit,  DistanceUnit? displayDistanceUnit,  double? unitPrice,  String? unitPriceCurrency,  AreaUnit? unitPriceArea,  String? thumbnailPath,  DateTime? savedAt,  WalkRunState? walkState,  DateTime? walkStartedAt,  int? walkElapsedSec,  DateTime? walkLastResumeAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Measurement() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.mapStyle,_that.createdAt,_that.updatedAt,_that.name,_that.points,_that.photos,_that.notes,_that.stats,_that.displayAreaUnit,_that.displayDistanceUnit,_that.unitPrice,_that.unitPriceCurrency,_that.unitPriceArea,_that.thumbnailPath,_that.savedAt,_that.walkState,_that.walkStartedAt,_that.walkElapsedSec,_that.walkLastResumeAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MeasurementType type,  MeasurementStatus status,  MapStyle mapStyle,  DateTime createdAt,  DateTime updatedAt,  String? name,  List<MeasurePoint> points,  List<Photo> photos,  String? notes,  MeasurementStats stats,  AreaUnit? displayAreaUnit,  DistanceUnit? displayDistanceUnit,  double? unitPrice,  String? unitPriceCurrency,  AreaUnit? unitPriceArea,  String? thumbnailPath,  DateTime? savedAt,  WalkRunState? walkState,  DateTime? walkStartedAt,  int? walkElapsedSec,  DateTime? walkLastResumeAt)  $default,) {final _that = this;
switch (_that) {
case _Measurement():
return $default(_that.id,_that.type,_that.status,_that.mapStyle,_that.createdAt,_that.updatedAt,_that.name,_that.points,_that.photos,_that.notes,_that.stats,_that.displayAreaUnit,_that.displayDistanceUnit,_that.unitPrice,_that.unitPriceCurrency,_that.unitPriceArea,_that.thumbnailPath,_that.savedAt,_that.walkState,_that.walkStartedAt,_that.walkElapsedSec,_that.walkLastResumeAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MeasurementType type,  MeasurementStatus status,  MapStyle mapStyle,  DateTime createdAt,  DateTime updatedAt,  String? name,  List<MeasurePoint> points,  List<Photo> photos,  String? notes,  MeasurementStats stats,  AreaUnit? displayAreaUnit,  DistanceUnit? displayDistanceUnit,  double? unitPrice,  String? unitPriceCurrency,  AreaUnit? unitPriceArea,  String? thumbnailPath,  DateTime? savedAt,  WalkRunState? walkState,  DateTime? walkStartedAt,  int? walkElapsedSec,  DateTime? walkLastResumeAt)?  $default,) {final _that = this;
switch (_that) {
case _Measurement() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.mapStyle,_that.createdAt,_that.updatedAt,_that.name,_that.points,_that.photos,_that.notes,_that.stats,_that.displayAreaUnit,_that.displayDistanceUnit,_that.unitPrice,_that.unitPriceCurrency,_that.unitPriceArea,_that.thumbnailPath,_that.savedAt,_that.walkState,_that.walkStartedAt,_that.walkElapsedSec,_that.walkLastResumeAt);case _:
  return null;

}
}

}

/// @nodoc


class _Measurement implements Measurement {
  const _Measurement({required this.id, required this.type, required this.status, required this.mapStyle, required this.createdAt, required this.updatedAt, this.name, final  List<MeasurePoint> points = const <MeasurePoint>[], final  List<Photo> photos = const <Photo>[], this.notes, this.stats = MeasurementStats.empty, this.displayAreaUnit, this.displayDistanceUnit, this.unitPrice, this.unitPriceCurrency, this.unitPriceArea, this.thumbnailPath, this.savedAt, this.walkState, this.walkStartedAt, this.walkElapsedSec, this.walkLastResumeAt}): _points = points,_photos = photos;
  

@override final  String id;
@override final  MeasurementType type;
@override final  MeasurementStatus status;
@override final  MapStyle mapStyle;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? name;
 final  List<MeasurePoint> _points;
@override@JsonKey() List<MeasurePoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

 final  List<Photo> _photos;
@override@JsonKey() List<Photo> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override final  String? notes;
@override@JsonKey() final  MeasurementStats stats;
@override final  AreaUnit? displayAreaUnit;
@override final  DistanceUnit? displayDistanceUnit;
/// Land value: price per [unitPriceArea] in [unitPriceCurrency].
@override final  double? unitPrice;
@override final  String? unitPriceCurrency;
@override final  AreaUnit? unitPriceArea;
@override final  String? thumbnailPath;
@override final  DateTime? savedAt;
@override final  WalkRunState? walkState;
@override final  DateTime? walkStartedAt;
@override final  int? walkElapsedSec;
@override final  DateTime? walkLastResumeAt;

/// Create a copy of Measurement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasurementCopyWith<_Measurement> get copyWith => __$MeasurementCopyWithImpl<_Measurement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Measurement&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.mapStyle, mapStyle) || other.mapStyle == mapStyle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._points, _points)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.displayAreaUnit, displayAreaUnit) || other.displayAreaUnit == displayAreaUnit)&&(identical(other.displayDistanceUnit, displayDistanceUnit) || other.displayDistanceUnit == displayDistanceUnit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.unitPriceCurrency, unitPriceCurrency) || other.unitPriceCurrency == unitPriceCurrency)&&(identical(other.unitPriceArea, unitPriceArea) || other.unitPriceArea == unitPriceArea)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.walkState, walkState) || other.walkState == walkState)&&(identical(other.walkStartedAt, walkStartedAt) || other.walkStartedAt == walkStartedAt)&&(identical(other.walkElapsedSec, walkElapsedSec) || other.walkElapsedSec == walkElapsedSec)&&(identical(other.walkLastResumeAt, walkLastResumeAt) || other.walkLastResumeAt == walkLastResumeAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,type,status,mapStyle,createdAt,updatedAt,name,const DeepCollectionEquality().hash(_points),const DeepCollectionEquality().hash(_photos),notes,stats,displayAreaUnit,displayDistanceUnit,unitPrice,unitPriceCurrency,unitPriceArea,thumbnailPath,savedAt,walkState,walkStartedAt,walkElapsedSec,walkLastResumeAt]);

@override
String toString() {
  return 'Measurement(id: $id, type: $type, status: $status, mapStyle: $mapStyle, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, points: $points, photos: $photos, notes: $notes, stats: $stats, displayAreaUnit: $displayAreaUnit, displayDistanceUnit: $displayDistanceUnit, unitPrice: $unitPrice, unitPriceCurrency: $unitPriceCurrency, unitPriceArea: $unitPriceArea, thumbnailPath: $thumbnailPath, savedAt: $savedAt, walkState: $walkState, walkStartedAt: $walkStartedAt, walkElapsedSec: $walkElapsedSec, walkLastResumeAt: $walkLastResumeAt)';
}


}

/// @nodoc
abstract mixin class _$MeasurementCopyWith<$Res> implements $MeasurementCopyWith<$Res> {
  factory _$MeasurementCopyWith(_Measurement value, $Res Function(_Measurement) _then) = __$MeasurementCopyWithImpl;
@override @useResult
$Res call({
 String id, MeasurementType type, MeasurementStatus status, MapStyle mapStyle, DateTime createdAt, DateTime updatedAt, String? name, List<MeasurePoint> points, List<Photo> photos, String? notes, MeasurementStats stats, AreaUnit? displayAreaUnit, DistanceUnit? displayDistanceUnit, double? unitPrice, String? unitPriceCurrency, AreaUnit? unitPriceArea, String? thumbnailPath, DateTime? savedAt, WalkRunState? walkState, DateTime? walkStartedAt, int? walkElapsedSec, DateTime? walkLastResumeAt
});


@override $MeasurementStatsCopyWith<$Res> get stats;

}
/// @nodoc
class __$MeasurementCopyWithImpl<$Res>
    implements _$MeasurementCopyWith<$Res> {
  __$MeasurementCopyWithImpl(this._self, this._then);

  final _Measurement _self;
  final $Res Function(_Measurement) _then;

/// Create a copy of Measurement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? status = null,Object? mapStyle = null,Object? createdAt = null,Object? updatedAt = null,Object? name = freezed,Object? points = null,Object? photos = null,Object? notes = freezed,Object? stats = null,Object? displayAreaUnit = freezed,Object? displayDistanceUnit = freezed,Object? unitPrice = freezed,Object? unitPriceCurrency = freezed,Object? unitPriceArea = freezed,Object? thumbnailPath = freezed,Object? savedAt = freezed,Object? walkState = freezed,Object? walkStartedAt = freezed,Object? walkElapsedSec = freezed,Object? walkLastResumeAt = freezed,}) {
  return _then(_Measurement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MeasurementType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MeasurementStatus,mapStyle: null == mapStyle ? _self.mapStyle : mapStyle // ignore: cast_nullable_to_non_nullable
as MapStyle,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<MeasurePoint>,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<Photo>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as MeasurementStats,displayAreaUnit: freezed == displayAreaUnit ? _self.displayAreaUnit : displayAreaUnit // ignore: cast_nullable_to_non_nullable
as AreaUnit?,displayDistanceUnit: freezed == displayDistanceUnit ? _self.displayDistanceUnit : displayDistanceUnit // ignore: cast_nullable_to_non_nullable
as DistanceUnit?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,unitPriceCurrency: freezed == unitPriceCurrency ? _self.unitPriceCurrency : unitPriceCurrency // ignore: cast_nullable_to_non_nullable
as String?,unitPriceArea: freezed == unitPriceArea ? _self.unitPriceArea : unitPriceArea // ignore: cast_nullable_to_non_nullable
as AreaUnit?,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,savedAt: freezed == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,walkState: freezed == walkState ? _self.walkState : walkState // ignore: cast_nullable_to_non_nullable
as WalkRunState?,walkStartedAt: freezed == walkStartedAt ? _self.walkStartedAt : walkStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,walkElapsedSec: freezed == walkElapsedSec ? _self.walkElapsedSec : walkElapsedSec // ignore: cast_nullable_to_non_nullable
as int?,walkLastResumeAt: freezed == walkLastResumeAt ? _self.walkLastResumeAt : walkLastResumeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Measurement
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
