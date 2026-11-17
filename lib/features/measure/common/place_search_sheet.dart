import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/empty_state.dart';
import 'package:gps_measurement/core/widgets/lm_bottom_sheet.dart';
import 'package:gps_measurement/features/measure/common/place_search_controller.dart';
import 'package:gps_measurement/features/measure/common/place_search_service.dart';

/// Place search (`architecture.md` §7.7, P4-04). Returns the picked place,
/// or null when dismissed.
Future<PlaceResult?> showPlaceSearchSheet(BuildContext context) {
  return showLmBottomSheet<PlaceResult>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const FractionallySizedBox(
      heightFactor: 0.9,
      child: PlaceSearchSheet(),
    ),
  );
}

class PlaceSearchSheet extends ConsumerStatefulWidget {
  const PlaceSearchSheet({super.key});

  @override
  ConsumerState<PlaceSearchSheet> createState() => _PlaceSearchSheetState();
}

class _PlaceSearchSheetState extends ConsumerState<PlaceSearchSheet> {
  final TextEditingController _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _submit([String? value]) async {
    final query = value ?? _text.text;
    if (value != null) _text.text = value;
    FocusScope.of(context).unfocus();
    final exact = await ref
        .read(placeSearchControllerProvider.notifier)
        .submit(query, locale: Localizations.localeOf(context));
    if (exact != null && mounted) Navigator.of(context).pop(exact);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final state = ref.watch(placeSearchControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            LmSpacing.pageH,
            0,
            LmSpacing.pageH,
            LmSpacing.s12,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _text,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
                  onSubmitted: (v) => unawaited(_submit(v)),
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: ListenableBuilder(
                      listenable: _text,
                      builder: (context, _) => _text.text.isEmpty
                          ? const SizedBox.shrink()
                          : IconButton(
                              tooltip: l10n.searchClear,
                              icon: const Icon(Icons.close_rounded),
                              onPressed: _text.clear,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: LmSpacing.s8),
              FilledButton(
                onPressed: state.status == PlaceSearchStatus.loading
                    ? null
                    : () => unawaited(_submit()),
                child: Text(l10n.searchAction),
              ),
            ],
          ),
        ),
        Expanded(child: _body(state, colors)),
      ],
    );
  }

  Widget _body(PlaceSearchState state, LmColors colors) {
    final l10n = context.l10n;
    switch (state.status) {
      case PlaceSearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case PlaceSearchStatus.empty:
        return _message(Icons.search_off_rounded, l10n.searchNoResults);
      case PlaceSearchStatus.offline:
        return _message(Icons.cloud_off_rounded, l10n.searchNeedsInternet);
      case PlaceSearchStatus.failed:
        return _message(Icons.search_off_rounded, l10n.searchFailed);
      case PlaceSearchStatus.unavailable:
        return _message(
          Icons.location_disabled_rounded,
          l10n.searchUnavailable,
        );
      case PlaceSearchStatus.results:
        return ListView(
          children: [
            for (final r in state.results)
              ListTile(
                minTileHeight: 56,
                leading: Icon(
                  r.isExact ? Icons.my_location_rounded : Icons.place_outlined,
                ),
                title: Text(r.title),
                subtitle: r.subtitle == null ? null : Text(r.subtitle!),
                onTap: () => Navigator.of(context).pop(r),
              ),
          ],
        );
      case PlaceSearchStatus.idle:
        if (state.recent.isEmpty) return const SizedBox.shrink();
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LmSpacing.pageH,
                LmSpacing.s8,
                LmSpacing.s4,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.searchRecent,
                      style: LmTypography.titleSection.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => unawaited(
                      ref
                          .read(placeSearchControllerProvider.notifier)
                          .clearRecent(),
                    ),
                    child: Text(l10n.searchClear),
                  ),
                ],
              ),
            ),
            for (final q in state.recent)
              ListTile(
                minTileHeight: 56,
                leading: const Icon(Icons.history_rounded),
                title: Text(q, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () => unawaited(_submit(q)),
              ),
          ],
        );
    }
  }

  Widget _message(IconData icon, String text) => Align(
    alignment: Alignment.topCenter,
    child: EmptyState(icon: icon, title: text),
  );
}
