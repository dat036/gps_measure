import 'package:flutter/material.dart';

/// The app's modal bottom sheet. Flutter's own `useSafeArea` leaves the
/// bottom out, so on an edge-to-edge screen the system navigation bar
/// covered the last rows of a sheet. This one keeps the content clear of
/// it (and of the status bar); with the keyboard open the sheets' own
/// `viewInsets` padding takes over, as the inset is not counted twice.
Future<T?> showLmBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,

  /// Above the bottom nav of the tab the sheet is opened from.
  bool useRootNavigator = false,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: isScrollControlled,
  useRootNavigator: useRootNavigator,
  useSafeArea: true,
  builder: (context) => SafeArea(top: false, child: builder(context)),
);
