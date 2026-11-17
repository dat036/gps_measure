import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_measurement/core/format/unit_formatter.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/l10n/measurement_labels.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/widgets/empty_state.dart';
import 'package:gps_measurement/core/widgets/map_fab.dart';
import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/features/detail/detail_controller.dart';
import 'package:gps_measurement/features/measure/common/map_layer_sheet.dart';
import 'package:gps_measurement/features/measure/common/measure_map_view.dart';
import 'package:gps_measurement/features/measure/walk/walk_map_view.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';

/// Read-only map of a saved measurement (`plan.md` P6-09), with Layers
/// (the chosen style is remembered on the measurement).
class FullMapScreen extends ConsumerStatefulWidget {
  const FullMapScreen({required this.measurementId, super.key});

  final String measurementId;

  @override
  ConsumerState<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends ConsumerState<FullMapScreen> {
  GoogleMapController? _map;

  void _fit(Measurement m) {
    final b = GeoCalculator.bounds(m.points.map((p) => p.position));
    final map = _map;
    if (b == null || map == null) return;
    unawaited(
      map.animateCamera(
        m.points.length < 2
            ? CameraUpdate.newLatLngZoom(LatLng(b.center.lat, b.center.lng), 18)
            : CameraUpdate.newLatLngBounds(
                LatLngBounds(
                  southwest: LatLng(b.minLat, b.minLng),
                  northeast: LatLng(b.maxLat, b.maxLng),
                ),
                56,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final async = ref.watch(detailControllerProvider(widget.measurementId));
    final m = async.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          m == null ? l10n.screenFullMap : l10n.titleOf(m.name, m.type),
        ),
      ),
      body: m == null
          ? (async.isLoading
                ? const Center(child: CircularProgressIndicator())
                : EmptyState(
                    icon: Icons.search_off_rounded,
                    title: l10n.saveNotFound,
                  ))
          : Stack(
              children: [
                Positioned.fill(child: _mapFor(context, m)),
                Positioned(
                  top: LmSpacing.s12,
                  right: LmSpacing.pageH,
                  child: Column(
                    children: [
                      MapFab(
                        icon: Icons.layers_rounded,
                        tooltip: l10n.fabLayers,
                        onPressed: () async {
                          final style = await showMapLayerSheet(
                            context,
                            ref,
                            current: m.mapStyle,
                          );
                          if (style == null) return;
                          await ref
                              .read(
                                detailControllerProvider(
                                  widget.measurementId,
                                ).notifier,
                              )
                              .setMapStyle(style);
                        },
                      ),
                      const SizedBox(height: MapFab.spacing),
                      MapFab(
                        icon: Icons.fit_screen_rounded,
                        tooltip: l10n.fabRecenter,
                        onPressed: () => _fit(m),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _mapFor(BuildContext context, Measurement m) {
    final b = GeoCalculator.bounds(m.points.map((p) => p.position));
    final camera = CameraPosition(
      target: b == null
          ? const LatLng(0, 0)
          : LatLng(b.center.lat, b.center.lng),
      zoom: b == null ? 2 : 17,
    );
    void created(GoogleMapController c) {
      _map = c;
      // Wait for the first layout so bounds fit the real map size.
      WidgetsBinding.instance.addPostFrameCallback((_) => _fit(m));
    }

    if (m.type == MeasurementType.walk) {
      return WalkMapView(
        points: m.points,
        initialCamera: camera,
        mapStyle: m.mapStyle,
        isClosed: m.stats.isClosed,
        finished: true,
        onMapCreated: created,
      );
    }
    final settings = ref.watch(settingsProvider);
    final locale = Localizations.localeOf(context).toString();
    final areaUnit = m.displayAreaUnit ?? settings.areaUnit;
    final distanceUnit = m.displayDistanceUnit ?? settings.distanceUnit;
    final area = m.stats.areaM2;
    final distance = m.stats.distanceM;
    return MeasureMapView(
      type: m.type,
      points: m.points,
      isClosed: m.stats.isClosed,
      selfIntersects: m.stats.selfIntersects,
      initialCamera: camera,
      mapStyle: m.mapStyle,
      readOnly: true,
      photoPointIds: {
        for (final p in m.photos)
          if (p.pointId != null) p.pointId!,
      },
      resultLabel: switch (m.type) {
        MeasurementType.area when area != null =>
          UnitFormatter.areaWithSecondary(
            area,
            areaUnit,
            locale,
            secondary: settings.showSecondaryUnit,
          ),
        MeasurementType.distance when distance != null => (
          primary: UnitFormatter.distance(distance, distanceUnit, locale),
          secondary: null,
        ),
        _ => null,
      },
      edgeLabelOf: settings.showEdgeLabels
          ? (meters) => UnitFormatter.distance(meters, distanceUnit, locale)
          : null,
      onMapCreated: created,
    );
  }
}
