// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'LandMeasure';

  @override
  String get navHome => 'Startseite';

  @override
  String get navSaved => 'Gespeichert';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get measurementTypeArea => 'Fläche';

  @override
  String get measurementTypeDistance => 'Distanz';

  @override
  String get measurementTypeWalk => 'Gehen';

  @override
  String get screenMeasureArea => 'Fläche messen';

  @override
  String get screenMeasureDistance => 'Entfernung messen';

  @override
  String get screenWalk => 'Gehen und messen';

  @override
  String get screenSave => 'Messung speichern';

  @override
  String get screenDetail => 'Messdetails';

  @override
  String get screenFullMap => 'Karte';

  @override
  String get screenEdit => 'Messung bearbeiten';

  @override
  String get screenSaved => 'Gespeicherte Messungen';

  @override
  String get screenSettings => 'Einstellungen';

  @override
  String get screenUnits => 'Einheiten';

  @override
  String get screenMapStyle => 'Kartenstil';

  @override
  String get screenLanguage => 'Sprache';

  @override
  String get screenPaywall => 'Premium';

  @override
  String get ctaStartMeasuring => 'Beginnen Sie mit der Messung';

  @override
  String get ctaStartArea => 'Flächenmessung starten';

  @override
  String get ctaStartDistance => 'Distanzmessung starten';

  @override
  String get ctaStartWalk => 'Starten Sie die Gehmessung';

  @override
  String get ctaSaveMeasurement => 'Messung speichern';

  @override
  String get ctaSaveRoute => 'Route speichern';

  @override
  String get ctaPause => 'Pause';

  @override
  String get ctaResume => 'Fortsetzen';

  @override
  String get ctaFinish => 'Beenden';

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionSave => 'Speichern';

  @override
  String get actionDiscard => 'Verwerfen';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get actionReset => 'Zurücksetzen';

  @override
  String get actionOpenSettings => 'Öffnen Sie Einstellungen';

  @override
  String get actionKeepRecording => 'Nehmen Sie weiter auf';

  @override
  String get actionKeepEditing => 'Bearbeiten Sie weiter';

  @override
  String get dialogResetTitle => 'Messung zurücksetzen?';

  @override
  String get dialogResetMessage => 'Dadurch werden alle Punkte entfernt.';

  @override
  String get dialogDiscardDraftTitle => 'Diesen Entwurf verwerfen?';

  @override
  String get dialogDiscardDraftMessage =>
      'Alle Punkte und nicht gespeicherten Änderungen werden entfernt.';

  @override
  String get dialogDeleteTitle => 'Messung löschen?';

  @override
  String get dialogDeleteMessage =>
      'Diese Messung, ihre Fotos und Notizen werden dauerhaft gelöscht.';

  @override
  String get dialogFinishWalkTitle => 'Aufnahme beenden?';

  @override
  String get dialogFinishWalkMessage => 'Die GPS-Verfolgung wird beendet.';

  @override
  String get dialogRenameTitle => 'Messung umbenennen';

  @override
  String get dialogDiscardChangesTitle => 'Änderungen verwerfen?';

  @override
  String get fabLayers => 'Kartenebenen';

  @override
  String get fabMyLocation => 'Mein Standort';

  @override
  String get fabSearch => 'Ort suchen';

  @override
  String get fabCamera => 'Machen Sie ein Foto';

  @override
  String get gpsReady => 'GPS bereit';

  @override
  String get gpsSearching => 'Suche nach GPS…';

  @override
  String get gpsLowAccuracy => 'Geringe GPS-Genauigkeit';

  @override
  String get locationOff => 'Der Standort ist deaktiviert';

  @override
  String get locationOffMessage =>
      'Schalten Sie den Standort ein, um Ihren Spaziergang aufzuzeichnen.';

  @override
  String get mapOffline =>
      'Kartenverbindung nicht verfügbar – Ihre Punkte sind sicher';

  @override
  String get emptyNoMeasurementsTitle => 'Noch keine Messungen';

  @override
  String get emptyNoMeasurementsMessage =>
      'Messen Sie Ihr erstes Stück Land und es wird hier angezeigt.';

  @override
  String get languageSystem => 'Systemstandard';

  @override
  String get measureHintCrosshair =>
      'Bewegen Sie die Karte, um das Fadenkreuz zu platzieren, und tippen Sie dann auf Punkt hinzufügen.';

  @override
  String get measureHintTap =>
      'Tippen Sie auf die Karte, um Punkte rund um die Grenze hinzuzufügen.';

  @override
  String get toolbarUndo => 'Rückgängig';

  @override
  String get toolbarAddPoint => 'Punkt hinzufügen';

  @override
  String get toolbarClose => 'Form schließen';

  @override
  String get toolbarReset => 'Zurücksetzen';

  @override
  String get toolbarAddAtMyLocation => 'Punkt an meinem Standort hinzufügen';

  @override
  String get resultArea => 'Fläche';

  @override
  String get resultPerimeter => 'Umfang';

  @override
  String get resultAreaNeedsPoints =>
      'Fügen Sie mindestens 3 Punkte hinzu, um die Fläche zu berechnen';

  @override
  String resultPointCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Punkte',
      one: '1 Punkt',
    );
    return '$_temp0';
  }

  @override
  String get edgesCross =>
      'Kanten kreuzen sich – die Fläche ist möglicherweise falsch';

  @override
  String get menuMore => 'Weitere Optionen';

  @override
  String get menuInputCrosshair => 'Mit Fadenkreuz hinzufügen';

  @override
  String get menuInputTap => 'Fügen Sie hinzu, indem Sie auf die Karte tippen';

  @override
  String get menuShowEdgeLabels => 'Kantenlängen anzeigen';

  @override
  String pointLabel(int number) {
    return 'Punkt $number';
  }

  @override
  String get pointDelete => 'Punkt löschen';

  @override
  String get pointDeselect => 'Fertig';

  @override
  String gpsLowAccuracyAdded(int meters) {
    return 'Die GPS-Genauigkeit ist gering (±$meters m). Der Punkt wurde trotzdem hinzugefügt.';
  }

  @override
  String get locationUnavailable =>
      'Ihr Standort konnte nicht ermittelt werden. Versuchen Sie es noch einmal im Freien.';

  @override
  String get locationPermissionDenied =>
      'Der Standortzugriff ist deaktiviert. Sie können weiterhin messen, indem Sie die Karte verschieben.';

  @override
  String get locationServiceOff =>
      'Der Standort ist auf diesem Gerät deaktiviert.';

  @override
  String get mapLayersTitle => 'Kartentyp';

  @override
  String get mapStyleStandard => 'Standard';

  @override
  String get mapStyleSatellite => 'Satellit';

  @override
  String get mapStyleTerrain => 'Terrain';

  @override
  String get mapStyleHybrid => 'Hybrid';

  @override
  String get draftSaveFailed =>
      'Ihre Punkte konnten nicht gespeichert werden. Bei der nächsten Änderung werden sie wieder gespeichert.';

  @override
  String get menuHelp => 'Helfen';

  @override
  String get actionGotIt => 'Verstanden';

  @override
  String get helpTitleArea => 'So messen Sie die Fläche';

  @override
  String get helpTitleDistance => 'So messen Sie die Entfernung';

  @override
  String get helpTitleWalk => 'Wie man geht und misst';

  @override
  String get helpAreaSummary =>
      'Fügen Sie Punkte rund um die Grenze Ihres Landes hinzu.';

  @override
  String get helpDistanceSummary =>
      'Fügen Sie Punkte entlang der Route hinzu, die Sie messen möchten.';

  @override
  String get helpWalkSummary =>
      'Gehen Sie um die Grenze herum, während LandMeasure Ihren GPS-Pfad aufzeichnet.';

  @override
  String get helpPhotoTip =>
      'Verwenden Sie Fotos, um Orientierungspunkte, Grenzen oder Standortbedingungen zu dokumentieren.';

  @override
  String get helpAccuracyNote =>
      'Die Genauigkeit von GPS- und Kartenmessungen kann je nach Gerät, Kartenbild und Umgebung variieren.';

  @override
  String get helpAreaStep1 =>
      'Bewegen Sie die Karte, sodass sich das Fadenkreuz in einer Ecke befindet, und tippen Sie dann auf **Punkt hinzufügen**.';

  @override
  String get helpAreaStep2 =>
      'Fügen Sie mindestens 3 Punkte um die Grenze hinzu. Ziehen Sie einen Punkt, um ihn anzupassen.';

  @override
  String get helpAreaStep3 =>
      'Tippen Sie auf **Schließen**, um die Form fertigzustellen, und dann auf **Messung speichern**.';

  @override
  String get helpDistanceStep1 =>
      'Platzieren Sie das Fadenkreuz am Anfang Ihrer Route und tippen Sie auf **Punkt hinzufügen**.';

  @override
  String get helpDistanceStep2 =>
      'Fügen Sie weitere Punkte entlang der Route hinzu. Die Länge jedes Segments wird auf der Karte angezeigt.';

  @override
  String get helpDistanceStep3 =>
      'Tippen Sie auf **Route speichern**, wenn Sie fertig sind.';

  @override
  String get helpWalkStep1 =>
      'Warten Sie auf **GPS bereit** und tippen Sie dann auf **Fangen Sie an zu laufen**.';

  @override
  String get helpWalkStep2 =>
      'Gehen Sie an der Grenze entlang. Verwenden Sie **Pause**, wenn Sie anhalten müssen.';

  @override
  String get helpWalkStep3 =>
      'Kehren Sie zu Ihrem Ausgangspunkt zurück und tippen Sie auf **Fertig stellen**, um die Fläche zu berechnen.';

  @override
  String get helpTipGpsPoint =>
      'Tipp: Tippen Sie auf 📍, um einen Punkt an Ihrem aktuellen GPS-Standort hinzuzufügen.';

  @override
  String get helpTipWalk =>
      'Tipp: Bleiben Sie für eine bessere GPS-Genauigkeit in offenen Bereichen.';

  @override
  String get resultDistance => 'Distanz';

  @override
  String get resultDistanceNeedsPoints =>
      'Fügen Sie mindestens 2 Punkte hinzu, um die Entfernung zu messen';

  @override
  String resultSegmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Abschnitte',
      one: '1 Abschnitt',
    );
    return '$_temp0';
  }

  @override
  String get segmentsTitle => 'Segmente';

  @override
  String draftSavedSnack(int count, String type) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Entwurf gespeichert · $type · $count Punkte',
      one: 'Entwurf gespeichert · $type · 1 Punkt',
    );
    return '$_temp0';
  }

  @override
  String get searchHint => 'Adresse, Koordinaten oder Google Maps-Link';

  @override
  String get searchAction => 'Suchen';

  @override
  String get searchRecent => 'Aktuelle Suchanfragen';

  @override
  String get searchNoResults =>
      'Keine Orte gefunden. Versuchen Sie es mit Koordinaten oder einem Google Maps-Link.';

  @override
  String get searchNeedsInternet =>
      'Für die Suche nach einer Adresse ist eine Internetverbindung erforderlich.';

  @override
  String get searchUnavailable =>
      'Die Adresssuche ist auf diesem Gerät nicht verfügbar. Versuchen Sie es mit Koordinaten oder einem Google Maps-Link.';

  @override
  String get searchClear => 'Klar';

  @override
  String get searchFailed =>
      'Diese Adresse konnte momentan nicht gesucht werden. Versuchen Sie es mit Koordinaten oder einem Google Maps-Link.';

  @override
  String get ctaStartWalking => 'Fangen Sie an zu laufen';

  @override
  String get walkReadyHelper =>
      'Gehen Sie um die Grenze herum, um Ihren Weg aufzuzeichnen.';

  @override
  String get keepScreenOn => 'Lassen Sie den Bildschirm eingeschaltet';

  @override
  String get walkRecording => 'GPS aufzeichnen…';

  @override
  String get walkPaused => 'Angehalten';

  @override
  String get walkPausedMessage =>
      'Tippen Sie auf „Fortsetzen“, um dort fortzufahren, wo Sie sich gerade befinden.';

  @override
  String gpsAccuracyShort(int meters) {
    return '±$meters m';
  }

  @override
  String gpsLowAccuracyMessage(int meters) {
    return 'Genauigkeit ±$meters m – Punkte werden erst aufgezeichnet, wenn sie sich verbessert. Gehen Sie in einen offenen Bereich.';
  }

  @override
  String get locationDeniedTitle => 'Der Standortzugriff ist deaktiviert';

  @override
  String get locationDeniedMessage =>
      'Erlauben Sie dem Standort, Ihren Spaziergang aufzuzeichnen.';

  @override
  String get actionAllow => 'Erlauben';

  @override
  String get actionNotNow => 'Nicht jetzt';

  @override
  String get mockLocationDetected =>
      'Scheinstandort erkannt – diese Positionen werden nicht aufgezeichnet.';

  @override
  String get walkCloseToStart =>
      'Nah am Start – am Ende, um die Fläche zu berechnen';

  @override
  String get walkNotClosed => 'Route nicht geschlossen – nur Entfernung';

  @override
  String get walkKeepWalking =>
      'Gehen Sie zurück zu Ihrem Ausgangspunkt, um die Schleife zu schließen.';

  @override
  String get resultDuration => 'Dauer';

  @override
  String get walkNotificationTitle => 'LandMeasure zeichnet Ihre Messung auf';

  @override
  String get walkNotificationText =>
      'Tippen Sie, um zu Ihrem Spaziergang zurückzukehren.';

  @override
  String get walkNotificationChannel => 'Gehaufzeichnung';

  @override
  String get walkRecordingBack =>
      'Aufnahme läuft. Machen Sie eine Pause oder beenden Sie den Vorgang, bevor Sie gehen.';

  @override
  String get walkPauseAndLeave => 'Innehalten und gehen';

  @override
  String get walkStartFailed =>
      'Die Aufnahme konnte nicht gestartet werden. Versuchen Sie es erneut.';

  @override
  String get batteryHintTitle => 'Lassen Sie LandMeasure im Hintergrund laufen';

  @override
  String get batteryHintMessage =>
      'Einige Telefone stoppen Apps, wenn der Bildschirm ausgeschaltet ist. Um Ihren Spaziergang weiterhin aufzuzeichnen, öffnen Sie Einstellungen → Akku und wählen Sie „Keine Einschränkungen“ (oder „Uneingeschränkt“) für LandMeasure.';

  @override
  String get fabRecenter => 'Neu zentrieren';

  @override
  String get homeHeroSubtitle =>
      'Wählen Sie eine Methode zur Vermessung Ihres Grundstücks.';

  @override
  String get homeContinueTitle => 'Messung fortsetzen';

  @override
  String get homeSeeAllDrafts => 'Alle Entwürfe ansehen';

  @override
  String get homeRecentTitle => 'Aktuelle Messungen';

  @override
  String get homeRecentEmptyTitle => 'Keine aktuellen Messungen';

  @override
  String get homeRecentEmptyMessage =>
      'Hier werden gespeicherte Messungen angezeigt.';

  @override
  String get actionSeeAll => 'Alle anzeigen';

  @override
  String get untitledArea => 'Unbenannter Bereich';

  @override
  String get untitledDistance => 'Ohne Titel Entfernung';

  @override
  String get untitledWalk => 'Spaziergang ohne Titel';

  @override
  String get draftLabel => 'Entwurf';

  @override
  String get walkFinishedNotSaved => 'Fertig · nicht gespeichert';

  @override
  String lastEdited(String time) {
    return 'Zuletzt bearbeitet $time';
  }

  @override
  String get timeJustNow => 'soeben';

  @override
  String timeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Min.',
      one: 'vor 1 Min.',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Stunden',
      one: 'vor 1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Tagen',
      one: 'gestern',
    );
    return '$_temp0';
  }

  @override
  String get savedSearchHint => 'Suche nach Namen';

  @override
  String get savedSearchOpen => 'Suchen';

  @override
  String get savedSearchClose => 'Suche schließen';

  @override
  String get filterAll => 'Alle';

  @override
  String filterWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String savedDraftsTitle(int count) {
    return 'Entwürfe ($count)';
  }

  @override
  String get savedNoResults => 'Keine Messungen gefunden.';

  @override
  String get menuRename => 'Umbenennen';

  @override
  String get menuExport => 'Export';

  @override
  String get measurementDeleted => 'Messung gelöscht';

  @override
  String get draftDiscarded => 'Entwurf verworfen';

  @override
  String get exportTitle => 'Export';

  @override
  String get renameHint => 'Messname';

  @override
  String get saveNameLabel => 'Name';

  @override
  String get saveNameRequired => 'Name ist erforderlich';

  @override
  String get saveNotesLabel => 'Notizen';

  @override
  String get saveNotesHint =>
      'Grenzen, Eigentümer, Sehenswürdigkeiten… (optional)';

  @override
  String get saveTypeLabel => 'Typ';

  @override
  String get saveFailed =>
      'Konnte nicht gespeichert werden. Bitte versuchen Sie es erneut.';

  @override
  String get saveLimitReached =>
      'Sie haben das kostenlose Limit der gespeicherten Messungen erreicht. Dieser bleibt in Ihren Entwürfen.';

  @override
  String get saveNotFound => 'Diese Messung existiert nicht mehr.';

  @override
  String photosTitle(int count) {
    return 'Standortfotos ($count)';
  }

  @override
  String get actionClose => 'Schließen';

  @override
  String get resultPoints => 'Punkte';

  @override
  String get resultSegments => 'Segmente';

  @override
  String get resultAvgPace => 'Durchschnittliches Tempo';

  @override
  String paceValue(String time, String unit) {
    return '$time /$unit';
  }

  @override
  String get notesTitle => 'Notizen';

  @override
  String get notesEmpty => 'Keine Notizen';

  @override
  String get actionEdit => 'Bearbeiten';

  @override
  String get actionExport => 'Export';

  @override
  String get detailOpenMap => 'Karte öffnen';

  @override
  String savedOn(String date) {
    return 'Gespeichert $date';
  }

  @override
  String get addPhotoTitle => 'Foto hinzufügen';

  @override
  String get addPhotoCamera => 'Machen Sie ein Foto';

  @override
  String get addPhotoGallery => 'Wählen Sie aus der Galerie';

  @override
  String addPhotoForPoint(int number) {
    return 'Für Punkt $number';
  }

  @override
  String get addPhotoTile => 'Foto hinzufügen';

  @override
  String get photoAddFailed =>
      'Das Foto konnte nicht hinzugefügt werden. Bitte versuchen Sie es erneut.';

  @override
  String get photoRemoved => 'Foto entfernt';

  @override
  String get actionUndo => 'Rückgängig';

  @override
  String get photoLimitReached =>
      'Sie haben das kostenlose Limit an Fotos für diese Messung erreicht.';

  @override
  String get photoDeleteTitle => 'Foto löschen?';

  @override
  String get photoDeleteMessage => 'Dieses Foto wird aus der Messung entfernt.';

  @override
  String get photoAttachTitle => 'Dieses Foto der Messung beifügen?';

  @override
  String get photoAttachMessage =>
      '„Fotos zur Messung speichern“ ist in den Einstellungen deaktiviert.';

  @override
  String get actionAttach => 'Anhängen';

  @override
  String get photoWaitForStart => 'Gehen Sie los, um Fotos hinzuzufügen.';

  @override
  String photoCounter(int index, int total) {
    return '$index / $total';
  }

  @override
  String get photoShare => 'Teilen';

  @override
  String photoOpen(int number) {
    return 'Öffnen Sie das Foto $number';
  }

  @override
  String get photoRemove => 'Foto entfernen';

  @override
  String get pointPhoto => 'Foto';

  @override
  String get cameraPermissionTitle => 'Kamerazugriff zulassen';

  @override
  String get cameraPermissionMessage =>
      'Machen Sie Fotos von Orientierungspunkten, Grenzen und Standortbedingungen und bewahren Sie diese zusammen mit Ihrer Messung auf.';

  @override
  String get cameraPermissionDenied =>
      'Der Kamerazugriff ist deaktiviert. Sie können es in den Einstellungen aktivieren.';

  @override
  String get actionContinue => 'Weiter';

  @override
  String get notesEditTitle => 'Notizen bearbeiten';

  @override
  String get notesAdd => 'Notizen hinzufügen';

  @override
  String get editTabResult => 'Ergebnis';

  @override
  String get editTabDetails => 'Einzelheiten';

  @override
  String get ctaSaveChanges => 'Änderungen speichern';

  @override
  String get dialogDiscardChangesMessage =>
      'Ihre Änderungen an dieser Messung gehen verloren.';

  @override
  String get changesSaved => 'Änderungen gespeichert';

  @override
  String get menuReopenShape => 'Form erneut öffnen';

  @override
  String get exportKml => 'KML – Google Earth';

  @override
  String get exportKmlSubtitle =>
      'Form- und Fotopunkte für Google Earth- und GIS-Apps';

  @override
  String get exportCsv => 'CSV – Excel';

  @override
  String get exportCsvSubtitle =>
      'Jeder Punkt mit Koordinaten, für Tabellenkalkulationen';

  @override
  String get exportPreparing => 'Datei wird vorbereitet…';

  @override
  String get exportFailed =>
      'Konnte nicht exportiert werden. Bitte versuchen Sie es erneut.';

  @override
  String get exportLimitReached =>
      'Der kostenlose KML-Export für heute ist aufgebraucht. CSV-Exporte bleiben kostenlos.';

  @override
  String get landValueTitle => 'Grundstückswert';

  @override
  String get landValueAdd => 'Fügen Sie den Bodenwert hinzu';

  @override
  String get landValueUnitPrice => 'Stückpreis';

  @override
  String get landValueUnit => 'Pro';

  @override
  String landValueEstimated(String value) {
    return 'Geschätzter Wert ≈ $value';
  }

  @override
  String landValueRate(String price, String unit) {
    return '$price / $unit';
  }

  @override
  String get landValueNeedsArea =>
      'Der Grundstückswert benötigt eine Fläche (schließen Sie die Form an).';

  @override
  String get landValueRemove => 'Entfernen';

  @override
  String get landValueInvalid => 'Geben Sie einen Preis größer als 0 ein';

  @override
  String get resultValue => 'Wert';

  @override
  String get settingsSubtitle => 'Einheiten, Karten- und App-Einstellungen';

  @override
  String get settingsSectionPreferences => 'Messeinstellungen';

  @override
  String get settingsSectionMeasureMap => 'Messung und Karte';

  @override
  String get settingsSectionSupport => 'Support & Recht';

  @override
  String get settingsDefaultMode => 'Standardmesstyp';

  @override
  String get settingsDefaultModeHint =>
      'Wird auf der Startseite ausgewählt, wenn Sie die App öffnen.';

  @override
  String get settingsGpsAccuracy => 'GPS-Genauigkeitsanzeige';

  @override
  String get settingsGpsAccuracySubtitle =>
      'Zeigen Sie beim Gehen ±m und den Genauigkeitskreis an';

  @override
  String get settingsAutoCenter => 'Karte automatisch zentrieren';

  @override
  String get settingsAutoCenterSubtitle =>
      'Öffnen Sie Karten an Ihrem Standort und folgen Sie Ihnen beim Gehen';

  @override
  String get settingsSavePhotos => 'Speichern Sie Fotos in der Messung';

  @override
  String get settingsSavePhotosSubtitle =>
      'Hängen Sie neue Fotos an, ohne zu fragen';

  @override
  String get settingsKeepAwake => 'Bildschirm eingeschaltet lassen';

  @override
  String get settingsKeepAwakeSubtitle =>
      'Der Bildschirm bleibt während der Messung eingeschaltet';

  @override
  String get settingsHelpFeedback => 'Hilfe und Feedback';

  @override
  String get settingsRateUs => 'Bewerten Sie uns';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get settingsTerms => 'Nutzungsbedingungen';

  @override
  String settingsVersion(String version, String build) {
    return 'Version $version ($build)';
  }

  @override
  String get feedbackSubject => 'LandMeasure-Feedback';

  @override
  String feedbackNoEmailApp(String email) {
    return 'Keine E-Mail-App gefunden. Schreiben Sie uns an $email.';
  }

  @override
  String get linkOpenFailed =>
      'Der Link konnte nicht geöffnet werden. Bitte versuchen Sie es erneut.';

  @override
  String get unitsDistanceTitle => 'Distanz';

  @override
  String get unitsAreaTitle => 'Fläche';

  @override
  String get unitsSecondary => 'Nebeneinheit anzeigen';

  @override
  String unitsSecondaryExample(String example) {
    return 'z.B. $example';
  }

  @override
  String get unitsNote =>
      'Neue Messungen verwenden diese Einheiten. Jede Messung kann auch die Einheiten ihres Ergebnisses wechseln.';

  @override
  String get unitMeters => 'Meter';

  @override
  String get unitKilometers => 'Kilometer';

  @override
  String get unitFeet => 'Fuß';

  @override
  String get unitMiles => 'Meilen';

  @override
  String get unitSquareMeters => 'Quadratmeter';

  @override
  String get unitHectares => 'Hektar';

  @override
  String get unitAcres => 'Acres';

  @override
  String get unitSquareFeet => 'Quadratfuß';

  @override
  String get mapStyleNote =>
      'Mit dieser Karte werden neue Messungen geöffnet. Sie können jede Karte mit der Schaltfläche „Ebenen“ wechseln.';

  @override
  String get actionApply => 'Anwenden';

  @override
  String get languageAppLanguages => 'App-Sprachen';

  @override
  String get languageMachineNote =>
      'Diese Sprache wurde maschinell übersetzt und kann Fehler enthalten.';

  @override
  String get locationPermissionTitle => 'Standortzugriff zulassen';

  @override
  String get locationPermissionMessage =>
      'LandMeasure verwendet Ihren Standort, um auf der Karte anzuzeigen, wo Sie sich befinden. Es bleibt auf Ihrem Telefon.';

  @override
  String get locationPermissionMeasureMessage =>
      'Zeigen Sie auf der Karte an, wo Sie sich befinden, und fügen Sie Punkte hinzu, an denen Sie sich befinden. Ohne sie können Sie immer noch messen, indem Sie die Karte verschieben.';

  @override
  String get locationPermissionWalkMessage =>
      'Walk & Measure zeichnet Ihren Weg mit GPS auf, während dieser Bildschirm geöffnet ist. Ihr Standort bleibt auf Ihrem Telefon.';

  @override
  String get locationPermissionBlocked =>
      'Der Standortzugriff ist für LandMeasure deaktiviert. Aktivieren Sie es in den Einstellungen, um Ihre Position zu verwenden.';

  @override
  String get notificationPermissionTitle => 'Benachrichtigungen zulassen';

  @override
  String get notificationPermissionMessage =>
      'Lassen Sie Benachrichtigungen zu, damit Sie den Aufnahmestatus sehen können, auch wenn Ihr Bildschirm ausgeschaltet ist.';

  @override
  String get actionRetry => 'Erneut versuchen';

  @override
  String get paywallTitle => 'Messen ohne Grenzen';

  @override
  String get paywallSubtitle =>
      'Schalten Sie unbegrenzte Projekte und Premium-Funktionen frei.';

  @override
  String get paywallBenefitNoAds => 'Keine Werbung';

  @override
  String get paywallBenefitSaves => 'Unbegrenzt gespeicherte Messungen';

  @override
  String get paywallBenefitPhotos => 'Unbegrenzte Fotos pro Messung';

  @override
  String get paywallBenefitKml => 'KML-Export jederzeit möglich';

  @override
  String paywallStartTrial(int days) {
    return '$days Tage kostenlos testen';
  }

  @override
  String paywallTermsTrial(int days, String price, String store) {
    return '$days Tage kostenlos, danach $price/Jahr. Automatische Verlängerung — jederzeit in $store kündbar.';
  }

  @override
  String paywallTermsYearly(String price, String store) {
    return '$price/Jahr. Verlängert sich automatisch – jederzeit kündbar in $store.';
  }

  @override
  String paywallTermsMonthly(String price, String store) {
    return '$price/Monat. Verlängert sich automatisch – jederzeit kündbar in $store.';
  }

  @override
  String get paywallRestore => 'Einkäufe wiederherstellen';

  @override
  String get paywallWelcome => 'Willkommen bei Premium!';

  @override
  String get paywallPending =>
      'Zahlung ausstehend. Premium wird freigeschaltet, sobald es abgeschlossen ist.';

  @override
  String get paywallPurchaseFailed =>
      'Der Kauf ist fehlgeschlagen. Ihnen wurde nichts berechnet.';

  @override
  String get paywallRestored => 'Einkäufe wiederhergestellt.';

  @override
  String get paywallNothingToRestore =>
      'Für dieses Shop-Konto wurde kein vorheriger Kauf gefunden.';

  @override
  String get paywallRestoreFailed =>
      'Käufe konnten nicht wiederhergestellt werden. Überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get paywallUnavailable =>
      'Pläne können derzeit nicht geladen werden. Überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get premiumActive => 'Premium aktiv';

  @override
  String get premiumActiveLifetime => 'Premium aktiv · Lebenslang';

  @override
  String get premiumManage => 'Verwalten';

  @override
  String get settingsPremiumTitle => 'LandMeasure Premium';

  @override
  String get settingsPremiumSubtitle =>
      'Keine Werbung, unbegrenzte Speicherungen und Fotos, jederzeit KML';

  @override
  String get settingsManageSubscription => 'Abonnement verwalten';

  @override
  String get settingsPrivacyChoices => 'Datenschutzoptionen';

  @override
  String get settingsAdInspector => 'Anzeigeninspektor (Entwickler)';

  @override
  String get exportUnlockTitle =>
      'Der kostenlose KML-Export für heute ist aufgebraucht';

  @override
  String get exportUnlockMessage =>
      'Sehen Sie sich eine kurze Anzeige an, um diese Datei zu exportieren, oder holen Sie sich Premium für unbegrenzte KML-Exporte. Der CSV-Export bleibt kostenlos.';

  @override
  String get exportWatchAd => 'Sehen Sie sich eine Anzeige an';

  @override
  String get exportGetPremium => 'Premium erhalten';

  @override
  String get exportLoadingAd => 'Anzeige wird geladen…';

  @override
  String get exportAdDismissed =>
      'Sehen Sie sich die Anzeige bis zum Ende an, um diesen Export freizuschalten.';

  @override
  String get introNext => 'Nächste';

  @override
  String get introGetStarted => 'Legen Sie los';

  @override
  String get introAreaTitle => 'Fläche einfach messen';

  @override
  String get introAreaBody =>
      'Markieren Sie Punkte auf der Karte, um Land, Felder und andere Bereiche in Sekundenschnelle zu vermessen.';

  @override
  String get introDistanceTitle => 'Messen Sie Entfernungen und Routen';

  @override
  String get introDistanceBody =>
      'Messen Sie geradlinige Entfernungen oder verfolgen Sie Ihre Route beim Gehen im Freien.';

  @override
  String get introFieldTitle => 'Gemacht für echte Feldarbeit';

  @override
  String get introFieldBody =>
      'Vermessen Sie ganz einfach Bauernhöfe, Grundstücke, Grundstücke und Außenanlagen.';

  @override
  String paywallTrialTitle(int days) {
    return '$days Tage kostenlos testen';
  }

  @override
  String paywallThenMonthly(String price) {
    return 'Dann $price / Monat';
  }

  @override
  String get paywallMonthlyTitle => 'Monatsplan';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price / Monat';
  }

  @override
  String get paywallYearlyTitle => 'Jahresplan';

  @override
  String paywallYearlyOnly(String price) {
    return 'Nur $price pro Jahr';
  }

  @override
  String get paywallBestPrice => 'Bester Preis';

  @override
  String get paywallMostPopular => 'Am beliebtesten';

  @override
  String get paywallStartFreeTrial => 'Kostenlose Testversion starten';

  @override
  String paywallTrialThenYearly(int days, String price) {
    return '$days Tage kostenlos, danach $price/Jahr';
  }

  @override
  String paywallPricePerYear(String price) {
    return '$price/Jahr';
  }

  @override
  String get paywallCancelAnytime => 'Jederzeit kündbar';

  @override
  String paywallTermsTrialMonthly(int days, String price, String store) {
    return '$days Tage kostenlos, dann $price/Monat. Verlängert sich automatisch – jederzeit kündbar in $store.';
  }

  @override
  String get premiumPromptTitle => 'Gehen Sie Premium';

  @override
  String premiumPromptPhotos(int count) {
    return 'Sie können bis zu $count Fotos kostenlos zu einer Messung hinzufügen. Upgraden Sie auf Premium, um mehr hinzuzufügen.';
  }

  @override
  String get premiumPromptUpgrade => 'Auf Premium upgraden';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get languageChooseTitle => 'Wählen Sie Ihre Sprache';

  @override
  String premiumPromptMapStyleReward(String style) {
    return '$style-Karten sind eine Premium-Funktion. Sehen Sie sich eine kurze Anzeige an, um diese Karte bis zum Schließen der App zu nutzen, oder upgraden Sie für dauerhaften Zugriff.';
  }

  @override
  String mapStyleUnlocked(String style) {
    return 'Die $style-Karte ist so lange freigeschaltet, bis Sie die App schließen.';
  }

  @override
  String get mapStyleAdDismissed =>
      'Sehen Sie sich die Anzeige bis zum Ende an, um diese Karte freizuschalten.';

  @override
  String get pdfReportTitleArea => 'Landvermessungsbericht';

  @override
  String get pdfReportTitleDistance => 'Entfernungsmessbericht';

  @override
  String get pdfReportTitleWalk => 'Gehmessbericht';

  @override
  String get pdfReportSubtitle =>
      'Exportierte Zusammenfassung einer gespeicherten Messung';

  @override
  String get pdfHeaderLabel => 'Messbericht';

  @override
  String get pdfFooterGenerated => 'Erstellt von LandMeasure';

  @override
  String get pdfFooterEstimate =>
      'GPS-/Kartenmessungen sind Schätzungen und können je nach Gerät und Umgebung variieren.';

  @override
  String pdfPage(int page, int pages) {
    return 'Seite $page von $pages';
  }

  @override
  String get pdfName => 'Name der Messung';

  @override
  String get pdfType => 'Typ';

  @override
  String get pdfDateSaved => 'Speicherdatum';

  @override
  String get pdfReportId => 'Berichts-ID';

  @override
  String get pdfSummary => 'Zusammenfassung der Messungen';

  @override
  String get pdfArea => 'Fläche';

  @override
  String get pdfPerimeter => 'Umfang';

  @override
  String get pdfDistance => 'Distanz';

  @override
  String get pdfDuration => 'Dauer';

  @override
  String get pdfPoints => 'Punkte';

  @override
  String get pdfSegments => 'Segmente';

  @override
  String get pdfMethod => 'Verfahren';

  @override
  String get pdfSubBoundaryVertices => 'Grenzscheitelpunkte';

  @override
  String get pdfSubRoutePoints => 'Routenpunkte';

  @override
  String get pdfSubTrackPoints => 'GPS-Trackpunkte';

  @override
  String get pdfSubSegments => 'Zwischen Punkten';

  @override
  String get pdfMethodMapPoints => 'Kartenpunkte';

  @override
  String get pdfMethodPolygon => 'Manuelles Polygon';

  @override
  String get pdfMethodRoute => 'Manuelle Route';

  @override
  String get pdfAreaNotClosed => 'Nicht geschlossen';

  @override
  String get pdfAreaNotClosedSub => 'Die Route bildete keine Schleife';

  @override
  String get pdfMapBoundary => 'Karte und Form';

  @override
  String get pdfMapCaption =>
      'Schematische Darstellung der gemessenen Form · Norden ist oben';

  @override
  String get pdfCenter => 'Mittelpunktkoordinaten';

  @override
  String get pdfMapStyle => 'Kartenstil';

  @override
  String get pdfDisplayUnits => 'Anzeigeeinheiten';

  @override
  String get pdfCoordinates => 'Koordinaten';

  @override
  String get pdfCoordinatesHint =>
      'Die Punkte werden in der Reihenfolge aufgelistet, in der sie gemessen wurden.';

  @override
  String get pdfColPoint => 'Punkt';

  @override
  String get pdfColLatitude => 'Breitengrad';

  @override
  String get pdfColLongitude => 'Längengrad';

  @override
  String get pdfColSegment => 'Segment';

  @override
  String get pdfColNote => 'Notiz';

  @override
  String get pdfNoteStart => 'Start';

  @override
  String get pdfNoteEnd => 'Ende';

  @override
  String get pdfNotePhoto => 'Foto beigefügt';

  @override
  String pdfMorePoints(int count) {
    return '$count weitere Punkte werden nicht angezeigt. Exportieren Sie CSV, um alle zu erhalten.';
  }

  @override
  String get pdfNotes => 'Vermessungsnotizen';

  @override
  String get pdfPhotos => 'Geländefotos';

  @override
  String pdfPhotoN(int n) {
    return 'Foto $n';
  }

  @override
  String pdfPhotoPoint(String point) {
    return 'Bei $point';
  }

  @override
  String pdfCaptured(String date) {
    return 'Aufgenommen am $date';
  }

  @override
  String pdfMorePhotos(int count) {
    return '$count weitere Fotos werden nicht angezeigt.';
  }

  @override
  String get pdfExportInfo => 'Exportinformationen';

  @override
  String get pdfSource => 'Quelle';

  @override
  String get pdfSourceAndroid => 'LandMeasure Android';

  @override
  String get pdfSourceIos => 'LandMeasure iOS';

  @override
  String get pdfCoordFormat => 'Koordinatenformat';

  @override
  String get pdfCoordFormatValue => 'WGS 84 Breiten-/Längengrad';

  @override
  String get pdfExported => 'Exportiert';

  @override
  String get pdfCompanion => 'Andere Exportformate';

  @override
  String get pdfAccuracyTitle => 'Genauigkeitshinweis:';

  @override
  String get pdfAccuracyBody =>
      'Dieser Bericht fasst Messungen zusammen, die aus Kartenpunkten und/oder GPS-Daten des Geräts berechnet wurden. Die Ergebnisse sind Schätzungen und können je nach Gerätegenauigkeit, Satellitensichtbarkeit, Kartenbildern, Gelände und der Position der Grenzpunkte variieren. Bei diesem Dokument handelt es sich nicht um eine zertifizierte Kataster- oder gesetzliche Landvermessung, es sei denn, es wurde separat von einem autorisierten Vermessungsfachmann überprüft.';

  @override
  String get exportPdf => 'PDF – Bericht';

  @override
  String get exportPdfSubtitle =>
      'Druckbarer Bericht mit Karte, Koordinaten, Notizen und Fotos';

  @override
  String get projectLimitTitle =>
      'Das Limit für kostenlose Projekte wurde erreicht';

  @override
  String get projectLimitMessage =>
      'Sie haben 4 kostenlose Projekte. Sehen Sie sich die vollständige Anzeige an, um ein weiteres Projekt zu erstellen, oder upgraden Sie auf Premium für unbegrenzte Projekte.';

  @override
  String get projectRewardRequired =>
      'Sehen Sie sich eine Anzeige vollständig an, um ein weiteres Projekt freizuschalten. Wenn keine Anzeige verfügbar ist, versuchen Sie es später erneut oder upgraden Sie auf Premium.';
}
