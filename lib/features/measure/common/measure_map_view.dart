import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/utils/throttler.dart';
import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/features/measure/common/map_style_mapper.dart';
import 'package:gps_measurement/features/measure/common/marker_factory.dart';

/// Text of the result pill (primary + optional secondary line).
typedef ResultLabel = ({String primary, String? secondary});

/// Google Map showing an Area polygon or a Distance polyline with draggable
/// point handles, edge-length chips and a result pill (`design.md` §2.4–2.6,
/// §5.2–5.3).
///
/// Geometry comes from the session controller; while a handle is dragged
/// the shape follows locally (throttled 30 ms) and the controller only gets
/// the final position on drag end.
class MeasureMapView extends StatefulWidget {
  const MeasureMapView({
    required this.type,
    required this.points,
    required this.initialCamera,
    required this.mapStyle,
    this.isClosed = false,
    this.selfIntersects = false,
    this.selectedPointId,
    this.photoPointIds = const {},
    this.resultLabel,
    this.edgeLabelOf,
    this.bottomPadding = 0,
    this.myLocationEnabled = false,
    this.onMapCreated,
    this.onCameraMove,
    this.onCameraIdle,
    this.onTap,
    this.onPointTap,
    this.onPointDragEnd,
    this.onEdgeLabelTap,
    this.readOnly = false,
    super.key,
  });

  final MeasurementType type;
  final List<MeasurePoint> points;
  final CameraPosition initialCamera;
  final MapStyle mapStyle;
  final bool isClosed;
  final bool selfIntersects;
  final String? selectedPointId;

  /// Points with an attached photo get a camera badge.
  final Set<String> photoPointIds;
  final ResultLabel? resultLabel;

  /// Formats an edge length (meters); null hides edge labels.
  final String Function(double meters)? edgeLabelOf;

  /// Space covered by the sheet/toolbar; keeps the camera target (and the
  /// crosshair) centered in the visible part of the map.
  final double bottomPadding;
  final bool myLocationEnabled;
  final ValueChanged<GoogleMapController>? onMapCreated;
  final ValueChanged<CameraPosition>? onCameraMove;
  final VoidCallback? onCameraIdle;
  final ValueChanged<GeoPoint>? onTap;
  final ValueChanged<String>? onPointTap;
  final void Function(String id, GeoPoint position)? onPointDragEnd;

  /// Tap on an edge-length chip, with the index where a point placed at
  /// the chip's midpoint belongs to split that edge. Null: taps ignored.
  final void Function(int insertIndex, GeoPoint midpoint)? onEdgeLabelTap;

  /// Full map from Detail: nothing can be dragged or selected.
  final bool readOnly;

  /// Edge chips are hidden below this zoom or when the edge is shorter than
  /// [minEdgeLabelPx] on screen.
  static const double minEdgeLabelZoom = 15;
  static const double minEdgeLabelPx = 40;

  @override
  State<MeasureMapView> createState() => _MeasureMapViewState();
}

class _MeasureMapViewState extends State<MeasureMapView> {
  MarkerFactory? _factory;
  Set<Marker> _markers = const {};
  int _markerGeneration = 0;
  String? _mapStyleJson;
  late double _zoom = widget.initialCamera.zoom;

