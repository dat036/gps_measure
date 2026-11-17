// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'LandMeasure';

  @override
  String get navHome => 'Accueil';

  @override
  String get navSaved => 'Enregistré';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get measurementTypeArea => 'Superficie';

  @override
  String get measurementTypeDistance => 'Distance';

  @override
  String get measurementTypeWalk => 'Marche';

  @override
  String get screenMeasureArea => 'Mesurer la superficie';

  @override
  String get screenMeasureDistance => 'Mesurer la distance';

  @override
  String get screenWalk => 'Marcher et mesurer';

  @override
  String get screenSave => 'Enregistrer la mesure';

  @override
  String get screenDetail => 'Détail des mesures';

  @override
  String get screenFullMap => 'Carte';

  @override
  String get screenEdit => 'Modifier la mesure';

  @override
  String get screenSaved => 'Mesures enregistrées';

  @override
  String get screenSettings => 'Paramètres';

  @override
  String get screenUnits => 'Unités';

  @override
  String get screenMapStyle => 'Style de carte';

  @override
  String get screenLanguage => 'Langue';

  @override
  String get screenPaywall => 'Premium';

  @override
  String get ctaStartMeasuring => 'Commencer à mesurer';

  @override
  String get ctaStartArea => 'Commencer la mesure de superficie';

  @override
  String get ctaStartDistance => 'Démarrer la mesure de la distance';

  @override
  String get ctaStartWalk => 'Commencer la mesure de marche';

  @override
  String get ctaSaveMeasurement => 'Enregistrer la mesure';

  @override
  String get ctaSaveRoute => 'Enregistrer l\'itinéraire';

  @override
  String get ctaPause => 'Pause';

  @override
  String get ctaResume => 'Reprendre';

  @override
  String get ctaFinish => 'Terminer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionDiscard => 'Abandonner';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionReset => 'Réinitialiser';

  @override
  String get actionOpenSettings => 'Ouvrir les paramètres';

  @override
  String get actionKeepRecording => 'Continuer à enregistrer';

  @override
  String get actionKeepEditing => 'Continuer à éditer';

  @override
  String get dialogResetTitle => 'Réinitialiser la mesure ?';

  @override
  String get dialogResetMessage => 'Cela supprimera tous les points.';

  @override
  String get dialogDiscardDraftTitle => 'Supprimer ce brouillon ?';

  @override
  String get dialogDiscardDraftMessage =>
      'Tous les points et modifications non enregistrées seront supprimés.';

  @override
  String get dialogDeleteTitle => 'Supprimer la mesure ?';

  @override
  String get dialogDeleteMessage =>
      'Cette mesure, ses photos et notes seront définitivement supprimées.';

  @override
  String get dialogFinishWalkTitle => 'Terminer l\'enregistrement ?';

  @override
  String get dialogFinishWalkMessage => 'Le suivi GPS s\'arrêtera.';

  @override
  String get dialogRenameTitle => 'Renommer la mesure';

  @override
  String get dialogDiscardChangesTitle => 'Supprimer les modifications ?';

  @override
  String get fabLayers => 'Couches de carte';

  @override
  String get fabMyLocation => 'Ma position';

  @override
  String get fabSearch => 'Rechercher un lieu';

  @override
  String get fabCamera => 'Prendre une photo';

  @override
  String get gpsReady => 'GPS prêt';

  @override
  String get gpsSearching => 'Recherche de GPS…';

  @override
  String get gpsLowAccuracy => 'Faible précision GPS';

  @override
  String get locationOff => 'L\'emplacement est désactivé';

  @override
  String get locationOffMessage =>
      'Activez l\'emplacement pour enregistrer votre promenade.';

  @override
  String get mapOffline =>
      'Connexion cartographique indisponible — vos points sont en sécurité';

  @override
  String get emptyNoMeasurementsTitle => 'Pas encore de mesures';

  @override
  String get emptyNoMeasurementsMessage =>
      'Mesurez votre premier terrain et il apparaîtra ici.';

  @override
  String get languageSystem => 'Valeur par défaut du système';

  @override
  String get measureHintCrosshair =>
      'Déplacez la carte pour placer le réticule, puis appuyez sur Ajouter un point.';

  @override
  String get measureHintTap =>
      'Appuyez sur la carte pour ajouter des points autour de la limite.';

  @override
  String get toolbarUndo => 'Annuler la dernière action';

  @override
  String get toolbarAddPoint => 'Ajouter un point';

  @override
  String get toolbarClose => 'Fermer la forme';

  @override
  String get toolbarReset => 'Réinitialiser';

  @override
  String get toolbarAddAtMyLocation => 'Ajouter un point à mon emplacement';

  @override
  String get resultArea => 'Superficie';

  @override
  String get resultPerimeter => 'Périmètre';

  @override
  String get resultAreaNeedsPoints =>
      'Ajoutez au moins 3 points pour calculer la superficie';

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
  String get edgesCross => 'Bords croisés — la zone peut être incorrecte';

  @override
  String get menuMore => 'Plus d\'options';

  @override
  String get menuInputCrosshair => 'Ajouter avec le réticule';

  @override
  String get menuInputTap => 'Ajoutez en appuyant sur la carte';

  @override
  String get menuShowEdgeLabels => 'Afficher les longueurs des bords';

  @override
  String pointLabel(int number) {
    return 'Point $number';
  }

  @override
  String get pointDelete => 'Supprimer un point';

  @override
  String get pointDeselect => 'Terminé';

  @override
  String gpsLowAccuracyAdded(int meters) {
    return 'La précision du GPS est faible (±$meters m). Le point a quand même été ajouté.';
  }

  @override
  String get locationUnavailable =>
      'Impossible d\'obtenir votre position. Réessayez à l\'extérieur.';

  @override
  String get locationPermissionDenied =>
      'L\'accès à la localisation est désactivé. Vous pouvez toujours mesurer en déplaçant la carte.';

  @override
  String get locationServiceOff =>
      'La localisation est désactivée sur cet appareil.';

  @override
  String get mapLayersTitle => 'Type de carte';

  @override
  String get mapStyleStandard => 'Standard';

  @override
  String get mapStyleSatellite => 'Satellite';

  @override
  String get mapStyleTerrain => 'Terrain';

  @override
  String get mapStyleHybrid => 'Hybride';

  @override
  String get draftSaveFailed =>
      'Impossible d\'enregistrer vos points. Ils seront à nouveau enregistrés lors du prochain changement.';

  @override
  String get menuHelp => 'Aide';

  @override
  String get actionGotIt => 'Compris';

  @override
  String get helpTitleArea => 'Comment mesurer la superficie';

  @override
  String get helpTitleDistance => 'Comment mesurer la distance';

  @override
  String get helpTitleWalk => 'Comment marcher et mesurer';

  @override
  String get helpAreaSummary =>
      'Ajoutez des points autour de la limite de votre terrain.';

  @override
  String get helpDistanceSummary =>
      'Ajoutez des points le long de l\'itinéraire que vous souhaitez mesurer.';

  @override
  String get helpWalkSummary =>
      'Faites le tour de la limite pendant que LandMeasure enregistre votre parcours GPS.';

  @override
  String get helpPhotoTip =>
      'Utilisez des photos pour documenter les points de repère, les limites ou les conditions du site.';

  @override
  String get helpAccuracyNote =>
      'La précision des mesures GPS et cartographiques peut varier en fonction de l\'appareil, des images cartographiques et de l\'environnement.';

  @override
  String get helpAreaStep1 =>
      'Déplacez la carte de manière à ce que le réticule se trouve dans un coin, puis appuyez sur **Ajouter un point**.';

  @override
  String get helpAreaStep2 =>
      'Ajoutez au moins 3 points autour de la limite. Faites glisser un point pour l\'ajuster.';

  @override
  String get helpAreaStep3 =>
      'Appuyez sur **Fermer** pour terminer la forme, puis sur **Enregistrer la mesure**.';

  @override
  String get helpDistanceStep1 =>
      'Placez le réticule au début de votre itinéraire et appuyez sur **Ajouter un point**.';

  @override
  String get helpDistanceStep2 =>
      'Continuez à ajouter des points le long de l\'itinéraire. Chaque longueur de segment est indiquée sur la carte.';

  @override
  String get helpDistanceStep3 =>
      'Appuyez sur **Enregistrer l\'itinéraire** lorsque vous avez terminé.';

  @override
  String get helpWalkStep1 =>
      'Attendez **GPS prêt**, puis appuyez sur **Commencez à marcher**.';

  @override
  String get helpWalkStep2 =>
      'Longez la limite. Utilisez **Pause** si vous devez vous arrêter.';

  @override
  String get helpWalkStep3 =>
      'Revenez à votre point de départ et appuyez sur **Terminer** pour calculer la superficie.';

  @override
  String get helpTipGpsPoint =>
      'Astuce : appuyez sur 📍 pour ajouter un point à votre position GPS actuelle.';

  @override
  String get helpTipWalk =>
      'Astuce : restez dans les zones ouvertes pour une meilleure précision GPS.';

  @override
  String get resultDistance => 'Distance';

  @override
  String get resultDistanceNeedsPoints =>
      'Ajoutez au moins 2 points pour mesurer la distance';

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
      other: 'Brouillon enregistré · $type · $count points',
      one: 'Brouillon enregistré · $type · 1 point',
    );
    return '$_temp0';
  }

  @override
  String get searchHint => 'Adresse, coordonnées ou lien Google Maps';

  @override
  String get searchAction => 'Recherche';

  @override
  String get searchRecent => 'Recherches récentes';

  @override
  String get searchNoResults =>
      'Aucun lieu trouvé. Essayez les coordonnées ou un lien Google Maps.';

  @override
  String get searchNeedsInternet =>
      'La recherche d’une adresse nécessite une connexion Internet.';

  @override
  String get searchUnavailable =>
      'La recherche d\'adresse n\'est pas disponible sur cet appareil. Essayez les coordonnées ou un lien Google Maps.';

  @override
  String get searchClear => 'Clair';

  @override
  String get searchFailed =>
      'Impossible de rechercher cette adresse pour le moment. Essayez les coordonnées ou un lien Google Maps.';

  @override
  String get ctaStartWalking => 'Commencez à marcher';

  @override
  String get walkReadyHelper =>
      'Faites le tour de la limite pour enregistrer votre chemin.';

  @override
  String get keepScreenOn => 'Garder l\'écran allumé';

  @override
  String get walkRecording => 'Enregistrement GPS…';

  @override
  String get walkPaused => 'En pause';

  @override
  String get walkPausedMessage =>
      'Appuyez sur Reprendre pour continuer là où vous êtes.';

  @override
  String gpsAccuracyShort(int meters) {
    return '±$meters m';
  }

  @override
  String gpsLowAccuracyMessage(int meters) {
    return 'Précision ±$meters m — les points ne sont pas enregistrés tant qu\'ils ne s\'améliorent pas. Déplacez-vous vers une zone ouverte.';
  }

  @override
  String get locationDeniedTitle => 'L\'accès à la localisation est désactivé';

  @override
  String get locationDeniedMessage =>
      'Autorisez l\'emplacement à enregistrer votre promenade.';

  @override
  String get actionAllow => 'Autoriser';

  @override
  String get actionNotNow => 'Pas maintenant';

  @override
  String get mockLocationDetected =>
      'Emplacement fictif détecté – ces positions ne sont pas enregistrées.';

  @override
  String get walkCloseToStart =>
      'Près du début — Terminez pour calculer la superficie';

  @override
  String get walkNotClosed => 'Itinéraire non fermé — distance uniquement';

  @override
  String get walkKeepWalking =>
      'Revenez à votre point de départ pour boucler la boucle.';

  @override
  String get resultDuration => 'Durée';

  @override
  String get walkNotificationTitle => 'LandMeasure enregistre votre mesure';

  @override
  String get walkNotificationText => 'Appuyez pour revenir à votre promenade.';

  @override
  String get walkNotificationChannel => 'Enregistrement de marche';

  @override
  String get walkRecordingBack =>
      'Enregistrement en cours. Faites une pause ou terminez avant de partir.';

  @override
  String get walkPauseAndLeave => 'Pause et départ';

  @override
  String get walkStartFailed =>
      'Impossible de démarrer l\'enregistrement. Essayer à nouveau.';

  @override
  String get batteryHintTitle =>
      'Autoriser LandMeasure à s\'exécuter en arrière-plan';

  @override
  String get batteryHintMessage =>
      'Certains téléphones arrêtent les applications lorsque l\'écran est éteint. Pour continuer à enregistrer votre promenade, ouvrez Paramètres → Batterie et choisissez « Aucune restriction » (ou « Sans restriction ») pour LandMeasure.';

  @override
  String get fabRecenter => 'Recentrer';

  @override
  String get homeHeroSubtitle =>
      'Choisissez une méthode pour mesurer votre terrain.';

  @override
  String get homeContinueTitle => 'Continuer la mesure';

  @override
  String get homeSeeAllDrafts => 'Voir tous les brouillons';

  @override
  String get homeRecentTitle => 'Mesures récentes';

  @override
  String get homeRecentEmptyTitle => 'Aucune mesure récente';

  @override
  String get homeRecentEmptyMessage =>
      'Les mesures enregistrées apparaîtront ici.';

  @override
  String get actionSeeAll => 'Tout voir';

  @override
  String get untitledArea => 'Zone sans titre';

  @override
  String get untitledDistance => 'Distance sans titre';

  @override
  String get untitledWalk => 'Promenade sans titre';

  @override
  String get draftLabel => 'Brouillon';

  @override
  String get walkFinishedNotSaved => 'Terminé · non enregistré';

  @override
  String lastEdited(String time) {
    return 'Dernière modification $time';
  }

  @override
  String get timeJustNow => 'tout à l\' heure';

  @override
  String timeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count min',
      one: 'il y a 1 min',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count heures',
      one: 'il y a 1 heure',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count jours',
      one: 'hier',
    );
    return '$_temp0';
  }

  @override
  String get savedSearchHint => 'Rechercher par nom';

  @override
  String get savedSearchOpen => 'Recherche';

  @override
  String get savedSearchClose => 'Fermer la recherche';

  @override
  String get filterAll => 'Tous';

  @override
  String filterWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String savedDraftsTitle(int count) {
    return 'Brouillons ($count)';
  }

  @override
  String get savedNoResults => 'Aucune mesure trouvée.';

  @override
  String get menuRename => 'Rebaptiser';

  @override
  String get menuExport => 'Exporter';

  @override
  String get measurementDeleted => 'Mesure supprimée';

  @override
  String get draftDiscarded => 'Brouillon rejeté';

  @override
  String get exportTitle => 'Exporter';

  @override
  String get renameHint => 'Nom de la mesure';

  @override
  String get saveNameLabel => 'Nom';

  @override
  String get saveNameRequired => 'Le nom est requis';

  @override
  String get saveNotesLabel => 'Remarques';

  @override
  String get saveNotesHint =>
      'Limites, propriétaire, points de repère… (facultatif)';

  @override
  String get saveTypeLabel => 'Type';

  @override
  String get saveFailed => 'Impossible d\'enregistrer. Veuillez réessayer.';

  @override
  String get saveLimitReached =>
      'Vous avez atteint la limite gratuite des mesures enregistrées. Celui-ci reste dans vos brouillons.';

  @override
  String get saveNotFound => 'Cette mesure n\'existe plus.';

  @override
  String photosTitle(int count) {
    return 'Photos du chantier ($count)';
  }

  @override
  String get actionClose => 'Fermer';

  @override
  String get resultPoints => 'Points';

  @override
  String get resultSegments => 'Segments';

  @override
  String get resultAvgPace => 'Rythme moyen';

  @override
  String paceValue(String time, String unit) {
    return '$time /$unit';
  }

  @override
  String get notesTitle => 'Remarques';

  @override
  String get notesEmpty => 'Aucune note';

  @override
  String get actionEdit => 'Modifier';

  @override
  String get actionExport => 'Exporter';

  @override
  String get detailOpenMap => 'Ouvrir la carte';

  @override
  String savedOn(String date) {
    return 'Enregistré $date';
  }

  @override
  String get addPhotoTitle => 'Ajouter une photo';

  @override
  String get addPhotoCamera => 'Prendre une photo';

  @override
  String get addPhotoGallery => 'Choisissez dans la galerie';

  @override
  String addPhotoForPoint(int number) {
    return 'Pour le point $number';
  }

  @override
  String get addPhotoTile => 'Ajouter une photo';

  @override
  String get photoAddFailed =>
      'Impossible d\'ajouter la photo. Veuillez réessayer.';

  @override
  String get photoRemoved => 'Photo supprimée';

  @override
  String get actionUndo => 'Annuler la dernière action';

  @override
  String get photoLimitReached =>
      'Vous avez atteint la limite gratuite de photos pour cette mesure.';

  @override
  String get photoDeleteTitle => 'Supprimer la photo ?';

  @override
  String get photoDeleteMessage => 'Cette photo sera supprimée de la mesure.';

  @override
  String get photoAttachTitle => 'Joindre cette photo à la mesure ?';

  @override
  String get photoAttachMessage =>
      '\"Enregistrer les photos dans les mesures\" est désactivé dans les paramètres.';

  @override
  String get actionAttach => 'Joindre';

  @override
  String get photoWaitForStart =>
      'Commencez à marcher pour ajouter des photos.';

  @override
  String photoCounter(int index, int total) {
    return '$index / $total';
  }

  @override
  String get photoShare => 'Partager';

  @override
  String photoOpen(int number) {
    return 'Ouvrir la photo $number';
  }

  @override
  String get photoRemove => 'Supprimer la photo';

  @override
  String get pointPhoto => 'Photo';

  @override
  String get cameraPermissionTitle => 'Autoriser l\'accès à la caméra';

  @override
  String get cameraPermissionMessage =>
      'Prenez des photos des points de repère, des limites et des conditions du site et conservez-les avec vos mesures.';

  @override
  String get cameraPermissionDenied =>
      'L\'accès à la caméra est désactivé. Vous pouvez l\'activer dans Paramètres.';

  @override
  String get actionContinue => 'Continuer';

  @override
  String get notesEditTitle => 'Modifier les notes';

  @override
  String get notesAdd => 'Ajouter des notes';

  @override
  String get editTabResult => 'Résultat';

  @override
  String get editTabDetails => 'Détails';

  @override
  String get ctaSaveChanges => 'Enregistrer les modifications';

  @override
  String get dialogDiscardChangesMessage =>
      'Vos modifications apportées à cette mesure seront perdues.';

  @override
  String get changesSaved => 'Modifications enregistrées';

  @override
  String get menuReopenShape => 'Réouvrir la forme';

  @override
  String get exportKml => 'KML — Google Earth';

  @override
  String get exportKmlSubtitle =>
      'Points de forme et de photo pour les applications Google Earth et SIG';

  @override
  String get exportCsv => 'CSV-Excel';

  @override
  String get exportCsvSubtitle =>
      'Chaque point avec des coordonnées, pour les feuilles de calcul';

  @override
  String get exportPreparing => 'Préparation du fichier…';

  @override
  String get exportFailed => 'Impossible d\'exporter. Veuillez réessayer.';

  @override
  String get exportLimitReached =>
      'L’export KML gratuit du jour a déjà été utilisé. L’export CSV reste gratuit.';

  @override
  String get landValueTitle => 'Valeur du terrain';

  @override
  String get landValueAdd => 'Ajouter de la valeur au terrain';

  @override
  String get landValueUnitPrice => 'Prix ​​unitaire';

  @override
  String get landValueUnit => 'Par';

  @override
  String landValueEstimated(String value) {
    return 'Valeur estimée ≈ $value';
  }

  @override
  String landValueRate(String price, String unit) {
    return '$price / $unit';
  }

  @override
  String get landValueNeedsArea =>
      'La valeur du terrain nécessite une superficie (fermez la forme).';

  @override
  String get landValueRemove => 'Retirer';

  @override
  String get landValueInvalid => 'Saisissez un prix supérieur à 0';

  @override
  String get resultValue => 'Valeur';

  @override
  String get settingsSubtitle =>
      'Préférences d\'unités, de carte et d\'application';

  @override
  String get settingsSectionPreferences => 'Préférences de mesure';

  @override
  String get settingsSectionMeasureMap => 'Mesure et carte';

  @override
  String get settingsSectionSupport => 'Assistance et informations juridiques';

  @override
  String get settingsDefaultMode => 'Type de mesure par défaut';

  @override
  String get settingsDefaultModeHint =>
      'Sélectionné sur Accueil lorsque vous ouvrez l\'application.';

  @override
  String get settingsGpsAccuracy => 'Affichage de la précision GPS';

  @override
  String get settingsGpsAccuracySubtitle =>
      'Afficher ±m et le cercle de précision en marchant';

  @override
  String get settingsAutoCenter => 'Centrer automatiquement la carte';

  @override
  String get settingsAutoCenterSubtitle =>
      'Ouvrez des cartes à votre emplacement et suivez-vous en marchant';

  @override
  String get settingsSavePhotos => 'Enregistrer des photos dans la mesure';

  @override
  String get settingsSavePhotosSubtitle =>
      'Joindre de nouvelles photos sans demander';

  @override
  String get settingsKeepAwake => 'Garder l’écran allumé';

  @override
  String get settingsKeepAwakeSubtitle =>
      'L\'écran reste allumé pendant la mesure';

  @override
  String get settingsHelpFeedback => 'Aide et commentaires';

  @override
  String get settingsRateUs => 'Évaluez-nous';

  @override
  String get settingsPrivacyPolicy => 'politique de confidentialité';

  @override
  String get settingsTerms => 'Conditions d\'utilisation';

  @override
  String settingsVersion(String version, String build) {
    return 'Version $version ($build)';
  }

  @override
  String get feedbackSubject => 'Commentaires sur LandMeasure';

  @override
  String feedbackNoEmailApp(String email) {
    return 'Aucune application de messagerie trouvée. Écrivez-nous à $email.';
  }

  @override
  String get linkOpenFailed =>
      'Impossible d\'ouvrir le lien. Veuillez réessayer.';

  @override
  String get unitsDistanceTitle => 'Distance';

  @override
  String get unitsAreaTitle => 'Superficie';

  @override
  String get unitsSecondary => 'Afficher l\'unité secondaire';

  @override
  String unitsSecondaryExample(String example) {
    return 'par ex. $example';
  }

  @override
  String get unitsNote =>
      'Les nouvelles mesures utilisent ces unités. Chaque mesure peut également changer d\'unité à partir de son résultat.';

  @override
  String get unitMeters => 'Mètres';

  @override
  String get unitKilometers => 'Kilomètres';

  @override
  String get unitFeet => 'Pieds';

  @override
  String get unitMiles => 'Milles';

  @override
  String get unitSquareMeters => 'Mètres carrés';

  @override
  String get unitHectares => 'Hectares';

  @override
  String get unitAcres => 'Acres';

  @override
  String get unitSquareFeet => 'Pieds carrés';

  @override
  String get mapStyleNote =>
      'De nouvelles mesures s\'ouvrent avec cette carte. Vous pouvez changer de carte avec le bouton Calques.';

  @override
  String get actionApply => 'Appliquer';

  @override
  String get languageAppLanguages => 'Langues de l\'application';

  @override
  String get languageMachineNote =>
      'Cette langue a été traduite automatiquement et peut contenir des erreurs.';

  @override
  String get locationPermissionTitle => 'Autoriser l\'accès à la localisation';

  @override
  String get locationPermissionMessage =>
      'LandMeasure utilise votre position pour indiquer où vous vous trouvez sur la carte. Il reste sur votre téléphone.';

  @override
  String get locationPermissionMeasureMessage =>
      'Montrez où vous vous trouvez sur la carte et ajoutez des points où vous vous situez. Sans cela, vous pouvez toujours mesurer en déplaçant la carte.';

  @override
  String get locationPermissionWalkMessage =>
      'Walk & Measure enregistre votre chemin avec le GPS lorsque cet écran est ouvert. Votre position reste sur votre téléphone.';

  @override
  String get locationPermissionBlocked =>
      'L’accès à la localisation est désactivé pour LandMeasure. Activez-le dans Paramètres pour utiliser votre position.';

  @override
  String get notificationPermissionTitle => 'Autoriser les notifications';

  @override
  String get notificationPermissionMessage =>
      'Autorisez les notifications afin que vous puissiez voir l\'état de l\'enregistrement lorsque votre écran est éteint.';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get paywallTitle => 'Mesurer sans limites';

  @override
  String get paywallSubtitle =>
      'Débloquez des projets illimités et des fonctionnalités premium.';

  @override
  String get paywallBenefitNoAds => 'Aucune publicité';

  @override
  String get paywallBenefitSaves => 'Mesures enregistrées illimitées';

  @override
  String get paywallBenefitPhotos => 'Photos illimitées par mesure';

  @override
  String get paywallBenefitKml => 'Exportation KML à tout moment';

  @override
  String paywallStartTrial(int days) {
    return 'Commencer l’essai gratuit de $days jours';
  }

  @override
  String paywallTermsTrial(int days, String price, String store) {
    return '$days jours gratuits, puis $price/an. Renouvellement automatique — annulez à tout moment dans $store.';
  }

  @override
  String paywallTermsYearly(String price, String store) {
    return '$price/an. Se renouvelle automatiquement — annulez à tout moment dans $store.';
  }

  @override
  String paywallTermsMonthly(String price, String store) {
    return '$price/mois. Se renouvelle automatiquement — annulez à tout moment dans $store.';
  }

  @override
  String get paywallRestore => 'Restaurer les achats';

  @override
  String get paywallWelcome => 'Bienvenue sur Premium !';

  @override
  String get paywallPending =>
      'Paiement en attente. Premium se déverrouille dès qu\'il est terminé.';

  @override
  String get paywallPurchaseFailed =>
      'L’achat n’a pas abouti. Aucun montant ne vous a été facturé.';

  @override
  String get paywallRestored => 'Achats restaurés.';

  @override
  String get paywallNothingToRestore =>
      'Aucun achat antérieur trouvé pour ce compte de magasin.';

  @override
  String get paywallRestoreFailed =>
      'Impossible de restaurer les achats. Vérifiez votre connexion et réessayez.';

  @override
  String get paywallUnavailable =>
      'Les plans ne peuvent pas être chargés pour le moment. Vérifiez votre connexion et réessayez.';

  @override
  String get premiumActive => 'Actif premium';

  @override
  String get premiumActiveLifetime => 'Actif premium · À vie';

  @override
  String get premiumManage => 'Gérer';

  @override
  String get settingsPremiumTitle => 'LandMeasure Premium';

  @override
  String get settingsPremiumSubtitle =>
      'Pas de publicité, sauvegardes et photos illimitées, KML à tout moment';

  @override
  String get settingsManageSubscription => 'Gérer l\'abonnement';

  @override
  String get settingsPrivacyChoices => 'Choix de confidentialité';

  @override
  String get settingsAdInspector => 'Inspecteur de publicité (développement)';

  @override
  String get exportUnlockTitle =>
      'L’export KML gratuit du jour a déjà été utilisé';

  @override
  String get exportUnlockMessage =>
      'Regardez une courte annonce pour exporter ce fichier ou obtenez Premium pour des exportations KML illimitées. L’export CSV reste gratuit.';

  @override
  String get exportWatchAd => 'Regarder une annonce';

  @override
  String get exportGetPremium => 'Passer à Premium';

  @override
  String get exportLoadingAd => 'Chargement de l\'annonce…';

  @override
  String get exportAdDismissed =>
      'Regardez la publicité jusqu\'à la fin pour débloquer cet export.';

  @override
  String get introNext => 'Suivant';

  @override
  String get introGetStarted => 'Commencer';

  @override
  String get introAreaTitle => 'Mesurer facilement la zone';

  @override
  String get introAreaBody =>
      'Marquez des points sur la carte pour mesurer les terres, les champs et d\'autres zones en quelques secondes.';

  @override
  String get introDistanceTitle => 'Mesurer la distance et les itinéraires';

  @override
  String get introDistanceBody =>
      'Mesurez les distances en ligne droite ou suivez votre itinéraire lorsque vous marchez à l\'extérieur.';

  @override
  String get introFieldTitle => 'Conçu pour le vrai travail sur le terrain';

  @override
  String get introFieldBody =>
      'Mesurez facilement les fermes, les terrains, les propriétés et les sites extérieurs.';

  @override
  String paywallTrialTitle(int days) {
    return 'Essai gratuit de $days jours';
  }

  @override
  String paywallThenMonthly(String price) {
    return 'Puis $price / mois';
  }

  @override
  String get paywallMonthlyTitle => 'Forfait mensuel';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price / mois';
  }

  @override
  String get paywallYearlyTitle => 'Plan annuel';

  @override
  String paywallYearlyOnly(String price) {
    return 'Seulement $price par an';
  }

  @override
  String get paywallBestPrice => 'Meilleur prix';

  @override
  String get paywallMostPopular => 'Le plus populaire';

  @override
  String get paywallStartFreeTrial => 'Commencer l\'essai gratuit';

  @override
  String paywallTrialThenYearly(int days, String price) {
    return 'Essai gratuit de $days jours, puis $price/an';
  }

  @override
  String paywallPricePerYear(String price) {
    return '$price/an';
  }

  @override
  String get paywallCancelAnytime => 'Annuler à tout moment';

  @override
  String paywallTermsTrialMonthly(int days, String price, String store) {
    return '$days jours gratuits, puis $price/mois. Se renouvelle automatiquement — annulez à tout moment dans $store.';
  }

  @override
  String get premiumPromptTitle => 'Passez à la version premium';

  @override
  String premiumPromptPhotos(int count) {
    return 'Vous pouvez ajouter gratuitement jusqu’à $count photos à une mesure. Passez à Premium pour en ajouter davantage.';
  }

  @override
  String get premiumPromptUpgrade => 'Passer à Premium';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get languageChooseTitle => 'Choisissez votre langue';

  @override
  String premiumPromptMapStyleReward(String style) {
    return 'Les cartes $style sont une fonctionnalité Premium. Regardez une courte annonce pour l\'utiliser jusqu\'à ce que vous fermiez l\'application ou que vous effectuiez une mise à niveau définitive.';
  }

  @override
  String mapStyleUnlocked(String style) {
    return 'Carte $style déverrouillée jusqu\'à ce que vous fermiez l\'application.';
  }

  @override
  String get mapStyleAdDismissed =>
      'Regardez la publicité jusqu\'à la fin pour débloquer cette carte.';

  @override
  String get pdfReportTitleArea => 'Rapport de mesure des terres';

  @override
  String get pdfReportTitleDistance => 'Rapport de mesure de distance';

  @override
  String get pdfReportTitleWalk => 'Rapport de mesure de marche';

  @override
  String get pdfReportSubtitle => 'Résumé exporté d\'une mesure enregistrée';

  @override
  String get pdfHeaderLabel => 'Rapport de mesure';

  @override
  String get pdfFooterGenerated => 'Généré par LandMeasure';

  @override
  String get pdfFooterEstimate =>
      'Les mesures GPS/carte sont des estimations et peuvent varier selon l\'appareil et l\'environnement.';

  @override
  String pdfPage(int page, int pages) {
    return 'Page $page de $pages';
  }

  @override
  String get pdfName => 'Nom de la mesure';

  @override
  String get pdfType => 'Type';

  @override
  String get pdfDateSaved => 'Date d’enregistrement';

  @override
  String get pdfReportId => 'ID du rapport';

  @override
  String get pdfSummary => 'Résumé des mesures';

  @override
  String get pdfArea => 'Superficie';

  @override
  String get pdfPerimeter => 'Périmètre';

  @override
  String get pdfDistance => 'Distance';

  @override
  String get pdfDuration => 'Durée';

  @override
  String get pdfPoints => 'Points';

  @override
  String get pdfSegments => 'Segments';

  @override
  String get pdfMethod => 'Méthode';

  @override
  String get pdfSubBoundaryVertices => 'Sommets limites';

  @override
  String get pdfSubRoutePoints => 'Points d\'itinéraire';

  @override
  String get pdfSubTrackPoints => 'Points de trace GPS';

  @override
  String get pdfSubSegments => 'Entre les points';

  @override
  String get pdfMethodMapPoints => 'Points de la carte';

  @override
  String get pdfMethodPolygon => 'Polygone manuel';

  @override
  String get pdfMethodRoute => 'Itinéraire manuel';

  @override
  String get pdfAreaNotClosed => 'Non fermé';

  @override
  String get pdfAreaNotClosedSub => 'L\'itinéraire ne forme pas une boucle';

  @override
  String get pdfMapBoundary => 'Carte et forme';

  @override
  String get pdfMapCaption =>
      'Schéma de la forme mesurée · le nord est en haut';

  @override
  String get pdfCenter => 'Coordonnées du centre';

  @override
  String get pdfMapStyle => 'Style de carte';

  @override
  String get pdfDisplayUnits => 'Unités d\'affichage';

  @override
  String get pdfCoordinates => 'Coordonnées';

  @override
  String get pdfCoordinatesHint =>
      'Les points sont répertoriés dans l’ordre dans lequel ils ont été mesurés.';

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
  String get pdfNoteStart => 'Commencer';

  @override
  String get pdfNoteEnd => 'Fin';

  @override
  String get pdfNotePhoto => 'Photo ci-jointe';

  @override
  String pdfMorePoints(int count) {
    return '$count points supplémentaires ne sont pas affichés. Exportez en CSV pour tous les obtenir.';
  }

  @override
  String get pdfNotes => 'Notes de relevé';

  @override
  String get pdfPhotos => 'Photos du terrain';

  @override
  String pdfPhotoN(int n) {
    return 'Photo $n';
  }

  @override
  String pdfPhotoPoint(String point) {
    return 'Au point $point';
  }

  @override
  String pdfCaptured(String date) {
    return 'Prise le $date';
  }

  @override
  String pdfMorePhotos(int count) {
    return '$count photos supplémentaires ne sont pas affichées.';
  }

  @override
  String get pdfExportInfo => 'Informations d’exportation';

  @override
  String get pdfSource => 'Source';

  @override
  String get pdfSourceAndroid => 'LandMeasure Android';

  @override
  String get pdfSourceIos => 'LandMeasure iOS';

  @override
  String get pdfCoordFormat => 'Format des coordonnées';

  @override
  String get pdfCoordFormatValue => 'WGS 84 latitude / longitude';

  @override
  String get pdfExported => 'Exporté';

  @override
  String get pdfCompanion => 'Autres formats d\'exportation';

  @override
  String get pdfAccuracyTitle => 'Avis de précision :';

  @override
  String get pdfAccuracyBody =>
      'Ce rapport résume les mesures calculées à partir de points cartographiques et/ou de données GPS de l\'appareil. Les résultats sont des estimations et peuvent varier en fonction de la précision de l\'appareil, de la visibilité du satellite, des images cartographiques, du terrain et de l\'endroit où les points limites ont été placés. Ce document n\'est pas un levé cadastral ou légal certifié, à moins d\'être vérifié séparément par un géomètre professionnel agréé.';

  @override
  String get exportPdf => 'PDF — Rapport';

  @override
  String get exportPdfSubtitle =>
      'Rapport imprimable avec carte, coordonnées, notes et photos';

  @override
  String get projectLimitTitle => 'Limite de projets gratuits atteinte';

  @override
  String get projectLimitMessage =>
      'Vous disposez de 4 projets gratuits. Regardez une annonce complète pour créer un projet supplémentaire, ou passez à Premium pour un nombre illimité de projets.';

  @override
  String get projectRewardRequired =>
      'Regardez une publicité jusqu’à la fin pour débloquer un projet supplémentaire. Si aucune publicité n’est disponible, réessayez plus tard ou passez à Premium.';
}
