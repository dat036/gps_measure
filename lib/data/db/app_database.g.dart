// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MeasurementsTable extends Measurements
    with TableInfo<$MeasurementsTable, MeasurementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameLowerMeta = const VerificationMeta(
    'nameLower',
  );
  @override
  late final GeneratedColumn<String> nameLower = GeneratedColumn<String>(
    'name_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MeasurementType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<MeasurementType>($MeasurementsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<MeasurementStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<MeasurementStatus>($MeasurementsTable.$converterstatus);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _areaM2Meta = const VerificationMeta('areaM2');
  @override
  late final GeneratedColumn<double> areaM2 = GeneratedColumn<double>(
    'area_m2',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _perimeterMMeta = const VerificationMeta(
    'perimeterM',
  );
  @override
  late final GeneratedColumn<double> perimeterM = GeneratedColumn<double>(
    'perimeter_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMMeta = const VerificationMeta(
    'distanceM',
  );
  @override
  late final GeneratedColumn<double> distanceM = GeneratedColumn<double>(
    'distance_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pointCountMeta = const VerificationMeta(
    'pointCount',
  );
  @override
  late final GeneratedColumn<int> pointCount = GeneratedColumn<int>(
    'point_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _segmentCountMeta = const VerificationMeta(
    'segmentCount',
  );
  @override
  late final GeneratedColumn<int> segmentCount = GeneratedColumn<int>(
    'segment_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isClosedMeta = const VerificationMeta(
    'isClosed',
  );
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
    'is_closed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_closed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _selfIntersectsMeta = const VerificationMeta(
    'selfIntersects',
  );
  @override
  late final GeneratedColumn<bool> selfIntersects = GeneratedColumn<bool>(
    'self_intersects',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("self_intersects" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MapStyle, int> mapStyle =
      GeneratedColumn<int>(
        'map_style',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<MapStyle>($MeasurementsTable.$convertermapStyle);
  @override
  late final GeneratedColumnWithTypeConverter<AreaUnit?, int> displayAreaUnit =
      GeneratedColumn<int>(
        'display_area_unit',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<AreaUnit?>($MeasurementsTable.$converterdisplayAreaUnitn);
  @override
  late final GeneratedColumnWithTypeConverter<DistanceUnit?, int>
  displayDistanceUnit =
      GeneratedColumn<int>(
        'display_distance_unit',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DistanceUnit?>(
        $MeasurementsTable.$converterdisplayDistanceUnitn,
      );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitPriceCurrencyMeta = const VerificationMeta(
    'unitPriceCurrency',
  );
  @override
  late final GeneratedColumn<String> unitPriceCurrency =
      GeneratedColumn<String>(
        'unit_price_currency',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<AreaUnit?, int> unitPriceArea =
      GeneratedColumn<int>(
        'unit_price_area',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<AreaUnit?>($MeasurementsTable.$converterunitPriceArean);
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minLatMeta = const VerificationMeta('minLat');
  @override
  late final GeneratedColumn<double> minLat = GeneratedColumn<double>(
    'min_lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minLngMeta = const VerificationMeta('minLng');
  @override
  late final GeneratedColumn<double> minLng = GeneratedColumn<double>(
    'min_lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxLatMeta = const VerificationMeta('maxLat');
  @override
  late final GeneratedColumn<double> maxLat = GeneratedColumn<double>(
    'max_lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxLngMeta = const VerificationMeta('maxLng');
  @override
  late final GeneratedColumn<double> maxLng = GeneratedColumn<double>(
    'max_lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WalkRunState?, int> walkState =
      GeneratedColumn<int>(
        'walk_state',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<WalkRunState?>($MeasurementsTable.$converterwalkStaten);
  static const VerificationMeta _walkStartedAtMeta = const VerificationMeta(
    'walkStartedAt',
  );
  @override
  late final GeneratedColumn<DateTime> walkStartedAt =
      GeneratedColumn<DateTime>(
        'walk_started_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _walkElapsedSecMeta = const VerificationMeta(
    'walkElapsedSec',
  );
  @override
  late final GeneratedColumn<int> walkElapsedSec = GeneratedColumn<int>(
    'walk_elapsed_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _walkLastResumeAtMeta = const VerificationMeta(
    'walkLastResumeAt',
  );
  @override
  late final GeneratedColumn<DateTime> walkLastResumeAt =
      GeneratedColumn<DateTime>(
        'walk_last_resume_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameLower,
    type,
    status,
    notes,
    areaM2,
    perimeterM,
    distanceM,
    durationSec,
    pointCount,
    segmentCount,
    isClosed,
    selfIntersects,
    mapStyle,
    displayAreaUnit,
    displayDistanceUnit,
    unitPrice,
    unitPriceCurrency,
    unitPriceArea,
    thumbnailPath,
    minLat,
    minLng,
    maxLat,
    maxLng,
    walkState,
    walkStartedAt,
    walkElapsedSec,
    walkLastResumeAt,
    createdAt,
    updatedAt,
    savedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurements';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeasurementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('name_lower')) {
      context.handle(
        _nameLowerMeta,
        nameLower.isAcceptableOrUnknown(data['name_lower']!, _nameLowerMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('area_m2')) {
      context.handle(
        _areaM2Meta,
        areaM2.isAcceptableOrUnknown(data['area_m2']!, _areaM2Meta),
      );
    }
    if (data.containsKey('perimeter_m')) {
      context.handle(
        _perimeterMMeta,
        perimeterM.isAcceptableOrUnknown(data['perimeter_m']!, _perimeterMMeta),
      );
    }
    if (data.containsKey('distance_m')) {
      context.handle(
        _distanceMMeta,
        distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta),
      );
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    }
    if (data.containsKey('point_count')) {
      context.handle(
        _pointCountMeta,
        pointCount.isAcceptableOrUnknown(data['point_count']!, _pointCountMeta),
      );
    }
    if (data.containsKey('segment_count')) {
      context.handle(
        _segmentCountMeta,
        segmentCount.isAcceptableOrUnknown(
          data['segment_count']!,
          _segmentCountMeta,
        ),
      );
    }
    if (data.containsKey('is_closed')) {
      context.handle(
        _isClosedMeta,
        isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta),
      );
    }
    if (data.containsKey('self_intersects')) {
      context.handle(
        _selfIntersectsMeta,
        selfIntersects.isAcceptableOrUnknown(
          data['self_intersects']!,
          _selfIntersectsMeta,
        ),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    }
    if (data.containsKey('unit_price_currency')) {
      context.handle(
        _unitPriceCurrencyMeta,
        unitPriceCurrency.isAcceptableOrUnknown(
          data['unit_price_currency']!,
          _unitPriceCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('min_lat')) {
      context.handle(
        _minLatMeta,
        minLat.isAcceptableOrUnknown(data['min_lat']!, _minLatMeta),
      );
    }
    if (data.containsKey('min_lng')) {
      context.handle(
        _minLngMeta,
        minLng.isAcceptableOrUnknown(data['min_lng']!, _minLngMeta),
      );
    }
    if (data.containsKey('max_lat')) {
      context.handle(
        _maxLatMeta,
        maxLat.isAcceptableOrUnknown(data['max_lat']!, _maxLatMeta),
      );
    }
    if (data.containsKey('max_lng')) {
      context.handle(
        _maxLngMeta,
        maxLng.isAcceptableOrUnknown(data['max_lng']!, _maxLngMeta),
      );
    }
    if (data.containsKey('walk_started_at')) {
      context.handle(
        _walkStartedAtMeta,
        walkStartedAt.isAcceptableOrUnknown(
          data['walk_started_at']!,
          _walkStartedAtMeta,
        ),
      );
    }
    if (data.containsKey('walk_elapsed_sec')) {
      context.handle(
        _walkElapsedSecMeta,
        walkElapsedSec.isAcceptableOrUnknown(
          data['walk_elapsed_sec']!,
          _walkElapsedSecMeta,
        ),
      );
    }
    if (data.containsKey('walk_last_resume_at')) {
      context.handle(
        _walkLastResumeAtMeta,
        walkLastResumeAt.isAcceptableOrUnknown(
          data['walk_last_resume_at']!,
          _walkLastResumeAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeasurementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeasurementRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      nameLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_lower'],
      ),
      type: $MeasurementsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      status: $MeasurementsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      areaM2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_m2'],
      ),
      perimeterM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}perimeter_m'],
      ),
      distanceM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_m'],
      ),
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      ),
      pointCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}point_count'],
      )!,
      segmentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}segment_count'],
      )!,
      isClosed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_closed'],
      )!,
      selfIntersects: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}self_intersects'],
      )!,
      mapStyle: $MeasurementsTable.$convertermapStyle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}map_style'],
        )!,
      ),
      displayAreaUnit: $MeasurementsTable.$converterdisplayAreaUnitn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}display_area_unit'],
        ),
      ),
      displayDistanceUnit: $MeasurementsTable.$converterdisplayDistanceUnitn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.int,
              data['${effectivePrefix}display_distance_unit'],
            ),
          ),
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      ),
      unitPriceCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_price_currency'],
      ),
      unitPriceArea: $MeasurementsTable.$converterunitPriceArean.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}unit_price_area'],
        ),
      ),
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      minLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_lat'],
      ),
      minLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_lng'],
      ),
      maxLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_lat'],
      ),
      maxLng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_lng'],
      ),
      walkState: $MeasurementsTable.$converterwalkStaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}walk_state'],
        ),
      ),
      walkStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}walk_started_at'],
      ),
      walkElapsedSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}walk_elapsed_sec'],
      ),
      walkLastResumeAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}walk_last_resume_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      ),
    );
  }

  @override
  $MeasurementsTable createAlias(String alias) {
    return $MeasurementsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MeasurementType, int, int> $convertertype =
      const EnumIndexConverter<MeasurementType>(MeasurementType.values);
  static JsonTypeConverter2<MeasurementStatus, int, int> $converterstatus =
      const EnumIndexConverter<MeasurementStatus>(MeasurementStatus.values);
  static JsonTypeConverter2<MapStyle, int, int> $convertermapStyle =
      const EnumIndexConverter<MapStyle>(MapStyle.values);
  static JsonTypeConverter2<AreaUnit, int, int> $converterdisplayAreaUnit =
      const EnumIndexConverter<AreaUnit>(AreaUnit.values);
  static JsonTypeConverter2<AreaUnit?, int?, int?> $converterdisplayAreaUnitn =
      JsonTypeConverter2.asNullable($converterdisplayAreaUnit);
  static JsonTypeConverter2<DistanceUnit, int, int>
  $converterdisplayDistanceUnit = const EnumIndexConverter<DistanceUnit>(
    DistanceUnit.values,
  );
  static JsonTypeConverter2<DistanceUnit?, int?, int?>
  $converterdisplayDistanceUnitn = JsonTypeConverter2.asNullable(
    $converterdisplayDistanceUnit,
  );
  static JsonTypeConverter2<AreaUnit, int, int> $converterunitPriceArea =
      const EnumIndexConverter<AreaUnit>(AreaUnit.values);
  static JsonTypeConverter2<AreaUnit?, int?, int?> $converterunitPriceArean =
      JsonTypeConverter2.asNullable($converterunitPriceArea);
  static JsonTypeConverter2<WalkRunState, int, int> $converterwalkState =
      const EnumIndexConverter<WalkRunState>(WalkRunState.values);
  static JsonTypeConverter2<WalkRunState?, int?, int?> $converterwalkStaten =
      JsonTypeConverter2.asNullable($converterwalkState);
}

