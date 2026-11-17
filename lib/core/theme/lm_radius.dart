import 'package:flutter/painting.dart';

/// Corner radii from `design.md` §1.3.
abstract final class LmRadius {
  /// Chips, small thumbnails.
  static const double xs = 8;

  /// Photo thumbnails, text fields.
  static const double sm = 12;

  /// Cards, list items, CTA.
  static const double md = 16;

  /// Bottom sheet top, hero card, dialogs.
  static const double lg = 24;

  /// Floating buttons, pills.
  static const double full = 999;

  static const BorderRadius xsAll = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius fullAll = BorderRadius.all(Radius.circular(full));
  static const BorderRadius sheetTop = BorderRadius.vertical(
    top: Radius.circular(lg),
  );
}
