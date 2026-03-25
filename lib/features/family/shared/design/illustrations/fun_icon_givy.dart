import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:lottie/lottie.dart';

/// A fun icon with a circle background and an icon in the center.
/// The icon can be passed as an [iconData] or as a [icon] widget.
/// The circle size can be customized with [circleSize].
/// The icon size can be customized with [iconSize].
/// The circle color can be customized with [circleColor].
/// The icon color can be customized with [iconColor].
///
/// Example on how to use the standard icons:
/// ```dart
/// FunIcon.mask();
/// FunIcon.handshake();
/// FunIcon.microphone();
///
/// ```
///
/// The above examples will create a mask, handshake and microphone icon respectively.
///
/// Example on how to use the custom icon:
///
/// ```dart
/// FunIcon(
///   iconData: FontAwesomeIcons.mask,
///   circleColor: FamilyAppTheme.primary95,
/// );
///
/// ```
class FunIconGivy extends StatelessWidget {
  const FunIconGivy({
    super.key,
    this.iconData,
    this.icon,
    this.circleSize = 112,
    this.iconSize = 48,
    this.circleColor = FamilyAppTheme.primary95,
    this.iconColor = FamilyAppTheme.primary20,
  });

  factory FunIconGivy.sad({
    Color circleColor = FamilyAppTheme.primary95,
    double circleSize = 112,
  }) => FunIconGivy(
    icon: SvgPicture.asset(
      'assets/fun/givy/givy_sad.svg',
      width: circleSize / 112 * 140,
    ),
    circleColor: circleColor,
    circleSize: circleSize,
    iconSize: circleSize / 112 * 140,
  );

  factory FunIconGivy.findingAnimation({
    double circleSize = 112,
  }) =>
      FunIconGivy(
        icon: Lottie.asset(
          'assets/family/lotties/givy_finding_animation.json',
          width: circleSize / 112 * 140,
          height: circleSize / 112 * 140,
          fit: BoxFit.contain,
        ),
        circleColor: Colors.transparent,
        circleSize: circleSize,
        iconSize: circleSize / 112 * 140,
      );

  factory FunIconGivy.bagAnimation({
    double circleSize = 112,
  }) =>
      FunIconGivy(
        icon: Lottie.asset(
          'assets/family/lotties/givy_bag_animation.json',
          width: circleSize / 112 * 140,
          height: circleSize / 112 * 140,
          fit: BoxFit.contain,
        ),
        circleColor: Colors.transparent,
        circleSize: circleSize,
        iconSize: circleSize / 112 * 140,
      );

  factory FunIconGivy.happy({
    Color circleColor = FamilyAppTheme.primary95,
    double circleSize = 112,
  }) => FunIconGivy(
    icon: SvgPicture.asset(
      'assets/images/givy_happy.svg',
      width: circleSize / 112 * 140,
    ),
    circleColor: circleColor,
    circleSize: circleSize,
    iconSize: circleSize / 112 * 140,
  );

  factory FunIconGivy.love({
    Color circleColor = FamilyAppTheme.primary95,
    double circleSize = 112,
  }) => FunIconGivy(
    icon: SvgPicture.asset(
      'assets/fun/givy/givy_love.svg',
      width: circleSize / 112 * 140,
    ),
    circleColor: circleColor,
    circleSize: circleSize,
    iconSize: circleSize / 112 * 140,
  );

  factory FunIconGivy.bluetoothSettings({
    Color circleColor = FamilyAppTheme.primary95,
    double circleSize = 112,
  }) => FunIconGivy(
    icon: SvgPicture.asset(
      'assets/fun/givy/givy_bluetooth_settings.svg',
      width: circleSize / 112 * 140,
    ),
    circleColor: circleColor,
    circleSize: circleSize,
    iconSize: circleSize / 112 * 140,
  );

  factory FunIconGivy.phone({
    Color circleColor = FamilyAppTheme.primary95,
    double circleSize = 112,
  }) => FunIconGivy(
    icon: SvgPicture.asset(
      'assets/fun/givy/givy_phone.svg',
      width: circleSize / 112 * 140,
    ),
    circleColor: circleColor,
    circleSize: circleSize,
    iconSize: circleSize / 112 * 140,
  );

  factory FunIconGivy.phoneWink({
    double circleSize = 112,
  }) => FunIconGivy(
    icon: SvgPicture.asset(
      'assets/fun/givy/givy_phone_wink.svg',
    ),
    circleColor: Colors.transparent,
    circleSize: circleSize,
    iconSize: circleSize / 112 * 140,
  );

  final IconData? iconData;
  final Widget? icon;
  final double circleSize;
  final double iconSize;
  final Color circleColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return FunIcon(
      icon: icon,
      circleSize: circleSize,
      iconSize: iconSize,
      circleColor: circleColor,
      iconColor: iconColor,
    );
  }
}
