// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavedFilter {

/// Search field shown in place of the header.
 bool get searching;/// Applied (debounced) query.
 String get query;/// Type chip; null = All.
 MeasurementType? get type; bool get draftsExpanded;
/// Create a copy of SavedFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedFilterCopyWith<SavedFilter> get copyWith => _$SavedFilterCopyWithImpl<SavedFilter>(this as SavedFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedFilter&&(identical(other.searching, searching) || other.searching == searching)&&(identical(other.query, query) || other.query == query)&&(identical(other.type, type) || other.type == type)&&(identical(other.draftsExpanded, draftsExpanded) || other.draftsExpanded == draftsExpanded));
}


@override
int get hashCode => Object.hash(runtimeType,searching,query,type,draftsExpanded);

@override
String toString() {
  return 'SavedFilter(searching: $searching, query: $query, type: $type, draftsExpanded: $draftsExpanded)';
}


}

/// @nodoc
abstract mixin class $SavedFilterCopyWith<$Res>  {
  factory $SavedFilterCopyWith(SavedFilter value, $Res Function(SavedFilter) _then) = _$SavedFilterCopyWithImpl;
@useResult
$Res call({
 bool searching, String query, MeasurementType? type, bool draftsExpanded
});




}
/// @nodoc
class _$SavedFilterCopyWithImpl<$Res>
    implements $SavedFilterCopyWith<$Res> {
  _$SavedFilterCopyWithImpl(this._self, this._then);

  final SavedFilter _self;
  final $Res Function(SavedFilter) _then;

/// Create a copy of SavedFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? searching = null,Object? query = null,Object? type = freezed,Object? draftsExpanded = null,}) {
  return _then(_self.copyWith(
searching: null == searching ? _self.searching : searching // ignore: cast_nullable_to_non_nullable
as bool,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MeasurementType?,draftsExpanded: null == draftsExpanded ? _self.draftsExpanded : draftsExpanded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedFilter].
extension SavedFilterPatterns on SavedFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedFilter value)  $default,){
final _that = this;
switch (_that) {
case _SavedFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedFilter value)?  $default,){
final _that = this;
switch (_that) {
case _SavedFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool searching,  String query,  MeasurementType? type,  bool draftsExpanded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedFilter() when $default != null:
return $default(_that.searching,_that.query,_that.type,_that.draftsExpanded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool searching,  String query,  MeasurementType? type,  bool draftsExpanded)  $default,) {final _that = this;
switch (_that) {
case _SavedFilter():
return $default(_that.searching,_that.query,_that.type,_that.draftsExpanded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool searching,  String query,  MeasurementType? type,  bool draftsExpanded)?  $default,) {final _that = this;
switch (_that) {
case _SavedFilter() when $default != null:
return $default(_that.searching,_that.query,_that.type,_that.draftsExpanded);case _:
  return null;

}
}

}

/// @nodoc


class _SavedFilter implements SavedFilter {
  const _SavedFilter({this.searching = false, this.query = '', this.type, this.draftsExpanded = true});
  

/// Search field shown in place of the header.
@override@JsonKey() final  bool searching;
/// Applied (debounced) query.
@override@JsonKey() final  String query;
/// Type chip; null = All.
@override final  MeasurementType? type;
@override@JsonKey() final  bool draftsExpanded;

/// Create a copy of SavedFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedFilterCopyWith<_SavedFilter> get copyWith => __$SavedFilterCopyWithImpl<_SavedFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedFilter&&(identical(other.searching, searching) || other.searching == searching)&&(identical(other.query, query) || other.query == query)&&(identical(other.type, type) || other.type == type)&&(identical(other.draftsExpanded, draftsExpanded) || other.draftsExpanded == draftsExpanded));
}


@override
int get hashCode => Object.hash(runtimeType,searching,query,type,draftsExpanded);

@override
String toString() {
  return 'SavedFilter(searching: $searching, query: $query, type: $type, draftsExpanded: $draftsExpanded)';
}


}

/// @nodoc
abstract mixin class _$SavedFilterCopyWith<$Res> implements $SavedFilterCopyWith<$Res> {
  factory _$SavedFilterCopyWith(_SavedFilter value, $Res Function(_SavedFilter) _then) = __$SavedFilterCopyWithImpl;
@override @useResult
$Res call({
 bool searching, String query, MeasurementType? type, bool draftsExpanded
});




}
/// @nodoc
class __$SavedFilterCopyWithImpl<$Res>
    implements _$SavedFilterCopyWith<$Res> {
  __$SavedFilterCopyWithImpl(this._self, this._then);

  final _SavedFilter _self;
  final $Res Function(_SavedFilter) _then;

/// Create a copy of SavedFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searching = null,Object? query = null,Object? type = freezed,Object? draftsExpanded = null,}) {
  return _then(_SavedFilter(
searching: null == searching ? _self.searching : searching // ignore: cast_nullable_to_non_nullable
as bool,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MeasurementType?,draftsExpanded: null == draftsExpanded ? _self.draftsExpanded : draftsExpanded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
