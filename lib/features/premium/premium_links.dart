import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/services/purchases/purchase_service.dart';
import 'package:gps_measurement/services/support/support_service.dart';

/// Where to cancel or change the subscription: the management
/// URL Play Billing gave, else the store's subscriptions page
/// (`overview.md` §5.4 — easy to cancel is a promise of this app).
@visibleForTesting
Uri manageSubscriptionUri(PremiumStatus status, {required bool ios}) {
  final url = status.managementUrl;
  if (url != null && url.isNotEmpty) return Uri.parse(url);
  return ios
      ? Uri.parse('https://apps.apple.com/account/subscriptions')
      : Uri.parse('https://play.google.com/store/account/subscriptions');
}

Future<bool> openManageSubscription(WidgetRef ref, PremiumStatus status) {
  return ref
      .read(supportServiceProvider)
      .launch(
        manageSubscriptionUri(
          status,
          ios: defaultTargetPlatform == TargetPlatform.iOS,
        ),
      );
}

Future<bool> openPremiumLink(WidgetRef ref, String url) {
  return ref.read(supportServiceProvider).launch(Uri.parse(url));
}
