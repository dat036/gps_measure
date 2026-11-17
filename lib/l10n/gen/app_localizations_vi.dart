// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'LandMeasure';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navSaved => 'Đã lưu';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get measurementTypeArea => 'Diện tích';

  @override
  String get measurementTypeDistance => 'Khoảng cách';

  @override
  String get measurementTypeWalk => 'Đi bộ';

  @override
  String get screenMeasureArea => 'Đo diện tích';

  @override
  String get screenMeasureDistance => 'Đo khoảng cách';

  @override
  String get screenWalk => 'Đi bộ & Đo';

  @override
  String get screenSave => 'Lưu phép đo';

  @override
  String get screenDetail => 'Chi tiết phép đo';

  @override
  String get screenFullMap => 'Bản đồ';

  @override
  String get screenEdit => 'Sửa phép đo';

  @override
  String get screenSaved => 'Phép đo đã lưu';

  @override
  String get screenSettings => 'Cài đặt';

  @override
  String get screenUnits => 'Đơn vị';

  @override
  String get screenMapStyle => 'Kiểu bản đồ';

  @override
  String get screenLanguage => 'Ngôn ngữ';

  @override
  String get screenPaywall => 'Premium';

  @override
  String get ctaStartMeasuring => 'Bắt đầu đo';

  @override
  String get ctaStartArea => 'Bắt đầu đo diện tích';

  @override
  String get ctaStartDistance => 'Bắt đầu đo khoảng cách';

  @override
  String get ctaStartWalk => 'Bắt đầu đi bộ đo';

  @override
  String get ctaSaveMeasurement => 'Lưu phép đo';

  @override
  String get ctaSaveRoute => 'Lưu tuyến đường';

  @override
  String get ctaPause => 'Tạm dừng';

  @override
  String get ctaResume => 'Tiếp tục';

  @override
  String get ctaFinish => 'Kết thúc';

  @override
  String get actionCancel => 'Huỷ';

  @override
  String get actionSave => 'Lưu';

  @override
  String get actionDiscard => 'Bỏ';

  @override
  String get actionDelete => 'Xoá';

  @override
  String get actionReset => 'Đặt lại';

  @override
  String get actionOpenSettings => 'Mở Cài đặt';

  @override
  String get actionKeepRecording => 'Tiếp tục ghi';

  @override
  String get actionKeepEditing => 'Tiếp tục sửa';

  @override
  String get dialogResetTitle => 'Đặt lại phép đo?';

  @override
  String get dialogResetMessage => 'Tất cả các điểm sẽ bị xoá.';

  @override
  String get dialogDiscardDraftTitle => 'Bỏ bản nháp này?';

  @override
  String get dialogDiscardDraftMessage =>
      'Tất cả các điểm và thay đổi chưa lưu sẽ bị xoá.';

  @override
  String get dialogDeleteTitle => 'Xoá phép đo?';

  @override
  String get dialogDeleteMessage =>
      'Phép đo này cùng ảnh và ghi chú sẽ bị xoá vĩnh viễn.';

  @override
  String get dialogFinishWalkTitle => 'Kết thúc ghi?';

  @override
  String get dialogFinishWalkMessage => 'Việc theo dõi GPS sẽ dừng lại.';

  @override
  String get dialogRenameTitle => 'Đổi tên phép đo';

  @override
  String get dialogDiscardChangesTitle => 'Bỏ các thay đổi?';

  @override
  String get fabLayers => 'Lớp bản đồ';

  @override
  String get fabMyLocation => 'Vị trí của tôi';

  @override
  String get fabSearch => 'Tìm địa điểm';

  @override
  String get fabCamera => 'Chụp ảnh';

  @override
  String get gpsReady => 'GPS sẵn sàng';

  @override
  String get gpsSearching => 'Đang tìm GPS…';

  @override
  String get gpsLowAccuracy => 'Độ chính xác GPS thấp';

  @override
  String get locationOff => 'Vị trí đang tắt';

  @override
  String get locationOffMessage => 'Bật vị trí để ghi lại quãng đường đi bộ.';

  @override
  String get mapOffline => 'Mất kết nối bản đồ — các điểm của bạn vẫn an toàn';

  @override
  String get emptyNoMeasurementsTitle => 'Chưa có phép đo nào';

  @override
  String get emptyNoMeasurementsMessage =>
      'Hãy đo mảnh đất đầu tiên, kết quả sẽ hiện ở đây.';

  @override
  String get languageSystem => 'Theo hệ thống';

  @override
  String get measureHintCrosshair =>
      'Kéo bản đồ để đặt tâm ngắm, rồi bấm Thêm điểm.';

  @override
  String get measureHintTap =>
      'Chạm lên bản đồ để thêm các điểm quanh ranh giới.';

  @override
  String get toolbarUndo => 'Hoàn tác';

  @override
  String get toolbarAddPoint => 'Thêm điểm';

  @override
  String get toolbarClose => 'Khép hình';

  @override
  String get toolbarReset => 'Đặt lại';

  @override
  String get toolbarAddAtMyLocation => 'Thêm điểm tại vị trí của tôi';

  @override
  String get resultArea => 'Diện tích';

  @override
  String get resultPerimeter => 'Chu vi';

  @override
  String get resultAreaNeedsPoints => 'Thêm ít nhất 3 điểm để tính diện tích';

  @override
  String resultPointCount(int count) {
    return '$count điểm';
  }

  @override
  String get edgesCross => 'Các cạnh cắt nhau — diện tích có thể sai';

  @override
  String get menuMore => 'Tuỳ chọn khác';

  @override
  String get menuInputCrosshair => 'Thêm bằng tâm ngắm';

  @override
  String get menuInputTap => 'Thêm bằng cách chạm bản đồ';

  @override
  String get menuShowEdgeLabels => 'Hiện độ dài cạnh';

  @override
  String pointLabel(int number) {
    return 'Điểm $number';
  }

  @override
  String get pointDelete => 'Xoá điểm';

  @override
  String get pointDeselect => 'Xong';

  @override
  String gpsLowAccuracyAdded(int meters) {
    return 'Độ chính xác GPS thấp (±$meters m). Điểm vẫn được thêm.';
  }

  @override
  String get locationUnavailable =>
      'Không lấy được vị trí. Hãy thử lại ở nơi thoáng.';

  @override
  String get locationPermissionDenied =>
      'Quyền vị trí đang tắt. Bạn vẫn đo được bằng cách kéo bản đồ.';

  @override
  String get locationServiceOff => 'Định vị trên máy đang tắt.';

  @override
  String get mapLayersTitle => 'Kiểu bản đồ';

  @override
  String get mapStyleStandard => 'Tiêu chuẩn';

  @override
  String get mapStyleSatellite => 'Vệ tinh';

  @override
  String get mapStyleTerrain => 'Địa hình';

  @override
  String get mapStyleHybrid => 'Kết hợp';

  @override
  String get draftSaveFailed =>
      'Chưa lưu được các điểm. Hệ thống sẽ lưu lại ở thay đổi tiếp theo.';

  @override
  String get menuHelp => 'Hướng dẫn';

  @override
  String get actionGotIt => 'Đã hiểu';

  @override
  String get helpTitleArea => 'Cách đo diện tích';

  @override
  String get helpTitleDistance => 'Cách đo khoảng cách';

  @override
  String get helpTitleWalk => 'Cách đi bộ đo';

  @override
  String get helpAreaSummary =>
      'Thêm các điểm quanh ranh giới mảnh đất của bạn.';

  @override
  String get helpDistanceSummary =>
      'Thêm các điểm dọc theo tuyến đường bạn muốn đo.';

  @override
  String get helpWalkSummary =>
      'Đi bộ quanh ranh giới, LandMeasure sẽ ghi lại đường đi GPS của bạn.';

  @override
  String get helpPhotoTip =>
      'Chụp ảnh để ghi lại cột mốc, ranh giới hoặc hiện trạng khu đất.';

  @override
  String get helpAccuracyNote =>
      'Độ chính xác của GPS và bản đồ có thể khác nhau tùy thiết bị, ảnh bản đồ và môi trường.';

  @override
  String get helpAreaStep1 =>
      'Kéo bản đồ để tâm ngắm nằm đúng góc đất, rồi bấm **Thêm điểm**.';

  @override
  String get helpAreaStep2 =>
      'Thêm ít nhất 3 điểm quanh ranh giới. Kéo điểm để chỉnh vị trí.';

  @override
  String get helpAreaStep3 =>
      'Bấm **Khép hình** để hoàn tất, rồi **Lưu phép đo**.';

  @override
  String get helpDistanceStep1 =>
      'Đặt tâm ngắm tại điểm bắt đầu và bấm **Thêm điểm**.';

  @override
  String get helpDistanceStep2 =>
      'Tiếp tục thêm điểm dọc tuyến đường. Độ dài từng đoạn hiện trên bản đồ.';

  @override
  String get helpDistanceStep3 => 'Bấm **Lưu tuyến đường** khi xong.';

  @override
  String get helpWalkStep1 => 'Chờ **GPS sẵn sàng**, rồi bấm **Bắt đầu đi**.';

  @override
  String get helpWalkStep2 =>
      'Đi dọc theo ranh giới. Bấm **Tạm dừng** nếu cần nghỉ.';

  @override
  String get helpWalkStep3 =>
      'Quay về điểm xuất phát và bấm **Kết thúc** để tính diện tích.';

  @override
  String get helpTipGpsPoint =>
      'Mẹo: bấm 📍 để thêm điểm tại vị trí GPS hiện tại của bạn.';

  @override
  String get helpTipWalk => 'Mẹo: đứng ở nơi thoáng để GPS chính xác hơn.';

  @override
  String get resultDistance => 'Khoảng cách';

  @override
  String get resultDistanceNeedsPoints =>
      'Thêm ít nhất 2 điểm để đo khoảng cách';

  @override
  String resultSegmentCount(int count) {
    return '$count đoạn';
  }

  @override
  String get segmentsTitle => 'Các đoạn';

  @override
  String draftSavedSnack(int count, String type) {
    return 'Đã lưu nháp · $type · $count điểm';
  }

  @override
  String get searchHint => 'Địa chỉ, toạ độ hoặc link Google Maps';

  @override
  String get searchAction => 'Tìm';

  @override
  String get searchRecent => 'Tìm kiếm gần đây';

  @override
  String get searchNoResults =>
      'Không tìm thấy địa điểm. Hãy thử nhập toạ độ hoặc dán link Google Maps.';

  @override
  String get searchNeedsInternet => 'Cần kết nối mạng để tìm địa chỉ.';

  @override
  String get searchUnavailable =>
      'Máy này không hỗ trợ tìm địa chỉ. Hãy thử nhập toạ độ hoặc dán link Google Maps.';

  @override
  String get searchClear => 'Xoá';

  @override
  String get searchFailed =>
      'Chưa tìm được địa chỉ này. Hãy thử nhập toạ độ hoặc dán link Google Maps.';

  @override
  String get ctaStartWalking => 'Bắt đầu đi';

  @override
  String get walkReadyHelper =>
      'Đi quanh ranh giới để ghi lại đường đi của bạn.';

  @override
  String get keepScreenOn => 'Giữ màn hình sáng';

  @override
  String get walkRecording => 'Đang ghi GPS…';

  @override
  String get walkPaused => 'Đã tạm dừng';

  @override
  String get walkPausedMessage =>
      'Bấm Tiếp tục để ghi tiếp từ vị trí hiện tại.';

  @override
  String gpsAccuracyShort(int meters) {
    return '±$meters m';
  }

  @override
  String gpsLowAccuracyMessage(int meters) {
    return 'Độ chính xác ±$meters m — chưa ghi điểm cho tới khi tốt hơn. Hãy ra chỗ thoáng.';
  }

  @override
  String get locationDeniedTitle => 'Chưa cho phép truy cập vị trí';

  @override
  String get locationDeniedMessage =>
      'Cho phép truy cập vị trí để ghi lại đường đi.';

  @override
  String get actionAllow => 'Cho phép';

  @override
  String get actionNotNow => 'Để sau';

  @override
  String get mockLocationDetected =>
      'Phát hiện vị trí giả — các vị trí này không được ghi.';

  @override
  String get walkCloseToStart =>
      'Đã gần điểm xuất phát — bấm Kết thúc để tính diện tích';

  @override
  String get walkNotClosed => 'Đường đi chưa khép kín — chỉ tính quãng đường';

  @override
  String get walkKeepWalking => 'Quay về điểm xuất phát để khép vòng.';

  @override
  String get resultDuration => 'Thời gian';

  @override
  String get walkNotificationTitle => 'LandMeasure đang ghi phép đo của bạn';

  @override
  String get walkNotificationText => 'Chạm để quay lại màn đi bộ.';

  @override
  String get walkNotificationChannel => 'Ghi đường đi bộ';

  @override
  String get walkRecordingBack =>
      'Đang ghi. Hãy tạm dừng hoặc kết thúc trước khi rời màn.';

  @override
  String get walkPauseAndLeave => 'Dừng & thoát';

  @override
  String get walkStartFailed => 'Không bắt đầu ghi được. Hãy thử lại.';

  @override
  String get batteryHintTitle => 'Cho phép LandMeasure chạy nền';

  @override
  String get batteryHintMessage =>
      'Một số điện thoại tự dừng ứng dụng khi tắt màn hình. Để tiếp tục ghi đường đi, mở Cài đặt → Pin và chọn \"Không hạn chế\" cho LandMeasure.';

  @override
  String get fabRecenter => 'Về vị trí của tôi';

  @override
  String get homeHeroSubtitle => 'Chọn cách đo mảnh đất của bạn.';

  @override
  String get homeContinueTitle => 'Tiếp tục đo';

  @override
  String get homeSeeAllDrafts => 'Xem tất cả bản nháp';

  @override
  String get homeRecentTitle => 'Phép đo gần đây';

  @override
  String get homeRecentEmptyTitle => 'Chưa có phép đo gần đây';

  @override
  String get homeRecentEmptyMessage => 'Các phép đo đã lưu sẽ hiện ở đây.';

  @override
  String get actionSeeAll => 'Xem tất cả';

  @override
  String get untitledArea => 'Diện tích chưa đặt tên';

  @override
  String get untitledDistance => 'Khoảng cách chưa đặt tên';

  @override
  String get untitledWalk => 'Đi bộ chưa đặt tên';

  @override
  String get draftLabel => 'Nháp';

  @override
  String get walkFinishedNotSaved => 'Đã kết thúc · chưa lưu';

  @override
  String lastEdited(String time) {
    return 'Sửa lần cuối $time';
  }

  @override
  String get timeJustNow => 'vừa xong';

  @override
  String timeMinutesAgo(int count) {
    return '$count phút trước';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count giờ trước';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày trước',
      one: 'hôm qua',
    );
    return '$_temp0';
  }

  @override
  String get savedSearchHint => 'Tìm theo tên';

  @override
  String get savedSearchOpen => 'Tìm kiếm';

  @override
  String get savedSearchClose => 'Đóng tìm kiếm';

  @override
  String get filterAll => 'Tất cả';

  @override
  String filterWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String savedDraftsTitle(int count) {
    return 'Bản nháp ($count)';
  }

  @override
  String get savedNoResults => 'Không tìm thấy phép đo nào.';

  @override
  String get menuRename => 'Đổi tên';

  @override
  String get menuExport => 'Xuất file';

  @override
  String get measurementDeleted => 'Đã xoá phép đo';

  @override
  String get draftDiscarded => 'Đã bỏ bản nháp';

  @override
  String get exportTitle => 'Xuất file';

  @override
  String get renameHint => 'Tên phép đo';

  @override
  String get saveNameLabel => 'Tên';

  @override
  String get saveNameRequired => 'Vui lòng nhập tên';

  @override
  String get saveNotesLabel => 'Ghi chú';

  @override
  String get saveNotesHint => 'Ranh giới, chủ đất, mốc… (không bắt buộc)';

  @override
  String get saveTypeLabel => 'Loại';

  @override
  String get saveFailed => 'Chưa lưu được. Vui lòng thử lại.';

  @override
  String get saveLimitReached =>
      'Bạn đã đạt giới hạn lưu của bản miễn phí. Phép đo này vẫn nằm trong bản nháp.';

  @override
  String get saveNotFound => 'Phép đo này không còn tồn tại.';

  @override
  String photosTitle(int count) {
    return 'Ảnh hiện trường ($count)';
  }

  @override
  String get actionClose => 'Đóng';

  @override
  String get resultPoints => 'Số điểm';

  @override
  String get resultSegments => 'Số đoạn';

  @override
  String get resultAvgPace => 'Tốc độ TB';

  @override
  String paceValue(String time, String unit) {
    return '$time /$unit';
  }

  @override
  String get notesTitle => 'Ghi chú';

  @override
  String get notesEmpty => 'Chưa có ghi chú';

  @override
  String get actionEdit => 'Sửa';

  @override
  String get actionExport => 'Xuất file';

  @override
  String get detailOpenMap => 'Mở bản đồ';

  @override
  String savedOn(String date) {
    return 'Lưu $date';
  }

  @override
  String get addPhotoTitle => 'Thêm ảnh';

  @override
  String get addPhotoCamera => 'Chụp ảnh';

  @override
  String get addPhotoGallery => 'Chọn từ thư viện';

  @override
  String addPhotoForPoint(int number) {
    return 'Cho điểm $number';
  }

  @override
  String get addPhotoTile => 'Thêm ảnh';

  @override
  String get photoAddFailed => 'Chưa thêm được ảnh. Vui lòng thử lại.';

  @override
  String get photoRemoved => 'Đã xoá ảnh';

  @override
  String get actionUndo => 'Hoàn tác';

  @override
  String get photoLimitReached =>
      'Bạn đã đạt giới hạn ảnh của bản miễn phí cho phép đo này.';

  @override
  String get photoDeleteTitle => 'Xoá ảnh?';

  @override
  String get photoDeleteMessage => 'Ảnh này sẽ bị xoá khỏi phép đo.';

  @override
  String get photoAttachTitle => 'Đính kèm ảnh này vào phép đo?';

  @override
  String get photoAttachMessage =>
      'Mục \"Lưu ảnh vào phép đo\" đang tắt trong Cài đặt.';

  @override
  String get actionAttach => 'Đính kèm';

  @override
  String get photoWaitForStart => 'Bắt đầu đi để thêm ảnh.';

  @override
  String photoCounter(int index, int total) {
    return '$index / $total';
  }

  @override
  String get photoShare => 'Chia sẻ';

  @override
  String photoOpen(int number) {
    return 'Mở ảnh $number';
  }

  @override
  String get photoRemove => 'Xoá ảnh';

  @override
  String get pointPhoto => 'Ảnh';

  @override
  String get cameraPermissionTitle => 'Cho phép dùng máy ảnh';

  @override
  String get cameraPermissionMessage =>
      'Chụp cột mốc, ranh giới và hiện trạng khu đất, lưu kèm phép đo của bạn.';

  @override
  String get cameraPermissionDenied =>
      'Quyền máy ảnh đang tắt. Bạn có thể bật trong Cài đặt.';

  @override
  String get actionContinue => 'Tiếp tục';

  @override
  String get notesEditTitle => 'Sửa ghi chú';

  @override
  String get notesAdd => 'Thêm ghi chú';

  @override
  String get editTabResult => 'Kết quả';

  @override
  String get editTabDetails => 'Thông tin';

  @override
  String get ctaSaveChanges => 'Lưu thay đổi';

  @override
  String get dialogDiscardChangesMessage =>
      'Các thay đổi với phép đo này sẽ bị mất.';

  @override
  String get changesSaved => 'Đã lưu thay đổi';

  @override
  String get menuReopenShape => 'Mở lại hình';

  @override
  String get exportKml => 'KML — Google Earth';

  @override
  String get exportKmlSubtitle =>
      'Hình và các điểm có ảnh cho Google Earth, phần mềm GIS';

  @override
  String get exportCsv => 'CSV — Excel';

  @override
  String get exportCsvSubtitle => 'Toàn bộ điểm kèm toạ độ, mở bằng Excel';

  @override
  String get exportPreparing => 'Đang tạo file…';

  @override
  String get exportFailed => 'Chưa xuất được file. Vui lòng thử lại.';

  @override
  String get exportLimitReached =>
      'Lượt xuất KML miễn phí hôm nay đã dùng. Xuất CSV vẫn miễn phí.';

  @override
  String get landValueTitle => 'Giá trị đất';

  @override
  String get landValueAdd => 'Thêm giá trị đất';

  @override
  String get landValueUnitPrice => 'Đơn giá';

  @override
  String get landValueUnit => 'Tính theo';

  @override
  String landValueEstimated(String value) {
    return 'Giá trị ước tính ≈ $value';
  }

  @override
  String landValueRate(String price, String unit) {
    return '$price / $unit';
  }

  @override
  String get landValueNeedsArea => 'Cần có diện tích để tính giá trị đất.';

  @override
  String get landValueRemove => 'Xoá';

  @override
  String get landValueInvalid => 'Nhập đơn giá lớn hơn 0';

  @override
  String get resultValue => 'Giá trị';

  @override
  String get settingsSubtitle => 'Đơn vị, bản đồ và tuỳ chọn ứng dụng';

  @override
  String get settingsSectionPreferences => 'Tuỳ chọn đo';

  @override
  String get settingsSectionMeasureMap => 'Đo đạc & bản đồ';

  @override
  String get settingsSectionSupport => 'Hỗ trợ & pháp lý';

  @override
  String get settingsDefaultMode => 'Kiểu đo mặc định';

  @override
  String get settingsDefaultModeHint =>
      'Được chọn sẵn ở Trang chủ khi mở ứng dụng.';

  @override
  String get settingsGpsAccuracy => 'Hiện độ chính xác GPS';

  @override
  String get settingsGpsAccuracySubtitle =>
      'Hiện ±m và vòng độ chính xác khi đi đo';

  @override
  String get settingsAutoCenter => 'Tự căn giữa bản đồ';

  @override
  String get settingsAutoCenterSubtitle =>
      'Mở bản đồ tại vị trí của bạn và bám theo khi đi đo';

  @override
  String get settingsSavePhotos => 'Lưu ảnh vào phép đo';

  @override
  String get settingsSavePhotosSubtitle => 'Tự đính kèm ảnh mới, không hỏi lại';

  @override
  String get settingsKeepAwake => 'Giữ màn hình sáng';

  @override
  String get settingsKeepAwakeSubtitle => 'Màn hình không tắt khi đang đo';

  @override
  String get settingsHelpFeedback => 'Trợ giúp & góp ý';

  @override
  String get settingsRateUs => 'Đánh giá ứng dụng';

  @override
  String get settingsPrivacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get settingsTerms => 'Điều khoản sử dụng';

  @override
  String settingsVersion(String version, String build) {
    return 'Phiên bản $version ($build)';
  }

  @override
  String get feedbackSubject => 'Góp ý LandMeasure';

  @override
  String feedbackNoEmailApp(String email) {
    return 'Không tìm thấy ứng dụng email. Hãy gửi thư cho chúng tôi tại $email.';
  }

  @override
  String get linkOpenFailed => 'Không mở được liên kết. Vui lòng thử lại.';

  @override
  String get unitsDistanceTitle => 'Khoảng cách';

  @override
  String get unitsAreaTitle => 'Diện tích';

  @override
  String get unitsSecondary => 'Hiện đơn vị phụ';

  @override
  String unitsSecondaryExample(String example) {
    return 'VD: $example';
  }

  @override
  String get unitsNote =>
      'Phép đo mới dùng các đơn vị này. Mỗi phép đo vẫn đổi được đơn vị ngay tại phần kết quả.';

  @override
  String get unitMeters => 'Mét';

  @override
  String get unitKilometers => 'Ki-lô-mét';

  @override
  String get unitFeet => 'Feet';

  @override
  String get unitMiles => 'Dặm';

  @override
  String get unitSquareMeters => 'Mét vuông';

  @override
  String get unitHectares => 'Héc-ta';

  @override
  String get unitAcres => 'Mẫu Anh (acre)';

  @override
  String get unitSquareFeet => 'Feet vuông';

  @override
  String get mapStyleNote =>
      'Phép đo mới mở với kiểu bản đồ này. Bạn vẫn đổi được bằng nút Lớp bản đồ trên màn đo.';

  @override
  String get actionApply => 'Áp dụng';

  @override
  String get languageAppLanguages => 'Ngôn ngữ ứng dụng';

  @override
  String get languageMachineNote =>
      'Ngôn ngữ này được dịch máy và có thể còn lỗi.';

  @override
  String get locationPermissionTitle => 'Cho phép truy cập vị trí';

  @override
  String get locationPermissionMessage =>
      'LandMeasure dùng vị trí để hiện bạn đang ở đâu trên bản đồ. Vị trí chỉ lưu trên điện thoại của bạn.';

  @override
  String get locationPermissionMeasureMessage =>
      'Hiện vị trí của bạn trên bản đồ và thêm điểm ngay chỗ bạn đứng. Không cho phép vẫn đo được bằng cách kéo bản đồ.';

  @override
  String get locationPermissionWalkMessage =>
      'Đi & đo ghi lại đường đi bằng GPS khi màn hình này đang mở. Vị trí chỉ lưu trên điện thoại của bạn.';

  @override
  String get locationPermissionBlocked =>
      'Quyền vị trí của LandMeasure đang tắt. Bật lại trong Cài đặt để dùng vị trí của bạn.';

  @override
  String get notificationPermissionTitle => 'Cho phép thông báo';

  @override
  String get notificationPermissionMessage =>
      'Cho phép thông báo để xem trạng thái ghi khi màn hình tắt.';

  @override
  String get actionRetry => 'Thử lại';

  @override
  String get paywallTitle => 'Đo không giới hạn';

  @override
  String get paywallSubtitle =>
      'Premium mở khóa project không giới hạn và các tính năng nâng cao.';

  @override
  String get paywallBenefitNoAds => 'Không quảng cáo';

  @override
  String get paywallBenefitSaves => 'Lưu phép đo không giới hạn';

  @override
  String get paywallBenefitPhotos => 'Ảnh không giới hạn cho mỗi phép đo';

  @override
  String get paywallBenefitKml => 'Xuất KML bất cứ lúc nào';

  @override
  String paywallStartTrial(int days) {
    return 'Dùng thử miễn phí $days ngày';
  }

  @override
  String paywallTermsTrial(int days, String price, String store) {
    return 'Miễn phí $days ngày, sau đó $price/năm. Tự động gia hạn — huỷ bất cứ lúc nào trong $store.';
  }

  @override
  String paywallTermsYearly(String price, String store) {
    return '$price/năm. Tự động gia hạn — huỷ bất cứ lúc nào trong $store.';
  }

  @override
  String paywallTermsMonthly(String price, String store) {
    return '$price/tháng. Tự động gia hạn — huỷ bất cứ lúc nào trong $store.';
  }

  @override
  String get paywallRestore => 'Khôi phục giao dịch';

  @override
  String get paywallWelcome => 'Chào mừng bạn đến với Premium!';

  @override
  String get paywallPending =>
      'Thanh toán đang chờ xử lý. Premium sẽ mở ngay khi hoàn tất.';

  @override
  String get paywallPurchaseFailed =>
      'Giao dịch chưa thành công. Bạn chưa bị trừ tiền.';

  @override
  String get paywallRestored => 'Đã khôi phục giao dịch.';

  @override
  String get paywallNothingToRestore =>
      'Không tìm thấy giao dịch nào của tài khoản cửa hàng này.';

  @override
  String get paywallRestoreFailed =>
      'Không khôi phục được giao dịch. Kiểm tra kết nối rồi thử lại.';

  @override
  String get paywallUnavailable =>
      'Chưa tải được các gói. Kiểm tra kết nối rồi thử lại.';

  @override
  String get premiumActive => 'Premium đang hoạt động';

  @override
  String get premiumActiveLifetime => 'Premium đang hoạt động · Trọn đời';

  @override
  String get premiumManage => 'Quản lý';

  @override
  String get settingsPremiumTitle => 'LandMeasure Premium';

  @override
  String get settingsPremiumSubtitle =>
      'Không quảng cáo, lưu và chụp ảnh không giới hạn, xuất KML thoải mái';

  @override
  String get settingsManageSubscription => 'Quản lý gói đăng ký';

  @override
  String get settingsPrivacyChoices => 'Lựa chọn quyền riêng tư';

  @override
  String get settingsAdInspector => 'Ad Inspector (dev)';

  @override
  String get exportUnlockTitle => 'Đã dùng lượt xuất KML miễn phí hôm nay';

  @override
  String get exportUnlockMessage =>
      'Xem một quảng cáo ngắn để xuất file này, hoặc nâng cấp Premium để xuất KML không giới hạn. Xuất CSV vẫn miễn phí.';

  @override
  String get exportWatchAd => 'Xem quảng cáo';

  @override
  String get exportGetPremium => 'Nâng cấp Premium';

  @override
  String get exportLoadingAd => 'Đang tải quảng cáo…';

  @override
  String get exportAdDismissed => 'Xem hết quảng cáo để mở lượt xuất này.';

  @override
  String get introNext => 'Tiếp';

  @override
  String get introGetStarted => 'Bắt đầu';

  @override
  String get introAreaTitle => 'Đo diện tích dễ dàng';

  @override
  String get introAreaBody =>
      'Đánh dấu các điểm trên bản đồ để đo đất, ruộng và các khu vực khác chỉ trong vài giây.';

  @override
  String get introDistanceTitle => 'Đo khoảng cách & lộ trình';

  @override
  String get introDistanceBody =>
      'Đo khoảng cách đường thẳng hoặc ghi lại lộ trình khi bạn đi bộ ngoài trời.';

  @override
  String get introFieldTitle => 'Dành cho công việc thực địa';

  @override
  String get introFieldBody =>
      'Đo nông trại, thửa đất, bất động sản và các địa điểm ngoài trời thật dễ dàng.';

  @override
  String paywallTrialTitle(int days) {
    return 'Dùng thử miễn phí $days ngày';
  }

  @override
  String paywallThenMonthly(String price) {
    return 'Sau đó $price / tháng';
  }

  @override
  String get paywallMonthlyTitle => 'Gói Tháng';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price / tháng';
  }

  @override
  String get paywallYearlyTitle => 'Gói Năm';

  @override
  String paywallYearlyOnly(String price) {
    return 'Chỉ $price mỗi năm';
  }

  @override
  String get paywallBestPrice => 'Giá tốt nhất';

  @override
  String get paywallMostPopular => 'Phổ biến nhất';

  @override
  String get paywallStartFreeTrial => 'Bắt đầu dùng thử miễn phí';

  @override
  String paywallTrialThenYearly(int days, String price) {
    return 'Dùng thử $days ngày, sau đó $price/năm';
  }

  @override
  String paywallPricePerYear(String price) {
    return '$price/năm';
  }

  @override
  String get paywallCancelAnytime => 'Hủy bất kỳ lúc nào';

  @override
  String paywallTermsTrialMonthly(int days, String price, String store) {
    return 'Miễn phí $days ngày, sau đó $price/tháng. Tự động gia hạn — huỷ bất cứ lúc nào trong $store.';
  }

  @override
  String get premiumPromptTitle => 'Nâng cấp Premium';

  @override
  String premiumPromptPhotos(int count) {
    return 'Bạn có thể thêm tối đa $count ảnh cho mỗi phép đo miễn phí. Nâng cấp Premium để thêm nhiều hơn.';
  }

  @override
  String get premiumPromptUpgrade => 'Nâng cấp';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get languageChooseTitle => 'Chọn ngôn ngữ';

  @override
  String premiumPromptMapStyleReward(String style) {
    return 'Bản đồ $style là tính năng Premium. Xem một quảng cáo ngắn để dùng đến khi bạn đóng ứng dụng, hoặc nâng cấp để dùng mãi.';
  }

  @override
  String mapStyleUnlocked(String style) {
    return 'Đã mở khoá bản đồ $style đến khi bạn đóng ứng dụng.';
  }

  @override
  String get mapStyleAdDismissed =>
      'Hãy xem hết quảng cáo để mở khoá bản đồ này.';

  @override
  String get pdfReportTitleArea => 'Báo cáo đo đất';

  @override
  String get pdfReportTitleDistance => 'Báo cáo đo khoảng cách';

  @override
  String get pdfReportTitleWalk => 'Báo cáo đo bằng đi bộ';

  @override
  String get pdfReportSubtitle => 'Tóm tắt phép đo đã lưu';

  @override
  String get pdfHeaderLabel => 'Báo cáo đo đạc';

  @override
  String get pdfFooterGenerated => 'Tạo bởi LandMeasure';

  @override
  String get pdfFooterEstimate =>
      'Số đo GPS/bản đồ chỉ là ước tính và có thể khác nhau tuỳ thiết bị và môi trường.';

  @override
  String pdfPage(int page, int pages) {
    return 'Trang $page/$pages';
  }

  @override
  String get pdfName => 'Tên phép đo';

  @override
  String get pdfType => 'Loại';

  @override
  String get pdfDateSaved => 'Ngày lưu';

  @override
  String get pdfReportId => 'Mã báo cáo';

  @override
  String get pdfSummary => 'Tóm tắt kết quả';

  @override
  String get pdfArea => 'Diện tích';

  @override
  String get pdfPerimeter => 'Chu vi';

  @override
  String get pdfDistance => 'Khoảng cách';

  @override
  String get pdfDuration => 'Thời gian';

  @override
  String get pdfPoints => 'Số điểm';

  @override
  String get pdfSegments => 'Số đoạn';

  @override
  String get pdfMethod => 'Cách đo';

  @override
  String get pdfSubBoundaryVertices => 'Đỉnh ranh giới';

  @override
  String get pdfSubRoutePoints => 'Điểm trên tuyến';

  @override
  String get pdfSubTrackPoints => 'Điểm ghi được';

  @override
  String get pdfSubSegments => 'Giữa các điểm';

  @override
  String get pdfMethodMapPoints => 'Chấm trên bản đồ';

  @override
  String get pdfMethodPolygon => 'Đa giác tự vẽ';

  @override
  String get pdfMethodRoute => 'Tuyến tự vẽ';

  @override
  String get pdfAreaNotClosed => 'Chưa khép kín';

  @override
  String get pdfAreaNotClosedSub => 'Tuyến chưa khép thành vòng';

  @override
  String get pdfMapBoundary => 'Bản đồ & hình dạng';

  @override
  String get pdfMapCaption => 'Sơ đồ hình đã đo · phía trên là hướng bắc';

  @override
  String get pdfCenter => 'Toạ độ trung tâm';

  @override
  String get pdfMapStyle => 'Kiểu bản đồ';

  @override
  String get pdfDisplayUnits => 'Đơn vị hiển thị';

  @override
  String get pdfCoordinates => 'Toạ độ các điểm';

  @override
  String get pdfCoordinatesHint => 'Các điểm được liệt kê theo thứ tự đo.';

  @override
  String get pdfColPoint => 'Điểm';

  @override
  String get pdfColLatitude => 'Vĩ độ';

  @override
  String get pdfColLongitude => 'Kinh độ';

  @override
  String get pdfColSegment => 'Đoạn';

  @override
  String get pdfColNote => 'Ghi chú';

  @override
  String get pdfNoteStart => 'Điểm đầu';

  @override
  String get pdfNoteEnd => 'Điểm cuối';

  @override
  String get pdfNotePhoto => 'Có ảnh đính kèm';

  @override
  String pdfMorePoints(int count) {
    return 'Còn $count điểm không hiển thị. Xuất CSV để có đầy đủ.';
  }

  @override
  String get pdfNotes => 'Ghi chú';

  @override
  String get pdfPhotos => 'Ảnh hiện trường';

  @override
  String pdfPhotoN(int n) {
    return 'Ảnh $n';
  }

  @override
  String pdfPhotoPoint(String point) {
    return 'Tại $point';
  }

  @override
  String pdfCaptured(String date) {
    return 'Chụp lúc $date';
  }

  @override
  String pdfMorePhotos(int count) {
    return 'Còn $count ảnh không hiển thị.';
  }

  @override
  String get pdfExportInfo => 'Thông tin xuất file';

  @override
  String get pdfSource => 'Nguồn';

  @override
  String get pdfSourceAndroid => 'LandMeasure Android';

  @override
  String get pdfSourceIos => 'LandMeasure iOS';

  @override
  String get pdfCoordFormat => 'Hệ toạ độ';

  @override
  String get pdfCoordFormatValue => 'WGS 84 vĩ độ / kinh độ';

  @override
  String get pdfExported => 'Thời điểm xuất';

  @override
  String get pdfCompanion => 'Định dạng xuất khác';

  @override
  String get pdfAccuracyTitle => 'Lưu ý về độ chính xác:';

  @override
  String get pdfAccuracyBody =>
      'Báo cáo này tóm tắt các số đo tính từ điểm trên bản đồ và/hoặc dữ liệu GPS của thiết bị. Kết quả chỉ là ước tính và có thể thay đổi theo độ chính xác của thiết bị, số vệ tinh nhìn thấy, ảnh bản đồ, địa hình và vị trí đặt các điểm ranh giới. Tài liệu này không phải bản đo đạc địa chính hay pháp lý, trừ khi được người có chuyên môn đo đạc được cấp phép xác minh riêng.';

  @override
  String get exportPdf => 'PDF — Báo cáo';

  @override
  String get exportPdfSubtitle =>
      'Báo cáo in được: bản đồ, toạ độ, ghi chú và ảnh';

  @override
  String get projectLimitTitle => 'Đã đạt giới hạn project miễn phí';

  @override
  String get projectLimitMessage =>
      'Bạn đã có 4 project miễn phí. Xem hết một quảng cáo để tạo thêm 1 project hoặc nâng cấp Premium để tạo không giới hạn.';

  @override
  String get projectRewardRequired =>
      'Hãy xem hết quảng cáo để mở thêm project. Nếu chưa có quảng cáo, vui lòng thử lại sau hoặc nâng cấp Premium.';
}
