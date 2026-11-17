// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettings {

 DistanceUnit get distanceUnit; AreaUnit get areaUnit; bool get showSecondaryUnit; MapStyle get mapStyle;/// Language code override; null = follow the system.
 String? get localeCode; MeasurementType get defaultMode; bool get showGpsAccuracy; bool get autoCenter; bool get savePhotosToMeasurement; bool get keepScreenAwake; InputMode get inputMode; bool get showEdgeLabels;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.distanceUnit, distanceUnit) || other.distanceUnit == distanceUnit)&&(identical(other.areaUnit, areaUnit) || other.areaUnit == areaUnit)&&(identical(other.showSecondaryUnit, showSecondaryUnit) || other.showSecondaryUnit == showSecondaryUnit)&&(identical(other.mapStyle, mapStyle) || other.mapStyle == mapStyle)&&(identical(other.localeCode, localeCode) || other.localeCode == localeCode)&&(identical(other.defaultMode, defaultMode) || other.defaultMode == defaultMode)&&(identical(other.showGpsAccuracy, showGpsAccuracy) || other.showGpsAccuracy == showGpsAccuracy)&&(identical(other.autoCenter, autoCenter) || other.autoCenter == autoCenter)&&(identical(other.savePhotosToMeasurement, savePhotosToMeasurement) || other.savePhotosToMeasurement == savePhotosToMeasurement)&&(identical(other.keepScreenAwake, keepScreenAwake) || other.keepScreenAwake == keepScreenAwake)&&(identical(other.inputMode, inputMode) || other.inputMode == inputMode)&&(identical(other.showEdgeLabels, showEdgeLabels) || other.showEdgeLabels == showEdgeLabels));
}


@override
int get hashCode => Object.hash(runtimeType,distanceUnit,areaUnit,showSecondaryUnit,mapStyle,localeCode,defaultMode,showGpsAccuracy,autoCenter,savePhotosToMeasurement,keepScreenAwake,inputMode,showEdgeLabels);

