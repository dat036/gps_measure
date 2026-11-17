import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/features/export/pdf_report_builder.dart';
import 'package:gps_measurement/features/settings/settings_labels.dart';
import 'package:gps_measurement/l10n/gen/app_localizations.dart';

void main() {
  const codes = ['th', 'fr', 'de', 'pl', 'nl'];
  final source =
      jsonDecode(
            File('lib/core/l10n/arb/app_en.arb').readAsStringSync(),
          )
          as Map<String, dynamic>;
  final keys = source.keys.where((key) => !key.startsWith('@')).toSet();

  for (final code in codes) {
    test('$code has complete messages and preserves every placeholder', () {
      final translated =
          jsonDecode(
                File('lib/core/l10n/arb/app_$code.arb').readAsStringSync(),
              )
              as Map<String, dynamic>;
      expect(translated['@@locale'], code);
      expect(
        translated.keys.where((key) => !key.startsWith('@')).toSet(),
        keys,
      );
      for (final key in keys) {
        final message = translated[key] as String;
        expect(message.trim(), isNotEmpty, reason: '$code/$key');
        final metadata = source['@$key'] as Map<String, dynamic>?;
        final placeholders = metadata?['placeholders'] as Map<String, dynamic>?;
        for (final name in placeholders?.keys ?? <String>[]) {
          expect(
            RegExp('\\{$name(?:\\}|,)').hasMatch(message),
            isTrue,
            reason: '$code/$key must preserve $name',
          );
        }
        expect(message, isNot(contains('ZXQPH')), reason: '$code/$key');
      }
    });

    test('$code is selectable and loads its own localization', () {
      expect(appLanguageCodes, contains(code));
      expect(languageNativeNames[code], isNotEmpty);
      expect(languageFlags[code], isNotEmpty);
      expect(AppLocalizations.supportedLocales, contains(Locale(code)));
      final l10n = lookupAppLocalizations(Locale(code));
      expect(l10n.localeName, code);
      expect(l10n.screenLanguage, isNot('Language'));
      expect(l10n.paywallTermsTrial(7, '9.99', 'App Store'), contains('9.99'));
      expect(
        l10n.paywallTermsTrial(7, '9.99', 'App Store'),
        contains('App Store'),
      );
      expect(l10n.resultPointCount(22), contains('22'));
      expect(PdfReportOptions.supportsLocale(Locale(code)), code != 'th');
    });
  }

  test('Polish point counts use singular, few and many forms', () {
    final l10n = lookupAppLocalizations(const Locale('pl'));
    expect(l10n.resultPointCount(1), '1 punkt');
    expect(l10n.resultPointCount(2), '2 punkty');
    expect(l10n.resultPointCount(5), '5 punktów');
    expect(l10n.resultPointCount(12), '12 punktów');
    expect(l10n.resultPointCount(22), '22 punkty');
  });
}
