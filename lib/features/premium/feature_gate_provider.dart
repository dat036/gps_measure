import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/domain/premium/feature_gate.dart';
import 'package:gps_measurement/features/premium/map_style_unlock.dart';
import 'package:gps_measurement/services/purchases/purchase_service.dart';
import 'package:gps_measurement/services/remote_config/rc_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feature_gate_provider.g.dart';

/// Premium gate used by Save / photos / export / ads: the `premium`
/// entitlement and the free limits of [MonetizationConfig].
@Riverpod(keepAlive: true)
FeatureGate featureGate(Ref ref) => FeatureGate(
  isPremium: ref.watch(premiumProvider.select((s) => s.isPremium)),
  config: ref.watch(monetizationConfigProvider.select((c) => c.gate)),
  unlockedMapStyles: ref.watch(unlockedMapStylesProvider),
);
