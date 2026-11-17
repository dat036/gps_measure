// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SaveState {

 Measurement get measurement;/// Map snapshot taken by the measure screen, else a drawn preview.
 Uint8List? get preview; bool get saving;
/// Create a copy of SaveState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveStateCopyWith<SaveState> get copyWith => _$SaveStateCopyWithImpl<SaveState>(this as SaveState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveState&&(identical(other.measurement, measurement) || other.measurement == measurement)&&const DeepCollectionEquality().equals(other.preview, preview)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode => Object.hash(runtimeType,measurement,const DeepCollectionEquality().hash(preview),saving);

@override
String toString() {
  return 'SaveState(measurement: $measurement, preview: $preview, saving: $saving)';
}


}

/// @nodoc
abstract mixin class $SaveStateCopyWith<$Res>  {
  factory $SaveStateCopyWith(SaveState value, $Res Function(SaveState) _then) = _$SaveStateCopyWithImpl;
@useResult
$Res call({
 Measurement measurement, Uint8List? preview, bool saving
});


$MeasurementCopyWith<$Res> get measurement;

}
/// @nodoc
class _$SaveStateCopyWithImpl<$Res>
    implements $SaveStateCopyWith<$Res> {
  _$SaveStateCopyWithImpl(this._self, this._then);

  final SaveState _self;
  final $Res Function(SaveState) _then;

/// Create a copy of SaveState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? measurement = null,Object? preview = freezed,Object? saving = null,}) {
  return _then(_self.copyWith(
measurement: null == measurement ? _self.measurement : measurement // ignore: cast_nullable_to_non_nullable
as Measurement,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as Uint8List?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SaveState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeasurementCopyWith<$Res> get measurement {
  
  return $MeasurementCopyWith<$Res>(_self.measurement, (value) {
    return _then(_self.copyWith(measurement: value));
  });
}
}


/// Adds pattern-matching-related methods to [SaveState].
extension SaveStatePatterns on SaveState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaveState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaveState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaveState value)  $default,){
final _that = this;
switch (_that) {
case _SaveState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaveState value)?  $default,){
final _that = this;
switch (_that) {
case _SaveState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Measurement measurement,  Uint8List? preview,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaveState() when $default != null:
return $default(_that.measurement,_that.preview,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Measurement measurement,  Uint8List? preview,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _SaveState():
return $default(_that.measurement,_that.preview,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Measurement measurement,  Uint8List? preview,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _SaveState() when $default != null:
return $default(_that.measurement,_that.preview,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _SaveState implements SaveState {
  const _SaveState({required this.measurement, this.preview, this.saving = false});
  

@override final  Measurement measurement;
/// Map snapshot taken by the measure screen, else a drawn preview.
@override final  Uint8List? preview;
@override@JsonKey() final  bool saving;

/// Create a copy of SaveState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveStateCopyWith<_SaveState> get copyWith => __$SaveStateCopyWithImpl<_SaveState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveState&&(identical(other.measurement, measurement) || other.measurement == measurement)&&const DeepCollectionEquality().equals(other.preview, preview)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode => Object.hash(runtimeType,measurement,const DeepCollectionEquality().hash(preview),saving);

@override
String toString() {
  return 'SaveState(measurement: $measurement, preview: $preview, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$SaveStateCopyWith<$Res> implements $SaveStateCopyWith<$Res> {
  factory _$SaveStateCopyWith(_SaveState value, $Res Function(_SaveState) _then) = __$SaveStateCopyWithImpl;
@override @useResult
$Res call({
 Measurement measurement, Uint8List? preview, bool saving
});


@override $MeasurementCopyWith<$Res> get measurement;

}
/// @nodoc
class __$SaveStateCopyWithImpl<$Res>
    implements _$SaveStateCopyWith<$Res> {
  __$SaveStateCopyWithImpl(this._self, this._then);

  final _SaveState _self;
  final $Res Function(_SaveState) _then;

/// Create a copy of SaveState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? measurement = null,Object? preview = freezed,Object? saving = null,}) {
  return _then(_SaveState(
measurement: null == measurement ? _self.measurement : measurement // ignore: cast_nullable_to_non_nullable
as Measurement,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as Uint8List?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SaveState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeasurementCopyWith<$Res> get measurement {
  
  return $MeasurementCopyWith<$Res>(_self.measurement, (value) {
    return _then(_self.copyWith(measurement: value));
  });
}
}

// dart format on
