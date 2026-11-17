import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('th'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'LandMeasure'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navSaved;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get navSettings;

  /// No description provided for @measurementTypeArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get measurementTypeArea;

  /// No description provided for @measurementTypeDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get measurementTypeDistance;

  /// No description provided for @measurementTypeWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get measurementTypeWalk;

  /// No description provided for @screenMeasureArea.
  ///
  /// In en, this message translates to:
  /// **'Measure Area'**
  String get screenMeasureArea;

  /// No description provided for @screenMeasureDistance.
  ///
  /// In en, this message translates to:
  /// **'Measure Distance'**
  String get screenMeasureDistance;

  /// No description provided for @screenWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk & Measure'**
  String get screenWalk;

  /// No description provided for @screenSave.
  ///
  /// In en, this message translates to:
  /// **'Save Measurement'**
  String get screenSave;

  /// No description provided for @screenDetail.
  ///
  /// In en, this message translates to:
  /// **'Measurement Detail'**
  String get screenDetail;

  /// No description provided for @screenFullMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get screenFullMap;

  /// No description provided for @screenEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Measurement'**
  String get screenEdit;

  /// No description provided for @screenSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved Measurements'**
  String get screenSaved;

  /// No description provided for @screenSettings.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get screenSettings;

  /// No description provided for @screenUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get screenUnits;

  /// No description provided for @screenMapStyle.
  ///
  /// In en, this message translates to:
  /// **'Map Style'**
  String get screenMapStyle;

  /// No description provided for @screenLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get screenLanguage;

  /// No description provided for @screenPaywall.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get screenPaywall;

  /// No description provided for @ctaStartMeasuring.
  ///
  /// In en, this message translates to:
  /// **'Start Measuring'**
  String get ctaStartMeasuring;

  /// No description provided for @ctaStartArea.
  ///
  /// In en, this message translates to:
  /// **'Start Area Survey'**
  String get ctaStartArea;

  /// No description provided for @ctaStartDistance.
  ///
  /// In en, this message translates to:
  /// **'Start Distance Measure'**
  String get ctaStartDistance;

  /// No description provided for @ctaStartWalk.
  ///
  /// In en, this message translates to:
  /// **'Start Walk Measure'**
  String get ctaStartWalk;

  /// No description provided for @ctaSaveMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Save Measurement'**
  String get ctaSaveMeasurement;

  /// No description provided for @ctaSaveRoute.
  ///
  /// In en, this message translates to:
  /// **'Save Route'**
  String get ctaSaveRoute;

  /// No description provided for @ctaPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get ctaPause;

  /// No description provided for @ctaResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get ctaResume;

  /// No description provided for @ctaFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get ctaFinish;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get actionDiscard;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get actionReset;

  /// No description provided for @actionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get actionOpenSettings;

  /// No description provided for @actionKeepRecording.
  ///
  /// In en, this message translates to:
  /// **'Keep recording'**
  String get actionKeepRecording;

  /// No description provided for @actionKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get actionKeepEditing;

  /// No description provided for @dialogResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset measurement?'**
  String get dialogResetTitle;

  /// No description provided for @dialogResetMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove all points.'**
  String get dialogResetMessage;

  /// No description provided for @dialogDiscardDraftTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard this draft?'**
  String get dialogDiscardDraftTitle;

  /// No description provided for @dialogDiscardDraftMessage.
  ///
  /// In en, this message translates to:
  /// **'All points and unsaved changes will be removed.'**
  String get dialogDiscardDraftMessage;

  /// No description provided for @dialogDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete measurement?'**
  String get dialogDeleteTitle;

  /// No description provided for @dialogDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This measurement, its photos and notes will be permanently deleted.'**
  String get dialogDeleteMessage;

  /// No description provided for @dialogFinishWalkTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish recording?'**
  String get dialogFinishWalkTitle;

  /// No description provided for @dialogFinishWalkMessage.
  ///
  /// In en, this message translates to:
  /// **'GPS tracking will stop.'**
  String get dialogFinishWalkMessage;

  /// No description provided for @dialogRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Measurement'**
  String get dialogRenameTitle;

  /// No description provided for @dialogDiscardChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get dialogDiscardChangesTitle;

  /// No description provided for @fabLayers.
  ///
  /// In en, this message translates to:
  /// **'Map layers'**
  String get fabLayers;

  /// No description provided for @fabMyLocation.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get fabMyLocation;

  /// No description provided for @fabSearch.
  ///
  /// In en, this message translates to:
  /// **'Search place'**
  String get fabSearch;

  /// No description provided for @fabCamera.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get fabCamera;

  /// No description provided for @gpsReady.
  ///
  /// In en, this message translates to:
  /// **'GPS Ready'**
  String get gpsReady;

  /// No description provided for @gpsSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching for GPS…'**
  String get gpsSearching;

  /// No description provided for @gpsLowAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Low GPS accuracy'**
  String get gpsLowAccuracy;

  /// No description provided for @locationOff.
  ///
  /// In en, this message translates to:
  /// **'Location is off'**
  String get locationOff;

  /// No description provided for @locationOffMessage.
  ///
  /// In en, this message translates to:
  /// **'Turn on location to record your walk.'**
  String get locationOffMessage;

  /// No description provided for @mapOffline.
  ///
  /// In en, this message translates to:
  /// **'Map connection unavailable — your points are safe'**
  String get mapOffline;

  /// No description provided for @emptyNoMeasurementsTitle.
  ///
  /// In en, this message translates to:
  /// **'No measurements yet'**
  String get emptyNoMeasurementsTitle;

  /// No description provided for @emptyNoMeasurementsMessage.
  ///
  /// In en, this message translates to:
  /// **'Measure your first piece of land and it will appear here.'**
  String get emptyNoMeasurementsMessage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @measureHintCrosshair.
  ///
  /// In en, this message translates to:
  /// **'Move the map to place the crosshair, then tap Add Point.'**
  String get measureHintCrosshair;

  /// No description provided for @measureHintTap.
  ///
  /// In en, this message translates to:
  /// **'Tap the map to add points around the boundary.'**
  String get measureHintTap;

  /// No description provided for @toolbarUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get toolbarUndo;

  /// No description provided for @toolbarAddPoint.
  ///
  /// In en, this message translates to:
  /// **'Add Point'**
  String get toolbarAddPoint;

  /// No description provided for @toolbarClose.
  ///
  /// In en, this message translates to:
  /// **'Close shape'**
  String get toolbarClose;

  /// No description provided for @toolbarReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get toolbarReset;

  /// No description provided for @toolbarAddAtMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Add point at my location'**
  String get toolbarAddAtMyLocation;

  /// No description provided for @resultArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get resultArea;

  /// No description provided for @resultPerimeter.
  ///
  /// In en, this message translates to:
  /// **'Perimeter'**
  String get resultPerimeter;

  /// No description provided for @resultAreaNeedsPoints.
  ///
  /// In en, this message translates to:
  /// **'Add at least 3 points to calculate area'**
  String get resultAreaNeedsPoints;

  /// No description provided for @resultPointCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 point} other{{count} points}}'**
  String resultPointCount(int count);

  /// No description provided for @edgesCross.
  ///
  /// In en, this message translates to:
  /// **'Edges cross — area may be incorrect'**
  String get edgesCross;

  /// No description provided for @menuMore.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get menuMore;

  /// No description provided for @menuInputCrosshair.
  ///
  /// In en, this message translates to:
  /// **'Add with crosshair'**
  String get menuInputCrosshair;

  /// No description provided for @menuInputTap.
  ///
  /// In en, this message translates to:
  /// **'Add by tapping the map'**
  String get menuInputTap;

  /// No description provided for @menuShowEdgeLabels.
  ///
  /// In en, this message translates to:
  /// **'Show edge lengths'**
  String get menuShowEdgeLabels;

  /// No description provided for @pointLabel.
  ///
  /// In en, this message translates to:
  /// **'Point {number}'**
  String pointLabel(int number);

  /// No description provided for @pointDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete point'**
  String get pointDelete;

  /// No description provided for @pointDeselect.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get pointDeselect;

  /// No description provided for @gpsLowAccuracyAdded.
  ///
  /// In en, this message translates to:
  /// **'GPS accuracy is low (±{meters} m). The point was added anyway.'**
  String gpsLowAccuracyAdded(int meters);

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get your location. Try again outdoors.'**
  String get locationUnavailable;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location access is off. You can still measure by moving the map.'**
  String get locationPermissionDenied;

  /// No description provided for @locationServiceOff.
  ///
  /// In en, this message translates to:
  /// **'Location is turned off on this device.'**
  String get locationServiceOff;

  /// No description provided for @mapLayersTitle.
  ///
  /// In en, this message translates to:
  /// **'Map type'**
  String get mapLayersTitle;

  /// No description provided for @mapStyleStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get mapStyleStandard;

  /// No description provided for @mapStyleSatellite.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get mapStyleSatellite;

  /// No description provided for @mapStyleTerrain.
  ///
  /// In en, this message translates to:
  /// **'Terrain'**
  String get mapStyleTerrain;

  /// No description provided for @mapStyleHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get mapStyleHybrid;

  /// No description provided for @draftSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your points. They will be saved again on the next change.'**
  String get draftSaveFailed;

  /// No description provided for @menuHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get menuHelp;

  /// No description provided for @actionGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get actionGotIt;

  /// No description provided for @helpTitleArea.
  ///
  /// In en, this message translates to:
  /// **'How to measure area'**
  String get helpTitleArea;

  /// No description provided for @helpTitleDistance.
  ///
  /// In en, this message translates to:
  /// **'How to measure distance'**
  String get helpTitleDistance;

  /// No description provided for @helpTitleWalk.
  ///
  /// In en, this message translates to:
  /// **'How to walk & measure'**
  String get helpTitleWalk;

  /// No description provided for @helpAreaSummary.
  ///
  /// In en, this message translates to:
  /// **'Add points around the boundary of your land.'**
  String get helpAreaSummary;

  /// No description provided for @helpDistanceSummary.
  ///
  /// In en, this message translates to:
  /// **'Add points along the route you want to measure.'**
  String get helpDistanceSummary;

  /// No description provided for @helpWalkSummary.
  ///
  /// In en, this message translates to:
  /// **'Walk around the boundary while LandMeasure records your GPS path.'**
  String get helpWalkSummary;

  /// No description provided for @helpPhotoTip.
  ///
  /// In en, this message translates to:
  /// **'Use photos to document landmarks, boundaries, or site conditions.'**
  String get helpPhotoTip;

  /// No description provided for @helpAccuracyNote.
  ///
  /// In en, this message translates to:
  /// **'GPS and map measurement accuracy may vary depending on device, map imagery, and environment.'**
  String get helpAccuracyNote;

  /// No description provided for @helpAreaStep1.
  ///
  /// In en, this message translates to:
  /// **'Move the map so the crosshair sits on a corner, then tap **Add Point**.'**
  String get helpAreaStep1;

  /// No description provided for @helpAreaStep2.
  ///
  /// In en, this message translates to:
  /// **'Add at least 3 points around the boundary. Drag a point to adjust it.'**
  String get helpAreaStep2;

  /// No description provided for @helpAreaStep3.
  ///
  /// In en, this message translates to:
  /// **'Tap **Close** to finish the shape, then **Save Measurement**.'**
  String get helpAreaStep3;

  /// No description provided for @helpDistanceStep1.
  ///
  /// In en, this message translates to:
  /// **'Place the crosshair on the start of your route and tap **Add Point**.'**
  String get helpDistanceStep1;

  /// No description provided for @helpDistanceStep2.
  ///
  /// In en, this message translates to:
  /// **'Keep adding points along the route. Each segment length is shown on the map.'**
  String get helpDistanceStep2;

  /// No description provided for @helpDistanceStep3.
  ///
  /// In en, this message translates to:
  /// **'Tap **Save Route** when you\'re done.'**
  String get helpDistanceStep3;

  /// No description provided for @helpWalkStep1.
  ///
  /// In en, this message translates to:
  /// **'Wait for **GPS Ready**, then tap **Start Walking**.'**
  String get helpWalkStep1;

  /// No description provided for @helpWalkStep2.
  ///
  /// In en, this message translates to:
  /// **'Walk along the boundary. Use **Pause** if you need to stop.'**
  String get helpWalkStep2;

  /// No description provided for @helpWalkStep3.
  ///
  /// In en, this message translates to:
  /// **'Return to your starting point and tap **Finish** to calculate the area.'**
  String get helpWalkStep3;

  /// No description provided for @helpTipGpsPoint.
  ///
  /// In en, this message translates to:
  /// **'Tip: tap 📍 to add a point at your current GPS location.'**
  String get helpTipGpsPoint;

  /// No description provided for @helpTipWalk.
  ///
  /// In en, this message translates to:
  /// **'Tip: stay in open areas for better GPS accuracy.'**
  String get helpTipWalk;

  /// No description provided for @resultDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get resultDistance;

  /// No description provided for @resultDistanceNeedsPoints.
  ///
  /// In en, this message translates to:
  /// **'Add at least 2 points to measure distance'**
  String get resultDistanceNeedsPoints;

  /// No description provided for @resultSegmentCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 segment} other{{count} segments}}'**
  String resultSegmentCount(int count);

  /// No description provided for @segmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Segments'**
  String get segmentsTitle;

  /// No description provided for @draftSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Draft saved · {type} · 1 point} other{Draft saved · {type} · {count} points}}'**
  String draftSavedSnack(int count, String type);

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Address, coordinates or Google Maps link'**
  String get searchHint;

  /// No description provided for @searchAction.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchAction;

  /// No description provided for @searchRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get searchRecent;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No places found. Try coordinates or a Google Maps link.'**
  String get searchNoResults;

  /// No description provided for @searchNeedsInternet.
  ///
  /// In en, this message translates to:
  /// **'Searching an address needs an internet connection.'**
  String get searchNeedsInternet;

  /// No description provided for @searchUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Address search isn\'t available on this device. Try coordinates or a Google Maps link.'**
  String get searchUnavailable;

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClear;

  /// No description provided for @searchFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t search this address right now. Try coordinates or a Google Maps link.'**
  String get searchFailed;

  /// No description provided for @ctaStartWalking.
  ///
  /// In en, this message translates to:
  /// **'Start Walking'**
  String get ctaStartWalking;

  /// No description provided for @walkReadyHelper.
  ///
  /// In en, this message translates to:
  /// **'Walk around the boundary to record your path.'**
  String get walkReadyHelper;

  /// No description provided for @keepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Keep screen on'**
  String get keepScreenOn;

  /// No description provided for @walkRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording GPS…'**
  String get walkRecording;

  /// No description provided for @walkPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get walkPaused;

  /// No description provided for @walkPausedMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap Resume to continue from where you are.'**
  String get walkPausedMessage;

  /// No description provided for @gpsAccuracyShort.
  ///
  /// In en, this message translates to:
  /// **'±{meters} m'**
  String gpsAccuracyShort(int meters);

  /// No description provided for @gpsLowAccuracyMessage.
  ///
  /// In en, this message translates to:
  /// **'Accuracy ±{meters} m — points are not recorded until it improves. Move to an open area.'**
  String gpsLowAccuracyMessage(int meters);

  /// No description provided for @locationDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Location access is off'**
  String get locationDeniedTitle;

  /// No description provided for @locationDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Allow location to record your walk.'**
  String get locationDeniedMessage;

  /// No description provided for @actionAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get actionAllow;

  /// No description provided for @actionNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get actionNotNow;

  /// No description provided for @mockLocationDetected.
  ///
  /// In en, this message translates to:
  /// **'Mock location detected — those positions are not recorded.'**
  String get mockLocationDetected;

  /// No description provided for @walkCloseToStart.
  ///
  /// In en, this message translates to:
  /// **'Close to start — finish to calculate area'**
  String get walkCloseToStart;

  /// No description provided for @walkNotClosed.
  ///
  /// In en, this message translates to:
  /// **'Route not closed — distance only'**
  String get walkNotClosed;

  /// No description provided for @walkKeepWalking.
  ///
  /// In en, this message translates to:
  /// **'Walk back to your start to close the loop.'**
  String get walkKeepWalking;

  /// No description provided for @resultDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get resultDuration;

  /// No description provided for @walkNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'LandMeasure is recording your measurement'**
  String get walkNotificationTitle;

  /// No description provided for @walkNotificationText.
  ///
  /// In en, this message translates to:
  /// **'Tap to return to your walk.'**
  String get walkNotificationText;

  /// No description provided for @walkNotificationChannel.
  ///
  /// In en, this message translates to:
  /// **'Walk recording'**
  String get walkNotificationChannel;

  /// No description provided for @walkRecordingBack.
  ///
  /// In en, this message translates to:
  /// **'Recording in progress. Pause or finish before leaving.'**
  String get walkRecordingBack;

  /// No description provided for @walkPauseAndLeave.
  ///
  /// In en, this message translates to:
  /// **'Pause & leave'**
  String get walkPauseAndLeave;

  /// No description provided for @walkStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start recording. Try again.'**
  String get walkStartFailed;

  /// No description provided for @batteryHintTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow LandMeasure to run in background'**
  String get batteryHintTitle;

  /// No description provided for @batteryHintMessage.
  ///
  /// In en, this message translates to:
  /// **'Some phones stop apps when the screen is off. To keep recording your walk, open Settings → Battery and choose \"No restrictions\" (or \"Unrestricted\") for LandMeasure.'**
  String get batteryHintMessage;

  /// No description provided for @fabRecenter.
  ///
  /// In en, this message translates to:
  /// **'Recenter'**
  String get fabRecenter;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a method to measure your land.'**
  String get homeHeroSubtitle;

  /// No description provided for @homeContinueTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue Measurement'**
  String get homeContinueTitle;

  /// No description provided for @homeSeeAllDrafts.
  ///
  /// In en, this message translates to:
  /// **'See all drafts'**
  String get homeSeeAllDrafts;

  /// No description provided for @homeRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Measurements'**
  String get homeRecentTitle;

  /// No description provided for @homeRecentEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No recent measurements'**
  String get homeRecentEmptyTitle;

  /// No description provided for @homeRecentEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Saved measurements will appear here.'**
  String get homeRecentEmptyMessage;

  /// No description provided for @actionSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get actionSeeAll;

  /// No description provided for @untitledArea.
  ///
  /// In en, this message translates to:
  /// **'Untitled Area'**
  String get untitledArea;

  /// No description provided for @untitledDistance.
  ///
  /// In en, this message translates to:
  /// **'Untitled Distance'**
  String get untitledDistance;

  /// No description provided for @untitledWalk.
  ///
  /// In en, this message translates to:
  /// **'Untitled Walk'**
  String get untitledWalk;

  /// No description provided for @draftLabel.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draftLabel;

  /// No description provided for @walkFinishedNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Finished · not saved'**
  String get walkFinishedNotSaved;

  /// No description provided for @lastEdited.
  ///
  /// In en, this message translates to:
  /// **'Last edited {time}'**
  String lastEdited(String time);

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 min ago} other{{count} min ago}}'**
  String timeMinutesAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String timeHoursAgo(int count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{yesterday} other{{count} days ago}}'**
  String timeDaysAgo(int count);

  /// No description provided for @savedSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get savedSearchHint;

  /// No description provided for @savedSearchOpen.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get savedSearchOpen;

  /// No description provided for @savedSearchClose.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get savedSearchClose;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterWithCount.
  ///
  /// In en, this message translates to:
  /// **'{label} ({count})'**
  String filterWithCount(String label, int count);

  /// No description provided for @savedDraftsTitle.
  ///
  /// In en, this message translates to:
  /// **'Drafts ({count})'**
  String savedDraftsTitle(int count);

  /// No description provided for @savedNoResults.
  ///
  /// In en, this message translates to:
  /// **'No measurements found.'**
  String get savedNoResults;

  /// No description provided for @menuRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get menuRename;

  /// No description provided for @menuExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get menuExport;

  /// No description provided for @measurementDeleted.
  ///
  /// In en, this message translates to:
  /// **'Measurement deleted'**
  String get measurementDeleted;

  /// No description provided for @draftDiscarded.
  ///
  /// In en, this message translates to:
  /// **'Draft discarded'**
  String get draftDiscarded;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportTitle;

  /// No description provided for @renameHint.
  ///
  /// In en, this message translates to:
  /// **'Measurement name'**
  String get renameHint;

  /// No description provided for @saveNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get saveNameLabel;

  /// No description provided for @saveNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get saveNameRequired;

  /// No description provided for @saveNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get saveNotesLabel;

  /// No description provided for @saveNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Boundaries, owner, landmarks… (optional)'**
  String get saveNotesHint;

  /// No description provided for @saveTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get saveTypeLabel;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Please try again.'**
  String get saveFailed;

  /// No description provided for @saveLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the free limit of saved measurements. This one stays in your drafts.'**
  String get saveLimitReached;

  /// No description provided for @saveNotFound.
  ///
  /// In en, this message translates to:
  /// **'This measurement no longer exists.'**
  String get saveNotFound;

  /// No description provided for @photosTitle.
  ///
  /// In en, this message translates to:
  /// **'Site Photos ({count})'**
  String photosTitle(int count);

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @resultPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get resultPoints;

  /// No description provided for @resultSegments.
  ///
  /// In en, this message translates to:
  /// **'Segments'**
  String get resultSegments;

  /// No description provided for @resultAvgPace.
  ///
  /// In en, this message translates to:
  /// **'Avg pace'**
  String get resultAvgPace;

  /// No description provided for @paceValue.
  ///
  /// In en, this message translates to:
  /// **'{time} /{unit}'**
  String paceValue(String time, String unit);

  /// No description provided for @notesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesTitle;

  /// No description provided for @notesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notes'**
  String get notesEmpty;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get actionExport;

  /// No description provided for @detailOpenMap.
  ///
  /// In en, this message translates to:
  /// **'Open map'**
  String get detailOpenMap;

  /// No description provided for @savedOn.
  ///
  /// In en, this message translates to:
  /// **'Saved {date}'**
  String savedOn(String date);

  /// No description provided for @addPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhotoTitle;

  /// No description provided for @addPhotoCamera.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get addPhotoCamera;

  /// No description provided for @addPhotoGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get addPhotoGallery;

  /// No description provided for @addPhotoForPoint.
  ///
  /// In en, this message translates to:
  /// **'For point {number}'**
  String addPhotoForPoint(int number);

  /// No description provided for @addPhotoTile.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhotoTile;

  /// No description provided for @photoAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add the photo. Please try again.'**
  String get photoAddFailed;

  /// No description provided for @photoRemoved.
  ///
  /// In en, this message translates to:
  /// **'Photo removed'**
  String get photoRemoved;

  /// No description provided for @actionUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// No description provided for @photoLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the free limit of photos for this measurement.'**
  String get photoLimitReached;

  /// No description provided for @photoDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete photo?'**
  String get photoDeleteTitle;

  /// No description provided for @photoDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This photo will be removed from the measurement.'**
  String get photoDeleteMessage;

  /// No description provided for @photoAttachTitle.
  ///
  /// In en, this message translates to:
  /// **'Attach this photo to measurement?'**
  String get photoAttachTitle;

  /// No description provided for @photoAttachMessage.
  ///
  /// In en, this message translates to:
  /// **'\"Save Photos to Measurement\" is off in Settings.'**
  String get photoAttachMessage;

  /// No description provided for @actionAttach.
  ///
  /// In en, this message translates to:
  /// **'Attach'**
  String get actionAttach;

  /// No description provided for @photoWaitForStart.
  ///
  /// In en, this message translates to:
  /// **'Start walking to add photos.'**
  String get photoWaitForStart;

  /// No description provided for @photoCounter.
  ///
  /// In en, this message translates to:
  /// **'{index} / {total}'**
  String photoCounter(int index, int total);

  /// No description provided for @photoShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get photoShare;

  /// No description provided for @photoOpen.
  ///
  /// In en, this message translates to:
  /// **'Open photo {number}'**
  String photoOpen(int number);

  /// No description provided for @photoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get photoRemove;

  /// No description provided for @pointPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get pointPhoto;

  /// No description provided for @cameraPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow Camera Access'**
  String get cameraPermissionTitle;

  /// No description provided for @cameraPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Take photos of landmarks, boundaries and site conditions and keep them with your measurement.'**
  String get cameraPermissionMessage;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera access is off. You can turn it on in Settings.'**
  String get cameraPermissionDenied;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @notesEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit notes'**
  String get notesEditTitle;

  /// No description provided for @notesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add notes'**
  String get notesAdd;

  /// No description provided for @editTabResult.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get editTabResult;

  /// No description provided for @editTabDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get editTabDetails;

  /// No description provided for @ctaSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get ctaSaveChanges;

  /// No description provided for @dialogDiscardChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'Your changes to this measurement will be lost.'**
  String get dialogDiscardChangesMessage;

  /// No description provided for @changesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get changesSaved;

  /// No description provided for @menuReopenShape.
  ///
  /// In en, this message translates to:
  /// **'Reopen shape'**
  String get menuReopenShape;

  /// No description provided for @exportKml.
  ///
  /// In en, this message translates to:
  /// **'KML — Google Earth'**
  String get exportKml;

  /// No description provided for @exportKmlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shape and photo points for Google Earth and GIS apps'**
  String get exportKmlSubtitle;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'CSV — Excel'**
  String get exportCsv;

  /// No description provided for @exportCsvSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every point with coordinates, for spreadsheets'**
  String get exportCsvSubtitle;

  /// No description provided for @exportPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing file…'**
  String get exportPreparing;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t export. Please try again.'**
  String get exportFailed;

  /// No description provided for @exportLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Today\'s free KML export is used. CSV export stays free.'**
  String get exportLimitReached;

  /// No description provided for @landValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Land value'**
  String get landValueTitle;

  /// No description provided for @landValueAdd.
  ///
  /// In en, this message translates to:
  /// **'Add land value'**
  String get landValueAdd;

  /// No description provided for @landValueUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get landValueUnitPrice;

  /// No description provided for @landValueUnit.
  ///
  /// In en, this message translates to:
  /// **'Per'**
  String get landValueUnit;

  /// No description provided for @landValueEstimated.
  ///
  /// In en, this message translates to:
  /// **'Estimated value ≈ {value}'**
  String landValueEstimated(String value);

  /// No description provided for @landValueRate.
  ///
  /// In en, this message translates to:
  /// **'{price} / {unit}'**
  String landValueRate(String price, String unit);

  /// No description provided for @landValueNeedsArea.
  ///
  /// In en, this message translates to:
  /// **'Land value needs an area (close the shape).'**
  String get landValueNeedsArea;

  /// No description provided for @landValueRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get landValueRemove;

  /// No description provided for @landValueInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a price greater than 0'**
  String get landValueInvalid;

  /// No description provided for @resultValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get resultValue;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Units, map and app preferences'**
  String get settingsSubtitle;

  /// No description provided for @settingsSectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Measurement Preferences'**
  String get settingsSectionPreferences;

  /// No description provided for @settingsSectionMeasureMap.
  ///
  /// In en, this message translates to:
  /// **'Measurement & Map'**
  String get settingsSectionMeasureMap;

  /// No description provided for @settingsSectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support & Legal'**
  String get settingsSectionSupport;

  /// No description provided for @settingsDefaultMode.
  ///
  /// In en, this message translates to:
  /// **'Default Measurement Type'**
  String get settingsDefaultMode;

  /// No description provided for @settingsDefaultModeHint.
  ///
  /// In en, this message translates to:
  /// **'Selected on Home when you open the app.'**
  String get settingsDefaultModeHint;

  /// No description provided for @settingsGpsAccuracy.
  ///
  /// In en, this message translates to:
  /// **'GPS Accuracy Display'**
  String get settingsGpsAccuracy;

  /// No description provided for @settingsGpsAccuracySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show ±m and the accuracy circle while walking'**
  String get settingsGpsAccuracySubtitle;

  /// No description provided for @settingsAutoCenter.
  ///
  /// In en, this message translates to:
  /// **'Auto Center Map'**
  String get settingsAutoCenter;

  /// No description provided for @settingsAutoCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open maps at your location and follow you while walking'**
  String get settingsAutoCenterSubtitle;

  /// No description provided for @settingsSavePhotos.
  ///
  /// In en, this message translates to:
  /// **'Save Photos to Measurement'**
  String get settingsSavePhotos;

  /// No description provided for @settingsSavePhotosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Attach new photos without asking'**
  String get settingsSavePhotosSubtitle;

  /// No description provided for @settingsKeepAwake.
  ///
  /// In en, this message translates to:
  /// **'Keep Screen Awake'**
  String get settingsKeepAwake;

  /// No description provided for @settingsKeepAwakeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Screen stays on while measuring'**
  String get settingsKeepAwakeSubtitle;

  /// No description provided for @settingsHelpFeedback.
  ///
  /// In en, this message translates to:
  /// **'Help & Feedback'**
  String get settingsHelpFeedback;

  /// No description provided for @settingsRateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get settingsRateUs;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get settingsTerms;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version} ({build})'**
  String settingsVersion(String version, String build);

  /// No description provided for @feedbackSubject.
  ///
  /// In en, this message translates to:
  /// **'LandMeasure feedback'**
  String get feedbackSubject;

  /// No description provided for @feedbackNoEmailApp.
  ///
  /// In en, this message translates to:
  /// **'No email app found. Write to us at {email}.'**
  String feedbackNoEmailApp(String email);

  /// No description provided for @linkOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the link. Please try again.'**
  String get linkOpenFailed;

  /// No description provided for @unitsDistanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get unitsDistanceTitle;

  /// No description provided for @unitsAreaTitle.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get unitsAreaTitle;

  /// No description provided for @unitsSecondary.
  ///
  /// In en, this message translates to:
  /// **'Show secondary unit'**
  String get unitsSecondary;

  /// No description provided for @unitsSecondaryExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. {example}'**
  String unitsSecondaryExample(String example);

  /// No description provided for @unitsNote.
  ///
  /// In en, this message translates to:
  /// **'New measurements use these units. Each measurement can also switch units from its result.'**
  String get unitsNote;

  /// No description provided for @unitMeters.
  ///
  /// In en, this message translates to:
  /// **'Meters'**
  String get unitMeters;

  /// No description provided for @unitKilometers.
  ///
  /// In en, this message translates to:
  /// **'Kilometers'**
  String get unitKilometers;

  /// No description provided for @unitFeet.
  ///
  /// In en, this message translates to:
  /// **'Feet'**
  String get unitFeet;

  /// No description provided for @unitMiles.
  ///
  /// In en, this message translates to:
  /// **'Miles'**
  String get unitMiles;

  /// No description provided for @unitSquareMeters.
  ///
  /// In en, this message translates to:
  /// **'Square meters'**
  String get unitSquareMeters;

  /// No description provided for @unitHectares.
  ///
  /// In en, this message translates to:
  /// **'Hectares'**
  String get unitHectares;

  /// No description provided for @unitAcres.
  ///
  /// In en, this message translates to:
  /// **'Acres'**
  String get unitAcres;

  /// No description provided for @unitSquareFeet.
  ///
  /// In en, this message translates to:
  /// **'Square feet'**
  String get unitSquareFeet;

  /// No description provided for @mapStyleNote.
  ///
  /// In en, this message translates to:
  /// **'New measurements open with this map. You can switch any map with the Layers button.'**
  String get mapStyleNote;

  /// No description provided for @actionApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get actionApply;

  /// No description provided for @languageAppLanguages.
  ///
  /// In en, this message translates to:
  /// **'App languages'**
  String get languageAppLanguages;

  /// No description provided for @languageMachineNote.
  ///
  /// In en, this message translates to:
  /// **'This language was machine-translated and may contain mistakes.'**
  String get languageMachineNote;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow Location Access'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'LandMeasure uses your location to show where you are on the map. It stays on your phone.'**
  String get locationPermissionMessage;

  /// No description provided for @locationPermissionMeasureMessage.
  ///
  /// In en, this message translates to:
  /// **'Show where you are on the map and add points where you stand. Without it you can still measure by moving the map.'**
  String get locationPermissionMeasureMessage;

  /// No description provided for @locationPermissionWalkMessage.
  ///
  /// In en, this message translates to:
  /// **'Walk & Measure records your path with GPS while this screen is open. Your location stays on your phone.'**
  String get locationPermissionWalkMessage;

  /// No description provided for @locationPermissionBlocked.
  ///
  /// In en, this message translates to:
  /// **'Location access is off for LandMeasure. Turn it on in Settings to use your position.'**
  String get locationPermissionBlocked;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow Notifications'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications so you can see recording status while your screen is off.'**
  String get notificationPermissionMessage;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Measure without limits'**
  String get paywallTitle;

  /// No description provided for @paywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited projects and premium features.'**
  String get paywallSubtitle;

  /// No description provided for @paywallBenefitNoAds.
  ///
  /// In en, this message translates to:
  /// **'No ads'**
  String get paywallBenefitNoAds;

  /// No description provided for @paywallBenefitSaves.
  ///
  /// In en, this message translates to:
  /// **'Unlimited saved measurements'**
  String get paywallBenefitSaves;

  /// No description provided for @paywallBenefitPhotos.
  ///
  /// In en, this message translates to:
  /// **'Unlimited photos per measurement'**
  String get paywallBenefitPhotos;

  /// No description provided for @paywallBenefitKml.
  ///
  /// In en, this message translates to:
  /// **'KML export any time'**
  String get paywallBenefitKml;

  /// No description provided for @paywallStartTrial.
  ///
  /// In en, this message translates to:
  /// **'Start {days}-day free trial'**
  String paywallStartTrial(int days);

  /// No description provided for @paywallTermsTrial.
  ///
  /// In en, this message translates to:
  /// **'{days} days free, then {price}/year. Renews automatically — cancel any time in {store}.'**
  String paywallTermsTrial(int days, String price, String store);

  /// No description provided for @paywallTermsYearly.
  ///
  /// In en, this message translates to:
  /// **'{price}/year. Renews automatically — cancel any time in {store}.'**
  String paywallTermsYearly(String price, String store);

  /// No description provided for @paywallTermsMonthly.
  ///
  /// In en, this message translates to:
  /// **'{price}/month. Renews automatically — cancel any time in {store}.'**
  String paywallTermsMonthly(String price, String store);

  /// No description provided for @paywallRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get paywallRestore;

  /// No description provided for @paywallWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Premium!'**
  String get paywallWelcome;

  /// No description provided for @paywallPending.
  ///
  /// In en, this message translates to:
  /// **'Payment pending. Premium unlocks as soon as it completes.'**
  String get paywallPending;

  /// No description provided for @paywallPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'The purchase didn\'t go through. You were not charged.'**
  String get paywallPurchaseFailed;

  /// No description provided for @paywallRestored.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored.'**
  String get paywallRestored;

  /// No description provided for @paywallNothingToRestore.
  ///
  /// In en, this message translates to:
  /// **'No previous purchase found for this store account.'**
  String get paywallNothingToRestore;

  /// No description provided for @paywallRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t restore purchases. Check your connection and try again.'**
  String get paywallRestoreFailed;

  /// No description provided for @paywallUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Plans can\'t be loaded right now. Check your connection and try again.'**
  String get paywallUnavailable;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium active'**
  String get premiumActive;

  /// No description provided for @premiumActiveLifetime.
  ///
  /// In en, this message translates to:
  /// **'Premium active · Lifetime'**
  String get premiumActiveLifetime;

  /// No description provided for @premiumManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get premiumManage;

  /// No description provided for @settingsPremiumTitle.
  ///
  /// In en, this message translates to:
  /// **'LandMeasure Premium'**
  String get settingsPremiumTitle;

  /// No description provided for @settingsPremiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No ads, unlimited saves and photos, KML any time'**
  String get settingsPremiumSubtitle;

  /// No description provided for @settingsManageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get settingsManageSubscription;

  /// No description provided for @settingsPrivacyChoices.
  ///
  /// In en, this message translates to:
  /// **'Privacy choices'**
  String get settingsPrivacyChoices;

  /// No description provided for @settingsAdInspector.
  ///
  /// In en, this message translates to:
  /// **'Ad Inspector (dev)'**
  String get settingsAdInspector;

  /// No description provided for @exportUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s free KML export is used'**
  String get exportUnlockTitle;

  /// No description provided for @exportUnlockMessage.
  ///
  /// In en, this message translates to:
  /// **'Watch a short ad to export this file, or get Premium for unlimited KML exports. CSV export stays free.'**
  String get exportUnlockMessage;

  /// No description provided for @exportWatchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad'**
  String get exportWatchAd;

  /// No description provided for @exportGetPremium.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get exportGetPremium;

  /// No description provided for @exportLoadingAd.
  ///
  /// In en, this message translates to:
  /// **'Loading ad…'**
  String get exportLoadingAd;

  /// No description provided for @exportAdDismissed.
  ///
  /// In en, this message translates to:
  /// **'Watch the ad to the end to unlock this export.'**
  String get exportAdDismissed;

  /// No description provided for @introNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get introNext;

  /// No description provided for @introGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get introGetStarted;

  /// No description provided for @introAreaTitle.
  ///
  /// In en, this message translates to:
  /// **'Measure Area Easily'**
  String get introAreaTitle;

  /// No description provided for @introAreaBody.
  ///
  /// In en, this message translates to:
  /// **'Mark points on the map to measure land, fields and other areas in seconds.'**
  String get introAreaBody;

  /// No description provided for @introDistanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Measure Distance & Routes'**
  String get introDistanceTitle;

  /// No description provided for @introDistanceBody.
  ///
  /// In en, this message translates to:
  /// **'Measure straight-line distances or track your route while walking outdoors.'**
  String get introDistanceBody;

  /// No description provided for @introFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Made for Real Field Work'**
  String get introFieldTitle;

  /// No description provided for @introFieldBody.
  ///
  /// In en, this message translates to:
  /// **'Measure farms, land plots, properties and outdoor sites with ease.'**
  String get introFieldBody;

  /// No description provided for @paywallTrialTitle.
  ///
  /// In en, this message translates to:
  /// **'{days}-day free trial'**
  String paywallTrialTitle(int days);

  /// No description provided for @paywallThenMonthly.
  ///
  /// In en, this message translates to:
  /// **'Then {price} / month'**
  String paywallThenMonthly(String price);

  /// No description provided for @paywallMonthlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly plan'**
  String get paywallMonthlyTitle;

  /// No description provided for @paywallMonthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'{price} / month'**
  String paywallMonthlyPrice(String price);

  /// No description provided for @paywallYearlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Yearly plan'**
  String get paywallYearlyTitle;

  /// No description provided for @paywallYearlyOnly.
  ///
  /// In en, this message translates to:
  /// **'Only {price} per year'**
  String paywallYearlyOnly(String price);

  /// No description provided for @paywallBestPrice.
  ///
  /// In en, this message translates to:
  /// **'Best price'**
  String get paywallBestPrice;

  /// No description provided for @paywallMostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most popular'**
  String get paywallMostPopular;

  /// No description provided for @paywallStartFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start free trial'**
  String get paywallStartFreeTrial;

  /// No description provided for @paywallTrialThenYearly.
  ///
  /// In en, this message translates to:
  /// **'{days}-day free trial, then {price}/year'**
  String paywallTrialThenYearly(int days, String price);

  /// No description provided for @paywallPricePerYear.
  ///
  /// In en, this message translates to:
  /// **'{price}/year'**
  String paywallPricePerYear(String price);

  /// No description provided for @paywallCancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime'**
  String get paywallCancelAnytime;

  /// No description provided for @paywallTermsTrialMonthly.
  ///
  /// In en, this message translates to:
  /// **'{days} days free, then {price}/month. Renews automatically — cancel any time in {store}.'**
  String paywallTermsTrialMonthly(int days, String price, String store);

  /// No description provided for @premiumPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Go Premium'**
  String get premiumPromptTitle;

  /// No description provided for @premiumPromptPhotos.
  ///
  /// In en, this message translates to:
  /// **'You can add up to {count} photos to a measurement for free. Upgrade to Premium to add more.'**
  String premiumPromptPhotos(int count);

  /// No description provided for @premiumPromptUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get premiumPromptUpgrade;

  /// No description provided for @premiumBadge.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumBadge;

  /// No description provided for @languageChooseTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageChooseTitle;

  /// No description provided for @premiumPromptMapStyleReward.
  ///
  /// In en, this message translates to:
  /// **'{style} maps are a Premium feature. Watch a short ad to use it until you close the app, or upgrade for good.'**
  String premiumPromptMapStyleReward(String style);

  /// No description provided for @mapStyleUnlocked.
  ///
  /// In en, this message translates to:
  /// **'{style} map unlocked until you close the app.'**
  String mapStyleUnlocked(String style);

  /// No description provided for @mapStyleAdDismissed.
  ///
  /// In en, this message translates to:
  /// **'Watch the ad to the end to unlock this map.'**
  String get mapStyleAdDismissed;

  /// No description provided for @pdfReportTitleArea.
  ///
  /// In en, this message translates to:
  /// **'Land Measurement Report'**
  String get pdfReportTitleArea;

  /// No description provided for @pdfReportTitleDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance Measurement Report'**
  String get pdfReportTitleDistance;

  /// No description provided for @pdfReportTitleWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk Measurement Report'**
  String get pdfReportTitleWalk;

  /// No description provided for @pdfReportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exported summary of a saved measurement'**
  String get pdfReportSubtitle;

  /// No description provided for @pdfHeaderLabel.
  ///
  /// In en, this message translates to:
  /// **'Measurement Report'**
  String get pdfHeaderLabel;

  /// No description provided for @pdfFooterGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated by LandMeasure'**
  String get pdfFooterGenerated;

  /// No description provided for @pdfFooterEstimate.
  ///
  /// In en, this message translates to:
  /// **'GPS/map measurements are estimates and may vary by device and environment.'**
  String get pdfFooterEstimate;

  /// No description provided for @pdfPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages}'**
  String pdfPage(int page, int pages);

  /// No description provided for @pdfName.
  ///
  /// In en, this message translates to:
  /// **'Measurement name'**
  String get pdfName;

  /// No description provided for @pdfType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get pdfType;

  /// No description provided for @pdfDateSaved.
  ///
  /// In en, this message translates to:
  /// **'Date saved'**
  String get pdfDateSaved;

  /// No description provided for @pdfReportId.
  ///
  /// In en, this message translates to:
  /// **'Report ID'**
  String get pdfReportId;

  /// No description provided for @pdfSummary.
  ///
  /// In en, this message translates to:
  /// **'Measurement summary'**
  String get pdfSummary;

  /// No description provided for @pdfArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get pdfArea;

  /// No description provided for @pdfPerimeter.
  ///
  /// In en, this message translates to:
  /// **'Perimeter'**
  String get pdfPerimeter;

  /// No description provided for @pdfDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get pdfDistance;

  /// No description provided for @pdfDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get pdfDuration;

  /// No description provided for @pdfPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get pdfPoints;

  /// No description provided for @pdfSegments.
  ///
  /// In en, this message translates to:
  /// **'Segments'**
  String get pdfSegments;

  /// No description provided for @pdfMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get pdfMethod;

  /// No description provided for @pdfSubBoundaryVertices.
  ///
  /// In en, this message translates to:
  /// **'Boundary vertices'**
  String get pdfSubBoundaryVertices;

  /// No description provided for @pdfSubRoutePoints.
  ///
  /// In en, this message translates to:
  /// **'Route points'**
  String get pdfSubRoutePoints;

  /// No description provided for @pdfSubTrackPoints.
  ///
  /// In en, this message translates to:
  /// **'Track points'**
  String get pdfSubTrackPoints;

  /// No description provided for @pdfSubSegments.
  ///
  /// In en, this message translates to:
  /// **'Between points'**
  String get pdfSubSegments;

  /// No description provided for @pdfMethodMapPoints.
  ///
  /// In en, this message translates to:
  /// **'Map points'**
  String get pdfMethodMapPoints;

  /// No description provided for @pdfMethodPolygon.
  ///
  /// In en, this message translates to:
  /// **'Manual polygon'**
  String get pdfMethodPolygon;

  /// No description provided for @pdfMethodRoute.
  ///
  /// In en, this message translates to:
  /// **'Manual route'**
  String get pdfMethodRoute;

  /// No description provided for @pdfAreaNotClosed.
  ///
  /// In en, this message translates to:
  /// **'Not closed'**
  String get pdfAreaNotClosed;

  /// No description provided for @pdfAreaNotClosedSub.
  ///
  /// In en, this message translates to:
  /// **'Route did not form a loop'**
  String get pdfAreaNotClosedSub;

  /// No description provided for @pdfMapBoundary.
  ///
  /// In en, this message translates to:
  /// **'Map & Shape'**
  String get pdfMapBoundary;

  /// No description provided for @pdfMapCaption.
  ///
  /// In en, this message translates to:
  /// **'Schematic of the measured shape · north is up'**
  String get pdfMapCaption;

  /// No description provided for @pdfCenter.
  ///
  /// In en, this message translates to:
  /// **'Center coordinate'**
  String get pdfCenter;

  /// No description provided for @pdfMapStyle.
  ///
  /// In en, this message translates to:
  /// **'Map style'**
  String get pdfMapStyle;

  /// No description provided for @pdfDisplayUnits.
  ///
  /// In en, this message translates to:
  /// **'Display units'**
  String get pdfDisplayUnits;

  /// No description provided for @pdfCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get pdfCoordinates;

  /// No description provided for @pdfCoordinatesHint.
  ///
  /// In en, this message translates to:
  /// **'Points are listed in the order they were measured.'**
  String get pdfCoordinatesHint;

  /// No description provided for @pdfColPoint.
  ///
  /// In en, this message translates to:
  /// **'Point'**
  String get pdfColPoint;

  /// No description provided for @pdfColLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get pdfColLatitude;

  /// No description provided for @pdfColLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get pdfColLongitude;

  /// No description provided for @pdfColSegment.
  ///
  /// In en, this message translates to:
  /// **'Segment'**
  String get pdfColSegment;

  /// No description provided for @pdfColNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get pdfColNote;

  /// No description provided for @pdfNoteStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get pdfNoteStart;

  /// No description provided for @pdfNoteEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get pdfNoteEnd;

  /// No description provided for @pdfNotePhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo attached'**
  String get pdfNotePhoto;

  /// No description provided for @pdfMorePoints.
  ///
  /// In en, this message translates to:
  /// **'{count} more points are not shown. Export CSV to get all of them.'**
  String pdfMorePoints(int count);

  /// No description provided for @pdfNotes.
  ///
  /// In en, this message translates to:
  /// **'Survey notes'**
  String get pdfNotes;

  /// No description provided for @pdfPhotos.
  ///
  /// In en, this message translates to:
  /// **'Site photos'**
  String get pdfPhotos;

  /// No description provided for @pdfPhotoN.
  ///
  /// In en, this message translates to:
  /// **'Photo {n}'**
  String pdfPhotoN(int n);

  /// No description provided for @pdfPhotoPoint.
  ///
  /// In en, this message translates to:
  /// **'At {point}'**
  String pdfPhotoPoint(String point);

  /// No description provided for @pdfCaptured.
  ///
  /// In en, this message translates to:
  /// **'Captured {date}'**
  String pdfCaptured(String date);

  /// No description provided for @pdfMorePhotos.
  ///
  /// In en, this message translates to:
  /// **'{count} more photos are not shown.'**
  String pdfMorePhotos(int count);

  /// No description provided for @pdfExportInfo.
  ///
  /// In en, this message translates to:
  /// **'Export information'**
  String get pdfExportInfo;

  /// No description provided for @pdfSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get pdfSource;

  /// No description provided for @pdfSourceAndroid.
  ///
  /// In en, this message translates to:
  /// **'LandMeasure Android'**
  String get pdfSourceAndroid;

  /// No description provided for @pdfSourceIos.
  ///
  /// In en, this message translates to:
  /// **'LandMeasure iOS'**
  String get pdfSourceIos;

  /// No description provided for @pdfCoordFormat.
  ///
  /// In en, this message translates to:
  /// **'Coordinate format'**
  String get pdfCoordFormat;

  /// No description provided for @pdfCoordFormatValue.
  ///
  /// In en, this message translates to:
  /// **'WGS 84 latitude / longitude'**
  String get pdfCoordFormatValue;

  /// No description provided for @pdfExported.
  ///
  /// In en, this message translates to:
  /// **'Exported'**
  String get pdfExported;

  /// No description provided for @pdfCompanion.
  ///
  /// In en, this message translates to:
  /// **'Other export formats'**
  String get pdfCompanion;

  /// No description provided for @pdfAccuracyTitle.
  ///
  /// In en, this message translates to:
  /// **'Accuracy notice:'**
  String get pdfAccuracyTitle;

  /// No description provided for @pdfAccuracyBody.
  ///
  /// In en, this message translates to:
  /// **'This report summarizes measurements calculated from map points and/or device GPS data. Results are estimates and may vary with device accuracy, satellite visibility, map imagery, terrain, and where boundary points were placed. This document is not a certified cadastral or legal land survey unless separately verified by an authorized survey professional.'**
  String get pdfAccuracyBody;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF — Report'**
  String get exportPdf;

  /// No description provided for @exportPdfSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Printable report with map, coordinates, notes and photos'**
  String get exportPdfSubtitle;

  /// No description provided for @projectLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Free project limit reached'**
  String get projectLimitTitle;

  /// No description provided for @projectLimitMessage.
  ///
  /// In en, this message translates to:
  /// **'You have 4 free projects. Watch a full ad to create one more project, or upgrade to Premium for unlimited projects.'**
  String get projectLimitMessage;

  /// No description provided for @projectRewardRequired.
  ///
  /// In en, this message translates to:
  /// **'Finish watching an ad to unlock another project. If no ad is available, try again later or upgrade to Premium.'**
  String get projectRewardRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'nl',
    'pl',
    'pt',
    'th',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'th':
      return AppLocalizationsTh();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
