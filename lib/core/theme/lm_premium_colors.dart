import 'package:flutter/painting.dart';

/// Paywall palette: always dark with a gold accent, in both light and dark
/// app themes (the Premium look; `design.md` §5.15). Only the paywall uses
/// it.
abstract final class LmPremiumColors {
  static const Color background = Color(0xFF080D18);
  static const Color backgroundGlow = Color(0xFF1A2236);
  static const Color card = Color(0xFF131A29);
  static const Color selectedCard = Color(0xFF30291C);
  static const Color cardBorder = Color(0xFF2A3447);

  static const Color gold = Color(0xFFFFC02E);
  static const Color goldSoft = Color(0x29FFC02E); // gold @ 16%
  static const Color goldBorder = Color(0x66FFC02E); // gold @ 40%
  static const Color onGold = Color(0xFF1B1300);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB4BDCD);
  static const Color textTertiary = Color(0xFF8993A6);
  static const Color radioOff = Color(0xFF7C8699);
}
