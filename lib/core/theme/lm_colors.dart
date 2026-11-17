import 'package:flutter/material.dart';

/// Color tokens from `design.md` §1.1. Widgets read colors only from here
/// (via `LmColors.of(context)`), never hard-coded hex values.
@immutable
class LmColors extends ThemeExtension<LmColors> {
  const LmColors({
    required this.brandPrimary,
    required this.areaMain,
    required this.areaContainer,
    required this.distanceMain,
    required this.distanceContainer,
    required this.walkMain,
    required this.walkContainer,
    required this.dangerMain,
    required this.dangerContainer,
    required this.warning,
    required this.onMode,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.surfacePage,
    required this.surfaceCard,
    required this.surfaceSheet,
    required this.divider,
    required this.outlineDashed,
    required this.mapPill,
    required this.scrim,
    required this.disabledBackground,
    required this.disabledForeground,
    required this.heroBase,
    required this.heroFieldA,
    required this.heroFieldB,
    required this.heroRoad,
    required this.mapLand,
    required this.mapPark,
    required this.mapWater,
    required this.mapRoad,
    required this.mapRoadMajor,
    required this.mapTerrain,
    required this.mapContour,
  });

  static const light = LmColors(
    brandPrimary: Color(0xFF0F8A5F),
    areaMain: Color(0xFF12A150),
    areaContainer: Color(0xFFE3F6EA),
    distanceMain: Color(0xFF1E6BFF),
    distanceContainer: Color(0xFFE4EDFF),
    walkMain: Color(0xFFF58A07),
    walkContainer: Color(0xFFFFF1DF),
    dangerMain: Color(0xFFE5383B),
    dangerContainer: Color(0xFFFDE8E8),
    warning: Color(0xFFF2A900),
    onMode: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0E1A2B),
    textSecondary: Color(0xFF5B6577),
    textTertiary: Color(0xFF8A93A3),
    surfacePage: Color(0xFFF4F7FA),
    surfaceCard: Color(0xFFFFFFFF),
    surfaceSheet: Color(0xFFFFFFFF),
    divider: Color(0xFFE6EAF0),
    outlineDashed: Color(0xFFC9D1DC),
    mapPill: Color(0xC70E1A2B), // #0E1A2B @ 78%
    scrim: Color(0x66000000), // #000000 @ 40%
    disabledBackground: Color(0xFFD5DBE3),
    disabledForeground: Color(0xFF8A93A3),
    heroBase: Color(0xFF2C4431),
    heroFieldA: Color(0xFF3B5A3A),
    heroFieldB: Color(0xFF566B3E),
    heroRoad: Color(0xFFB9A98A),
    mapLand: Color(0xFFEEF0F2),
    mapPark: Color(0xFFCDE8C8),
    mapWater: Color(0xFFAAD3F5),
    mapRoad: Color(0xFFFFFFFF),
    mapRoadMajor: Color(0xFFFFD98A),
    mapTerrain: Color(0xFFE9E3D0),
    mapContour: Color(0xFFC9BC98),
  );

  /// Dark palette. design.md only fixes surfaces/text/divider; mode
  /// containers are darker tints of the mode color so chips stay legible.
  static const dark = LmColors(
    brandPrimary: Color(0xFF2FB27E),
    areaMain: Color(0xFF12A150),
    areaContainer: Color(0xFF123A26),
    distanceMain: Color(0xFF1E6BFF),
    distanceContainer: Color(0xFF152A52),
    walkMain: Color(0xFFF58A07),
    walkContainer: Color(0xFF3D2A10),
    dangerMain: Color(0xFFE5383B),
    dangerContainer: Color(0xFF4A1D1F),
    warning: Color(0xFFF2A900),
    onMode: Color(0xFFFFFFFF),
    textPrimary: Color(0xFFEEF2F7),
    textSecondary: Color(0xFFA7B0BF),
    textTertiary: Color(0xFF7C8699),
    surfacePage: Color(0xFF0B1220),
    surfaceCard: Color(0xFF151E2E),
    surfaceSheet: Color(0xFF151E2E),
    divider: Color(0xFF243044),
    outlineDashed: Color(0xFF3A4760),
    mapPill: Color(0xC70E1A2B),
    scrim: Color(0x99000000),
    disabledBackground: Color(0xFF2A3447),
    disabledForeground: Color(0xFF6F7A8C),
    heroBase: Color(0xFF2C4431),
    heroFieldA: Color(0xFF3B5A3A),
    heroFieldB: Color(0xFF566B3E),
    heroRoad: Color(0xFFB9A98A),
    mapLand: Color(0xFF1D2533),
    mapPark: Color(0xFF1F3A2B),
    mapWater: Color(0xFF17314F),
    mapRoad: Color(0xFF3A4658),
    mapRoadMajor: Color(0xFF5B5236),
    mapTerrain: Color(0xFFE9E3D0),
    mapContour: Color(0xFFC9BC98),
  );

  static LmColors of(BuildContext context) =>
      Theme.of(context).extension<LmColors>() ?? light;

  final Color brandPrimary;
  final Color areaMain;
  final Color areaContainer;
  final Color distanceMain;
  final Color distanceContainer;
  final Color walkMain;
  final Color walkContainer;
  final Color dangerMain;
  final Color dangerContainer;
  final Color warning;

  /// Text/icon color on top of a filled mode or danger color.
  final Color onMode;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color surfacePage;
  final Color surfaceCard;
  final Color surfaceSheet;
  final Color divider;
  final Color outlineDashed;
  final Color mapPill;
  final Color scrim;
  final Color disabledBackground;
  final Color disabledForeground;

  /// Home hero illustration (stands in for the satellite photos until
  /// licensed images exist): ground, two field tones, a dirt road.
  final Color heroBase;
  final Color heroFieldA;
  final Color heroFieldB;
  final Color heroRoad;

  /// Painted previews in Settings → Map Style (until real screenshots).
  final Color mapLand;
  final Color mapPark;
  final Color mapWater;
  final Color mapRoad;
  final Color mapRoadMajor;
  final Color mapTerrain;
  final Color mapContour;

  @override
  LmColors copyWith({
    Color? brandPrimary,
    Color? areaMain,
    Color? areaContainer,
    Color? distanceMain,
    Color? distanceContainer,
    Color? walkMain,
    Color? walkContainer,
    Color? dangerMain,
    Color? dangerContainer,
    Color? warning,
    Color? onMode,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? surfacePage,
    Color? surfaceCard,
    Color? surfaceSheet,
    Color? divider,
    Color? outlineDashed,
    Color? mapPill,
    Color? scrim,
    Color? disabledBackground,
    Color? disabledForeground,
    Color? heroBase,
    Color? heroFieldA,
    Color? heroFieldB,
    Color? heroRoad,
    Color? mapLand,
    Color? mapPark,
    Color? mapWater,
    Color? mapRoad,
    Color? mapRoadMajor,
    Color? mapTerrain,
    Color? mapContour,
  }) {
    return LmColors(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      areaMain: areaMain ?? this.areaMain,
      areaContainer: areaContainer ?? this.areaContainer,
      distanceMain: distanceMain ?? this.distanceMain,
      distanceContainer: distanceContainer ?? this.distanceContainer,
      walkMain: walkMain ?? this.walkMain,
      walkContainer: walkContainer ?? this.walkContainer,
      dangerMain: dangerMain ?? this.dangerMain,
      dangerContainer: dangerContainer ?? this.dangerContainer,
      warning: warning ?? this.warning,
      onMode: onMode ?? this.onMode,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      surfacePage: surfacePage ?? this.surfacePage,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceSheet: surfaceSheet ?? this.surfaceSheet,
      divider: divider ?? this.divider,
      outlineDashed: outlineDashed ?? this.outlineDashed,
      mapPill: mapPill ?? this.mapPill,
      scrim: scrim ?? this.scrim,
      disabledBackground: disabledBackground ?? this.disabledBackground,
      disabledForeground: disabledForeground ?? this.disabledForeground,
      heroBase: heroBase ?? this.heroBase,
      heroFieldA: heroFieldA ?? this.heroFieldA,
      heroFieldB: heroFieldB ?? this.heroFieldB,
      heroRoad: heroRoad ?? this.heroRoad,
      mapLand: mapLand ?? this.mapLand,
      mapPark: mapPark ?? this.mapPark,
      mapWater: mapWater ?? this.mapWater,
      mapRoad: mapRoad ?? this.mapRoad,
      mapRoadMajor: mapRoadMajor ?? this.mapRoadMajor,
      mapTerrain: mapTerrain ?? this.mapTerrain,
      mapContour: mapContour ?? this.mapContour,
    );
  }

  @override
  LmColors lerp(ThemeExtension<LmColors>? other, double t) {
    if (other is! LmColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return LmColors(
      brandPrimary: l(brandPrimary, other.brandPrimary),
      areaMain: l(areaMain, other.areaMain),
      areaContainer: l(areaContainer, other.areaContainer),
      distanceMain: l(distanceMain, other.distanceMain),
      distanceContainer: l(distanceContainer, other.distanceContainer),
      walkMain: l(walkMain, other.walkMain),
      walkContainer: l(walkContainer, other.walkContainer),
      dangerMain: l(dangerMain, other.dangerMain),
      dangerContainer: l(dangerContainer, other.dangerContainer),
      warning: l(warning, other.warning),
      onMode: l(onMode, other.onMode),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textTertiary: l(textTertiary, other.textTertiary),
      surfacePage: l(surfacePage, other.surfacePage),
      surfaceCard: l(surfaceCard, other.surfaceCard),
      surfaceSheet: l(surfaceSheet, other.surfaceSheet),
      divider: l(divider, other.divider),
      outlineDashed: l(outlineDashed, other.outlineDashed),
      mapPill: l(mapPill, other.mapPill),
      scrim: l(scrim, other.scrim),
      disabledBackground: l(disabledBackground, other.disabledBackground),
      disabledForeground: l(disabledForeground, other.disabledForeground),
      heroBase: l(heroBase, other.heroBase),
      heroFieldA: l(heroFieldA, other.heroFieldA),
      heroFieldB: l(heroFieldB, other.heroFieldB),
      heroRoad: l(heroRoad, other.heroRoad),
      mapLand: l(mapLand, other.mapLand),
      mapPark: l(mapPark, other.mapPark),
      mapWater: l(mapWater, other.mapWater),
      mapRoad: l(mapRoad, other.mapRoad),
      mapRoadMajor: l(mapRoadMajor, other.mapRoadMajor),
      mapTerrain: l(mapTerrain, other.mapTerrain),
      mapContour: l(mapContour, other.mapContour),
    );
  }
}
