import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:intl/intl.dart';

class Util {
  /// Features overlay keys
  static const String cancelFeatureOverlayKey = 'cancelFeatureOverlayKey';
  static const String testimonialsSummaryKey = 'testimonialsSummaryKey';
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
  static const String defaultUSPhoneNumber = '1231231234';
  static const String empty = '';
  static const String countryIso = 'countryIso';

  static final ukPostCodeRegEx = RegExp(
    r'^(([A-Z][0-9]{1,2})|(([A-Z][A-HJ-Y][0-9]{1,2})|(([A-Z][0-9][A-Z])|([A-Z][A-HJ-Y][0-9]?[A-Z])))) [0-9][A-Z]{2}$',
  );
  static final ukPhoneNumberRegEx = RegExp(
    r'^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$',
  );
  static final usPhoneNumberRegEx =
      RegExp(r'^(\([0-9]{3}\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}$');
  static final ukSortCodeRegEx = RegExp(r'^\d{6}$');
  static final emailRegEx = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final nameFieldsRegEx =
      RegExp(r'^[^0-9_!,¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$');

  static RegExp phoneNumberRegEx(String prefix) =>
      RegExp('\\(?\\+\\(?$prefix\\)?[()]?([-()]?\\d[-()]?){9,10}');

  static RegExp phoneNumberRegExWithPrefix() => RegExp(
        r'\(?\+\(?31|32|49|33|39|352|30|34|358|43|357|372|371|370|356|386|421|353\)?[()]?([-()]?\d[-()]?){9,10}',
      );
  static final certificatesPublicKey = RSAPublicKey('''
-----BEGIN PUBLIC KEY-----
MIIBITANBgkqhkiG9w0BAQEFAAOCAQ4AMIIBCQKCAQBZ7fQsGvR+889VBFQZvb+L
0sFM0kzRPD9djOpUzzPLZy1RfUKhA9e6hmnbGToWIZ4l4f4Hf3weuO9umnd1+SYS
SpknfbzZHEm4Bw5XQuWg6co4TfhzF+q9PP6fghyxRvP6Ep1qfxGTKzE7BXiwrrRA
bMGXpq8/IlmArMCahl/rkg3h+JUoS5GLtSp24vV6l0XkUQcy/nIPdInjaJwYfXCM
i2qkpEAvzAVUnUibRblnjr3U/2aWSCNisb8CY5noWSI6PFOm9hEJo6MpFRqUX6WJ
DKMjI861g8uLPf2mXBrkUOsvnSlUOD/CKYH10yvghfP+6T2KnA21dfVTX7HhGPcV
AgMBAAE=
-----END PUBLIC KEY-----
''');
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

  static String formatPhoneNrUs(String input) {
    final numericOnly = input.replaceAll(RegExp(r'[^\d]'), '');
    if (numericOnly.length != 10) return '';
    return '${numericOnly.substring(0, 3)}-${numericOnly.substring(3, 6)}-${numericOnly.substring(6)}';
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

  /// Allow only numbers and one comma or dot
  /// Like 123, 123.45, 12,05, 12,5
  static RegExp numberInputFieldRegExp() => RegExp(r'^\d+([,.]\d{0,2})?');
}
