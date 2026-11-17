// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'LandMeasure';

  @override
  String get navHome => '首页';

  @override
  String get navSaved => '已保存';

  @override
  String get navSettings => '设置';

  @override
  String get measurementTypeArea => '面积';

  @override
  String get measurementTypeDistance => '距离';

  @override
  String get measurementTypeWalk => '步行';

  @override
  String get screenMeasureArea => '测量面积';

  @override
  String get screenMeasureDistance => '测量距离';

  @override
  String get screenWalk => '步行测量';

  @override
  String get screenSave => '保存测量';

  @override
  String get screenDetail => '测量详情';

  @override
  String get screenFullMap => '地图';

  @override
  String get screenEdit => '编辑测量';

  @override
  String get screenSaved => '已保存的测量';

  @override
  String get screenSettings => '设置';

  @override
  String get screenUnits => '单位';

  @override
  String get screenMapStyle => '地图样式';

  @override
  String get screenLanguage => '语言';

  @override
  String get screenPaywall => '高级版';

  @override
  String get ctaStartMeasuring => '开始测量';

  @override
  String get ctaStartArea => '开始测量面积';

  @override
  String get ctaStartDistance => '开始测量距离';

  @override
  String get ctaStartWalk => '开始步行测量';

  @override
  String get ctaSaveMeasurement => '保存测量';

  @override
  String get ctaSaveRoute => '保存路线';

  @override
  String get ctaPause => '暂停';

  @override
  String get ctaResume => '继续';

  @override
  String get ctaFinish => '完成';

  @override
  String get actionCancel => '取消';

  @override
  String get actionSave => '保存';

  @override
  String get actionDiscard => '放弃';

  @override
  String get actionDelete => '删除';

  @override
  String get actionReset => '重置';

  @override
  String get actionOpenSettings => '打开设置';

  @override
  String get actionKeepRecording => '继续记录';

  @override
  String get actionKeepEditing => '继续编辑';

  @override
  String get dialogResetTitle => '重置测量？';

  @override
  String get dialogResetMessage => '这将删除所有点。';

  @override
  String get dialogDiscardDraftTitle => '放弃此草稿？';

  @override
  String get dialogDiscardDraftMessage => '所有点和未保存的更改都将被删除。';

  @override
  String get dialogDeleteTitle => '删除测量？';

  @override
  String get dialogDeleteMessage => '此测量及其照片和备注将被永久删除。';

  @override
  String get dialogFinishWalkTitle => '结束记录？';

  @override
  String get dialogFinishWalkMessage => 'GPS 跟踪将停止。';

  @override
  String get dialogRenameTitle => '重命名测量';

  @override
  String get dialogDiscardChangesTitle => '放弃更改？';

  @override
  String get fabLayers => '地图图层';

  @override
  String get fabMyLocation => '我的位置';

  @override
  String get fabSearch => '搜索地点';

  @override
  String get fabCamera => '拍照';

  @override
  String get gpsReady => 'GPS 就绪';

  @override
  String get gpsSearching => '正在搜索 GPS…';

  @override
  String get gpsLowAccuracy => 'GPS 精度低';

  @override
  String get locationOff => '定位已关闭';

  @override
  String get locationOffMessage => '请开启定位以记录您的步行路线。';

  @override
  String get mapOffline => '地图连接不可用——您的点已安全保存';

  @override
  String get emptyNoMeasurementsTitle => '还没有测量';

  @override
  String get emptyNoMeasurementsMessage => '测量您的第一块土地，它会显示在这里。';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get measureHintCrosshair => '移动地图放置十字准星，然后点按“添加点”。';

  @override
  String get measureHintTap => '点按地图，沿边界添加点。';

  @override
  String get toolbarUndo => '撤销';

  @override
  String get toolbarAddPoint => '添加点';

  @override
  String get toolbarClose => '闭合图形';

  @override
  String get toolbarReset => '重置';

  @override
  String get toolbarAddAtMyLocation => '在我的位置添加点';

  @override
  String get resultArea => '面积';

  @override
  String get resultPerimeter => '周长';

  @override
  String get resultAreaNeedsPoints => '至少添加 3 个点才能计算面积';

  @override
  String resultPointCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个点',
    );
    return '$_temp0';
  }

  @override
  String get edgesCross => '边线交叉——面积可能不正确';

  @override
  String get menuMore => '更多选项';

  @override
  String get menuInputCrosshair => '用十字准星添加';

  @override
  String get menuInputTap => '点按地图添加';

  @override
  String get menuShowEdgeLabels => '显示边长';

  @override
  String pointLabel(int number) {
    return '点 $number';
  }

  @override
  String get pointDelete => '删除点';

  @override
  String get pointDeselect => '完成';

  @override
  String gpsLowAccuracyAdded(int meters) {
    return 'GPS 精度较低（±$meters m），但仍已添加该点。';
  }

  @override
  String get locationUnavailable => '无法获取您的位置。请到户外再试。';

  @override
  String get locationPermissionDenied => '定位权限已关闭。您仍可通过移动地图进行测量。';

  @override
  String get locationServiceOff => '此设备的定位已关闭。';

  @override
  String get mapLayersTitle => '地图类型';

  @override
  String get mapStyleStandard => '标准';

  @override
  String get mapStyleSatellite => '卫星';

  @override
  String get mapStyleTerrain => '地形';

  @override
  String get mapStyleHybrid => '混合';

  @override
  String get draftSaveFailed => '无法保存您的点。下次更改时会再次保存。';

  @override
  String get menuHelp => '帮助';

  @override
  String get actionGotIt => '知道了';

  @override
  String get helpTitleArea => '如何测量面积';

  @override
  String get helpTitleDistance => '如何测量距离';

  @override
  String get helpTitleWalk => '如何步行测量';

  @override
  String get helpAreaSummary => '沿您土地的边界添加点。';

  @override
  String get helpDistanceSummary => '沿您要测量的路线添加点。';

  @override
  String get helpWalkSummary => '沿边界步行，LandMeasure 会记录您的 GPS 路径。';

  @override
  String get helpPhotoTip => '用照片记录界桩、边界或场地状况。';

  @override
  String get helpAccuracyNote => 'GPS 和地图测量的精度可能因设备、地图影像和环境而异。';

  @override
  String get helpAreaStep1 => '移动地图，让十字准星对准一个角，然后点按**添加点**。';

  @override
  String get helpAreaStep2 => '沿边界至少添加 3 个点。拖动点可调整位置。';

  @override
  String get helpAreaStep3 => '点按**闭合图形**完成，然后点按**保存测量**。';

  @override
  String get helpDistanceStep1 => '将十字准星放在路线起点，点按**添加点**。';

  @override
  String get helpDistanceStep2 => '沿路线继续添加点。每段长度会显示在地图上。';

  @override
  String get helpDistanceStep3 => '完成后点按**保存路线**。';

  @override
  String get helpWalkStep1 => '等待**GPS 就绪**，然后点按**开始步行**。';

  @override
  String get helpWalkStep2 => '沿边界步行。需要停下时使用**暂停**。';

  @override
  String get helpWalkStep3 => '回到起点并点按**完成**来计算面积。';

  @override
  String get helpTipGpsPoint => '提示：点按 📍 可在当前 GPS 位置添加点。';

  @override
  String get helpTipWalk => '提示：待在开阔区域可获得更好的 GPS 精度。';

  @override
  String get resultDistance => '距离';

  @override
  String get resultDistanceNeedsPoints => '至少添加 2 个点才能测量距离';

  @override
  String resultSegmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 段',
    );
    return '$_temp0';
  }

  @override
  String get segmentsTitle => '分段';

  @override
  String draftSavedSnack(int count, String type) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '草稿已保存 · $type · $count 个点',
    );
    return '$_temp0';
  }

  @override
  String get searchHint => '地址、坐标或 Google 地图链接';

  @override
  String get searchAction => '搜索';

  @override
  String get searchRecent => '最近搜索';

  @override
  String get searchNoResults => '未找到地点。请尝试坐标或 Google 地图链接。';

  @override
  String get searchNeedsInternet => '搜索地址需要网络连接。';

  @override
  String get searchUnavailable => '此设备不支持地址搜索。请尝试坐标或 Google 地图链接。';

  @override
  String get searchClear => '清除';

  @override
  String get searchFailed => '暂时无法搜索此地址。请尝试坐标或 Google 地图链接。';

  @override
  String get ctaStartWalking => '开始步行';

  @override
  String get walkReadyHelper => '沿边界步行以记录您的路径。';

  @override
  String get keepScreenOn => '保持屏幕常亮';

  @override
  String get walkRecording => '正在记录 GPS…';

  @override
  String get walkPaused => '已暂停';

  @override
  String get walkPausedMessage => '点按“继续”，从当前位置接着记录。';

  @override
  String gpsAccuracyShort(int meters) {
    return '±$meters m';
  }

  @override
  String gpsLowAccuracyMessage(int meters) {
    return '精度 ±$meters m——精度改善前不会记录点。请移到开阔区域。';
  }

  @override
  String get locationDeniedTitle => '定位权限已关闭';

  @override
  String get locationDeniedMessage => '允许定位以记录您的步行路线。';

  @override
  String get actionAllow => '允许';

  @override
  String get actionNotNow => '以后再说';

  @override
  String get mockLocationDetected => '检测到模拟位置——这些位置不会被记录。';

  @override
  String get walkCloseToStart => '接近起点——完成后可计算面积';

  @override
  String get walkNotClosed => '路线未闭合——仅显示距离';

  @override
  String get walkKeepWalking => '走回起点以闭合路线。';

  @override
  String get resultDuration => '时长';

  @override
  String get walkNotificationTitle => 'LandMeasure 正在记录您的测量';

  @override
  String get walkNotificationText => '点按返回步行测量。';

  @override
  String get walkNotificationChannel => '步行记录';

  @override
  String get walkRecordingBack => '正在记录。离开前请暂停或完成。';

  @override
  String get walkPauseAndLeave => '暂停并离开';

  @override
  String get walkStartFailed => '无法开始记录。请重试。';

  @override
  String get batteryHintTitle => '允许 LandMeasure 在后台运行';

  @override
  String get batteryHintMessage =>
      '部分手机会在熄屏后停止应用。要持续记录步行，请打开 设置 → 电池，并将 LandMeasure 设为“无限制”。';

  @override
  String get fabRecenter => '重新居中';

  @override
  String get homeHeroSubtitle => '选择一种方式测量您的土地。';

  @override
  String get homeContinueTitle => '继续测量';

  @override
  String get homeSeeAllDrafts => '查看全部草稿';

  @override
  String get homeRecentTitle => '最近的测量';

  @override
  String get homeRecentEmptyTitle => '没有最近的测量';

  @override
  String get homeRecentEmptyMessage => '已保存的测量会显示在这里。';

  @override
  String get actionSeeAll => '查看全部';

  @override
  String get untitledArea => '未命名面积';

  @override
  String get untitledDistance => '未命名距离';

  @override
  String get untitledWalk => '未命名步行';

  @override
  String get draftLabel => '草稿';

  @override
  String get walkFinishedNotSaved => '已完成 · 未保存';

  @override
  String lastEdited(String time) {
    return '编辑于 $time';
  }

  @override
  String get timeJustNow => '刚刚';

  @override
  String timeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分钟前',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 小时前',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天前',
      one: '昨天',
    );
    return '$_temp0';
  }

  @override
  String get savedSearchHint => '按名称搜索';

  @override
  String get savedSearchOpen => '搜索';

  @override
  String get savedSearchClose => '关闭搜索';

  @override
  String get filterAll => '全部';

  @override
  String filterWithCount(String label, int count) {
    return '$label（$count）';
  }

  @override
  String savedDraftsTitle(int count) {
    return '草稿（$count）';
  }

  @override
  String get savedNoResults => '未找到测量。';

  @override
  String get menuRename => '重命名';

  @override
  String get menuExport => '导出';

  @override
  String get measurementDeleted => '测量已删除';

  @override
  String get draftDiscarded => '草稿已放弃';

  @override
  String get exportTitle => '导出';

  @override
  String get renameHint => '测量名称';

  @override
  String get saveNameLabel => '名称';

  @override
  String get saveNameRequired => '名称为必填项';

  @override
  String get saveNotesLabel => '备注';

  @override
  String get saveNotesHint => '边界、所有人、地标……（可选）';

  @override
  String get saveTypeLabel => '类型';

  @override
  String get saveFailed => '无法保存。请重试。';

  @override
  String get saveLimitReached => '您已达到免费版保存测量的上限。此测量会保留在草稿中。';

  @override
  String get saveNotFound => '此测量已不存在。';

  @override
  String photosTitle(int count) {
    return '现场照片（$count）';
  }

  @override
  String get actionClose => '关闭';

  @override
  String get resultPoints => '点数';

  @override
  String get resultSegments => '分段';

  @override
  String get resultAvgPace => '平均配速';

  @override
  String paceValue(String time, String unit) {
    return '$time /$unit';
  }

  @override
  String get notesTitle => '备注';

  @override
  String get notesEmpty => '无备注';

  @override
  String get actionEdit => '编辑';

  @override
  String get actionExport => '导出';

  @override
  String get detailOpenMap => '打开地图';

  @override
  String savedOn(String date) {
    return '保存于 $date';
  }

  @override
  String get addPhotoTitle => '添加照片';

  @override
  String get addPhotoCamera => '拍照';

  @override
  String get addPhotoGallery => '从相册选择';

  @override
  String addPhotoForPoint(int number) {
    return '用于点 $number';
  }

  @override
  String get addPhotoTile => '添加照片';

  @override
  String get photoAddFailed => '无法添加照片。请重试。';

  @override
  String get photoRemoved => '照片已移除';

  @override
  String get actionUndo => '撤销';

  @override
  String get photoLimitReached => '您已达到此测量的免费照片上限。';

  @override
  String get photoDeleteTitle => '删除照片？';

  @override
  String get photoDeleteMessage => '此照片将从测量中移除。';

  @override
  String get photoAttachTitle => '将此照片附加到测量？';

  @override
  String get photoAttachMessage => '设置中的“将照片保存到测量”已关闭。';

  @override
  String get actionAttach => '附加';

  @override
  String get photoWaitForStart => '开始步行后即可添加照片。';

  @override
  String photoCounter(int index, int total) {
    return '$index / $total';
  }

  @override
  String get photoShare => '分享';

  @override
  String photoOpen(int number) {
    return '打开照片 $number';
  }

  @override
  String get photoRemove => '移除照片';

  @override
  String get pointPhoto => '照片';

  @override
  String get cameraPermissionTitle => '允许访问相机';

  @override
  String get cameraPermissionMessage => '拍摄界桩、边界和场地状况，并与测量一起保存。';

  @override
  String get cameraPermissionDenied => '相机权限已关闭。您可以在设置中开启。';

  @override
  String get actionContinue => '继续';

  @override
  String get notesEditTitle => '编辑备注';

  @override
  String get notesAdd => '添加备注';

  @override
  String get editTabResult => '结果';

  @override
  String get editTabDetails => '详情';

  @override
  String get ctaSaveChanges => '保存更改';

  @override
  String get dialogDiscardChangesMessage => '您对此测量的更改将丢失。';

  @override
  String get changesSaved => '更改已保存';

  @override
  String get menuReopenShape => '重新打开图形';

  @override
  String get exportKml => 'KML — Google Earth';

  @override
  String get exportKmlSubtitle => '图形和带照片的点，适用于 Google Earth 和 GIS 应用';

  @override
  String get exportCsv => 'CSV — Excel';

  @override
  String get exportCsvSubtitle => '每个点及其坐标，适用于电子表格';

  @override
  String get exportPreparing => '正在准备文件…';

  @override
  String get exportFailed => '无法导出。请重试。';

  @override
  String get exportLimitReached => '今天的免费 KML 导出已用完。CSV 导出仍然免费。';

  @override
  String get landValueTitle => '土地价值';

  @override
  String get landValueAdd => '添加土地价值';

  @override
  String get landValueUnitPrice => '单价';

  @override
  String get landValueUnit => '按';

  @override
  String landValueEstimated(String value) {
    return '估计价值 ≈ $value';
  }

  @override
  String landValueRate(String price, String unit) {
    return '$price / $unit';
  }

  @override
  String get landValueNeedsArea => '土地价值需要面积（请闭合图形）。';

  @override
  String get landValueRemove => '移除';

  @override
  String get landValueInvalid => '请输入大于 0 的价格';

  @override
  String get resultValue => '价值';

  @override
  String get settingsSubtitle => '单位、地图和应用偏好';

  @override
  String get settingsSectionPreferences => '测量偏好';

  @override
  String get settingsSectionMeasureMap => '测量与地图';

  @override
  String get settingsSectionSupport => '支持与法律';

  @override
  String get settingsDefaultMode => '默认测量类型';

  @override
  String get settingsDefaultModeHint => '打开应用时在首页默认选中。';

  @override
  String get settingsGpsAccuracy => '显示 GPS 精度';

  @override
  String get settingsGpsAccuracySubtitle => '步行时显示 ±m 和精度圈';

  @override
  String get settingsAutoCenter => '地图自动居中';

  @override
  String get settingsAutoCenterSubtitle => '在您的位置打开地图，步行时跟随您';

  @override
  String get settingsSavePhotos => '将照片保存到测量';

  @override
  String get settingsSavePhotosSubtitle => '新照片直接附加，不再询问';

  @override
  String get settingsKeepAwake => '保持屏幕常亮';

  @override
  String get settingsKeepAwakeSubtitle => '测量时屏幕不会关闭';

  @override
  String get settingsHelpFeedback => '帮助与反馈';

  @override
  String get settingsRateUs => '给我们评分';

  @override
  String get settingsPrivacyPolicy => '隐私政策';

  @override
  String get settingsTerms => '使用条款';

  @override
  String settingsVersion(String version, String build) {
    return '版本 $version（$build）';
  }

  @override
  String get feedbackSubject => 'LandMeasure 反馈';

  @override
  String feedbackNoEmailApp(String email) {
    return '未找到邮件应用。请发送邮件至 $email。';
  }

  @override
  String get linkOpenFailed => '无法打开链接。请重试。';

  @override
  String get unitsDistanceTitle => '距离';

  @override
  String get unitsAreaTitle => '面积';

  @override
  String get unitsSecondary => '显示辅助单位';

  @override
  String unitsSecondaryExample(String example) {
    return '例如 $example';
  }

  @override
  String get unitsNote => '新测量使用这些单位。每个测量也可以在结果中切换单位。';

  @override
  String get unitMeters => '米';

  @override
  String get unitKilometers => '千米';

  @override
  String get unitFeet => '英尺';

  @override
  String get unitMiles => '英里';

  @override
  String get unitSquareMeters => '平方米';

  @override
  String get unitHectares => '公顷';

  @override
  String get unitAcres => '英亩';

  @override
  String get unitSquareFeet => '平方英尺';

  @override
  String get mapStyleNote => '新测量将以此地图打开。您可以用“地图图层”按钮切换。';

  @override
  String get actionApply => '应用';

  @override
  String get languageAppLanguages => '应用语言';

  @override
  String get languageMachineNote => '此语言为机器翻译，可能存在错误。';

  @override
  String get locationPermissionTitle => '允许访问位置';

  @override
  String get locationPermissionMessage =>
      'LandMeasure 使用您的位置在地图上显示您所在的地方。位置信息只保存在您的手机上。';

  @override
  String get locationPermissionMeasureMessage =>
      '在地图上显示您的位置，并在您所站的地方添加点。不开启也可以通过移动地图进行测量。';

  @override
  String get locationPermissionWalkMessage =>
      '此页面打开期间，步行测量会用 GPS 记录您的路径。位置信息只保存在您的手机上。';

  @override
  String get locationPermissionBlocked =>
      'LandMeasure 的定位权限已关闭。请在设置中开启以使用您的位置。';

  @override
  String get notificationPermissionTitle => '允许通知';

  @override
  String get notificationPermissionMessage => '允许通知，以便在熄屏时查看记录状态。';

  @override
  String get actionRetry => '重试';

  @override
  String get paywallTitle => '测量无限制';

  @override
  String get paywallSubtitle => '解锁无限项目和 Premium 功能。';

  @override
  String get paywallBenefitNoAds => '无广告';

  @override
  String get paywallBenefitSaves => '无限保存测量';

  @override
  String get paywallBenefitPhotos => '每个测量无限照片';

  @override
  String get paywallBenefitKml => '随时导出 KML';

  @override
  String paywallStartTrial(int days) {
    return '开始 $days 天免费试用';
  }

  @override
  String paywallTermsTrial(int days, String price, String store) {
    return '免费 $days 天，之后 $price/年。自动续订——可随时在 $store 取消。';
  }

  @override
  String paywallTermsYearly(String price, String store) {
    return '$price/年。自动续订——可随时在 $store 取消。';
  }

  @override
  String paywallTermsMonthly(String price, String store) {
    return '$price/月。自动续订——可随时在 $store 取消。';
  }

  @override
  String get paywallRestore => '恢复购买';

  @override
  String get paywallWelcome => '欢迎使用高级版！';

  @override
  String get paywallPending => '付款处理中。完成后将立即解锁高级版。';

  @override
  String get paywallPurchaseFailed => '购买未完成，您未被扣款。';

  @override
  String get paywallRestored => '已恢复购买。';

  @override
  String get paywallNothingToRestore => '此商店账号没有找到以前的购买记录。';

  @override
  String get paywallRestoreFailed => '无法恢复购买。请检查网络后重试。';

  @override
  String get paywallUnavailable => '暂时无法加载套餐。请检查网络后重试。';

  @override
  String get premiumActive => '高级版已激活';

  @override
  String get premiumActiveLifetime => '高级版已激活 · 终身';

  @override
  String get premiumManage => '管理';

  @override
  String get settingsPremiumTitle => 'LandMeasure 高级版';

  @override
  String get settingsPremiumSubtitle => '无广告，无限保存和照片，随时导出 KML';

  @override
  String get settingsManageSubscription => '管理订阅';

  @override
  String get settingsPrivacyChoices => '隐私选项';

  @override
  String get settingsAdInspector => 'Ad Inspector (dev)';

  @override
  String get exportUnlockTitle => '今天的免费 KML 导出已用完';

  @override
  String get exportUnlockMessage => '观看一段短广告即可导出此文件，或升级高级版无限导出 KML。CSV 导出仍然免费。';

  @override
  String get exportWatchAd => '观看广告';

  @override
  String get exportGetPremium => '升级高级版';

  @override
  String get exportLoadingAd => '正在加载广告…';

  @override
  String get exportAdDismissed => '看完广告即可解锁本次导出。';

  @override
  String get introNext => '下一步';

  @override
  String get introGetStarted => '开始使用';

  @override
  String get introAreaTitle => '轻松测量面积';

  @override
  String get introAreaBody => '在地图上标记点，几秒钟即可测量土地、农田和其他区域。';

  @override
  String get introDistanceTitle => '测量距离与路线';

  @override
  String get introDistanceBody => '测量直线距离，或在户外步行时记录你的路线。';

  @override
  String get introFieldTitle => '为真实野外作业而生';

  @override
  String get introFieldBody => '轻松测量农场、地块、房产和户外场地。';

  @override
  String paywallTrialTitle(int days) {
    return '$days 天免费试用';
  }

  @override
  String paywallThenMonthly(String price) {
    return '之后 $price / 月';
  }

  @override
  String get paywallMonthlyTitle => '月度方案';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price / 月';
  }

  @override
  String get paywallYearlyTitle => '年度方案';

  @override
  String paywallYearlyOnly(String price) {
    return '每年仅需 $price';
  }

  @override
  String get paywallBestPrice => '最优价格';

  @override
  String get paywallMostPopular => '最受欢迎';

  @override
  String get paywallStartFreeTrial => '开始免费试用';

  @override
  String paywallTrialThenYearly(int days, String price) {
    return '免费试用 $days 天，之后 $price/年';
  }

  @override
  String paywallPricePerYear(String price) {
    return '$price/年';
  }

  @override
  String get paywallCancelAnytime => '随时取消';

  @override
  String paywallTermsTrialMonthly(int days, String price, String store) {
    return '免费 $days 天，之后 $price/月。自动续订——可随时在 $store 中取消。';
  }

  @override
  String get premiumPromptTitle => '升级 Premium';

  @override
  String premiumPromptPhotos(int count) {
    return '每次测量最多可免费添加 $count 张照片。升级 Premium 即可添加更多。';
  }

  @override
  String get premiumPromptUpgrade => '升级';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get languageChooseTitle => '选择语言';

  @override
  String premiumPromptMapStyleReward(String style) {
    return '$style 地图是 Premium 功能。观看一段短广告即可使用至关闭应用，或升级永久使用。';
  }

  @override
  String mapStyleUnlocked(String style) {
    return '$style 地图已解锁，直至关闭应用。';
  }

  @override
  String get mapStyleAdDismissed => '请看完广告以解锁此地图。';

  @override
  String get pdfReportTitleArea => 'Land Measurement Report';

  @override
  String get pdfReportTitleDistance => 'Distance Measurement Report';

  @override
  String get pdfReportTitleWalk => 'Walk Measurement Report';

  @override
  String get pdfReportSubtitle => 'Exported summary of a saved measurement';

  @override
  String get pdfHeaderLabel => 'Measurement Report';

  @override
  String get pdfFooterGenerated => 'Generated by LandMeasure';

  @override
  String get pdfFooterEstimate =>
      'GPS/map measurements are estimates and may vary by device and environment.';

  @override
  String pdfPage(int page, int pages) {
    return 'Page $page of $pages';
  }

  @override
  String get pdfName => 'Measurement name';

  @override
  String get pdfType => 'Type';

  @override
  String get pdfDateSaved => 'Date saved';

  @override
  String get pdfReportId => 'Report ID';

  @override
  String get pdfSummary => 'Measurement summary';

  @override
  String get pdfArea => 'Area';

  @override
  String get pdfPerimeter => 'Perimeter';

  @override
  String get pdfDistance => 'Distance';

  @override
  String get pdfDuration => 'Duration';

  @override
  String get pdfPoints => 'Points';

  @override
  String get pdfSegments => 'Segments';

  @override
  String get pdfMethod => 'Method';

  @override
  String get pdfSubBoundaryVertices => 'Boundary vertices';

  @override
  String get pdfSubRoutePoints => 'Route points';

  @override
  String get pdfSubTrackPoints => 'Track points';

  @override
  String get pdfSubSegments => 'Between points';

  @override
  String get pdfMethodMapPoints => 'Map points';

  @override
  String get pdfMethodPolygon => 'Manual polygon';

  @override
  String get pdfMethodRoute => 'Manual route';

  @override
  String get pdfAreaNotClosed => 'Not closed';

  @override
  String get pdfAreaNotClosedSub => 'Route did not form a loop';

  @override
  String get pdfMapBoundary => 'Map & Shape';

  @override
  String get pdfMapCaption => 'Schematic of the measured shape · north is up';

  @override
  String get pdfCenter => 'Center coordinate';

  @override
  String get pdfMapStyle => 'Map style';

  @override
  String get pdfDisplayUnits => 'Display units';

  @override
  String get pdfCoordinates => 'Coordinates';

  @override
  String get pdfCoordinatesHint =>
      'Points are listed in the order they were measured.';

  @override
  String get pdfColPoint => 'Point';

  @override
  String get pdfColLatitude => 'Latitude';

  @override
  String get pdfColLongitude => 'Longitude';

  @override
  String get pdfColSegment => 'Segment';

  @override
  String get pdfColNote => 'Note';

  @override
  String get pdfNoteStart => 'Start';

  @override
  String get pdfNoteEnd => 'End';

  @override
  String get pdfNotePhoto => 'Photo attached';

  @override
  String pdfMorePoints(int count) {
    return '$count more points are not shown. Export CSV to get all of them.';
  }

  @override
  String get pdfNotes => 'Survey notes';

  @override
  String get pdfPhotos => 'Site photos';

  @override
  String pdfPhotoN(int n) {
    return 'Photo $n';
  }

  @override
  String pdfPhotoPoint(String point) {
    return 'At $point';
  }

  @override
  String pdfCaptured(String date) {
    return 'Captured $date';
  }

  @override
  String pdfMorePhotos(int count) {
    return '$count more photos are not shown.';
  }

  @override
  String get pdfExportInfo => 'Export information';

  @override
  String get pdfSource => 'Source';

  @override
  String get pdfSourceAndroid => 'LandMeasure Android';

  @override
  String get pdfSourceIos => 'LandMeasure iOS';

  @override
  String get pdfCoordFormat => 'Coordinate format';

  @override
  String get pdfCoordFormatValue => 'WGS 84 latitude / longitude';

  @override
  String get pdfExported => 'Exported';

  @override
  String get pdfCompanion => 'Other export formats';

  @override
  String get pdfAccuracyTitle => 'Accuracy notice:';

  @override
  String get pdfAccuracyBody =>
      'This report summarizes measurements calculated from map points and/or device GPS data. Results are estimates and may vary with device accuracy, satellite visibility, map imagery, terrain, and where boundary points were placed. This document is not a certified cadastral or legal land survey unless separately verified by an authorized survey professional.';

  @override
  String get exportPdf => 'PDF — 报告';

  @override
  String get exportPdfSubtitle => '含地图、坐标、备注和照片的可打印报告';

  @override
  String get projectLimitTitle => '已达到免费项目上限';

  @override
  String get projectLimitMessage =>
      '您已有 4 个免费项目。完整观看一段广告可再创建一个项目，或升级至 Premium 创建无限项目。';

  @override
  String get projectRewardRequired =>
      '请完整观看广告以解锁另一个项目。如果暂无广告，请稍后重试或升级至 Premium。';
}