@override
String toString() {
  return 'AppSettings(distanceUnit: $distanceUnit, areaUnit: $areaUnit, showSecondaryUnit: $showSecondaryUnit, mapStyle: $mapStyle, localeCode: $localeCode, defaultMode: $defaultMode, showGpsAccuracy: $showGpsAccuracy, autoCenter: $autoCenter, savePhotosToMeasurement: $savePhotosToMeasurement, keepScreenAwake: $keepScreenAwake, inputMode: $inputMode, showEdgeLabels: $showEdgeLabels)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 DistanceUnit distanceUnit, AreaUnit areaUnit, bool showSecondaryUnit, MapStyle mapStyle, String? localeCode, MeasurementType defaultMode, bool showGpsAccuracy, bool autoCenter, bool savePhotosToMeasurement, bool keepScreenAwake, InputMode inputMode, bool showEdgeLabels
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? distanceUnit = null,Object? areaUnit = null,Object? showSecondaryUnit = null,Object? mapStyle = null,Object? localeCode = freezed,Object? defaultMode = null,Object? showGpsAccuracy = null,Object? autoCenter = null,Object? savePhotosToMeasurement = null,Object? keepScreenAwake = null,Object? inputMode = null,Object? showEdgeLabels = null,}) {
  return _then(_self.copyWith(
distanceUnit: null == distanceUnit ? _self.distanceUnit : distanceUnit // ignore: cast_nullable_to_non_nullable
as DistanceUnit,areaUnit: null == areaUnit ? _self.areaUnit : areaUnit // ignore: cast_nullable_to_non_nullable
as AreaUnit,showSecondaryUnit: null == showSecondaryUnit ? _self.showSecondaryUnit : showSecondaryUnit // ignore: cast_nullable_to_non_nullable
as bool,mapStyle: null == mapStyle ? _self.mapStyle : mapStyle // ignore: cast_nullable_to_non_nullable
as MapStyle,localeCode: freezed == localeCode ? _self.localeCode : localeCode // ignore: cast_nullable_to_non_nullable
as String?,defaultMode: null == defaultMode ? _self.defaultMode : defaultMode // ignore: cast_nullable_to_non_nullable
as MeasurementType,showGpsAccuracy: null == showGpsAccuracy ? _self.showGpsAccuracy : showGpsAccuracy // ignore: cast_nullable_to_non_nullable
as bool,autoCenter: null == autoCenter ? _self.autoCenter : autoCenter // ignore: cast_nullable_to_non_nullable
as bool,savePhotosToMeasurement: null == savePhotosToMeasurement ? _self.savePhotosToMeasurement : savePhotosToMeasurement // ignore: cast_nullable_to_non_nullable
as bool,keepScreenAwake: null == keepScreenAwake ? _self.keepScreenAwake : keepScreenAwake // ignore: cast_nullable_to_non_nullable
as bool,inputMode: null == inputMode ? _self.inputMode : inputMode // ignore: cast_nullable_to_non_nullable
as InputMode,showEdgeLabels: null == showEdgeLabels ? _self.showEdgeLabels : showEdgeLabels // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DistanceUnit distanceUnit,  AreaUnit areaUnit,  bool showSecondaryUnit,  MapStyle mapStyle,  String? localeCode,  MeasurementType defaultMode,  bool showGpsAccuracy,  bool autoCenter,  bool savePhotosToMeasurement,  bool keepScreenAwake,  InputMode inputMode,  bool showEdgeLabels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.distanceUnit,_that.areaUnit,_that.showSecondaryUnit,_that.mapStyle,_that.localeCode,_that.defaultMode,_that.showGpsAccuracy,_that.autoCenter,_that.savePhotosToMeasurement,_that.keepScreenAwake,_that.inputMode,_that.showEdgeLabels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DistanceUnit distanceUnit,  AreaUnit areaUnit,  bool showSecondaryUnit,  MapStyle mapStyle,  String? localeCode,  MeasurementType defaultMode,  bool showGpsAccuracy,  bool autoCenter,  bool savePhotosToMeasurement,  bool keepScreenAwake,  InputMode inputMode,  bool showEdgeLabels)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.distanceUnit,_that.areaUnit,_that.showSecondaryUnit,_that.mapStyle,_that.localeCode,_that.defaultMode,_that.showGpsAccuracy,_that.autoCenter,_that.savePhotosToMeasurement,_that.keepScreenAwake,_that.inputMode,_that.showEdgeLabels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DistanceUnit distanceUnit,  AreaUnit areaUnit,  bool showSecondaryUnit,  MapStyle mapStyle,  String? localeCode,  MeasurementType defaultMode,  bool showGpsAccuracy,  bool autoCenter,  bool savePhotosToMeasurement,  bool keepScreenAwake,  InputMode inputMode,  bool showEdgeLabels)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.distanceUnit,_that.areaUnit,_that.showSecondaryUnit,_that.mapStyle,_that.localeCode,_that.defaultMode,_that.showGpsAccuracy,_that.autoCenter,_that.savePhotosToMeasurement,_that.keepScreenAwake,_that.inputMode,_that.showEdgeLabels);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettings implements AppSettings {
  const _AppSettings({required this.distanceUnit, required this.areaUnit, this.showSecondaryUnit = true, this.mapStyle = MapStyle.standard, this.localeCode, this.defaultMode = MeasurementType.area, this.showGpsAccuracy = true, this.autoCenter = true, this.savePhotosToMeasurement = true, this.keepScreenAwake = true, this.inputMode = InputMode.crosshair, this.showEdgeLabels = true});
  

@override final  DistanceUnit distanceUnit;
@override final  AreaUnit areaUnit;
@override@JsonKey() final  bool showSecondaryUnit;
@override@JsonKey() final  MapStyle mapStyle;
/// Language code override; null = follow the system.
@override final  String? localeCode;
@override@JsonKey() final  MeasurementType defaultMode;
@override@JsonKey() final  bool showGpsAccuracy;
@override@JsonKey() final  bool autoCenter;
@override@JsonKey() final  bool savePhotosToMeasurement;
@override@JsonKey() final  bool keepScreenAwake;
@override@JsonKey() final  InputMode inputMode;
@override@JsonKey() final  bool showEdgeLabels;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.distanceUnit, distanceUnit) || other.distanceUnit == distanceUnit)&&(identical(other.areaUnit, areaUnit) || other.areaUnit == areaUnit)&&(identical(other.showSecondaryUnit, showSecondaryUnit) || other.showSecondaryUnit == showSecondaryUnit)&&(identical(other.mapStyle, mapStyle) || other.mapStyle == mapStyle)&&(identical(other.localeCode, localeCode) || other.localeCode == localeCode)&&(identical(other.defaultMode, defaultMode) || other.defaultMode == defaultMode)&&(identical(other.showGpsAccuracy, showGpsAccuracy) || other.showGpsAccuracy == showGpsAccuracy)&&(identical(other.autoCenter, autoCenter) || other.autoCenter == autoCenter)&&(identical(other.savePhotosToMeasurement, savePhotosToMeasurement) || other.savePhotosToMeasurement == savePhotosToMeasurement)&&(identical(other.keepScreenAwake, keepScreenAwake) || other.keepScreenAwake == keepScreenAwake)&&(identical(other.inputMode, inputMode) || other.inputMode == inputMode)&&(identical(other.showEdgeLabels, showEdgeLabels) || other.showEdgeLabels == showEdgeLabels));
}


