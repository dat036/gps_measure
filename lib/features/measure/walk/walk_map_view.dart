import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/domain/geo/path_simplifier.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/location_fix.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/features/measure/common/map_style_mapper.dart';
import 'package:gps_measurement/features/measure/common/marker_factory.dart';

/// Walk map (`design.md` §2.5, §5.4–5.5): orange track drawn per segment
/// (never joined across a Pause), green fill once the loop is closed, a
/// circle around Start showing the closing distance, and the current
/// position as a blue dot with its accuracy halo.
///
/// Reports the user's own pan ([onUserPan]) so the screen can stop
/// following.
class WalkMapView extends StatefulWidget {
  const WalkMapView({
    required this.points,
    required this.initialCamera,
    required this.mapStyle,
    this.isClosed = false,
    this.closureThresholdM,
    this.lastFix,
    this.showAccuracy = true,
    this.finished = false,
    this.bottomPadding = 0,
    this.onMapCreated,
    this.onUserPan,
    super.key,
  });

  final List<MeasurePoint> points;
  final CameraPosition initialCamera;
  final MapStyle mapStyle;
  final bool isClosed;

  /// Radius of the circle around Start; null hides it.
  final double? closureThresholdM;
  final LocationFix? lastFix;

  /// Accuracy halo (setting "GPS Accuracy Display").
  final bool showAccuracy;

  /// Finished walk: end pin instead of the live position.
  final bool finished;
  final double bottomPadding;
  final ValueChanged<GoogleMapController>? onMapCreated;
  final VoidCallback? onUserPan;

  /// Finger travel (logical px) that counts as a pan, not a tap.
  static const double panSlop = 12;

  /// Below this speed (m/s) the bearing is noise: no heading arrow.
  static const double headingMinSpeed = 0.5;

  @override
  State<WalkMapView> createState() => _WalkMapViewState();
}

