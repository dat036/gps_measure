import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_measurement/core/connectivity/connectivity_service.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/location/location_service.dart';
import 'package:gps_measurement/core/permissions/permission_flows.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/widgets/lm_dialog.dart';
import 'package:gps_measurement/core/widgets/map_fab.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/core/widgets/status_banner.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/location_fix.dart';
import 'package:gps_measurement/features/measure/common/leave_measure_guard.dart';
import 'package:gps_measurement/features/measure/common/map_layer_sheet.dart';
import 'package:gps_measurement/features/measure/common/map_snapshot.dart';
import 'package:gps_measurement/features/measure/common/measure_floating_controls.dart';
import 'package:gps_measurement/features/measure/common/measure_help_sheet.dart';
import 'package:gps_measurement/features/measure/common/photo_strip.dart';
import 'package:gps_measurement/features/measure/common/result_sheet.dart';
import 'package:gps_measurement/features/measure/walk/battery_optimization_helper.dart';
import 'package:gps_measurement/features/measure/walk/walk_controller.dart';
import 'package:gps_measurement/features/measure/walk/walk_map_view.dart';
import 'package:gps_measurement/features/measure/walk/walk_result_panel.dart';
import 'package:gps_measurement/features/measure/walk/walk_state.dart';
import 'package:gps_measurement/features/photos/photo_actions.dart';
import 'package:gps_measurement/features/photos/photo_flows.dart';
import 'package:gps_measurement/features/save/pending_thumbnails.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/services/ads/interstitial_manager.dart';
import 'package:gps_measurement/services/ads/native_ad_view.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Walk & Measure (`design.md` §5.4–5.5): Ready → Recording ⇄ Paused →
/// Finished. The map follows the user until they pan it; the ⌖ button
/// (orange while not following) recenters.
///
/// Back leaves at once like the other measure screens (the walk stays a
/// draft), except while recording: then back is blocked with a snackbar
/// offering "Pause & leave", so a stray back press never stops a walk.
class WalkScreen extends ConsumerStatefulWidget {
  const WalkScreen({this.draftId, super.key});

  final String? draftId;

  @override
  ConsumerState<WalkScreen> createState() => _WalkScreenState();
}

class _WalkScreenState extends ConsumerState<WalkScreen> {
  static const _hanoi = CameraPosition(
    target: LatLng(21.0285, 105.8542),
    zoom: 15,
  );
  static const _world = CameraPosition(target: LatLng(20, 0), zoom: 2);
  static const double _followZoom = 18;

  /// Tracks spanning less than this are shown at [_followZoom].
  static const double _minFitSpanM = 60;

  late final WalkController _walk;
  late final AppLifecycleListener _lifecycle;
  final DraggableScrollableController _sheet = DraggableScrollableController();
  final ValueNotifier<double> _sheetExtent = ValueNotifier(
    ResultSheet.defaultSize,
  );

  GoogleMapController? _map;
  CameraPosition? _initialCamera;
  late bool _following = ref.read(settingsProvider).autoCenter;
  bool _zoomedToUser = false;
  bool _starting = false;
  bool _saving = false;

  /// Map height of the last layout (thumbnail framing).
  double _mapHeight = 1;

