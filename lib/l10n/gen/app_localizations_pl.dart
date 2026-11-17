// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'LandMeasure';

  @override
  String get navHome => 'Główna';

  @override
  String get navSaved => 'Zapisane';

  @override
  String get navSettings => 'Ustawienia';

  @override
  String get measurementTypeArea => 'Powierzchnia';

  @override
  String get measurementTypeDistance => 'Dystans';

  @override
  String get measurementTypeWalk => 'Spacer';

  @override
  String get screenMeasureArea => 'Zmierz powierzchnię';

  @override
  String get screenMeasureDistance => 'Zmierz odległość';

  @override
  String get screenWalk => 'Spaceruj i mierz';

  @override
  String get screenSave => 'Zapisz pomiar';

  @override
  String get screenDetail => 'Szczegóły pomiaru';

  @override
  String get screenFullMap => 'Mapa';

  @override
  String get screenEdit => 'Edytuj pomiar';

  @override
  String get screenSaved => 'Zapisane pomiary';

  @override
  String get screenSettings => 'Ustawienia';

  @override
  String get screenUnits => 'Jednostki';

  @override
  String get screenMapStyle => 'Styl mapy';

  @override
  String get screenLanguage => 'Język';

  @override
  String get screenPaywall => 'Premium';

  @override
  String get ctaStartMeasuring => 'Rozpocznij pomiar';

  @override
  String get ctaStartArea => 'Rozpocznij pomiar powierzchni';

  @override
  String get ctaStartDistance => 'Rozpocznij pomiar odległości';

  @override
  String get ctaStartWalk => 'Rozpocznij pomiar spaceru';

  @override
  String get ctaSaveMeasurement => 'Zapisz pomiar';

  @override
  String get ctaSaveRoute => 'Zapisz trasę';

  @override
  String get ctaPause => 'Pauza';

  @override
  String get ctaResume => 'Wznów';

  @override
  String get ctaFinish => 'Zakończ';

  @override
  String get actionCancel => 'Anuluj';

  @override
  String get actionSave => 'Zapisz';

  @override
  String get actionDiscard => 'Odrzuć';

  @override
  String get actionDelete => 'Usuń';

  @override
  String get actionReset => 'Resetuj';

  @override
  String get actionOpenSettings => 'Otwórz Ustawienia';

  @override
  String get actionKeepRecording => 'Nagrywaj dalej';

  @override
  String get actionKeepEditing => 'Edytuj dalej';

  @override
  String get dialogResetTitle => 'Zresetować pomiar?';

  @override
  String get dialogResetMessage => 'Spowoduje to usunięcie wszystkich punktów.';

  @override
  String get dialogDiscardDraftTitle => 'Odrzucić tę wersję roboczą?';

  @override
  String get dialogDiscardDraftMessage =>
      'Wszystkie punkty i niezapisane zmiany zostaną usunięte.';

  @override
  String get dialogDeleteTitle => 'Usunąć pomiar?';

  @override
  String get dialogDeleteMessage =>
      'Ten pomiar, jego zdjęcia i notatki zostaną trwale usunięte.';

  @override
  String get dialogFinishWalkTitle => 'Zakończyć nagrywanie?';

  @override
  String get dialogFinishWalkMessage => 'Śledzenie GPS zostanie zatrzymane.';

  @override
  String get dialogRenameTitle => 'Zmień nazwę pomiaru';

  @override
  String get dialogDiscardChangesTitle => 'Odrzucić zmiany?';

  @override
  String get fabLayers => 'Warstwy mapy';

  @override
  String get fabMyLocation => 'Moja lokalizacja';

  @override
  String get fabSearch => 'Szukaj miejsca';

  @override
  String get fabCamera => 'Zrób zdjęcie';

  @override
  String get gpsReady => 'GPS gotowy';

  @override
  String get gpsSearching => 'Wyszukiwanie GPS…';

  @override
  String get gpsLowAccuracy => 'Niska dokładność GPS';

  @override
  String get locationOff => 'Lokalizacja jest wyłączona';

  @override
  String get locationOffMessage => 'Włącz lokalizację, aby nagrać swój spacer.';

  @override
  String get mapOffline =>
      'Połączenie z mapą niedostępne — Twoje punkty są bezpieczne';

  @override
  String get emptyNoMeasurementsTitle => 'Nie ma jeszcze żadnych pomiarów';

  @override
  String get emptyNoMeasurementsMessage =>
      'Zmierz swój pierwszy kawałek ziemi, a pojawi się on tutaj.';

  @override
  String get languageSystem => 'Domyślne systemowe';

  @override
  String get measureHintCrosshair =>
      'Przesuń mapę, aby umieścić celownik, a następnie dotknij opcji Dodaj punkt.';

  @override
  String get measureHintTap => 'Kliknij mapę, aby dodać punkty wokół granicy.';

  @override
  String get toolbarUndo => 'Cofnij';

  @override
  String get toolbarAddPoint => 'Dodaj punkt';

  @override
  String get toolbarClose => 'Zamknij kształt';

  @override
  String get toolbarReset => 'Resetuj';

  @override
  String get toolbarAddAtMyLocation => 'Dodaj punkt w mojej lokalizacji';

  @override
  String get resultArea => 'Powierzchnia';

  @override
  String get resultPerimeter => 'Obwód';

  @override
  String get resultAreaNeedsPoints =>
      'Dodaj co najmniej 3 punkty, aby obliczyć powierzchnię';

  @override
  String resultPointCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count punktu',
      many: '$count punktów',
      few: '$count punkty',
      one: '1 punkt',
    );
    return '$_temp0';
  }

  @override
  String get edgesCross =>
      'Krawędzie się krzyżują — obszar może być nieprawidłowy';

  @override
  String get menuMore => 'Więcej opcji';

  @override
  String get menuInputCrosshair => 'Dodaj za pomocą celownika';

  @override
  String get menuInputTap => 'Dodaj, dotykając mapy';

  @override
  String get menuShowEdgeLabels => 'Pokaż długości krawędzi';

  @override
  String pointLabel(int number) {
    return 'Punkt $number';
  }

  @override
  String get pointDelete => 'Usuń punkt';

  @override
  String get pointDeselect => 'Gotowe';

  @override
  String gpsLowAccuracyAdded(int meters) {
    return 'Dokładność GPS jest niska (±$meters m). W każdym razie punkt został dodany.';
  }

  @override
  String get locationUnavailable =>
      'Nie udało się uzyskać Twojej lokalizacji. Spróbuj ponownie na świeżym powietrzu.';

  @override
  String get locationPermissionDenied =>
      'Dostęp do lokalizacji jest wyłączony. Nadal możesz mierzyć, przesuwając mapę.';

  @override
  String get locationServiceOff =>
      'Lokalizacja jest wyłączona na tym urządzeniu.';

  @override
  String get mapLayersTitle => 'Typ mapy';

  @override
  String get mapStyleStandard => 'Standard';

  @override
  String get mapStyleSatellite => 'Satelita';

  @override
  String get mapStyleTerrain => 'Teren';

  @override
  String get mapStyleHybrid => 'Hybrydowy';

  @override
  String get draftSaveFailed =>
      'Nie udało się zapisać Twoich punktów. Zostaną zapisane ponownie przy następnej zmianie.';

  @override
  String get menuHelp => 'Pomoc';

  @override
  String get actionGotIt => 'Rozumiem';

  @override
  String get helpTitleArea => 'Jak zmierzyć powierzchnię';

  @override
  String get helpTitleDistance => 'Jak mierzyć odległość';

  @override
  String get helpTitleWalk => 'Jak chodzić i mierzyć';

  @override
  String get helpAreaSummary => 'Dodaj punkty wokół granicy swojej działki.';

  @override
  String get helpDistanceSummary =>
      'Dodaj punkty na trasie, którą chcesz zmierzyć.';

  @override
  String get helpWalkSummary =>
      'Obejdź granicę, podczas gdy LandMeasure zarejestruje Twoją ścieżkę GPS.';

  @override
  String get helpPhotoTip =>
      'Użyj zdjęć, aby udokumentować punkty orientacyjne, granice lub stan terenu.';

  @override
  String get helpAccuracyNote =>
      'Dokładność pomiarów GPS i map może się różnić w zależności od urządzenia, obrazów map i środowiska.';

  @override
  String get helpAreaStep1 =>
      'Przesuń mapę tak, aby celownik znalazł się w rogu, a następnie dotknij **Dodaj punkt**.';

  @override
  String get helpAreaStep2 =>
      'Dodaj co najmniej 3 punkty wokół granicy. Przeciągnij punkt, aby go dostosować.';

  @override
  String get helpAreaStep3 =>
      'Kliknij **Zamknij**, aby zakończyć kształt, a następnie **Zapisz pomiar**.';

  @override
  String get helpDistanceStep1 =>
      'Umieść celownik na początku trasy i dotknij **Dodaj punkt**.';

  @override
  String get helpDistanceStep2 =>
      'Kontynuuj dodawanie punktów na trasie. Długość każdego segmentu jest pokazana na mapie.';

  @override
  String get helpDistanceStep3 => 'Gdy skończysz, dotknij **Zapisz trasę**.';

  @override
  String get helpWalkStep1 =>
      'Poczekaj na **GPS gotowy**, a następnie dotknij **Zacznij chodzić**.';

  @override
  String get helpWalkStep2 =>
      'Idź wzdłuż granicy. Użyj **Pauza**, jeśli chcesz się zatrzymać.';

  @override
  String get helpWalkStep3 =>
      'Wróć do punktu początkowego i dotknij **Zakończ**, aby obliczyć powierzchnię.';

  @override
  String get helpTipGpsPoint =>
      'Wskazówka: dotknij 📍, aby dodać punkt w Twojej aktualnej lokalizacji GPS.';

  @override
  String get helpTipWalk =>
      'Wskazówka: pozostań na otwartych przestrzeniach, aby uzyskać lepszą dokładność GPS.';

  @override
  String get resultDistance => 'Dystans';

  @override
  String get resultDistanceNeedsPoints =>
      'Dodaj co najmniej 2 punkty, aby zmierzyć odległość';

  @override
  String resultSegmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count odcinka',
      many: '$count odcinków',
      few: '$count odcinki',
      one: '1 odcinek',
    );
    return '$_temp0';
  }

  @override
  String get segmentsTitle => 'Segmenty';

  @override
  String draftSavedSnack(int count, String type) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Szkic zapisany · $type · $count punktu',
      many: 'Szkic zapisany · $type · $count punktów',
      few: 'Szkic zapisany · $type · $count punkty',
      one: 'Szkic zapisany · $type · 1 punkt',
    );
    return '$_temp0';
  }

  @override
  String get searchHint => 'Adres, współrzędne lub link do Map Google';

  @override
  String get searchAction => 'Szukaj';

  @override
  String get searchRecent => 'Ostatnie wyszukiwania';

  @override
  String get searchNoResults =>
      'Nie znaleziono żadnych miejsc. Wypróbuj współrzędne lub link do Map Google.';

  @override
  String get searchNeedsInternet =>
      'Wyszukiwanie adresu wymaga połączenia z Internetem.';

  @override
  String get searchUnavailable =>
      'Wyszukiwanie adresów nie jest dostępne na tym urządzeniu. Wypróbuj współrzędne lub link do Map Google.';

  @override
  String get searchClear => 'Jasne';

  @override
  String get searchFailed =>
      'Nie udało się teraz przeszukać tego adresu. Wypróbuj współrzędne lub link do Map Google.';

  @override
  String get ctaStartWalking => 'Zacznij chodzić';

  @override
  String get walkReadyHelper =>
      'Obejdź granicę, aby zarejestrować swoją ścieżkę.';

  @override
  String get keepScreenOn => 'Pozostaw ekran włączony';

  @override
  String get walkRecording => 'Nagrywanie GPS…';

  @override
  String get walkPaused => 'Wstrzymano';

  @override
  String get walkPausedMessage =>
      'Kliknij opcję Wznów, aby kontynuować w miejscu, w którym się znajdujesz.';

  @override
  String gpsAccuracyShort(int meters) {
    return '±$meters m';
  }

  @override
  String gpsLowAccuracyMessage(int meters) {
    return 'Dokładność ±$meters m — punkty nie są rejestrowane, dopóki się nie poprawi. Przenieś się na otwartą przestrzeń.';
  }

  @override
  String get locationDeniedTitle => 'Dostęp do lokalizacji jest wyłączony';

  @override
  String get locationDeniedMessage =>
      'Zezwól lokalizacji na nagrywanie Twojego spaceru.';

  @override
  String get actionAllow => 'Zezwól';

  @override
  String get actionNotNow => 'Nie teraz';

  @override
  String get mockLocationDetected =>
      'Wykryto fikcyjną lokalizację — te pozycje nie są rejestrowane.';

  @override
  String get walkCloseToStart =>
      'Blisko początku — zakończ, aby obliczyć powierzchnię';

  @override
  String get walkNotClosed => 'Trasa nie zamknięta – tylko dystans';

  @override
  String get walkKeepWalking => 'Wróć na początek, aby zamknąć pętlę.';

  @override
  String get resultDuration => 'Czas trwania';

  @override
  String get walkNotificationTitle => 'LandMeasure rejestruje Twój pomiar';

  @override
  String get walkNotificationText => 'Kliknij, aby wrócić do spaceru.';

  @override
  String get walkNotificationChannel => 'Nagranie spaceru';

  @override
  String get walkRecordingBack =>
      'Trwa nagrywanie. Zatrzymaj lub zakończ przed wyjściem.';

  @override
  String get walkPauseAndLeave => 'Zatrzymaj i wyjdź';

  @override
  String get walkStartFailed =>
      'Nie udało się rozpocząć nagrywania. Spróbuj ponownie.';

  @override
  String get batteryHintTitle => 'Pozwól LandMeasure działać w tle';

  @override
  String get batteryHintMessage =>
      'Niektóre telefony zatrzymują aplikacje, gdy ekran jest wyłączony. Aby kontynuować nagrywanie spaceru, otwórz Ustawienia → Bateria i wybierz „Bez ograniczeń” (lub „Bez ograniczeń”) dla LandMeasure.';

  @override
  String get fabRecenter => 'Wyśrodkuj ponownie';

  @override
  String get homeHeroSubtitle => 'Wybierz metodę pomiaru swojej ziemi.';

  @override
  String get homeContinueTitle => 'Kontynuuj pomiar';

  @override
  String get homeSeeAllDrafts => 'Zobacz wszystkie wersje robocze';

  @override
  String get homeRecentTitle => 'Ostatnie pomiary';

  @override
  String get homeRecentEmptyTitle => 'Brak aktualnych pomiarów';

  @override
  String get homeRecentEmptyMessage => 'Tutaj pojawią się zapisane pomiary.';

  @override
  String get actionSeeAll => 'Zobacz wszystko';

  @override
  String get untitledArea => 'Obszar bez tytułu';

  @override
  String get untitledDistance => 'Odległość bez tytułu';

  @override
  String get untitledWalk => 'Spacer bez tytułu';

  @override
  String get draftLabel => 'Projekt';

  @override
  String get walkFinishedNotSaved => 'Zakończone · niezapisane';

  @override
  String lastEdited(String time) {
    return 'Ostatnio edytowany $time';
  }

  @override
  String get timeJustNow => 'właśnie';

  @override
  String timeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min temu',
      many: '$count min temu',
      few: '$count min temu',
      one: '1 min temu',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count godziny temu',
      many: '$count godzin temu',
      few: '$count godziny temu',
      one: '1 godzinę temu',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dni temu',
      one: 'wczoraj',
    );
    return '$_temp0';
  }

  @override
  String get savedSearchHint => 'Szukaj według nazwy';

  @override
  String get savedSearchOpen => 'Szukaj';

  @override
  String get savedSearchClose => 'Zamknij wyszukiwanie';

  @override
  String get filterAll => 'Wszystko';

  @override
  String filterWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String savedDraftsTitle(int count) {
    return 'Szkice ($count)';
  }

  @override
  String get savedNoResults => 'Nie znaleziono żadnych pomiarów.';

  @override
  String get menuRename => 'Przemianować';

  @override
  String get menuExport => 'Eksport';

  @override
  String get measurementDeleted => 'Pomiar usunięty';

  @override
  String get draftDiscarded => 'Wersja robocza odrzucona';

  @override
  String get exportTitle => 'Eksport';

  @override
  String get renameHint => 'Nazwa pomiaru';

  @override
  String get saveNameLabel => 'Nazwa';

  @override
  String get saveNameRequired => 'Imię i nazwisko jest wymagane';

  @override
  String get saveNotesLabel => 'Notatki';

  @override
  String get saveNotesHint =>
      'Granice, właściciel, punkty orientacyjne… (opcjonalnie)';

  @override
  String get saveTypeLabel => 'Typ';

  @override
  String get saveFailed => 'Nie udało się zapisać. Spróbuj ponownie.';

  @override
  String get saveLimitReached =>
      'Osiągnąłeś bezpłatny limit zapisanych pomiarów. Ten pozostanie w Twoich wersjach roboczych.';

  @override
  String get saveNotFound => 'Ten pomiar już nie istnieje.';

  @override
  String photosTitle(int count) {
    return 'Zdjęcia witryny ($count)';
  }

  @override
  String get actionClose => 'Zamknij';

  @override
  String get resultPoints => 'Punkty';

  @override
  String get resultSegments => 'Segmenty';

  @override
  String get resultAvgPace => 'Średnie tempo';

  @override
  String paceValue(String time, String unit) {
    return '$time /$unit';
  }

  @override
  String get notesTitle => 'Notatki';

  @override
  String get notesEmpty => 'Żadnych notatek';

  @override
  String get actionEdit => 'Edytuj';

  @override
  String get actionExport => 'Eksport';

  @override
  String get detailOpenMap => 'Otwórz mapę';

  @override
  String savedOn(String date) {
    return 'Zapisano $date';
  }

  @override
  String get addPhotoTitle => 'Dodaj zdjęcie';

  @override
  String get addPhotoCamera => 'Zrób zdjęcie';

  @override
  String get addPhotoGallery => 'Wybierz z Galerii';

  @override
  String addPhotoForPoint(int number) {
    return 'Dla punktu $number';
  }

  @override
  String get addPhotoTile => 'Dodaj zdjęcie';

  @override
  String get photoAddFailed => 'Nie udało się dodać zdjęcia. Spróbuj ponownie.';

  @override
  String get photoRemoved => 'Zdjęcie usunięte';

  @override
  String get actionUndo => 'Cofnij';

  @override
  String get photoLimitReached =>
      'Osiągnąłeś bezpłatny limit zdjęć dla tego pomiaru.';

  @override
  String get photoDeleteTitle => 'Usunąć zdjęcie?';

  @override
  String get photoDeleteMessage => 'To zdjęcie zostanie usunięte z pomiaru.';

  @override
  String get photoAttachTitle => 'Załączyć to zdjęcie do pomiaru?';

  @override
  String get photoAttachMessage =>
      'Opcja „Zapisz zdjęcia do pomiaru” jest wyłączona w Ustawieniach.';

  @override
  String get actionAttach => 'Dołącz';

  @override
  String get photoWaitForStart => 'Zacznij chodzić, aby dodać zdjęcia.';

  @override
  String photoCounter(int index, int total) {
    return '$index / $total';
  }

  @override
  String get photoShare => 'Udostępnij';

  @override
  String photoOpen(int number) {
    return 'Otwórz zdjęcie $number';
  }

  @override
  String get photoRemove => 'Usuń zdjęcie';

  @override
  String get pointPhoto => 'Zdjęcie';

  @override
  String get cameraPermissionTitle => 'Zezwól na dostęp do aparatu';

  @override
  String get cameraPermissionMessage =>
      'Rób zdjęcia punktów orientacyjnych, granic i warunków terenowych i przechowuj je wraz z pomiarami.';

  @override
  String get cameraPermissionDenied =>
      'Dostęp do aparatu jest wyłączony. Możesz to włączyć w Ustawieniach.';

  @override
  String get actionContinue => 'Kontynuuj';

  @override
  String get notesEditTitle => 'Edytuj notatki';

  @override
  String get notesAdd => 'Dodaj notatki';

  @override
  String get editTabResult => 'Wynik';

  @override
  String get editTabDetails => 'Bliższe dane';

  @override
  String get ctaSaveChanges => 'Zapisz zmiany';

  @override
  String get dialogDiscardChangesMessage =>
      'Zmiany wprowadzone w tym pomiarze zostaną utracone.';

  @override
  String get changesSaved => 'Zmiany zostały zapisane';

  @override
  String get menuReopenShape => 'Otwórz ponownie kształt';

  @override
  String get exportKml => 'KML — Google Earth';

  @override
  String get exportKmlSubtitle =>
      'Kształtuj i fotografuj punkty dla aplikacji Google Earth i GIS';

  @override
  String get exportCsv => 'CSV — Excel';

  @override
  String get exportCsvSubtitle =>
      'Każdy punkt ze współrzędnymi, dla arkuszy kalkulacyjnych';

  @override
  String get exportPreparing => 'Przygotowuję plik…';

  @override
  String get exportFailed => 'Nie udało się wyeksportować. Spróbuj ponownie.';

  @override
  String get exportLimitReached =>
      'Dzisiejszy bezpłatny eksport KML został już wykorzystany. Eksport CSV pozostaje bezpłatny.';

  @override
  String get landValueTitle => 'Wartość gruntu';

  @override
  String get landValueAdd => 'Dodaj wartość gruntu';

  @override
  String get landValueUnitPrice => 'Cena jednostkowa';

  @override
  String get landValueUnit => 'Za';

  @override
  String landValueEstimated(String value) {
    return 'Szacowana wartość ≈ $value';
  }

  @override
  String landValueRate(String price, String unit) {
    return '$price / $unit';
  }

  @override
  String get landValueNeedsArea =>
      'Wartość gruntu wymaga powierzchni (zamknij kształt).';

  @override
  String get landValueRemove => 'Usunąć';

  @override
  String get landValueInvalid => 'Wprowadź cenę większą niż 0';

  @override
  String get resultValue => 'Wartość';

  @override
  String get settingsSubtitle => 'Jednostki, mapy i preferencje aplikacji';

  @override
  String get settingsSectionPreferences => 'Preferencje pomiaru';

  @override
  String get settingsSectionMeasureMap => 'Pomiary i mapa';

  @override
  String get settingsSectionSupport => 'Wsparcie i kwestie prawne';

  @override
  String get settingsDefaultMode => 'Domyślny typ pomiaru';

  @override
  String get settingsDefaultModeHint =>
      'Wybrane na stronie głównej po otwarciu aplikacji.';

  @override
  String get settingsGpsAccuracy => 'Wyświetlacz dokładności GPS';

  @override
  String get settingsGpsAccuracySubtitle =>
      'Pokaż ±m i okrąg dokładności podczas chodzenia';

  @override
  String get settingsAutoCenter => 'Automatyczne centrowanie mapy';

  @override
  String get settingsAutoCenterSubtitle =>
      'Otwórz mapy w swojej lokalizacji i podążaj za tobą podczas spaceru';

  @override
  String get settingsSavePhotos => 'Zapisz zdjęcia do pomiaru';

  @override
  String get settingsSavePhotosSubtitle => 'Dołącz nowe zdjęcia bez pytania';

  @override
  String get settingsKeepAwake => 'Nie wygaszaj ekranu';

  @override
  String get settingsKeepAwakeSubtitle =>
      'Ekran pozostaje włączony podczas pomiaru';

  @override
  String get settingsHelpFeedback => 'Pomoc i opinie';

  @override
  String get settingsRateUs => 'Oceń nas';

  @override
  String get settingsPrivacyPolicy => 'Polityka prywatności';

  @override
  String get settingsTerms => 'Warunki użytkowania';

  @override
  String settingsVersion(String version, String build) {
    return 'Wersja $version ($build)';
  }

  @override
  String get feedbackSubject => 'Opinia LandMeasure';

  @override
  String feedbackNoEmailApp(String email) {
    return 'Nie znaleziono aplikacji e-mail. Napisz do nas na $email.';
  }

  @override
  String get linkOpenFailed =>
      'Nie udało się otworzyć linku. Spróbuj ponownie.';

  @override
  String get unitsDistanceTitle => 'Dystans';

  @override
  String get unitsAreaTitle => 'Powierzchnia';

  @override
  String get unitsSecondary => 'Pokaż jednostkę dodatkową';

  @override
  String unitsSecondaryExample(String example) {
    return 'np. $example';
  }

  @override
  String get unitsNote =>
      'Nowe pomiary wykorzystują te jednostki. Każdy pomiar może również zmieniać jednostki w wyniku.';

  @override
  String get unitMeters => 'Metry';

  @override
  String get unitKilometers => 'Kilometry';

  @override
  String get unitFeet => 'Stopy';

  @override
  String get unitMiles => 'Mile';

  @override
  String get unitSquareMeters => 'Metry kwadratowe';

  @override
  String get unitHectares => 'Hektary';

  @override
  String get unitAcres => 'Akry';

  @override
  String get unitSquareFeet => 'Stopy kwadratowe';

  @override
  String get mapStyleNote =>
      'Z tą mapą otwierają się nowe pomiary. Możesz przełączać dowolną mapę za pomocą przycisku Warstwy.';

  @override
  String get actionApply => 'Zastosuj';

  @override
  String get languageAppLanguages => 'Języki aplikacji';

  @override
  String get languageMachineNote =>
      'Ten język został przetłumaczony maszynowo i może zawierać błędy.';

  @override
  String get locationPermissionTitle => 'Zezwól na dostęp do lokalizacji';

  @override
  String get locationPermissionMessage =>
      'LandMeasure wykorzystuje Twoją lokalizację, aby pokazać, gdzie jesteś na mapie. Pozostaje w Twoim telefonie.';

  @override
  String get locationPermissionMeasureMessage =>
      'Pokaż, gdzie jesteś na mapie i dodaj punkty, w których stoisz. Bez tego nadal możesz mierzyć, przesuwając mapę.';

  @override
  String get locationPermissionWalkMessage =>
      'Walk & Measure rejestruje Twoją trasę za pomocą GPS, gdy ten ekran jest otwarty. Twoja lokalizacja pozostanie w Twoim telefonie.';

  @override
  String get locationPermissionBlocked =>
      'Dostęp do lokalizacji jest wyłączony dla LandMeasure. Włącz tę opcję w Ustawieniach, aby używać swojej pozycji.';

  @override
  String get notificationPermissionTitle => 'Zezwalaj na powiadomienia';

  @override
  String get notificationPermissionMessage =>
      'Zezwalaj na powiadomienia, aby móc zobaczyć stan nagrywania, gdy ekran jest wyłączony.';

  @override
  String get actionRetry => 'Spróbuj ponownie';

  @override
  String get paywallTitle => 'Mierz bez ograniczeń';

  @override
  String get paywallSubtitle =>
      'Odblokuj nieograniczoną liczbę projektów i funkcji premium.';

  @override
  String get paywallBenefitNoAds => 'Brak reklam';

  @override
  String get paywallBenefitSaves => 'Nieograniczona liczba zapisanych pomiarów';

  @override
  String get paywallBenefitPhotos => 'Nieograniczona liczba zdjęć na pomiar';

  @override
  String get paywallBenefitKml => 'Eksport KML w dowolnym momencie';

  @override
  String paywallStartTrial(int days) {
    return 'Rozpocznij $days-dniowy bezpłatny okres próbny';
  }

  @override
  String paywallTermsTrial(int days, String price, String store) {
    return '$days dni bezpłatnie, następnie $price/rok. Odnawia się automatycznie — anuluj w dowolnym momencie w $store.';
  }

  @override
  String paywallTermsYearly(String price, String store) {
    return '$price/rok. Odnawia się automatycznie — anuluj w dowolnym momencie w $store.';
  }

  @override
  String paywallTermsMonthly(String price, String store) {
    return '$price/miesiąc. Odnawia się automatycznie — anuluj w dowolnym momencie w $store.';
  }

  @override
  String get paywallRestore => 'Przywróć zakupy';

  @override
  String get paywallWelcome => 'Witamy w Premium!';

  @override
  String get paywallPending =>
      'Płatność oczekująca. Premium odblokowuje się zaraz po ukończeniu.';

  @override
  String get paywallPurchaseFailed =>
      'Zakup nie powiódł się. Nie pobrano żadnej opłaty.';

  @override
  String get paywallRestored => 'Zakupy przywrócone.';

  @override
  String get paywallNothingToRestore =>
      'Nie znaleziono żadnego poprzedniego zakupu dla tego konta sklepu.';

  @override
  String get paywallRestoreFailed =>
      'Nie udało się przywrócić zakupów. Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get paywallUnavailable =>
      'W tej chwili nie można wczytać planów. Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get premiumActive => 'Premium aktywne';

  @override
  String get premiumActiveLifetime => 'Premium aktywny · Dożywotni';

  @override
  String get premiumManage => 'Zarządzać';

  @override
  String get settingsPremiumTitle => 'LandMeasure Premium';

  @override
  String get settingsPremiumSubtitle =>
      'Brak reklam, nieograniczona liczba zapisów i zdjęć w formacie KML w dowolnym momencie';

  @override
  String get settingsManageSubscription => 'Zarządzaj subskrypcją';

  @override
  String get settingsPrivacyChoices => 'Wybory dotyczące prywatności';

  @override
  String get settingsAdInspector => 'Inspektor reklam (programista)';

  @override
  String get exportUnlockTitle =>
      'Dzisiejszy bezpłatny eksport KML został już wykorzystany';

  @override
  String get exportUnlockMessage =>
      'Obejrzyj krótką reklamę, aby wyeksportować ten plik, lub uzyskaj Premium na nieograniczony eksport KML. Eksport CSV pozostaje bezpłatny.';

  @override
  String get exportWatchAd => 'Obejrzyj reklamę';

  @override
  String get exportGetPremium => 'Przejdź na Premium';

  @override
  String get exportLoadingAd => 'Ładowanie reklamy…';

  @override
  String get exportAdDismissed =>
      'Obejrzyj reklamę do końca, aby odblokować ten eksport.';

  @override
  String get introNext => 'Następny';

  @override
  String get introGetStarted => 'Rozpocznij';

  @override
  String get introAreaTitle => 'Zmierz powierzchnię łatwo';

  @override
  String get introAreaBody =>
      'Zaznacz punkty na mapie, aby w ciągu kilku sekund zmierzyć teren, pola i inne obszary.';

  @override
  String get introDistanceTitle => 'Zmierz odległość i trasy';

  @override
  String get introDistanceBody =>
      'Mierz odległości w linii prostej lub śledź trasę podczas spaceru na świeżym powietrzu.';

  @override
  String get introFieldTitle => 'Stworzony do prawdziwej pracy w terenie';

  @override
  String get introFieldBody =>
      'Z łatwością mierz gospodarstwa, działki, nieruchomości i tereny zewnętrzne.';

  @override
  String paywallTrialTitle(int days) {
    return '$days-dniowy bezpłatny okres próbny';
  }

  @override
  String paywallThenMonthly(String price) {
    return 'Następnie $price / miesiąc';
  }

  @override
  String get paywallMonthlyTitle => 'Plan miesięczny';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price / miesiąc';
  }

  @override
  String get paywallYearlyTitle => 'Plan roczny';

  @override
  String paywallYearlyOnly(String price) {
    return 'Tylko $price rocznie';
  }

  @override
  String get paywallBestPrice => 'Najlepsza cena';

  @override
  String get paywallMostPopular => 'Najpopularniejszy';

  @override
  String get paywallStartFreeTrial => 'Rozpocznij bezpłatny okres próbny';

  @override
  String paywallTrialThenYearly(int days, String price) {
    return '$days-dniowy bezpłatny okres próbny, następnie $price/rok';
  }

  @override
  String paywallPricePerYear(String price) {
    return '$price/rok';
  }

  @override
  String get paywallCancelAnytime => 'Anuluj w dowolnym momencie';

  @override
  String paywallTermsTrialMonthly(int days, String price, String store) {
    return '$days dni bezpłatne, następnie $price/miesiąc. Odnawia się automatycznie — anuluj w dowolnym momencie w $store.';
  }

  @override
  String get premiumPromptTitle => 'Przejdź na Premium';

  @override
  String premiumPromptPhotos(int count) {
    return 'Możesz bezpłatnie dodać do $count zdjęć do pomiaru. Przejdź na Premium, aby dodać więcej.';
  }

  @override
  String get premiumPromptUpgrade => 'Przejdź na Premium';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get languageChooseTitle => 'Wybierz swój język';

  @override
  String premiumPromptMapStyleReward(String style) {
    return 'Mapy $style są funkcją Premium. Obejrzyj krótką reklamę, aby z niej korzystać, dopóki nie zamkniesz aplikacji lub nie dokonasz aktualizacji na stałe.';
  }

  @override
  String mapStyleUnlocked(String style) {
    return 'Mapa $style odblokowana do czasu zamknięcia aplikacji.';
  }

  @override
  String get mapStyleAdDismissed =>
      'Obejrzyj reklamę do końca, aby odblokować tę mapę.';

  @override
  String get pdfReportTitleArea => 'Raport z pomiaru gruntu';

  @override
  String get pdfReportTitleDistance => 'Raport z pomiaru odległości';

  @override
  String get pdfReportTitleWalk => 'Raport z pomiaru chodu';

  @override
  String get pdfReportSubtitle =>
      'Wyeksportowane podsumowanie zapisanego pomiaru';

  @override
  String get pdfHeaderLabel => 'Raport pomiarowy';

  @override
  String get pdfFooterGenerated => 'Wygenerowane przez LandMeasure';

  @override
  String get pdfFooterEstimate =>
      'Pomiary GPS/mapy są szacunkowe i mogą się różnić w zależności od urządzenia i środowiska.';

  @override
  String pdfPage(int page, int pages) {
    return 'Strona $page z $pages';
  }

  @override
  String get pdfName => 'Nazwa pomiaru';

  @override
  String get pdfType => 'Typ';

  @override
  String get pdfDateSaved => 'Data zapisania';

  @override
  String get pdfReportId => 'Identyfikator raportu';

  @override
  String get pdfSummary => 'Podsumowanie pomiarów';

  @override
  String get pdfArea => 'Powierzchnia';

  @override
  String get pdfPerimeter => 'Obwód';

  @override
  String get pdfDistance => 'Dystans';

  @override
  String get pdfDuration => 'Czas trwania';

  @override
  String get pdfPoints => 'Punkty';

  @override
  String get pdfSegments => 'Segmenty';

  @override
  String get pdfMethod => 'Metoda';

  @override
  String get pdfSubBoundaryVertices => 'Wierzchołki graniczne';

  @override
  String get pdfSubRoutePoints => 'Punkty trasy';

  @override
  String get pdfSubTrackPoints => 'Punkty śladu GPS';

  @override
  String get pdfSubSegments => 'Między punktami';

  @override
  String get pdfMethodMapPoints => 'Punkty mapy';

  @override
  String get pdfMethodPolygon => 'Ręczny wielokąt';

  @override
  String get pdfMethodRoute => 'Trasa ręczna';

  @override
  String get pdfAreaNotClosed => 'Niezamknięte';

  @override
  String get pdfAreaNotClosedSub => 'Trasa nie tworzyła pętli';

  @override
  String get pdfMapBoundary => 'Mapa i kształt';

  @override
  String get pdfMapCaption =>
      'Schemat zmierzonego kształtu · Północ jest na górze';

  @override
  String get pdfCenter => 'Współrzędne środka';

  @override
  String get pdfMapStyle => 'Styl mapy';

  @override
  String get pdfDisplayUnits => 'Wyświetlane jednostki';

  @override
  String get pdfCoordinates => 'Współrzędne';

  @override
  String get pdfCoordinatesHint =>
      'Punkty są wymienione w kolejności, w jakiej zostały zmierzone.';

  @override
  String get pdfColPoint => 'Punkt';

  @override
  String get pdfColLatitude => 'Szerokość geograficzna';

  @override
  String get pdfColLongitude => 'Długość geograficzna';

  @override
  String get pdfColSegment => 'Segment';

  @override
  String get pdfColNote => 'Notatka';

  @override
  String get pdfNoteStart => 'Start';

  @override
  String get pdfNoteEnd => 'Koniec';

  @override
  String get pdfNotePhoto => 'Zdjęcie w załączeniu';

  @override
  String pdfMorePoints(int count) {
    return 'Nie pokazano kolejnych $count punktów. Wyeksportuj CSV, aby uzyskać wszystkie.';
  }

  @override
  String get pdfNotes => 'Notatki pomiarowe';

  @override
  String get pdfPhotos => 'Zdjęcia terenu';

  @override
  String pdfPhotoN(int n) {
    return 'Zdjęcie $n';
  }

  @override
  String pdfPhotoPoint(String point) {
    return 'Przy $point';
  }

  @override
  String pdfCaptured(String date) {
    return 'Zrobiono $date';
  }

  @override
  String pdfMorePhotos(int count) {
    return 'Nie pokazano kolejnych $count zdjęć.';
  }

  @override
  String get pdfExportInfo => 'Informacje o eksporcie';

  @override
  String get pdfSource => 'Źródło';

  @override
  String get pdfSourceAndroid => 'LandMeasure na Androida';

  @override
  String get pdfSourceIos => 'LandMeasure iOS';

  @override
  String get pdfCoordFormat => 'Format współrzędnych';

  @override
  String get pdfCoordFormatValue => 'Szerokość/długość geograficzna WGS 84';

  @override
  String get pdfExported => 'Eksportowane';

  @override
  String get pdfCompanion => 'Inne formaty eksportu';

  @override
  String get pdfAccuracyTitle => 'Uwaga dotycząca dokładności:';

  @override
  String get pdfAccuracyBody =>
      'Ten raport podsumowuje pomiary obliczone na podstawie punktów na mapie i/lub danych GPS urządzenia. Wyniki mają charakter szacunkowy i mogą się różnić w zależności od dokładności urządzenia, widoczności satelitarnej, zdjęć map, terenu i miejsca umieszczenia punktów granicznych. Niniejszy dokument nie jest certyfikowanym badaniem katastralnym ani legalnym badaniem gruntów, chyba że zostanie osobno zweryfikowane przez upoważnionego specjalistę ds. geodezji.';

  @override
  String get exportPdf => 'PDF — Raport';

  @override
  String get exportPdfSubtitle =>
      'Raport do wydrukowania z mapą, współrzędnymi, notatkami i zdjęciami';

  @override
  String get projectLimitTitle => 'Osiągnięto limit bezpłatnego projektu';

  @override
  String get projectLimitMessage =>
      'Masz 4 darmowe projekty. Obejrzyj pełną reklamę, aby stworzyć jeszcze jeden projekt lub uaktualnij do Premium, aby uzyskać nieograniczoną liczbę projektów.';

  @override
  String get projectRewardRequired =>
      'Obejrzyj reklamę do końca, aby odblokować kolejny projekt. Jeśli żadna reklama nie jest dostępna, spróbuj później lub przejdź na Premium.';
}
