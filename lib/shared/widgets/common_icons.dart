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

Widget declinedIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/images/donation_states_declined.svg',
      width: width,
      height: height,
    );
Widget approvedIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/images/donation_states_approved.svg',
      width: width,
      height: height,
    );
Widget pendingIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/images/donation_states_pending.svg',
      width: width,
      height: height,
    );
Widget warningIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/images/donation_states_error.svg',
    );
Widget familySuperheroesIcon({double? width, double? height}) =>
    SvgPicture.asset(
      'assets/images/family_superheroes.svg',
      width: width,
      height: height,
    );
