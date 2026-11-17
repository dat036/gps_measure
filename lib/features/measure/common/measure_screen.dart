import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_measurement/core/connectivity/connectivity_service.dart';
import 'package:gps_measurement/core/format/unit_formatter.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/location/location_service.dart';
import 'package:gps_measurement/core/permissions/permission_flows.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/widgets/lm_dialog.dart';
import 'package:gps_measurement/core/widgets/map_fab.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/core/widgets/status_banner.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:gps_measurement/features/edit/edit_controller.dart';
import 'package:gps_measurement/features/edit/edit_details_form.dart';
import 'package:gps_measurement/features/measure/area/area_result_panel.dart';
import 'package:gps_measurement/features/measure/common/center_crosshair.dart';
import 'package:gps_measurement/features/measure/common/leave_measure_guard.dart';
import 'package:gps_measurement/features/measure/common/map_layer_sheet.dart';
import 'package:gps_measurement/features/measure/common/map_snapshot.dart';
import 'package:gps_measurement/features/measure/common/measure_floating_controls.dart';
import 'package:gps_measurement/features/measure/common/measure_help_sheet.dart';
import 'package:gps_measurement/features/measure/common/measure_map_view.dart';
import 'package:gps_measurement/features/measure/common/measure_toolbar.dart';
import 'package:gps_measurement/features/measure/common/photo_strip.dart';
import 'package:gps_measurement/features/measure/common/place_search_sheet.dart';
import 'package:gps_measurement/features/measure/common/point_actions_popup.dart';
import 'package:gps_measurement/features/measure/common/result_sheet.dart';
import 'package:gps_measurement/features/measure/distance/distance_result_panel.dart';
import 'package:gps_measurement/features/measure/session/measure_session_controller.dart';
import 'package:gps_measurement/features/measure/session/measure_session_state.dart';
import 'package:gps_measurement/features/photos/photo_actions.dart';
import 'package:gps_measurement/features/photos/photo_flows.dart';
import 'package:gps_measurement/features/save/pending_thumbnails.dart';
import 'package:gps_measurement/features/settings/app_settings.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/services/ads/interstitial_manager.dart';
import 'package:gps_measurement/services/ads/native_ad_view.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Shared Area/Distance measuring screen (`design.md` §5.2–5.3). The
/// per-mode differences (title, result panel, pill text, trailing toolbar
/// action, CTA) are switched on [type].
///
/// With [editing] it is the Edit screen of a saved measurement ([draftId]
/// is then its id, `design.md` §5.9): nothing is written until "Save
/// Changes", the sheet gains a Details tab, and leaving with changes asks
/// "Discard changes?".
class MeasureScreen extends ConsumerStatefulWidget {
  const MeasureScreen({
    required this.type,
    this.draftId,
    this.editing = false,
    super.key,
  }) : assert(type != MeasurementType.walk, 'Walk has its own screen'),
       assert(!editing || draftId != null, 'Edit needs the measurement id');

  final MeasurementType type;
  final String? draftId;
  final bool editing;

  @override
  ConsumerState<MeasureScreen> createState() => _MeasureScreenState();
}

class _MeasureScreenState extends ConsumerState<MeasureScreen> {
  /// Camera when there is no draft and no location permission.
  static const _hanoi = CameraPosition(
    target: LatLng(21.0285, 105.8542),
    zoom: 15,
  );
  static const _world = CameraPosition(target: LatLng(20, 0), zoom: 2);

  /// Accuracy above which a GPS point is added with a warning.
  static const double lowAccuracyM = 20;

  /// Space reserved for the floating toolbar above the collapsed sheet.
  static const double _toolbarArea = MeasureToolbar.height + 24;

  GoogleMapController? _map;
  CameraPosition? _initialCamera;
  LatLng? _cameraTarget;
  double _cameraZoom = 17;
  bool _myLocationEnabled = false;
  bool _locating = false;
  bool _saving = false;

  /// Edit: 0 = Result, 1 = Details.
  int _tab = 0;

