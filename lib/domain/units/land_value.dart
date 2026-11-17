import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/units/unit_converter.dart';

/// Estimated land value (`overview.md` §4.1 ⭐2): area × price per unit
/// ("50 triệu / sào" × 3,4 sào ≈ 170 triệu).
abstract final class LandValue {
  /// Null when the area or the price is missing or not positive.
  static double? estimate({
    required double? areaM2,
    required double? unitPrice,
    required AreaUnit? priceUnit,
  }) {
    if (areaM2 == null || unitPrice == null || priceUnit == null) return null;
    if (areaM2 <= 0 || unitPrice <= 0) return null;
    return UnitConverter.areaTo(areaM2, priceUnit) * unitPrice;
  }

  /// Currency for a new price: the device region's (VN → VND, US → USD…),
  /// looked up by the caller; this only maps the few land markets the app
  /// targets and falls back to USD.
  static String currencyForRegion(String? countryCode) =>
      switch (countryCode?.toUpperCase()) {
        'VN' => 'VND',
        'US' => 'USD',
        'GB' => 'GBP',
        'IN' => 'INR',
        'ID' => 'IDR',
        'PH' => 'PHP',
        'TH' => 'THB',
        'MY' => 'MYR',
        'MM' => 'MMK',
        'KH' => 'KHR',
        'LA' => 'LAK',
        'CN' => 'CNY',
        'BR' => 'BRL',
        'MX' => 'MXN',
        'ES' || 'FR' || 'DE' || 'IT' || 'PT' || 'NL' => 'EUR',
        _ => 'USD',
      };
}
