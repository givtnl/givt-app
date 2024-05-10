import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget calendarClockIcon({double? width, double? height}) => Image.asset(
      'assets/images/calendar_clock.webp',
      width: width,
      height: height,
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
