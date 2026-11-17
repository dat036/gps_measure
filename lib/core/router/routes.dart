import 'package:gps_measurement/domain/models/enums.dart';

/// Route paths (`architecture.md` §10). Deep links from notifications use
/// the same paths. Build locations with the helpers, never by hand.
abstract final class Routes {
  static const String splash = '/splash';
  static const String language = '/language';
  static const String intro = '/intro';
  static const String home = '/home';
  static const String saved = '/saved';
  static const String settings = '/settings';

  static const String measureArea = '/measure/area';
  static const String measureDistance = '/measure/distance';
  static const String measureWalk = '/measure/walk';

  static const String save = '/save/:id';
  static const String detail = '/detail/:id';
  static const String detailMap = 'map'; // child of [detail]
  static const String edit = '/edit/:id';
  static const String photos = '/photos/:measurementId';
  static const String paywall = '/paywall';

  /// The paywall of the 2nd launch: the yearly plan only.
  static const String paywallFirst = '/paywall-first';

  static const String settingsUnits = 'units'; // children of [settings]
  static const String settingsMapStyle = 'map-style';
  static const String settingsLanguage = 'language';

  static const String paramId = 'id';
  static const String paramMeasurementId = 'measurementId';
  static const String queryDraftId = 'draftId';
  static const String queryIndex = 'index';
  static const String querySource = 'source';
  static const String queryReadOnly = 'readOnly';

  static String measure(MeasurementType type, {String? draftId}) {
    final path = switch (type) {
      MeasurementType.area => measureArea,
      MeasurementType.distance => measureDistance,
      MeasurementType.walk => measureWalk,
    };
    return _withQuery(path, {queryDraftId: draftId});
  }

  static String saveOf(String id) => '/save/$id';
  static String detailOf(String id) => '/detail/$id';
  static String detailMapOf(String id) => '/detail/$id/$detailMap';
  static String editOf(String id) => '/edit/$id';

  /// [readOnly]: no Delete (e.g. opened from Edit, where removals wait for
  /// "Save Changes").
  static String photosOf(
    String measurementId, {
    int? index,
    bool readOnly = false,
  }) => _withQuery('/photos/$measurementId', {
    queryIndex: index?.toString(),
    queryReadOnly: readOnly ? '1' : null,
  });

  static String paywallFrom(String source) =>
      _withQuery(paywall, {querySource: source});

  static String settingsChild(String child) => '$settings/$child';

  static String _withQuery(String path, Map<String, String?> query) {
    final params = {
      for (final e in query.entries)
        if (e.value != null) e.key: e.value!,
    };
    if (params.isEmpty) return path;
    return Uri(path: path, queryParameters: params).toString();
  }
}
