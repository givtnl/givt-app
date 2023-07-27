import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';

class Util {
  /// Allowed SHA-256 fingerprints for Givt backend
  /// The list is used in APIService while building the http.client
  /// using the http_certificate_pinning package
  /// https://github.com/diefferson/http_certificate_pinning/tree/master
  static final List<String> allowedSHAFingerprints = [
    /// backend.givtapp.net
    '3C A9 57 A6 92 E2 D7 0A 14 B2 C2 97 F8 0A 60 1A 64 AA 31 DF C7 E7 4B 9A 2E 30 DF CE 42 6F 8C 90',

    /// dev-backend.givtapp.net
    'A3 DF 18 C7 60 73 54 55 CD DD AE 9A BF CB 4E B7 03 1B 80 32 FB C4 A0 B0 E7 0A CB 6B C4 A4 4B A7',

    /// backend.givt.app
    'DE 9C AD B7 02 B9 58 AA 85 BF 82 D9 D8 14 E7 DD 30 AB EB 1E 6D F1 82 C7 DA 81 8A 18 D8 2D 2F 0D',

    /// dev-backend.givt.app
    'C6 E5 6F E7 C5 BA CE EA DD 87 7F A0 C0 DA 4D D1 EC DF 69 A6 F5 37 08 0D E3 63 D0 7D 94 66 C3 36',

    /// api.production.givt.app
    'B4 00 35 42 EF C3 19 42 25 BD A5 5F 1D FE 02 27 CB D0 05 59 9D F5 73 7D 02 2B C8 FC 68 5D B5 6C',

    /// api.development.givt.app
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
}
