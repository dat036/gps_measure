import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ad_instance_manager.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/services/ads/ad_unit_ids.dart';
import 'package:gps_measurement/services/ads/native_ad_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final calls = <MethodCall>[];
  final codec = StandardMethodCodec(AdMessageCodec());
  const style = NativeAdStyle(
    background: Color(0xffffffff),
    stroke: Color(0xffeeeeee),
    title: Color(0xff111111),
    body: Color(0xff555555),
    cta: Color(0xff1e6bff),
    ctaText: Color(0xffffffff),
    badge: Color(0xffeeeeee),
    badgeText: Color(0xff111111),
  );

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    calls.clear();
    instanceManager = AdInstanceManager('plugins.flutter.io/google_mobile_ads');
    messenger.setMockMethodCallHandler(instanceManager.channel, (call) async {
      calls.add(call);
      return null;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(instanceManager.channel, null);
    debugDefaultTargetPlatformOverride = null;
    Log.sink = null;
  });

  Future<void> event(int id, String name, {LoadAdError? error}) async {
    await messenger.handlePlatformMessage(
      instanceManager.channel.name,
      codec.encodeMethodCall(
        MethodCall('onAdEvent', {
          'adId': id,
          'eventName': name,
          'loadAdError': ?error,
        }),
      ),
      (_) {},
    );
  }

  test(
    'iOS requests each registered factory and accepts loaded native ads',
    () async {
      for (final layout in NativeLayout.values) {
        final controller = NativeAdController(
          format: AdFormat.nativeIntro,
          layout: layout,
          style: style,
        )..load();
        await Future<void>.delayed(Duration.zero);
        final request = calls.lastWhere((c) => c.method == 'loadNativeAd');
        final args = request.arguments as Map<dynamic, dynamic>;
        expect(args['factoryId'], layout.factoryId);
        expect(args['adUnitId'], 'ca-app-pub-3940256099942544/3986624511');
        await event(args['adId'] as int, 'onAdLoaded');
        expect(controller.status, NativeAdStatus.loaded);
        expect(controller.ad, isNotNull);
        controller.dispose();
        await Future<void>.delayed(Duration.zero);
        expect(calls.last.method, 'disposeAd');
      }
    },
  );

  test(
    'iOS load failure collapses the slot and preserves diagnostic code',
    () async {
      final warnings = <String>[];
      Log.sink = (_, message, _, _) => warnings.add(message);
      final controller = NativeAdController(
        format: AdFormat.nativeLanguage,
        layout: NativeLayout.medium,
        style: style,
      )..load();
      await Future<void>.delayed(Duration.zero);
      final args = calls.last.arguments as Map<dynamic, dynamic>;
      await event(
        args['adId'] as int,
        'onAdFailedToLoad',
        error: LoadAdError(1, 'com.google.admob', 'Invalid request', null),
      );
      expect(controller.status, NativeAdStatus.failed);
      expect(controller.ad, isNull);
      expect(warnings.single, contains('[com.google.admob/1]'));
      controller.dispose();
      await Future<void>.delayed(Duration.zero);
    },
  );

  test('desktop does not send a native ad request', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    final controller = NativeAdController(
      format: AdFormat.nativeIntro,
      layout: NativeLayout.compact,
      style: style,
    )..load();
    expect(controller.status, NativeAdStatus.failed);
    expect(calls, isEmpty);
    controller.dispose();
  });
}
