// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditState {

/// As loaded; never changed by editing.
 Measurement get original; String get name; String get notes;/// Photos added during this edit (already stored; deleted on discard).
 Set<String> get addedPhotoIds;/// Photos the user removed (still stored; deleted on Save Changes).
 Map<String, Photo> get removedPhotos; bool get saving;
/// Create a copy of EditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditStateCopyWith<EditState> get copyWith => _$EditStateCopyWithImpl<EditState>(this as EditState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditState&&(identical(other.original, original) || other.original == original)&&(identical(other.name, name) || other.name == name)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.addedPhotoIds, addedPhotoIds)&&const DeepCollectionEquality().equals(other.removedPhotos, removedPhotos)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode => Object.hash(runtimeType,original,name,notes,const DeepCollectionEquality().hash(addedPhotoIds),const DeepCollectionEquality().hash(removedPhotos),saving);

@override
String toString() {
  return 'EditState(original: $original, name: $name, notes: $notes, addedPhotoIds: $addedPhotoIds, removedPhotos: $removedPhotos, saving: $saving)';
}


}

/// @nodoc
abstract mixin class $EditStateCopyWith<$Res>  {
  factory $EditStateCopyWith(EditState value, $Res Function(EditState) _then) = _$EditStateCopyWithImpl;
@useResult
$Res call({
 Measurement original, String name, String notes, Set<String> addedPhotoIds, Map<String, Photo> removedPhotos, bool saving
});


$MeasurementCopyWith<$Res> get original;

}
/// @nodoc
class _$EditStateCopyWithImpl<$Res>
    implements $EditStateCopyWith<$Res> {
  _$EditStateCopyWithImpl(this._self, this._then);

  final EditState _self;
  final $Res Function(EditState) _then;

/// Create a copy of EditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? original = null,Object? name = null,Object? notes = null,Object? addedPhotoIds = null,Object? removedPhotos = null,Object? saving = null,}) {
  return _then(_self.copyWith(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as Measurement,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,addedPhotoIds: null == addedPhotoIds ? _self.addedPhotoIds : addedPhotoIds // ignore: cast_nullable_to_non_nullable
as Set<String>,removedPhotos: null == removedPhotos ? _self.removedPhotos : removedPhotos // ignore: cast_nullable_to_non_nullable
as Map<String, Photo>,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of EditState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeasurementCopyWith<$Res> get original {
  
  return $MeasurementCopyWith<$Res>(_self.original, (value) {
    return _then(_self.copyWith(original: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditState].
extension EditStatePatterns on EditState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditState value)  $default,){
final _that = this;
switch (_that) {
case _EditState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditState value)?  $default,){
final _that = this;
switch (_that) {
case _EditState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Measurement original,  String name,  String notes,  Set<String> addedPhotoIds,  Map<String, Photo> removedPhotos,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditState() when $default != null:
return $default(_that.original,_that.name,_that.notes,_that.addedPhotoIds,_that.removedPhotos,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Measurement original,  String name,  String notes,  Set<String> addedPhotoIds,  Map<String, Photo> removedPhotos,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _EditState():
return $default(_that.original,_that.name,_that.notes,_that.addedPhotoIds,_that.removedPhotos,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Measurement original,  String name,  String notes,  Set<String> addedPhotoIds,  Map<String, Photo> removedPhotos,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _EditState() when $default != null:
return $default(_that.original,_that.name,_that.notes,_that.addedPhotoIds,_that.removedPhotos,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _EditState extends EditState {
  const _EditState({required this.original, required this.name, required this.notes, final  Set<String> addedPhotoIds = const <String>{}, final  Map<String, Photo> removedPhotos = const <String, Photo>{}, this.saving = false}): _addedPhotoIds = addedPhotoIds,_removedPhotos = removedPhotos,super._();
  

/// As loaded; never changed by editing.
@override final  Measurement original;
@override final  String name;
@override final  String notes;
/// Photos added during this edit (already stored; deleted on discard).
 final  Set<String> _addedPhotoIds;
/// Photos added during this edit (already stored; deleted on discard).
@override@JsonKey() Set<String> get addedPhotoIds {
  if (_addedPhotoIds is EqualUnmodifiableSetView) return _addedPhotoIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_addedPhotoIds);
}

/// Photos the user removed (still stored; deleted on Save Changes).
 final  Map<String, Photo> _removedPhotos;
/// Photos the user removed (still stored; deleted on Save Changes).
@override@JsonKey() Map<String, Photo> get removedPhotos {
  if (_removedPhotos is EqualUnmodifiableMapView) return _removedPhotos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_removedPhotos);
}

@override@JsonKey() final  bool saving;

/// Create a copy of EditState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditStateCopyWith<_EditState> get copyWith => __$EditStateCopyWithImpl<_EditState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditState&&(identical(other.original, original) || other.original == original)&&(identical(other.name, name) || other.name == name)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._addedPhotoIds, _addedPhotoIds)&&const DeepCollectionEquality().equals(other._removedPhotos, _removedPhotos)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode => Object.hash(runtimeType,original,name,notes,const DeepCollectionEquality().hash(_addedPhotoIds),const DeepCollectionEquality().hash(_removedPhotos),saving);

@override
String toString() {
  return 'EditState(original: $original, name: $name, notes: $notes, addedPhotoIds: $addedPhotoIds, removedPhotos: $removedPhotos, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$EditStateCopyWith<$Res> implements $EditStateCopyWith<$Res> {
  factory _$EditStateCopyWith(_EditState value, $Res Function(_EditState) _then) = __$EditStateCopyWithImpl;
@override @useResult
$Res call({
 Measurement original, String name, String notes, Set<String> addedPhotoIds, Map<String, Photo> removedPhotos, bool saving
});


@override $MeasurementCopyWith<$Res> get original;

}
/// @nodoc
class __$EditStateCopyWithImpl<$Res>
    implements _$EditStateCopyWith<$Res> {
  __$EditStateCopyWithImpl(this._self, this._then);

  final _EditState _self;
  final $Res Function(_EditState) _then;

/// Create a copy of EditState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? original = null,Object? name = null,Object? notes = null,Object? addedPhotoIds = null,Object? removedPhotos = null,Object? saving = null,}) {
  return _then(_EditState(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as Measurement,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,addedPhotoIds: null == addedPhotoIds ? _self._addedPhotoIds : addedPhotoIds // ignore: cast_nullable_to_non_nullable
as Set<String>,removedPhotos: null == removedPhotos ? _self._removedPhotos : removedPhotos // ignore: cast_nullable_to_non_nullable
as Map<String, Photo>,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of EditState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeasurementCopyWith<$Res> get original {
  
  return $MeasurementCopyWith<$Res>(_self.original, (value) {
    return _then(_self.copyWith(original: value));
  });
}
}

// dart format on
