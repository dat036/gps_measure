// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_search_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaceSearchState {

 PlaceSearchStatus get status; List<PlaceResult> get results; List<String> get recent;
/// Create a copy of PlaceSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceSearchStateCopyWith<PlaceSearchState> get copyWith => _$PlaceSearchStateCopyWithImpl<PlaceSearchState>(this as PlaceSearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceSearchState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.results, results)&&const DeepCollectionEquality().equals(other.recent, recent));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(results),const DeepCollectionEquality().hash(recent));

@override
String toString() {
  return 'PlaceSearchState(status: $status, results: $results, recent: $recent)';
}


}

/// @nodoc
abstract mixin class $PlaceSearchStateCopyWith<$Res>  {
  factory $PlaceSearchStateCopyWith(PlaceSearchState value, $Res Function(PlaceSearchState) _then) = _$PlaceSearchStateCopyWithImpl;
@useResult
$Res call({
 PlaceSearchStatus status, List<PlaceResult> results, List<String> recent
});




}
/// @nodoc
class _$PlaceSearchStateCopyWithImpl<$Res>
    implements $PlaceSearchStateCopyWith<$Res> {
  _$PlaceSearchStateCopyWithImpl(this._self, this._then);

  final PlaceSearchState _self;
  final $Res Function(PlaceSearchState) _then;

/// Create a copy of PlaceSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? results = null,Object? recent = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlaceSearchStatus,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<PlaceResult>,recent: null == recent ? _self.recent : recent // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaceSearchState].
extension PlaceSearchStatePatterns on PlaceSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaceSearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaceSearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaceSearchState value)  $default,){
final _that = this;
switch (_that) {
case _PlaceSearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaceSearchState value)?  $default,){
final _that = this;
switch (_that) {
case _PlaceSearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlaceSearchStatus status,  List<PlaceResult> results,  List<String> recent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaceSearchState() when $default != null:
return $default(_that.status,_that.results,_that.recent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlaceSearchStatus status,  List<PlaceResult> results,  List<String> recent)  $default,) {final _that = this;
switch (_that) {
case _PlaceSearchState():
return $default(_that.status,_that.results,_that.recent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlaceSearchStatus status,  List<PlaceResult> results,  List<String> recent)?  $default,) {final _that = this;
switch (_that) {
case _PlaceSearchState() when $default != null:
return $default(_that.status,_that.results,_that.recent);case _:
  return null;

}
}

}

/// @nodoc


class _PlaceSearchState implements PlaceSearchState {
  const _PlaceSearchState({this.status = PlaceSearchStatus.idle, final  List<PlaceResult> results = const <PlaceResult>[], final  List<String> recent = const <String>[]}): _results = results,_recent = recent;
  

@override@JsonKey() final  PlaceSearchStatus status;
 final  List<PlaceResult> _results;
@override@JsonKey() List<PlaceResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

 final  List<String> _recent;
@override@JsonKey() List<String> get recent {
  if (_recent is EqualUnmodifiableListView) return _recent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recent);
}


/// Create a copy of PlaceSearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceSearchStateCopyWith<_PlaceSearchState> get copyWith => __$PlaceSearchStateCopyWithImpl<_PlaceSearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaceSearchState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._results, _results)&&const DeepCollectionEquality().equals(other._recent, _recent));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_results),const DeepCollectionEquality().hash(_recent));

@override
String toString() {
  return 'PlaceSearchState(status: $status, results: $results, recent: $recent)';
}


}

/// @nodoc
abstract mixin class _$PlaceSearchStateCopyWith<$Res> implements $PlaceSearchStateCopyWith<$Res> {
  factory _$PlaceSearchStateCopyWith(_PlaceSearchState value, $Res Function(_PlaceSearchState) _then) = __$PlaceSearchStateCopyWithImpl;
@override @useResult
$Res call({
 PlaceSearchStatus status, List<PlaceResult> results, List<String> recent
});




}
/// @nodoc
class __$PlaceSearchStateCopyWithImpl<$Res>
    implements _$PlaceSearchStateCopyWith<$Res> {
  __$PlaceSearchStateCopyWithImpl(this._self, this._then);

  final _PlaceSearchState _self;
  final $Res Function(_PlaceSearchState) _then;

/// Create a copy of PlaceSearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? results = null,Object? recent = null,}) {
  return _then(_PlaceSearchState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlaceSearchStatus,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<PlaceResult>,recent: null == recent ? _self._recent : recent // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
