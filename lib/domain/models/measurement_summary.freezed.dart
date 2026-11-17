// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurement_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MeasurementSummary {

 String get id; MeasurementType get type; MeasurementStatus get status; DateTime get updatedAt; String? get name; double? get areaM2; double? get perimeterM; double? get distanceM; int? get durationSec; int get pointCount; int get segmentCount; int get photoCount; String? get thumbnailPath; DateTime? get savedAt; WalkRunState? get walkState;
/// Create a copy of MeasurementSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasurementSummaryCopyWith<MeasurementSummary> get copyWith => _$MeasurementSummaryCopyWithImpl<MeasurementSummary>(this as MeasurementSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasurementSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.perimeterM, perimeterM) || other.perimeterM == perimeterM)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.durationSec, durationSec) || other.durationSec == durationSec)&&(identical(other.pointCount, pointCount) || other.pointCount == pointCount)&&(identical(other.segmentCount, segmentCount) || other.segmentCount == segmentCount)&&(identical(other.photoCount, photoCount) || other.photoCount == photoCount)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.walkState, walkState) || other.walkState == walkState));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,status,updatedAt,name,areaM2,perimeterM,distanceM,durationSec,pointCount,segmentCount,photoCount,thumbnailPath,savedAt,walkState);

@override
String toString() {
  return 'MeasurementSummary(id: $id, type: $type, status: $status, updatedAt: $updatedAt, name: $name, areaM2: $areaM2, perimeterM: $perimeterM, distanceM: $distanceM, durationSec: $durationSec, pointCount: $pointCount, segmentCount: $segmentCount, photoCount: $photoCount, thumbnailPath: $thumbnailPath, savedAt: $savedAt, walkState: $walkState)';
}


}

/// @nodoc
abstract mixin class $MeasurementSummaryCopyWith<$Res>  {
  factory $MeasurementSummaryCopyWith(MeasurementSummary value, $Res Function(MeasurementSummary) _then) = _$MeasurementSummaryCopyWithImpl;
@useResult
$Res call({
 String id, MeasurementType type, MeasurementStatus status, DateTime updatedAt, String? name, double? areaM2, double? perimeterM, double? distanceM, int? durationSec, int pointCount, int segmentCount, int photoCount, String? thumbnailPath, DateTime? savedAt, WalkRunState? walkState
});




}
/// @nodoc
class _$MeasurementSummaryCopyWithImpl<$Res>
    implements $MeasurementSummaryCopyWith<$Res> {
  _$MeasurementSummaryCopyWithImpl(this._self, this._then);

  final MeasurementSummary _self;
  final $Res Function(MeasurementSummary) _then;

/// Create a copy of MeasurementSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? status = null,Object? updatedAt = null,Object? name = freezed,Object? areaM2 = freezed,Object? perimeterM = freezed,Object? distanceM = freezed,Object? durationSec = freezed,Object? pointCount = null,Object? segmentCount = null,Object? photoCount = null,Object? thumbnailPath = freezed,Object? savedAt = freezed,Object? walkState = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MeasurementType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MeasurementStatus,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,perimeterM: freezed == perimeterM ? _self.perimeterM : perimeterM // ignore: cast_nullable_to_non_nullable
as double?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as double?,durationSec: freezed == durationSec ? _self.durationSec : durationSec // ignore: cast_nullable_to_non_nullable
as int?,pointCount: null == pointCount ? _self.pointCount : pointCount // ignore: cast_nullable_to_non_nullable
as int,segmentCount: null == segmentCount ? _self.segmentCount : segmentCount // ignore: cast_nullable_to_non_nullable
as int,photoCount: null == photoCount ? _self.photoCount : photoCount // ignore: cast_nullable_to_non_nullable
as int,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,savedAt: freezed == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,walkState: freezed == walkState ? _self.walkState : walkState // ignore: cast_nullable_to_non_nullable
as WalkRunState?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeasurementSummary].
extension MeasurementSummaryPatterns on MeasurementSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeasurementSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeasurementSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeasurementSummary value)  $default,){
final _that = this;
switch (_that) {
case _MeasurementSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeasurementSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MeasurementSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MeasurementType type,  MeasurementStatus status,  DateTime updatedAt,  String? name,  double? areaM2,  double? perimeterM,  double? distanceM,  int? durationSec,  int pointCount,  int segmentCount,  int photoCount,  String? thumbnailPath,  DateTime? savedAt,  WalkRunState? walkState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeasurementSummary() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.updatedAt,_that.name,_that.areaM2,_that.perimeterM,_that.distanceM,_that.durationSec,_that.pointCount,_that.segmentCount,_that.photoCount,_that.thumbnailPath,_that.savedAt,_that.walkState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MeasurementType type,  MeasurementStatus status,  DateTime updatedAt,  String? name,  double? areaM2,  double? perimeterM,  double? distanceM,  int? durationSec,  int pointCount,  int segmentCount,  int photoCount,  String? thumbnailPath,  DateTime? savedAt,  WalkRunState? walkState)  $default,) {final _that = this;
switch (_that) {
case _MeasurementSummary():
return $default(_that.id,_that.type,_that.status,_that.updatedAt,_that.name,_that.areaM2,_that.perimeterM,_that.distanceM,_that.durationSec,_that.pointCount,_that.segmentCount,_that.photoCount,_that.thumbnailPath,_that.savedAt,_that.walkState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MeasurementType type,  MeasurementStatus status,  DateTime updatedAt,  String? name,  double? areaM2,  double? perimeterM,  double? distanceM,  int? durationSec,  int pointCount,  int segmentCount,  int photoCount,  String? thumbnailPath,  DateTime? savedAt,  WalkRunState? walkState)?  $default,) {final _that = this;
switch (_that) {
case _MeasurementSummary() when $default != null:
return $default(_that.id,_that.type,_that.status,_that.updatedAt,_that.name,_that.areaM2,_that.perimeterM,_that.distanceM,_that.durationSec,_that.pointCount,_that.segmentCount,_that.photoCount,_that.thumbnailPath,_that.savedAt,_that.walkState);case _:
  return null;

}
}

}

