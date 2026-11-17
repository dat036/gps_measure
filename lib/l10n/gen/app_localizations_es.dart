// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'LandMeasure';

  @override
  String get navHome => 'Inicio';

  @override
  String get navSaved => 'Guardadas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get measurementTypeArea => 'Área';

  @override
  String get measurementTypeDistance => 'Distancia';

  @override
  String get measurementTypeWalk => 'Caminata';

  @override
  String get screenMeasureArea => 'Medir área';

  @override
  String get screenMeasureDistance => 'Medir distancia';

  @override
  String get screenWalk => 'Caminar y medir';

  @override
  String get screenSave => 'Guardar medición';

  @override
  String get screenDetail => 'Detalle de la medición';

  @override
  String get screenFullMap => 'Mapa';

  @override
  String get screenEdit => 'Editar medición';

  @override
  String get screenSaved => 'Mediciones guardadas';

  @override
  String get screenSettings => 'Ajustes';

  @override
  String get screenUnits => 'Unidades';

  @override
  String get screenMapStyle => 'Estilo de mapa';

  @override
  String get screenLanguage => 'Idioma';

  @override
  String get screenPaywall => 'Premium';

  @override
  String get ctaStartMeasuring => 'Empieza a medir';

  @override
  String get ctaStartArea => 'Medir un área';

  @override
  String get ctaStartDistance => 'Medir una distancia';

  @override
  String get ctaStartWalk => 'Medir caminando';

  @override
  String get ctaSaveMeasurement => 'Guardar medición';

  @override
  String get ctaSaveRoute => 'Guardar ruta';

  @override
  String get ctaPause => 'Pausar';

  @override
  String get ctaResume => 'Reanudar';

  @override
  String get ctaFinish => 'Terminar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionSave => 'Guardar';

  @override
  String get actionDiscard => 'Descartar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionReset => 'Reiniciar';

  @override
  String get actionOpenSettings => 'Abrir Ajustes';

  @override
  String get actionKeepRecording => 'Seguir grabando';

  @override
  String get actionKeepEditing => 'Seguir editando';

  @override
  String get dialogResetTitle => '¿Reiniciar la medición?';

  @override
  String get dialogResetMessage => 'Se eliminarán todos los puntos.';

  @override
  String get dialogDiscardDraftTitle => '¿Descartar este borrador?';

  @override
  String get dialogDiscardDraftMessage =>
      'Se eliminarán todos los puntos y los cambios sin guardar.';

  @override
  String get dialogDeleteTitle => '¿Eliminar la medición?';

  @override
  String get dialogDeleteMessage =>
      'Esta medición, sus fotos y notas se eliminarán de forma permanente.';

  @override
  String get dialogFinishWalkTitle => '¿Terminar la grabación?';

  @override
  String get dialogFinishWalkMessage => 'El seguimiento GPS se detendrá.';

  @override
  String get dialogRenameTitle => 'Cambiar nombre';

  @override
  String get dialogDiscardChangesTitle => '¿Descartar los cambios?';

  @override
  String get fabLayers => 'Capas del mapa';

  @override
  String get fabMyLocation => 'Mi ubicación';

  @override
  String get fabSearch => 'Buscar lugar';

  @override
  String get fabCamera => 'Tomar foto';

  @override
  String get gpsReady => 'GPS listo';

  @override
  String get gpsSearching => 'Buscando GPS…';

  @override
  String get gpsLowAccuracy => 'Precisión GPS baja';

  @override
  String get locationOff => 'La ubicación está desactivada';

  @override
  String get locationOffMessage =>
      'Activa la ubicación para grabar tu caminata.';

  @override
  String get mapOffline => 'Sin conexión con el mapa: tus puntos están a salvo';

  @override
  String get emptyNoMeasurementsTitle => 'Aún no hay mediciones';

  @override
  String get emptyNoMeasurementsMessage =>
      'Mide tu primer terreno y aparecerá aquí.';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get measureHintCrosshair =>
      'Mueve el mapa para colocar la mira y toca Añadir punto.';

  @override
  String get measureHintTap =>
      'Toca el mapa para añadir puntos alrededor del límite.';

  @override
  String get toolbarUndo => 'Deshacer';

  @override
  String get toolbarAddPoint => 'Añadir punto';

  @override
  String get toolbarClose => 'Cerrar forma';

  @override
  String get toolbarReset => 'Reiniciar';

  @override
  String get toolbarAddAtMyLocation => 'Añadir punto en mi ubicación';

  @override
  String get resultArea => 'Área';

  @override
  String get resultPerimeter => 'Perímetro';

  @override
  String get resultAreaNeedsPoints =>
      'Añade al menos 3 puntos para calcular el área';

  @override
  String resultPointCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos',
      one: '1 punto',
    );
    return '$_temp0';
  }

  @override
  String get edgesCross => 'Los lados se cruzan: el área puede ser incorrecta';

  @override
  String get menuMore => 'Más opciones';

  @override
  String get menuInputCrosshair => 'Añadir con la mira';

  @override
  String get menuInputTap => 'Añadir tocando el mapa';

  @override
  String get menuShowEdgeLabels => 'Mostrar longitud de los lados';

  @override
  String pointLabel(int number) {
    return 'Punto $number';
  }

  @override
  String get pointDelete => 'Eliminar punto';

  @override
  String get pointDeselect => 'Listo';

  @override
  String gpsLowAccuracyAdded(int meters) {
    return 'La precisión GPS es baja (±$meters m). El punto se añadió de todos modos.';
  }

  @override
  String get locationUnavailable =>
      'No se pudo obtener tu ubicación. Inténtalo al aire libre.';

  @override
  String get locationPermissionDenied =>
      'El acceso a la ubicación está desactivado. Puedes seguir midiendo moviendo el mapa.';

  @override
  String get locationServiceOff =>
      'La ubicación está desactivada en este dispositivo.';

  @override
  String get mapLayersTitle => 'Tipo de mapa';

  @override
  String get mapStyleStandard => 'Estándar';

  @override
  String get mapStyleSatellite => 'Satélite';

  @override
  String get mapStyleTerrain => 'Relieve';

  @override
  String get mapStyleHybrid => 'Híbrido';

  @override
  String get draftSaveFailed =>
      'No se pudieron guardar tus puntos. Se guardarán de nuevo con el próximo cambio.';

  @override
  String get menuHelp => 'Ayuda';

  @override
  String get actionGotIt => 'Entendido';

  @override
  String get helpTitleArea => 'Cómo medir un área';

  @override
  String get helpTitleDistance => 'Cómo medir una distancia';

  @override
  String get helpTitleWalk => 'Cómo medir caminando';

  @override
  String get helpAreaSummary =>
      'Añade puntos alrededor del límite de tu terreno.';

  @override
  String get helpDistanceSummary =>
      'Añade puntos a lo largo de la ruta que quieres medir.';

  @override
  String get helpWalkSummary =>
      'Camina por el límite mientras LandMeasure graba tu recorrido GPS.';

  @override
  String get helpPhotoTip =>
      'Usa fotos para documentar hitos, linderos o el estado del terreno.';

  @override
  String get helpAccuracyNote =>
      'La precisión del GPS y de las mediciones en el mapa puede variar según el dispositivo, las imágenes del mapa y el entorno.';

  @override
  String get helpAreaStep1 =>
      'Mueve el mapa para que la mira quede sobre una esquina y toca **Añadir punto**.';

  @override
  String get helpAreaStep2 =>
      'Añade al menos 3 puntos alrededor del límite. Arrastra un punto para ajustarlo.';

  @override
  String get helpAreaStep3 =>
      'Toca **Cerrar forma** para terminar y luego **Guardar medición**.';

  @override
  String get helpDistanceStep1 =>
      'Coloca la mira al inicio de tu ruta y toca **Añadir punto**.';

  @override
  String get helpDistanceStep2 =>
      'Sigue añadiendo puntos a lo largo de la ruta. La longitud de cada tramo aparece en el mapa.';

  @override
  String get helpDistanceStep3 => 'Toca **Guardar ruta** cuando termines.';

  @override
  String get helpWalkStep1 =>
      'Espera a **GPS listo** y toca **Empezar a caminar**.';

  @override
  String get helpWalkStep2 =>
      'Camina por el límite. Usa **Pausar** si necesitas detenerte.';

  @override
  String get helpWalkStep3 =>
      'Vuelve al punto de partida y toca **Terminar** para calcular el área.';

  @override
  String get helpTipGpsPoint =>
      'Consejo: toca 📍 para añadir un punto en tu ubicación GPS actual.';

  @override
  String get helpTipWalk =>
      'Consejo: quédate en zonas abiertas para una mejor precisión GPS.';

  @override
  String get resultDistance => 'Distancia';

  @override
  String get resultDistanceNeedsPoints =>
      'Añade al menos 2 puntos para medir la distancia';

  @override
  String resultSegmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tramos',
      one: '1 tramo',
    );
    return '$_temp0';
  }

  @override
  String get segmentsTitle => 'Tramos';

  @override
  String draftSavedSnack(int count, String type) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Borrador guardado · $type · $count puntos',
      one: 'Borrador guardado · $type · 1 punto',
    );
    return '$_temp0';
  }

  @override
  String get searchHint => 'Dirección, coordenadas o enlace de Google Maps';

  @override
  String get searchAction => 'Buscar';

  @override
  String get searchRecent => 'Búsquedas recientes';

  @override
  String get searchNoResults =>
      'No se encontraron lugares. Prueba con coordenadas o un enlace de Google Maps.';

  @override
  String get searchNeedsInternet =>
      'Buscar una dirección requiere conexión a internet.';

  @override
  String get searchUnavailable =>
      'La búsqueda de direcciones no está disponible en este dispositivo. Prueba con coordenadas o un enlace de Google Maps.';

  @override
  String get searchClear => 'Borrar';

  @override
  String get searchFailed =>
      'No se pudo buscar esta dirección ahora. Prueba con coordenadas o un enlace de Google Maps.';

  @override
  String get ctaStartWalking => 'Empezar a caminar';

  @override
  String get walkReadyHelper =>
      'Camina por el límite para grabar tu recorrido.';

  @override
  String get keepScreenOn => 'Mantener la pantalla encendida';

  @override
  String get walkRecording => 'Grabando GPS…';

  @override
  String get walkPaused => 'En pausa';

  @override
  String get walkPausedMessage =>
      'Toca Reanudar para continuar desde donde estás.';

  @override
  String gpsAccuracyShort(int meters) {
    return '±$meters m';
  }

  @override
  String gpsLowAccuracyMessage(int meters) {
    return 'Precisión ±$meters m: no se graban puntos hasta que mejore. Ve a una zona abierta.';
  }

  @override
  String get locationDeniedTitle => 'El acceso a la ubicación está desactivado';

  @override
  String get locationDeniedMessage =>
      'Permite la ubicación para grabar tu caminata.';

  @override
  String get actionAllow => 'Permitir';

  @override
  String get actionNotNow => 'Ahora no';

  @override
  String get mockLocationDetected =>
      'Se detectó una ubicación simulada: esas posiciones no se graban.';

  @override
  String get walkCloseToStart =>
      'Cerca del inicio: termina para calcular el área';

  @override
  String get walkNotClosed => 'Ruta no cerrada: solo distancia';

  @override
  String get walkKeepWalking => 'Vuelve al inicio para cerrar el recorrido.';

  @override
  String get resultDuration => 'Duración';

  @override
  String get walkNotificationTitle => 'LandMeasure está grabando tu medición';

  @override
  String get walkNotificationText => 'Toca para volver a tu caminata.';

  @override
  String get walkNotificationChannel => 'Grabación de caminata';

  @override
  String get walkRecordingBack =>
      'Grabación en curso. Pausa o termina antes de salir.';

  @override
  String get walkPauseAndLeave => 'Pausar y salir';

  @override
  String get walkStartFailed =>
      'No se pudo iniciar la grabación. Inténtalo de nuevo.';

  @override
  String get batteryHintTitle =>
      'Permite que LandMeasure funcione en segundo plano';

  @override
  String get batteryHintMessage =>
      'Algunos teléfonos detienen las apps con la pantalla apagada. Para seguir grabando tu caminata, abre Ajustes → Batería y elige \"Sin restricciones\" para LandMeasure.';

  @override
  String get fabRecenter => 'Recentrar';

  @override
  String get homeHeroSubtitle => 'Elige un método para medir tu terreno.';

  @override
  String get homeContinueTitle => 'Continuar medición';

  @override
  String get homeSeeAllDrafts => 'Ver todos los borradores';

  @override
  String get homeRecentTitle => 'Mediciones recientes';

  @override
  String get homeRecentEmptyTitle => 'No hay mediciones recientes';

  @override
  String get homeRecentEmptyMessage =>
      'Las mediciones guardadas aparecerán aquí.';

  @override
  String get actionSeeAll => 'Ver todo';

  @override
  String get untitledArea => 'Área sin nombre';

  @override
  String get untitledDistance => 'Distancia sin nombre';

  @override
  String get untitledWalk => 'Caminata sin nombre';

  @override
  String get draftLabel => 'Borrador';

  @override
  String get walkFinishedNotSaved => 'Terminada · sin guardar';

  @override
  String lastEdited(String time) {
    return 'Editado $time';
  }

  @override
  String get timeJustNow => 'ahora mismo';

  @override
  String timeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count min',
      one: 'hace 1 min',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count horas',
      one: 'hace 1 hora',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'ayer',
    );
    return '$_temp0';
  }

  @override
  String get savedSearchHint => 'Buscar por nombre';

  @override
  String get savedSearchOpen => 'Buscar';

  @override
  String get savedSearchClose => 'Cerrar búsqueda';

  @override
  String get filterAll => 'Todas';

  @override
  String filterWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String savedDraftsTitle(int count) {
    return 'Borradores ($count)';
  }

  @override
  String get savedNoResults => 'No se encontraron mediciones.';

  @override
  String get menuRename => 'Cambiar nombre';

  @override
  String get menuExport => 'Exportar';

  @override
  String get measurementDeleted => 'Medición eliminada';

  @override
  String get draftDiscarded => 'Borrador descartado';

  @override
  String get exportTitle => 'Exportar';

  @override
  String get renameHint => 'Nombre de la medición';

  @override
  String get saveNameLabel => 'Nombre';

  @override
  String get saveNameRequired => 'El nombre es obligatorio';

  @override
  String get saveNotesLabel => 'Notas';

  @override
  String get saveNotesHint => 'Linderos, propietario, referencias… (opcional)';

  @override
  String get saveTypeLabel => 'Tipo';

  @override
  String get saveFailed => 'No se pudo guardar. Inténtalo de nuevo.';

  @override
  String get saveLimitReached =>
      'Alcanzaste el límite gratuito de mediciones guardadas. Esta queda en tus borradores.';

  @override
  String get saveNotFound => 'Esta medición ya no existe.';

  @override
  String photosTitle(int count) {
    return 'Fotos del terreno ($count)';
  }

  @override
  String get actionClose => 'Cerrar';

  @override
  String get resultPoints => 'Puntos';

  @override
  String get resultSegments => 'Tramos';

  @override
  String get resultAvgPace => 'Ritmo medio';

  @override
  String paceValue(String time, String unit) {
    return '$time /$unit';
  }

  @override
  String get notesTitle => 'Notas';

  @override
  String get notesEmpty => 'Sin notas';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionExport => 'Exportar';

  @override
  String get detailOpenMap => 'Abrir mapa';

  @override
  String savedOn(String date) {
    return 'Guardado el $date';
  }

  @override
  String get addPhotoTitle => 'Añadir foto';

  @override
  String get addPhotoCamera => 'Tomar foto';

  @override
  String get addPhotoGallery => 'Elegir de la galería';

  @override
  String addPhotoForPoint(int number) {
    return 'Para el punto $number';
  }

  @override
  String get addPhotoTile => 'Añadir foto';

  @override
  String get photoAddFailed => 'No se pudo añadir la foto. Inténtalo de nuevo.';

  @override
  String get photoRemoved => 'Foto eliminada';

  @override
  String get actionUndo => 'Deshacer';

  @override
  String get photoLimitReached =>
      'Alcanzaste el límite gratuito de fotos para esta medición.';

  @override
  String get photoDeleteTitle => '¿Eliminar la foto?';

  @override
  String get photoDeleteMessage => 'Esta foto se quitará de la medición.';

  @override
  String get photoAttachTitle => '¿Adjuntar esta foto a la medición?';

  @override
  String get photoAttachMessage =>
      '\"Guardar fotos en la medición\" está desactivado en Ajustes.';

  @override
  String get actionAttach => 'Adjuntar';

  @override
  String get photoWaitForStart => 'Empieza a caminar para añadir fotos.';

  @override
  String photoCounter(int index, int total) {
    return '$index / $total';
  }

  @override
  String get photoShare => 'Compartir';

  @override
  String photoOpen(int number) {
    return 'Abrir foto $number';
  }

  @override
  String get photoRemove => 'Quitar foto';

  @override
  String get pointPhoto => 'Foto';

  @override
  String get cameraPermissionTitle => 'Permitir acceso a la cámara';

  @override
  String get cameraPermissionMessage =>
      'Fotografía hitos, linderos y el estado del terreno y guárdalos con tu medición.';

  @override
  String get cameraPermissionDenied =>
      'El acceso a la cámara está desactivado. Puedes activarlo en Ajustes.';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get notesEditTitle => 'Editar notas';

  @override
  String get notesAdd => 'Añadir notas';

  @override
  String get editTabResult => 'Resultado';

  @override
  String get editTabDetails => 'Detalles';

  @override
  String get ctaSaveChanges => 'Guardar cambios';

  @override
  String get dialogDiscardChangesMessage =>
      'Se perderán los cambios en esta medición.';

  @override
  String get changesSaved => 'Cambios guardados';

  @override
  String get menuReopenShape => 'Reabrir forma';

  @override
  String get exportKml => 'KML — Google Earth';

  @override
  String get exportKmlSubtitle =>
      'Forma y puntos con foto para Google Earth y apps SIG';

  @override
  String get exportCsv => 'CSV — Excel';

  @override
  String get exportCsvSubtitle =>
      'Cada punto con sus coordenadas, para hojas de cálculo';

  @override
  String get exportPreparing => 'Preparando archivo…';

  @override
  String get exportFailed => 'No se pudo exportar. Inténtalo de nuevo.';

  @override
  String get exportLimitReached =>
      'Ya usaste la exportación KML gratuita de hoy. La exportación CSV sigue siendo gratuita.';

  @override
  String get landValueTitle => 'Valor del terreno';

  @override
  String get landValueAdd => 'Añadir valor del terreno';

  @override
  String get landValueUnitPrice => 'Precio unitario';

  @override
  String get landValueUnit => 'Por';

  @override
  String landValueEstimated(String value) {
    return 'Valor estimado ≈ $value';
  }

  @override
  String landValueRate(String price, String unit) {
    return '$price / $unit';
  }

  @override
  String get landValueNeedsArea =>
      'El valor del terreno necesita un área (cierra la forma).';

  @override
  String get landValueRemove => 'Quitar';

  @override
  String get landValueInvalid => 'Introduce un precio mayor que 0';

  @override
  String get resultValue => 'Valor';

  @override
  String get settingsSubtitle => 'Unidades, mapa y preferencias';

  @override
  String get settingsSectionPreferences => 'Preferencias de medición';

  @override
  String get settingsSectionMeasureMap => 'Medición y mapa';

  @override
  String get settingsSectionSupport => 'Soporte y legal';

  @override
  String get settingsDefaultMode => 'Tipo de medición predeterminado';

  @override
  String get settingsDefaultModeHint =>
      'Se selecciona en Inicio al abrir la app.';

  @override
  String get settingsGpsAccuracy => 'Mostrar precisión GPS';

  @override
  String get settingsGpsAccuracySubtitle =>
      'Muestra ±m y el círculo de precisión al caminar';

  @override
  String get settingsAutoCenter => 'Centrar mapa automáticamente';

  @override
  String get settingsAutoCenterSubtitle =>
      'Abre los mapas en tu ubicación y te sigue al caminar';

  @override
  String get settingsSavePhotos => 'Guardar fotos en la medición';

  @override
  String get settingsSavePhotosSubtitle =>
      'Adjunta las fotos nuevas sin preguntar';

  @override
  String get settingsKeepAwake => 'Mantener pantalla encendida';

  @override
  String get settingsKeepAwakeSubtitle =>
      'La pantalla no se apaga mientras mides';

  @override
  String get settingsHelpFeedback => 'Ayuda y comentarios';

  @override
  String get settingsRateUs => 'Valóranos';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidad';

  @override
  String get settingsTerms => 'Términos de uso';

  @override
  String settingsVersion(String version, String build) {
    return 'Versión $version ($build)';
  }

  @override
  String get feedbackSubject => 'Comentarios sobre LandMeasure';

  @override
  String feedbackNoEmailApp(String email) {
    return 'No se encontró una app de correo. Escríbenos a $email.';
  }

  @override
  String get linkOpenFailed =>
      'No se pudo abrir el enlace. Inténtalo de nuevo.';

  @override
  String get unitsDistanceTitle => 'Distancia';

  @override
  String get unitsAreaTitle => 'Área';

  @override
  String get unitsSecondary => 'Mostrar unidad secundaria';

  @override
  String unitsSecondaryExample(String example) {
    return 'p. ej. $example';
  }

  @override
  String get unitsNote =>
      'Las mediciones nuevas usan estas unidades. Cada medición también puede cambiar de unidad desde su resultado.';

  @override
  String get unitMeters => 'Metros';

  @override
  String get unitKilometers => 'Kilómetros';

  @override
  String get unitFeet => 'Pies';

  @override
  String get unitMiles => 'Millas';

  @override
  String get unitSquareMeters => 'Metros cuadrados';

  @override
  String get unitHectares => 'Hectáreas';

  @override
  String get unitAcres => 'Acres';

  @override
  String get unitSquareFeet => 'Pies cuadrados';

  @override
  String get mapStyleNote =>
      'Las mediciones nuevas se abren con este mapa. Puedes cambiarlo con el botón Capas del mapa.';

  @override
  String get actionApply => 'Aplicar';

  @override
  String get languageAppLanguages => 'Idiomas de la app';

  @override
  String get languageMachineNote =>
      'Este idioma se tradujo automáticamente y puede contener errores.';

  @override
  String get locationPermissionTitle => 'Permitir acceso a la ubicación';

  @override
  String get locationPermissionMessage =>
      'LandMeasure usa tu ubicación para mostrar dónde estás en el mapa. Se queda en tu teléfono.';

  @override
  String get locationPermissionMeasureMessage =>
      'Muestra dónde estás en el mapa y añade puntos donde te encuentras. Sin ella puedes seguir midiendo moviendo el mapa.';

  @override
  String get locationPermissionWalkMessage =>
      'Caminar y medir graba tu recorrido con GPS mientras esta pantalla está abierta. Tu ubicación se queda en tu teléfono.';

  @override
  String get locationPermissionBlocked =>
      'El acceso a la ubicación está desactivado para LandMeasure. Actívalo en Ajustes para usar tu posición.';

  @override
  String get notificationPermissionTitle => 'Permitir notificaciones';

  @override
  String get notificationPermissionMessage =>
      'Permite las notificaciones para ver el estado de la grabación con la pantalla apagada.';

  @override
  String get actionRetry => 'Reintentar';

  @override
  String get paywallTitle => 'Mide sin límites';

  @override
  String get paywallSubtitle =>
      'Desbloquea proyectos ilimitados y funciones Premium.';

  @override
  String get paywallBenefitNoAds => 'Sin anuncios';

  @override
  String get paywallBenefitSaves => 'Mediciones guardadas ilimitadas';

  @override
  String get paywallBenefitPhotos => 'Fotos ilimitadas por medición';

  @override
  String get paywallBenefitKml => 'Exporta KML cuando quieras';

  @override
  String paywallStartTrial(int days) {
    return 'Empezar prueba gratis de $days días';
  }

  @override
  String paywallTermsTrial(int days, String price, String store) {
    return '$days días gratis, luego $price/año. Se renueva automáticamente: cancela cuando quieras en $store.';
  }

  @override
  String paywallTermsYearly(String price, String store) {
    return '$price/año. Se renueva automáticamente: cancela cuando quieras en $store.';
  }

  @override
  String paywallTermsMonthly(String price, String store) {
    return '$price/mes. Se renueva automáticamente: cancela cuando quieras en $store.';
  }

  @override
  String get paywallRestore => 'Restaurar compras';

  @override
  String get paywallWelcome => '¡Bienvenido a Premium!';

  @override
  String get paywallPending =>
      'Pago pendiente. Premium se activará en cuanto se complete.';

  @override
  String get paywallPurchaseFailed =>
      'La compra no se completó. No se te ha cobrado.';

  @override
  String get paywallRestored => 'Compras restauradas.';

  @override
  String get paywallNothingToRestore =>
      'No se encontraron compras anteriores para esta cuenta de la tienda.';

  @override
  String get paywallRestoreFailed =>
      'No se pudieron restaurar las compras. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get paywallUnavailable =>
      'No se pueden cargar los planes ahora. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get premiumActive => 'Premium activo';

  @override
  String get premiumActiveLifetime => 'Premium activo · De por vida';

  @override
  String get premiumManage => 'Gestionar';

  @override
  String get settingsPremiumTitle => 'LandMeasure Premium';

  @override
  String get settingsPremiumSubtitle =>
      'Sin anuncios, guardados y fotos ilimitados, KML cuando quieras';

  @override
  String get settingsManageSubscription => 'Gestionar suscripción';

  @override
  String get settingsPrivacyChoices => 'Opciones de privacidad';

  @override
  String get settingsAdInspector => 'Ad Inspector (dev)';

  @override
  String get exportUnlockTitle =>
      'Ya usaste la exportación KML gratuita de hoy';

  @override
  String get exportUnlockMessage =>
      'Mira un anuncio breve para exportar este archivo u obtén Premium para exportar KML sin límites. La exportación CSV sigue siendo gratuita.';

  @override
  String get exportWatchAd => 'Ver un anuncio';

  @override
  String get exportGetPremium => 'Obtener Premium';

  @override
  String get exportLoadingAd => 'Cargando anuncio…';

  @override
  String get exportAdDismissed =>
      'Mira el anuncio hasta el final para desbloquear esta exportación.';

  @override
  String get introNext => 'Siguiente';

  @override
  String get introGetStarted => 'Comenzar';

  @override
  String get introAreaTitle => 'Mide áreas fácilmente';

  @override
  String get introAreaBody =>
      'Marca puntos en el mapa para medir terrenos, campos y otras áreas en segundos.';

  @override
  String get introDistanceTitle => 'Mide distancias y rutas';

  @override
  String get introDistanceBody =>
      'Mide distancias en línea recta o registra tu ruta mientras caminas al aire libre.';

  @override
  String get introFieldTitle => 'Hecha para el trabajo de campo';

  @override
  String get introFieldBody =>
      'Mide granjas, parcelas, propiedades y sitios al aire libre con facilidad.';

  @override
  String paywallTrialTitle(int days) {
    return 'Prueba gratis de $days días';
  }

  @override
  String paywallThenMonthly(String price) {
    return 'Luego $price / mes';
  }

  @override
  String get paywallMonthlyTitle => 'Plan mensual';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price / mes';
  }

  @override
  String get paywallYearlyTitle => 'Plan anual';

  @override
  String paywallYearlyOnly(String price) {
    return 'Solo $price al año';
  }

  @override
  String get paywallBestPrice => 'Mejor precio';

  @override
  String get paywallMostPopular => 'Más popular';

  @override
  String get paywallStartFreeTrial => 'Empezar prueba gratis';

  @override
  String paywallTrialThenYearly(int days, String price) {
    return 'Prueba gratis de $days días, luego $price/año';
  }

  @override
  String paywallPricePerYear(String price) {
    return '$price/año';
  }

  @override
  String get paywallCancelAnytime => 'Cancela cuando quieras';

  @override
  String paywallTermsTrialMonthly(int days, String price, String store) {
    return '$days días gratis, luego $price/mes. Se renueva automáticamente: cancela cuando quieras en $store.';
  }

  @override
  String get premiumPromptTitle => 'Pásate a Premium';

  @override
  String premiumPromptPhotos(int count) {
    return 'Puedes añadir hasta $count fotos por medición gratis. Pásate a Premium para añadir más.';
  }

  @override
  String get premiumPromptUpgrade => 'Mejorar';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get languageChooseTitle => 'Elige tu idioma';

  @override
  String premiumPromptMapStyleReward(String style) {
    return 'Los mapas $style son una función Premium. Mira un anuncio corto para usarlo hasta que cierres la app, o mejora para siempre.';
  }

  @override
  String mapStyleUnlocked(String style) {
    return 'Mapa $style desbloqueado hasta que cierres la app.';
  }

  @override
  String get mapStyleAdDismissed =>
      'Mira el anuncio completo para desbloquear este mapa.';

  @override
  String get pdfReportTitleArea => 'Informe de medición de terreno';

  @override
  String get pdfReportTitleDistance => 'Informe de medición de distancia';

  @override
  String get pdfReportTitleWalk => 'Informe de medición a pie';

  @override
  String get pdfReportSubtitle => 'Resumen exportado de una medición guardada';

  @override
  String get pdfHeaderLabel => 'Informe de medición';

  @override
  String get pdfFooterGenerated => 'Generado por LandMeasure';

  @override
  String get pdfFooterEstimate =>
      'Las mediciones por GPS/mapa son estimaciones y pueden variar según el dispositivo y el entorno.';

  @override
  String pdfPage(int page, int pages) {
    return 'Página $page de $pages';
  }

  @override
  String get pdfName => 'Nombre de la medición';

  @override
  String get pdfType => 'Tipo';

  @override
  String get pdfDateSaved => 'Fecha de guardado';

  @override
  String get pdfReportId => 'ID del informe';

  @override
  String get pdfSummary => 'Resumen de la medición';

  @override
  String get pdfArea => 'Área';

  @override
  String get pdfPerimeter => 'Perímetro';

  @override
  String get pdfDistance => 'Distancia';

  @override
  String get pdfDuration => 'Duración';

  @override
  String get pdfPoints => 'Puntos';

  @override
  String get pdfSegments => 'Tramos';

  @override
  String get pdfMethod => 'Método';

  @override
  String get pdfSubBoundaryVertices => 'Vértices del límite';

  @override
  String get pdfSubRoutePoints => 'Puntos de la ruta';

  @override
  String get pdfSubTrackPoints => 'Puntos del recorrido';

  @override
  String get pdfSubSegments => 'Entre puntos';

  @override
  String get pdfMethodMapPoints => 'Puntos en el mapa';

  @override
  String get pdfMethodPolygon => 'Polígono manual';

  @override
  String get pdfMethodRoute => 'Ruta manual';

  @override
  String get pdfAreaNotClosed => 'No cerrada';

  @override
  String get pdfAreaNotClosedSub => 'La ruta no formó un bucle';

  @override
  String get pdfMapBoundary => 'Mapa y forma';

  @override
  String get pdfMapCaption =>
      'Esquema de la forma medida · el norte está arriba';

  @override
  String get pdfCenter => 'Coordenada central';

  @override
  String get pdfMapStyle => 'Estilo de mapa';

  @override
  String get pdfDisplayUnits => 'Unidades mostradas';

  @override
  String get pdfCoordinates => 'Coordenadas';

  @override
  String get pdfCoordinatesHint =>
      'Los puntos aparecen en el orden en que se midieron.';

  @override
  String get pdfColPoint => 'Punto';

  @override
  String get pdfColLatitude => 'Latitud';

  @override
  String get pdfColLongitude => 'Longitud';

  @override
  String get pdfColSegment => 'Tramo';

  @override
  String get pdfColNote => 'Nota';

  @override
  String get pdfNoteStart => 'Inicio';

  @override
  String get pdfNoteEnd => 'Fin';

  @override
  String get pdfNotePhoto => 'Foto adjunta';

  @override
  String pdfMorePoints(int count) {
    return 'No se muestran $count puntos más. Exporta a CSV para obtenerlos todos.';
  }

  @override
  String get pdfNotes => 'Notas de la medición';

  @override
  String get pdfPhotos => 'Fotos del lugar';

  @override
  String pdfPhotoN(int n) {
    return 'Foto $n';
  }

  @override
  String pdfPhotoPoint(String point) {
    return 'En $point';
  }

  @override
  String pdfCaptured(String date) {
    return 'Tomada el $date';
  }

  @override
  String pdfMorePhotos(int count) {
    return 'No se muestran $count fotos más.';
  }

  @override
  String get pdfExportInfo => 'Información de exportación';

  @override
  String get pdfSource => 'Origen';

  @override
  String get pdfSourceAndroid => 'LandMeasure Android';

  @override
  String get pdfSourceIos => 'LandMeasure iOS';

  @override
  String get pdfCoordFormat => 'Formato de coordenadas';

  @override
  String get pdfCoordFormatValue => 'WGS 84 latitud / longitud';

  @override
  String get pdfExported => 'Exportado';

  @override
  String get pdfCompanion => 'Otros formatos de exportación';

  @override
  String get pdfAccuracyTitle => 'Aviso de precisión:';

  @override
  String get pdfAccuracyBody =>
      'Este informe resume mediciones calculadas a partir de puntos del mapa y/o datos GPS del dispositivo. Los resultados son estimaciones y pueden variar según la precisión del dispositivo, la visibilidad de los satélites, las imágenes del mapa, el terreno y la ubicación de los puntos del límite. Este documento no es un levantamiento catastral ni legal certificado, salvo que lo verifique por separado un profesional de topografía autorizado.';

  @override
  String get exportPdf => 'PDF — Informe';

  @override
  String get exportPdfSubtitle =>
      'Informe imprimible con mapa, coordenadas, notas y fotos';

  @override
  String get projectLimitTitle => 'Límite de proyectos gratuitos alcanzado';

  @override
  String get projectLimitMessage =>
      'Tienes 4 proyectos gratuitos. Mira un anuncio completo para crear uno más o consigue Premium para crear proyectos ilimitados.';

  @override
  String get projectRewardRequired =>
      'Termina de ver un anuncio para desbloquear otro proyecto. Si no hay anuncios disponibles, inténtalo más tarde o consigue Premium.';
}