  /// Map size and bottom padding of the last layout (thumbnail crop).
  double _mapHeight = 1;
  double _mapBottomPadding = 0;
  final ValueNotifier<bool> _cameraMoving = ValueNotifier(false);
  final ValueNotifier<double> _sheetExtent = ValueNotifier(
    ResultSheet.defaultSize,
  );
  late final AppLifecycleListener _lifecycle;

  MeasurementType get type => widget.type;
  bool get _isArea => type == MeasurementType.area;

  MeasureSessionControllerProvider get _provider =>
      measureSessionControllerProvider(
        type,
        widget.draftId,
        editing: widget.editing,
      );

  EditControllerProvider get _edit => editControllerProvider(widget.draftId!);

  MeasureSessionController get _session => ref.read(_provider.notifier);

  @override
  void initState() {
    super.initState();
    // Never lose points: write the draft as soon as the app leaves the
    // foreground (architecture.md §13).
    _lifecycle = AppLifecycleListener(
      onHide: () => unawaited(_session.flushNow()),
      onPause: () => unawaited(_session.flushNow()),
    );
    // Keep Screen Awake setting (P4-08), live while on this screen.
    ref.listenManual(
      settingsProvider.select((s) => s.keepScreenAwake),
      (_, awake) => unawaited(WakelockPlus.toggle(enable: awake)),
      fireImmediately: true,
    );
    // Next to save: have the interstitial ready by then.
    ref.read(interstitialManagerProvider).preload();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      // Detail page's native ad (a new measurement; Edit has none to come).
      if (!widget.editing) {
        NativeAdPlacements.preloadDetail(context, ref, type);
      }
      await _prepareCamera();
      if (mounted) _maybeShowHelp();
    });
  }

  @override
  void dispose() {
    unawaited(WakelockPlus.disable());
    _lifecycle.dispose();
    _cameraMoving.dispose();
    _sheetExtent.dispose();
    super.dispose();
  }

  /// Help opens by itself the first time each mode is used (§5.18).
  void _maybeShowHelp() {
    final settings = ref.read(settingsRepositoryProvider);
    if (!mounted || widget.editing || settings.helpSeen(type)) return;
    unawaited(settings.setHelpSeen(type));
    unawaited(showMeasureHelpSheet(context, type));
  }

  // ------------------------------------------------------------- camera

  /// Existing shape → framed. Otherwise with Auto Center Map on, the
  /// user's position; off, where the map was left last time.
  Future<void> _prepareCamera() async {
    final location = ref.read(locationServiceProvider);
    final isVietnamese =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'vi';
    final session = await ref.read(_provider.future);
    if (!mounted) return;
    final access = widget.editing
        ? await location.ensureAccess(request: false)
        : await PermissionFlows.location(
            context,
            ref,
            message: context.l10n.locationPermissionMeasureMessage,
          );
    if (!mounted) return;
    final granted = access == LocationAccess.granted;
    final bounds = GeoCalculator.bounds(session.points.map((p) => p.position));
    final saved = ref.read(settingsProvider).autoCenter
        ? null
        : ref.read(settingsRepositoryProvider).lastMapCamera;
    var position = granted && bounds == null && saved == null
        ? await location.lastKnown()
        : null;
    // A cached fix can be far from where the user is now. Resolve a fresh
    // fix before creating the map so centering cannot race onMapCreated.
    if (granted && bounds == null && saved == null) {
      try {
        position = (await location.current()).position;
      } on LocationException {
        // A cached fix (or the default camera) still allows manual measuring.
      }
    }
    if (!mounted) return;

    CameraPosition camera;
    if (bounds != null) {
      camera = CameraPosition(
        target: LatLng(bounds.center.lat, bounds.center.lng),
        zoom: 17,
      );
    } else if (saved != null) {
      camera = CameraPosition(
        target: LatLng(saved.lat, saved.lng),
        zoom: saved.zoom,
      );
    } else if (position != null) {
      camera = CameraPosition(
        target: LatLng(position.lat, position.lng),
        zoom: 17,
      );
    } else {
      final localeIsVi =
          isVietnamese || ref.read(settingsProvider).localeCode == 'vi';
      camera = localeIsVi ? _hanoi : _world;
    }
    if (!mounted) return;
    setState(() {
      _initialCamera = camera;
      _cameraTarget = camera.target;
      _myLocationEnabled = granted;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _map = controller;
    final points = ref.read(_provider).value?.points ?? const [];
    final b = GeoCalculator.bounds(points.map((p) => p.position));
    if (b != null && points.length > 1) {
      unawaited(
        controller.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(b.minLat, b.minLng),
              northeast: LatLng(b.maxLat, b.maxLng),
            ),
            64,
          ),
        ),
      );
    }
  }

  /// Remembered for Auto Center Map off (next measurement opens here).
  void _onCameraIdle() {
    _cameraMoving.value = false;
    final t = _cameraTarget;
    if (t == null) return;
    unawaited(
      ref
          .read(settingsRepositoryProvider)
          .setLastMapCamera(t.latitude, t.longitude, _cameraZoom),
    );
  }

  void _animateTo(GeoPoint p, {double zoom = 18}) => unawaited(
    _map?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(p.lat, p.lng), zoom)),
  );

  // ------------------------------------------------------------- actions

  void _added(bool ok) {
    if (ok) unawaited(HapticFeedback.lightImpact());
  }

  void _addAtCrosshair() {
    final t = _cameraTarget;
    if (t == null) return;
    _added(_session.addPointAt(GeoPoint(lat: t.latitude, lng: t.longitude)));
  }

  bool get _tapMode => ref.read(settingsProvider).inputMode == InputMode.tap;

  void _onMapTap(GeoPoint at) {
    final s = ref.read(_provider).value;
    if (s == null) return;
    if (_tapMode && s.canAddPoint) {
      _added(_session.addPointAt(at, method: AddPointMethod.tap));
    } else if (s.selectedPointId != null) {
      _session.selectPoint(null);
    }
  }

  /// In tap mode a tap landing on an edge chip splits that edge instead of
  /// being swallowed by the chip.
  void _onEdgeLabelTap(int insertIndex, GeoPoint midpoint) {
    final s = ref.read(_provider).value;
    if (s == null || !_tapMode || !s.canAddPoint) return;
    _added(
      _session.addPointAt(
        midpoint,
        method: AddPointMethod.tap,
        atIndex: insertIndex,
      ),
    );
  }

  /// Returns a fix, or null after telling the user why not.
  Future<GeoPoint?> _currentFix({bool addAsPoint = false}) async {
    final l10n = context.l10n;
    final location = ref.read(locationServiceProvider);
    final access = await PermissionFlows.location(
      context,
      ref,
      message: l10n.locationPermissionMeasureMessage,
    );
    if (!mounted) return null;
    if (access != LocationAccess.granted) {
      _snack(
        access == LocationAccess.serviceDisabled
            ? l10n.locationServiceOff
            : l10n.locationPermissionDenied,
      );
      return null;
    }
    setState(() {
      _myLocationEnabled = true;
      _locating = addAsPoint;
    });
    try {
      final fix = await location.current();
      if (!mounted) return null;
      if (addAsPoint) {
        final ok = _session.addPointAt(
          fix.position,
          method: AddPointMethod.gps,
          accuracy: fix.accuracy,
        );
        _added(ok);
        if (ok && fix.accuracy > lowAccuracyM) {
          _snack(l10n.gpsLowAccuracyAdded(fix.accuracy.round()));
        }
      }
      return fix.position;
    } on LocationException {
      if (mounted) _snack(l10n.locationUnavailable);
      return null;
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _addAtMyLocation() async {
    final p = await _currentFix(addAsPoint: true);
    if (p != null) _animateTo(p);
  }

  Future<void> _goToMyLocation() async {
    final p = await _currentFix();
    if (p != null) _animateTo(p);
  }

  Future<void> _search() async {
    final place = await showPlaceSearchSheet(context);
    if (place != null) _animateTo(place.point, zoom: place.isExact ? 18 : 16);
  }

  Future<void> _pickMapStyle(MapStyle current) async {
    final style = await showMapLayerSheet(context, ref, current: current);
    if (style == null) return;
    _session.setMapStyle(style);
    // Also the default for the next measurement (P4-03).
    await ref
        .read(settingsProvider.notifier)
        .change((s) => s.copyWith(mapStyle: style));
  }

  Future<void> _confirmReset() async {
    final l10n = context.l10n;
    final ok = await showLmConfirm(
      context,
      title: l10n.dialogResetTitle,
      message: l10n.dialogResetMessage,
      confirmLabel: l10n.actionReset,
      cancelLabel: l10n.actionCancel,
      destructive: true,
    );
    if (ok) _session.reset();
  }

  /// Flush, snapshot the framed shape for the thumbnail, open Save.
  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      _session.selectPoint(null);
      await _session.flushNow();
      final s = ref.read(_provider).value;
      final id = s?.measurementId;
      if (s == null || id == null || !mounted) return;
      final png = await captureMapThumbnail(
        _map,
        s.points.map((p) => p.position),
        mapHeight: _mapHeight,
        visibleHeight: _mapHeight - _mapBottomPadding,
      );
      if (png != null) ref.read(pendingThumbnailsProvider).put(id, png);
      if (!mounted) return;
      await context.push(Routes.saveOf(id));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ------------------------------------------------------------- photos

  /// Add Photo; [pointId] attaches it to that (selected) point. Creates the
  /// draft first when there is none yet.
  Future<void> _addPhoto({String? pointId}) async {
    final String id;
    try {
      id = await _session.ensureDraft();
    } on AppException {
      if (mounted) _snack(context.l10n.draftSaveFailed);
      return;
    }
    if (!mounted) return;
    final points = ref.read(_provider).value?.points ?? const [];
    final index = pointId == null
        ? -1
        : points.indexWhere((p) => p.id == pointId);
    final added = await PhotoFlows.add(
      context,
      ref,
      measurementId: id,
      pointId: index < 0 ? null : pointId,
      pointNumber: index < 0 ? null : index + 1,
      location: index < 0 ? null : points[index].position,
    );
    if (widget.editing && added.isNotEmpty) {
      ref.read(_edit.notifier).photosAdded(added);
    }
  }

  void _removePhoto(Photo photo) {
    if (!widget.editing) {
      unawaited(PhotoFlows.removeWithUndo(context, ref, photo));
      return;
    }
    final l10n = context.l10n;
    final edit = ref.read(_edit.notifier)..removePhoto(photo);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.photoRemoved),
          persist: false,
          action: SnackBarAction(
            label: l10n.actionUndo,
            onPressed: () => edit.undoRemovePhoto(photo),
          ),
        ),
      );
  }

  // ------------------------------------------------------------- edit

  bool _dirty(MeasureSessionState s, EditState? e) =>
      s.geometryChanged || (e?.detailsChanged ?? false);

  Future<void> _saveChanges() async {
    final s = ref.read(_provider).value;
    final e = ref.read(_edit).value;
    if (s == null || e == null || _saving) return;
    setState(() => _saving = true);
    try {
      _session.selectPoint(null);
      final png = s.geometryChanged
          ? await captureMapThumbnail(
              _map,
              s.points.map((p) => p.position),
              mapHeight: _mapHeight,
              visibleHeight: _mapHeight - _mapBottomPadding,
            )
          : null;
      final ok = await ref
          .read(_edit.notifier)
          .saveChanges(
            points: s.geometryChanged ? s.points : null,
            stats: s.geometryChanged ? s.stats : null,
            snapshot: png,
          );
      if (!mounted) return;
      if (!ok) {
        _snack(context.l10n.saveFailed);
        return;
      }
      // The thumbnail file keeps its path: drop cached decodes.
      PaintingBinding.instance.imageCache
        ..clear()
        ..clearLiveImages();
      final messenger = ScaffoldMessenger.of(context);
      final l10n = context.l10n;
      final navigator = Navigator.of(context);
      // Interstitial after Save Changes (at most one per 30 s), then leave.
      await ref.read(interstitialManagerProvider).showIfReady();
      if (!mounted) return;
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(l10n.changesSaved)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Back with unsaved changes: "Discard changes?".
  Future<void> _confirmDiscard() async {
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final discard = await showLmConfirm(
      context,
      title: l10n.dialogDiscardChangesTitle,
      message: l10n.dialogDiscardChangesMessage,
      confirmLabel: l10n.actionDiscard,
      cancelLabel: l10n.actionKeepEditing,
      destructive: true,
    );
    if (!discard) return;
    await ref.read(_edit.notifier).discard();
    _discarded = true;
    if (mounted) setState(() {});
    navigator.pop();
  }

  /// Set once the user chose Discard, so the pop is no longer blocked.
  bool _discarded = false;

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = widget.editing
        ? l10n.screenEdit
        : _isArea
        ? l10n.screenMeasureArea
        : l10n.screenMeasureDistance;
    final session = ref.watch(_provider);
    final edit = widget.editing ? ref.watch(_edit) : null;
    final settings = ref.watch(settingsProvider);
    final online = ref.watch(isOnlineProvider).value ?? true;
    final camera = _initialCamera;
    final s = session.value;
    final e = edit?.value;

    if (s == null || camera == null || (widget.editing && e == null)) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final locale = Localizations.localeOf(context).toString();
    final areaUnit = s.displayAreaUnit ?? settings.areaUnit;
    final distanceUnit = s.displayDistanceUnit ?? settings.distanceUnit;
    final crosshairMode = settings.inputMode == InputMode.crosshair;
    final banner = _banner(s, crosshairMode: crosshairMode, online: online);
    final id = s.measurementId;
    final stored = id == null
        ? const <Photo>[]
        : ref.watch(measurementPhotosProvider(id)).value ?? const <Photo>[];
    final photos = widget.editing
        ? ref.read(_edit.notifier).visible(stored)
        : stored;
    final pointNumbers = {
      for (final (i, p) in s.points.indexed) p.id: i + 1,
    };
    final dirty = _dirty(s, e);

    final scaffold = Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: l10n.menuHelp,
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () => unawaited(showMeasureHelpSheet(context, type)),
          ),
          _overflowMenu(s, settings),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final mapBottomPadding = height * ResultSheet.minSize + _toolbarArea;
          _mapHeight = height;
          _mapBottomPadding = mapBottomPadding;
          return Stack(
            children: [
              Positioned.fill(
                child: MeasureMapView(
                  type: type,
                  points: s.points,
                  isClosed: s.isClosed,
                  selfIntersects: s.stats.selfIntersects,
                  selectedPointId: s.selectedPointId,
                  photoPointIds: {
                    for (final p in photos)
                      if (p.pointId != null) p.pointId!,
                  },
                  mapStyle: s.mapStyle,
                  initialCamera: camera,
                  bottomPadding: mapBottomPadding,
                  myLocationEnabled: _myLocationEnabled,
                  resultLabel: _resultLabel(
                    s,
                    areaUnit,
                    distanceUnit,
                    locale,
                    settings.showSecondaryUnit,
                  ),
                  edgeLabelOf: settings.showEdgeLabels
                      ? (m) => UnitFormatter.distance(m, distanceUnit, locale)
                      : null,
                  onMapCreated: _onMapCreated,
                  onCameraMove: (p) {
                    _cameraTarget = p.target;
                    _cameraZoom = p.zoom;
                    if (!_cameraMoving.value) _cameraMoving.value = true;
                  },
                  onCameraIdle: _onCameraIdle,
                  onTap: _onMapTap,
                  onPointTap: _session.selectPoint,
                  onPointDragEnd: _session.movePoint,
                  onEdgeLabelTap: _onEdgeLabelTap,
                ),
              ),
              if (crosshairMode && s.canAddPoint)
                Positioned(
                  left: 0,
                  right: 0,
                  top: (height - mapBottomPadding - CenterCrosshair.size) / 2,
                  child: Center(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _cameraMoving,
                      builder: (_, moving, _) =>
                          CenterCrosshair(moving: moving),
                    ),
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
                    tooltip: l10n.fabMyLocation,
                    onPressed: _goToMyLocation,
                  ),
                  MapFab(
                    icon: Icons.search_rounded,
                    tooltip: l10n.fabSearch,
                    onPressed: _search,
                  ),
                ],
                cameraFab: MapFab(
                  icon: Icons.photo_camera_rounded,
                  tooltip: l10n.fabCamera,
                  large: true,
                  onPressed: () => unawaited(_addPhoto()),
                ),
                bottom: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (s.selectedIndex case final int index) ...[
                      Center(
                        child: PointActionsPopup(
                          pointNumber: index + 1,
                          onPhoto: () => unawaited(
                            _addPhoto(pointId: s.selectedPointId),
                          ),
                          onDelete: _session.deleteSelected,
                          onDone: () => _session.selectPoint(null),
                        ),
                      ),
                      const SizedBox(height: LmSpacing.s8),
                    ],
                    MeasureToolbar(
                      type: type,
                      locating: _locating,
                      onUndo: s.canUndo ? _session.undo : null,
                      onAddAtMyLocation: s.canAddPoint && !_locating
                          ? _addAtMyLocation
                          : null,
                      onAddPoint: crosshairMode && s.canAddPoint
                          ? _addAtCrosshair
                          : null,
                      onTrailing: _isArea
                          ? (s.canClose ? _session.closeShape : null)
                          : (s.points.isNotEmpty ? _confirmReset : null),
                    ),
                  ],
                ),
              ),
              NotificationListener<DraggableScrollableNotification>(
                onNotification: (n) {
                  _sheetExtent.value = n.extent;
                  return false;
                },
                child: ResultSheet(
                  children: [
                    if (widget.editing) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          LmSpacing.pageH,
                          0,
                          LmSpacing.pageH,
                          LmSpacing.s12,
                        ),
                        child: SegmentedButton<int>(
                          showSelectedIcon: false,
                          segments: [
                            ButtonSegment(
                              value: 0,
                              label: Text(l10n.editTabResult),
                            ),
                            ButtonSegment(
                              value: 1,
                              label: Text(l10n.editTabDetails),
                            ),
                          ],
                          selected: {_tab},
                          onSelectionChanged: (v) =>
                              setState(() => _tab = v.first),
                        ),
                      ),
                    ],
                    if (widget.editing && _tab == 1)
                      EditDetailsForm(
                        measurementId: widget.draftId!,
                        points: s.points,
                      )
                    else if (_isArea)
                      AreaResultPanel(
                        stats: s.stats,
                        areaUnit: areaUnit,
                        distanceUnit: distanceUnit,
                        showSecondary: settings.showSecondaryUnit,
                        onAreaUnitChanged: _session.setDisplayAreaUnit,
                      )
                    else
                      DistanceResultPanel(
                        stats: s.stats,
                        points: s.points,
                        distanceUnit: distanceUnit,
                        showSecondary: settings.showSecondaryUnit,
                        onDistanceUnitChanged: _session.setDisplayDistanceUnit,
                      ),
                    if (!widget.editing && id != null) ...[
                      const SizedBox(height: LmSpacing.s12),
                      PhotoStrip(
                        photos: photos,
                        resolve: ref.read(photoStorageProvider).resolve,
                        pointNumbers: pointNumbers,
                        importing: ref.watch(photoImportsProvider),
                        onAdd: () => unawaited(_addPhoto()),
                        onRemove: _removePhoto,
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
            child: widget.editing
                ? PrimaryCta(
                    label: l10n.ctaSaveChanges,
                    variant: PrimaryCtaVariant.forMode(type),
                    icon: Icons.check_circle_outline_rounded,
                    loading: _saving || (e?.saving ?? false),
                    onPressed: dirty && s.hasResult && (e?.nameValid ?? false)
                        ? () => unawaited(_saveChanges())
                        : null,
                  )
                : PrimaryCta(
                    label: _isArea
                        ? l10n.ctaSaveMeasurement
                        : l10n.ctaSaveRoute,
                    variant: PrimaryCtaVariant.forMode(type),
                    icon: Icons.check_circle_outline_rounded,
                    loading: _saving,
                    onPressed: s.hasResult ? _save : null,
                  ),
          ),
        ),
      ),
    );

    if (widget.editing) {
      return PopScope<Object?>(
        canPop: !dirty || _discarded,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) unawaited(_confirmDiscard());
        },
        child: scaffold,
      );
    }
    return LeaveMeasureGuard(
      type: type,
      onLeave: _session.flushAndDescribe,
      child: scaffold,
    );
  }

  ResultLabel? _resultLabel(
    MeasureSessionState s,
    AreaUnit areaUnit,
    DistanceUnit distanceUnit,
    String locale,
    bool showSecondary,
  ) {
    if (_isArea) {
      final area = s.stats.areaM2;
      return area == null
          ? null
          : UnitFormatter.areaWithSecondary(
              area,
              areaUnit,
              locale,
              secondary: showSecondary,
            );
    }
    final distance = s.stats.distanceM;
    return distance == null
        ? null
        : (
            primary: UnitFormatter.distance(distance, distanceUnit, locale),
            secondary: null,
          );
  }

  /// Most important first: save failure, offline, crossing edges, hint.
  Widget? _banner(
    MeasureSessionState s, {
    required bool crosshairMode,
    required bool online,
  }) {
    final l10n = context.l10n;
    if (s.saveFailed) {
      return StatusBanner(
        kind: StatusBannerKind.warning,
        title: l10n.draftSaveFailed,
      );
    }
    if (!online) {
      return StatusBanner(
        kind: StatusBannerKind.neutral,
        leading: const Icon(Icons.cloud_off_rounded, size: 20),
        title: l10n.mapOffline,
      );
    }
    if (s.stats.selfIntersects) {
      return StatusBanner(
        kind: StatusBannerKind.warning,
        title: l10n.edgesCross,
      );
    }
    if (s.points.isEmpty) {
      return StatusBanner(
        kind: StatusBannerKind.neutral,
        leading: Icon(
          crosshairMode ? Icons.add_rounded : Icons.touch_app_outlined,
          size: 20,
        ),
        title: helpSummary(context, type),
        message: crosshairMode
            ? l10n.measureHintCrosshair
            : l10n.measureHintTap,
      );
    }
    return null;
  }

  Widget _overflowMenu(MeasureSessionState s, AppSettings current) {
    final l10n = context.l10n;
    final settings = ref.read(settingsProvider.notifier);
    return PopupMenuButton<_MenuAction>(
      tooltip: l10n.menuMore,
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (action) => switch (action) {
        _MenuAction.reset => unawaited(_confirmReset()),
        _MenuAction.reopen => _session.reopenShape(),
        _MenuAction.crosshair => unawaited(
          settings.change((x) => x.copyWith(inputMode: InputMode.crosshair)),
        ),
        _MenuAction.tap => unawaited(
          settings.change((x) => x.copyWith(inputMode: InputMode.tap)),
        ),
        _MenuAction.edgeLabels => unawaited(
          settings.change(
            (x) => x.copyWith(showEdgeLabels: !current.showEdgeLabels),
          ),
        ),
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _MenuAction.reset,
          enabled: s.points.isNotEmpty,
          child: Text(l10n.actionReset),
        ),
        // A closed Area takes no new points; reopen to add some.
        if (_isArea && s.isClosed)
          PopupMenuItem(
            value: _MenuAction.reopen,
            child: Text(l10n.menuReopenShape),
          ),
        const PopupMenuDivider(),
        CheckedPopupMenuItem(
          value: _MenuAction.crosshair,
          checked: current.inputMode == InputMode.crosshair,
          child: Text(l10n.menuInputCrosshair),
        ),
        CheckedPopupMenuItem(
          value: _MenuAction.tap,
          checked: current.inputMode == InputMode.tap,
          child: Text(l10n.menuInputTap),
        ),
        const PopupMenuDivider(),
        CheckedPopupMenuItem(
          value: _MenuAction.edgeLabels,
          checked: current.showEdgeLabels,
          child: Text(l10n.menuShowEdgeLabels),
        ),
      ],
    );
  }
}

enum _MenuAction { reset, reopen, crosshair, tap, edgeLabels }