@override
int get hashCode => Object.hash(runtimeType,distanceUnit,areaUnit,showSecondaryUnit,mapStyle,localeCode,defaultMode,showGpsAccuracy,autoCenter,savePhotosToMeasurement,keepScreenAwake,inputMode,showEdgeLabels);

@override
String toString() {
  return 'AppSettings(distanceUnit: $distanceUnit, areaUnit: $areaUnit, showSecondaryUnit: $showSecondaryUnit, mapStyle: $mapStyle, localeCode: $localeCode, defaultMode: $defaultMode, showGpsAccuracy: $showGpsAccuracy, autoCenter: $autoCenter, savePhotosToMeasurement: $savePhotosToMeasurement, keepScreenAwake: $keepScreenAwake, inputMode: $inputMode, showEdgeLabels: $showEdgeLabels)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 DistanceUnit distanceUnit, AreaUnit areaUnit, bool showSecondaryUnit, MapStyle mapStyle, String? localeCode, MeasurementType defaultMode, bool showGpsAccuracy, bool autoCenter, bool savePhotosToMeasurement, bool keepScreenAwake, InputMode inputMode, bool showEdgeLabels
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? distanceUnit = null,Object? areaUnit = null,Object? showSecondaryUnit = null,Object? mapStyle = null,Object? localeCode = freezed,Object? defaultMode = null,Object? showGpsAccuracy = null,Object? autoCenter = null,Object? savePhotosToMeasurement = null,Object? keepScreenAwake = null,Object? inputMode = null,Object? showEdgeLabels = null,}) {
  return _then(_AppSettings(
distanceUnit: null == distanceUnit ? _self.distanceUnit : distanceUnit // ignore: cast_nullable_to_non_nullable
as DistanceUnit,areaUnit: null == areaUnit ? _self.areaUnit : areaUnit // ignore: cast_nullable_to_non_nullable
as AreaUnit,showSecondaryUnit: null == showSecondaryUnit ? _self.showSecondaryUnit : showSecondaryUnit // ignore: cast_nullable_to_non_nullable
as bool,mapStyle: null == mapStyle ? _self.mapStyle : mapStyle // ignore: cast_nullable_to_non_nullable
as MapStyle,localeCode: freezed == localeCode ? _self.localeCode : localeCode // ignore: cast_nullable_to_non_nullable
as String?,defaultMode: null == defaultMode ? _self.defaultMode : defaultMode // ignore: cast_nullable_to_non_nullable
as MeasurementType,showGpsAccuracy: null == showGpsAccuracy ? _self.showGpsAccuracy : showGpsAccuracy // ignore: cast_nullable_to_non_nullable
as bool,autoCenter: null == autoCenter ? _self.autoCenter : autoCenter // ignore: cast_nullable_to_non_nullable
as bool,savePhotosToMeasurement: null == savePhotosToMeasurement ? _self.savePhotosToMeasurement : savePhotosToMeasurement // ignore: cast_nullable_to_non_nullable
as bool,keepScreenAwake: null == keepScreenAwake ? _self.keepScreenAwake : keepScreenAwake // ignore: cast_nullable_to_non_nullable
as bool,inputMode: null == inputMode ? _self.inputMode : inputMode // ignore: cast_nullable_to_non_nullable
as InputMode,showEdgeLabels: null == showEdgeLabels ? _self.showEdgeLabels : showEdgeLabels // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
