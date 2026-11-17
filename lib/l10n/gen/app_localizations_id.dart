// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'LandMeasure';

  @override
  String get navHome => 'Beranda';

  @override
  String get navSaved => 'Tersimpan';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get measurementTypeArea => 'Luas';

  @override
  String get measurementTypeDistance => 'Jarak';

  @override
  String get measurementTypeWalk => 'Jalan';

  @override
  String get screenMeasureArea => 'Ukur luas';

  @override
  String get screenMeasureDistance => 'Ukur jarak';

  @override
  String get screenWalk => 'Jalan & ukur';

  @override
  String get screenSave => 'Simpan pengukuran';

  @override
  String get screenDetail => 'Detail pengukuran';

  @override
  String get screenFullMap => 'Peta';

  @override
  String get screenEdit => 'Edit pengukuran';

  @override
  String get screenSaved => 'Pengukuran tersimpan';

  @override
  String get screenSettings => 'Pengaturan';

  @override
  String get screenUnits => 'Satuan';

  @override
  String get screenMapStyle => 'Gaya peta';

  @override
  String get screenLanguage => 'Bahasa';

  @override
  String get screenPaywall => 'Premium';

  @override
  String get ctaStartMeasuring => 'Mulai mengukur';

  @override
  String get ctaStartArea => 'Mulai ukur luas';

  @override
  String get ctaStartDistance => 'Mulai ukur jarak';

  @override
  String get ctaStartWalk => 'Mulai ukur sambil jalan';

  @override
  String get ctaSaveMeasurement => 'Simpan pengukuran';

  @override
  String get ctaSaveRoute => 'Simpan rute';

  @override
  String get ctaPause => 'Jeda';

  @override
  String get ctaResume => 'Lanjutkan';

  @override
  String get ctaFinish => 'Selesai';

  @override
  String get actionCancel => 'Batal';

  @override
  String get actionSave => 'Simpan';

  @override
  String get actionDiscard => 'Buang';

  @override
  String get actionDelete => 'Hapus';

  @override
  String get actionReset => 'Atur ulang';

  @override
  String get actionOpenSettings => 'Buka Pengaturan';

  @override
  String get actionKeepRecording => 'Terus merekam';

  @override
  String get actionKeepEditing => 'Terus mengedit';

  @override
  String get dialogResetTitle => 'Atur ulang pengukuran?';

  @override
  String get dialogResetMessage => 'Semua titik akan dihapus.';

  @override
  String get dialogDiscardDraftTitle => 'Buang draf ini?';

  @override
  String get dialogDiscardDraftMessage =>
      'Semua titik dan perubahan yang belum disimpan akan dihapus.';

  @override
  String get dialogDeleteTitle => 'Hapus pengukuran?';

  @override
  String get dialogDeleteMessage =>
      'Pengukuran ini beserta foto dan catatannya akan dihapus permanen.';

  @override
  String get dialogFinishWalkTitle => 'Selesai merekam?';

  @override
  String get dialogFinishWalkMessage => 'Pelacakan GPS akan berhenti.';

  @override
  String get dialogRenameTitle => 'Ganti nama pengukuran';

  @override
  String get dialogDiscardChangesTitle => 'Buang perubahan?';

  @override
  String get fabLayers => 'Lapisan peta';

  @override
  String get fabMyLocation => 'Lokasi saya';

  @override
  String get fabSearch => 'Cari tempat';

  @override
  String get fabCamera => 'Ambil foto';

  @override
  String get gpsReady => 'GPS siap';

  @override
  String get gpsSearching => 'Mencari GPS…';

  @override
  String get gpsLowAccuracy => 'Akurasi GPS rendah';

  @override
  String get locationOff => 'Lokasi nonaktif';

  @override
  String get locationOffMessage =>
      'Aktifkan lokasi untuk merekam perjalanan Anda.';

  @override
  String get mapOffline => 'Koneksi peta tidak tersedia — titik Anda aman';

  @override
  String get emptyNoMeasurementsTitle => 'Belum ada pengukuran';

  @override
  String get emptyNoMeasurementsMessage =>
      'Ukur lahan pertama Anda dan hasilnya akan muncul di sini.';

  @override
  String get languageSystem => 'Bawaan sistem';

  @override
  String get measureHintCrosshair =>
      'Geser peta untuk menempatkan bidikan, lalu ketuk Tambah titik.';

  @override
  String get measureHintTap =>
      'Ketuk peta untuk menambahkan titik di sekeliling batas.';

  @override
  String get toolbarUndo => 'Urungkan';

  @override
  String get toolbarAddPoint => 'Tambah titik';

  @override
  String get toolbarClose => 'Tutup bentuk';

  @override
  String get toolbarReset => 'Atur ulang';

  @override
  String get toolbarAddAtMyLocation => 'Tambah titik di lokasi saya';

  @override
  String get resultArea => 'Luas';

  @override
  String get resultPerimeter => 'Keliling';

  @override
  String get resultAreaNeedsPoints =>
      'Tambahkan minimal 3 titik untuk menghitung luas';

  @override
  String resultPointCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titik',
    );
    return '$_temp0';
  }

  @override
  String get edgesCross => 'Sisi saling bersilangan — luas mungkin tidak tepat';

  @override
  String get menuMore => 'Opsi lainnya';

  @override
  String get menuInputCrosshair => 'Tambah dengan bidikan';

  @override
  String get menuInputTap => 'Tambah dengan mengetuk peta';

  @override
  String get menuShowEdgeLabels => 'Tampilkan panjang sisi';

  @override
  String pointLabel(int number) {
    return 'Titik $number';
  }

  @override
  String get pointDelete => 'Hapus titik';

  @override
  String get pointDeselect => 'Selesai';

  @override
  String gpsLowAccuracyAdded(int meters) {
    return 'Akurasi GPS rendah (±$meters m). Titik tetap ditambahkan.';
  }

  @override
  String get locationUnavailable =>
      'Tidak dapat memperoleh lokasi Anda. Coba lagi di luar ruangan.';

  @override
  String get locationPermissionDenied =>
      'Akses lokasi nonaktif. Anda tetap bisa mengukur dengan menggeser peta.';

  @override
  String get locationServiceOff => 'Lokasi dinonaktifkan di perangkat ini.';

  @override
  String get mapLayersTitle => 'Jenis peta';

  @override
  String get mapStyleStandard => 'Standar';

  @override
  String get mapStyleSatellite => 'Satelit';

  @override
  String get mapStyleTerrain => 'Medan';

  @override
  String get mapStyleHybrid => 'Hibrida';

  @override
  String get draftSaveFailed =>
      'Titik Anda tidak dapat disimpan. Titik akan disimpan lagi pada perubahan berikutnya.';

  @override
  String get menuHelp => 'Bantuan';

  @override
  String get actionGotIt => 'Mengerti';

  @override
  String get helpTitleArea => 'Cara mengukur luas';

  @override
  String get helpTitleDistance => 'Cara mengukur jarak';

  @override
  String get helpTitleWalk => 'Cara mengukur sambil berjalan';

  @override
  String get helpAreaSummary =>
      'Tambahkan titik di sekeliling batas lahan Anda.';

  @override
  String get helpDistanceSummary =>
      'Tambahkan titik di sepanjang rute yang ingin Anda ukur.';

  @override
  String get helpWalkSummary =>
      'Berjalanlah menyusuri batas sementara LandMeasure merekam jalur GPS Anda.';

  @override
  String get helpPhotoTip =>
      'Gunakan foto untuk mendokumentasikan patok, batas, atau kondisi lahan.';

  @override
  String get helpAccuracyNote =>
      'Akurasi GPS dan pengukuran peta dapat berbeda tergantung perangkat, citra peta, dan lingkungan.';

  @override
  String get helpAreaStep1 =>
      'Geser peta hingga bidikan berada di sudut lahan, lalu ketuk **Tambah titik**.';

  @override
  String get helpAreaStep2 =>
      'Tambahkan minimal 3 titik di sekeliling batas. Seret titik untuk menyesuaikannya.';

  @override
  String get helpAreaStep3 =>
      'Ketuk **Tutup bentuk** untuk menyelesaikan, lalu **Simpan pengukuran**.';

  @override
  String get helpDistanceStep1 =>
      'Letakkan bidikan di awal rute dan ketuk **Tambah titik**.';

  @override
  String get helpDistanceStep2 =>
      'Terus tambahkan titik di sepanjang rute. Panjang setiap ruas ditampilkan di peta.';

  @override
  String get helpDistanceStep3 => 'Ketuk **Simpan rute** setelah selesai.';

  @override
  String get helpWalkStep1 =>
      'Tunggu **GPS siap**, lalu ketuk **Mulai berjalan**.';

  @override
  String get helpWalkStep2 =>
      'Berjalanlah menyusuri batas. Gunakan **Jeda** jika perlu berhenti.';

  @override
  String get helpWalkStep3 =>
      'Kembali ke titik awal dan ketuk **Selesai** untuk menghitung luas.';

  @override
  String get helpTipGpsPoint =>
      'Tips: ketuk 📍 untuk menambahkan titik di lokasi GPS Anda saat ini.';

  @override
  String get helpTipWalk =>
      'Tips: berada di area terbuka agar akurasi GPS lebih baik.';

  @override
  String get resultDistance => 'Jarak';

  @override
  String get resultDistanceNeedsPoints =>
      'Tambahkan minimal 2 titik untuk mengukur jarak';

  @override
  String resultSegmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ruas',
    );
    return '$_temp0';
  }

  @override
  String get segmentsTitle => 'Ruas';

  @override
  String draftSavedSnack(int count, String type) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Draf tersimpan · $type · $count titik',
    );
    return '$_temp0';
  }

  @override
  String get searchHint => 'Alamat, koordinat, atau tautan Google Maps';

  @override
  String get searchAction => 'Cari';

  @override
  String get searchRecent => 'Pencarian terbaru';

  @override
  String get searchNoResults =>
      'Tempat tidak ditemukan. Coba koordinat atau tautan Google Maps.';

  @override
  String get searchNeedsInternet =>
      'Mencari alamat memerlukan koneksi internet.';

  @override
  String get searchUnavailable =>
      'Pencarian alamat tidak tersedia di perangkat ini. Coba koordinat atau tautan Google Maps.';

  @override
  String get searchClear => 'Hapus';

  @override
  String get searchFailed =>
      'Alamat ini tidak dapat dicari sekarang. Coba koordinat atau tautan Google Maps.';

  @override
  String get ctaStartWalking => 'Mulai berjalan';

  @override
  String get walkReadyHelper =>
      'Berjalanlah menyusuri batas untuk merekam jalur Anda.';

  @override
  String get keepScreenOn => 'Biarkan layar tetap menyala';

  @override
  String get walkRecording => 'Merekam GPS…';

  @override
  String get walkPaused => 'Dijeda';

  @override
  String get walkPausedMessage =>
      'Ketuk Lanjutkan untuk meneruskan dari posisi Anda sekarang.';

  @override
  String gpsAccuracyShort(int meters) {
    return '±$meters m';
  }

  @override
  String gpsLowAccuracyMessage(int meters) {
    return 'Akurasi ±$meters m — titik tidak direkam sampai membaik. Pindahlah ke area terbuka.';
  }

  @override
  String get locationDeniedTitle => 'Akses lokasi nonaktif';

  @override
  String get locationDeniedMessage =>
      'Izinkan lokasi untuk merekam perjalanan Anda.';

  @override
  String get actionAllow => 'Izinkan';

  @override
  String get actionNotNow => 'Nanti saja';

  @override
  String get mockLocationDetected =>
      'Lokasi palsu terdeteksi — posisi tersebut tidak direkam.';

  @override
  String get walkCloseToStart =>
      'Dekat titik awal — selesaikan untuk menghitung luas';

  @override
  String get walkNotClosed => 'Rute tidak tertutup — hanya jarak';

  @override
  String get walkKeepWalking =>
      'Kembalilah ke titik awal untuk menutup putaran.';

  @override
  String get resultDuration => 'Durasi';

  @override
  String get walkNotificationTitle =>
      'LandMeasure sedang merekam pengukuran Anda';

  @override
  String get walkNotificationText => 'Ketuk untuk kembali ke perjalanan Anda.';

  @override
  String get walkNotificationChannel => 'Perekaman jalan';

  @override
  String get walkRecordingBack =>
      'Sedang merekam. Jeda atau selesaikan sebelum keluar.';

  @override
  String get walkPauseAndLeave => 'Jeda & keluar';

  @override
  String get walkStartFailed => 'Tidak dapat mulai merekam. Coba lagi.';

  @override
  String get batteryHintTitle =>
      'Izinkan LandMeasure berjalan di latar belakang';

  @override
  String get batteryHintMessage =>
      'Beberapa ponsel menghentikan aplikasi saat layar mati. Agar perjalanan tetap terekam, buka Setelan → Baterai dan pilih \"Tanpa batasan\" untuk LandMeasure.';

  @override
  String get fabRecenter => 'Pusatkan ulang';

  @override
  String get homeHeroSubtitle => 'Pilih cara untuk mengukur lahan Anda.';

  @override
  String get homeContinueTitle => 'Lanjutkan pengukuran';

  @override
  String get homeSeeAllDrafts => 'Lihat semua draf';

  @override
  String get homeRecentTitle => 'Pengukuran terbaru';

  @override
  String get homeRecentEmptyTitle => 'Belum ada pengukuran terbaru';

  @override
  String get homeRecentEmptyMessage =>
      'Pengukuran yang disimpan akan muncul di sini.';

  @override
  String get actionSeeAll => 'Lihat semua';

  @override
  String get untitledArea => 'Luas tanpa nama';

  @override
  String get untitledDistance => 'Jarak tanpa nama';

  @override
  String get untitledWalk => 'Jalan tanpa nama';

  @override
  String get draftLabel => 'Draf';

  @override
  String get walkFinishedNotSaved => 'Selesai · belum disimpan';

  @override
  String lastEdited(String time) {
    return 'Diedit $time';
  }

  @override
  String get timeJustNow => 'baru saja';

  @override
  String timeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mnt lalu',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jam lalu',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari lalu',
      one: 'kemarin',
    );
    return '$_temp0';
  }

  @override
  String get savedSearchHint => 'Cari berdasarkan nama';

  @override
  String get savedSearchOpen => 'Cari';

  @override
  String get savedSearchClose => 'Tutup pencarian';

  @override
  String get filterAll => 'Semua';

  @override
  String filterWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String savedDraftsTitle(int count) {
    return 'Draf ($count)';
  }

  @override
  String get savedNoResults => 'Pengukuran tidak ditemukan.';

  @override
  String get menuRename => 'Ganti nama';

  @override
  String get menuExport => 'Ekspor';

  @override
  String get measurementDeleted => 'Pengukuran dihapus';

  @override
  String get draftDiscarded => 'Draf dibuang';

  @override
  String get exportTitle => 'Ekspor';

  @override
  String get renameHint => 'Nama pengukuran';

  @override
  String get saveNameLabel => 'Nama';

  @override
  String get saveNameRequired => 'Nama wajib diisi';

  @override
  String get saveNotesLabel => 'Catatan';

  @override
  String get saveNotesHint => 'Batas, pemilik, patokan… (opsional)';

  @override
  String get saveTypeLabel => 'Jenis';

  @override
  String get saveFailed => 'Tidak dapat menyimpan. Coba lagi.';

  @override
  String get saveLimitReached =>
      'Anda telah mencapai batas gratis pengukuran tersimpan. Pengukuran ini tetap ada di draf Anda.';

  @override
  String get saveNotFound => 'Pengukuran ini sudah tidak ada.';

  @override
  String photosTitle(int count) {
    return 'Foto lokasi ($count)';
  }

  @override
  String get actionClose => 'Tutup';

  @override
  String get resultPoints => 'Titik';

  @override
  String get resultSegments => 'Ruas';

  @override
  String get resultAvgPace => 'Laju rata-rata';

  @override
  String paceValue(String time, String unit) {
    return '$time /$unit';
  }

  @override
  String get notesTitle => 'Catatan';

  @override
  String get notesEmpty => 'Tidak ada catatan';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionExport => 'Ekspor';

  @override
  String get detailOpenMap => 'Buka peta';

  @override
  String savedOn(String date) {
    return 'Disimpan $date';
  }

  @override
  String get addPhotoTitle => 'Tambah foto';

  @override
  String get addPhotoCamera => 'Ambil foto';

  @override
  String get addPhotoGallery => 'Pilih dari galeri';

  @override
  String addPhotoForPoint(int number) {
    return 'Untuk titik $number';
  }

  @override
  String get addPhotoTile => 'Tambah foto';

  @override
  String get photoAddFailed => 'Foto tidak dapat ditambahkan. Coba lagi.';

  @override
  String get photoRemoved => 'Foto dihapus';

  @override
  String get actionUndo => 'Urungkan';

  @override
  String get photoLimitReached =>
      'Anda telah mencapai batas gratis foto untuk pengukuran ini.';

  @override
  String get photoDeleteTitle => 'Hapus foto?';

  @override
  String get photoDeleteMessage => 'Foto ini akan dihapus dari pengukuran.';

  @override
  String get photoAttachTitle => 'Lampirkan foto ini ke pengukuran?';

  @override
  String get photoAttachMessage =>
      '\"Simpan foto ke pengukuran\" dinonaktifkan di Pengaturan.';

  @override
  String get actionAttach => 'Lampirkan';

  @override
  String get photoWaitForStart => 'Mulai berjalan untuk menambahkan foto.';

  @override
  String photoCounter(int index, int total) {
    return '$index / $total';
  }

  @override
  String get photoShare => 'Bagikan';

  @override
  String photoOpen(int number) {
    return 'Buka foto $number';
  }

  @override
  String get photoRemove => 'Hapus foto';

  @override
  String get pointPhoto => 'Foto';

  @override
  String get cameraPermissionTitle => 'Izinkan akses kamera';

  @override
  String get cameraPermissionMessage =>
      'Foto patok, batas, dan kondisi lahan, lalu simpan bersama pengukuran Anda.';

  @override
  String get cameraPermissionDenied =>
      'Akses kamera nonaktif. Anda dapat mengaktifkannya di Setelan.';

  @override
  String get actionContinue => 'Lanjut';

  @override
  String get notesEditTitle => 'Edit catatan';

  @override
  String get notesAdd => 'Tambah catatan';

  @override
  String get editTabResult => 'Hasil';

  @override
  String get editTabDetails => 'Detail';

  @override
  String get ctaSaveChanges => 'Simpan perubahan';

  @override
  String get dialogDiscardChangesMessage =>
      'Perubahan Anda pada pengukuran ini akan hilang.';

  @override
  String get changesSaved => 'Perubahan disimpan';

  @override
  String get menuReopenShape => 'Buka kembali bentuk';

  @override
  String get exportKml => 'KML — Google Earth';

  @override
  String get exportKmlSubtitle =>
      'Bentuk dan titik berfoto untuk Google Earth dan aplikasi GIS';

  @override
  String get exportCsv => 'CSV — Excel';

  @override
  String get exportCsvSubtitle =>
      'Setiap titik beserta koordinatnya, untuk spreadsheet';

  @override
  String get exportPreparing => 'Menyiapkan file…';

  @override
  String get exportFailed => 'Tidak dapat mengekspor. Coba lagi.';

  @override
  String get exportLimitReached =>
      'Ekspor KML gratis hari ini sudah terpakai. Ekspor CSV tetap gratis.';

  @override
  String get landValueTitle => 'Nilai lahan';

  @override
  String get landValueAdd => 'Tambah nilai lahan';

  @override
  String get landValueUnitPrice => 'Harga satuan';

  @override
  String get landValueUnit => 'Per';

  @override
  String landValueEstimated(String value) {
    return 'Perkiraan nilai ≈ $value';
  }

  @override
  String landValueRate(String price, String unit) {
    return '$price / $unit';
  }

  @override
  String get landValueNeedsArea =>
      'Nilai lahan memerlukan luas (tutup bentuknya).';

  @override
  String get landValueRemove => 'Hapus';

  @override
  String get landValueInvalid => 'Masukkan harga lebih dari 0';

  @override
  String get resultValue => 'Nilai';

  @override
  String get settingsSubtitle => 'Satuan, peta, dan preferensi aplikasi';

  @override
  String get settingsSectionPreferences => 'Preferensi pengukuran';

  @override
  String get settingsSectionMeasureMap => 'Pengukuran & peta';

  @override
  String get settingsSectionSupport => 'Dukungan & legal';

  @override
  String get settingsDefaultMode => 'Jenis pengukuran default';

  @override
  String get settingsDefaultModeHint =>
      'Dipilih di Beranda saat aplikasi dibuka.';

  @override
  String get settingsGpsAccuracy => 'Tampilkan akurasi GPS';

  @override
  String get settingsGpsAccuracySubtitle =>
      'Tampilkan ±m dan lingkaran akurasi saat berjalan';

  @override
  String get settingsAutoCenter => 'Pusatkan peta otomatis';

  @override
  String get settingsAutoCenterSubtitle =>
      'Buka peta di lokasi Anda dan ikuti Anda saat berjalan';

  @override
  String get settingsSavePhotos => 'Simpan foto ke pengukuran';

  @override
  String get settingsSavePhotosSubtitle => 'Lampirkan foto baru tanpa bertanya';

  @override
  String get settingsKeepAwake => 'Layar tetap menyala';

  @override
  String get settingsKeepAwakeSubtitle => 'Layar tidak mati saat mengukur';

  @override
  String get settingsHelpFeedback => 'Bantuan & masukan';

  @override
  String get settingsRateUs => 'Beri kami rating';

  @override
  String get settingsPrivacyPolicy => 'Kebijakan privasi';

  @override
  String get settingsTerms => 'Ketentuan penggunaan';

  @override
  String settingsVersion(String version, String build) {
    return 'Versi $version ($build)';
  }

  @override
  String get feedbackSubject => 'Masukan LandMeasure';

  @override
  String feedbackNoEmailApp(String email) {
    return 'Aplikasi email tidak ditemukan. Kirim email ke $email.';
  }

  @override
  String get linkOpenFailed => 'Tautan tidak dapat dibuka. Coba lagi.';

  @override
  String get unitsDistanceTitle => 'Jarak';

  @override
  String get unitsAreaTitle => 'Luas';

  @override
  String get unitsSecondary => 'Tampilkan satuan kedua';

  @override
  String unitsSecondaryExample(String example) {
    return 'mis. $example';
  }

  @override
  String get unitsNote =>
      'Pengukuran baru memakai satuan ini. Setiap pengukuran juga bisa mengganti satuan dari hasilnya.';

  @override
  String get unitMeters => 'Meter';

  @override
  String get unitKilometers => 'Kilometer';

  @override
  String get unitFeet => 'Kaki';

  @override
  String get unitMiles => 'Mil';

  @override
  String get unitSquareMeters => 'Meter persegi';

  @override
  String get unitHectares => 'Hektare';

  @override
  String get unitAcres => 'Acre';

  @override
  String get unitSquareFeet => 'Kaki persegi';

  @override
  String get mapStyleNote =>
      'Pengukuran baru dibuka dengan peta ini. Anda dapat menggantinya dengan tombol Lapisan peta.';

  @override
  String get actionApply => 'Terapkan';

  @override
  String get languageAppLanguages => 'Bahasa aplikasi';

  @override
  String get languageMachineNote =>
      'Bahasa ini diterjemahkan oleh mesin dan mungkin mengandung kesalahan.';

  @override
  String get locationPermissionTitle => 'Izinkan akses lokasi';

  @override
  String get locationPermissionMessage =>
      'LandMeasure memakai lokasi Anda untuk menunjukkan posisi Anda di peta. Lokasi tetap di ponsel Anda.';

  @override
  String get locationPermissionMeasureMessage =>
      'Tunjukkan posisi Anda di peta dan tambahkan titik di tempat Anda berdiri. Tanpa izin ini Anda tetap bisa mengukur dengan menggeser peta.';

  @override
  String get locationPermissionWalkMessage =>
      'Jalan & ukur merekam jalur Anda dengan GPS selama layar ini terbuka. Lokasi Anda tetap di ponsel Anda.';

  @override
  String get locationPermissionBlocked =>
      'Akses lokasi untuk LandMeasure nonaktif. Aktifkan di Setelan untuk memakai posisi Anda.';

  @override
  String get notificationPermissionTitle => 'Izinkan notifikasi';

  @override
  String get notificationPermissionMessage =>
      'Izinkan notifikasi agar Anda bisa melihat status perekaman saat layar mati.';

  @override
  String get actionRetry => 'Coba lagi';

  @override
  String get paywallTitle => 'Ukur tanpa batas';

  @override
  String get paywallSubtitle => 'Buka proyek tanpa batas dan fitur Premium.';

  @override
  String get paywallBenefitNoAds => 'Tanpa iklan';

  @override
  String get paywallBenefitSaves => 'Simpan pengukuran tanpa batas';

  @override
  String get paywallBenefitPhotos => 'Foto tanpa batas per pengukuran';

  @override
  String get paywallBenefitKml => 'Ekspor KML kapan saja';

  @override
  String paywallStartTrial(int days) {
    return 'Mulai uji coba gratis $days hari';
  }

  @override
  String paywallTermsTrial(int days, String price, String store) {
    return 'Gratis $days hari, lalu $price/tahun. Diperpanjang otomatis — batalkan kapan saja di $store.';
  }

  @override
  String paywallTermsYearly(String price, String store) {
    return '$price/tahun. Diperpanjang otomatis — batalkan kapan saja di $store.';
  }

  @override
  String paywallTermsMonthly(String price, String store) {
    return '$price/bulan. Diperpanjang otomatis — batalkan kapan saja di $store.';
  }

  @override
  String get paywallRestore => 'Pulihkan pembelian';

  @override
  String get paywallWelcome => 'Selamat datang di Premium!';

  @override
  String get paywallPending =>
      'Pembayaran tertunda. Premium terbuka begitu pembayaran selesai.';

  @override
  String get paywallPurchaseFailed =>
      'Pembelian tidak berhasil. Anda tidak dikenai biaya.';

  @override
  String get paywallRestored => 'Pembelian dipulihkan.';

  @override
  String get paywallNothingToRestore =>
      'Tidak ada pembelian sebelumnya untuk akun toko ini.';

  @override
  String get paywallRestoreFailed =>
      'Pembelian tidak dapat dipulihkan. Periksa koneksi lalu coba lagi.';

  @override
  String get paywallUnavailable =>
      'Paket belum dapat dimuat. Periksa koneksi lalu coba lagi.';

  @override
  String get premiumActive => 'Premium aktif';

  @override
  String get premiumActiveLifetime => 'Premium aktif · Seumur hidup';

  @override
  String get premiumManage => 'Kelola';

  @override
  String get settingsPremiumTitle => 'LandMeasure Premium';

  @override
  String get settingsPremiumSubtitle =>
      'Tanpa iklan, simpan dan foto tanpa batas, KML kapan saja';

  @override
  String get settingsManageSubscription => 'Kelola langganan';

  @override
  String get settingsPrivacyChoices => 'Pilihan privasi';

  @override
  String get settingsAdInspector => 'Ad Inspector (dev)';

  @override
  String get exportUnlockTitle => 'Ekspor KML gratis hari ini sudah terpakai';

  @override
  String get exportUnlockMessage =>
      'Tonton iklan singkat untuk mengekspor file ini, atau ambil Premium untuk ekspor KML tanpa batas. Ekspor CSV tetap gratis.';

  @override
  String get exportWatchAd => 'Tonton iklan';

  @override
  String get exportGetPremium => 'Ambil Premium';

  @override
  String get exportLoadingAd => 'Memuat iklan…';

  @override
  String get exportAdDismissed =>
      'Tonton iklan sampai selesai untuk membuka ekspor ini.';

  @override
  String get introNext => 'Lanjut';

  @override
  String get introGetStarted => 'Mulai';

  @override
  String get introAreaTitle => 'Ukur Luas dengan Mudah';

  @override
  String get introAreaBody =>
      'Tandai titik di peta untuk mengukur lahan, sawah, dan area lain dalam hitungan detik.';

  @override
  String get introDistanceTitle => 'Ukur Jarak & Rute';

  @override
  String get introDistanceBody =>
      'Ukur jarak garis lurus atau catat rute Anda saat berjalan di luar ruangan.';

  @override
  String get introFieldTitle => 'Dibuat untuk Kerja Lapangan';

  @override
  String get introFieldBody =>
      'Ukur pertanian, bidang tanah, properti, dan lokasi luar ruangan dengan mudah.';

  @override
  String paywallTrialTitle(int days) {
    return 'Uji coba gratis $days hari';
  }

  @override
  String paywallThenMonthly(String price) {
    return 'Lalu $price / bulan';
  }

  @override
  String get paywallMonthlyTitle => 'Paket Bulanan';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price / bulan';
  }

  @override
  String get paywallYearlyTitle => 'Paket Tahunan';

  @override
  String paywallYearlyOnly(String price) {
    return 'Hanya $price per tahun';
  }

  @override
  String get paywallBestPrice => 'Harga terbaik';

  @override
  String get paywallMostPopular => 'Paling populer';

  @override
  String get paywallStartFreeTrial => 'Mulai uji coba gratis';

  @override
  String paywallTrialThenYearly(int days, String price) {
    return 'Uji coba gratis $days hari, lalu $price/tahun';
  }

  @override
  String paywallPricePerYear(String price) {
    return '$price/tahun';
  }

  @override
  String get paywallCancelAnytime => 'Batalkan kapan saja';

  @override
  String paywallTermsTrialMonthly(int days, String price, String store) {
    return 'Gratis $days hari, lalu $price/bulan. Diperpanjang otomatis — batalkan kapan saja di $store.';
  }

  @override
  String get premiumPromptTitle => 'Upgrade ke Premium';

  @override
  String premiumPromptPhotos(int count) {
    return 'Anda bisa menambahkan hingga $count foto per pengukuran secara gratis. Upgrade ke Premium untuk menambah lebih banyak.';
  }

  @override
  String get premiumPromptUpgrade => 'Upgrade';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get languageChooseTitle => 'Pilih bahasa Anda';

  @override
  String premiumPromptMapStyleReward(String style) {
    return 'Peta $style adalah fitur Premium. Tonton iklan singkat untuk memakainya sampai Anda menutup aplikasi, atau upgrade selamanya.';
  }

  @override
  String mapStyleUnlocked(String style) {
    return 'Peta $style terbuka sampai Anda menutup aplikasi.';
  }

  @override
  String get mapStyleAdDismissed =>
      'Tonton iklan sampai selesai untuk membuka peta ini.';

  @override
  String get pdfReportTitleArea => 'Laporan Pengukuran Lahan';

  @override
  String get pdfReportTitleDistance => 'Laporan Pengukuran Jarak';

  @override
  String get pdfReportTitleWalk => 'Laporan Pengukuran Jalan Kaki';

  @override
  String get pdfReportSubtitle =>
      'Ringkasan pengukuran tersimpan yang diekspor';

  @override
  String get pdfHeaderLabel => 'Laporan Pengukuran';

  @override
  String get pdfFooterGenerated => 'Dibuat oleh LandMeasure';

  @override
  String get pdfFooterEstimate =>
      'Pengukuran GPS/peta hanyalah perkiraan dan dapat berbeda menurut perangkat dan lingkungan.';

  @override
  String pdfPage(int page, int pages) {
    return 'Halaman $page dari $pages';
  }

  @override
  String get pdfName => 'Nama pengukuran';

  @override
  String get pdfType => 'Jenis';

  @override
  String get pdfDateSaved => 'Tanggal disimpan';

  @override
  String get pdfReportId => 'ID laporan';

  @override
  String get pdfSummary => 'Ringkasan pengukuran';

  @override
  String get pdfArea => 'Luas';

  @override
  String get pdfPerimeter => 'Keliling';

  @override
  String get pdfDistance => 'Jarak';

  @override
  String get pdfDuration => 'Durasi';

  @override
  String get pdfPoints => 'Titik';

  @override
  String get pdfSegments => 'Ruas';

  @override
  String get pdfMethod => 'Metode';

  @override
  String get pdfSubBoundaryVertices => 'Titik sudut batas';

  @override
  String get pdfSubRoutePoints => 'Titik rute';

  @override
  String get pdfSubTrackPoints => 'Titik jejak';

  @override
  String get pdfSubSegments => 'Antar titik';

  @override
  String get pdfMethodMapPoints => 'Titik peta';

  @override
  String get pdfMethodPolygon => 'Poligon manual';

  @override
  String get pdfMethodRoute => 'Rute manual';

  @override
  String get pdfAreaNotClosed => 'Tidak tertutup';

  @override
  String get pdfAreaNotClosedSub => 'Rute tidak membentuk lingkaran';

  @override
  String get pdfMapBoundary => 'Peta & Bentuk';

  @override
  String get pdfMapCaption => 'Skema bentuk terukur · utara di atas';

  @override
  String get pdfCenter => 'Koordinat pusat';

  @override
  String get pdfMapStyle => 'Gaya peta';

  @override
  String get pdfDisplayUnits => 'Satuan tampilan';

  @override
  String get pdfCoordinates => 'Koordinat';

  @override
  String get pdfCoordinatesHint =>
      'Titik dicantumkan sesuai urutan pengukuran.';

  @override
  String get pdfColPoint => 'Titik';

  @override
  String get pdfColLatitude => 'Lintang';

  @override
  String get pdfColLongitude => 'Bujur';

  @override
  String get pdfColSegment => 'Ruas';

  @override
  String get pdfColNote => 'Catatan';

  @override
  String get pdfNoteStart => 'Awal';

  @override
  String get pdfNoteEnd => 'Akhir';

  @override
  String get pdfNotePhoto => 'Foto terlampir';

  @override
  String pdfMorePoints(int count) {
    return '$count titik lagi tidak ditampilkan. Ekspor CSV untuk mendapatkan semuanya.';
  }

  @override
  String get pdfNotes => 'Catatan survei';

  @override
  String get pdfPhotos => 'Foto lokasi';

  @override
  String pdfPhotoN(int n) {
    return 'Foto $n';
  }

  @override
  String pdfPhotoPoint(String point) {
    return 'Di $point';
  }

  @override
  String pdfCaptured(String date) {
    return 'Diambil $date';
  }

  @override
  String pdfMorePhotos(int count) {
    return '$count foto lagi tidak ditampilkan.';
  }

  @override
  String get pdfExportInfo => 'Informasi ekspor';

  @override
  String get pdfSource => 'Sumber';

  @override
  String get pdfSourceAndroid => 'LandMeasure Android';

  @override
  String get pdfSourceIos => 'LandMeasure iOS';

  @override
  String get pdfCoordFormat => 'Format koordinat';

  @override
  String get pdfCoordFormatValue => 'WGS 84 lintang / bujur';

  @override
  String get pdfExported => 'Diekspor';

  @override
  String get pdfCompanion => 'Format ekspor lain';

  @override
  String get pdfAccuracyTitle => 'Catatan akurasi:';

  @override
  String get pdfAccuracyBody =>
      'Laporan ini merangkum pengukuran yang dihitung dari titik peta dan/atau data GPS perangkat. Hasilnya adalah perkiraan dan dapat berbeda menurut akurasi perangkat, visibilitas satelit, citra peta, medan, serta posisi titik batas. Dokumen ini bukan survei kadaster atau hukum resmi kecuali diverifikasi terpisah oleh surveyor berwenang.';

  @override
  String get exportPdf => 'PDF — Laporan';

  @override
  String get exportPdfSubtitle =>
      'Laporan siap cetak dengan peta, koordinat, catatan, dan foto';

  @override
  String get projectLimitTitle => 'Batas proyek gratis tercapai';

  @override
  String get projectLimitMessage =>
      'Anda memiliki 4 proyek gratis. Tonton iklan sampai selesai untuk membuat satu proyek lagi, atau upgrade ke Premium untuk proyek tanpa batas.';

  @override
  String get projectRewardRequired =>
      'Tonton iklan sampai selesai untuk membuka proyek lain. Jika iklan tidak tersedia, coba lagi nanti atau upgrade ke Premium.';
}
