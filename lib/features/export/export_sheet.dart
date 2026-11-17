import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/l10n/measurement_labels.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/lm_bottom_sheet.dart';
import 'package:gps_measurement/core/widgets/lm_dialog.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/export/export_service.dart';
import 'package:gps_measurement/features/export/pdf_report_builder.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/premium/premium_badge.dart';
import 'package:gps_measurement/features/premium/premium_flows.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/services/ads/rewarded_manager.dart';

/// Export action sheet (`design.md` §2.14): KML · CSV. The chosen file is
/// written and handed to the system share sheet; the result shows as a
/// snackbar on the screen underneath.
Future<void> showExportSheet(
  BuildContext context,
  String measurementId, {
  String? name,
  MeasurementType type = MeasurementType.area,
}) {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;
  final fallbackName = l10n.titleOf(name, type);
  return showLmBottomSheet<void>(
    context: context,
    // From the Saved tab too: above the bottom nav.
    useRootNavigator: true,
    builder: (_) => ExportSheet(
      measurementId: measurementId,
      fallbackName: fallbackName,
      onResult: (result) {
        final text = switch (result) {
          // premiumRequired: the sheet opens the paywall before exporting.
          ExportResult.shared ||
          ExportResult.dismissed ||
          ExportResult.premiumRequired => null,
          ExportResult.limitReached => l10n.exportLimitReached,
          ExportResult.failed => l10n.exportFailed,
        };
        if (text == null) return;
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(text)));
      },
    ),
  );
}

class ExportSheet extends ConsumerStatefulWidget {
  const ExportSheet({
    required this.measurementId,
    required this.fallbackName,
    required this.onResult,
    super.key,
  });

  final String measurementId;
  final String fallbackName;
  final ValueChanged<ExportResult> onResult;

  @override
  ConsumerState<ExportSheet> createState() => _ExportSheetState();
}

enum _Unlock { cancel, watchAd, premium }

class _ExportSheetState extends ConsumerState<ExportSheet> {
  ExportFormat? _busy;
  bool _loadingAd = false;

  Future<ExportResult> _run(
    ExportFormat format,
    Rect? origin, {
    bool unlocked = false,
  }) {
    final settings = ref.read(settingsProvider);
    final pdf = format == ExportFormat.pdf
        ? PdfReportOptions.forLocale(
            Localizations.localeOf(context),
            areaUnit: settings.areaUnit,
            distanceUnit: settings.distanceUnit,
            showSecondaryUnit: settings.showSecondaryUnit,
          )
        : null;
    return ref
        .read(exportServiceProvider)
        .export(
          widget.measurementId,
          format,
          fallbackName: widget.fallbackName,
          shareOrigin: origin,
          unlocked: unlocked,
          pdf: pdf,
        );
  }

  Future<void> _export(ExportFormat format, BuildContext tileContext) async {
    if (_busy != null) return;
    final box = tileContext.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    // The PDF report is Premium: a free user goes straight to the paywall
    // and the export runs once they have bought.
    if (format == ExportFormat.pdf &&
        !ref.read(featureGateProvider).canUsePdf) {
      final premium = await PremiumFlows.openPaywall(
        context,
        PaywallSource.exportPdf,
      );
      if (!premium || !mounted) return;
    }
    setState(() => _busy = format);
    var result = await _run(format, origin);
    if (result == ExportResult.limitReached && mounted) {
      result = await _unlock(format, origin) ?? ExportResult.dismissed;
    }
    if (!mounted) return;
    setState(() {
      _busy = null;
      _loadingAd = false;
    });
    Navigator.of(context).pop();
    widget.onResult(result);
  }

  /// Free KML used today: a rewarded ad unlocks this one export, Premium
  /// unlocks all (`overview.md` §5.3). Null when the user gives up.
  Future<ExportResult?> _unlock(ExportFormat format, Rect? origin) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final choice = await showLmDialog<_Unlock>(
      context,
      title: l10n.exportUnlockTitle,
      message: l10n.exportUnlockMessage,
      actions: [
        LmDialogAction(label: l10n.actionCancel, value: _Unlock.cancel),
        LmDialogAction(label: l10n.exportWatchAd, value: _Unlock.watchAd),
        LmDialogAction(
          label: l10n.exportGetPremium,
          value: _Unlock.premium,
          style: LmDialogActionStyle.primary,
        ),
      ],
    );
    if (!mounted) return null;
    switch (choice) {
      case _Unlock.watchAd:
        setState(() => _loadingAd = true);
        final reward = await ref.read(rewardedManagerProvider).show();
        if (!mounted) return null;
        setState(() => _loadingAd = false);
        if (reward == RewardOutcome.dismissed) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.exportAdDismissed)));
          return null;
        }
        // Earned, or no ad to show: export anyway.
        return _run(format, origin, unlocked: true);
      case _Unlock.premium:
        final premium = await PremiumFlows.openPaywall(
          context,
          PaywallSource.exportKml,
        );
        if (!premium || !mounted) return null;
        return _run(format, origin);
      case _Unlock.cancel || null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);

    final pdfLocked = !ref.watch(featureGateProvider).canUsePdf;

    Widget item(
      ExportFormat format,
      IconData icon,
      String title,
      String subtitle, {
      bool locked = false,
    }) => Builder(
      builder: (tileContext) => ListTile(
        minTileHeight: 64,
        enabled: _busy == null,
        leading: _busy == format
            ? const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Icon(icon, color: colors.textPrimary),
        title: Text(
          title,
          style: LmTypography.bodyLg.copyWith(color: colors.textPrimary),
        ),
        subtitle: Text(
          _busy != format
              ? subtitle
              : _loadingAd
              ? l10n.exportLoadingAd
              : l10n.exportPreparing,
          style: LmTypography.caption.copyWith(color: colors.textSecondary),
        ),
        trailing: locked ? PremiumBadge(label: l10n.premiumBadge) : null,
        onTap: () => unawaited(_export(format, tileContext)),
      ),
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
            child: Text(
              l10n.exportTitle,
              style: LmTypography.titleSection.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          item(
            ExportFormat.kml,
            Icons.public_rounded,
            l10n.exportKml,
            l10n.exportKmlSubtitle,
          ),
          item(
            ExportFormat.csv,
            Icons.table_chart_outlined,
            l10n.exportCsv,
            l10n.exportCsvSubtitle,
          ),
          item(
            ExportFormat.pdf,
            Icons.picture_as_pdf_outlined,
            l10n.exportPdf,
            l10n.exportPdfSubtitle,
            locked: pdfLocked,
          ),
        ],
      ),
    );
  }
}
