import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/utils/util.dart';

void main() {
  group('Util.formatUkPostCode', () {
    test('returns null for empty input', () {
      expect(Util.formatUkPostCode(''), isNull);
      expect(Util.formatUkPostCode(null), isNull);
    });

    test('keeps already formatted postcode', () {
      expect(Util.formatUkPostCode('SW1A 1AA'), equals('SW1A 1AA'));
    });

    test('inserts missing space for valid postcode', () {
      expect(Util.formatUkPostCode('SW1A1AA'), equals('SW1A 1AA'));
      expect(Util.formatUkPostCode('m11aa'), equals('M1 1AA'));
      expect(Util.formatUkPostCode('DN551PT'), equals('DN55 1PT'));
      expect(Util.formatUkPostCode('Cr26Xh'), equals('CR2 6XH'));
    });

    test('normalizes multiple spaces and casing', () {
      expect(Util.formatUkPostCode(' sw1a   1aa '), equals('SW1A 1AA'));
    });

    test('returns null for invalid postcode', () {
      expect(Util.formatUkPostCode('INVALID'), isNull);
      expect(Util.formatUkPostCode('SW1A 1A'), isNull);
    });
  });

  group('Util.resolveLocale', () {
    const supportedLocales = [
      Locale('de'),
      Locale('en'),
      Locale('en', 'US'),
      Locale('es'),
      Locale('es', '419'),
      Locale('nl'),
    ];

    test('returns null for null locale', () {
      expect(
        Util.resolveLocale(null, supportedLocales),
        isNull,
      );
    });

    test('returns null for supported locales', () {
      expect(
        Util.resolveLocale(const Locale('de'), supportedLocales),
        isNull,
      );
      expect(
        Util.resolveLocale(const Locale('en'), supportedLocales),
        isNull,
      );
      expect(
        Util.resolveLocale(const Locale('en', 'US'), supportedLocales),
        isNull,
      );
      expect(
        Util.resolveLocale(const Locale('es'), supportedLocales),
        isNull,
      );
      expect(
        Util.resolveLocale(const Locale('nl'), supportedLocales),
        isNull,
      );
    });

    test('returns English for Polish locale (pl)', () {
      expect(
        Util.resolveLocale(const Locale('pl'), supportedLocales),
        equals(const Locale('en')),
      );
    });

    test('returns English for other unsupported locales', () {
      expect(
        Util.resolveLocale(const Locale('fr'), supportedLocales),
        equals(const Locale('en')),
      );
      expect(
        Util.resolveLocale(const Locale('it'), supportedLocales),
        equals(const Locale('en')),
      );
      expect(
        Util.resolveLocale(const Locale('ja'), supportedLocales),
        equals(const Locale('en')),
      );
    });

    test('matches language code when country code differs (nl_BE -> nl)', () {
      // nl_BE should match nl and return null (supported)
      expect(
        Util.resolveLocale(const Locale('nl', 'BE'), supportedLocales),
        isNull,
      );
    });

    test('matches language code when country code differs (en_GB -> en)', () {
      // en_GB should match en and return null (supported)
      expect(
        Util.resolveLocale(const Locale('en', 'GB'), supportedLocales),
        isNull,
      );
    });
  });
}