  @override
  void initState() {
    super.initState();
    _walk = ref.read(walkControllerProvider.notifier);
    // Next to save: have the interstitial ready by then.
    ref.read(interstitialManagerProvider).preload();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        NativeAdPlacements.preloadDetail(context, ref, MeasurementType.walk);
      }
    });
    _lifecycle = AppLifecycleListener(
      onHide: () => unawaited(_walk.flushNow()),
      onPause: () => unawaited(_walk.flushNow()),
      // Back from system Settings (location / permission / battery).
      onResume: () => unawaited(_onResume()),
    );
    ref
      ..listenManual(
        settingsProvider.select((s) => s.keepScreenAwake),
        (_, awake) => unawaited(WakelockPlus.toggle(enable: awake)),
        fireImmediately: true,
      )
      ..listenManual(
        walkControllerProvider.select((s) => s.lastFix),
        (_, fix) => _onFix(fix),
      )
      ..listenManual(
        walkControllerProvider.select((s) => s.runState),
        (previous, next) {
          if (next == WalkRunState.finished &&
              previous != WalkRunState.finished) {
            _showFinishedResult();
          }
        },
      );
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
  }

  @override
  void dispose() {
    unawaited(WakelockPlus.disable());
    // Already done by the back handler; covers other ways of closing.
    unawaited(_walk.leave());
    _lifecycle.dispose();
    _sheet.dispose();
    _sheetExtent.dispose();
    super.dispose();
  }

  Future<void> _open() async {
    final l10n = context.l10n;
    await _walk.prepare(
      draftId: widget.draftId,
      notification: (
        title: l10n.walkNotificationTitle,
        text: l10n.walkNotificationText,
        channelName: l10n.walkNotificationChannel,
      ),
    );
    await _prepareCamera();
    if (!mounted) return;
    // Not asked yet (or refused once): explain, then the system dialog.
    if (ref.read(walkControllerProvider).gps == GpsStatus.denied) {
      await _askLocation();
      if (!mounted) return;
    }
    final settings = ref.read(settingsRepositoryProvider);
    if (!settings.helpSeen(MeasurementType.walk)) {
      unawaited(settings.setHelpSeen(MeasurementType.walk));
      unawaited(showMeasureHelpSheet(context, MeasurementType.walk));
    }
  }

  /// Camera moves sent while another app (system Settings) was on top are
  /// lost: when still following, center on the user again.
  Future<void> _onResume() async {
    await _walk.refreshAccess();
    if (!mounted || !_following) return;
    _zoomedToUser = false;
    _onFix(ref.read(walkControllerProvider).lastFix);
  }

  /// Location pre-prompt → system dialog → restart the GPS preview.
  Future<void> _askLocation() async {
    await PermissionFlows.location(
      context,
      ref,
      message: context.l10n.locationPermissionWalkMessage,
    );
    if (mounted) await _walk.refreshAccess();
  }

  // ------------------------------------------------------------- camera

  Future<void> _prepareCamera() async {
    final s = ref.read(walkControllerProvider);
    final bounds = GeoCalculator.bounds(s.points.map((p) => p.position));
    CameraPosition camera;
    if (bounds != null) {
      camera = CameraPosition(
        target: LatLng(bounds.center.lat, bounds.center.lng),
        zoom: 17,
      );
    } else if (s.lastFix case final LocationFix fix) {
      camera = CameraPosition(
        target: LatLng(fix.lat, fix.lng),
        zoom: _followZoom,
      );
      _zoomedToUser = true;
    } else {
      final location = ref.read(locationServiceProvider);
      final granted =
          await location.ensureAccess(request: false) == LocationAccess.granted;
      final last = granted ? await location.lastKnown() : null;
      if (last != null) {
        camera = CameraPosition(
          target: LatLng(last.lat, last.lng),
          zoom: 17,
        );
      } else {
        final vi =
            WidgetsBinding.instance.platformDispatcher.locale.languageCode ==
                'vi' ||
            ref.read(settingsProvider).localeCode == 'vi';
        camera = vi ? _hanoi : _world;
      }
    }
    if (mounted) setState(() => _initialCamera = camera);
  }

  void _onMapCreated(GoogleMapController controller) {
    _map = controller;
    final s = ref.read(walkControllerProvider);
    if (s.isFinished) _fitTrack();
  }

  void _onFix(LocationFix? fix) {
    final map = _map;
    if (fix == null || map == null || !_following) return;
    if (ref.read(walkControllerProvider).isFinished) return;
    final target = LatLng(fix.lat, fix.lng);
    unawaited(
      map.animateCamera(
        _zoomedToUser
            ? CameraUpdate.newLatLng(target)
            : CameraUpdate.newLatLngZoom(target, _followZoom),
      ),
    );
    _zoomedToUser = true;
  }

  void _recenter() {
    setState(() => _following = true);
    final s = ref.read(walkControllerProvider);
    if (s.isFinished) {
      _fitTrack();
    } else {
      _onFix(s.lastFix);
    }
  }

  void _fitTrack() {
    final points = ref.read(walkControllerProvider).points;
    final b = GeoCalculator.bounds(points.map((p) => p.position));
    if (b == null || _map == null) return;
    // A short track would zoom in past the imagery: keep street level.
    final small =
        GeoCalculator.distance(
          GeoPoint(lat: b.minLat, lng: b.minLng),
          GeoPoint(lat: b.maxLat, lng: b.maxLng),
        ) <
        _minFitSpanM;
    unawaited(
      _map!.animateCamera(
        small
            ? CameraUpdate.newLatLngZoom(
                LatLng(b.center.lat, b.center.lng),
                _followZoom,
              )
            : CameraUpdate.newLatLngBounds(
                LatLngBounds(
                  southwest: LatLng(b.minLat, b.minLng),
                  northeast: LatLng(b.maxLat, b.maxLng),
                ),
                64,
              ),
      ),
    );
  }

  void _showFinishedResult() {
    if (_sheet.isAttached) {
      unawaited(
        _sheet.animateTo(
          ResultSheet.maxSize,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
        ),
      );
    }
    _fitTrack();
  }

  // ------------------------------------------------------------- actions

  Future<void> _start() async {
    setState(() => _starting = true);
    try {
      await PermissionFlows.walkNotificationsOnce(context, ref);
      if (!mounted) return;
      final battery = ref.read(batteryOptimizationHelperProvider);
      if (await battery.shouldShowHint()) {
        await battery.markShown();
        if (!mounted) return;
        final choice = await showBatteryHintSheet(context);
        if (choice == BatteryHintChoice.openSettings) {
          await battery.openSettings();
          return; // Start again when back from Settings.
        }
      }
      final ok = await _walk.start();
      if (!mounted) return;
      if (ok) {
        unawaited(HapticFeedback.mediumImpact());
        // Auto Center Map off: the map stays where the user put it.
        if (ref.read(settingsProvider).autoCenter) {
          // Street level on the user, even if an earlier move was lost.
          setState(() {
            _following = true;
            _zoomedToUser = false;
          });
        }
        _onFix(ref.read(walkControllerProvider).lastFix);
      } else {
        _snack(context.l10n.walkStartFailed);
      }
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  Future<void> _confirmFinish() async {
    final l10n = context.l10n;
    final ok = await showLmConfirm(
      context,
      title: l10n.dialogFinishWalkTitle,
      message: l10n.dialogFinishWalkMessage,
      confirmLabel: l10n.ctaFinish,
      cancelLabel: l10n.actionKeepRecording,
    );
    if (ok) await _walk.finish();
  }

  Future<void> _pickMapStyle(MapStyle current) async {
    final style = await showMapLayerSheet(context, ref, current: current);
    if (style == null) return;
    _walk.setMapStyle(style);
    await ref
        .read(settingsProvider.notifier)
        .change((s) => s.copyWith(mapStyle: style));
  }

  /// Flush, snapshot the track for the thumbnail, open Save.
  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await _walk.flushNow();
      final s = ref.read(walkControllerProvider);
      final id = s.measurementId;
      if (id == null || !mounted) return;
      final png = await captureMapThumbnail(
        _map,
        s.points.map((p) => p.position),
        mapHeight: _mapHeight,
        visibleHeight: _mapHeight * (1 - ResultSheet.minSize),
      );
      if (png != null) ref.read(pendingThumbnailsProvider).put(id, png);
      if (!mounted) return;
      await context.push(Routes.saveOf(id));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Back while recording: explain, offer to pause and leave.
  void _onBackWhileRecording() {
    final navigator = Navigator.of(context);
    final l10n = context.l10n;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.walkRecordingBack),
          persist: false,
          action: SnackBarAction(
            label: l10n.walkPauseAndLeave,
            // A direct pop still runs the guard, whose leave() pauses.
            onPressed: navigator.pop,
          ),
        ),
      );
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = ref.watch(walkControllerProvider);
    final settings = ref.watch(settingsProvider);
    final online = ref.watch(isOnlineProvider).value ?? true;
    final camera = _initialCamera;

    if (!s.ready || camera == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.screenWalk)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final areaUnit = s.displayAreaUnit ?? settings.areaUnit;
    final distanceUnit = s.displayDistanceUnit ?? settings.distanceUnit;
    final banner = _banner(
      s,
      online: online,
      showAccuracy: settings.showGpsAccuracy,
    );
    final walkColor = ModeColors.of(context, MeasurementType.walk).main;

    return LeaveMeasureGuard(
      type: MeasurementType.walk,
      onLeave: _walk.leave,
      canPop: !s.isRecording,
      onPopBlocked: _onBackWhileRecording,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.screenWalk),
          actions: [
            IconButton(
              tooltip: l10n.menuHelp,
              icon: const Icon(Icons.help_outline_rounded),
              onPressed: () => unawaited(
                showMeasureHelpSheet(context, MeasurementType.walk),
              ),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            _mapHeight = height;
            return Stack(
              children: [
                Positioned.fill(
                  child: WalkMapView(
                    points: s.points,
                    initialCamera: camera,
                    mapStyle: s.mapStyle,
                    isClosed: s.stats.isClosed,
                    closureThresholdM: s.runState == WalkRunState.idle
                        ? null
                        : s.closureThresholdM,
                    lastFix: s.lastFix,
                    showAccuracy: settings.showGpsAccuracy,
                    finished: s.isFinished,
                    bottomPadding: height * ResultSheet.minSize,
                    onMapCreated: _onMapCreated,
                    onUserPan: () {
                      if (_following) setState(() => _following = false);
                    },
                  ),
                ),
                if (banner != null)
                  Positioned(
                    top: LmSpacing.s12,
                    left: LmSpacing.pageH,
                    right: LmSpacing.pageH,
                    child: banner,
                  ),
                MeasureFloatingControls(
                  sheetExtent: _sheetExtent,
                  height: height,
                  topInset: banner != null ? 88 : LmSpacing.s12,
                  topFabs: [
                    MapFab(
                      icon: Icons.layers_rounded,
                      tooltip: l10n.fabLayers,
                      onPressed: () => _pickMapStyle(s.mapStyle),
                    ),
                    MapFab(
                      icon: Icons.my_location_rounded,
                      tooltip: _following
                          ? l10n.fabMyLocation
                          : l10n.fabRecenter,
                      active: !_following,
                      activeColor: walkColor,
                      onPressed: s.lastFix == null && !s.isFinished
                          ? null
                          : _recenter,
                    ),
                  ],
                  // Photos need the draft, created by Start Walking.
                  cameraFab: MapFab(
                    icon: Icons.photo_camera_rounded,
                    tooltip: s.measurementId == null
                        ? l10n.photoWaitForStart
                        : l10n.fabCamera,
                    large: true,
                    onPressed: s.measurementId == null
                        ? null
                        : () => unawaited(
                            PhotoFlows.add(
                              context,
                              ref,
                              measurementId: s.measurementId!,
                              location: s.lastFix?.position,
                            ),
                          ),
                  ),
                  bottom: const SizedBox.shrink(),
                ),
                NotificationListener<DraggableScrollableNotification>(
                  onNotification: (n) {
                    _sheetExtent.value = n.extent;
                    return false;
                  },
                  child: ResultSheet(
                    controller: _sheet,
                    children: [
                      if (s.runState == WalkRunState.idle)
                        _ReadyPanel(
                          keepScreenOn: settings.keepScreenAwake,
                          onKeepScreenOnChanged: (on) => unawaited(
                            ref
                                .read(settingsProvider.notifier)
                                .change((x) => x.copyWith(keepScreenAwake: on)),
                          ),
                        )
                      else
                        WalkResultPanel(
                          stats: s.stats,
                          elapsedSec: s.elapsedSec,
                          runState: s.runState,
                          areaUnit: areaUnit,
                          distanceUnit: distanceUnit,
                          showSecondary: settings.showSecondaryUnit,
                          onAreaUnitChanged: _walk.setDisplayAreaUnit,
                          onDistanceUnitChanged: _walk.setDisplayDistanceUnit,
                        ),
                      if (s.measurementId case final String id) ...[
                        const SizedBox(height: LmSpacing.s12),
                        PhotoStrip(
                          photos:
                              ref.watch(measurementPhotosProvider(id)).value ??
                              const [],
                          resolve: ref.read(photoStorageProvider).resolve,
                          importing: ref.watch(photoImportsProvider),
                          onAdd: () => unawaited(
                            PhotoFlows.add(
                              context,
                              ref,
                              measurementId: id,
                              location: s.lastFix?.position,
                            ),
                          ),
                          onRemove: (p) => unawaited(
                            PhotoFlows.removeWithUndo(context, ref, p),
                          ),
                          onOpen: (i) => unawaited(
                            context.push(Routes.photosOf(id, index: i)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: ColoredBox(
          color: LmColors.of(context).surfaceSheet,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                LmSpacing.pageH,
                LmSpacing.s8,
                LmSpacing.pageH,
                LmSpacing.s12,
              ),
              child: _actions(s),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actions(WalkState s) {
    final l10n = context.l10n;
    Widget pair(Widget left, Widget right) => Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: LmSpacing.s12),
        Expanded(child: right),
      ],
    );
    final finish = PrimaryCta(
      label: l10n.ctaFinish,
      variant: PrimaryCtaVariant.danger,
      icon: Icons.stop_rounded,
      onPressed: _confirmFinish,
    );
    return switch (s.runState) {
      WalkRunState.idle => PrimaryCta(
        label: l10n.ctaStartWalking,
        variant: PrimaryCtaVariant.walk,
        icon: Icons.directions_walk_rounded,
        loading: _starting,
        onPressed: s.canStart ? _start : null,
      ),
      WalkRunState.recording => pair(
        PrimaryCta(
          label: l10n.ctaPause,
          variant: PrimaryCtaVariant.tonalDanger,
          icon: Icons.pause_rounded,
          onPressed: () => unawaited(_walk.pause()),
        ),
        finish,
      ),
      WalkRunState.paused => pair(
        PrimaryCta(
          label: l10n.ctaResume,
          variant: PrimaryCtaVariant.walk,
          icon: Icons.play_arrow_rounded,
          onPressed: () => unawaited(_walk.resume()),
        ),
        finish,
      ),
      WalkRunState.finished => PrimaryCta(
        label: l10n.ctaSaveMeasurement,
        variant: PrimaryCtaVariant.walk,
        icon: Icons.check_circle_outline_rounded,
        loading: _saving,
        onPressed: s.hasResult ? _save : null,
      ),
    };
  }

  /// Most important first: write failure, location off/denied, mock
  /// location, offline map, then the GPS / recording status.
  Widget? _banner(
    WalkState s, {
    required bool online,
    required bool showAccuracy,
  }) {
    final l10n = context.l10n;
    final accuracy = s.lastFix?.accuracy.round();
    final accuracyText = showAccuracy && accuracy != null
        ? l10n.gpsAccuracyShort(accuracy)
        : null;

    if (s.saveFailed) {
      return StatusBanner(
        kind: StatusBannerKind.warning,
        title: l10n.draftSaveFailed,
      );
    }
    if (s.isFinished) {
      return online
          ? null
          : StatusBanner(
              kind: StatusBannerKind.neutral,
              leading: const Icon(Icons.cloud_off_rounded, size: 20),
              title: l10n.mapOffline,
            );
    }
    switch (s.gps) {
      case GpsStatus.off:
        return StatusBanner(
          kind: StatusBannerKind.error,
          title: l10n.locationOff,
          message: l10n.locationOffMessage,
          actionLabel: l10n.actionOpenSettings,
          onAction: () => unawaited(_walk.fixAccess()),
        );
      case GpsStatus.denied || GpsStatus.deniedForever:
        return StatusBanner(
          kind: StatusBannerKind.error,
          title: l10n.locationDeniedTitle,
          message: l10n.locationDeniedMessage,
          actionLabel: s.gps == GpsStatus.denied
              ? l10n.actionAllow
              : l10n.actionOpenSettings,
          onAction: () => unawaited(
            s.gps == GpsStatus.denied ? _askLocation() : _walk.fixAccess(),
          ),
        );
      case GpsStatus.searching || GpsStatus.ready || GpsStatus.low:
        break;
    }
    if (s.mockDetected) {
      return StatusBanner(
        kind: StatusBannerKind.warning,
        title: l10n.mockLocationDetected,
      );
    }
    if (!online) {
      return StatusBanner(
        kind: StatusBannerKind.neutral,
        leading: const Icon(Icons.cloud_off_rounded, size: 20),
        title: l10n.mapOffline,
      );
    }
    if (s.isPaused) {
      return StatusBanner(
        kind: StatusBannerKind.warning,
        leading: Icon(
          Icons.pause_circle_filled_rounded,
          size: 20,
          color: LmColors.of(context).warning,
        ),
        title: l10n.walkPaused,
        message: l10n.walkPausedMessage,
      );
    }
    final searching = s.gps == GpsStatus.searching;
    final low = s.gps == GpsStatus.low;
    if (s.isRecording) {
      return StatusBanner(
        kind: low ? StatusBannerKind.warning : StatusBannerKind.neutral,
        leading: searching ? const _BannerSpinner() : const _BlinkingDot(),
        title: searching
            ? l10n.gpsSearching
            : [l10n.walkRecording, ?accuracyText].join(' · '),
        message: low && accuracy != null
            ? l10n.gpsLowAccuracyMessage(accuracy)
            : null,
      );
    }
    // Ready screen.
    if (searching) {
      return StatusBanner(
        kind: StatusBannerKind.neutral,
        leading: const _BannerSpinner(),
        title: l10n.gpsSearching,
      );
    }
    if (low) {
      return StatusBanner(
        kind: StatusBannerKind.warning,
        title: l10n.gpsLowAccuracy,
        message: accuracy == null ? null : l10n.gpsLowAccuracyMessage(accuracy),
      );
    }
    return StatusBanner(
      kind: StatusBannerKind.success,
      title: [l10n.gpsReady, ?accuracyText].join(' · '),
    );
  }
}

/// Ready sheet: helper text + quick "Keep screen on" switch (§5.4).
class _ReadyPanel extends StatelessWidget {
  const _ReadyPanel({
    required this.keepScreenOn,
    required this.onKeepScreenOnChanged,
  });

  final bool keepScreenOn;
  final ValueChanged<bool> onKeepScreenOnChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final mode = ModeColors.of(context, MeasurementType.walk);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: mode.container,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.directions_walk_rounded, color: mode.main),
              ),
              const SizedBox(width: LmSpacing.s12),
              Expanded(
                child: Text(
                  l10n.walkReadyHelper,
                  style: LmTypography.bodyMd.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: LmSpacing.s8),
        SwitchListTile(
          value: keepScreenOn,
          onChanged: onKeepScreenOnChanged,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: LmSpacing.pageH,
          ),
          secondary: Icon(
            Icons.light_mode_outlined,
            color: colors.textSecondary,
          ),
          title: Text(
            l10n.keepScreenOn,
            style: LmTypography.bodyMd.copyWith(color: colors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _BannerSpinner extends StatelessWidget {
  const _BannerSpinner();

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 20,
    child: CircularProgressIndicator(
      strokeWidth: 2.5,
      color: LmColors.of(context).textSecondary,
    ),
  );
}

/// Red "recording" dot blinking 1 → 0.3 opacity (1 s), still when the
/// system asks to reduce motion.
class _BlinkingDot extends StatefulWidget {
  const _BlinkingDot();

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    lowerBound: 0.3,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller
        ..stop()
        ..value = 1;
    } else if (!_controller.isAnimating) {
      unawaited(_controller.repeat(reverse: true));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 20,
      child: Center(
        child: FadeTransition(
          opacity: _controller,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: LmColors.of(context).dangerMain,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
