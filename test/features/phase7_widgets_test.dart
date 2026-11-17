import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/location/location_service.dart';
import 'package:gps_measurement/core/permissions/permission_service.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/photo_repository.dart';
import 'package:gps_measurement/data/storage/photo_storage.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/location_fix.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:gps_measurement/domain/premium/feature_gate.dart';
import 'package:gps_measurement/features/detail/detail_controller.dart';
import 'package:gps_measurement/features/measure/common/photo_strip.dart';
import 'package:gps_measurement/features/photos/photo_actions.dart';
import 'package:gps_measurement/features/photos/photo_flows.dart';
import 'package:gps_measurement/features/photos/photo_picker.dart';
import 'package:gps_measurement/features/photos/photo_viewer_screen.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/data.dart';
import '../helpers/fakes.dart';
import '../helpers/golden.dart';
import '../helpers/router.dart';

class MockPhotoRepository extends Mock implements PhotoRepository {}

class MockPhotoStorage extends Mock implements PhotoStorage {}

/// Records calls instead of importing files.
class RecordingActions extends PhotoActions {
  RecordingActions({required super.repository, required super.storage})
    : super(gate: const FeatureGate(isPremium: true), imports: PhotoImports());

  final List<(String, String?, GeoPoint?)> camera = [];
  final List<int> gallery = [];
  int? left;

  @override
  Future<int?> remaining(String measurementId) async => left;

  @override
  Future<Photo> addFromCamera(
    XFile file,
    String measurementId, {
    String? pointId,
    GeoPoint? location,
  }) async {
    camera.add((measurementId, pointId, location));
    return photo('new');
  }

  @override
  Future<List<Photo>> addFromGallery(
    List<XFile> files,
    String measurementId, {
    String? pointId,
    GeoPoint? location,
  }) async {
    gallery.add(files.length);
    return [for (final (i, _) in files.indexed) photo('g$i')];
  }
}

class NoLocation implements LocationService {
  @override
  Future<LocationAccess> ensureAccess({bool request = true}) async =>
      LocationAccess.denied;

  @override
  Future<LocationFix> current({Duration? timeLimit}) =>
      throw const LocationException('none');

  @override
  Future<GeoPoint?> lastKnown() async => null;
}

Photo photo(String id, {String? pointId}) => Photo(
  id: id,
  measurementId: 'm1',
  pointId: pointId,
  filePath: 'photos/m1/$id.jpg',
  thumbPath: 'photos/m1/${id}_t.jpg',
  takenAt: DateTime.utc(2026, 9, 29, 8, 30),
  source: PhotoSource.camera,
  width: 2048,
  height: 1536,
  bytes: 500000,
  sortIndex: 0,
);

