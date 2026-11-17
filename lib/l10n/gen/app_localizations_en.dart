// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LandMeasure';

  @override
  String get navHome => 'Home';

  @override
  String get navSaved => 'Saved';

  @override
  String get navSettings => 'Setting';

  @override
  String get measurementTypeArea => 'Area';

  @override
  String get measurementTypeDistance => 'Distance';

  @override
  String get measurementTypeWalk => 'Walk';

  @override
  String get screenMeasureArea => 'Measure Area';

  @override
  String get screenMeasureDistance => 'Measure Distance';

  @override
  String get screenWalk => 'Walk & Measure';

  @override
  String get screenSave => 'Save Measurement';

  @override
  String get screenDetail => 'Measurement Detail';

  @override
  String get screenFullMap => 'Map';

  @override
  String get screenEdit => 'Edit Measurement';

  @override
  String get screenSaved => 'Saved Measurements';

  @override
  String get screenSettings => 'Setting';

  @override
  String get screenUnits => 'Units';

  @override
  String get screenMapStyle => 'Map Style';

  @override
  String get screenLanguage => 'Language';

  @override
  String get screenPaywall => 'Premium';

  @override
  String get ctaStartMeasuring => 'Start Measuring';

  @override
  String get ctaStartArea => 'Start Area Survey';

  @override
  String get ctaStartDistance => 'Start Distance Measure';

  @override
  String get ctaStartWalk => 'Start Walk Measure';

  @override
  String get ctaSaveMeasurement => 'Save Measurement';

  @override
  String get ctaSaveRoute => 'Save Route';

  @override
  String get ctaPause => 'Pause';

  @override
  String get ctaResume => 'Resume';

  @override
  String get ctaFinish => 'Finish';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionSave => 'Save';

  @override
  String get actionDiscard => 'Discard';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionReset => 'Reset';

  @override
  String get actionOpenSettings => 'Open Settings';

  @override
  String get actionKeepRecording => 'Keep recording';

  @override
  String get actionKeepEditing => 'Keep editing';

  @override
  String get dialogResetTitle => 'Reset measurement?';

  @override
  String get dialogResetMessage => 'This will remove all points.';

  @override
  String get dialogDiscardDraftTitle => 'Discard this draft?';

  @override
  String get dialogDiscardDraftMessage =>
      'All points and unsaved changes will be removed.';

  @override
  String get dialogDeleteTitle => 'Delete measurement?';

  @override
  String get dialogDeleteMessage =>
      'This measurement, its photos and notes will be permanently deleted.';

  @override
  String get dialogFinishWalkTitle => 'Finish recording?';

  @override
  String get dialogFinishWalkMessage => 'GPS tracking will stop.';

  @override
  String get dialogRenameTitle => 'Rename Measurement';

  @override
  String get dialogDiscardChangesTitle => 'Discard changes?';

  @override
  String get fabLayers => 'Map layers';

  @override
  String get fabMyLocation => 'My location';

  @override
  String get fabSearch => 'Search place';

  @override
  String get fabCamera => 'Take photo';

  @override
  String get gpsReady => 'GPS Ready';

  @override
  String get gpsSearching => 'Searching for GPS…';

  @override
  String get gpsLowAccuracy => 'Low GPS accuracy';

  @override
  String get locationOff => 'Location is off';

  @override
  String get locationOffMessage => 'Turn on location to record your walk.';

  @override
  String get mapOffline => 'Map connection unavailable — your points are safe';

  @override
  String get emptyNoMeasurementsTitle => 'No measurements yet';

  @override
  String get emptyNoMeasurementsMessage =>
      'Measure your first piece of land and it will appear here.';

  @override
  String get languageSystem => 'System default';

  @override
  String get measureHintCrosshair =>
      'Move the map to place the crosshair, then tap Add Point.';

  @override
  String get measureHintTap => 'Tap the map to add points around the boundary.';

  @override
  String get toolbarUndo => 'Undo';

  @override
  String get toolbarAddPoint => 'Add Point';

  @override
  String get toolbarClose => 'Close shape';

  @override
  String get toolbarReset => 'Reset';

  @override
  String get toolbarAddAtMyLocation => 'Add point at my location';

  @override
  String get resultArea => 'Area';

  @override
  String get resultPerimeter => 'Perimeter';

  @override
  String get resultAreaNeedsPoints => 'Add at least 3 points to calculate area';

  @override
  String resultPointCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points',
      one: '1 point',
    );
    return '$_temp0';
  }

  @override
  String get edgesCross => 'Edges cross — area may be incorrect';

  @override
  String get menuMore => 'More options';

  @override
  String get menuInputCrosshair => 'Add with crosshair';

  @override
  String get menuInputTap => 'Add by tapping the map';

  @override
  String get menuShowEdgeLabels => 'Show edge lengths';

  @override
  String pointLabel(int number) {
    return 'Point $number';
  }

  @override
  String get pointDelete => 'Delete point';

  @override
  String get pointDeselect => 'Done';

  @override
  String gpsLowAccuracyAdded(int meters) {
    return 'GPS accuracy is low (±$meters m). The point was added anyway.';
  }

  @override
  String get locationUnavailable =>
      'Couldn\'t get your location. Try again outdoors.';

  @override
  String get locationPermissionDenied =>
      'Location access is off. You can still measure by moving the map.';

  @override
  String get locationServiceOff => 'Location is turned off on this device.';

  @override
  String get mapLayersTitle => 'Map type';

  @override
  String get mapStyleStandard => 'Standard';

  @override
  String get mapStyleSatellite => 'Satellite';

  @override
  String get mapStyleTerrain => 'Terrain';

  @override
  String get mapStyleHybrid => 'Hybrid';

  @override
  String get draftSaveFailed =>
      'Couldn\'t save your points. They will be saved again on the next change.';

  @override
  String get menuHelp => 'Help';

  @override
  String get actionGotIt => 'Got it';

  @override
  String get helpTitleArea => 'How to measure area';

  @override
  String get helpTitleDistance => 'How to measure distance';

  @override
  String get helpTitleWalk => 'How to walk & measure';

  @override
  String get helpAreaSummary => 'Add points around the boundary of your land.';

  @override
  String get helpDistanceSummary =>
      'Add points along the route you want to measure.';

  @override
  String get helpWalkSummary =>
      'Walk around the boundary while LandMeasure records your GPS path.';

  @override
  String get helpPhotoTip =>
      'Use photos to document landmarks, boundaries, or site conditions.';

  @override
  String get helpAccuracyNote =>
      'GPS and map measurement accuracy may vary depending on device, map imagery, and environment.';

  @override
  String get helpAreaStep1 =>
      'Move the map so the crosshair sits on a corner, then tap **Add Point**.';

  @override
  String get helpAreaStep2 =>
      'Add at least 3 points around the boundary. Drag a point to adjust it.';

  @override
  String get helpAreaStep3 =>
      'Tap **Close** to finish the shape, then **Save Measurement**.';

  @override
  String get helpDistanceStep1 =>
      'Place the crosshair on the start of your route and tap **Add Point**.';

  @override
  String get helpDistanceStep2 =>
      'Keep adding points along the route. Each segment length is shown on the map.';

  @override
  String get helpDistanceStep3 => 'Tap **Save Route** when you\'re done.';

  @override
  String get helpWalkStep1 =>
      'Wait for **GPS Ready**, then tap **Start Walking**.';

  @override
  String get helpWalkStep2 =>
      'Walk along the boundary. Use **Pause** if you need to stop.';

  @override
  String get helpWalkStep3 =>
      'Return to your starting point and tap **Finish** to calculate the area.';

  @override
  String get helpTipGpsPoint =>
      'Tip: tap 📍 to add a point at your current GPS location.';

  @override
  String get helpTipWalk => 'Tip: stay in open areas for better GPS accuracy.';

  @override
  String get resultDistance => 'Distance';

  @override
  String get resultDistanceNeedsPoints =>
      'Add at least 2 points to measure distance';

  @override
  String resultSegmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segments',
      one: '1 segment',
    );
    return '$_temp0';
  }

  @override
  String get segmentsTitle => 'Segments';

  @override
  String draftSavedSnack(int count, String type) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Draft saved · $type · $count points',
      one: 'Draft saved · $type · 1 point',
    );
    return '$_temp0';
  }

  @override
  String get searchHint => 'Address, coordinates or Google Maps link';

  @override
  String get searchAction => 'Search';

  @override
  String get searchRecent => 'Recent searches';

  @override
  String get searchNoResults =>
      'No places found. Try coordinates or a Google Maps link.';

  @override
  String get searchNeedsInternet =>
      'Searching an address needs an internet connection.';

  @override
  String get searchUnavailable =>
      'Address search isn\'t available on this device. Try coordinates or a Google Maps link.';

  @override
  String get searchClear => 'Clear';

  @override
  String get searchFailed =>
      'Couldn\'t search this address right now. Try coordinates or a Google Maps link.';

  @override
  String get ctaStartWalking => 'Start Walking';

  @override
  String get walkReadyHelper => 'Walk around the boundary to record your path.';

  @override
  String get keepScreenOn => 'Keep screen on';

  @override
  String get walkRecording => 'Recording GPS…';

  @override
  String get walkPaused => 'Paused';

  @override
  String get walkPausedMessage => 'Tap Resume to continue from where you are.';

  @override
  String gpsAccuracyShort(int meters) {
    return '±$meters m';
  }

  @override
  String gpsLowAccuracyMessage(int meters) {
    return 'Accuracy ±$meters m — points are not recorded until it improves. Move to an open area.';
  }

  @override
  String get locationDeniedTitle => 'Location access is off';

  @override
  String get locationDeniedMessage => 'Allow location to record your walk.';

  @override
  String get actionAllow => 'Allow';

  @override
  String get actionNotNow => 'Not now';

  @override
  String get mockLocationDetected =>
      'Mock location detected — those positions are not recorded.';

  @override
  String get walkCloseToStart => 'Close to start — finish to calculate area';

  @override
  String get walkNotClosed => 'Route not closed — distance only';

  @override
  String get walkKeepWalking => 'Walk back to your start to close the loop.';

  @override
  String get resultDuration => 'Duration';

  @override
  String get walkNotificationTitle =>
      'LandMeasure is recording your measurement';

  @override
  String get walkNotificationText => 'Tap to return to your walk.';

  @override
  String get walkNotificationChannel => 'Walk recording';

  @override
  String get walkRecordingBack =>
      'Recording in progress. Pause or finish before leaving.';

  @override
  String get walkPauseAndLeave => 'Pause & leave';

  @override
  String get walkStartFailed => 'Couldn\'t start recording. Try again.';

  @override
  String get batteryHintTitle => 'Allow LandMeasure to run in background';

  @override
  String get batteryHintMessage =>
      'Some phones stop apps when the screen is off. To keep recording your walk, open Settings → Battery and choose \"No restrictions\" (or \"Unrestricted\") for LandMeasure.';

  @override
  String get fabRecenter => 'Recenter';

  @override
  String get homeHeroSubtitle => 'Choose a method to measure your land.';

  @override
  String get homeContinueTitle => 'Continue Measurement';

  @override
  String get homeSeeAllDrafts => 'See all drafts';

  @override
  String get homeRecentTitle => 'Recent Measurements';

  @override
  String get homeRecentEmptyTitle => 'No recent measurements';

  @override
  String get homeRecentEmptyMessage => 'Saved measurements will appear here.';

  @override
  String get actionSeeAll => 'See All';

  @override
  String get untitledArea => 'Untitled Area';

  @override
  String get untitledDistance => 'Untitled Distance';

  @override
  String get untitledWalk => 'Untitled Walk';

  @override
  String get draftLabel => 'Draft';

  @override
  String get walkFinishedNotSaved => 'Finished · not saved';

  @override
  String lastEdited(String time) {
    return 'Last edited $time';
  }

  @override
  String get timeJustNow => 'just now';

  @override
  String timeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min ago',
      one: '1 min ago',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: 'yesterday',
    );
    return '$_temp0';
  }

  @override
  String get savedSearchHint => 'Search by name';

  @override
  String get savedSearchOpen => 'Search';

  @override
  String get savedSearchClose => 'Close search';

  @override
  String get filterAll => 'All';

  @override
  String filterWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String savedDraftsTitle(int count) {
    return 'Drafts ($count)';
  }

  @override
  String get savedNoResults => 'No measurements found.';

  @override
  String get menuRename => 'Rename';

  @override
  String get menuExport => 'Export';

  @override
  String get measurementDeleted => 'Measurement deleted';

  @override
  String get draftDiscarded => 'Draft discarded';

  @override
  String get exportTitle => 'Export';

  @override
  String get renameHint => 'Measurement name';

  @override
  String get saveNameLabel => 'Name';

  @override
  String get saveNameRequired => 'Name is required';

  @override
  String get saveNotesLabel => 'Notes';

  @override
  String get saveNotesHint => 'Boundaries, owner, landmarks… (optional)';

  @override
  String get saveTypeLabel => 'Type';

  @override
  String get saveFailed => 'Couldn\'t save. Please try again.';

  @override
  String get saveLimitReached =>
      'You\'ve reached the free limit of saved measurements. This one stays in your drafts.';

  @override
  String get saveNotFound => 'This measurement no longer exists.';

  @override
  String photosTitle(int count) {
    return 'Site Photos ($count)';
  }

  @override
  String get actionClose => 'Close';

  @override
  String get resultPoints => 'Points';

  @override
  String get resultSegments => 'Segments';

  @override
  String get resultAvgPace => 'Avg pace';

  @override
  String paceValue(String time, String unit) {
    return '$time /$unit';
  }

  @override
  String get notesTitle => 'Notes';

  @override
  String get notesEmpty => 'No notes';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionExport => 'Export';

  @override
  String get detailOpenMap => 'Open map';

  @override
  String savedOn(String date) {
    return 'Saved $date';
  }

  @override
  String get addPhotoTitle => 'Add Photo';

  @override
  String get addPhotoCamera => 'Take Photo';

  @override
  String get addPhotoGallery => 'Choose from Gallery';

  @override
  String addPhotoForPoint(int number) {
    return 'For point $number';
  }

  @override
  String get addPhotoTile => 'Add Photo';

  @override
  String get photoAddFailed => 'Couldn\'t add the photo. Please try again.';

  @override
  String get photoRemoved => 'Photo removed';

  @override
  String get actionUndo => 'Undo';

  @override
  String get photoLimitReached =>
      'You\'ve reached the free limit of photos for this measurement.';

  @override
  String get photoDeleteTitle => 'Delete photo?';

  @override
  String get photoDeleteMessage =>
      'This photo will be removed from the measurement.';

  @override
  String get photoAttachTitle => 'Attach this photo to measurement?';

  @override
  String get photoAttachMessage =>
      '\"Save Photos to Measurement\" is off in Settings.';

  @override
  String get actionAttach => 'Attach';

  @override
  String get photoWaitForStart => 'Start walking to add photos.';

  @override
  String photoCounter(int index, int total) {
    return '$index / $total';
  }

  @override
  String get photoShare => 'Share';

  @override
  String photoOpen(int number) {
    return 'Open photo $number';
  }

  @override
  String get photoRemove => 'Remove photo';

  @override
  String get pointPhoto => 'Photo';

  @override
  String get cameraPermissionTitle => 'Allow Camera Access';

  @override
  String get cameraPermissionMessage =>
      'Take photos of landmarks, boundaries and site conditions and keep them with your measurement.';

  @override
  String get cameraPermissionDenied =>
      'Camera access is off. You can turn it on in Settings.';

  @override
  String get actionContinue => 'Continue';

  @override
  String get notesEditTitle => 'Edit notes';

  @override
  String get notesAdd => 'Add notes';

  @override
  String get editTabResult => 'Result';

  @override
  String get editTabDetails => 'Details';

  @override
  String get ctaSaveChanges => 'Save Changes';

  @override
  String get dialogDiscardChangesMessage =>
      'Your changes to this measurement will be lost.';

  @override
  String get changesSaved => 'Changes saved';

  @override
  String get menuReopenShape => 'Reopen shape';

  @override
  String get exportKml => 'KML — Google Earth';

  @override
  String get exportKmlSubtitle =>
      'Shape and photo points for Google Earth and GIS apps';

  @override
  String get exportCsv => 'CSV — Excel';

  @override
  String get exportCsvSubtitle =>
      'Every point with coordinates, for spreadsheets';

  @override
  String get exportPreparing => 'Preparing file…';

  @override
  String get exportFailed => 'Couldn\'t export. Please try again.';

  @override
  String get exportLimitReached =>
      'Today\'s free KML export is used. CSV export stays free.';

  @override
  String get landValueTitle => 'Land value';

  @override
  String get landValueAdd => 'Add land value';

  @override
  String get landValueUnitPrice => 'Unit price';

  @override
  String get landValueUnit => 'Per';

  @override
  String landValueEstimated(String value) {
    return 'Estimated value ≈ $value';
  }

  @override
  String landValueRate(String price, String unit) {
    return '$price / $unit';
  }

  @override
  String get landValueNeedsArea =>
      'Land value needs an area (close the shape).';

  @override
  String get landValueRemove => 'Remove';

  @override
  String get landValueInvalid => 'Enter a price greater than 0';

  @override
  String get resultValue => 'Value';

  @override
  String get settingsSubtitle => 'Units, map and app preferences';

  @override
  String get settingsSectionPreferences => 'Measurement Preferences';

  @override
  String get settingsSectionMeasureMap => 'Measurement & Map';

  @override
  String get settingsSectionSupport => 'Support & Legal';

  @override
  String get settingsDefaultMode => 'Default Measurement Type';

  @override
  String get settingsDefaultModeHint =>
      'Selected on Home when you open the app.';

  @override
  String get settingsGpsAccuracy => 'GPS Accuracy Display';

  @override
  String get settingsGpsAccuracySubtitle =>
      'Show ±m and the accuracy circle while walking';

  @override
  String get settingsAutoCenter => 'Auto Center Map';

  @override
  String get settingsAutoCenterSubtitle =>
      'Open maps at your location and follow you while walking';

  @override
  String get settingsSavePhotos => 'Save Photos to Measurement';

  @override
  String get settingsSavePhotosSubtitle => 'Attach new photos without asking';

  @override
  String get settingsKeepAwake => 'Keep Screen Awake';

  @override
  String get settingsKeepAwakeSubtitle => 'Screen stays on while measuring';

  @override
  String get settingsHelpFeedback => 'Help & Feedback';

  @override
  String get settingsRateUs => 'Rate Us';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTerms => 'Terms of Use';

  @override
  String settingsVersion(String version, String build) {
    return 'Version $version ($build)';
  }

  @override
  String get feedbackSubject => 'LandMeasure feedback';

  @override
  String feedbackNoEmailApp(String email) {
    return 'No email app found. Write to us at $email.';
  }

  @override
  String get linkOpenFailed => 'Couldn\'t open the link. Please try again.';

  @override
  String get unitsDistanceTitle => 'Distance';

  @override
  String get unitsAreaTitle => 'Area';

  @override
  String get unitsSecondary => 'Show secondary unit';

  @override
  String unitsSecondaryExample(String example) {
    return 'e.g. $example';
  }

  @override
  String get unitsNote =>
      'New measurements use these units. Each measurement can also switch units from its result.';

  @override
  String get unitMeters => 'Meters';

  @override
  String get unitKilometers => 'Kilometers';

  @override
  String get unitFeet => 'Feet';

  @override
  String get unitMiles => 'Miles';

  @override
  String get unitSquareMeters => 'Square meters';

  @override
  String get unitHectares => 'Hectares';

  @override
  String get unitAcres => 'Acres';

  @override
  String get unitSquareFeet => 'Square feet';

  @override
  String get mapStyleNote =>
      'New measurements open with this map. You can switch any map with the Layers button.';

  @override
  String get actionApply => 'Apply';

  @override
  String get languageAppLanguages => 'App languages';

  @override
  String get languageMachineNote =>
      'This language was machine-translated and may contain mistakes.';

  @override
  String get locationPermissionTitle => 'Allow Location Access';

  @override
  String get locationPermissionMessage =>
      'LandMeasure uses your location to show where you are on the map. It stays on your phone.';

  @override
  String get locationPermissionMeasureMessage =>
      'Show where you are on the map and add points where you stand. Without it you can still measure by moving the map.';

  @override
  String get locationPermissionWalkMessage =>
      'Walk & Measure records your path with GPS while this screen is open. Your location stays on your phone.';

  @override
  String get locationPermissionBlocked =>
      'Location access is off for LandMeasure. Turn it on in Settings to use your position.';

  @override
  String get notificationPermissionTitle => 'Allow Notifications';

  @override
  String get notificationPermissionMessage =>
      'Allow notifications so you can see recording status while your screen is off.';

  @override
  String get actionRetry => 'Retry';

  @override
  String get paywallTitle => 'Measure without limits';

  @override
  String get paywallSubtitle =>
      'Unlock unlimited projects and premium features.';

  @override
  String get paywallBenefitNoAds => 'No ads';

  @override
  String get paywallBenefitSaves => 'Unlimited saved measurements';

  @override
  String get paywallBenefitPhotos => 'Unlimited photos per measurement';

  @override
  String get paywallBenefitKml => 'KML export any time';

  @override
  String paywallStartTrial(int days) {
    return 'Start $days-day free trial';
  }

  @override
  String paywallTermsTrial(int days, String price, String store) {
    return '$days days free, then $price/year. Renews automatically — cancel any time in $store.';
  }

  @override
  String paywallTermsYearly(String price, String store) {
    return '$price/year. Renews automatically — cancel any time in $store.';
  }

  @override
  String paywallTermsMonthly(String price, String store) {
    return '$price/month. Renews automatically — cancel any time in $store.';
  }

  @override
  String get paywallRestore => 'Restore purchases';

  @override
  String get paywallWelcome => 'Welcome to Premium!';

  @override
  String get paywallPending =>
      'Payment pending. Premium unlocks as soon as it completes.';

  @override
  String get paywallPurchaseFailed =>
      'The purchase didn\'t go through. You were not charged.';

  @override
  String get paywallRestored => 'Purchases restored.';

  @override
  String get paywallNothingToRestore =>
      'No previous purchase found for this store account.';

  @override
  String get paywallRestoreFailed =>
      'Couldn\'t restore purchases. Check your connection and try again.';

  @override
  String get paywallUnavailable =>
      'Plans can\'t be loaded right now. Check your connection and try again.';

  @override
  String get premiumActive => 'Premium active';

  @override
  String get premiumActiveLifetime => 'Premium active · Lifetime';

  @override
  String get premiumManage => 'Manage';

  @override
  String get settingsPremiumTitle => 'LandMeasure Premium';

  @override
  String get settingsPremiumSubtitle =>
      'No ads, unlimited saves and photos, KML any time';

  @override
  String get settingsManageSubscription => 'Manage subscription';

  @override
  String get settingsPrivacyChoices => 'Privacy choices';

  @override
  String get settingsAdInspector => 'Ad Inspector (dev)';

  @override
  String get exportUnlockTitle => 'Today\'s free KML export is used';

  @override
  String get exportUnlockMessage =>
      'Watch a short ad to export this file, or get Premium for unlimited KML exports. CSV export stays free.';

  @override
  String get exportWatchAd => 'Watch an ad';

  @override
  String get exportGetPremium => 'Get Premium';

  @override
  String get exportLoadingAd => 'Loading ad…';

  @override
  String get exportAdDismissed =>
      'Watch the ad to the end to unlock this export.';

  @override
  String get introNext => 'Next';

  @override
  String get introGetStarted => 'Get Started';

  @override
  String get introAreaTitle => 'Measure Area Easily';

  @override
  String get introAreaBody =>
      'Mark points on the map to measure land, fields and other areas in seconds.';

  @override
  String get introDistanceTitle => 'Measure Distance & Routes';

  @override
  String get introDistanceBody =>
      'Measure straight-line distances or track your route while walking outdoors.';

  @override
  String get introFieldTitle => 'Made for Real Field Work';

  @override
  String get introFieldBody =>
      'Measure farms, land plots, properties and outdoor sites with ease.';

  @override
  String paywallTrialTitle(int days) {
    return '$days-day free trial';
  }

  @override
  String paywallThenMonthly(String price) {
    return 'Then $price / month';
  }

  @override
  String get paywallMonthlyTitle => 'Monthly plan';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price / month';
  }

  @override
  String get paywallYearlyTitle => 'Yearly plan';

  @override
  String paywallYearlyOnly(String price) {
    return 'Only $price per year';
  }

  @override
  String get paywallBestPrice => 'Best price';

  @override
  String get paywallMostPopular => 'Most popular';

  @override
  String get paywallStartFreeTrial => 'Start free trial';

  @override
  String paywallTrialThenYearly(int days, String price) {
    return '$days-day free trial, then $price/year';
  }

  @override
  String paywallPricePerYear(String price) {
    return '$price/year';
  }

  @override
  String get paywallCancelAnytime => 'Cancel anytime';

  @override
  String paywallTermsTrialMonthly(int days, String price, String store) {
    return '$days days free, then $price/month. Renews automatically — cancel any time in $store.';
  }

  @override
  String get premiumPromptTitle => 'Go Premium';

  @override
  String premiumPromptPhotos(int count) {
    return 'You can add up to $count photos to a measurement for free. Upgrade to Premium to add more.';
  }

  @override
  String get premiumPromptUpgrade => 'Upgrade';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get languageChooseTitle => 'Choose your language';

  @override
  String premiumPromptMapStyleReward(String style) {
    return '$style maps are a Premium feature. Watch a short ad to use it until you close the app, or upgrade for good.';
  }

  @override
  String mapStyleUnlocked(String style) {
    return '$style map unlocked until you close the app.';
  }

  @override
  String get mapStyleAdDismissed =>
      'Watch the ad to the end to unlock this map.';

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
  String get exportPdf => 'PDF — Report';

  @override
  String get exportPdfSubtitle =>
      'Printable report with map, coordinates, notes and photos';

  @override
  String get projectLimitTitle => 'Free project limit reached';

  @override
  String get projectLimitMessage =>
      'You have 4 free projects. Watch a full ad to create one more project, or upgrade to Premium for unlimited projects.';

  @override
  String get projectRewardRequired =>
      'Finish watching an ad to unlock another project. If no ad is available, try again later or upgrade to Premium.';
}
