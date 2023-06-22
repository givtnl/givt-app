import 'package:flutter/material.dart';

class Util {
  static final ukPostCodeRegEx = RegExp(
      r'^(([A-Z][0-9]{1,2})|(([A-Z][A-HJ-Y][0-9]{1,2})|(([A-Z][0-9][A-Z])|([A-Z][A-HJ-Y][0-9]?[A-Z])))) [0-9][A-Z]{2}$');
  static final ukPhoneNumberRegEx = RegExp(
      r'^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$');
  static final usPhoneNumberRegEx =
      RegExp(r'^(\([0-9]{3}\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}$');
  static final ukSortCodeRegEx = RegExp(r'^\d{6}$');
  static final emailRegEx = RegExp(
      r'^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*(\+[a-zA-Z0-9-]+)?@[a-z0-9-]+(\.[a-zA-Z0-9-]+)*$');
  static final nameFieldsRegEx =
      RegExp(r'^[^0-9_!,¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$');

  static final phoneNumberRegEx = RegExp(
      r'((?:\+|00)[17](?: |\-)?|(?:\+|00)[1-9]\d{0,2}(?: |\-)?|(?:\+|00)1\-\d{3}(?: |\-)?)?(0\d|\([0-9]{3}\)|[1-9]{0,3})(?:((?: |\-)[0-9]{2}){4}|((?:[0-9]{2}){4})|((?: |\-)[0-9]{3}(?: |\-)[0-9]{4})|([0-9]{7}))');
  static final navigatorKey = GlobalKey<NavigatorState>();
}
