import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/dashed_border.dart';
import 'package:gps_measurement/core/widgets/section_header.dart';
import 'package:gps_measurement/domain/models/photo.dart';

/// "Site Photos (n)   See All ›" + 96dp thumbnails (`design.md` §2.11):
/// round black ✕ when [onRemove] is set, "P3" when attached to a point,
/// a spinner tile per running import, and the dashed "Add Photo" tile
/// when [onAdd] is set.
class PhotoStrip extends StatelessWidget {
  const PhotoStrip({
    required this.photos,
    required this.resolve,
    this.pointNumbers = const {},
    this.onOpen,
    this.onAdd,
    this.onRemove,
    this.importing = 0,
    super.key,
  });

  final List<Photo> photos;

  /// Relative path → file (`PhotoStorage.resolve`).
  final File Function(String relativePath) resolve;

  /// Point id → 1-based number, for the "P3" label.
  final Map<String, int> pointNumbers;

  /// Tap on a photo (viewer at that index); also enables "See All".
  final ValueChanged<int>? onOpen;
  final VoidCallback? onAdd;
  final ValueChanged<Photo>? onRemove;

  /// Imports in progress (spinner tiles).
  final int importing;

  static const double thumbSize = 96;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final open = onOpen;
    final tiles = <Widget>[
      for (final (i, photo) in photos.indexed)
        _Thumb(
          file: resolve(photo.thumbPath),
          cacheWidth: (thumbSize * dpr).round(),
          point: photo.pointId == null ? null : pointNumbers[photo.pointId],
          label: l10n.photoOpen(i + 1),
          onTap: open == null ? null : () => open(i),
          onRemove: onRemove == null ? null : () => onRemove!(photo),
        ),
      for (var i = 0; i < importing; i++) const _LoadingTile(),
      if (onAdd != null) _AddTile(onTap: onAdd!),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: SectionHeader(
            title: l10n.photosTitle(photos.length),
            actionLabel: photos.isEmpty ? null : l10n.actionSeeAll,
            onAction: open == null || photos.isEmpty ? null : () => open(0),
          ),
        ),
        SizedBox(
          height: thumbSize + 6, // room for the ✕ overhang
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
            itemCount: tiles.length,
            separatorBuilder: (_, _) => const SizedBox(width: LmSpacing.s8),
            itemBuilder: (_, i) => Align(
              alignment: Alignment.bottomCenter,
              child: tiles[i],
            ),
          ),
        ),
        if (tiles.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
            child: Text(
              l10n.helpPhotoTip,
              style: LmTypography.caption.copyWith(color: colors.textSecondary),
            ),
          ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.file,
    required this.cacheWidth,
    required this.point,
    required this.label,
    this.onTap,
    this.onRemove,
  });

  final File file;
  final int cacheWidth;
  final int? point;
  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    return SizedBox(
      width: PhotoStrip.thumbSize + 6,
      height: PhotoStrip.thumbSize + 6,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Semantics(
              button: onTap != null,
              label: label,
              child: GestureDetector(
                onTap: onTap,
                child: ClipRRect(
                  borderRadius: LmRadius.smAll,
                  child: SizedBox.square(
                    dimension: PhotoStrip.thumbSize,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          file,
                          fit: BoxFit.cover,
                          cacheWidth: cacheWidth,
                          errorBuilder: (_, _, _) => ColoredBox(
                            color: colors.divider,
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: colors.textTertiary,
                            ),
                          ),
                        ),
                        if (point != null)
                          Positioned(
                            left: 6,
                            bottom: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colors.mapPill,
                                borderRadius: LmRadius.xsAll,
                              ),
                              child: Text(
                                'P$point',
                                style: LmTypography.caption.copyWith(
                                  color: colors.onMode,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (onRemove != null)
            Positioned(
              top: 0,
              right: 0,
              child: Semantics(
                button: true,
                label: l10n.photoRemove,
                child: GestureDetector(
                  onTap: onRemove,
                  behavior: HitTestBehavior.opaque,
                  // 22 dp visual in the corner, 48 dp touch area reaching
                  // into the thumbnail.
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 2, 2, 24),
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: colors.mapPill,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.onMode, width: 1.5),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: colors.onMode,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LoadingTile extends StatelessWidget {
  const _LoadingTile();

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return Container(
      width: PhotoStrip.thumbSize,
      height: PhotoStrip.thumbSize,
      decoration: BoxDecoration(
        color: colors.surfacePage,
        borderRadius: LmRadius.smAll,
      ),
      alignment: Alignment.center,
      child: SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: colors.textSecondary,
        ),
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    return DashedBorder(
      color: colors.outlineDashed,
      radius: LmRadius.sm,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: LmRadius.smAll,
          child: SizedBox.square(
            dimension: PhotoStrip.thumbSize,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  color: colors.textSecondary,
                ),
                const SizedBox(height: LmSpacing.s4),
                Text(
                  l10n.addPhotoTile,
                  textAlign: TextAlign.center,
                  style: LmTypography.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
