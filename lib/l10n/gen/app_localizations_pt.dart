// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'LandMeasure';

  @override
  String get navHome => 'Início';

  @override
  String get navSaved => 'Salvas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get measurementTypeArea => 'Área';

  @override
  String get measurementTypeDistance => 'Distância';

  @override
  String get measurementTypeWalk => 'Caminhada';

  @override
  String get screenMeasureArea => 'Medir área';

  @override
  String get screenMeasureDistance => 'Medir distância';

  @override
  String get screenWalk => 'Caminhar e medir';

  @override
  String get screenSave => 'Salvar medição';

  @override
  String get screenDetail => 'Detalhes da medição';

  @override
  String get screenFullMap => 'Mapa';

  @override
  String get screenEdit => 'Editar medição';

  @override
  String get screenSaved => 'Medições salvas';

  @override
  String get screenSettings => 'Ajustes';

  @override
  String get screenUnits => 'Unidades';

  @override
  String get screenMapStyle => 'Estilo do mapa';

  @override
  String get screenLanguage => 'Idioma';

  @override
  String get screenPaywall => 'Premium';

  @override
  String get ctaStartMeasuring => 'Comece a medir';

  @override
  String get ctaStartArea => 'Medir uma área';

  @override
  String get ctaStartDistance => 'Medir uma distância';

  @override
  String get ctaStartWalk => 'Medir caminhando';

  @override
  String get ctaSaveMeasurement => 'Salvar medição';

  @override
  String get ctaSaveRoute => 'Salvar rota';

  @override
  String get ctaPause => 'Pausar';

  @override
  String get ctaResume => 'Retomar';

  @override
  String get ctaFinish => 'Concluir';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionSave => 'Salvar';

  @override
  String get actionDiscard => 'Descartar';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get actionReset => 'Redefinir';

  @override
  String get actionOpenSettings => 'Abrir Ajustes';

  @override
  String get actionKeepRecording => 'Continuar gravando';

  @override
  String get actionKeepEditing => 'Continuar editando';

  @override
  String get dialogResetTitle => 'Redefinir a medição?';

  @override
  String get dialogResetMessage => 'Todos os pontos serão removidos.';

  @override
  String get dialogDiscardDraftTitle => 'Descartar este rascunho?';

  @override
  String get dialogDiscardDraftMessage =>
      'Todos os pontos e alterações não salvas serão removidos.';

  @override
  String get dialogDeleteTitle => 'Excluir a medição?';

  @override
  String get dialogDeleteMessage =>
      'Esta medição, suas fotos e notas serão excluídas permanentemente.';

  @override
  String get dialogFinishWalkTitle => 'Concluir a gravação?';

  @override
  String get dialogFinishWalkMessage =>
      'O rastreamento por GPS será interrompido.';

  @override
  String get dialogRenameTitle => 'Renomear medição';

  @override
  String get dialogDiscardChangesTitle => 'Descartar alterações?';

  @override
  String get fabLayers => 'Camadas do mapa';

  @override
  String get fabMyLocation => 'Minha localização';

  @override
  String get fabSearch => 'Buscar local';

  @override
  String get fabCamera => 'Tirar foto';

  @override
  String get gpsReady => 'GPS pronto';

  @override
  String get gpsSearching => 'Procurando GPS…';

  @override
  String get gpsLowAccuracy => 'Precisão do GPS baixa';

  @override
  String get locationOff => 'A localização está desativada';

  @override
  String get locationOffMessage =>
      'Ative a localização para gravar sua caminhada.';

  @override
  String get mapOffline => 'Sem conexão com o mapa — seus pontos estão seguros';

  @override
  String get emptyNoMeasurementsTitle => 'Nenhuma medição ainda';

  @override
  String get emptyNoMeasurementsMessage =>
      'Meça seu primeiro terreno e ele aparecerá aqui.';

  @override
  String get languageSystem => 'Padrão do sistema';

  @override
  String get measureHintCrosshair =>
      'Mova o mapa para posicionar a mira e toque em Adicionar ponto.';

  @override
  String get measureHintTap =>
      'Toque no mapa para adicionar pontos ao redor do limite.';

  @override
  String get toolbarUndo => 'Desfazer';

  @override
  String get toolbarAddPoint => 'Adicionar ponto';

  @override
  String get toolbarClose => 'Fechar forma';

  @override
  String get toolbarReset => 'Redefinir';

  @override
  String get toolbarAddAtMyLocation => 'Adicionar ponto na minha localização';

  @override
  String get resultArea => 'Área';

  @override
  String get resultPerimeter => 'Perímetro';

  @override
  String get resultAreaNeedsPoints =>
      'Adicione pelo menos 3 pontos para calcular a área';

  @override
  String resultPointCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pontos',
      one: '1 ponto',
    );
    return '$_temp0';
  }

  @override
  String get edgesCross => 'Os lados se cruzam — a área pode estar incorreta';

  @override
  String get menuMore => 'Mais opções';

  @override
  String get menuInputCrosshair => 'Adicionar com a mira';

  @override
  String get menuInputTap => 'Adicionar tocando no mapa';

  @override
  String get menuShowEdgeLabels => 'Mostrar comprimento dos lados';

  @override
  String pointLabel(int number) {
    return 'Ponto $number';
  }

  @override
  String get pointDelete => 'Excluir ponto';

  @override
  String get pointDeselect => 'Pronto';

  @override
  String gpsLowAccuracyAdded(int meters) {
    return 'A precisão do GPS está baixa (±$meters m). O ponto foi adicionado mesmo assim.';
  }

  @override
  String get locationUnavailable =>
      'Não foi possível obter sua localização. Tente ao ar livre.';

  @override
  String get locationPermissionDenied =>
      'O acesso à localização está desativado. Você ainda pode medir movendo o mapa.';

  @override
  String get locationServiceOff =>
      'A localização está desativada neste dispositivo.';

  @override
  String get mapLayersTitle => 'Tipo de mapa';

  @override
  String get mapStyleStandard => 'Padrão';

  @override
  String get mapStyleSatellite => 'Satélite';

  @override
  String get mapStyleTerrain => 'Relevo';

  @override
  String get mapStyleHybrid => 'Híbrido';

  @override
  String get draftSaveFailed =>
      'Não foi possível salvar seus pontos. Eles serão salvos novamente na próxima alteração.';

  @override
  String get menuHelp => 'Ajuda';

  @override
  String get actionGotIt => 'Entendi';

  @override
  String get helpTitleArea => 'Como medir uma área';

  @override
  String get helpTitleDistance => 'Como medir uma distância';

  @override
  String get helpTitleWalk => 'Como medir caminhando';

  @override
  String get helpAreaSummary =>
      'Adicione pontos ao redor do limite do seu terreno.';

  @override
  String get helpDistanceSummary =>
      'Adicione pontos ao longo da rota que você quer medir.';

  @override
  String get helpWalkSummary =>
      'Caminhe pelo limite enquanto o LandMeasure grava seu trajeto GPS.';

  @override
  String get helpPhotoTip =>
      'Use fotos para registrar marcos, divisas ou as condições do terreno.';

  @override
  String get helpAccuracyNote =>
      'A precisão do GPS e das medições no mapa pode variar conforme o dispositivo, as imagens do mapa e o ambiente.';

  @override
  String get helpAreaStep1 =>
      'Mova o mapa até a mira ficar sobre um canto e toque em **Adicionar ponto**.';

  @override
  String get helpAreaStep2 =>
      'Adicione pelo menos 3 pontos ao redor do limite. Arraste um ponto para ajustá-lo.';

  @override
  String get helpAreaStep3 =>
      'Toque em **Fechar forma** para concluir e depois em **Salvar medição**.';

  @override
  String get helpDistanceStep1 =>
      'Posicione a mira no início da rota e toque em **Adicionar ponto**.';

  @override
  String get helpDistanceStep2 =>
      'Continue adicionando pontos ao longo da rota. O comprimento de cada trecho aparece no mapa.';

  @override
  String get helpDistanceStep3 => 'Toque em **Salvar rota** quando terminar.';

  @override
  String get helpWalkStep1 =>
      'Aguarde **GPS pronto** e toque em **Começar a caminhar**.';

  @override
  String get helpWalkStep2 =>
      'Caminhe pelo limite. Use **Pausar** se precisar parar.';

  @override
  String get helpWalkStep3 =>
      'Volte ao ponto de partida e toque em **Concluir** para calcular a área.';

  @override
  String get helpTipGpsPoint =>
      'Dica: toque em 📍 para adicionar um ponto na sua localização GPS atual.';

  @override
  String get helpTipWalk =>
      'Dica: fique em áreas abertas para uma melhor precisão do GPS.';

  @override
  String get resultDistance => 'Distância';

  @override
  String get resultDistanceNeedsPoints =>
      'Adicione pelo menos 2 pontos para medir a distância';

  @override
  String resultSegmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trechos',
      one: '1 trecho',
    );
    return '$_temp0';
  }

  @override
  String get segmentsTitle => 'Trechos';

  @override
  String draftSavedSnack(int count, String type) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rascunho salvo · $type · $count pontos',
      one: 'Rascunho salvo · $type · 1 ponto',
    );
    return '$_temp0';
  }

  @override
  String get searchHint => 'Endereço, coordenadas ou link do Google Maps';

  @override
  String get searchAction => 'Buscar';

  @override
  String get searchRecent => 'Buscas recentes';

  @override
  String get searchNoResults =>
      'Nenhum local encontrado. Tente coordenadas ou um link do Google Maps.';

  @override
  String get searchNeedsInternet =>
      'Buscar um endereço requer conexão com a internet.';

  @override
  String get searchUnavailable =>
      'A busca de endereços não está disponível neste dispositivo. Tente coordenadas ou um link do Google Maps.';

  @override
  String get searchClear => 'Limpar';

  @override
  String get searchFailed =>
      'Não foi possível buscar este endereço agora. Tente coordenadas ou um link do Google Maps.';

  @override
  String get ctaStartWalking => 'Começar a caminhar';

  @override
  String get walkReadyHelper => 'Caminhe pelo limite para gravar seu trajeto.';

  @override
  String get keepScreenOn => 'Manter a tela ligada';

  @override
  String get walkRecording => 'Gravando GPS…';

  @override
  String get walkPaused => 'Pausado';

  @override
  String get walkPausedMessage =>
      'Toque em Retomar para continuar de onde você está.';

  @override
  String gpsAccuracyShort(int meters) {
    return '±$meters m';
  }

  @override
  String gpsLowAccuracyMessage(int meters) {
    return 'Precisão ±$meters m — os pontos não são gravados até melhorar. Vá para uma área aberta.';
  }

  @override
  String get locationDeniedTitle => 'O acesso à localização está desativado';

  @override
  String get locationDeniedMessage =>
      'Permita a localização para gravar sua caminhada.';

  @override
  String get actionAllow => 'Permitir';

  @override
  String get actionNotNow => 'Agora não';

  @override
  String get mockLocationDetected =>
      'Localização simulada detectada — essas posições não são gravadas.';

  @override
  String get walkCloseToStart =>
      'Perto do início — conclua para calcular a área';

  @override
  String get walkNotClosed => 'Rota não fechada — somente distância';

  @override
  String get walkKeepWalking => 'Volte ao início para fechar o trajeto.';

  @override
  String get resultDuration => 'Duração';

  @override
  String get walkNotificationTitle => 'O LandMeasure está gravando sua medição';

  @override
  String get walkNotificationText => 'Toque para voltar à sua caminhada.';

  @override
  String get walkNotificationChannel => 'Gravação de caminhada';

  @override
  String get walkRecordingBack =>
      'Gravação em andamento. Pause ou conclua antes de sair.';

  @override
  String get walkPauseAndLeave => 'Pausar e sair';

  @override
  String get walkStartFailed =>
      'Não foi possível iniciar a gravação. Tente novamente.';

  @override
  String get batteryHintTitle =>
      'Permita que o LandMeasure funcione em segundo plano';

  @override
  String get batteryHintMessage =>
      'Alguns celulares interrompem apps com a tela desligada. Para continuar gravando sua caminhada, abra Configurações → Bateria e escolha \"Sem restrições\" para o LandMeasure.';

  @override
  String get fabRecenter => 'Recentralizar';

  @override
  String get homeHeroSubtitle => 'Escolha um método para medir seu terreno.';

  @override
  String get homeContinueTitle => 'Continuar medição';

  @override
  String get homeSeeAllDrafts => 'Ver todos os rascunhos';

  @override
  String get homeRecentTitle => 'Medições recentes';

  @override
  String get homeRecentEmptyTitle => 'Nenhuma medição recente';

  @override
  String get homeRecentEmptyMessage => 'As medições salvas aparecerão aqui.';

  @override
  String get actionSeeAll => 'Ver tudo';

  @override
  String get untitledArea => 'Área sem nome';

  @override
  String get untitledDistance => 'Distância sem nome';

  @override
  String get untitledWalk => 'Caminhada sem nome';

  @override
  String get draftLabel => 'Rascunho';

  @override
  String get walkFinishedNotSaved => 'Concluída · não salva';

  @override
  String lastEdited(String time) {
    return 'Editado $time';
  }

  @override
  String get timeJustNow => 'agora mesmo';

  @override
  String timeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count min',
      one: 'há 1 min',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count horas',
      one: 'há 1 hora',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count dias',
      one: 'ontem',
    );
    return '$_temp0';
  }

  @override
  String get savedSearchHint => 'Buscar por nome';

  @override
  String get savedSearchOpen => 'Buscar';

  @override
  String get savedSearchClose => 'Fechar busca';

  @override
  String get filterAll => 'Todas';

  @override
  String filterWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String savedDraftsTitle(int count) {
    return 'Rascunhos ($count)';
  }

  @override
  String get savedNoResults => 'Nenhuma medição encontrada.';

  @override
  String get menuRename => 'Renomear';

  @override
  String get menuExport => 'Exportar';

  @override
  String get measurementDeleted => 'Medição excluída';

  @override
  String get draftDiscarded => 'Rascunho descartado';

  @override
  String get exportTitle => 'Exportar';

  @override
  String get renameHint => 'Nome da medição';

  @override
  String get saveNameLabel => 'Nome';

  @override
  String get saveNameRequired => 'O nome é obrigatório';

  @override
  String get saveNotesLabel => 'Notas';

  @override
  String get saveNotesHint => 'Divisas, proprietário, referências… (opcional)';

  @override
  String get saveTypeLabel => 'Tipo';

  @override
  String get saveFailed => 'Não foi possível salvar. Tente novamente.';

  @override
  String get saveLimitReached =>
      'Você atingiu o limite gratuito de medições salvas. Esta continua nos seus rascunhos.';

  @override
  String get saveNotFound => 'Esta medição não existe mais.';

  @override
  String photosTitle(int count) {
    return 'Fotos do terreno ($count)';
  }

  @override
  String get actionClose => 'Fechar';

  @override
  String get resultPoints => 'Pontos';

  @override
  String get resultSegments => 'Trechos';

  @override
  String get resultAvgPace => 'Ritmo médio';

  @override
  String paceValue(String time, String unit) {
    return '$time /$unit';
  }

  @override
  String get notesTitle => 'Notas';

  @override
  String get notesEmpty => 'Sem notas';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionExport => 'Exportar';

  @override
  String get detailOpenMap => 'Abrir mapa';

  @override
  String savedOn(String date) {
    return 'Salva em $date';
  }

  @override
  String get addPhotoTitle => 'Adicionar foto';

  @override
  String get addPhotoCamera => 'Tirar foto';

  @override
  String get addPhotoGallery => 'Escolher da galeria';

  @override
  String addPhotoForPoint(int number) {
    return 'Para o ponto $number';
  }

  @override
  String get addPhotoTile => 'Adicionar foto';

  @override
  String get photoAddFailed =>
      'Não foi possível adicionar a foto. Tente novamente.';

  @override
  String get photoRemoved => 'Foto removida';

  @override
  String get actionUndo => 'Desfazer';

  @override
  String get photoLimitReached =>
      'Você atingiu o limite gratuito de fotos para esta medição.';

  @override
  String get photoDeleteTitle => 'Excluir a foto?';

  @override
  String get photoDeleteMessage => 'Esta foto será removida da medição.';

  @override
  String get photoAttachTitle => 'Anexar esta foto à medição?';

  @override
  String get photoAttachMessage =>
      '\"Salvar fotos na medição\" está desativado em Ajustes.';

  @override
  String get actionAttach => 'Anexar';

  @override
  String get photoWaitForStart => 'Comece a caminhar para adicionar fotos.';

  @override
  String photoCounter(int index, int total) {
    return '$index / $total';
  }

  @override
  String get photoShare => 'Compartilhar';

  @override
  String photoOpen(int number) {
    return 'Abrir foto $number';
  }

  @override
  String get photoRemove => 'Remover foto';

  @override
  String get pointPhoto => 'Foto';

  @override
  String get cameraPermissionTitle => 'Permitir acesso à câmera';

  @override
  String get cameraPermissionMessage =>
      'Fotografe marcos, divisas e as condições do terreno e guarde tudo com sua medição.';

  @override
  String get cameraPermissionDenied =>
      'O acesso à câmera está desativado. Você pode ativá-lo em Configurações.';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get notesEditTitle => 'Editar notas';

  @override
  String get notesAdd => 'Adicionar notas';

  @override
  String get editTabResult => 'Resultado';

  @override
  String get editTabDetails => 'Detalhes';

  @override
  String get ctaSaveChanges => 'Salvar alterações';

  @override
  String get dialogDiscardChangesMessage =>
      'Suas alterações nesta medição serão perdidas.';

  @override
  String get changesSaved => 'Alterações salvas';

  @override
  String get menuReopenShape => 'Reabrir forma';

  @override
  String get exportKml => 'KML — Google Earth';

  @override
  String get exportKmlSubtitle =>
      'Forma e pontos com foto para o Google Earth e apps de SIG';

  @override
  String get exportCsv => 'CSV — Excel';

  @override
  String get exportCsvSubtitle => 'Cada ponto com coordenadas, para planilhas';

  @override
  String get exportPreparing => 'Preparando arquivo…';

  @override
  String get exportFailed => 'Não foi possível exportar. Tente novamente.';

  @override
  String get exportLimitReached =>
      'A exportação KML gratuita de hoje já foi usada. A exportação CSV continua gratuita.';

  @override
  String get landValueTitle => 'Valor do terreno';

  @override
  String get landValueAdd => 'Adicionar valor do terreno';

  @override
  String get landValueUnitPrice => 'Preço unitário';

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
      'O valor do terreno precisa de uma área (feche a forma).';

  @override
  String get landValueRemove => 'Remover';

  @override
  String get landValueInvalid => 'Digite um preço maior que 0';

  @override
  String get resultValue => 'Valor';

  @override
  String get settingsSubtitle => 'Unidades, mapa e preferências';

  @override
  String get settingsSectionPreferences => 'Preferências de medição';

  @override
  String get settingsSectionMeasureMap => 'Medição e mapa';

  @override
  String get settingsSectionSupport => 'Suporte e legal';

  @override
  String get settingsDefaultMode => 'Tipo de medição padrão';

  @override
  String get settingsDefaultModeHint => 'Selecionado no Início ao abrir o app.';

  @override
  String get settingsGpsAccuracy => 'Mostrar precisão do GPS';

  @override
  String get settingsGpsAccuracySubtitle =>
      'Mostra ±m e o círculo de precisão ao caminhar';

  @override
  String get settingsAutoCenter => 'Centralizar mapa automaticamente';

  @override
  String get settingsAutoCenterSubtitle =>
      'Abre os mapas na sua localização e segue você ao caminhar';

  @override
  String get settingsSavePhotos => 'Salvar fotos na medição';

  @override
  String get settingsSavePhotosSubtitle => 'Anexa novas fotos sem perguntar';

  @override
  String get settingsKeepAwake => 'Manter tela ligada';

  @override
  String get settingsKeepAwakeSubtitle => 'A tela não apaga enquanto você mede';

  @override
  String get settingsHelpFeedback => 'Ajuda e feedback';

  @override
  String get settingsRateUs => 'Avalie-nos';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidade';

  @override
  String get settingsTerms => 'Termos de uso';

  @override
  String settingsVersion(String version, String build) {
    return 'Versão $version ($build)';
  }

  @override
  String get feedbackSubject => 'Feedback do LandMeasure';

  @override
  String feedbackNoEmailApp(String email) {
    return 'Nenhum app de e-mail encontrado. Escreva para $email.';
  }

  @override
  String get linkOpenFailed =>
      'Não foi possível abrir o link. Tente novamente.';

  @override
  String get unitsDistanceTitle => 'Distância';

  @override
  String get unitsAreaTitle => 'Área';

  @override
  String get unitsSecondary => 'Mostrar unidade secundária';

  @override
  String unitsSecondaryExample(String example) {
    return 'ex.: $example';
  }

  @override
  String get unitsNote =>
      'Novas medições usam estas unidades. Cada medição também pode trocar de unidade no resultado.';

  @override
  String get unitMeters => 'Metros';

  @override
  String get unitKilometers => 'Quilômetros';

  @override
  String get unitFeet => 'Pés';

  @override
  String get unitMiles => 'Milhas';

  @override
  String get unitSquareMeters => 'Metros quadrados';

  @override
  String get unitHectares => 'Hectares';

  @override
  String get unitAcres => 'Acres';

  @override
  String get unitSquareFeet => 'Pés quadrados';

  @override
  String get mapStyleNote =>
      'Novas medições abrem com este mapa. Você pode trocá-lo pelo botão Camadas do mapa.';

  @override
  String get actionApply => 'Aplicar';

  @override
  String get languageAppLanguages => 'Idiomas do app';

  @override
  String get languageMachineNote =>
      'Este idioma foi traduzido automaticamente e pode conter erros.';

  @override
  String get locationPermissionTitle => 'Permitir acesso à localização';

  @override
  String get locationPermissionMessage =>
      'O LandMeasure usa sua localização para mostrar onde você está no mapa. Ela fica no seu celular.';

  @override
  String get locationPermissionMeasureMessage =>
      'Mostre onde você está no mapa e adicione pontos onde você está. Sem ela, você ainda pode medir movendo o mapa.';

  @override
  String get locationPermissionWalkMessage =>
      'Caminhar e medir grava seu trajeto com GPS enquanto esta tela está aberta. Sua localização fica no seu celular.';

  @override
  String get locationPermissionBlocked =>
      'O acesso à localização está desativado para o LandMeasure. Ative-o em Configurações para usar sua posição.';

  @override
  String get notificationPermissionTitle => 'Permitir notificações';

  @override
  String get notificationPermissionMessage =>
      'Permita notificações para ver o status da gravação com a tela desligada.';

  @override
  String get actionRetry => 'Tentar novamente';

  @override
  String get paywallTitle => 'Meça sem limites';

  @override
  String get paywallSubtitle =>
      'Desbloqueie projetos ilimitados e recursos Premium.';

  @override
  String get paywallBenefitNoAds => 'Sem anúncios';

  @override
  String get paywallBenefitSaves => 'Medições salvas ilimitadas';

  @override
  String get paywallBenefitPhotos => 'Fotos ilimitadas por medição';

  @override
  String get paywallBenefitKml => 'Exporte KML quando quiser';

  @override
  String paywallStartTrial(int days) {
    return 'Iniciar teste grátis de $days dias';
  }

  @override
  String paywallTermsTrial(int days, String price, String store) {
    return '$days dias grátis, depois $price/ano. Renova automaticamente — cancele quando quiser na $store.';
  }

  @override
  String paywallTermsYearly(String price, String store) {
    return '$price/ano. Renova automaticamente — cancele quando quiser na $store.';
  }

  @override
  String paywallTermsMonthly(String price, String store) {
    return '$price/mês. Renova automaticamente — cancele quando quiser na $store.';
  }

  @override
  String get paywallRestore => 'Restaurar compras';

  @override
  String get paywallWelcome => 'Bem-vindo ao Premium!';

  @override
  String get paywallPending =>
      'Pagamento pendente. O Premium será liberado assim que for concluído.';

  @override
  String get paywallPurchaseFailed =>
      'A compra não foi concluída. Você não foi cobrado.';

  @override
  String get paywallRestored => 'Compras restauradas.';

  @override
  String get paywallNothingToRestore =>
      'Nenhuma compra anterior encontrada para esta conta da loja.';

  @override
  String get paywallRestoreFailed =>
      'Não foi possível restaurar as compras. Verifique a conexão e tente novamente.';

  @override
  String get paywallUnavailable =>
      'Não foi possível carregar os planos agora. Verifique a conexão e tente novamente.';

  @override
  String get premiumActive => 'Premium ativo';

  @override
  String get premiumActiveLifetime => 'Premium ativo · Vitalício';

  @override
  String get premiumManage => 'Gerenciar';

  @override
  String get settingsPremiumTitle => 'LandMeasure Premium';

  @override
  String get settingsPremiumSubtitle =>
      'Sem anúncios, salvamentos e fotos ilimitados, KML quando quiser';

  @override
  String get settingsManageSubscription => 'Gerenciar assinatura';

  @override
  String get settingsPrivacyChoices => 'Opções de privacidade';

  @override
  String get settingsAdInspector => 'Ad Inspector (dev)';

  @override
  String get exportUnlockTitle =>
      'A exportação KML gratuita de hoje já foi usada';

  @override
  String get exportUnlockMessage =>
      'Assista a um anúncio curto para exportar este arquivo ou assine o Premium para exportar KML sem limites. A exportação CSV continua gratuita.';

  @override
  String get exportWatchAd => 'Assistir a um anúncio';

  @override
  String get exportGetPremium => 'Assinar o Premium';

  @override
  String get exportLoadingAd => 'Carregando anúncio…';

  @override
  String get exportAdDismissed =>
      'Assista ao anúncio até o fim para liberar esta exportação.';

  @override
  String get introNext => 'Avançar';

  @override
  String get introGetStarted => 'Começar';

  @override
  String get introAreaTitle => 'Meça áreas com facilidade';

  @override
  String get introAreaBody =>
      'Marque pontos no mapa para medir terrenos, campos e outras áreas em segundos.';

  @override
  String get introDistanceTitle => 'Meça distâncias e rotas';

  @override
  String get introDistanceBody =>
      'Meça distâncias em linha reta ou registre seu trajeto enquanto caminha ao ar livre.';

  @override
  String get introFieldTitle => 'Feito para o trabalho de campo';

  @override
  String get introFieldBody =>
      'Meça fazendas, lotes, propriedades e locais ao ar livre com facilidade.';

  @override
  String paywallTrialTitle(int days) {
    return 'Teste grátis de $days dias';
  }

  @override
  String paywallThenMonthly(String price) {
    return 'Depois $price / mês';
  }

  @override
  String get paywallMonthlyTitle => 'Plano mensal';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price / mês';
  }

  @override
  String get paywallYearlyTitle => 'Plano anual';

  @override
  String paywallYearlyOnly(String price) {
    return 'Apenas $price por ano';
  }

  @override
  String get paywallBestPrice => 'Melhor preço';

  @override
  String get paywallMostPopular => 'Mais popular';

  @override
  String get paywallStartFreeTrial => 'Iniciar teste grátis';

  @override
  String paywallTrialThenYearly(int days, String price) {
    return 'Teste grátis de $days dias, depois $price/ano';
  }

  @override
  String paywallPricePerYear(String price) {
    return '$price/ano';
  }

  @override
  String get paywallCancelAnytime => 'Cancele quando quiser';

  @override
  String paywallTermsTrialMonthly(int days, String price, String store) {
    return '$days dias grátis, depois $price/mês. Renova automaticamente — cancele quando quiser em $store.';
  }

  @override
  String get premiumPromptTitle => 'Assine o Premium';

  @override
  String premiumPromptPhotos(int count) {
    return 'Você pode adicionar até $count fotos por medição gratuitamente. Assine o Premium para adicionar mais.';
  }

  @override
  String get premiumPromptUpgrade => 'Assinar';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get languageChooseTitle => 'Escolha seu idioma';

  @override
  String premiumPromptMapStyleReward(String style) {
    return 'Os mapas $style são um recurso Premium. Assista a um anúncio curto para usar até fechar o app, ou assine para sempre.';
  }

  @override
  String mapStyleUnlocked(String style) {
    return 'Mapa $style desbloqueado até você fechar o app.';
  }

  @override
  String get mapStyleAdDismissed =>
      'Assista ao anúncio até o fim para desbloquear este mapa.';

  @override
  String get pdfReportTitleArea => 'Relatório de medição de terreno';

  @override
  String get pdfReportTitleDistance => 'Relatório de medição de distância';

  @override
  String get pdfReportTitleWalk => 'Relatório de medição a pé';

  @override
  String get pdfReportSubtitle => 'Resumo exportado de uma medição salva';

  @override
  String get pdfHeaderLabel => 'Relatório de medição';

  @override
  String get pdfFooterGenerated => 'Gerado pelo LandMeasure';

  @override
  String get pdfFooterEstimate =>
      'As medições por GPS/mapa são estimativas e podem variar conforme o dispositivo e o ambiente.';

  @override
  String pdfPage(int page, int pages) {
    return 'Página $page de $pages';
  }

  @override
  String get pdfName => 'Nome da medição';

  @override
  String get pdfType => 'Tipo';

  @override
  String get pdfDateSaved => 'Data de salvamento';

  @override
  String get pdfReportId => 'ID do relatório';

  @override
  String get pdfSummary => 'Resumo da medição';

  @override
  String get pdfArea => 'Área';

  @override
  String get pdfPerimeter => 'Perímetro';

  @override
  String get pdfDistance => 'Distância';

  @override
  String get pdfDuration => 'Duração';

  @override
  String get pdfPoints => 'Pontos';

  @override
  String get pdfSegments => 'Trechos';

  @override
  String get pdfMethod => 'Método';

  @override
  String get pdfSubBoundaryVertices => 'Vértices do limite';

  @override
  String get pdfSubRoutePoints => 'Pontos da rota';

  @override
  String get pdfSubTrackPoints => 'Pontos do percurso';

  @override
  String get pdfSubSegments => 'Entre pontos';

  @override
  String get pdfMethodMapPoints => 'Pontos no mapa';

  @override
  String get pdfMethodPolygon => 'Polígono manual';

  @override
  String get pdfMethodRoute => 'Rota manual';

  @override
  String get pdfAreaNotClosed => 'Não fechada';

  @override
  String get pdfAreaNotClosedSub => 'A rota não formou um laço';

  @override
  String get pdfMapBoundary => 'Mapa e forma';

  @override
  String get pdfMapCaption => 'Esquema da forma medida · o norte está no topo';

  @override
  String get pdfCenter => 'Coordenada central';

  @override
  String get pdfMapStyle => 'Estilo de mapa';

  @override
  String get pdfDisplayUnits => 'Unidades exibidas';

  @override
  String get pdfCoordinates => 'Coordenadas';

  @override
  String get pdfCoordinatesHint =>
      'Os pontos estão listados na ordem em que foram medidos.';

  @override
  String get pdfColPoint => 'Ponto';

  @override
  String get pdfColLatitude => 'Latitude';

  @override
  String get pdfColLongitude => 'Longitude';

  @override
  String get pdfColSegment => 'Trecho';

  @override
  String get pdfColNote => 'Nota';

  @override
  String get pdfNoteStart => 'Início';

  @override
  String get pdfNoteEnd => 'Fim';

  @override
  String get pdfNotePhoto => 'Foto anexada';

  @override
  String pdfMorePoints(int count) {
    return '$count pontos a mais não são exibidos. Exporte em CSV para obter todos.';
  }

  @override
  String get pdfNotes => 'Notas da medição';

  @override
  String get pdfPhotos => 'Fotos do local';

  @override
  String pdfPhotoN(int n) {
    return 'Foto $n';
  }

  @override
  String pdfPhotoPoint(String point) {
    return 'Em $point';
  }

  @override
  String pdfCaptured(String date) {
    return 'Tirada em $date';
  }

  @override
  String pdfMorePhotos(int count) {
    return '$count fotos a mais não são exibidas.';
  }

  @override
  String get pdfExportInfo => 'Informações de exportação';

  @override
  String get pdfSource => 'Origem';

  @override
  String get pdfSourceAndroid => 'LandMeasure Android';

  @override
  String get pdfSourceIos => 'LandMeasure iOS';

  @override
  String get pdfCoordFormat => 'Formato de coordenadas';

  @override
  String get pdfCoordFormatValue => 'WGS 84 latitude / longitude';

  @override
  String get pdfExported => 'Exportado';

  @override
  String get pdfCompanion => 'Outros formatos de exportação';

  @override
  String get pdfAccuracyTitle => 'Aviso de precisão:';

  @override
  String get pdfAccuracyBody =>
      'Este relatório resume medições calculadas a partir de pontos no mapa e/ou dados de GPS do dispositivo. Os resultados são estimativas e podem variar conforme a precisão do dispositivo, a visibilidade dos satélites, as imagens do mapa, o terreno e a posição dos pontos do limite. Este documento não é um levantamento cadastral ou legal certificado, a menos que seja verificado separadamente por um profissional de topografia autorizado.';

  @override
  String get exportPdf => 'PDF — Relatório';

  @override
  String get exportPdfSubtitle =>
      'Relatório para imprimir com mapa, coordenadas, notas e fotos';

  @override
  String get projectLimitTitle => 'Limite de projetos gratuitos atingido';

  @override
  String get projectLimitMessage =>
      'Você tem 4 projetos gratuitos. Assista a um anúncio completo para criar mais um ou assine o Premium para projetos ilimitados.';

  @override
  String get projectRewardRequired =>
      'Assista ao anúncio até o fim para desbloquear outro projeto. Se não houver anúncios disponíveis, tente mais tarde ou assine o Premium.';
}