class _WalkMapViewState extends State<WalkMapView> {
  MarkerFactory? _factory;
  BitmapDescriptor? _start;
  BitmapDescriptor? _end;
  BitmapDescriptor? _dot;
  BitmapDescriptor? _dotHeading;
  String? _mapStyleJson;
  Offset? _pointerDownAt;
  bool _panReported = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final colors = LmColors.of(context);
    if (_factory?.devicePixelRatio != dpr || _factory?.colors != colors) {
      _factory = MarkerFactory(devicePixelRatio: dpr, colors: colors);
      unawaited(_loadIcons());
    }
    unawaited(_loadStyle());
  }

  @override
  void didUpdateWidget(WalkMapView old) {
    super.didUpdateWidget(old);
    if (old.mapStyle != widget.mapStyle) unawaited(_loadStyle());
  }

  Future<void> _loadIcons() async {
    final f = _factory!;
    final (start, end, dot, dotHeading) = await (
      f.startDot(),
      f.endPin(),
      f.currentLocation(heading: false),
      f.currentLocation(heading: true),
    ).wait;
    if (!mounted || f != _factory) return;
    setState(() {
      _start = start;
      _end = end;
      _dot = dot;
      _dotHeading = dotHeading;
    });
  }

  Future<void> _loadStyle() async {
    final json = await MapStyleMapper.styleFor(
      widget.mapStyle,
      Theme.of(context).brightness,
    );
    if (mounted && json != _mapStyleJson) setState(() => _mapStyleJson = json);
  }

  static LatLng _latLng(MeasurePoint p) => LatLng(p.lat, p.lng);

  /// Points grouped by segment, in recording order.
  List<List<MeasurePoint>> get _segments {
    final segments = <List<MeasurePoint>>[];
    int? current;
    for (final p in widget.points) {
      if (p.segmentIndex != current) {
        segments.add([]);
        current = p.segmentIndex;
      }
      segments.last.add(p);
    }
    return segments;
  }

  Set<Polyline> _polylines(ModeColors walk) {
    // Long tracks are simplified for drawing only (architecture.md §7.8).
    final simplify = widget.points.length > PathSimplifier.displayThreshold;
    return {
      for (final (i, segment) in _segments.indexed)
        if (segment.length >= 2)
          Polyline(
            polylineId: PolylineId('segment$i'),
            points: [
              for (final p
                  in simplify
                      ? PathSimplifier.simplify(
                          segment,
                          (p) => p.position,
                          toleranceM: 1,
                        )
                      : segment)
                _latLng(p),
            ],
            color: walk.main,
            width: 5,
            jointType: JointType.round,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            zIndex: 2,
          ),
    };
  }

  Set<Polygon> _polygons(ModeColors area) {
    if (!widget.isClosed || widget.points.length < 3) return const {};
    return {
      Polygon(
        polygonId: const PolygonId('walk-area'),
        points: [for (final p in widget.points) _latLng(p)],
        fillColor: area.fill,
        strokeColor: Colors.transparent,
        strokeWidth: 0,
      ),
    };
  }

  Set<Circle> _circles(LmColors colors, ModeColors walk, ModeColors area) {
    final circles = <Circle>{};
    final threshold = widget.closureThresholdM;
    if (threshold != null && widget.points.length >= 2 && !widget.finished) {
      final near = widget.isClosed;
      circles.add(
        Circle(
          circleId: const CircleId('start-zone'),
          center: _latLng(widget.points.first),
          radius: threshold,
          strokeWidth: 2,
          strokeColor: near ? area.main : walk.main.withValues(alpha: 0.6),
          fillColor: near
              ? area.main.withValues(alpha: 0.18)
              : Colors.transparent,
          zIndex: 1,
        ),
      );
    }
    final fix = widget.lastFix;
    if (fix != null && widget.showAccuracy && !widget.finished) {
      circles.add(
        Circle(
          circleId: const CircleId('accuracy'),
          center: LatLng(fix.lat, fix.lng),
          radius: fix.accuracy,
          strokeWidth: 1,
          strokeColor: colors.distanceMain.withValues(alpha: 0.3),
          fillColor: colors.distanceMain.withValues(alpha: 0.15),
          zIndex: 3,
        ),
      );
    }
    return circles;
  }

  Set<Marker> _markers() {
    final markers = <Marker>{};
    final points = widget.points;
    final start = _start;
    if (points.isNotEmpty && start != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: _latLng(points.first),
          icon: start,
          anchor: MarkerFactory.centerAnchor,
          zIndexInt: 4,
          consumeTapEvents: true,
        ),
      );
    }
    final end = _end;
    if (widget.finished && points.length > 1 && end != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('end'),
          position: _latLng(points.last),
          icon: end, // default anchor: bottom center (pin tip)
          zIndexInt: 5,
          consumeTapEvents: true,
        ),
      );
    }
    final fix = widget.lastFix;
    if (fix != null && !widget.finished) {
      final bearing = fix.bearing;
      final heading =
          bearing != null && (fix.speed ?? 0) >= WalkMapView.headingMinSpeed;
      final icon = heading ? _dotHeading : _dot;
      if (icon != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('me'),
            position: LatLng(fix.lat, fix.lng),
            icon: icon,
            anchor: MarkerFactory.centerAnchor,
            flat: heading,
            rotation: heading ? bearing : 0,
            zIndexInt: 6,
            consumeTapEvents: true,
          ),
        );
      }
    }
    return markers;
  }

  // A pan anywhere on the map stops follow mode.
  void _onPointerDown(PointerDownEvent e) {
    _pointerDownAt = e.position;
    _panReported = false;
  }

  void _onPointerMove(PointerMoveEvent e) {
    final from = _pointerDownAt;
    if (from == null || _panReported) return;
    if ((e.position - from).distance >= WalkMapView.panSlop) {
      _panReported = true;
      widget.onUserPan?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final walk = ModeColors.from(colors, MeasurementType.walk);
    final area = ModeColors.from(colors, MeasurementType.area);
    return RepaintBoundary(
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        child: GoogleMap(
          initialCameraPosition: widget.initialCamera,
          mapType: MapStyleMapper.mapType(widget.mapStyle),
          style: _mapStyleJson,
          polylines: _polylines(walk),
          polygons: _polygons(area),
          circles: _circles(colors, walk, area),
          markers: _markers(),
          padding: EdgeInsets.only(bottom: widget.bottomPadding),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          tiltGesturesEnabled: false,
          buildingsEnabled: false,
          onMapCreated: widget.onMapCreated,
        ),
      ),
    );
  }
}
