import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/widgets/mode_icon.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// Saved map thumbnail, or the mode icon on the mode's container color when
/// there is none (drafts) or the file is missing.
class MeasurementThumbnail extends StatelessWidget {
  const MeasurementThumbnail({
    required this.type,
    required this.file,
    this.size = 64,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    super.key,
  });

  final MeasurementType type;
  final File? file;
  final double size;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final mode = ModeColors.of(context, type);
    final fallback = ColoredBox(
      color: mode.container,
      child: Center(
        child: Icon(modeIcon(type), color: mode.main, size: size * 0.42),
      ),
    );
    final f = file;
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox.square(
        dimension: size,
        child: f == null
            ? fallback
            : Image.file(
                f,
                fit: BoxFit.cover,
                cacheWidth: (size * MediaQuery.devicePixelRatioOf(context))
                    .round(),
                errorBuilder: (_, _, _) => fallback,
              ),
      ),
    );
  }
}
