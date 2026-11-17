import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/services/ads/ad_unit_ids.dart';
import 'package:gps_measurement/services/ads/native_ad_controller.dart';
import 'package:gps_measurement/services/ads/native_ad_view.dart';

/// Medium native ad on the Detail page, right under the name and above the
/// result (free users). Takes the ad the measure screen preloaded, else
/// requests one; shows nothing until it has loaded and nothing at all if it
/// fails or the user is premium.
class DetailNativeAd extends ConsumerStatefulWidget {
  const DetailNativeAd({required this.type, super.key});

  /// Colors the ad's button like the measurement's mode.
  final MeasurementType type;

  @override
  ConsumerState<DetailNativeAd> createState() => _DetailNativeAdState();
}

class _DetailNativeAdState extends ConsumerState<DetailNativeAd> {
  NativeAdController? _controller;

  void _ensure() {
    if (_controller != null || !ref.read(nativeAdsEnabledProvider)) return;
    _controller = ref
        .read(nativeAdCacheProvider)
        .obtain(
          AdFormat.nativeSaved,
          NativeLayout.medium,
          NativeAdPlacements.detailForm(context, widget.type),
        );
  }

  @override
  void initState() {
    super.initState();
    // Ads can become ready after the tab was built.
    ref.listenManual(nativeAdsEnabledProvider, (_, enabled) {
      if (!mounted) return;
      if (enabled) {
        setState(_ensure);
      } else {
        setState(() {
          _controller?.dispose();
          _controller = null;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensure();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();
    return NativeAdBox(
      controller: controller,
      showSkeleton: false,
      margin: const EdgeInsets.fromLTRB(
        LmSpacing.pageH,
        LmSpacing.s12,
        LmSpacing.pageH,
        0,
      ),
    );
  }
}
