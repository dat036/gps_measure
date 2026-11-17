import 'package:flutter/material.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/lm_bottom_sheet.dart';

enum PhotoSourceChoice { camera, gallery }

/// "Add Photo" action sheet (`design.md` §2.14): Take Photo · Choose from
/// Gallery. [pointNumber] notes that the photo goes to that point.
Future<PhotoSourceChoice?> showAddPhotoSheet(
  BuildContext context, {
  int? pointNumber,
}) {
  return showLmBottomSheet<PhotoSourceChoice>(
    context: context,
    builder: (context) {
      final l10n = context.l10n;
      final colors = LmColors.of(context);
      Widget item(IconData icon, String label, PhotoSourceChoice choice) =>
          ListTile(
            minTileHeight: 56,
            leading: Icon(icon, color: colors.textPrimary),
            title: Text(
              label,
              style: LmTypography.bodyLg.copyWith(color: colors.textPrimary),
            ),
            onTap: () => Navigator.of(context).pop(choice),
          );
      return Padding(
        padding: const EdgeInsets.only(bottom: LmSpacing.s8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LmSpacing.pageH,
                0,
                LmSpacing.pageH,
                LmSpacing.s8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.addPhotoTitle,
                    style: LmTypography.titleSection.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  if (pointNumber != null)
                    Text(
                      l10n.addPhotoForPoint(pointNumber),
                      style: LmTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            item(
              Icons.photo_camera_outlined,
              l10n.addPhotoCamera,
              PhotoSourceChoice.camera,
            ),
            item(
              Icons.photo_library_outlined,
              l10n.addPhotoGallery,
              PhotoSourceChoice.gallery,
            ),
          ],
        ),
      );
    },
  );
}