/// @nodoc


class _MeasurementSummary implements MeasurementSummary {
  const _MeasurementSummary({required this.id, required this.type, required this.status, required this.updatedAt, this.name, this.areaM2, this.perimeterM, this.distanceM, this.durationSec, this.pointCount = 0, this.segmentCount = 0, this.photoCount = 0, this.thumbnailPath, this.savedAt, this.walkState});
  

@override final  String id;
@override final  MeasurementType type;
@override final  MeasurementStatus status;
@override final  DateTime updatedAt;
@override final  String? name;
@override final  double? areaM2;
@override final  double? perimeterM;
@override final  double? distanceM;
@override final  int? durationSec;
@override@JsonKey() final  int pointCount;
@override@JsonKey() final  int segmentCount;
@override@JsonKey() final  int photoCount;
@override final  String? thumbnailPath;
@override final  DateTime? savedAt;
@override final  WalkRunState? walkState;

/// Create a copy of MeasurementSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasurementSummaryCopyWith<_MeasurementSummary> get copyWith => __$MeasurementSummaryCopyWithImpl<_MeasurementSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeasurementSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2)&&(identical(other.perimeterM, perimeterM) || other.perimeterM == perimeterM)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.durationSec, durationSec) || other.durationSec == durationSec)&&(identical(other.pointCount, pointCount) || other.pointCount == pointCount)&&(identical(other.segmentCount, segmentCount) || other.segmentCount == segmentCount)&&(identical(other.photoCount, photoCount) || other.photoCount == photoCount)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.walkState, walkState) || other.walkState == walkState));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,status,updatedAt,name,areaM2,perimeterM,distanceM,durationSec,pointCount,segmentCount,photoCount,thumbnailPath,savedAt,walkState);

@override
String toString() {
  return 'MeasurementSummary(id: $id, type: $type, status: $status, updatedAt: $updatedAt, name: $name, areaM2: $areaM2, perimeterM: $perimeterM, distanceM: $distanceM, durationSec: $durationSec, pointCount: $pointCount, segmentCount: $segmentCount, photoCount: $photoCount, thumbnailPath: $thumbnailPath, savedAt: $savedAt, walkState: $walkState)';
}


}

/// @nodoc
abstract mixin class _$MeasurementSummaryCopyWith<$Res> implements $MeasurementSummaryCopyWith<$Res> {
  factory _$MeasurementSummaryCopyWith(_MeasurementSummary value, $Res Function(_MeasurementSummary) _then) = __$MeasurementSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, MeasurementType type, MeasurementStatus status, DateTime updatedAt, String? name, double? areaM2, double? perimeterM, double? distanceM, int? durationSec, int pointCount, int segmentCount, int photoCount, String? thumbnailPath, DateTime? savedAt, WalkRunState? walkState
});




}
/// @nodoc
class __$MeasurementSummaryCopyWithImpl<$Res>
    implements _$MeasurementSummaryCopyWith<$Res> {
  __$MeasurementSummaryCopyWithImpl(this._self, this._then);

  final _MeasurementSummary _self;
  final $Res Function(_MeasurementSummary) _then;

/// Create a copy of MeasurementSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? status = null,Object? updatedAt = null,Object? name = freezed,Object? areaM2 = freezed,Object? perimeterM = freezed,Object? distanceM = freezed,Object? durationSec = freezed,Object? pointCount = null,Object? segmentCount = null,Object? photoCount = null,Object? thumbnailPath = freezed,Object? savedAt = freezed,Object? walkState = freezed,}) {
  return _then(_MeasurementSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MeasurementType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MeasurementStatus,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,perimeterM: freezed == perimeterM ? _self.perimeterM : perimeterM // ignore: cast_nullable_to_non_nullable
as double?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as double?,durationSec: freezed == durationSec ? _self.durationSec : durationSec // ignore: cast_nullable_to_non_nullable
as int?,pointCount: null == pointCount ? _self.pointCount : pointCount // ignore: cast_nullable_to_non_nullable
as int,segmentCount: null == segmentCount ? _self.segmentCount : segmentCount // ignore: cast_nullable_to_non_nullable
as int,photoCount: null == photoCount ? _self.photoCount : photoCount // ignore: cast_nullable_to_non_nullable
as int,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,savedAt: freezed == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,walkState: freezed == walkState ? _self.walkState : walkState // ignore: cast_nullable_to_non_nullable
as WalkRunState?,
  ));
}


}

// dart format on
