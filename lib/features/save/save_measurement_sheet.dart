import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/empty_state.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/core/widgets/type_chip.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/features/detail/result_grid.dart';
import 'package:gps_measurement/features/measure/common/photo_strip.dart';
import 'package:gps_measurement/features/photos/photo_actions.dart';
import 'package:gps_measurement/features/photos/photo_flows.dart';
import 'package:gps_measurement/features/premium/premium_flows.dart';
import 'package:gps_measurement/features/save/land_value_field.dart';
import 'package:gps_measurement/features/save/save_controller.dart';
import 'package:gps_measurement/features/saved/widgets/measurement_thumbnail.dart';
import 'package:gps_measurement/features/settings/app_settings.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/services/ads/consent_service.dart';
import 'package:gps_measurement/services/ads/interstitial_manager.dart';

/// Save Measurement (`design.md` §5.6), a full-screen modal page over the
/// measure screen. After saving, the measure screens are replaced by the
/// Detail page (Home → Detail).
class SaveMeasurementSheet extends ConsumerStatefulWidget {
  const SaveMeasurementSheet({required this.measurementId, super.key});

  final String measurementId;

  @override
  ConsumerState<SaveMeasurementSheet> createState() =>
      _SaveMeasurementSheetState();
}

class _SaveMeasurementSheetState extends ConsumerState<SaveMeasurementSheet> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  bool _nameError = false;
  bool _prefilled = false;

  /// Land value typed on this sheet (null until touched).
  LandPrice? _price;

  SaveControllerProvider get _provider =>
      saveControllerProvider(widget.measurementId);

  @override
  void dispose() {
    _name.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _prefill(Measurement m) async {
    _notes.text = m.notes ?? '';
    final name = await ref
        .read(_provider.notifier)
        .suggestName(
          typeLabel: TypeChip.labelOf(context, m.type),
          locale: Localizations.localeOf(context).toString(),
        );
    if (mounted && _name.text.isEmpty) _name.text = name;
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final l10n = context.l10n;
    final result = await ref
        .read(_provider.notifier)
        .save(name: _name.text, notes: _notes.text, price: _price);
    if (!mounted) return;
    switch (result) {
      case SaveResult.saved:
        // Read before this screen is replaced (its ref goes away).
        final interstitial = ref.read(interstitialManagerProvider);
        final consent = ref.read(consentServiceProvider);
        final router = GoRouter.of(context);
        final id = widget.measurementId;
        // iOS ATT may follow the first save. Then an interstitial (at most
        // one per 30 s, otherwise skipped at once); only after it is closed
        // do we leave: Home, then the new record's Detail.
        await consent.requestTrackingIfEligible();
        await interstitial.showIfReady();
        router.go(Routes.home);
        unawaited(router.push(Routes.detailOf(id)));
      case SaveResult.invalidName:
        setState(() => _nameError = true);
      case SaveResult.limitReached:
        // Still a draft (nothing lost). Premium → save right away.
        if (await PremiumFlows.unlockProject(
          context,
          ref,
          widget.measurementId,
        )) {
          if (mounted) await _save();
        } else if (mounted) {
          _snack(l10n.saveLimitReached);
        }
      case SaveResult.failed:
        _snack(l10n.saveFailed);
    }
  }

  void _snack(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final async = ref.watch(_provider);
    final settings = ref.watch(settingsProvider);

    final data = async.value;
    if (data != null && !_prefilled) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => unawaited(_prefill(data.measurement)),
      );
      _prefilled = true;
    }

    return Scaffold(
      backgroundColor: colors.surfaceSheet,
      appBar: AppBar(
        backgroundColor: colors.surfaceSheet,
        automaticallyImplyLeading: false,
        title: Text(l10n.screenSave),
        actions: [
          IconButton(
            tooltip: l10n.actionClose,
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
      body: switch (async) {
        AsyncData(:final value) => _form(context, value, settings),
        AsyncError() => EmptyState(
          icon: Icons.error_outline_rounded,
          title: l10n.saveNotFound,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
      bottomNavigationBar: data == null
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  LmSpacing.pageH,
                  LmSpacing.s8,
                  LmSpacing.pageH,
                  LmSpacing.s8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryCta(
                      label: l10n.actionSave,
                      icon: Icons.check_circle_outline_rounded,
                      variant: PrimaryCtaVariant.forMode(
                        data.measurement.type,
                      ),
                      loading: data.saving,
                      onPressed: _save,
                    ),
                    TextButton(
                      onPressed: data.saving
                          ? null
                          : () => Navigator.of(context).maybePop(),
                      style: TextButton.styleFrom(
                        foregroundColor: colors.textSecondary,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: Text(l10n.actionCancel),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _form(BuildContext context, SaveState s, AppSettings settings) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final m = s.measurement;
    final preview = s.preview;
    final sectionLabel = LmTypography.labelCaps.copyWith(
      color: colors.textSecondary,
    );
    final photos = ref.read(photoStorageProvider);

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(vertical: LmSpacing.s8),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: ClipRRect(
            borderRadius: LmRadius.mdAll,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: preview == null
                  ? MeasurementThumbnail(
                      type: m.type,
                      file: null,
                      size: double.infinity,
                      borderRadius: BorderRadius.zero,
                    )
                  : Image.memory(preview, fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: LmSpacing.s20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: TextField(
            controller: _name,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            maxLength: SaveController.maxNameLength,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              if (_nameError) setState(() => _nameError = false);
            },
            decoration: InputDecoration(
              labelText: l10n.saveNameLabel,
              errorText: _nameError ? l10n.saveNameRequired : null,
              border: const OutlineInputBorder(borderRadius: LmRadius.smAll),
            ),
          ),
        ),
        const SizedBox(height: LmSpacing.s8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: Row(
            children: [
              Text(l10n.saveTypeLabel.toUpperCase(), style: sectionLabel),
              const SizedBox(width: LmSpacing.s12),
              TypeChip(type: m.type),
            ],
          ),
        ),
        const SizedBox(height: LmSpacing.s12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: ResultGrid(
            type: m.type,
            stats: m.stats,
            areaUnit: m.displayAreaUnit ?? settings.areaUnit,
            distanceUnit: m.displayDistanceUnit ?? settings.distanceUnit,
            showSecondary: settings.showSecondaryUnit,
          ),
        ),
        if (m.stats.areaM2 != null) ...[
          const SizedBox(height: LmSpacing.s16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
            child: Text(l10n.landValueTitle.toUpperCase(), style: sectionLabel),
          ),
          const SizedBox(height: LmSpacing.s8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
            child: LandValueField(
              areaM2: m.stats.areaM2,
              initial: landPriceOf(
                m,
                fallbackUnit: m.displayAreaUnit ?? settings.areaUnit,
                region: ref.read(deviceLocaleProvider).countryCode,
              ),
              onChanged: (p) => _price = p,
            ),
          ),
        ],
        const SizedBox(height: LmSpacing.s20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: TextField(
            controller: _notes,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            // Kept in the draft even if Save is cancelled.
            onChanged: ref.read(_provider.notifier).autosaveNotes,
            maxLength: SaveController.maxNotesLength,
            minLines: 3,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.saveNotesLabel,
              hintText: l10n.saveNotesHint,
              alignLabelWithHint: true,
              border: const OutlineInputBorder(borderRadius: LmRadius.smAll),
            ),
          ),
        ),
        const SizedBox(height: LmSpacing.s4),
        PhotoStrip(
          photos: ref.watch(measurementPhotosProvider(m.id)).value ?? m.photos,
          resolve: photos.resolve,
          pointNumbers: {
            for (final (i, p) in m.points.indexed) p.id: i + 1,
          },
          importing: ref.watch(photoImportsProvider),
          onAdd: () =>
              unawaited(PhotoFlows.add(context, ref, measurementId: m.id)),
          onRemove: (p) =>
              unawaited(PhotoFlows.removeWithUndo(context, ref, p)),
          onOpen: (i) =>
              unawaited(context.push(Routes.photosOf(m.id, index: i))),
        ),
      ],
    );
  }
}
