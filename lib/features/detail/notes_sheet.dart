import 'package:flutter/material.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/lm_bottom_sheet.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/features/save/save_controller.dart';

/// Notes editor (`plan.md` P7-07) from Detail. Returns the text on Save,
/// null when dismissed.
Future<String?> showNotesSheet(
  BuildContext context, {
  required String initial,
}) {
  return showLmBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (_) => NotesSheet(initial: initial),
  );
}

class NotesSheet extends StatefulWidget {
  const NotesSheet({required this.initial, super.key});

  final String initial;

  @override
  State<NotesSheet> createState() => _NotesSheetState();
}

class _NotesSheetState extends State<NotesSheet> {
  late final TextEditingController _text = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        LmSpacing.pageH,
        0,
        LmSpacing.pageH,
        LmSpacing.s16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.notesEditTitle,
            style: LmTypography.titleScreen.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: LmSpacing.s12),
          TextField(
            controller: _text,
            autofocus: true,
            minLines: 4,
            maxLines: 10,
            maxLength: SaveController.maxNotesLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: l10n.saveNotesHint,
              border: const OutlineInputBorder(borderRadius: LmRadius.smAll),
            ),
          ),
          const SizedBox(height: LmSpacing.s12),
          PrimaryCta(
            label: l10n.actionSave,
            onPressed: () => Navigator.of(context).pop(_text.text),
          ),
        ],
      ),
    );
  }
}
