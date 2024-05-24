import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/utils/utils.dart';

Widget walletIcon({double? width, double? height}) =>
    SvgPicture.asset('assets/images/wallet.svg');

Widget calendarClockIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/images/calendar_clock.svg',
      width: width,
      height: height,
    );
Widget plusIcon({double? size}) => FaIcon(
      FontAwesomeIcons.plus,
      color: AppTheme.givtLightGreen,
      size: size,
    );

Widget registeredCheck({double? width, double? height, Clip? clipBehavior}) =>
    SvgPicture.asset(
      'assets/images/registered_check.svg',
      width: width,
      height: height,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
    );

Widget registeredCheckBackground({double? width, double? height}) =>
    SvgPicture.asset(
      'assets/images/registered_check_background.svg',
      width: width,
      height: height,
    );
