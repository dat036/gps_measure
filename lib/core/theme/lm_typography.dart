import 'package:flutter/painting.dart';

/// Typography tokens from `design.md` §1.2. Styles carry no color — apply
/// one from `LmColors` at the call site (or rely on the theme's TextTheme).
abstract final class LmTypography {
  static const String fontFamily = 'Inter';

  /// Numbers that change in place (results, timers) must not jitter.
  static const List<FontFeature> tabular = [FontFeature.tabularFigures()];

  static TextStyle _style(
    double size,
    double lineHeight,
    FontWeight weight, {
    double letterSpacing = 0,
    List<FontFeature>? features,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      height: lineHeight / size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      fontFeatures: features,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// Main number in the result sheet ("12,450 m²").
  static final TextStyle displayResult = _style(
    32,
    38,
    FontWeight.w700,
    features: tabular,
  );

  /// Result number when the sheet shows 3 columns.
  static final TextStyle displayResultCompact = _style(
    26,
    32,
    FontWeight.w700,
    features: tabular,
  );

  /// "Start Measuring" on the Home hero card.
  static final TextStyle displayHero = _style(26, 32, FontWeight.w700);

  static final TextStyle titleScreen = _style(20, 28, FontWeight.w700);
  static final TextStyle titleSection = _style(16, 22, FontWeight.w600);

  /// Item names, CTA labels.
  static final TextStyle bodyLg = _style(16, 24, FontWeight.w500);
  static final TextStyle bodyMd = _style(14, 20, FontWeight.w400);

  /// Secondary result ("1.25 ha") — use `textSecondary`.
  static final TextStyle resultSecondary = _style(
    16,
    22,
    FontWeight.w400,
    features: tabular,
  );

  /// "AREA", "PERIMETER", type chips.
  static final TextStyle labelCaps = _style(
    12,
    16,
    FontWeight.w600,
    letterSpacing: 0.6,
  );

  static final TextStyle caption = _style(12, 16, FontWeight.w400);

  /// Walk duration ("00:12:36").
  static final TextStyle timer = _style(
    28,
    34,
    FontWeight.w700,
    features: tabular,
  );
}
