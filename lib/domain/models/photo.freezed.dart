// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Photo {

 String get id; String get measurementId;/// Paths RELATIVE to the app documents directory (the iOS container path
/// changes between app updates).
 String get filePath; String get thumbPath; DateTime get takenAt; PhotoSource get source; int get width; int get height; int get bytes; int get sortIndex;/// Set when the photo is attached to a specific point (badge 📷).
 String? get pointId; double? get lat; double? get lng; String? get caption;
/// Create a copy of Photo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoCopyWith<Photo> get copyWith => _$PhotoCopyWithImpl<Photo>(this as Photo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Photo&&(identical(other.id, id) || other.id == id)&&(identical(other.measurementId, measurementId) || other.measurementId == measurementId)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.thumbPath, thumbPath) || other.thumbPath == thumbPath)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.source, source) || other.source == source)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.bytes, bytes) || other.bytes == bytes)&&(identical(other.sortIndex, sortIndex) || other.sortIndex == sortIndex)&&(identical(other.pointId, pointId) || other.pointId == pointId)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.caption, caption) || other.caption == caption));
}


@override
int get hashCode => Object.hash(runtimeType,id,measurementId,filePath,thumbPath,takenAt,source,width,height,bytes,sortIndex,pointId,lat,lng,caption);

@override
String toString() {
  return 'Photo(id: $id, measurementId: $measurementId, filePath: $filePath, thumbPath: $thumbPath, takenAt: $takenAt, source: $source, width: $width, height: $height, bytes: $bytes, sortIndex: $sortIndex, pointId: $pointId, lat: $lat, lng: $lng, caption: $caption)';
}


}

/// @nodoc
abstract mixin class $PhotoCopyWith<$Res>  {
  factory $PhotoCopyWith(Photo value, $Res Function(Photo) _then) = _$PhotoCopyWithImpl;
@useResult
$Res call({
 String id, String measurementId, String filePath, String thumbPath, DateTime takenAt, PhotoSource source, int width, int height, int bytes, int sortIndex, String? pointId, double? lat, double? lng, String? caption
});




}
/// @nodoc
class _$PhotoCopyWithImpl<$Res>
    implements $PhotoCopyWith<$Res> {
  _$PhotoCopyWithImpl(this._self, this._then);

  final Photo _self;
  final $Res Function(Photo) _then;

/// Create a copy of Photo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? measurementId = null,Object? filePath = null,Object? thumbPath = null,Object? takenAt = null,Object? source = null,Object? width = null,Object? height = null,Object? bytes = null,Object? sortIndex = null,Object? pointId = freezed,Object? lat = freezed,Object? lng = freezed,Object? caption = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,measurementId: null == measurementId ? _self.measurementId : measurementId // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,thumbPath: null == thumbPath ? _self.thumbPath : thumbPath // ignore: cast_nullable_to_non_nullable
as String,takenAt: null == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as PhotoSource,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,sortIndex: null == sortIndex ? _self.sortIndex : sortIndex // ignore: cast_nullable_to_non_nullable
as int,pointId: freezed == pointId ? _self.pointId : pointId // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Photo].
extension PhotoPatterns on Photo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Photo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Photo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Photo value)  $default,){
final _that = this;
switch (_that) {
case _Photo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Photo value)?  $default,){
final _that = this;
switch (_that) {
case _Photo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String measurementId,  String filePath,  String thumbPath,  DateTime takenAt,  PhotoSource source,  int width,  int height,  int bytes,  int sortIndex,  String? pointId,  double? lat,  double? lng,  String? caption)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Photo() when $default != null:
return $default(_that.id,_that.measurementId,_that.filePath,_that.thumbPath,_that.takenAt,_that.source,_that.width,_that.height,_that.bytes,_that.sortIndex,_that.pointId,_that.lat,_that.lng,_that.caption);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String measurementId,  String filePath,  String thumbPath,  DateTime takenAt,  PhotoSource source,  int width,  int height,  int bytes,  int sortIndex,  String? pointId,  double? lat,  double? lng,  String? caption)  $default,) {final _that = this;
switch (_that) {
case _Photo():
return $default(_that.id,_that.measurementId,_that.filePath,_that.thumbPath,_that.takenAt,_that.source,_that.width,_that.height,_that.bytes,_that.sortIndex,_that.pointId,_that.lat,_that.lng,_that.caption);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String measurementId,  String filePath,  String thumbPath,  DateTime takenAt,  PhotoSource source,  int width,  int height,  int bytes,  int sortIndex,  String? pointId,  double? lat,  double? lng,  String? caption)?  $default,) {final _that = this;
switch (_that) {
case _Photo() when $default != null:
return $default(_that.id,_that.measurementId,_that.filePath,_that.thumbPath,_that.takenAt,_that.source,_that.width,_that.height,_that.bytes,_that.sortIndex,_that.pointId,_that.lat,_that.lng,_that.caption);case _:
  return null;

}
}

}

