// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geo_parse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GeoQuery {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoQuery);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GeoQuery()';
}


}

/// @nodoc
class $GeoQueryCopyWith<$Res>  {
$GeoQueryCopyWith(GeoQuery _, $Res Function(GeoQuery) __);
}


/// Adds pattern-matching-related methods to [GeoQuery].
extension GeoQueryPatterns on GeoQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CoordinateQuery value)?  coordinate,TResult Function( AddressQuery value)?  address,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CoordinateQuery() when coordinate != null:
return coordinate(_that);case AddressQuery() when address != null:
return address(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CoordinateQuery value)  coordinate,required TResult Function( AddressQuery value)  address,}){
final _that = this;
switch (_that) {
case CoordinateQuery():
return coordinate(_that);case AddressQuery():
return address(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CoordinateQuery value)?  coordinate,TResult? Function( AddressQuery value)?  address,}){
final _that = this;
switch (_that) {
case CoordinateQuery() when coordinate != null:
return coordinate(_that);case AddressQuery() when address != null:
return address(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( GeoPoint point)?  coordinate,TResult Function( String text)?  address,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CoordinateQuery() when coordinate != null:
return coordinate(_that.point);case AddressQuery() when address != null:
return address(_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( GeoPoint point)  coordinate,required TResult Function( String text)  address,}) {final _that = this;
switch (_that) {
case CoordinateQuery():
return coordinate(_that.point);case AddressQuery():
return address(_that.text);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( GeoPoint point)?  coordinate,TResult? Function( String text)?  address,}) {final _that = this;
switch (_that) {
case CoordinateQuery() when coordinate != null:
return coordinate(_that.point);case AddressQuery() when address != null:
return address(_that.text);case _:
  return null;

}
}

}

/// @nodoc


class CoordinateQuery implements GeoQuery {
  const CoordinateQuery(this.point);
  

 final  GeoPoint point;

/// Create a copy of GeoQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoordinateQueryCopyWith<CoordinateQuery> get copyWith => _$CoordinateQueryCopyWithImpl<CoordinateQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoordinateQuery&&(identical(other.point, point) || other.point == point));
}


@override
int get hashCode => Object.hash(runtimeType,point);

@override
String toString() {
  return 'GeoQuery.coordinate(point: $point)';
}


}

/// @nodoc
abstract mixin class $CoordinateQueryCopyWith<$Res> implements $GeoQueryCopyWith<$Res> {
  factory $CoordinateQueryCopyWith(CoordinateQuery value, $Res Function(CoordinateQuery) _then) = _$CoordinateQueryCopyWithImpl;
@useResult
$Res call({
 GeoPoint point
});


$GeoPointCopyWith<$Res> get point;

}
/// @nodoc
class _$CoordinateQueryCopyWithImpl<$Res>
    implements $CoordinateQueryCopyWith<$Res> {
  _$CoordinateQueryCopyWithImpl(this._self, this._then);

  final CoordinateQuery _self;
  final $Res Function(CoordinateQuery) _then;

/// Create a copy of GeoQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? point = null,}) {
  return _then(CoordinateQuery(
null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as GeoPoint,
  ));
}

/// Create a copy of GeoQuery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get point {
  
  return $GeoPointCopyWith<$Res>(_self.point, (value) {
    return _then(_self.copyWith(point: value));
  });
}
}

/// @nodoc


class AddressQuery implements GeoQuery {
  const AddressQuery(this.text);
  

 final  String text;

/// Create a copy of GeoQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressQueryCopyWith<AddressQuery> get copyWith => _$AddressQueryCopyWithImpl<AddressQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressQuery&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'GeoQuery.address(text: $text)';
}


}

/// @nodoc
abstract mixin class $AddressQueryCopyWith<$Res> implements $GeoQueryCopyWith<$Res> {
  factory $AddressQueryCopyWith(AddressQuery value, $Res Function(AddressQuery) _then) = _$AddressQueryCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$AddressQueryCopyWithImpl<$Res>
    implements $AddressQueryCopyWith<$Res> {
  _$AddressQueryCopyWithImpl(this._self, this._then);

  final AddressQuery _self;
  final $Res Function(AddressQuery) _then;

/// Create a copy of GeoQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(AddressQuery(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