  /// Live position of the handle being dragged.
  final Map<String, LatLng> _dragging = {};
  final Throttler _dragThrottle = Throttler(const Duration(milliseconds: 30));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final colors = LmColors.of(context);
    if (_factory?.devicePixelRatio != dpr || _factory?.colors != colors) {
      _factory = MarkerFactory(devicePixelRatio: dpr, colors: colors);
      unawaited(_rebuildMarkers());
    }
    unawaited(_loadStyle());
  }

  @override
  void didUpdateWidget(MeasureMapView old) {
    super.didUpdateWidget(old);
    if (old.points != widget.points ||
        old.selectedPointId != widget.selectedPointId ||
        old.resultLabel != widget.resultLabel ||
        old.isClosed != widget.isClosed ||
        old.photoPointIds != widget.photoPointIds ||
        (old.edgeLabelOf == null) != (widget.edgeLabelOf == null)) {
      _dragging.clear();
      unawaited(_rebuildMarkers());
    }
    if (old.mapStyle != widget.mapStyle) unawaited(_loadStyle());
  }

  @override
  void dispose() {
    _dragThrottle.dispose();
    super.dispose();
  }

  Future<void> _loadStyle() async {
    final json = await MapStyleMapper.styleFor(
      widget.mapStyle,
      Theme.of(context).brightness,
    );
    if (mounted && json != _mapStyleJson) setState(() => _mapStyleJson = json);
  }

  LatLng _latLng(MeasurePoint p) => _dragging[p.id] ?? LatLng(p.lat, p.lng);

  List<LatLng> get _path => [for (final p in widget.points) _latLng(p)];

  static GeoPoint _geo(LatLng l) => GeoPoint(lat: l.latitude, lng: l.longitude);

  // ------------------------------------------------------------ markers

  Future<void> _rebuildMarkers() async {
    final factory = _factory;
    if (factory == null) return;
    final generation = ++_markerGeneration;
    final w = widget;
    final mode = ModeColors.of(context, w.type);
    final pts = w.points;
    final markers = <Marker>{};

    for (final (i, p) in pts.indexed) {
      final isDistance = w.type == MeasurementType.distance;
      final isStart = isDistance && i == 0;
      final isEnd = isDistance && i == pts.length - 1 && pts.length > 1;
      final selected = p.id == w.selectedPointId;
      final icon = isEnd
          ? await factory.endPin()
          : isStart
          ? await factory.startDot()
          : await factory.pointHandle(
              color: mode.main,
              selected: selected,
              hasPhoto: w.photoPointIds.contains(p.id),
            );
      markers.add(
        Marker(
          markerId: MarkerId(p.id),
          position: LatLng(p.lat, p.lng),
          icon: icon,
          anchor: isEnd
              ? MarkerFactory.bottomAnchor
              : MarkerFactory.centerAnchor,
          draggable: !w.readOnly,
          consumeTapEvents: true,
          zIndexInt: selected ? 3 : 2,
          onTap: w.readOnly ? null : () => w.onPointTap?.call(p.id),
          onDrag: (pos) => _onDrag(p.id, pos),
          onDragEnd: (pos) => _onDragEnd(p.id, pos),
        ),
      );
    }

    markers.addAll(await _edgeMarkers(factory));

    final label = w.resultLabel;
    final labelAt = _labelPosition();
    if (label != null && labelAt != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('result'),
          position: LatLng(labelAt.lat, labelAt.lng),
          icon: await factory.resultPill(label.primary, label.secondary),
          // A route's midpoint is often a vertex: lift the pill above the
          // line so the point handle stays visible.
          anchor: w.type == MeasurementType.distance
              ? MarkerFactory.aboveAnchor
              : MarkerFactory.centerAnchor,
          zIndexInt: 1,
          consumeTapEvents: true,
        ),
      );
    }

    if (mounted && generation == _markerGeneration) {
      setState(() => _markers = markers);
    }
  }

  GeoPoint? _labelPosition() {
    final pts = [for (final p in widget.points) p.position];
    return switch (widget.type) {
      MeasurementType.area when pts.length >= 3 => GeoCalculator.centroid(
        pts,
      ),
      MeasurementType.distance when pts.length >= 2 =>
        GeoCalculator.midpointAlongPath(pts),
      _ => null,
    };
  }

  Future<List<Marker>> _edgeMarkers(MarkerFactory factory) async {
    final format = widget.edgeLabelOf;
    final pts = widget.points;
    if (format == null ||
        pts.length < 2 ||
        _zoom < MeasureMapView.minEdgeLabelZoom) {
      return const [];
    }
    final closedRing = widget.type == MeasurementType.area && pts.length >= 3;
    final edges = [
      for (var i = 0; i < pts.length - 1; i++) (pts[i], pts[i + 1]),
      if (closedRing) (pts.last, pts.first),
    ];
    // Meters per screen pixel at this zoom (Web Mercator).
    final lat = pts.first.lat * math.pi / 180;
    final metersPerPx = 156543.03392 * math.cos(lat) / math.pow(2, _zoom);

    final result = <Marker>[];
    for (final (i, (a, b)) in edges.indexed) {
      final length = GeoCalculator.distance(a.position, b.position);
      if (length / metersPerPx < MeasureMapView.minEdgeLabelPx) continue;
      final mid = GeoCalculator.interpolate(a.position, b.position, 0.5);
      result.add(
        Marker(
          markerId: MarkerId('edge$i'),
          position: LatLng(mid.lat, mid.lng),
          icon: await factory.edgeLabel(format(length)),
          anchor: MarkerFactory.centerAnchor,
          consumeTapEvents: true,
          onTap: () => widget.onEdgeLabelTap?.call(i + 1, mid),
        ),
      );
    }
    return result;
  }

  // ------------------------------------------------------------ dragging

  void _onDrag(String id, LatLng pos) {
    _dragThrottle.run(() {
      if (mounted) setState(() => _dragging[id] = pos);
    });
  }

  void _onDragEnd(String id, LatLng pos) {
    _dragThrottle.cancel();
    setState(() => _dragging[id] = pos);
    widget.onPointDragEnd?.call(id, _geo(pos));
  }

  // ------------------------------------------------------------ shapes

  Set<Polygon> _polygons(ModeColors mode) {
    if (widget.type != MeasurementType.area || widget.points.length < 3) {
      return const {};
    }
    return {
      Polygon(
        polygonId: const PolygonId('area'),
        points: _path,
        fillColor: mode.fill,
        strokeColor: widget.selfIntersects ? Colors.transparent : mode.main,
        strokeWidth: 3,
      ),
    };
  }

  Set<Polyline> _polylines(ModeColors mode, LmColors colors) {
    final path = _path;
    if (path.length < 2) return const {};
    return switch (widget.type) {
      MeasurementType.area when widget.selfIntersects && path.length >= 3 => {
        // Dashed yellow outline warns that the area may be wrong.
        Polyline(
          polylineId: const PolylineId('warning'),
          points: [...path, path.first],
          color: colors.warning,
          width: 4,
          patterns: [PatternItem.dash(18), PatternItem.gap(10)],
        ),
      },
      MeasurementType.area when path.length == 2 => {
        Polyline(
          polylineId: const PolylineId('edge'),
          points: path,
          color: mode.main,
          width: 3,
        ),
      },
      MeasurementType.distance => {
        Polyline(
          polylineId: const PolylineId('route'),
          points: path,
          color: mode.main,
          width: 5,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      },
      _ => const {},
    };
  }

  @override
  Widget build(BuildContext context) {
    final mode = ModeColors.of(context, widget.type);
    final colors = LmColors.of(context);
    return RepaintBoundary(
      child: GoogleMap(
        initialCameraPosition: widget.initialCamera,
        mapType: MapStyleMapper.mapType(widget.mapStyle),
        style: _mapStyleJson,
        polygons: _polygons(mode),
        polylines: _polylines(mode, colors),
        markers: _markers,
        padding: EdgeInsets.only(bottom: widget.bottomPadding),
        myLocationEnabled: widget.myLocationEnabled,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        tiltGesturesEnabled: false,
        buildingsEnabled: false,
        onMapCreated: widget.onMapCreated,
        onTap: widget.onTap == null ? null : (l) => widget.onTap!(_geo(l)),
        onCameraMove: (position) {
          _zoom = position.zoom;
          widget.onCameraMove?.call(position);
        },
        onCameraIdle: () {
          unawaited(_rebuildMarkers()); // edge chips depend on zoom
          widget.onCameraIdle?.call();
        },
      ),
    );
  }
}