/// @nodoc


class _Photo implements Photo {
  const _Photo({required this.id, required this.measurementId, required this.filePath, required this.thumbPath, required this.takenAt, required this.source, required this.width, required this.height, required this.bytes, required this.sortIndex, this.pointId, this.lat, this.lng, this.caption});
  

@override final  String id;
@override final  String measurementId;
/// Paths RELATIVE to the app documents directory (the iOS container path
/// changes between app updates).
@override final  String filePath;
@override final  String thumbPath;
@override final  DateTime takenAt;
@override final  PhotoSource source;
@override final  int width;
@override final  int height;
@override final  int bytes;
@override final  int sortIndex;
/// Set when the photo is attached to a specific point (badge 📷).
@override final  String? pointId;
@override final  double? lat;
@override final  double? lng;
@override final  String? caption;

/// Create a copy of Photo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoCopyWith<_Photo> get copyWith => __$PhotoCopyWithImpl<_Photo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Photo&&(identical(other.id, id) || other.id == id)&&(identical(other.measurementId, measurementId) || other.measurementId == measurementId)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.thumbPath, thumbPath) || other.thumbPath == thumbPath)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.source, source) || other.source == source)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.bytes, bytes) || other.bytes == bytes)&&(identical(other.sortIndex, sortIndex) || other.sortIndex == sortIndex)&&(identical(other.pointId, pointId) || other.pointId == pointId)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.caption, caption) || other.caption == caption));
}


@override
int get hashCode => Object.hash(runtimeType,id,measurementId,filePath,thumbPath,takenAt,source,width,height,bytes,sortIndex,pointId,lat,lng,caption);

@override
String toString() {
  return 'Photo(id: $id, measurementId: $measurementId, filePath: $filePath, thumbPath: $thumbPath, takenAt: $takenAt, source: $source, width: $width, height: $height, bytes: $bytes, sortIndex: $sortIndex, pointId: $pointId, lat: $lat, lng: $lng, caption: $caption)';
}


}

/// @nodoc
abstract mixin class _$PhotoCopyWith<$Res> implements $PhotoCopyWith<$Res> {
  factory _$PhotoCopyWith(_Photo value, $Res Function(_Photo) _then) = __$PhotoCopyWithImpl;
@override @useResult
$Res call({
 String id, String measurementId, String filePath, String thumbPath, DateTime takenAt, PhotoSource source, int width, int height, int bytes, int sortIndex, String? pointId, double? lat, double? lng, String? caption
});




}
/// @nodoc
class __$PhotoCopyWithImpl<$Res>
    implements _$PhotoCopyWith<$Res> {
  __$PhotoCopyWithImpl(this._self, this._then);

  final _Photo _self;
  final $Res Function(_Photo) _then;

/// Create a copy of Photo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? measurementId = null,Object? filePath = null,Object? thumbPath = null,Object? takenAt = null,Object? source = null,Object? width = null,Object? height = null,Object? bytes = null,Object? sortIndex = null,Object? pointId = freezed,Object? lat = freezed,Object? lng = freezed,Object? caption = freezed,}) {
  return _then(_Photo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,measurementId: null == measurementId ? _self.measurementId : measurementId // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,thumbPath: null == thumbPath ? _self.thumbPath : thumbPath // ignore: cast_nullable_to_non_nullable
as String,takenAt: null == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as PhotoSource,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,sortIndex: null == sortIndex ? _self.sortIndex : sortIndex // ignore: cast_nullable_to_non_nullable
as int,pointId: freezed == pointId ? _self.pointId : pointId // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