class MeasurementRow extends DataClass implements Insertable<MeasurementRow> {
  final String id;
  final String? name;

  /// Search key: lower-cased, Vietnamese diacritics folded (`foldForSearch`).
  final String? nameLower;
  final MeasurementType type;
  final MeasurementStatus status;
  final String? notes;
  final double? areaM2;
  final double? perimeterM;
  final double? distanceM;
  final int? durationSec;
  final int pointCount;
  final int segmentCount;
  final bool isClosed;
  final bool selfIntersects;
  final MapStyle mapStyle;
  final AreaUnit? displayAreaUnit;
  final DistanceUnit? displayDistanceUnit;
  final double? unitPrice;
  final String? unitPriceCurrency;
  final AreaUnit? unitPriceArea;

  /// Relative to the app documents directory.
  final String? thumbnailPath;
  final double? minLat;
  final double? minLng;
  final double? maxLat;
  final double? maxLng;
  final WalkRunState? walkState;
  final DateTime? walkStartedAt;
  final int? walkElapsedSec;
  final DateTime? walkLastResumeAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? savedAt;
  const MeasurementRow({
    required this.id,
    this.name,
    this.nameLower,
    required this.type,
    required this.status,
    this.notes,
    this.areaM2,
    this.perimeterM,
    this.distanceM,
    this.durationSec,
    required this.pointCount,
    required this.segmentCount,
    required this.isClosed,
    required this.selfIntersects,
    required this.mapStyle,
    this.displayAreaUnit,
    this.displayDistanceUnit,
    this.unitPrice,
    this.unitPriceCurrency,
    this.unitPriceArea,
    this.thumbnailPath,
    this.minLat,
    this.minLng,
    this.maxLat,
    this.maxLng,
    this.walkState,
    this.walkStartedAt,
    this.walkElapsedSec,
    this.walkLastResumeAt,
    required this.createdAt,
    required this.updatedAt,
    this.savedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || nameLower != null) {
      map['name_lower'] = Variable<String>(nameLower);
    }
    {
      map['type'] = Variable<int>(
        $MeasurementsTable.$convertertype.toSql(type),
      );
    }
    {
      map['status'] = Variable<int>(
        $MeasurementsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || areaM2 != null) {
      map['area_m2'] = Variable<double>(areaM2);
    }
    if (!nullToAbsent || perimeterM != null) {
      map['perimeter_m'] = Variable<double>(perimeterM);
    }
    if (!nullToAbsent || distanceM != null) {
      map['distance_m'] = Variable<double>(distanceM);
    }
    if (!nullToAbsent || durationSec != null) {
      map['duration_sec'] = Variable<int>(durationSec);
    }
    map['point_count'] = Variable<int>(pointCount);
    map['segment_count'] = Variable<int>(segmentCount);
    map['is_closed'] = Variable<bool>(isClosed);
    map['self_intersects'] = Variable<bool>(selfIntersects);
    {
      map['map_style'] = Variable<int>(
        $MeasurementsTable.$convertermapStyle.toSql(mapStyle),
      );
    }
    if (!nullToAbsent || displayAreaUnit != null) {
      map['display_area_unit'] = Variable<int>(
        $MeasurementsTable.$converterdisplayAreaUnitn.toSql(displayAreaUnit),
      );
    }
    if (!nullToAbsent || displayDistanceUnit != null) {
      map['display_distance_unit'] = Variable<int>(
        $MeasurementsTable.$converterdisplayDistanceUnitn.toSql(
          displayDistanceUnit,
        ),
      );
    }
    if (!nullToAbsent || unitPrice != null) {
      map['unit_price'] = Variable<double>(unitPrice);
    }
    if (!nullToAbsent || unitPriceCurrency != null) {
      map['unit_price_currency'] = Variable<String>(unitPriceCurrency);
    }
    if (!nullToAbsent || unitPriceArea != null) {
      map['unit_price_area'] = Variable<int>(
        $MeasurementsTable.$converterunitPriceArean.toSql(unitPriceArea),
      );
    }
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    if (!nullToAbsent || minLat != null) {
      map['min_lat'] = Variable<double>(minLat);
    }
    if (!nullToAbsent || minLng != null) {
      map['min_lng'] = Variable<double>(minLng);
    }
    if (!nullToAbsent || maxLat != null) {
      map['max_lat'] = Variable<double>(maxLat);
    }
    if (!nullToAbsent || maxLng != null) {
      map['max_lng'] = Variable<double>(maxLng);
    }
    if (!nullToAbsent || walkState != null) {
      map['walk_state'] = Variable<int>(
        $MeasurementsTable.$converterwalkStaten.toSql(walkState),
      );
    }
    if (!nullToAbsent || walkStartedAt != null) {
      map['walk_started_at'] = Variable<DateTime>(walkStartedAt);
    }
    if (!nullToAbsent || walkElapsedSec != null) {
      map['walk_elapsed_sec'] = Variable<int>(walkElapsedSec);
    }
    if (!nullToAbsent || walkLastResumeAt != null) {
      map['walk_last_resume_at'] = Variable<DateTime>(walkLastResumeAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || savedAt != null) {
      map['saved_at'] = Variable<DateTime>(savedAt);
    }
    return map;
  }

  MeasurementsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      nameLower: nameLower == null && nullToAbsent
          ? const Value.absent()
          : Value(nameLower),
      type: Value(type),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      areaM2: areaM2 == null && nullToAbsent
          ? const Value.absent()
          : Value(areaM2),
      perimeterM: perimeterM == null && nullToAbsent
          ? const Value.absent()
          : Value(perimeterM),
      distanceM: distanceM == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceM),
      durationSec: durationSec == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSec),
      pointCount: Value(pointCount),
      segmentCount: Value(segmentCount),
      isClosed: Value(isClosed),
      selfIntersects: Value(selfIntersects),
      mapStyle: Value(mapStyle),
      displayAreaUnit: displayAreaUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(displayAreaUnit),
      displayDistanceUnit: displayDistanceUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(displayDistanceUnit),
      unitPrice: unitPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(unitPrice),
      unitPriceCurrency: unitPriceCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(unitPriceCurrency),
      unitPriceArea: unitPriceArea == null && nullToAbsent
          ? const Value.absent()
          : Value(unitPriceArea),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      minLat: minLat == null && nullToAbsent
          ? const Value.absent()
          : Value(minLat),
      minLng: minLng == null && nullToAbsent
          ? const Value.absent()
          : Value(minLng),
      maxLat: maxLat == null && nullToAbsent
          ? const Value.absent()
          : Value(maxLat),
      maxLng: maxLng == null && nullToAbsent
          ? const Value.absent()
          : Value(maxLng),
      walkState: walkState == null && nullToAbsent
          ? const Value.absent()
          : Value(walkState),
      walkStartedAt: walkStartedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(walkStartedAt),
      walkElapsedSec: walkElapsedSec == null && nullToAbsent
          ? const Value.absent()
          : Value(walkElapsedSec),
      walkLastResumeAt: walkLastResumeAt == null && nullToAbsent
          ? const Value.absent()
          : Value(walkLastResumeAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      savedAt: savedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(savedAt),
    );
  }

  factory MeasurementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasurementRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      nameLower: serializer.fromJson<String?>(json['nameLower']),
      type: $MeasurementsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      status: $MeasurementsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      areaM2: serializer.fromJson<double?>(json['areaM2']),
      perimeterM: serializer.fromJson<double?>(json['perimeterM']),
      distanceM: serializer.fromJson<double?>(json['distanceM']),
      durationSec: serializer.fromJson<int?>(json['durationSec']),
      pointCount: serializer.fromJson<int>(json['pointCount']),
      segmentCount: serializer.fromJson<int>(json['segmentCount']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
      selfIntersects: serializer.fromJson<bool>(json['selfIntersects']),
      mapStyle: $MeasurementsTable.$convertermapStyle.fromJson(
        serializer.fromJson<int>(json['mapStyle']),
      ),
      displayAreaUnit: $MeasurementsTable.$converterdisplayAreaUnitn.fromJson(
        serializer.fromJson<int?>(json['displayAreaUnit']),
      ),
      displayDistanceUnit: $MeasurementsTable.$converterdisplayDistanceUnitn
          .fromJson(serializer.fromJson<int?>(json['displayDistanceUnit'])),
      unitPrice: serializer.fromJson<double?>(json['unitPrice']),
      unitPriceCurrency: serializer.fromJson<String?>(
        json['unitPriceCurrency'],
      ),
      unitPriceArea: $MeasurementsTable.$converterunitPriceArean.fromJson(
        serializer.fromJson<int?>(json['unitPriceArea']),
      ),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      minLat: serializer.fromJson<double?>(json['minLat']),
      minLng: serializer.fromJson<double?>(json['minLng']),
      maxLat: serializer.fromJson<double?>(json['maxLat']),
      maxLng: serializer.fromJson<double?>(json['maxLng']),
      walkState: $MeasurementsTable.$converterwalkStaten.fromJson(
        serializer.fromJson<int?>(json['walkState']),
      ),
      walkStartedAt: serializer.fromJson<DateTime?>(json['walkStartedAt']),
      walkElapsedSec: serializer.fromJson<int?>(json['walkElapsedSec']),
      walkLastResumeAt: serializer.fromJson<DateTime?>(
        json['walkLastResumeAt'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      savedAt: serializer.fromJson<DateTime?>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'nameLower': serializer.toJson<String?>(nameLower),
      'type': serializer.toJson<int>(
        $MeasurementsTable.$convertertype.toJson(type),
      ),
      'status': serializer.toJson<int>(
        $MeasurementsTable.$converterstatus.toJson(status),
      ),
      'notes': serializer.toJson<String?>(notes),
      'areaM2': serializer.toJson<double?>(areaM2),
      'perimeterM': serializer.toJson<double?>(perimeterM),
      'distanceM': serializer.toJson<double?>(distanceM),
      'durationSec': serializer.toJson<int?>(durationSec),
      'pointCount': serializer.toJson<int>(pointCount),
      'segmentCount': serializer.toJson<int>(segmentCount),
      'isClosed': serializer.toJson<bool>(isClosed),
      'selfIntersects': serializer.toJson<bool>(selfIntersects),
      'mapStyle': serializer.toJson<int>(
        $MeasurementsTable.$convertermapStyle.toJson(mapStyle),
      ),
      'displayAreaUnit': serializer.toJson<int?>(
        $MeasurementsTable.$converterdisplayAreaUnitn.toJson(displayAreaUnit),
      ),
      'displayDistanceUnit': serializer.toJson<int?>(
        $MeasurementsTable.$converterdisplayDistanceUnitn.toJson(
          displayDistanceUnit,
        ),
      ),
      'unitPrice': serializer.toJson<double?>(unitPrice),
      'unitPriceCurrency': serializer.toJson<String?>(unitPriceCurrency),
      'unitPriceArea': serializer.toJson<int?>(
        $MeasurementsTable.$converterunitPriceArean.toJson(unitPriceArea),
      ),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'minLat': serializer.toJson<double?>(minLat),
      'minLng': serializer.toJson<double?>(minLng),
      'maxLat': serializer.toJson<double?>(maxLat),
      'maxLng': serializer.toJson<double?>(maxLng),
      'walkState': serializer.toJson<int?>(
        $MeasurementsTable.$converterwalkStaten.toJson(walkState),
      ),
      'walkStartedAt': serializer.toJson<DateTime?>(walkStartedAt),
      'walkElapsedSec': serializer.toJson<int?>(walkElapsedSec),
      'walkLastResumeAt': serializer.toJson<DateTime?>(walkLastResumeAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'savedAt': serializer.toJson<DateTime?>(savedAt),
    };
  }

  MeasurementRow copyWith({
    String? id,
    Value<String?> name = const Value.absent(),
    Value<String?> nameLower = const Value.absent(),
    MeasurementType? type,
    MeasurementStatus? status,
    Value<String?> notes = const Value.absent(),
    Value<double?> areaM2 = const Value.absent(),
    Value<double?> perimeterM = const Value.absent(),
    Value<double?> distanceM = const Value.absent(),
    Value<int?> durationSec = const Value.absent(),
    int? pointCount,
    int? segmentCount,
    bool? isClosed,
    bool? selfIntersects,
    MapStyle? mapStyle,
    Value<AreaUnit?> displayAreaUnit = const Value.absent(),
    Value<DistanceUnit?> displayDistanceUnit = const Value.absent(),
    Value<double?> unitPrice = const Value.absent(),
    Value<String?> unitPriceCurrency = const Value.absent(),
    Value<AreaUnit?> unitPriceArea = const Value.absent(),
    Value<String?> thumbnailPath = const Value.absent(),
    Value<double?> minLat = const Value.absent(),
    Value<double?> minLng = const Value.absent(),
    Value<double?> maxLat = const Value.absent(),
    Value<double?> maxLng = const Value.absent(),
    Value<WalkRunState?> walkState = const Value.absent(),
    Value<DateTime?> walkStartedAt = const Value.absent(),
    Value<int?> walkElapsedSec = const Value.absent(),
    Value<DateTime?> walkLastResumeAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> savedAt = const Value.absent(),
  }) => MeasurementRow(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    nameLower: nameLower.present ? nameLower.value : this.nameLower,
    type: type ?? this.type,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    areaM2: areaM2.present ? areaM2.value : this.areaM2,
    perimeterM: perimeterM.present ? perimeterM.value : this.perimeterM,
    distanceM: distanceM.present ? distanceM.value : this.distanceM,
    durationSec: durationSec.present ? durationSec.value : this.durationSec,
    pointCount: pointCount ?? this.pointCount,
    segmentCount: segmentCount ?? this.segmentCount,
    isClosed: isClosed ?? this.isClosed,
    selfIntersects: selfIntersects ?? this.selfIntersects,
    mapStyle: mapStyle ?? this.mapStyle,
    displayAreaUnit: displayAreaUnit.present
        ? displayAreaUnit.value
        : this.displayAreaUnit,
    displayDistanceUnit: displayDistanceUnit.present
        ? displayDistanceUnit.value
        : this.displayDistanceUnit,
    unitPrice: unitPrice.present ? unitPrice.value : this.unitPrice,
    unitPriceCurrency: unitPriceCurrency.present
        ? unitPriceCurrency.value
        : this.unitPriceCurrency,
    unitPriceArea: unitPriceArea.present
        ? unitPriceArea.value
        : this.unitPriceArea,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    minLat: minLat.present ? minLat.value : this.minLat,
    minLng: minLng.present ? minLng.value : this.minLng,
    maxLat: maxLat.present ? maxLat.value : this.maxLat,
    maxLng: maxLng.present ? maxLng.value : this.maxLng,
    walkState: walkState.present ? walkState.value : this.walkState,
    walkStartedAt: walkStartedAt.present
        ? walkStartedAt.value
        : this.walkStartedAt,
    walkElapsedSec: walkElapsedSec.present
        ? walkElapsedSec.value
        : this.walkElapsedSec,
    walkLastResumeAt: walkLastResumeAt.present
        ? walkLastResumeAt.value
        : this.walkLastResumeAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    savedAt: savedAt.present ? savedAt.value : this.savedAt,
  );
  MeasurementRow copyWithCompanion(MeasurementsCompanion data) {
    return MeasurementRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameLower: data.nameLower.present ? data.nameLower.value : this.nameLower,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      areaM2: data.areaM2.present ? data.areaM2.value : this.areaM2,
      perimeterM: data.perimeterM.present
          ? data.perimeterM.value
          : this.perimeterM,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      pointCount: data.pointCount.present
          ? data.pointCount.value
          : this.pointCount,
      segmentCount: data.segmentCount.present
          ? data.segmentCount.value
          : this.segmentCount,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
      selfIntersects: data.selfIntersects.present
          ? data.selfIntersects.value
          : this.selfIntersects,
      mapStyle: data.mapStyle.present ? data.mapStyle.value : this.mapStyle,
      displayAreaUnit: data.displayAreaUnit.present
          ? data.displayAreaUnit.value
          : this.displayAreaUnit,
      displayDistanceUnit: data.displayDistanceUnit.present
          ? data.displayDistanceUnit.value
          : this.displayDistanceUnit,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      unitPriceCurrency: data.unitPriceCurrency.present
          ? data.unitPriceCurrency.value
          : this.unitPriceCurrency,
      unitPriceArea: data.unitPriceArea.present
          ? data.unitPriceArea.value
          : this.unitPriceArea,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      minLat: data.minLat.present ? data.minLat.value : this.minLat,
      minLng: data.minLng.present ? data.minLng.value : this.minLng,
      maxLat: data.maxLat.present ? data.maxLat.value : this.maxLat,
      maxLng: data.maxLng.present ? data.maxLng.value : this.maxLng,
      walkState: data.walkState.present ? data.walkState.value : this.walkState,
      walkStartedAt: data.walkStartedAt.present
          ? data.walkStartedAt.value
          : this.walkStartedAt,
      walkElapsedSec: data.walkElapsedSec.present
          ? data.walkElapsedSec.value
          : this.walkElapsedSec,
      walkLastResumeAt: data.walkLastResumeAt.present
          ? data.walkLastResumeAt.value
          : this.walkLastResumeAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameLower: $nameLower, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('areaM2: $areaM2, ')
          ..write('perimeterM: $perimeterM, ')
          ..write('distanceM: $distanceM, ')
          ..write('durationSec: $durationSec, ')
          ..write('pointCount: $pointCount, ')
          ..write('segmentCount: $segmentCount, ')
          ..write('isClosed: $isClosed, ')
          ..write('selfIntersects: $selfIntersects, ')
          ..write('mapStyle: $mapStyle, ')
          ..write('displayAreaUnit: $displayAreaUnit, ')
          ..write('displayDistanceUnit: $displayDistanceUnit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('unitPriceCurrency: $unitPriceCurrency, ')
          ..write('unitPriceArea: $unitPriceArea, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('minLat: $minLat, ')
          ..write('minLng: $minLng, ')
          ..write('maxLat: $maxLat, ')
          ..write('maxLng: $maxLng, ')
          ..write('walkState: $walkState, ')
          ..write('walkStartedAt: $walkStartedAt, ')
          ..write('walkElapsedSec: $walkElapsedSec, ')
          ..write('walkLastResumeAt: $walkLastResumeAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    nameLower,
    type,
    status,
    notes,
    areaM2,
    perimeterM,
    distanceM,
    durationSec,
    pointCount,
    segmentCount,
    isClosed,
    selfIntersects,
    mapStyle,
    displayAreaUnit,
    displayDistanceUnit,
    unitPrice,
    unitPriceCurrency,
    unitPriceArea,
    thumbnailPath,
    minLat,
    minLng,
    maxLat,
    maxLng,
    walkState,
    walkStartedAt,
    walkElapsedSec,
    walkLastResumeAt,
    createdAt,
    updatedAt,
    savedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasurementRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameLower == this.nameLower &&
          other.type == this.type &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.areaM2 == this.areaM2 &&
          other.perimeterM == this.perimeterM &&
          other.distanceM == this.distanceM &&
          other.durationSec == this.durationSec &&
          other.pointCount == this.pointCount &&
          other.segmentCount == this.segmentCount &&
          other.isClosed == this.isClosed &&
          other.selfIntersects == this.selfIntersects &&
          other.mapStyle == this.mapStyle &&
          other.displayAreaUnit == this.displayAreaUnit &&
          other.displayDistanceUnit == this.displayDistanceUnit &&
          other.unitPrice == this.unitPrice &&
          other.unitPriceCurrency == this.unitPriceCurrency &&
          other.unitPriceArea == this.unitPriceArea &&
          other.thumbnailPath == this.thumbnailPath &&
          other.minLat == this.minLat &&
          other.minLng == this.minLng &&
          other.maxLat == this.maxLat &&
          other.maxLng == this.maxLng &&
          other.walkState == this.walkState &&
          other.walkStartedAt == this.walkStartedAt &&
          other.walkElapsedSec == this.walkElapsedSec &&
          other.walkLastResumeAt == this.walkLastResumeAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.savedAt == this.savedAt);
}

class MeasurementsCompanion extends UpdateCompanion<MeasurementRow> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> nameLower;
  final Value<MeasurementType> type;
  final Value<MeasurementStatus> status;
  final Value<String?> notes;
  final Value<double?> areaM2;
  final Value<double?> perimeterM;
  final Value<double?> distanceM;
  final Value<int?> durationSec;
  final Value<int> pointCount;
  final Value<int> segmentCount;
  final Value<bool> isClosed;
  final Value<bool> selfIntersects;
  final Value<MapStyle> mapStyle;
  final Value<AreaUnit?> displayAreaUnit;
  final Value<DistanceUnit?> displayDistanceUnit;
  final Value<double?> unitPrice;
  final Value<String?> unitPriceCurrency;
  final Value<AreaUnit?> unitPriceArea;
  final Value<String?> thumbnailPath;
  final Value<double?> minLat;
  final Value<double?> minLng;
  final Value<double?> maxLat;
  final Value<double?> maxLng;
  final Value<WalkRunState?> walkState;
  final Value<DateTime?> walkStartedAt;
  final Value<int?> walkElapsedSec;
  final Value<DateTime?> walkLastResumeAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> savedAt;
  final Value<int> rowid;
  const MeasurementsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameLower = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.perimeterM = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.pointCount = const Value.absent(),
    this.segmentCount = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.selfIntersects = const Value.absent(),
    this.mapStyle = const Value.absent(),
    this.displayAreaUnit = const Value.absent(),
    this.displayDistanceUnit = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.unitPriceCurrency = const Value.absent(),
    this.unitPriceArea = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.minLat = const Value.absent(),
    this.minLng = const Value.absent(),
    this.maxLat = const Value.absent(),
    this.maxLng = const Value.absent(),
    this.walkState = const Value.absent(),
    this.walkStartedAt = const Value.absent(),
    this.walkElapsedSec = const Value.absent(),
    this.walkLastResumeAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeasurementsCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.nameLower = const Value.absent(),
    required MeasurementType type,
    required MeasurementStatus status,
    this.notes = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.perimeterM = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.pointCount = const Value.absent(),
    this.segmentCount = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.selfIntersects = const Value.absent(),
    required MapStyle mapStyle,
    this.displayAreaUnit = const Value.absent(),
    this.displayDistanceUnit = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.unitPriceCurrency = const Value.absent(),
    this.unitPriceArea = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.minLat = const Value.absent(),
    this.minLng = const Value.absent(),
    this.maxLat = const Value.absent(),
    this.maxLng = const Value.absent(),
    this.walkState = const Value.absent(),
    this.walkStartedAt = const Value.absent(),
    this.walkElapsedSec = const Value.absent(),
    this.walkLastResumeAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       status = Value(status),
       mapStyle = Value(mapStyle),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MeasurementRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameLower,
    Expression<int>? type,
    Expression<int>? status,
    Expression<String>? notes,
    Expression<double>? areaM2,
    Expression<double>? perimeterM,
    Expression<double>? distanceM,
    Expression<int>? durationSec,
    Expression<int>? pointCount,
    Expression<int>? segmentCount,
    Expression<bool>? isClosed,
    Expression<bool>? selfIntersects,
    Expression<int>? mapStyle,
    Expression<int>? displayAreaUnit,
    Expression<int>? displayDistanceUnit,
    Expression<double>? unitPrice,
    Expression<String>? unitPriceCurrency,
    Expression<int>? unitPriceArea,
    Expression<String>? thumbnailPath,
    Expression<double>? minLat,
    Expression<double>? minLng,
    Expression<double>? maxLat,
    Expression<double>? maxLng,
    Expression<int>? walkState,
    Expression<DateTime>? walkStartedAt,
    Expression<int>? walkElapsedSec,
    Expression<DateTime>? walkLastResumeAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameLower != null) 'name_lower': nameLower,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (areaM2 != null) 'area_m2': areaM2,
      if (perimeterM != null) 'perimeter_m': perimeterM,
      if (distanceM != null) 'distance_m': distanceM,
      if (durationSec != null) 'duration_sec': durationSec,
      if (pointCount != null) 'point_count': pointCount,
      if (segmentCount != null) 'segment_count': segmentCount,
      if (isClosed != null) 'is_closed': isClosed,
      if (selfIntersects != null) 'self_intersects': selfIntersects,
      if (mapStyle != null) 'map_style': mapStyle,
      if (displayAreaUnit != null) 'display_area_unit': displayAreaUnit,
      if (displayDistanceUnit != null)
        'display_distance_unit': displayDistanceUnit,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (unitPriceCurrency != null) 'unit_price_currency': unitPriceCurrency,
      if (unitPriceArea != null) 'unit_price_area': unitPriceArea,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (minLat != null) 'min_lat': minLat,
      if (minLng != null) 'min_lng': minLng,
      if (maxLat != null) 'max_lat': maxLat,
      if (maxLng != null) 'max_lng': maxLng,
      if (walkState != null) 'walk_state': walkState,
      if (walkStartedAt != null) 'walk_started_at': walkStartedAt,
      if (walkElapsedSec != null) 'walk_elapsed_sec': walkElapsedSec,
      if (walkLastResumeAt != null) 'walk_last_resume_at': walkLastResumeAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeasurementsCompanion copyWith({
    Value<String>? id,
    Value<String?>? name,
    Value<String?>? nameLower,
    Value<MeasurementType>? type,
    Value<MeasurementStatus>? status,
    Value<String?>? notes,
    Value<double?>? areaM2,
    Value<double?>? perimeterM,
    Value<double?>? distanceM,
    Value<int?>? durationSec,
    Value<int>? pointCount,
    Value<int>? segmentCount,
    Value<bool>? isClosed,
    Value<bool>? selfIntersects,
    Value<MapStyle>? mapStyle,
    Value<AreaUnit?>? displayAreaUnit,
    Value<DistanceUnit?>? displayDistanceUnit,
    Value<double?>? unitPrice,
    Value<String?>? unitPriceCurrency,
    Value<AreaUnit?>? unitPriceArea,
    Value<String?>? thumbnailPath,
    Value<double?>? minLat,
    Value<double?>? minLng,
    Value<double?>? maxLat,
    Value<double?>? maxLng,
    Value<WalkRunState?>? walkState,
    Value<DateTime?>? walkStartedAt,
    Value<int?>? walkElapsedSec,
    Value<DateTime?>? walkLastResumeAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? savedAt,
    Value<int>? rowid,
  }) {
    return MeasurementsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameLower: nameLower ?? this.nameLower,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      areaM2: areaM2 ?? this.areaM2,
      perimeterM: perimeterM ?? this.perimeterM,
      distanceM: distanceM ?? this.distanceM,
      durationSec: durationSec ?? this.durationSec,
      pointCount: pointCount ?? this.pointCount,
      segmentCount: segmentCount ?? this.segmentCount,
      isClosed: isClosed ?? this.isClosed,
      selfIntersects: selfIntersects ?? this.selfIntersects,
      mapStyle: mapStyle ?? this.mapStyle,
      displayAreaUnit: displayAreaUnit ?? this.displayAreaUnit,
      displayDistanceUnit: displayDistanceUnit ?? this.displayDistanceUnit,
      unitPrice: unitPrice ?? this.unitPrice,
      unitPriceCurrency: unitPriceCurrency ?? this.unitPriceCurrency,
      unitPriceArea: unitPriceArea ?? this.unitPriceArea,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      minLat: minLat ?? this.minLat,
      minLng: minLng ?? this.minLng,
      maxLat: maxLat ?? this.maxLat,
      maxLng: maxLng ?? this.maxLng,
      walkState: walkState ?? this.walkState,
      walkStartedAt: walkStartedAt ?? this.walkStartedAt,
      walkElapsedSec: walkElapsedSec ?? this.walkElapsedSec,
      walkLastResumeAt: walkLastResumeAt ?? this.walkLastResumeAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameLower.present) {
      map['name_lower'] = Variable<String>(nameLower.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $MeasurementsTable.$convertertype.toSql(type.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $MeasurementsTable.$converterstatus.toSql(status.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (areaM2.present) {
      map['area_m2'] = Variable<double>(areaM2.value);
    }
    if (perimeterM.present) {
      map['perimeter_m'] = Variable<double>(perimeterM.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<double>(distanceM.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (pointCount.present) {
      map['point_count'] = Variable<int>(pointCount.value);
    }
    if (segmentCount.present) {
      map['segment_count'] = Variable<int>(segmentCount.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    if (selfIntersects.present) {
      map['self_intersects'] = Variable<bool>(selfIntersects.value);
    }
    if (mapStyle.present) {
      map['map_style'] = Variable<int>(
        $MeasurementsTable.$convertermapStyle.toSql(mapStyle.value),
      );
    }
    if (displayAreaUnit.present) {
      map['display_area_unit'] = Variable<int>(
        $MeasurementsTable.$converterdisplayAreaUnitn.toSql(
          displayAreaUnit.value,
        ),
      );
    }
    if (displayDistanceUnit.present) {
      map['display_distance_unit'] = Variable<int>(
        $MeasurementsTable.$converterdisplayDistanceUnitn.toSql(
          displayDistanceUnit.value,
        ),
      );
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (unitPriceCurrency.present) {
      map['unit_price_currency'] = Variable<String>(unitPriceCurrency.value);
    }
    if (unitPriceArea.present) {
      map['unit_price_area'] = Variable<int>(
        $MeasurementsTable.$converterunitPriceArean.toSql(unitPriceArea.value),
      );
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (minLat.present) {
      map['min_lat'] = Variable<double>(minLat.value);
    }
    if (minLng.present) {
      map['min_lng'] = Variable<double>(minLng.value);
    }
    if (maxLat.present) {
      map['max_lat'] = Variable<double>(maxLat.value);
    }
    if (maxLng.present) {
      map['max_lng'] = Variable<double>(maxLng.value);
    }
    if (walkState.present) {
      map['walk_state'] = Variable<int>(
        $MeasurementsTable.$converterwalkStaten.toSql(walkState.value),
      );
    }
    if (walkStartedAt.present) {
      map['walk_started_at'] = Variable<DateTime>(walkStartedAt.value);
    }
    if (walkElapsedSec.present) {
      map['walk_elapsed_sec'] = Variable<int>(walkElapsedSec.value);
    }
    if (walkLastResumeAt.present) {
      map['walk_last_resume_at'] = Variable<DateTime>(walkLastResumeAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameLower: $nameLower, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('areaM2: $areaM2, ')
          ..write('perimeterM: $perimeterM, ')
          ..write('distanceM: $distanceM, ')
          ..write('durationSec: $durationSec, ')
          ..write('pointCount: $pointCount, ')
          ..write('segmentCount: $segmentCount, ')
          ..write('isClosed: $isClosed, ')
          ..write('selfIntersects: $selfIntersects, ')
          ..write('mapStyle: $mapStyle, ')
          ..write('displayAreaUnit: $displayAreaUnit, ')
          ..write('displayDistanceUnit: $displayDistanceUnit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('unitPriceCurrency: $unitPriceCurrency, ')
          ..write('unitPriceArea: $unitPriceArea, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('minLat: $minLat, ')
          ..write('minLng: $minLng, ')
          ..write('maxLat: $maxLat, ')
          ..write('maxLng: $maxLng, ')
          ..write('walkState: $walkState, ')
          ..write('walkStartedAt: $walkStartedAt, ')
          ..write('walkElapsedSec: $walkElapsedSec, ')
          ..write('walkLastResumeAt: $walkLastResumeAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeasurePointsTable extends MeasurePoints
    with TableInfo<$MeasurePointsTable, PointRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurePointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measurementIdMeta = const VerificationMeta(
    'measurementId',
  );
  @override
  late final GeneratedColumn<String> measurementId = GeneratedColumn<String>(
    'measurement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES measurements (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _segmentIndexMeta = const VerificationMeta(
    'segmentIndex',
  );
  @override
  late final GeneratedColumn<int> segmentIndex = GeneratedColumn<int>(
    'segment_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _altitudeMeta = const VerificationMeta(
    'altitude',
  );
  @override
  late final GeneratedColumn<double> altitude = GeneratedColumn<double>(
    'altitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accuracyMeta = const VerificationMeta(
    'accuracy',
  );
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
    'accuracy',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
    'speed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bearingMeta = const VerificationMeta(
    'bearing',
  );
  @override
  late final GeneratedColumn<double> bearing = GeneratedColumn<double>(
    'bearing',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    measurementId,
    orderIndex,
    segmentIndex,
    lat,
    lng,
    altitude,
    accuracy,
    speed,
    bearing,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measure_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<PointRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('measurement_id')) {
      context.handle(
        _measurementIdMeta,
        measurementId.isAcceptableOrUnknown(
          data['measurement_id']!,
          _measurementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('segment_index')) {
      context.handle(
        _segmentIndexMeta,
        segmentIndex.isAcceptableOrUnknown(
          data['segment_index']!,
          _segmentIndexMeta,
        ),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    if (data.containsKey('altitude')) {
      context.handle(
        _altitudeMeta,
        altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta),
      );
    }
    if (data.containsKey('accuracy')) {
      context.handle(
        _accuracyMeta,
        accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta),
      );
    }
    if (data.containsKey('speed')) {
      context.handle(
        _speedMeta,
        speed.isAcceptableOrUnknown(data['speed']!, _speedMeta),
      );
    }
    if (data.containsKey('bearing')) {
      context.handle(
        _bearingMeta,
        bearing.isAcceptableOrUnknown(data['bearing']!, _bearingMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PointRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PointRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      measurementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      segmentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}segment_index'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      )!,
      altitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude'],
      ),
      accuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy'],
      ),
      speed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed'],
      ),
      bearing: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bearing'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $MeasurePointsTable createAlias(String alias) {
    return $MeasurePointsTable(attachedDatabase, alias);
  }
}

class PointRow extends DataClass implements Insertable<PointRow> {
  final String id;
  final String measurementId;
  final int orderIndex;
  final int segmentIndex;
  final double lat;
  final double lng;
  final double? altitude;
  final double? accuracy;
  final double? speed;
  final double? bearing;
  final DateTime timestamp;
  const PointRow({
    required this.id,
    required this.measurementId,
    required this.orderIndex,
    required this.segmentIndex,
    required this.lat,
    required this.lng,
    this.altitude,
    this.accuracy,
    this.speed,
    this.bearing,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['measurement_id'] = Variable<String>(measurementId);
    map['order_index'] = Variable<int>(orderIndex);
    map['segment_index'] = Variable<int>(segmentIndex);
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    if (!nullToAbsent || altitude != null) {
      map['altitude'] = Variable<double>(altitude);
    }
    if (!nullToAbsent || accuracy != null) {
      map['accuracy'] = Variable<double>(accuracy);
    }
    if (!nullToAbsent || speed != null) {
      map['speed'] = Variable<double>(speed);
    }
    if (!nullToAbsent || bearing != null) {
      map['bearing'] = Variable<double>(bearing);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  MeasurePointsCompanion toCompanion(bool nullToAbsent) {
    return MeasurePointsCompanion(
      id: Value(id),
      measurementId: Value(measurementId),
      orderIndex: Value(orderIndex),
      segmentIndex: Value(segmentIndex),
      lat: Value(lat),
      lng: Value(lng),
      altitude: altitude == null && nullToAbsent
          ? const Value.absent()
          : Value(altitude),
      accuracy: accuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracy),
      speed: speed == null && nullToAbsent
          ? const Value.absent()
          : Value(speed),
      bearing: bearing == null && nullToAbsent
          ? const Value.absent()
          : Value(bearing),
      timestamp: Value(timestamp),
    );
  }

  factory PointRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PointRow(
      id: serializer.fromJson<String>(json['id']),
      measurementId: serializer.fromJson<String>(json['measurementId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      segmentIndex: serializer.fromJson<int>(json['segmentIndex']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
      altitude: serializer.fromJson<double?>(json['altitude']),
      accuracy: serializer.fromJson<double?>(json['accuracy']),
      speed: serializer.fromJson<double?>(json['speed']),
      bearing: serializer.fromJson<double?>(json['bearing']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'measurementId': serializer.toJson<String>(measurementId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'segmentIndex': serializer.toJson<int>(segmentIndex),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
      'altitude': serializer.toJson<double?>(altitude),
      'accuracy': serializer.toJson<double?>(accuracy),
      'speed': serializer.toJson<double?>(speed),
      'bearing': serializer.toJson<double?>(bearing),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  PointRow copyWith({
    String? id,
    String? measurementId,
    int? orderIndex,
    int? segmentIndex,
    double? lat,
    double? lng,
    Value<double?> altitude = const Value.absent(),
    Value<double?> accuracy = const Value.absent(),
    Value<double?> speed = const Value.absent(),
    Value<double?> bearing = const Value.absent(),
    DateTime? timestamp,
  }) => PointRow(
    id: id ?? this.id,
    measurementId: measurementId ?? this.measurementId,
    orderIndex: orderIndex ?? this.orderIndex,
    segmentIndex: segmentIndex ?? this.segmentIndex,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    altitude: altitude.present ? altitude.value : this.altitude,
    accuracy: accuracy.present ? accuracy.value : this.accuracy,
    speed: speed.present ? speed.value : this.speed,
    bearing: bearing.present ? bearing.value : this.bearing,
    timestamp: timestamp ?? this.timestamp,
  );
  PointRow copyWithCompanion(MeasurePointsCompanion data) {
    return PointRow(
      id: data.id.present ? data.id.value : this.id,
      measurementId: data.measurementId.present
          ? data.measurementId.value
          : this.measurementId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      segmentIndex: data.segmentIndex.present
          ? data.segmentIndex.value
          : this.segmentIndex,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      altitude: data.altitude.present ? data.altitude.value : this.altitude,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      speed: data.speed.present ? data.speed.value : this.speed,
      bearing: data.bearing.present ? data.bearing.value : this.bearing,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PointRow(')
          ..write('id: $id, ')
          ..write('measurementId: $measurementId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('segmentIndex: $segmentIndex, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('altitude: $altitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('speed: $speed, ')
          ..write('bearing: $bearing, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    measurementId,
    orderIndex,
    segmentIndex,
    lat,
    lng,
    altitude,
    accuracy,
    speed,
    bearing,
    timestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PointRow &&
          other.id == this.id &&
          other.measurementId == this.measurementId &&
          other.orderIndex == this.orderIndex &&
          other.segmentIndex == this.segmentIndex &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.altitude == this.altitude &&
          other.accuracy == this.accuracy &&
          other.speed == this.speed &&
          other.bearing == this.bearing &&
          other.timestamp == this.timestamp);
}

class MeasurePointsCompanion extends UpdateCompanion<PointRow> {
  final Value<String> id;
  final Value<String> measurementId;
  final Value<int> orderIndex;
  final Value<int> segmentIndex;
  final Value<double> lat;
  final Value<double> lng;
  final Value<double?> altitude;
  final Value<double?> accuracy;
  final Value<double?> speed;
  final Value<double?> bearing;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const MeasurePointsCompanion({
    this.id = const Value.absent(),
    this.measurementId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.segmentIndex = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.altitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.speed = const Value.absent(),
    this.bearing = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeasurePointsCompanion.insert({
    required String id,
    required String measurementId,
    required int orderIndex,
    this.segmentIndex = const Value.absent(),
    required double lat,
    required double lng,
    this.altitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.speed = const Value.absent(),
    this.bearing = const Value.absent(),
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       measurementId = Value(measurementId),
       orderIndex = Value(orderIndex),
       lat = Value(lat),
       lng = Value(lng),
       timestamp = Value(timestamp);
  static Insertable<PointRow> custom({
    Expression<String>? id,
    Expression<String>? measurementId,
    Expression<int>? orderIndex,
    Expression<int>? segmentIndex,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<double>? altitude,
    Expression<double>? accuracy,
    Expression<double>? speed,
    Expression<double>? bearing,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (measurementId != null) 'measurement_id': measurementId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (segmentIndex != null) 'segment_index': segmentIndex,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (altitude != null) 'altitude': altitude,
      if (accuracy != null) 'accuracy': accuracy,
      if (speed != null) 'speed': speed,
      if (bearing != null) 'bearing': bearing,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeasurePointsCompanion copyWith({
    Value<String>? id,
    Value<String>? measurementId,
    Value<int>? orderIndex,
    Value<int>? segmentIndex,
    Value<double>? lat,
    Value<double>? lng,
    Value<double?>? altitude,
    Value<double?>? accuracy,
    Value<double?>? speed,
    Value<double?>? bearing,
    Value<DateTime>? timestamp,
    Value<int>? rowid,
  }) {
    return MeasurePointsCompanion(
      id: id ?? this.id,
      measurementId: measurementId ?? this.measurementId,
      orderIndex: orderIndex ?? this.orderIndex,
      segmentIndex: segmentIndex ?? this.segmentIndex,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      altitude: altitude ?? this.altitude,
      accuracy: accuracy ?? this.accuracy,
      speed: speed ?? this.speed,
      bearing: bearing ?? this.bearing,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (measurementId.present) {
      map['measurement_id'] = Variable<String>(measurementId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (segmentIndex.present) {
      map['segment_index'] = Variable<int>(segmentIndex.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (bearing.present) {
      map['bearing'] = Variable<double>(bearing.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurePointsCompanion(')
          ..write('id: $id, ')
          ..write('measurementId: $measurementId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('segmentIndex: $segmentIndex, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('altitude: $altitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('speed: $speed, ')
          ..write('bearing: $bearing, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhotosTable extends Photos with TableInfo<$PhotosTable, PhotoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measurementIdMeta = const VerificationMeta(
    'measurementId',
  );
  @override
  late final GeneratedColumn<String> measurementId = GeneratedColumn<String>(
    'measurement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES measurements (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pointIdMeta = const VerificationMeta(
    'pointId',
  );
  @override
  late final GeneratedColumn<String> pointId = GeneratedColumn<String>(
    'point_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbPathMeta = const VerificationMeta(
    'thumbPath',
  );
  @override
  late final GeneratedColumn<String> thumbPath = GeneratedColumn<String>(
    'thumb_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PhotoSource, int> source =
      GeneratedColumn<int>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<PhotoSource>($PhotosTable.$convertersource);
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bytesMeta = const VerificationMeta('bytes');
  @override
  late final GeneratedColumn<int> bytes = GeneratedColumn<int>(
    'bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    measurementId,
    pointId,
    filePath,
    thumbPath,
    takenAt,
    lat,
    lng,
    caption,
    source,
    width,
    height,
    bytes,
    sortIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<PhotoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('measurement_id')) {
      context.handle(
        _measurementIdMeta,
        measurementId.isAcceptableOrUnknown(
          data['measurement_id']!,
          _measurementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementIdMeta);
    }
    if (data.containsKey('point_id')) {
      context.handle(
        _pointIdMeta,
        pointId.isAcceptableOrUnknown(data['point_id']!, _pointIdMeta),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('thumb_path')) {
      context.handle(
        _thumbPathMeta,
        thumbPath.isAcceptableOrUnknown(data['thumb_path']!, _thumbPathMeta),
      );
    } else if (isInserting) {
      context.missing(_thumbPathMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('bytes')) {
      context.handle(
        _bytesMeta,
        bytes.isAcceptableOrUnknown(data['bytes']!, _bytesMeta),
      );
    } else if (isInserting) {
      context.missing(_bytesMeta);
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PhotoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      measurementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_id'],
      )!,
      pointId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}point_id'],
      ),
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      thumbPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumb_path'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      source: $PhotosTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}source'],
        )!,
      ),
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      bytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bytes'],
      )!,
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PhotoSource, int, int> $convertersource =
      const EnumIndexConverter<PhotoSource>(PhotoSource.values);
}

class PhotoRow extends DataClass implements Insertable<PhotoRow> {
  final String id;
  final String measurementId;

  /// No FK: deleting a point sets this to null in code (`detachPoint`).
  final String? pointId;

  /// Relative to the app documents directory.
  final String filePath;
  final String thumbPath;
  final DateTime takenAt;
  final double? lat;
  final double? lng;
  final String? caption;
  final PhotoSource source;
  final int width;
  final int height;
  final int bytes;
  final int sortIndex;
  const PhotoRow({
    required this.id,
    required this.measurementId,
    this.pointId,
    required this.filePath,
    required this.thumbPath,
    required this.takenAt,
    this.lat,
    this.lng,
    this.caption,
    required this.source,
    required this.width,
    required this.height,
    required this.bytes,
    required this.sortIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['measurement_id'] = Variable<String>(measurementId);
    if (!nullToAbsent || pointId != null) {
      map['point_id'] = Variable<String>(pointId);
    }
    map['file_path'] = Variable<String>(filePath);
    map['thumb_path'] = Variable<String>(thumbPath);
    map['taken_at'] = Variable<DateTime>(takenAt);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    {
      map['source'] = Variable<int>(
        $PhotosTable.$convertersource.toSql(source),
      );
    }
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    map['bytes'] = Variable<int>(bytes);
    map['sort_index'] = Variable<int>(sortIndex);
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: Value(id),
      measurementId: Value(measurementId),
      pointId: pointId == null && nullToAbsent
          ? const Value.absent()
          : Value(pointId),
      filePath: Value(filePath),
      thumbPath: Value(thumbPath),
      takenAt: Value(takenAt),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      source: Value(source),
      width: Value(width),
      height: Value(height),
      bytes: Value(bytes),
      sortIndex: Value(sortIndex),
    );
  }

  factory PhotoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotoRow(
      id: serializer.fromJson<String>(json['id']),
      measurementId: serializer.fromJson<String>(json['measurementId']),
      pointId: serializer.fromJson<String?>(json['pointId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      thumbPath: serializer.fromJson<String>(json['thumbPath']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      caption: serializer.fromJson<String?>(json['caption']),
      source: $PhotosTable.$convertersource.fromJson(
        serializer.fromJson<int>(json['source']),
      ),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
      bytes: serializer.fromJson<int>(json['bytes']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'measurementId': serializer.toJson<String>(measurementId),
      'pointId': serializer.toJson<String?>(pointId),
      'filePath': serializer.toJson<String>(filePath),
      'thumbPath': serializer.toJson<String>(thumbPath),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'caption': serializer.toJson<String?>(caption),
      'source': serializer.toJson<int>(
        $PhotosTable.$convertersource.toJson(source),
      ),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
      'bytes': serializer.toJson<int>(bytes),
      'sortIndex': serializer.toJson<int>(sortIndex),
    };
  }

  PhotoRow copyWith({
    String? id,
    String? measurementId,
    Value<String?> pointId = const Value.absent(),
    String? filePath,
    String? thumbPath,
    DateTime? takenAt,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    Value<String?> caption = const Value.absent(),
    PhotoSource? source,
    int? width,
    int? height,
    int? bytes,
    int? sortIndex,
  }) => PhotoRow(
    id: id ?? this.id,
    measurementId: measurementId ?? this.measurementId,
    pointId: pointId.present ? pointId.value : this.pointId,
    filePath: filePath ?? this.filePath,
    thumbPath: thumbPath ?? this.thumbPath,
    takenAt: takenAt ?? this.takenAt,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    caption: caption.present ? caption.value : this.caption,
    source: source ?? this.source,
    width: width ?? this.width,
    height: height ?? this.height,
    bytes: bytes ?? this.bytes,
    sortIndex: sortIndex ?? this.sortIndex,
  );
  PhotoRow copyWithCompanion(PhotosCompanion data) {
    return PhotoRow(
      id: data.id.present ? data.id.value : this.id,
      measurementId: data.measurementId.present
          ? data.measurementId.value
          : this.measurementId,
      pointId: data.pointId.present ? data.pointId.value : this.pointId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      thumbPath: data.thumbPath.present ? data.thumbPath.value : this.thumbPath,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      caption: data.caption.present ? data.caption.value : this.caption,
      source: data.source.present ? data.source.value : this.source,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      bytes: data.bytes.present ? data.bytes.value : this.bytes,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotoRow(')
          ..write('id: $id, ')
          ..write('measurementId: $measurementId, ')
          ..write('pointId: $pointId, ')
          ..write('filePath: $filePath, ')
          ..write('thumbPath: $thumbPath, ')
          ..write('takenAt: $takenAt, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('caption: $caption, ')
          ..write('source: $source, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('bytes: $bytes, ')
          ..write('sortIndex: $sortIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    measurementId,
    pointId,
    filePath,
    thumbPath,
    takenAt,
    lat,
    lng,
    caption,
    source,
    width,
    height,
    bytes,
    sortIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotoRow &&
          other.id == this.id &&
          other.measurementId == this.measurementId &&
          other.pointId == this.pointId &&
          other.filePath == this.filePath &&
          other.thumbPath == this.thumbPath &&
          other.takenAt == this.takenAt &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.caption == this.caption &&
          other.source == this.source &&
          other.width == this.width &&
          other.height == this.height &&
          other.bytes == this.bytes &&
          other.sortIndex == this.sortIndex);
}

class PhotosCompanion extends UpdateCompanion<PhotoRow> {
  final Value<String> id;
  final Value<String> measurementId;
  final Value<String?> pointId;
  final Value<String> filePath;
  final Value<String> thumbPath;
  final Value<DateTime> takenAt;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<String?> caption;
  final Value<PhotoSource> source;
  final Value<int> width;
  final Value<int> height;
  final Value<int> bytes;
  final Value<int> sortIndex;
  final Value<int> rowid;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.measurementId = const Value.absent(),
    this.pointId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.thumbPath = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.caption = const Value.absent(),
    this.source = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.bytes = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotosCompanion.insert({
    required String id,
    required String measurementId,
    this.pointId = const Value.absent(),
    required String filePath,
    required String thumbPath,
    required DateTime takenAt,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.caption = const Value.absent(),
    required PhotoSource source,
    required int width,
    required int height,
    required int bytes,
    required int sortIndex,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       measurementId = Value(measurementId),
       filePath = Value(filePath),
       thumbPath = Value(thumbPath),
       takenAt = Value(takenAt),
       source = Value(source),
       width = Value(width),
       height = Value(height),
       bytes = Value(bytes),
       sortIndex = Value(sortIndex);
  static Insertable<PhotoRow> custom({
    Expression<String>? id,
    Expression<String>? measurementId,
    Expression<String>? pointId,
    Expression<String>? filePath,
    Expression<String>? thumbPath,
    Expression<DateTime>? takenAt,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? caption,
    Expression<int>? source,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? bytes,
    Expression<int>? sortIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (measurementId != null) 'measurement_id': measurementId,
      if (pointId != null) 'point_id': pointId,
      if (filePath != null) 'file_path': filePath,
      if (thumbPath != null) 'thumb_path': thumbPath,
      if (takenAt != null) 'taken_at': takenAt,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (caption != null) 'caption': caption,
      if (source != null) 'source': source,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (bytes != null) 'bytes': bytes,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? measurementId,
    Value<String?>? pointId,
    Value<String>? filePath,
    Value<String>? thumbPath,
    Value<DateTime>? takenAt,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<String?>? caption,
    Value<PhotoSource>? source,
    Value<int>? width,
    Value<int>? height,
    Value<int>? bytes,
    Value<int>? sortIndex,
    Value<int>? rowid,
  }) {
    return PhotosCompanion(
      id: id ?? this.id,
      measurementId: measurementId ?? this.measurementId,
      pointId: pointId ?? this.pointId,
      filePath: filePath ?? this.filePath,
      thumbPath: thumbPath ?? this.thumbPath,
      takenAt: takenAt ?? this.takenAt,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      caption: caption ?? this.caption,
      source: source ?? this.source,
      width: width ?? this.width,
      height: height ?? this.height,
      bytes: bytes ?? this.bytes,
      sortIndex: sortIndex ?? this.sortIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (measurementId.present) {
      map['measurement_id'] = Variable<String>(measurementId.value);
    }
    if (pointId.present) {
      map['point_id'] = Variable<String>(pointId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (thumbPath.present) {
      map['thumb_path'] = Variable<String>(thumbPath.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (source.present) {
      map['source'] = Variable<int>(
        $PhotosTable.$convertersource.toSql(source.value),
      );
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (bytes.present) {
      map['bytes'] = Variable<int>(bytes.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('measurementId: $measurementId, ')
          ..write('pointId: $pointId, ')
          ..write('filePath: $filePath, ')
          ..write('thumbPath: $thumbPath, ')
          ..write('takenAt: $takenAt, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('caption: $caption, ')
          ..write('source: $source, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('bytes: $bytes, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MeasurementsTable measurements = $MeasurementsTable(this);
  late final $MeasurePointsTable measurePoints = $MeasurePointsTable(this);
  late final $PhotosTable photos = $PhotosTable(this);
  late final Index idxMeasurementsStatusUpdated = Index(
    'idx_measurements_status_updated',
    'CREATE INDEX idx_measurements_status_updated ON measurements (status, updated_at DESC)',
  );
  late final Index idxMeasurementsTypeStatus = Index(
    'idx_measurements_type_status',
    'CREATE INDEX idx_measurements_type_status ON measurements (type, status)',
  );
  late final Index idxMeasurementsNameLower = Index(
    'idx_measurements_name_lower',
    'CREATE INDEX idx_measurements_name_lower ON measurements (name_lower)',
  );
  late final Index idxPointsMeasurementOrder = Index(
    'idx_points_measurement_order',
    'CREATE INDEX idx_points_measurement_order ON measure_points (measurement_id, order_index)',
  );
  late final Index idxPhotosMeasurementSort = Index(
    'idx_photos_measurement_sort',
    'CREATE INDEX idx_photos_measurement_sort ON photos (measurement_id, sort_index)',
  );
  late final MeasurementDao measurementDao = MeasurementDao(
    this as AppDatabase,
  );
  late final PointDao pointDao = PointDao(this as AppDatabase);
  late final PhotoDao photoDao = PhotoDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    measurements,
    measurePoints,
    photos,
    idxMeasurementsStatusUpdated,
    idxMeasurementsTypeStatus,
    idxMeasurementsNameLower,
    idxPointsMeasurementOrder,
    idxPhotosMeasurementSort,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'measurements',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('measure_points', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'measurements',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('photos', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$MeasurementsTableCreateCompanionBuilder =
    MeasurementsCompanion Function({
      required String id,
      Value<String?> name,
      Value<String?> nameLower,
      required MeasurementType type,
      required MeasurementStatus status,
      Value<String?> notes,
      Value<double?> areaM2,
      Value<double?> perimeterM,
      Value<double?> distanceM,
      Value<int?> durationSec,
      Value<int> pointCount,
      Value<int> segmentCount,
      Value<bool> isClosed,
      Value<bool> selfIntersects,
      required MapStyle mapStyle,
      Value<AreaUnit?> displayAreaUnit,
      Value<DistanceUnit?> displayDistanceUnit,
      Value<double?> unitPrice,
      Value<String?> unitPriceCurrency,
      Value<AreaUnit?> unitPriceArea,
      Value<String?> thumbnailPath,
      Value<double?> minLat,
      Value<double?> minLng,
      Value<double?> maxLat,
      Value<double?> maxLng,
      Value<WalkRunState?> walkState,
      Value<DateTime?> walkStartedAt,
      Value<int?> walkElapsedSec,
      Value<DateTime?> walkLastResumeAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> savedAt,
      Value<int> rowid,
    });
typedef $$MeasurementsTableUpdateCompanionBuilder =
    MeasurementsCompanion Function({
      Value<String> id,
      Value<String?> name,
      Value<String?> nameLower,
      Value<MeasurementType> type,
      Value<MeasurementStatus> status,
      Value<String?> notes,
      Value<double?> areaM2,
      Value<double?> perimeterM,
      Value<double?> distanceM,
      Value<int?> durationSec,
      Value<int> pointCount,
      Value<int> segmentCount,
      Value<bool> isClosed,
      Value<bool> selfIntersects,
      Value<MapStyle> mapStyle,
      Value<AreaUnit?> displayAreaUnit,
      Value<DistanceUnit?> displayDistanceUnit,
      Value<double?> unitPrice,
      Value<String?> unitPriceCurrency,
      Value<AreaUnit?> unitPriceArea,
      Value<String?> thumbnailPath,
      Value<double?> minLat,
      Value<double?> minLng,
      Value<double?> maxLat,
      Value<double?> maxLng,
      Value<WalkRunState?> walkState,
      Value<DateTime?> walkStartedAt,
      Value<int?> walkElapsedSec,
      Value<DateTime?> walkLastResumeAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> savedAt,
      Value<int> rowid,
    });

final class $$MeasurementsTableReferences
    extends BaseReferences<_$AppDatabase, $MeasurementsTable, MeasurementRow> {
  $$MeasurementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MeasurePointsTable, List<PointRow>>
  _measurePointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.measurePoints,
    aliasName: $_aliasNameGenerator(
      db.measurements.id,
      db.measurePoints.measurementId,
    ),
  );

  $$MeasurePointsTableProcessedTableManager get measurePointsRefs {
    final manager = $$MeasurePointsTableTableManager(
      $_db,
      $_db.measurePoints,
    ).filter((f) => f.measurementId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_measurePointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PhotosTable, List<PhotoRow>> _photosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.photos,
    aliasName: $_aliasNameGenerator(
      db.measurements.id,
      db.photos.measurementId,
    ),
  );

  $$PhotosTableProcessedTableManager get photosRefs {
    final manager = $$PhotosTableTableManager(
      $_db,
      $_db.photos,
    ).filter((f) => f.measurementId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_photosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasurementsTable> {
  $$MeasurementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameLower => $composableBuilder(
    column: $table.nameLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MeasurementType, MeasurementType, int>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<MeasurementStatus, MeasurementStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaM2 => $composableBuilder(
    column: $table.areaM2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get perimeterM => $composableBuilder(
    column: $table.perimeterM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get segmentCount => $composableBuilder(
    column: $table.segmentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get selfIntersects => $composableBuilder(
    column: $table.selfIntersects,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MapStyle, MapStyle, int> get mapStyle =>
      $composableBuilder(
        column: $table.mapStyle,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<AreaUnit?, AreaUnit, int>
  get displayAreaUnit => $composableBuilder(
    column: $table.displayAreaUnit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DistanceUnit?, DistanceUnit, int>
  get displayDistanceUnit => $composableBuilder(
    column: $table.displayDistanceUnit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitPriceCurrency => $composableBuilder(
    column: $table.unitPriceCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AreaUnit?, AreaUnit, int> get unitPriceArea =>
      $composableBuilder(
        column: $table.unitPriceArea,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minLat => $composableBuilder(
    column: $table.minLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minLng => $composableBuilder(
    column: $table.minLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxLat => $composableBuilder(
    column: $table.maxLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxLng => $composableBuilder(
    column: $table.maxLng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WalkRunState?, WalkRunState, int>
  get walkState => $composableBuilder(
    column: $table.walkState,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get walkStartedAt => $composableBuilder(
    column: $table.walkStartedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walkElapsedSec => $composableBuilder(
    column: $table.walkElapsedSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get walkLastResumeAt => $composableBuilder(
    column: $table.walkLastResumeAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> measurePointsRefs(
    Expression<bool> Function($$MeasurePointsTableFilterComposer f) f,
  ) {
    final $$MeasurePointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurePoints,
      getReferencedColumn: (t) => t.measurementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurePointsTableFilterComposer(
            $db: $db,
            $table: $db.measurePoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> photosRefs(
    Expression<bool> Function($$PhotosTableFilterComposer f) f,
  ) {
    final $$PhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.measurementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableFilterComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasurementsTable> {
  $$MeasurementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameLower => $composableBuilder(
    column: $table.nameLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaM2 => $composableBuilder(
    column: $table.areaM2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get perimeterM => $composableBuilder(
    column: $table.perimeterM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get segmentCount => $composableBuilder(
    column: $table.segmentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get selfIntersects => $composableBuilder(
    column: $table.selfIntersects,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mapStyle => $composableBuilder(
    column: $table.mapStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayAreaUnit => $composableBuilder(
    column: $table.displayAreaUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayDistanceUnit => $composableBuilder(
    column: $table.displayDistanceUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitPriceCurrency => $composableBuilder(
    column: $table.unitPriceCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceArea => $composableBuilder(
    column: $table.unitPriceArea,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minLat => $composableBuilder(
    column: $table.minLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minLng => $composableBuilder(
    column: $table.minLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxLat => $composableBuilder(
    column: $table.maxLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxLng => $composableBuilder(
    column: $table.maxLng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walkState => $composableBuilder(
    column: $table.walkState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get walkStartedAt => $composableBuilder(
    column: $table.walkStartedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walkElapsedSec => $composableBuilder(
    column: $table.walkElapsedSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get walkLastResumeAt => $composableBuilder(
    column: $table.walkLastResumeAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasurementsTable> {
  $$MeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameLower =>
      $composableBuilder(column: $table.nameLower, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MeasurementType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MeasurementStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get areaM2 =>
      $composableBuilder(column: $table.areaM2, builder: (column) => column);

  GeneratedColumn<double> get perimeterM => $composableBuilder(
    column: $table.perimeterM,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pointCount => $composableBuilder(
    column: $table.pointCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get segmentCount => $composableBuilder(
    column: $table.segmentCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);

  GeneratedColumn<bool> get selfIntersects => $composableBuilder(
    column: $table.selfIntersects,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<MapStyle, int> get mapStyle =>
      $composableBuilder(column: $table.mapStyle, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AreaUnit?, int> get displayAreaUnit =>
      $composableBuilder(
        column: $table.displayAreaUnit,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DistanceUnit?, int>
  get displayDistanceUnit => $composableBuilder(
    column: $table.displayDistanceUnit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<String> get unitPriceCurrency => $composableBuilder(
    column: $table.unitPriceCurrency,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AreaUnit?, int> get unitPriceArea =>
      $composableBuilder(
        column: $table.unitPriceArea,
        builder: (column) => column,
      );

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minLat =>
      $composableBuilder(column: $table.minLat, builder: (column) => column);

  GeneratedColumn<double> get minLng =>
      $composableBuilder(column: $table.minLng, builder: (column) => column);

  GeneratedColumn<double> get maxLat =>
      $composableBuilder(column: $table.maxLat, builder: (column) => column);

  GeneratedColumn<double> get maxLng =>
      $composableBuilder(column: $table.maxLng, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WalkRunState?, int> get walkState =>
      $composableBuilder(column: $table.walkState, builder: (column) => column);

  GeneratedColumn<DateTime> get walkStartedAt => $composableBuilder(
    column: $table.walkStartedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get walkElapsedSec => $composableBuilder(
    column: $table.walkElapsedSec,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get walkLastResumeAt => $composableBuilder(
    column: $table.walkLastResumeAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  Expression<T> measurePointsRefs<T extends Object>(
    Expression<T> Function($$MeasurePointsTableAnnotationComposer a) f,
  ) {
    final $$MeasurePointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.measurePoints,
      getReferencedColumn: (t) => t.measurementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurePointsTableAnnotationComposer(
            $db: $db,
            $table: $db.measurePoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> photosRefs<T extends Object>(
    Expression<T> Function($$PhotosTableAnnotationComposer a) f,
  ) {
    final $$PhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.measurementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MeasurementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasurementsTable,
          MeasurementRow,
          $$MeasurementsTableFilterComposer,
          $$MeasurementsTableOrderingComposer,
          $$MeasurementsTableAnnotationComposer,
          $$MeasurementsTableCreateCompanionBuilder,
          $$MeasurementsTableUpdateCompanionBuilder,
          (MeasurementRow, $$MeasurementsTableReferences),
          MeasurementRow,
          PrefetchHooks Function({bool measurePointsRefs, bool photosRefs})
        > {
  $$MeasurementsTableTableManager(_$AppDatabase db, $MeasurementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeasurementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> nameLower = const Value.absent(),
                Value<MeasurementType> type = const Value.absent(),
                Value<MeasurementStatus> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> areaM2 = const Value.absent(),
                Value<double?> perimeterM = const Value.absent(),
                Value<double?> distanceM = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                Value<int> pointCount = const Value.absent(),
                Value<int> segmentCount = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
                Value<bool> selfIntersects = const Value.absent(),
                Value<MapStyle> mapStyle = const Value.absent(),
                Value<AreaUnit?> displayAreaUnit = const Value.absent(),
                Value<DistanceUnit?> displayDistanceUnit = const Value.absent(),
                Value<double?> unitPrice = const Value.absent(),
                Value<String?> unitPriceCurrency = const Value.absent(),
                Value<AreaUnit?> unitPriceArea = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<double?> minLat = const Value.absent(),
                Value<double?> minLng = const Value.absent(),
                Value<double?> maxLat = const Value.absent(),
                Value<double?> maxLng = const Value.absent(),
                Value<WalkRunState?> walkState = const Value.absent(),
                Value<DateTime?> walkStartedAt = const Value.absent(),
                Value<int?> walkElapsedSec = const Value.absent(),
                Value<DateTime?> walkLastResumeAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeasurementsCompanion(
                id: id,
                name: name,
                nameLower: nameLower,
                type: type,
                status: status,
                notes: notes,
                areaM2: areaM2,
                perimeterM: perimeterM,
                distanceM: distanceM,
                durationSec: durationSec,
                pointCount: pointCount,
                segmentCount: segmentCount,
                isClosed: isClosed,
                selfIntersects: selfIntersects,
                mapStyle: mapStyle,
                displayAreaUnit: displayAreaUnit,
                displayDistanceUnit: displayDistanceUnit,
                unitPrice: unitPrice,
                unitPriceCurrency: unitPriceCurrency,
                unitPriceArea: unitPriceArea,
                thumbnailPath: thumbnailPath,
                minLat: minLat,
                minLng: minLng,
                maxLat: maxLat,
                maxLng: maxLng,
                walkState: walkState,
                walkStartedAt: walkStartedAt,
                walkElapsedSec: walkElapsedSec,
                walkLastResumeAt: walkLastResumeAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                savedAt: savedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> name = const Value.absent(),
                Value<String?> nameLower = const Value.absent(),
                required MeasurementType type,
                required MeasurementStatus status,
                Value<String?> notes = const Value.absent(),
                Value<double?> areaM2 = const Value.absent(),
                Value<double?> perimeterM = const Value.absent(),
                Value<double?> distanceM = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                Value<int> pointCount = const Value.absent(),
                Value<int> segmentCount = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
                Value<bool> selfIntersects = const Value.absent(),
                required MapStyle mapStyle,
                Value<AreaUnit?> displayAreaUnit = const Value.absent(),
                Value<DistanceUnit?> displayDistanceUnit = const Value.absent(),
                Value<double?> unitPrice = const Value.absent(),
                Value<String?> unitPriceCurrency = const Value.absent(),
                Value<AreaUnit?> unitPriceArea = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<double?> minLat = const Value.absent(),
                Value<double?> minLng = const Value.absent(),
                Value<double?> maxLat = const Value.absent(),
                Value<double?> maxLng = const Value.absent(),
                Value<WalkRunState?> walkState = const Value.absent(),
                Value<DateTime?> walkStartedAt = const Value.absent(),
                Value<int?> walkElapsedSec = const Value.absent(),
                Value<DateTime?> walkLastResumeAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeasurementsCompanion.insert(
                id: id,
                name: name,
                nameLower: nameLower,
                type: type,
                status: status,
                notes: notes,
                areaM2: areaM2,
                perimeterM: perimeterM,
                distanceM: distanceM,
                durationSec: durationSec,
                pointCount: pointCount,
                segmentCount: segmentCount,
                isClosed: isClosed,
                selfIntersects: selfIntersects,
                mapStyle: mapStyle,
                displayAreaUnit: displayAreaUnit,
                displayDistanceUnit: displayDistanceUnit,
                unitPrice: unitPrice,
                unitPriceCurrency: unitPriceCurrency,
                unitPriceArea: unitPriceArea,
                thumbnailPath: thumbnailPath,
                minLat: minLat,
                minLng: minLng,
                maxLat: maxLat,
                maxLng: maxLng,
                walkState: walkState,
                walkStartedAt: walkStartedAt,
                walkElapsedSec: walkElapsedSec,
                walkLastResumeAt: walkLastResumeAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                savedAt: savedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MeasurementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({measurePointsRefs = false, photosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (measurePointsRefs) db.measurePoints,
                    if (photosRefs) db.photos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (measurePointsRefs)
                        await $_getPrefetchedData<
                          MeasurementRow,
                          $MeasurementsTable,
                          PointRow
                        >(
                          currentTable: table,
                          referencedTable: $$MeasurementsTableReferences
                              ._measurePointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeasurementsTableReferences(
                                db,
                                table,
                                p0,
                              ).measurePointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.measurementId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (photosRefs)
                        await $_getPrefetchedData<
                          MeasurementRow,
                          $MeasurementsTable,
                          PhotoRow
                        >(
                          currentTable: table,
                          referencedTable: $$MeasurementsTableReferences
                              ._photosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MeasurementsTableReferences(
                                db,
                                table,
                                p0,
                              ).photosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.measurementId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasurementsTable,
      MeasurementRow,
      $$MeasurementsTableFilterComposer,
      $$MeasurementsTableOrderingComposer,
      $$MeasurementsTableAnnotationComposer,
      $$MeasurementsTableCreateCompanionBuilder,
      $$MeasurementsTableUpdateCompanionBuilder,
      (MeasurementRow, $$MeasurementsTableReferences),
      MeasurementRow,
      PrefetchHooks Function({bool measurePointsRefs, bool photosRefs})
    >;
typedef $$MeasurePointsTableCreateCompanionBuilder =
    MeasurePointsCompanion Function({
      required String id,
      required String measurementId,
      required int orderIndex,
      Value<int> segmentIndex,
      required double lat,
      required double lng,
      Value<double?> altitude,
      Value<double?> accuracy,
      Value<double?> speed,
      Value<double?> bearing,
      required DateTime timestamp,
      Value<int> rowid,
    });
typedef $$MeasurePointsTableUpdateCompanionBuilder =
    MeasurePointsCompanion Function({
      Value<String> id,
      Value<String> measurementId,
      Value<int> orderIndex,
      Value<int> segmentIndex,
      Value<double> lat,
      Value<double> lng,
      Value<double?> altitude,
      Value<double?> accuracy,
      Value<double?> speed,
      Value<double?> bearing,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });

final class $$MeasurePointsTableReferences
    extends BaseReferences<_$AppDatabase, $MeasurePointsTable, PointRow> {
  $$MeasurePointsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MeasurementsTable _measurementIdTable(_$AppDatabase db) =>
      db.measurements.createAlias(
        $_aliasNameGenerator(
          db.measurePoints.measurementId,
          db.measurements.id,
        ),
      );

  $$MeasurementsTableProcessedTableManager get measurementId {
    final $_column = $_itemColumn<String>('measurement_id')!;

    final manager = $$MeasurementsTableTableManager(
      $_db,
      $_db.measurements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_measurementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MeasurePointsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasurePointsTable> {
  $$MeasurePointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get segmentIndex => $composableBuilder(
    column: $table.segmentIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bearing => $composableBuilder(
    column: $table.bearing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$MeasurementsTableFilterComposer get measurementId {
    final $$MeasurementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.measurementId,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableFilterComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeasurePointsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasurePointsTable> {
  $$MeasurePointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get segmentIndex => $composableBuilder(
    column: $table.segmentIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bearing => $composableBuilder(
    column: $table.bearing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$MeasurementsTableOrderingComposer get measurementId {
    final $$MeasurementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.measurementId,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableOrderingComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeasurePointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasurePointsTable> {
  $$MeasurePointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get segmentIndex => $composableBuilder(
    column: $table.segmentIndex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<double> get altitude =>
      $composableBuilder(column: $table.altitude, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<double> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<double> get bearing =>
      $composableBuilder(column: $table.bearing, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$MeasurementsTableAnnotationComposer get measurementId {
    final $$MeasurementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.measurementId,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableAnnotationComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeasurePointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasurePointsTable,
          PointRow,
          $$MeasurePointsTableFilterComposer,
          $$MeasurePointsTableOrderingComposer,
          $$MeasurePointsTableAnnotationComposer,
          $$MeasurePointsTableCreateCompanionBuilder,
          $$MeasurePointsTableUpdateCompanionBuilder,
          (PointRow, $$MeasurePointsTableReferences),
          PointRow,
          PrefetchHooks Function({bool measurementId})
        > {
  $$MeasurePointsTableTableManager(_$AppDatabase db, $MeasurePointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasurePointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeasurePointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeasurePointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> measurementId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> segmentIndex = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lng = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
                Value<double?> accuracy = const Value.absent(),
                Value<double?> speed = const Value.absent(),
                Value<double?> bearing = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeasurePointsCompanion(
                id: id,
                measurementId: measurementId,
                orderIndex: orderIndex,
                segmentIndex: segmentIndex,
                lat: lat,
                lng: lng,
                altitude: altitude,
                accuracy: accuracy,
                speed: speed,
                bearing: bearing,
                timestamp: timestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String measurementId,
                required int orderIndex,
                Value<int> segmentIndex = const Value.absent(),
                required double lat,
                required double lng,
                Value<double?> altitude = const Value.absent(),
                Value<double?> accuracy = const Value.absent(),
                Value<double?> speed = const Value.absent(),
                Value<double?> bearing = const Value.absent(),
                required DateTime timestamp,
                Value<int> rowid = const Value.absent(),
              }) => MeasurePointsCompanion.insert(
                id: id,
                measurementId: measurementId,
                orderIndex: orderIndex,
                segmentIndex: segmentIndex,
                lat: lat,
                lng: lng,
                altitude: altitude,
                accuracy: accuracy,
                speed: speed,
                bearing: bearing,
                timestamp: timestamp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MeasurePointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({measurementId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (measurementId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.measurementId,
                                referencedTable: $$MeasurePointsTableReferences
                                    ._measurementIdTable(db),
                                referencedColumn: $$MeasurePointsTableReferences
                                    ._measurementIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MeasurePointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasurePointsTable,
      PointRow,
      $$MeasurePointsTableFilterComposer,
      $$MeasurePointsTableOrderingComposer,
      $$MeasurePointsTableAnnotationComposer,
      $$MeasurePointsTableCreateCompanionBuilder,
      $$MeasurePointsTableUpdateCompanionBuilder,
      (PointRow, $$MeasurePointsTableReferences),
      PointRow,
      PrefetchHooks Function({bool measurementId})
    >;
typedef $$PhotosTableCreateCompanionBuilder =
    PhotosCompanion Function({
      required String id,
      required String measurementId,
      Value<String?> pointId,
      required String filePath,
      required String thumbPath,
      required DateTime takenAt,
      Value<double?> lat,
      Value<double?> lng,
      Value<String?> caption,
      required PhotoSource source,
      required int width,
      required int height,
      required int bytes,
      required int sortIndex,
      Value<int> rowid,
    });
typedef $$PhotosTableUpdateCompanionBuilder =
    PhotosCompanion Function({
      Value<String> id,
      Value<String> measurementId,
      Value<String?> pointId,
      Value<String> filePath,
      Value<String> thumbPath,
      Value<DateTime> takenAt,
      Value<double?> lat,
      Value<double?> lng,
      Value<String?> caption,
      Value<PhotoSource> source,
      Value<int> width,
      Value<int> height,
      Value<int> bytes,
      Value<int> sortIndex,
      Value<int> rowid,
    });

final class $$PhotosTableReferences
    extends BaseReferences<_$AppDatabase, $PhotosTable, PhotoRow> {
  $$PhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MeasurementsTable _measurementIdTable(_$AppDatabase db) =>
      db.measurements.createAlias(
        $_aliasNameGenerator(db.photos.measurementId, db.measurements.id),
      );

  $$MeasurementsTableProcessedTableManager get measurementId {
    final $_column = $_itemColumn<String>('measurement_id')!;

    final manager = $$MeasurementsTableTableManager(
      $_db,
      $_db.measurements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_measurementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PhotosTableFilterComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pointId => $composableBuilder(
    column: $table.pointId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbPath => $composableBuilder(
    column: $table.thumbPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PhotoSource, PhotoSource, int> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$MeasurementsTableFilterComposer get measurementId {
    final $$MeasurementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.measurementId,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableFilterComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pointId => $composableBuilder(
    column: $table.pointId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbPath => $composableBuilder(
    column: $table.thumbPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$MeasurementsTableOrderingComposer get measurementId {
    final $$MeasurementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.measurementId,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableOrderingComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pointId =>
      $composableBuilder(column: $table.pointId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get thumbPath =>
      $composableBuilder(column: $table.thumbPath, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PhotoSource, int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get bytes =>
      $composableBuilder(column: $table.bytes, builder: (column) => column);

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  $$MeasurementsTableAnnotationComposer get measurementId {
    final $$MeasurementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.measurementId,
      referencedTable: $db.measurements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeasurementsTableAnnotationComposer(
            $db: $db,
            $table: $db.measurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhotosTable,
          PhotoRow,
          $$PhotosTableFilterComposer,
          $$PhotosTableOrderingComposer,
          $$PhotosTableAnnotationComposer,
          $$PhotosTableCreateCompanionBuilder,
          $$PhotosTableUpdateCompanionBuilder,
          (PhotoRow, $$PhotosTableReferences),
          PhotoRow,
          PrefetchHooks Function({bool measurementId})
        > {
  $$PhotosTableTableManager(_$AppDatabase db, $PhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> measurementId = const Value.absent(),
                Value<String?> pointId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> thumbPath = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<PhotoSource> source = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> bytes = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PhotosCompanion(
                id: id,
                measurementId: measurementId,
                pointId: pointId,
                filePath: filePath,
                thumbPath: thumbPath,
                takenAt: takenAt,
                lat: lat,
                lng: lng,
                caption: caption,
                source: source,
                width: width,
                height: height,
                bytes: bytes,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String measurementId,
                Value<String?> pointId = const Value.absent(),
                required String filePath,
                required String thumbPath,
                required DateTime takenAt,
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                required PhotoSource source,
                required int width,
                required int height,
                required int bytes,
                required int sortIndex,
                Value<int> rowid = const Value.absent(),
              }) => PhotosCompanion.insert(
                id: id,
                measurementId: measurementId,
                pointId: pointId,
                filePath: filePath,
                thumbPath: thumbPath,
                takenAt: takenAt,
                lat: lat,
                lng: lng,
                caption: caption,
                source: source,
                width: width,
                height: height,
                bytes: bytes,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PhotosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({measurementId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (measurementId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.measurementId,
                                referencedTable: $$PhotosTableReferences
                                    ._measurementIdTable(db),
                                referencedColumn: $$PhotosTableReferences
                                    ._measurementIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhotosTable,
      PhotoRow,
      $$PhotosTableFilterComposer,
      $$PhotosTableOrderingComposer,
      $$PhotosTableAnnotationComposer,
      $$PhotosTableCreateCompanionBuilder,
      $$PhotosTableUpdateCompanionBuilder,
      (PhotoRow, $$PhotosTableReferences),
      PhotoRow,
      PrefetchHooks Function({bool measurementId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MeasurementsTableTableManager get measurements =>
      $$MeasurementsTableTableManager(_db, _db.measurements);
  $$MeasurePointsTableTableManager get measurePoints =>
      $$MeasurePointsTableTableManager(_db, _db.measurePoints);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db, _db.photos);
}
