import 'dart:async';
import 'dart:io';

import 'package:gps_measurement/core/permissions/permission_service.dart';
import 'package:gps_measurement/features/photos/photo_picker.dart';
import 'package:gps_measurement/services/ads/rewarded_manager.dart';
import 'package:gps_measurement/services/purchases/purchase_service.dart';
import 'package:gps_measurement/services/support/support_service.dart';
import 'package:image_picker/image_picker.dart';

class FakePermissions implements PermissionService {
  int notificationRequests = 0;
  int appSettingsOpened = 0;
  int cameraRequests = 0;
  PermissionAccess camera = PermissionAccess.askable;
  PermissionAccess notifications = PermissionAccess.askable;

  /// What the system dialog answers.
  PermissionAccess cameraAnswer = PermissionAccess.granted;

  @override
  Future<PermissionAccess> notificationStatus() async => notifications;

  @override
  Future<PermissionAccess> requestNotifications() async {
    notificationRequests++;
    return notifications = PermissionAccess.granted;
  }

  @override
  Future<bool> openAppSettings() async {
    appSettingsOpened++;
    return true;
  }

  @override
  Future<PermissionAccess> cameraStatus() async => camera;

  @override
  Future<PermissionAccess> requestCamera() async {
    cameraRequests++;
    return camera = cameraAnswer;
  }
}

/// Returns files created in [dir] instead of opening the camera/gallery.
class FakePicker implements PhotoPicker {
  FakePicker(this.dir);

  final Directory dir;
  int _n = 0;
  int? lastLimit;
  int galleryCount = 2;

  XFile _file(String prefix) {
    final f = File('${dir.path}/$prefix${_n++}.jpg')
      ..writeAsBytesSync(List.filled(64, 7));
    return XFile(f.path);
  }

  @override
  Future<XFile?> takePhoto() async => _file('cam');

  @override
  Future<List<XFile>> pickFromGallery({int? limit}) async {
    lastLimit = limit;
    final n = limit == null || limit > galleryCount ? galleryCount : limit;
    return [for (var i = 0; i < n; i++) _file('gal')];
  }
}

/// Records what Settings → Support & Legal opens.
class FakeSupport implements SupportService {
  final List<Uri> launched = [];
  int storeListings = 0;

  /// What [launch] answers (false: no app can open it).
  bool canLaunch = true;

  @override
  Future<AppInfo> appInfo() async => (
    version: '1.0.0',
    build: '7',
    device: 'Google Pixel 7',
    os: 'Android 14 (SDK 34)',
  );

  @override
  Future<bool> launch(Uri uri) async {
    launched.add(uri);
    return canLaunch;
  }

  @override
  Future<bool> openStoreListing() async {
    storeListings++;
    return true;
  }
}

/// Store stand-in: [offers] on the paywall, [nextPurchase] / [nextRestore]
/// answers; a purchase or restore that succeeds turns premium on.
class FakePurchaseService implements PurchaseService {
  FakePurchaseService({this.offers = const []});

  List<PlanOffer> offers;
  PurchaseOutcome nextPurchase = PurchaseOutcome.purchased;
  RestoreOutcome nextRestore = RestoreOutcome.nothingToRestore;
  final List<PremiumPlan> purchased = [];
  final StreamController<PremiumStatus> _changes = StreamController.broadcast();

  @override
  PremiumStatus status = PremiumStatus.free;

  void setStatus(PremiumStatus s) {
    status = s;
    _changes.add(s);
  }

  @override
  bool get isAvailable => true;

  @override
  Stream<PremiumStatus> get statusStream => _changes.stream;

  @override
  Future<void> init() async {}

  @override
  Future<List<PlanOffer>> plans() async => offers;

  @override
  Future<PurchaseOutcome> purchase(PlanOffer offer) async {
    purchased.add(offer.plan);
    if (nextPurchase == PurchaseOutcome.purchased) {
      setStatus(const PremiumStatus(isPremium: true));
    }
    return nextPurchase;
  }

  @override
  Future<RestoreOutcome> restore() async {
    if (nextRestore == RestoreOutcome.restored) {
      setStatus(const PremiumStatus(isPremium: true));
    }
    return nextRestore;
  }
}

const List<PlanOffer> testOffers = [
  PlanOffer(
    plan: PremiumPlan.monthly,
    price: r'$3.99',
    priceAmount: 3.99,
    currencyCode: 'USD',
    trialDays: 3,
  ),
  PlanOffer(
    plan: PremiumPlan.annual,
    price: r'$19.99',
    priceAmount: 19.99,
    currencyCode: 'USD',
  ),
];

/// Rewarded ad that answers [outcome] without the SDK.
class FakeRewarded implements RewardedManager {
  FakeRewarded(this.outcome);

  RewardOutcome outcome;
  int shown = 0;

  @override
  Future<RewardOutcome> show() async {
    shown++;
    return outcome;
  }
}
