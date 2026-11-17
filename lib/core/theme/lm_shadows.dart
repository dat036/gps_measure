import 'package:flutter/painting.dart';

/// Elevation tokens from `design.md` §1.3 (shadow color = text.primary navy).
abstract final class LmShadows {
  static const Color _navy = Color(0xFF0E1A2B);

  static final List<BoxShadow> card = [
    BoxShadow(
      color: _navy.withValues(alpha: 0.06),
      offset: const Offset(0, 1),
      blurRadius: 3,
    ),
    BoxShadow(
      color: _navy.withValues(alpha: 0.04),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  /// Round buttons floating over the map.
  static final List<BoxShadow> float = [
    BoxShadow(
      color: _navy.withValues(alpha: 0.16),
      offset: const Offset(0, 4),
      blurRadius: 12,
    ),
  ];

  static final List<BoxShadow> sheet = [
    BoxShadow(
      color: _navy.withValues(alpha: 0.10),
      offset: const Offset(0, -4),
      blurRadius: 24,
    ),
  ];
}
