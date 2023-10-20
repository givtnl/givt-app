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
    /// dev-backend.givtapp.net
    /// backend.givt.app
    /// dev-backend.givt.app
    '6D99FB265EB1C5B3744765FCBC648F3CD8E1BFFAFDC4C2F99B9D47CF7FF1C24F',

    /// api.production.givt.app
    /// api.development.givtapp.net
    /// api.production.givtapp.net
    '87DCD4DC74640A322CD205552506D1BE64F12596258096544986B4850BC72706',

    /// aws dev
    'B6BC0A83BABC3AB4A0DACF492F88A5BB878EE2FD0291A65117B8E305B71604CF',

    /// aws prod
    'D8A8F6D46EAC49E08F1DD9E99379EFCCE1A34F7D27811744122D024BF423B9F3',
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

  // todo remove this
  static String getCurrencyName({required Country country}) {
    return country == Country.us
        ? 'USD'
        : Country.unitedKingdomCodes().contains(country.countryCode)
            ? 'GBP'
            : 'EUR';
  }

  static NumberFormat getCurrency({required String countryCode}) {
    return NumberFormat.simpleCurrency(
      name: Country.fromCode(
        countryCode,
      ).currency,
    );
  }

  static String getCurrencySymbol({required String countryCode}) {
    return getCurrency(countryCode: countryCode).currencySymbol;
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
    if (country.countryCode == Country.us.countryCode ||
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
