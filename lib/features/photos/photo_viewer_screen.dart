import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/core/format/date_formatter.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:gps_measurement/features/detail/detail_controller.dart';
import 'package:gps_measurement/features/photos/photo_flows.dart';
import 'package:share_plus/share_plus.dart';

/// Photo viewer (`design.md` §5.14): dark background, swipe between
/// photos, pinch to zoom, "1 / 4", date taken, "Point 3", Delete, Share.
class PhotoViewerScreen extends ConsumerStatefulWidget {
  const PhotoViewerScreen({
    required this.measurementId,
    this.initialIndex = 0,
    this.readOnly = false,
    super.key,
  });

  final String measurementId;
  final int initialIndex;

  /// No Delete (opened from Edit: removals wait for "Save Changes").
  final bool readOnly;

  @override
  ConsumerState<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends ConsumerState<PhotoViewerScreen> {
  late final PageController _pages = PageController(
    initialPage: widget.initialIndex < 0 ? 0 : widget.initialIndex,
  );
  late int _index = widget.initialIndex < 0 ? 0 : widget.initialIndex;

  // Photos are shown on near-black in both themes.
  static const LmColors _c = LmColors.light;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  Future<void> _share(Photo photo) async {
    final file = ref.read(photoStorageProvider).resolve(photo.filePath);
    try {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path, mimeType: 'image/jpeg')]),
      );
    } on Object catch (e, st) {
      Log.w('Photo share failed', e, st);
    }
  }

  Future<void> _delete(Photo photo, int count) async {
    final navigator = Navigator.of(context);
    final deleted = await PhotoFlows.removeConfirmed(context, ref, photo);
    if (deleted && count <= 1) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final m = ref.watch(detailControllerProvider(widget.measurementId)).value;
    final photos = m?.photos ?? const <Photo>[];
    final index = photos.isEmpty ? 0 : _index.clamp(0, photos.length - 1);
    final photo = photos.isEmpty ? null : photos[index];
    final storage = ref.read(photoStorageProvider);

    return Scaffold(
      backgroundColor: _c.textPrimary,
      appBar: AppBar(
        backgroundColor: _c.textPrimary,
        foregroundColor: _c.onMode,
        title: Text(
          photos.isEmpty ? '' : l10n.photoCounter(index + 1, photos.length),
          style: LmTypography.titleSection.copyWith(color: _c.onMode),
        ),
      ),
      body: photos.isEmpty
          ? const SizedBox.shrink()
          : PageView.builder(
              controller: _pages,
              itemCount: photos.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => InteractiveViewer(
                maxScale: 5,
                child: Center(
                  child: Image.file(
                    storage.resolve(photos[i].filePath),
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.broken_image_outlined,
                      size: 48,
                      color: _c.textTertiary,
                    ),
                  ),
                ),
              ),
            ),
      bottomNavigationBar: photo == null || m == null
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  LmSpacing.pageH,
                  LmSpacing.s8,
                  LmSpacing.s8,
                  LmSpacing.s8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _Caption(photo: photo, measurement: m),
                    ),
                    if (!widget.readOnly)
                      IconButton(
                        tooltip: l10n.actionDelete,
                        color: _c.onMode,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () =>
                            unawaited(_delete(photo, photos.length)),
                      ),
                    IconButton(
                      tooltip: l10n.photoShare,
                      color: _c.onMode,
                      icon: const Icon(Icons.ios_share_rounded),
                      onPressed: () => unawaited(_share(photo)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption({required this.photo, required this.measurement});

  final Photo photo;
  final Measurement measurement;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const c = LmColors.light;
    final locale = Localizations.localeOf(context).toString();
    final pointIndex = photo.pointId == null
        ? -1
        : measurement.points.indexWhere((p) => p.id == photo.pointId);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormatter.dateTime(photo.takenAt, locale),
          style: LmTypography.bodyMd.copyWith(color: c.onMode),
        ),
        if (pointIndex >= 0)
          Text(
            l10n.pointLabel(pointIndex + 1),
            style: LmTypography.caption.copyWith(color: c.textTertiary),
          ),
      ],
    );
  }
}
