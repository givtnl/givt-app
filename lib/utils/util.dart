import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:intl/intl.dart';

import 'app_theme.dart';

class Util {
// Default user info
  static const String defaultAdress = 'Foobarstraat 5';
  static const String defaultCity = 'Foobar';
  static const String defaultPostCode = 'B3 1RD';
  static const String defaultIban = 'FB66GIVT12345678';
  static const String defaultPhoneNumber = '060000000';
  static const String defaultFirstName = 'John';
  static const String defaultLastName = 'Doe';
  static const String defaulAppLanguage = 'en';
  static const String defaultTimeZoneId = 'Europe/Amsterdam';
  static const String nativeAppKeysMigration = 'nativeAppKeysMigration';

  /// Allowed SHA-256 fingerprints for Givt backend
  /// The list is used in APIService while building the http.client
  /// using the http_certificate_pinning package
  /// https://github.com/diefferson/http_certificate_pinning/tree/master
  static final List<String> allowedSHAFingerprints = [
    /// backend.givtapp.net
    '90 FB E1 EF 4D 99 50 C0 6B 12 D9 0B 87 84 CC F9 56 92 92 EF F3 6E 01 4C 4A 27 1E CC C9 CA 17 52',

    /// dev-backend.givtapp.net
    'E5 CD DE 1C 42 98 98 68 44 14 D4 D6 6B 44 F5 17 0F E0 5D B8 1F CE 25 2D A6 88 6C A4 34 E1 72 DD',

    /// backend.givt.app
    'DE 9C AD B7 02 B9 58 AA 85 BF 82 D9 D8 14 E7 DD 30 AB EB 1E 6D F1 82 C7 DA 81 8A 18 D8 2D 2F 0D',

    /// dev-backend.givt.app
    'C6 E5 6F E7 C5 BA CE EA DD 87 7F A0 C0 DA 4D D1 EC DF 69 A6 F5 37 08 0D E3 63 D0 7D 94 66 C3 36',

    /// api.production.givt.app
    'B4 00 35 42 EF C3 19 42 25 BD A5 5F 1D FE 02 27 CB D0 05 59 9D F5 73 7D 02 2B C8 FC 68 5D B5 6C',

    /// api.development.givtapp.net
    'B6 BC 0A 83 BA BC 3A B4 A0 DA CF 49 2F 88 A5 BB 87 8E E2 FD 02 91 A6 51 17 B8 E3 05 B7 16 04 CF',

    /// api.production.givtapp.net
    '97 F0 E8 B1 08 59 48 D0 EC AD 82 96 20 4A 47 04 BE F5 5D D2 0F 7E AB BF 33 DF 52 FB D3 A7 4F 96',
  ];

  static final ukPostCodeRegEx = RegExp(
      r'^(([A-Z][0-9]{1,2})|(([A-Z][A-HJ-Y][0-9]{1,2})|(([A-Z][0-9][A-Z])|([A-Z][A-HJ-Y][0-9]?[A-Z])))) [0-9][A-Z]{2}$');
  static final ukPhoneNumberRegEx = RegExp(
      r'^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$');
  static final usPhoneNumberRegEx =
      RegExp(r'^(\([0-9]{3}\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}$');
  static final ukSortCodeRegEx = RegExp(r'^\d{6}$');
  static final emailRegEx = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final nameFieldsRegEx =
      RegExp(r'^[^0-9_!,¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$');

  static RegExp phoneNumberRegEx(String prefix) =>
      RegExp('\\(?\\+\\(?$prefix\\)?[()]?([-()]?\\d[-()]?){9,10}');

  static RegExp phoneNumberRegExWithPrefix() => RegExp(
      r'\(?\+\(?31|32|49|33|39|352|30|34|358|43|357|372|371|370|356|386|421|353\)?[()]?([-()]?\d[-()]?){9,10}');

  static IconData getCurrencyIconData({required Country country}) {
    var icon = Icons.euro;
    if (country == Country.us) {
      icon = Icons.attach_money;
    }
    if (Country.unitedKingdomCodes().contains(country.countryCode)) {
      icon = Icons.currency_pound;
    }

    return icon;
  }

  static String getCurrencyName({required Country country}) {
    return country == Country.us
        ? 'USD'
        : Country.unitedKingdomCodes().contains(country.countryCode)
            ? 'GBP'
            : 'EUR';
  }

  static double getLowerLimitByCountry(Country country) {
    if (country == Country.us) {
      return 2;
    }
    if (Country.unitedKingdomCodes().contains(country.countryCode)) {
      return 0.50;
    }
    return 0.25;
  }

  static String formatNumberComma(double number, Country country) {
    if (country.countryCode == 'US' ||
        Country.unitedKingdomCodes().contains(country.countryCode)) {
      return number.toStringAsFixed(2);
    }
    return number.toStringAsFixed(2).replaceAll('.', ',');
  }

  static String getMonthName(String isoString, String locale) {
    final dateTime = DateTime.parse(isoString);
    final dateFormat = DateFormat.MMMM(locale);
    final monthName = dateFormat.format(dateTime);
    final capitalizedMonthName =
        '${monthName[0].toUpperCase()}${monthName.substring(1)}';
    return capitalizedMonthName;
  }

  static String getLanguageTageFromLocale(BuildContext context) {
    final languageTag = Localizations.localeOf(context).toLanguageTag();
    return languageTag;
  }

  static Color getStatusColor(int status) {
    switch (status) {
      case 3:
        return AppTheme.givtLightGreen;
      case 4:
        return AppTheme.givtRed;
      case 5:
        return AppTheme.givtLightGray;
    }
    return AppTheme.givtPurple;
  }
}
