import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/utils/utils.dart';

Widget microphoneIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/images/microphone.svg',
      width: width,
      height: height,
    );

Widget sidekickIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/images/sidekick.svg',
      width: width,
      height: height,
    );

Widget superheroMaskIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/images/superhero_mask.svg',
      width: width,
      height: height,
    );

Widget walletIcon({double? width, double? height}) =>
    SvgPicture.asset('assets/images/wallet.svg', width: width, height: height);

Widget coin({double? width, double? height}) => SvgPicture.asset(
      'assets/images/coin.svg',
      width: width,
      height: height,
    );

Widget calendarClockIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/images/calendar_clock.svg',
      width: width,
      height: height,
    );

Widget calendarClockAvatarIcon({double? width, double? height}) =>
    SvgPicture.asset(
      'assets/images/calendar_clock_avatar.svg',
      width: width,
      height: height,
    );

Widget plusIcon({double? size}) => FaIcon(
      FontAwesomeIcons.plus,
      color: AppTheme.givtLightGreen,
      size: size,
    );

Widget smilePurpleIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/family/images/smiley_purple.svg',
      width: width,
      height: height,
    );

Widget smileGreyIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/family/images/smiley_grey.svg',
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

Widget registeredCheckAvatar({double? width, double? height}) =>
    SvgPicture.asset(
      'assets/images/registered_check_avatar.svg',
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

Widget trashAvatarIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/images/trash_avatar.svg',
      width: width,
      height: height,
    );

Widget secureCardsIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/images/vpc_secure.svg',
      width: width,
      height: height,
    );

Widget familySuperheroesIcon({double? width, double? height}) =>
    SvgPicture.asset(
      'assets/images/family_superheroes.svg',
      width: width,
      height: height,
    );

Widget switchProfilesIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/family/images/switch_profiles.svg',
      width: width,
      height: height,
    );

Widget day4TimerIconGreen({double? width, double? height}) => SvgPicture.asset(
      'assets/images/generosity_challenge_day_4_green.svg',
      width: width,
      height: height,
    );

Widget day4TimerIconRed({double? width, double? height}) => SvgPicture.asset(
      'assets/images/generosity_challenge_day_4_red.svg',
      width: width,
      height: height,
    );

Widget recordMicRedIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/family/images/record_mic_red.svg',
      width: width,
      height: height,
    );

Widget recordMicGreenIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/family/images/record_mic_green.svg',
      width: width,
      height: height,
    );

Widget secretWordBackground({double? width, double? height}) =>
    SvgPicture.asset(
      'assets/family/images/secret_word_bg.svg',
      width: width,
      height: height,
    );

Widget walletEmptyIcon({double? width, double? height}) => SvgPicture.asset(
      'assets/images/wallet_empty.svg',
      width: width,
      height: height,
    );

Widget primaryCircleWithText({
  String? text = '',
  double circleSize = 62,
  Color? circleColor,
  Color? iconColor,
}) =>
    Padding(
      // 14 is what the design has when exporting svgs
      padding: const EdgeInsets.all(14),
      child: Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          color: circleColor ?? FamilyAppTheme.primary95,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            text!,
            style: TextStyle(
              color: iconColor ?? FamilyAppTheme.primary20,
              fontSize: text.length < 3 ? 40 : 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

Widget primaryCircleWithIcon({
  IconData? iconData,
  double circleSize = 62,
  double iconSize = 40,
  Color? circleColor,
  Color? iconColor,
}) =>
    Padding(
      // 14 is what the design has when exporting svgs
      padding: const EdgeInsets.all(14),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: circleColor ?? FamilyAppTheme.primary95,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: iconSize * 2,
            child: Icon(
              iconData,
              color: iconColor ?? FamilyAppTheme.primary20,
              size: iconSize,
            ),
          ),
        ],
      ),
    );

Widget errorCircleWithIcon({
  IconData? iconData,
  double circleSize = 62,
  double iconSize = 40,
  Color? circleColor,
  Color? iconColor,
}) =>
    Padding(
      // 14 is what the design has when exporting svgs
      padding: const EdgeInsets.all(14),
      child: Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          color: circleColor ?? FamilyAppTheme.error80,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            iconData,
            color: iconColor ?? FamilyAppTheme.error30,
            size: iconSize,
          ),
        ),
      ),
    );
