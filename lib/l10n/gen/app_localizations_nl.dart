// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'LandMeasure';

  @override
  String get navHome => 'Start';

  @override
  String get navSaved => 'Opgeslagen';

  @override
  String get navSettings => 'Instellingen';

  @override
  String get measurementTypeArea => 'Oppervlakte';

  @override
  String get measurementTypeDistance => 'Afstand';

  @override
  String get measurementTypeWalk => 'Wandelen';

  @override
  String get screenMeasureArea => 'Oppervlakte meten';

  @override
  String get screenMeasureDistance => 'Meet afstand';

  @override
  String get screenWalk => 'Lopen en meten';

  @override
  String get screenSave => 'Meting opslaan';

  @override
  String get screenDetail => 'Meetdetail';

  @override
  String get screenFullMap => 'Kaart';

  @override
  String get screenEdit => 'Meting bewerken';

  @override
  String get screenSaved => 'Opgeslagen metingen';

  @override
  String get screenSettings => 'Instellingen';

  @override
  String get screenUnits => 'Eenheden';

  @override
  String get screenMapStyle => 'Kaartstijl';

  @override
  String get screenLanguage => 'Taal';

  @override
  String get screenPaywall => 'Premium';

  @override
  String get ctaStartMeasuring => 'Begin met meten';

  @override
  String get ctaStartArea => 'Oppervlaktemeting starten';

  @override
  String get ctaStartDistance => 'Afstandsmeting starten';

  @override
  String get ctaStartWalk => 'Start loopmeting';

  @override
  String get ctaSaveMeasurement => 'Meting opslaan';

  @override
  String get ctaSaveRoute => 'Route opslaan';

  @override
  String get ctaPause => 'Pauze';

  @override
  String get ctaResume => 'Hervatten';

  @override
  String get ctaFinish => 'Voltooien';

  @override
  String get actionCancel => 'Annuleren';

  @override
  String get actionSave => 'Opslaan';

  @override
  String get actionDiscard => 'Verwerpen';

  @override
  String get actionDelete => 'Verwijderen';

  @override
  String get actionReset => 'Opnieuw instellen';

  @override
  String get actionOpenSettings => 'Instellingen openen';

  @override
  String get actionKeepRecording => 'Blijf opnemen';

  @override
  String get actionKeepEditing => 'Blijf bewerken';

  @override
  String get dialogResetTitle => 'Meting resetten?';

  @override
  String get dialogResetMessage => 'Hiermee worden alle punten verwijderd.';

  @override
  String get dialogDiscardDraftTitle => 'Dit concept weggooien?';

  @override
  String get dialogDiscardDraftMessage =>
      'Alle punten en niet-opgeslagen wijzigingen worden verwijderd.';

  @override
  String get dialogDeleteTitle => 'Meting verwijderen?';

  @override
  String get dialogDeleteMessage =>
      'Deze meting, de foto\'s en aantekeningen worden permanent verwijderd.';

  @override
  String get dialogFinishWalkTitle => 'Opname voltooien?';

  @override
  String get dialogFinishWalkMessage => 'GPS-tracking stopt.';

  @override
  String get dialogRenameTitle => 'Hernoem meting';

  @override
  String get dialogDiscardChangesTitle => 'Wijzigingen weggooien?';

  @override
  String get fabLayers => 'Kaartlagen';

  @override
  String get fabMyLocation => 'Mijn locatie';

  @override
  String get fabSearch => 'Plaats zoeken';

  @override
  String get fabCamera => 'Maak een foto';

  @override
  String get gpsReady => 'GPS gereed';

  @override
  String get gpsSearching => 'Zoeken naar GPS…';

  @override
  String get gpsLowAccuracy => 'Lage GPS-nauwkeurigheid';

  @override
  String get locationOff => 'Locatie is uitgeschakeld';

  @override
  String get locationOffMessage =>
      'Schakel locatie in om uw wandeling vast te leggen.';

  @override
  String get mapOffline =>
      'Kaartverbinding niet beschikbaar: uw punten zijn veilig';

  @override
  String get emptyNoMeasurementsTitle => 'Nog geen metingen';

  @override
  String get emptyNoMeasurementsMessage =>
      'Meet uw eerste stuk land en het zal hier verschijnen.';

  @override
  String get languageSystem => 'Systeemstandaard';

  @override
  String get measureHintCrosshair =>
      'Verplaats de kaart om het draadkruis te plaatsen en tik vervolgens op Punt toevoegen.';

  @override
  String get measureHintTap =>
      'Tik op de kaart om punten rond de grens toe te voegen.';

  @override
  String get toolbarUndo => 'Ongedaan maken';

  @override
  String get toolbarAddPoint => 'Punt toevoegen';

  @override
  String get toolbarClose => 'Vorm sluiten';

  @override
  String get toolbarReset => 'Opnieuw instellen';

  @override
  String get toolbarAddAtMyLocation => 'Voeg een punt toe op mijn locatie';

  @override
  String get resultArea => 'Oppervlakte';

  @override
  String get resultPerimeter => 'Omtrek';

  @override
  String get resultAreaNeedsPoints =>
      'Voeg minimaal 3 punten toe om de oppervlakte te berekenen';

  @override
  String resultPointCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punten',
      one: '1 punt',
    );
    return '$_temp0';
  }

  @override
  String get edgesCross => 'Randen kruisen elkaar: gebied is mogelijk onjuist';

  @override
  String get menuMore => 'Meer opties';

  @override
  String get menuInputCrosshair => 'Voeg toe met draadkruis';

  @override
  String get menuInputTap => 'Voeg toe door op de kaart te tikken';

  @override
  String get menuShowEdgeLabels => 'Toon randlengtes';

  @override
  String pointLabel(int number) {
    return 'Punt $number';
  }

  @override
  String get pointDelete => 'Punt verwijderen';

  @override
  String get pointDeselect => 'Klaar';

  @override
  String gpsLowAccuracyAdded(int meters) {
    return 'De GPS-nauwkeurigheid is laag (±$meters m). Het punt is toch toegevoegd.';
  }

  @override
  String get locationUnavailable =>
      'Kan je locatie niet ophalen. Probeer het opnieuw buitenshuis.';

  @override
  String get locationPermissionDenied =>
      'Locatietoegang is uitgeschakeld. Je kunt nog steeds meten door de kaart te verplaatsen.';

  @override
  String get locationServiceOff => 'Locatie is uitgeschakeld op dit apparaat.';

  @override
  String get mapLayersTitle => 'Kaarttype';

  @override
  String get mapStyleStandard => 'Standaard';

  @override
  String get mapStyleSatellite => 'Satelliet';

  @override
  String get mapStyleTerrain => 'Terrein';

  @override
  String get mapStyleHybrid => 'Hybride';

  @override
  String get draftSaveFailed =>
      'Kan je punten niet opslaan. Bij de volgende wijziging worden ze opnieuw opgeslagen.';

  @override
  String get menuHelp => 'Hulp';

  @override
  String get actionGotIt => 'Begrepen';

  @override
  String get helpTitleArea => 'Hoe het gebied te meten';

  @override
  String get helpTitleDistance => 'Hoe afstand te meten';

  @override
  String get helpTitleWalk => 'Hoe te lopen en te meten';

  @override
  String get helpAreaSummary => 'Voeg punten toe rond de grens van je land.';

  @override
  String get helpDistanceSummary =>
      'Voeg punten toe langs de route die u wilt meten.';

  @override
  String get helpWalkSummary =>
      'Loop rond de grens terwijl LandMeasure uw GPS-pad registreert.';

  @override
  String get helpPhotoTip =>
      'Gebruik foto\'s om oriëntatiepunten, grenzen of locatieomstandigheden te documenteren.';

  @override
  String get helpAccuracyNote =>
      'De nauwkeurigheid van GPS- en kaartmetingen kan variëren, afhankelijk van het apparaat, de kaartbeelden en de omgeving.';

  @override
  String get helpAreaStep1 =>
      'Verplaats de kaart zodat het draadkruis op een hoek staat en tik vervolgens op **Punt toevoegen**.';

  @override
  String get helpAreaStep2 =>
      'Voeg minimaal 3 punten rond de grens toe. Versleep een punt om het aan te passen.';

  @override
  String get helpAreaStep3 =>
      'Tik op **Sluiten** om de vorm te voltooien en vervolgens op **Meting opslaan**.';

  @override
  String get helpDistanceStep1 =>
      'Plaats het draadkruis op het begin van uw route en tik op **Punt toevoegen**.';

  @override
  String get helpDistanceStep2 =>
      'Blijf punten toevoegen langs de route. Elke segmentlengte wordt op de kaart weergegeven.';

  @override
  String get helpDistanceStep3 => 'Tik op **Route opslaan** als je klaar bent.';

  @override
  String get helpWalkStep1 =>
      'Wacht op **GPS gereed** en tik vervolgens op **Begin met lopen**.';

  @override
  String get helpWalkStep2 =>
      'Loop langs de grens. Gebruik **Pauze** als u wilt stoppen.';

  @override
  String get helpWalkStep3 =>
      'Keer terug naar uw startpunt en tik op **Voltooien** om het gebied te berekenen.';

  @override
  String get helpTipGpsPoint =>
      'Tip: tik op 📍 om een ​​punt toe te voegen aan uw huidige GPS-locatie.';

  @override
  String get helpTipWalk =>
      'Tip: blijf in open gebieden voor een betere GPS-nauwkeurigheid.';

  @override
  String get resultDistance => 'Afstand';

  @override
  String get resultDistanceNeedsPoints =>
      'Voeg minimaal 2 punten toe om de afstand te meten';

  @override
  String resultSegmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segmenten',
      one: '1 segment',
    );
    return '$_temp0';
  }

  @override
  String get segmentsTitle => 'Segmenten';

  @override
  String draftSavedSnack(int count, String type) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Concept opgeslagen · $type · $count punten',
      one: 'Concept opgeslagen · $type · 1 punt',
    );
    return '$_temp0';
  }

  @override
  String get searchHint => 'Adres, coördinaten of Google Maps-link';

  @override
  String get searchAction => 'Zoekopdracht';

  @override
  String get searchRecent => 'Recente zoekopdrachten';

  @override
  String get searchNoResults =>
      'Geen plaatsen gevonden. Probeer coördinaten of een Google Maps-link.';

  @override
  String get searchNeedsInternet =>
      'Voor het zoeken naar een adres is een internetverbinding nodig.';

  @override
  String get searchUnavailable =>
      'Adreszoeken is niet beschikbaar op dit apparaat. Probeer coördinaten of een Google Maps-link.';

  @override
  String get searchClear => 'Duidelijk';

  @override
  String get searchFailed =>
      'Kan dit adres momenteel niet doorzoeken. Probeer coördinaten of een Google Maps-link.';

  @override
  String get ctaStartWalking => 'Begin met lopen';

  @override
  String get walkReadyHelper => 'Loop rond de grens om uw pad vast te leggen.';

  @override
  String get keepScreenOn => 'Houd het scherm ingeschakeld';

  @override
  String get walkRecording => 'GPS opnemen…';

  @override
  String get walkPaused => 'Gepauzeerd';

  @override
  String get walkPausedMessage =>
      'Tik op Hervatten om door te gaan waar u bent.';

  @override
  String gpsAccuracyShort(int meters) {
    return '±$meters m';
  }

  @override
  String gpsLowAccuracyMessage(int meters) {
    return 'Nauwkeurigheid ±$meters m — punten worden pas geregistreerd als deze verbetert. Ga naar een open ruimte.';
  }

  @override
  String get locationDeniedTitle => 'Locatietoegang is uitgeschakeld';

  @override
  String get locationDeniedMessage =>
      'Geef de locatie toestemming om uw wandeling vast te leggen.';

  @override
  String get actionAllow => 'Toestaan';

  @override
  String get actionNotNow => 'Niet nu';

  @override
  String get mockLocationDetected =>
      'Namaaklocatie gedetecteerd – deze posities worden niet vastgelegd.';

  @override
  String get walkCloseToStart =>
      'Dicht bij start — eindig om de oppervlakte te berekenen';

  @override
  String get walkNotClosed => 'Route niet afgesloten — alleen afstand';

  @override
  String get walkKeepWalking =>
      'Loop terug naar je startpunt om de lus te sluiten.';

  @override
  String get resultDuration => 'Duur';

  @override
  String get walkNotificationTitle => 'LandMeasure registreert uw meting';

  @override
  String get walkNotificationText => 'Tik om terug te keren naar je wandeling.';

  @override
  String get walkNotificationChannel => 'Wandelopname';

  @override
  String get walkRecordingBack =>
      'Opname bezig. Pauzeer of voltooi voordat u vertrekt.';

  @override
  String get walkPauseAndLeave => 'Pauzeer en vertrek';

  @override
  String get walkStartFailed =>
      'Kan de opname niet starten. Probeer het opnieuw.';

  @override
  String get batteryHintTitle => 'Laat LandMeasure op de achtergrond draaien';

  @override
  String get batteryHintMessage =>
      'Sommige telefoons stoppen apps wanneer het scherm is uitgeschakeld. Om uw wandeling te blijven opnemen, opent u Instellingen → Batterij en kiest u \"Geen beperkingen\" (of \"Onbeperkt\") voor LandMeasure.';

  @override
  String get fabRecenter => 'Opnieuw centreren';

  @override
  String get homeHeroSubtitle => 'Kies een methode om uw land te meten.';

  @override
  String get homeContinueTitle => 'Ga door met meten';

  @override
  String get homeSeeAllDrafts => 'Bekijk alle concepten';

  @override
  String get homeRecentTitle => 'Recente metingen';

  @override
  String get homeRecentEmptyTitle => 'Geen recente metingen';

  @override
  String get homeRecentEmptyMessage => 'Hier verschijnen opgeslagen metingen.';

  @override
  String get actionSeeAll => 'Bekijk alles';

  @override
  String get untitledArea => 'Naamloos gebied';

  @override
  String get untitledDistance => 'Naamloze afstand';

  @override
  String get untitledWalk => 'Naamloze wandeling';

  @override
  String get draftLabel => 'Voorlopige versie';

  @override
  String get walkFinishedNotSaved => 'Voltooid · niet opgeslagen';

  @override
  String lastEdited(String time) {
    return 'Laatst bewerkt $time';
  }

  @override
  String get timeJustNow => 'zojuist';

  @override
  String timeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min geleden',
      one: '1 min geleden',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uur geleden',
      one: '1 uur geleden',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen geleden',
      one: 'gisteren',
    );
    return '$_temp0';
  }

  @override
  String get savedSearchHint => 'Zoek op naam';

  @override
  String get savedSearchOpen => 'Zoekopdracht';

  @override
  String get savedSearchClose => 'Zoekopdracht sluiten';

  @override
  String get filterAll => 'Alle';

  @override
  String filterWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String savedDraftsTitle(int count) {
    return 'Concepten ($count)';
  }

  @override
  String get savedNoResults => 'Geen metingen gevonden.';

  @override
  String get menuRename => 'Hernoemen';

  @override
  String get menuExport => 'Exporteren';

  @override
  String get measurementDeleted => 'Meting verwijderd';

  @override
  String get draftDiscarded => 'Concept weggegooid';

  @override
  String get exportTitle => 'Exporteren';

  @override
  String get renameHint => 'Naam van meting';

  @override
  String get saveNameLabel => 'Naam';

  @override
  String get saveNameRequired => 'Naam is vereist';

  @override
  String get saveNotesLabel => 'Opmerkingen';

  @override
  String get saveNotesHint =>
      'Grenzen, eigenaar, oriëntatiepunten… (optioneel)';

  @override
  String get saveTypeLabel => 'Type';

  @override
  String get saveFailed => 'Kan niet opslaan. Probeer het opnieuw.';

  @override
  String get saveLimitReached =>
      'U heeft de vrije limiet van opgeslagen metingen bereikt. Deze blijft in je concepten.';

  @override
  String get saveNotFound => 'Deze meting bestaat niet meer.';

  @override
  String photosTitle(int count) {
    return 'Locatiefoto\'s ($count)';
  }

  @override
  String get actionClose => 'Sluiten';

  @override
  String get resultPoints => 'Punten';

  @override
  String get resultSegments => 'Segmenten';

  @override
  String get resultAvgPace => 'Gemiddeld tempo';

  @override
  String paceValue(String time, String unit) {
    return '$time /$unit';
  }

  @override
  String get notesTitle => 'Opmerkingen';

  @override
  String get notesEmpty => 'Geen aantekeningen';

  @override
  String get actionEdit => 'Bewerken';

  @override
  String get actionExport => 'Exporteren';

  @override
  String get detailOpenMap => 'Kaart openen';

  @override
  String savedOn(String date) {
    return '$date opgeslagen';
  }

  @override
  String get addPhotoTitle => 'Foto toevoegen';

  @override
  String get addPhotoCamera => 'Maak een foto';

  @override
  String get addPhotoGallery => 'Kies uit Galerij';

  @override
  String addPhotoForPoint(int number) {
    return 'Voor punt $number';
  }

  @override
  String get addPhotoTile => 'Foto toevoegen';

  @override
  String get photoAddFailed =>
      'Kan de foto niet toevoegen. Probeer het opnieuw.';

  @override
  String get photoRemoved => 'Foto verwijderd';

  @override
  String get actionUndo => 'Ongedaan maken';

  @override
  String get photoLimitReached =>
      'U heeft de vrije limiet voor het aantal foto\'s voor deze meting bereikt.';

  @override
  String get photoDeleteTitle => 'Foto verwijderen?';

  @override
  String get photoDeleteMessage => 'Deze foto wordt verwijderd uit de meting.';

  @override
  String get photoAttachTitle => 'Deze foto bij de meting voegen?';

  @override
  String get photoAttachMessage =>
      '\'Foto\'s opslaan in meting\' is uitgeschakeld in Instellingen.';

  @override
  String get actionAttach => 'Bijvoegen';

  @override
  String get photoWaitForStart => 'Begin te lopen om foto\'s toe te voegen.';

  @override
  String photoCounter(int index, int total) {
    return '$index / $total';
  }

  @override
  String get photoShare => 'Delen';

  @override
  String photoOpen(int number) {
    return 'Foto $number openen';
  }

  @override
  String get photoRemove => 'Foto verwijderen';

  @override
  String get pointPhoto => 'Foto';

  @override
  String get cameraPermissionTitle => 'Cameratoegang toestaan';

  @override
  String get cameraPermissionMessage =>
      'Maak foto\'s van oriëntatiepunten, grenzen en omstandigheden ter plaatse en bewaar ze bij uw meting.';

  @override
  String get cameraPermissionDenied =>
      'Cameratoegang is uitgeschakeld. Je kunt het inschakelen in Instellingen.';

  @override
  String get actionContinue => 'Doorgaan';

  @override
  String get notesEditTitle => 'Bewerk notities';

  @override
  String get notesAdd => 'Voeg notities toe';

  @override
  String get editTabResult => 'Resultaat';

  @override
  String get editTabDetails => 'Details';

  @override
  String get ctaSaveChanges => 'Wijzigingen opslaan';

  @override
  String get dialogDiscardChangesMessage =>
      'Uw wijzigingen in deze meting gaan verloren.';

  @override
  String get changesSaved => 'Wijzigingen opgeslagen';

  @override
  String get menuReopenShape => 'Vorm opnieuw openen';

  @override
  String get exportKml => 'KML — Google Earth';

  @override
  String get exportKmlSubtitle =>
      'Vorm- en fotopunten voor Google Earth en GIS-apps';

  @override
  String get exportCsv => 'CSV-Excel';

  @override
  String get exportCsvSubtitle => 'Elk punt met coördinaten, voor spreadsheets';

  @override
  String get exportPreparing => 'Bestand voorbereiden…';

  @override
  String get exportFailed => 'Kan niet exporteren. Probeer het opnieuw.';

  @override
  String get exportLimitReached =>
      'De gratis KML-export van vandaag is al gebruikt. CSV-export blijft gratis.';

  @override
  String get landValueTitle => 'Grondwaarde';

  @override
  String get landValueAdd => 'Voeg grondwaarde toe';

  @override
  String get landValueUnitPrice => 'Eenheidsprijs';

  @override
  String get landValueUnit => 'Per';

  @override
  String landValueEstimated(String value) {
    return 'Geschatte waarde ≈ $value';
  }

  @override
  String landValueRate(String price, String unit) {
    return '$price / $unit';
  }

  @override
  String get landValueNeedsArea =>
      'De grondwaarde heeft een oppervlakte nodig (sluit de vorm).';

  @override
  String get landValueRemove => 'Verwijderen';

  @override
  String get landValueInvalid => 'Voer een prijs in die groter is dan 0';

  @override
  String get resultValue => 'Waarde';

  @override
  String get settingsSubtitle => 'Eenheden, kaart- en app-voorkeuren';

  @override
  String get settingsSectionPreferences => 'Meetvoorkeuren';

  @override
  String get settingsSectionMeasureMap => 'Meting en kaart';

  @override
  String get settingsSectionSupport => 'Ondersteuning en juridisch';

  @override
  String get settingsDefaultMode => 'Standaard meettype';

  @override
  String get settingsDefaultModeHint =>
      'Geselecteerd op Home wanneer je de app opent.';

  @override
  String get settingsGpsAccuracy => 'GPS-nauwkeurigheidsweergave';

  @override
  String get settingsGpsAccuracySubtitle =>
      'Toon ±m en de nauwkeurigheidscirkel tijdens het lopen';

  @override
  String get settingsAutoCenter => 'Kaart automatisch centreren';

  @override
  String get settingsAutoCenterSubtitle =>
      'Open kaarten op uw locatie en volg u tijdens het wandelen';

  @override
  String get settingsSavePhotos => 'Foto\'s opslaan in meting';

  @override
  String get settingsSavePhotosSubtitle =>
      'Voeg nieuwe foto\'s toe zonder te vragen';

  @override
  String get settingsKeepAwake => 'Scherm aanhouden';

  @override
  String get settingsKeepAwakeSubtitle => 'Scherm blijft aan tijdens het meten';

  @override
  String get settingsHelpFeedback => 'Hulp en feedback';

  @override
  String get settingsRateUs => 'Beoordeel ons';

  @override
  String get settingsPrivacyPolicy => 'Privacybeleid';

  @override
  String get settingsTerms => 'Gebruiksvoorwaarden';

  @override
  String settingsVersion(String version, String build) {
    return 'Versie $version ($build)';
  }

  @override
  String get feedbackSubject => 'Feedback over landmetingen';

  @override
  String feedbackNoEmailApp(String email) {
    return 'Geen e-mailapp gevonden. Schrijf ons op $email.';
  }

  @override
  String get linkOpenFailed => 'Kan de link niet openen. Probeer het opnieuw.';

  @override
  String get unitsDistanceTitle => 'Afstand';

  @override
  String get unitsAreaTitle => 'Oppervlakte';

  @override
  String get unitsSecondary => 'Toon secundaire eenheid';

  @override
  String unitsSecondaryExample(String example) {
    return 'bijv. $example';
  }

  @override
  String get unitsNote =>
      'Nieuwe metingen gebruiken deze eenheden. Bij elke meting kan ook de eenheid van het resultaat worden gewijzigd.';

  @override
  String get unitMeters => 'Meters';

  @override
  String get unitKilometers => 'Kilometers';

  @override
  String get unitFeet => 'Voet';

  @override
  String get unitMiles => 'Mijlen';

  @override
  String get unitSquareMeters => 'Vierkante meter';

  @override
  String get unitHectares => 'Hectaren';

  @override
  String get unitAcres => 'Acres';

  @override
  String get unitSquareFeet => 'Vierkante voet';

  @override
  String get mapStyleNote =>
      'Met deze kaart worden nieuwe metingen geopend. U kunt van kaart wisselen met de knop Lagen.';

  @override
  String get actionApply => 'Toepassen';

  @override
  String get languageAppLanguages => 'App-talen';

  @override
  String get languageMachineNote =>
      'Deze taal is machinaal vertaald en kan fouten bevatten.';

  @override
  String get locationPermissionTitle => 'Locatietoegang toestaan';

  @override
  String get locationPermissionMessage =>
      'LandMeasure gebruikt uw locatie om op de kaart te laten zien waar u zich bevindt. Het blijft op je telefoon staan.';

  @override
  String get locationPermissionMeasureMessage =>
      'Laat op de kaart zien waar u zich bevindt en voeg punten toe waar u zich bevindt. Zonder kunt u nog steeds meten door de kaart te verplaatsen.';

  @override
  String get locationPermissionWalkMessage =>
      'Walk & Measure registreert uw pad met GPS terwijl dit scherm geopend is. Uw locatie blijft op uw telefoon.';

  @override
  String get locationPermissionBlocked =>
      'Locatietoegang is uitgeschakeld voor LandMeasure. Schakel het in Instellingen in om uw positie te gebruiken.';

  @override
  String get notificationPermissionTitle => 'Meldingen toestaan';

  @override
  String get notificationPermissionMessage =>
      'Sta meldingen toe zodat u de opnamestatus kunt zien terwijl uw scherm is uitgeschakeld.';

  @override
  String get actionRetry => 'Opnieuw proberen';

  @override
  String get paywallTitle => 'Meten zonder grenzen';

  @override
  String get paywallSubtitle =>
      'Ontgrendel onbeperkte projecten en premiumfuncties.';

  @override
  String get paywallBenefitNoAds => 'Geen advertenties';

  @override
  String get paywallBenefitSaves => 'Onbeperkt opgeslagen metingen';

  @override
  String get paywallBenefitPhotos => 'Onbeperkt foto\'s per meting';

  @override
  String get paywallBenefitKml => 'KML-export op elk gewenst moment';

  @override
  String paywallStartTrial(int days) {
    return 'Start een gratis proefperiode van $days dagen';
  }

  @override
  String paywallTermsTrial(int days, String price, String store) {
    return '$days dagen gratis, daarna $price/jaar. Wordt automatisch verlengd — op elk moment opzegbaar in $store.';
  }

  @override
  String paywallTermsYearly(String price, String store) {
    return '$price/jaar. Wordt automatisch verlengd. Je kunt op elk gewenst moment opzeggen in $store.';
  }

  @override
  String paywallTermsMonthly(String price, String store) {
    return '$price/maand. Wordt automatisch verlengd. Je kunt op elk gewenst moment opzeggen in $store.';
  }

  @override
  String get paywallRestore => 'Aankopen herstellen';

  @override
  String get paywallWelcome => 'Welkom bij Premium!';

  @override
  String get paywallPending =>
      'Betaling in behandeling. Premium wordt ontgrendeld zodra het is voltooid.';

  @override
  String get paywallPurchaseFailed =>
      'De aankoop is mislukt. Er zijn geen kosten in rekening gebracht.';

  @override
  String get paywallRestored => 'Aankopen hersteld.';

  @override
  String get paywallNothingToRestore =>
      'Er is geen eerdere aankoop gevonden voor dit winkelaccount.';

  @override
  String get paywallRestoreFailed =>
      'Kan aankopen niet herstellen. Controleer uw verbinding en probeer het opnieuw.';

  @override
  String get paywallUnavailable =>
      'Plannen kunnen momenteel niet worden geladen. Controleer uw verbinding en probeer het opnieuw.';

  @override
  String get premiumActive => 'Premium actief';

  @override
  String get premiumActiveLifetime => 'Premium actief · Levenslang';

  @override
  String get premiumManage => 'Beheren';

  @override
  String get settingsPremiumTitle => 'LandMeasure Premium';

  @override
  String get settingsPremiumSubtitle =>
      'Geen advertenties, onbeperkt opslaan en foto\'s, KML op elk gewenst moment';

  @override
  String get settingsManageSubscription => 'Beheer abonnement';

  @override
  String get settingsPrivacyChoices => 'Privacy-keuzes';

  @override
  String get settingsAdInspector => 'Advertentieinspecteur (ontwikkelaar)';

  @override
  String get exportUnlockTitle =>
      'De gratis KML-export van vandaag is al gebruikt';

  @override
  String get exportUnlockMessage =>
      'Bekijk een korte advertentie om dit bestand te exporteren, of neem Premium voor onbeperkte KML-exports. CSV-export blijft gratis.';

  @override
  String get exportWatchAd => 'Bekijk een advertentie';

  @override
  String get exportGetPremium => 'Neem Premium';

  @override
  String get exportLoadingAd => 'Advertentie laden…';

  @override
  String get exportAdDismissed =>
      'Bekijk de advertentie tot het einde om deze export te ontgrendelen.';

  @override
  String get introNext => 'Volgende';

  @override
  String get introGetStarted => 'Aan de slag';

  @override
  String get introAreaTitle => 'Meet het gebied eenvoudig';

  @override
  String get introAreaBody =>
      'Markeer punten op de kaart om binnen enkele seconden land, velden en andere gebieden te meten.';

  @override
  String get introDistanceTitle => 'Meet afstand en routes';

  @override
  String get introDistanceBody =>
      'Meet afstanden in rechte lijnen of volg uw route terwijl u buiten loopt.';

  @override
  String get introFieldTitle => 'Gemaakt voor echt veldwerk';

  @override
  String get introFieldBody =>
      'Meet eenvoudig boerderijen, percelen, eigendommen en buitenterreinen.';

  @override
  String paywallTrialTitle(int days) {
    return 'Gratis proefperiode van $days dagen';
  }

  @override
  String paywallThenMonthly(String price) {
    return 'Dan $price/maand';
  }

  @override
  String get paywallMonthlyTitle => 'Maandplan';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price / maand';
  }

  @override
  String get paywallYearlyTitle => 'Jaarplan';

  @override
  String paywallYearlyOnly(String price) {
    return 'Slechts $price per jaar';
  }

  @override
  String get paywallBestPrice => 'Beste prijs';

  @override
  String get paywallMostPopular => 'Meest populair';

  @override
  String get paywallStartFreeTrial => 'Gratis proefperiode starten';

  @override
  String paywallTrialThenYearly(int days, String price) {
    return '$days dagen gratis, daarna $price/jaar';
  }

  @override
  String paywallPricePerYear(String price) {
    return '$price/jaar';
  }

  @override
  String get paywallCancelAnytime => 'Annuleer op elk gewenst moment';

  @override
  String paywallTermsTrialMonthly(int days, String price, String store) {
    return '$days dagen gratis, daarna $price/maand. Wordt automatisch verlengd. Je kunt op elk gewenst moment opzeggen in $store.';
  }

  @override
  String get premiumPromptTitle => 'Ga voor Premium';

  @override
  String premiumPromptPhotos(int count) {
    return 'Je kunt gratis maximaal $count-foto\'s aan een meting toevoegen. Upgrade naar Premium om meer toe te voegen.';
  }

  @override
  String get premiumPromptUpgrade => 'Upgraden';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get languageChooseTitle => 'Kies uw taal';

  @override
  String premiumPromptMapStyleReward(String style) {
    return '$style-kaarten zijn een Premium-functie. Bekijk een korte advertentie om deze te gebruiken totdat u de app sluit, of upgrade voorgoed.';
  }

  @override
  String mapStyleUnlocked(String style) {
    return '$style-kaart ontgrendeld totdat u de app sluit.';
  }

  @override
  String get mapStyleAdDismissed =>
      'Bekijk de advertentie tot het einde om deze kaart te ontgrendelen.';

  @override
  String get pdfReportTitleArea => 'Landmetingsrapport';

  @override
  String get pdfReportTitleDistance => 'Afstandsmetingsrapport';

  @override
  String get pdfReportTitleWalk => 'Loopmetingsrapport';

  @override
  String get pdfReportSubtitle =>
      'Geëxporteerde samenvatting van een opgeslagen meting';

  @override
  String get pdfHeaderLabel => 'Meetrapport';

  @override
  String get pdfFooterGenerated => 'Gegenereerd door LandMeasure';

  @override
  String get pdfFooterEstimate =>
      'GPS-/kaartmetingen zijn schattingen en kunnen per apparaat en omgeving verschillen.';

  @override
  String pdfPage(int page, int pages) {
    return 'Pagina $page van $pages';
  }

  @override
  String get pdfName => 'Naam van meting';

  @override
  String get pdfType => 'Type';

  @override
  String get pdfDateSaved => 'Datum opgeslagen';

  @override
  String get pdfReportId => 'Rapport-ID';

  @override
  String get pdfSummary => 'Samenvatting van metingen';

  @override
  String get pdfArea => 'Oppervlakte';

  @override
  String get pdfPerimeter => 'Omtrek';

  @override
  String get pdfDistance => 'Afstand';

  @override
  String get pdfDuration => 'Duur';

  @override
  String get pdfPoints => 'Punten';

  @override
  String get pdfSegments => 'Segmenten';

  @override
  String get pdfMethod => 'Methode';

  @override
  String get pdfSubBoundaryVertices => 'Grenshoekpunten';

  @override
  String get pdfSubRoutePoints => 'Routepunten';

  @override
  String get pdfSubTrackPoints => 'GPS-trackpunten';

  @override
  String get pdfSubSegments => 'Tussen punten';

  @override
  String get pdfMethodMapPoints => 'Kaartpunten';

  @override
  String get pdfMethodPolygon => 'Handmatige veelhoek';

  @override
  String get pdfMethodRoute => 'Handmatig traject';

  @override
  String get pdfAreaNotClosed => 'Niet gesloten';

  @override
  String get pdfAreaNotClosedSub => 'Route vormde geen lus';

  @override
  String get pdfMapBoundary => 'Kaart en vorm';

  @override
  String get pdfMapCaption =>
      'Schematische voorstelling van de gemeten vorm · Het noorden is boven';

  @override
  String get pdfCenter => 'Middelpuntcoördinaten';

  @override
  String get pdfMapStyle => 'Kaartstijl';

  @override
  String get pdfDisplayUnits => 'Weergave-eenheden';

  @override
  String get pdfCoordinates => 'Coördinaten';

  @override
  String get pdfCoordinatesHint =>
      'De punten worden weergegeven in de volgorde waarin ze zijn gemeten.';

  @override
  String get pdfColPoint => 'Punt';

  @override
  String get pdfColLatitude => 'Breedtegraad';

  @override
  String get pdfColLongitude => 'Lengtegraad';

  @override
  String get pdfColSegment => 'Segment';

  @override
  String get pdfColNote => 'Opmerking';

  @override
  String get pdfNoteStart => 'Begin';

  @override
  String get pdfNoteEnd => 'Einde';

  @override
  String get pdfNotePhoto => 'Foto bijgevoegd';

  @override
  String pdfMorePoints(int count) {
    return 'Nog $count punten worden niet getoond. Exporteer CSV om alle punten te krijgen.';
  }

  @override
  String get pdfNotes => 'Meetnotities';

  @override
  String get pdfPhotos => 'Terreinfoto’s';

  @override
  String pdfPhotoN(int n) {
    return 'Foto $n';
  }

  @override
  String pdfPhotoPoint(String point) {
    return 'Bij $point';
  }

  @override
  String pdfCaptured(String date) {
    return 'Gemaakt op $date';
  }

  @override
  String pdfMorePhotos(int count) {
    return 'Nog $count foto’s worden niet getoond.';
  }

  @override
  String get pdfExportInfo => 'Exportinformatie';

  @override
  String get pdfSource => 'Bron';

  @override
  String get pdfSourceAndroid => 'LandMeasure Android';

  @override
  String get pdfSourceIos => 'LandMeasure iOS';

  @override
  String get pdfCoordFormat => 'Coördinaat formaat';

  @override
  String get pdfCoordFormatValue => 'WGS 84 breedtegraad/lengtegraad';

  @override
  String get pdfExported => 'Geëxporteerd';

  @override
  String get pdfCompanion => 'Andere exportformaten';

  @override
  String get pdfAccuracyTitle => 'Nauwkeurigheidsmelding:';

  @override
  String get pdfAccuracyBody =>
      'Dit rapport vat metingen samen die zijn berekend op basis van kaartpunten en/of GPS-gegevens van het apparaat. Resultaten zijn schattingen en kunnen variëren afhankelijk van de nauwkeurigheid van het apparaat, satellietzichtbaarheid, kaartbeelden, terrein en waar grenspunten zijn geplaatst. Dit document is geen gecertificeerd kadastraal of legaal landonderzoek, tenzij afzonderlijk geverifieerd door een geautoriseerde onderzoeksprofessional.';

  @override
  String get exportPdf => 'PDF-rapport';

  @override
  String get exportPdfSubtitle =>
      'Printbaar rapport met kaart, coördinaten, aantekeningen en foto\'s';

  @override
  String get projectLimitTitle => 'Vrije projectlimiet bereikt';

  @override
  String get projectLimitMessage =>
      'Je hebt 4 gratis projecten. Bekijk een volledige advertentie om nog een project te maken, of upgrade naar Premium voor een onbeperkt aantal projecten.';

  @override
  String get projectRewardRequired =>
      'Bekijk een advertentie tot het einde om nog een project te ontgrendelen. Als er geen advertentie beschikbaar is, probeer het later opnieuw of upgrade naar Premium.';
}
