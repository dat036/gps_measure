import 'package:flutter/material.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/widgets/lm_dialog.dart';
import 'package:gps_measurement/features/save/save_controller.dart';

/// "Rename Measurement" (`design.md` §5.17). Returns the trimmed new name,
/// or null when cancelled / unchanged.
Future<String?> showRenameDialog(
  BuildContext context, {
  required String initialName,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => RenameDialog(initialName: initialName),
  );
}

class RenameDialog extends StatefulWidget {
  const RenameDialog({required this.initialName, super.key});

  final String initialName;

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  late final TextEditingController _text =
      TextEditingController(
          text: widget.initialName,
        )
        ..selection = TextSelection(
          baseOffset: 0,
          extentOffset: widget.initialName.length,
        );
  bool _showError = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _text.text.trim();
    if (name.isEmpty) {
      setState(() => _showError = true);
      return;
    }
    Navigator.of(context).pop(name == widget.initialName ? null : name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LmDialog<String>(
      title: l10n.dialogRenameTitle,
      content: TextField(
        controller: _text,
        autofocus: true,
        maxLength: SaveController.maxNameLength,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        onChanged: (_) {
          if (_showError) setState(() => _showError = false);
        },
        decoration: InputDecoration(
          hintText: l10n.renameHint,
          errorText: _showError ? l10n.saveNameRequired : null,
        ),
      ),
      actions: [
        LmDialogAction(label: l10n.actionCancel, value: ''),
        LmDialogAction(
          label: l10n.actionSave,
          value: '',
          style: LmDialogActionStyle.primary,
        ),
      ],
      onAction: (index) => index == 0 ? Navigator.of(context).pop() : _submit(),
    );
  }
}
