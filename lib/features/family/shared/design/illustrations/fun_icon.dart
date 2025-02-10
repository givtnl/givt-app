import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/utils/utils.dart';

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
class FunIcon extends StatelessWidget {
  const FunIcon({
    this.iconData,
    this.icon,
    this.circleSize = 112,
    this.iconSize = 48,
    this.circleColor = FamilyAppTheme.primary95,
    this.iconColor = FamilyAppTheme.primary20,
    this.padding = const EdgeInsets.all(14),
    super.key,
  });

  factory FunIcon.mask({Color circleColor = FamilyAppTheme.primary95}) =>
      FunIcon(
        iconData: FontAwesomeIcons.mask,
        circleColor: circleColor,
      );

  factory FunIcon.handshake({Color circleColor = FamilyAppTheme.primary95}) =>
      FunIcon(
        iconData: FontAwesomeIcons.solidHandshake,
        circleColor: circleColor,
      );

  factory FunIcon.microphone(
          {Color circleColor = FamilyAppTheme.primary95,
          double iconsize = 48,
          double circleSize = 112}) =>
      FunIcon(
        iconData: FontAwesomeIcons.microphone,
        circleColor: circleColor,
        iconSize: iconsize,
        circleSize: circleSize,
      );

  factory FunIcon.bell(
          {Color circleColor = FamilyAppTheme.primary95,
          double iconsize = 48,
          double circleSize = 112}) =>
      FunIcon(
        iconData: FontAwesomeIcons.solidBell,
        circleColor: circleColor,
        iconSize: iconsize,
        circleSize: circleSize,
      );

  factory FunIcon.recordingSquare(
          {Color circleColor = FamilyAppTheme.error90,
          Color iconColor = FamilyAppTheme.error30,
          double iconsize = 48,
          double circleSize = 112}) =>
      FunIcon(
        iconData: FontAwesomeIcons.solidSquare,
        iconColor: iconColor,
        circleColor: circleColor,
        iconSize: iconsize,
        circleSize: circleSize,
      );

  factory FunIcon.magnifyingGlass({
    Color circleColor = FamilyAppTheme.primary95,
  }) =>
      FunIcon(
        iconData: FontAwesomeIcons.magnifyingGlass,
        circleColor: circleColor,
      );

  factory FunIcon.checkmark({Color circleColor = FamilyAppTheme.primary95}) =>
      FunIcon(
        iconData: FontAwesomeIcons.check,
        circleColor: circleColor,
      );

  factory FunIcon.xmark({
    Color circleColor = FamilyAppTheme.error90,
    Color iconColor = FamilyAppTheme.error20,
  }) =>
      FunIcon(
        iconData: FontAwesomeIcons.xmark,
        circleColor: circleColor,
        iconColor: iconColor,
      );

  factory FunIcon.xmarkPlain() => FunIcon(
        iconData: FontAwesomeIcons.xmark,
        circleColor: Colors.transparent,
      );

  factory FunIcon.bowlFood({
    Color circleColor = FamilyAppTheme.primary95,
    Color iconColor = FamilyAppTheme.primary20,
  }) =>
      FunIcon(
        iconData: FontAwesomeIcons.bowlFood,
        circleColor: circleColor,
        iconColor: iconColor,
      );

  factory FunIcon.book({
    Color circleColor = FamilyAppTheme.primary95,
    Color iconColor = FamilyAppTheme.primary20,
  }) =>
      FunIcon(
        iconData: FontAwesomeIcons.book,
        circleColor: circleColor,
        iconColor: iconColor,
      );

  factory FunIcon.boxOpen({
    Color circleColor = FamilyAppTheme.primary95,
    Color iconColor = FamilyAppTheme.primary20,
  }) =>
      FunIcon(
        iconData: FontAwesomeIcons.boxOpen,
        circleColor: circleColor,
        iconColor: iconColor,
      );

  factory FunIcon.church(
          {Color circleColor = FamilyAppTheme.primary95,
          double iconsize = 48,
          double circleSize = 112}) =>
      FunIcon(
        iconData: FontAwesomeIcons.church,
        circleColor: circleColor,
        iconSize: iconsize,
        circleSize: circleSize,
      );

  factory FunIcon.globe(
          {Color circleColor = FamilyAppTheme.primary95,
          Color iconColor = FamilyAppTheme.primary20,
          double iconsize = 48,
          double circleSize = 112}) =>
      FunIcon(
        iconData: FontAwesomeIcons.earthAmericas,
        circleColor: circleColor,
        iconColor: iconColor,
        iconSize: iconsize,
        circleSize: circleSize,
      );

  factory FunIcon.guitar(
          {Color circleColor = FamilyAppTheme.primary95,
          Color iconColor = FamilyAppTheme.primary20,
          double iconsize = 48,
          double circleSize = 112}) =>
      FunIcon(
        iconData: FontAwesomeIcons.guitar,
        circleColor: circleColor,
        iconColor: iconColor,
        iconSize: iconsize,
        circleSize: circleSize,
      );

  factory FunIcon.seedling(
          {Color circleColor = FamilyAppTheme.primary95,
          Color iconColor = FamilyAppTheme.primary20,
          double iconsize = 48,
          double circleSize = 112}) =>
      FunIcon(
        iconData: FontAwesomeIcons.seedling,
        circleColor: circleColor,
        iconColor: iconColor,
        iconSize: iconsize,
        circleSize: circleSize,
      );

  factory FunIcon.solidFlagPlain({
    Color iconColor = FamilyAppTheme.primary20,
    EdgeInsets padding = const EdgeInsets.all(14),
    double iconSize = 48,
    double circleSize = 112,
  }) =>
      FunIcon(
        iconData: FontAwesomeIcons.solidFlag,
        iconColor: iconColor,
        circleColor: Colors.transparent,
        circleSize: circleSize,
        padding: padding,
        iconSize: iconSize,
      );

  factory FunIcon.clock({
    Color iconColor = FamilyAppTheme.primary40,
    EdgeInsets padding = EdgeInsets.zero,
    double iconSize = 16,
    double circleSize = 16,
  }) =>
      FunIcon(
        padding: padding,
        iconData: FontAwesomeIcons.solidClock,
        iconColor: iconColor,
        circleColor: Colors.transparent,
        circleSize: circleSize,
        iconSize: iconSize,
      );

  /// The icon to be displayed in the center of the circle.
  /// If [icon] is provided, it will be used instead of [iconData].
  final IconData? iconData;

  /// The widget to be displayed in the center of the circle.
  /// If [icon] is provided, it will be used instead of [iconData].
  final Widget? icon;
  final double circleSize;
  final double iconSize;
  final Color circleColor;
  final Color iconColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
          ),
          if (icon != null)
            SizedBox(
              width: circleSize,
              height: circleSize,
              child: icon,
            )
          else
            FaIcon(
              iconData,
              color: iconColor,
              size: iconSize,
            ),
        ],
      ),
    );
  }
}
