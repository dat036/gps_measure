import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:gps_measurement/features/edit/edit_controller.dart';
import 'package:gps_measurement/features/measure/common/photo_strip.dart';
import 'package:gps_measurement/features/photos/photo_actions.dart';
import 'package:gps_measurement/features/photos/photo_flows.dart';
import 'package:gps_measurement/features/save/save_controller.dart';

/// "Details" of Edit Measurement (`design.md` §5.9): name, notes, photos.
/// Changes stay in [EditController] until Save Changes.
class EditDetailsForm extends ConsumerStatefulWidget {
  const EditDetailsForm({
    required this.measurementId,
    this.points = const [],
    super.key,
  });

  final String measurementId;

  /// Current geometry (for "P3" labels).
  final List<MeasurePoint> points;

  @override
  ConsumerState<EditDetailsForm> createState() => _EditDetailsFormState();
}

class _EditDetailsFormState extends ConsumerState<EditDetailsForm> {
  late final TextEditingController _name;
  late final TextEditingController _notes;

  EditControllerProvider get _provider =>
      editControllerProvider(widget.measurementId);

  @override
  void initState() {
    super.initState();
    final s = ref.read(_provider).requireValue;
    _name = TextEditingController(text: s.name);
    _notes = TextEditingController(text: s.notes);
  }

  @override
  void dispose() {
    _name.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _remove(Photo photo) async {
    final l10n = context.l10n;
    final controller = ref.read(_provider.notifier)..removePhoto(photo);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.photoRemoved),
          persist: false,
          action: SnackBarAction(
            label: l10n.actionUndo,
            onPressed: () => controller.undoRemovePhoto(photo),
          ),
        ),
      );
  }

  Future<void> _add() async {
    final controller = ref.read(_provider.notifier);
    final added = await PhotoFlows.add(
      context,
      ref,
      measurementId: widget.measurementId,
    );
    if (added.isNotEmpty) controller.photosAdded(added);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = ref.watch(_provider).value;
    final stored =
        ref.watch(measurementPhotosProvider(widget.measurementId)).value ??
        const <Photo>[];
    final controller = ref.read(_provider.notifier);
    final photos = s == null ? const <Photo>[] : controller.visible(stored);
    const border = OutlineInputBorder(borderRadius: LmRadius.smAll);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: TextField(
            controller: _name,
            maxLength: SaveController.maxNameLength,
            textCapitalization: TextCapitalization.sentences,
            onChanged: controller.setName,
            decoration: InputDecoration(
              labelText: l10n.saveNameLabel,
              errorText: s != null && !s.nameValid
                  ? l10n.saveNameRequired
                  : null,
              border: border,
            ),
          ),
        ),
        const SizedBox(height: LmSpacing.s8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: TextField(
            controller: _notes,
            maxLength: SaveController.maxNotesLength,
            minLines: 3,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            onChanged: controller.setNotes,
            decoration: InputDecoration(
              labelText: l10n.saveNotesLabel,
              hintText: l10n.saveNotesHint,
              alignLabelWithHint: true,
              border: border,
            ),
          ),
        ),
        const SizedBox(height: LmSpacing.s8),
        PhotoStrip(
          photos: photos,
          resolve: ref.read(photoStorageProvider).resolve,
          pointNumbers: {
            for (final (i, p) in widget.points.indexed) p.id: i + 1,
          },
          importing: ref.watch(photoImportsProvider),
          onAdd: () => unawaited(_add()),
          onRemove: (p) => unawaited(_remove(p)),
          onOpen: (i) => unawaited(
            context.push(
              Routes.photosOf(
                widget.measurementId,
                index: stored.indexOf(photos[i]),
                readOnly: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
