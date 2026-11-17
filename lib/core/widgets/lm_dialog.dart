import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';

enum LmDialogActionStyle {
  /// Text button (Cancel, Discard in the Leave dialog…).
  secondary,

  /// Filled brand button.
  primary,

  /// Filled red button (Delete, Reset, Discard draft).
  destructive,
}

class LmDialogAction<T> {
  const LmDialogAction({
    required this.label,
    required this.value,
    this.style = LmDialogActionStyle.secondary,
  });

  final String label;
  final T value;
  final LmDialogActionStyle style;
}

/// Shows an M3 dialog (`design.md` §2.14) with any number of actions,
/// laid out right-aligned in the given order. Returns the tapped action's
/// value, or null when dismissed.
Future<T?> showLmDialog<T>(
  BuildContext context, {
  required String title,
  required List<LmDialogAction<T>> actions,
  String? message,
  Widget? content,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => LmDialog<T>(
      title: title,
      message: message,
      content: content,
      actions: actions,
    ),
  );
}

/// Two-button confirm dialog. Returns true only when confirmed.
Future<bool> showLmConfirm(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  required String cancelLabel,
  String? message,
  bool destructive = false,
}) async {
  final result = await showLmDialog<bool>(
    context,
    title: title,
    message: message,
    actions: [
      LmDialogAction(label: cancelLabel, value: false),
      LmDialogAction(
        label: confirmLabel,
        value: true,
        style: destructive
            ? LmDialogActionStyle.destructive
            : LmDialogActionStyle.primary,
      ),
    ],
  );
  return result ?? false;
}

class LmDialog<T> extends StatelessWidget {
  const LmDialog({
    required this.title,
    required this.actions,
    this.message,
    this.content,
    this.onAction,
    super.key,
  });

  final String title;
  final String? message;
  final Widget? content;
  final List<LmDialogAction<T>> actions;

  /// Handles a tap on the action at the given index instead of popping
  /// (e.g. a form that validates before closing).
  final void Function(int index)? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    var body = content;
    if (body == null && message != null) body = Text(message!);

    return AlertDialog(
      title: Text(title),
      content: body,
      actionsOverflowButtonSpacing: 8,
      actions: [
        for (final (i, action) in actions.indexed)
          _buildAction(context, colors, action, i),
      ],
    );
  }

  Widget _buildAction(
    BuildContext context,
    LmColors colors,
    LmDialogAction<T> action,
    int index,
  ) {
    void pop() => onAction != null
        ? onAction!(index)
        : Navigator.of(context).pop(action.value);
    const shape = RoundedRectangleBorder(borderRadius: LmRadius.fullAll);
    return switch (action.style) {
      LmDialogActionStyle.secondary => TextButton(
        onPressed: pop,
        style: TextButton.styleFrom(foregroundColor: colors.textSecondary),
        child: Text(action.label),
      ),
      LmDialogActionStyle.primary => FilledButton(
        onPressed: pop,
        style: FilledButton.styleFrom(shape: shape),
        child: Text(action.label),
      ),
      LmDialogActionStyle.destructive => FilledButton(
        onPressed: pop,
        style: FilledButton.styleFrom(
          backgroundColor: colors.dangerMain,
          foregroundColor: colors.onMode,
          shape: shape,
        ),
        child: Text(action.label),
      ),
    };
  }
}