void main() {
  late Directory tmp;
  late SharedPreferences prefs;

  setUp(() async {
    tmp = Directory.systemTemp.createTempSync('p7_');
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() {
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
  });

  group('PhotoStrip', () {
    Widget strip({
      ValueChanged<Photo>? onRemove,
      VoidCallback? onAdd,
      ValueChanged<int>? onOpen,
      int importing = 0,
    }) => PhotoStrip(
      photos: [
        photo('a', pointId: 'p3'),
        photo('b'),
      ],
      resolve: (rel) => File('${tmp.path}/$rel'), // missing → placeholder
      pointNumbers: const {'p3': 3},
      onRemove: onRemove,
      onAdd: onAdd,
      onOpen: onOpen,
      importing: importing,
    );

    testWidgets('remove, add, open, point label, import spinner', (
      tester,
    ) async {
      final removed = <String>[];
      var added = 0;
      final opened = <int>[];
      await tester.pumpWidget(
        testApp(
          child: strip(
            onRemove: (p) => removed.add(p.id),
            onAdd: () => added++,
            onOpen: opened.add,
            importing: 1,
          ),
        ),
      );
      expect(find.text('Site Photos (2)'), findsOneWidget);
      expect(find.text('P3'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Remove photo').first);
      await tester.tap(find.text('Add Photo'));
      await tester.tap(find.bySemanticsLabel('Open photo 2'));
      await tester.tap(find.text('See All'));
      expect(removed, ['a']);
      expect(added, 1);
      expect(opened, [1, 0]);
    });

    testWidgets('read-only: no ✕, no add tile', (tester) async {
      await tester.pumpWidget(testApp(child: strip()));
      expect(find.bySemanticsLabel('Remove photo'), findsNothing);
      expect(find.text('Add Photo'), findsNothing);
    });

    testWidgets(
      'golden',
      (tester) => expectGoldenBothThemes(
        tester,
        'photo_strip',
        strip(onRemove: (_) {}, onAdd: () {}, importing: 1),
      ),
      tags: ['golden'],
    );
  });

  group('PhotoFlows.add', () {
    late FakePermissions permissions;
    late RecordingActions actions;

    setUp(() {
      permissions = FakePermissions();
      actions = RecordingActions(
        repository: MockPhotoRepository(),
        storage: MockPhotoStorage(),
      );
    });

    final paywalls = <String>[];

    Future<void> run(
      WidgetTester tester, {
      bool savePhotos = true,
      String? pointId,
    }) async {
      registerFallbackValue(XFile(''));
      final storage = MockPhotoStorage();
      when(() => storage.discardCapture(any())).thenAnswer((_) async {});
      await prefs.setBool('save_photos_to_measurement', savePhotos);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            deviceLocaleProvider.overrideWithValue(const Locale('en', 'US')),
            permissionServiceProvider.overrideWithValue(permissions),
            photoActionsProvider.overrideWithValue(actions),
            photoPickerProvider.overrideWithValue(FakePicker(tmp)),
            photoStorageProvider.overrideWithValue(storage),
            locationServiceProvider.overrideWithValue(NoLocation()),
          ],
          child: routerTestApp(
            paywallOpened: paywalls,
            child: Consumer(
              builder: (context, ref, _) => TextButton(
                onPressed: () => PhotoFlows.add(
                  context,
                  ref,
                  measurementId: 'm1',
                  pointId: pointId,
                  pointNumber: pointId == null ? null : 3,
                  location: pointId == null
                      ? null
                      : const GeoPoint(lat: 21, lng: 105),
                ),
                child: const Text('go'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
    }

    testWidgets('camera: pre-prompt, system dialog, attached to the point', (
      tester,
    ) async {
      await run(tester, pointId: 'p3');
      await tester.pumpAndSettle();
      expect(find.text('For point 3'), findsOneWidget);
      await tester.tap(find.text('Take Photo'));
      await tester.pumpAndSettle();
      expect(find.text('Allow Camera Access'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(permissions.cameraRequests, 1);
      expect(actions.camera, [('m1', 'p3', const GeoPoint(lat: 21, lng: 105))]);
    });

    testWidgets('camera blocked → Open Settings, nothing added', (
      tester,
    ) async {
      permissions.camera = PermissionAccess.blocked;
      await run(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take Photo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Settings'));
      await tester.pumpAndSettle();
      expect(permissions.appSettingsOpened, 1);
      expect(actions.camera, isEmpty);
    });

    testWidgets('"Save Photos to Measurement" off asks before attaching', (
      tester,
    ) async {
      permissions.camera = PermissionAccess.granted;
      await run(tester, savePhotos: false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take Photo'));
      await tester.pumpAndSettle();
      expect(find.text('Attach this photo to measurement?'), findsOneWidget);
      await tester.tap(find.text('Discard'));
      await tester.pumpAndSettle();
      expect(actions.camera, isEmpty);
    });

    testWidgets('gallery respects the free quota', (tester) async {
      actions.left = 1;
      await run(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose from Gallery'));
      await tester.pumpAndSettle();
      expect(actions.gallery, [1]);
    });

    testWidgets('no quota left → paywall; closed → message, no sheet', (
      tester,
    ) async {
      actions.left = 0;
      await run(tester);
      await tester.pumpAndSettle();
      // First the Premium popup; Upgrade goes to the paywall.
      expect(find.text('Go Premium'), findsOneWidget);
      expect(find.textContaining('up to 2 photos'), findsOneWidget);
      await tester.tap(find.text('Upgrade'));
      await tester.pumpAndSettle();
      expect(paywalls.last, 'photo_limit');
      await tester.tap(find.text('stub close'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('free limit of photos'),
        findsOneWidget,
      );
      expect(find.text('Take Photo'), findsNothing);
    });

    testWidgets('no quota left → paywall; bought → the photo sheet opens', (
      tester,
    ) async {
      actions.left = 0;
      await run(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Upgrade'));
      await tester.pumpAndSettle();
      actions.left = null; // Premium: unlimited.
      await tester.tap(find.text('stub buy'));
      await tester.pumpAndSettle();
      expect(find.text('Take Photo'), findsOneWidget);
    });
  });

  group('PhotoViewerScreen', () {
    final m = Measurement(
      id: 'm1',
      type: MeasurementType.area,
      status: MeasurementStatus.saved,
      mapStyle: MapStyle.satellite,
      createdAt: DateTime.utc(2026, 9, 29),
      updatedAt: DateTime.utc(2026, 9, 29),
      points: [
        for (var i = 0; i < 3; i++)
          MeasurePoint(
            id: 'p$i',
            orderIndex: i,
            lat: 21,
            lng: 105 + i / 1000,
            timestamp: DateTime.utc(2026, 9, 29),
          ),
      ],
      photos: [
        photo('a'),
        photo('b', pointId: 'p2'),
      ],
    );

    late TempDirectories dirs;
    setUp(() => dirs = TempDirectories());
    tearDown(() => dirs.dispose());

    Future<void> open(WidgetTester tester, {bool readOnly = false}) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            appDirectoriesProvider.overrideWithValue(dirs.dirs),
            detailControllerProvider('m1').overrideWith(() => _Fixed(m)),
          ],
          child: testApp(
            child: PhotoViewerScreen(measurementId: 'm1', readOnly: readOnly),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }

    testWidgets('counter, swipe, point label', (tester) async {
      await open(tester);
      expect(find.text('1 / 2'), findsOneWidget);
      expect(find.byTooltip('Delete'), findsOneWidget);
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();
      expect(find.text('2 / 2'), findsOneWidget);
      expect(find.text('Point 3'), findsOneWidget);
    });

    testWidgets('read-only hides Delete', (tester) async {
      await open(tester, readOnly: true);
      expect(find.byTooltip('Delete'), findsNothing);
      expect(find.byTooltip('Share'), findsOneWidget);
    });
  });

  testWidgets('labels exist in Vietnamese', (tester) async {
    await tester.pumpWidget(
      testApp(locale: const Locale('vi'), child: const SizedBox()),
    );
    final l10n = tester.element(find.byType(SizedBox)).l10n;
    expect(l10n.addPhotoCamera, 'Chụp ảnh');
    expect(l10n.ctaSaveChanges, 'Lưu thay đổi');
  });
}

class _Fixed extends DetailController {
  _Fixed(this.m);

  final Measurement m;

  @override
  Stream<Measurement?> build(String measurementId) => Stream.value(m);
}
