import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget switchProfilesIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/family/images/switch_profiles.svg',
      width: width,
      height: height,
    );

Widget logoutIcon({double? width = 36, double? height = 36}) => SvgPicture.asset(
      'assets/family/images/logout.svg',
      width: width,
      height: height,
    );