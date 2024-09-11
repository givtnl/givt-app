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

  factory FunIcon.microphone({Color circleColor = FamilyAppTheme.primary95}) =>
      FunIcon(
        iconData: FontAwesomeIcons.microphone,
        circleColor: circleColor,
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

  factory FunIcon.box({
    Color circleColor = FamilyAppTheme.primary95,
    Color iconColor = FamilyAppTheme.primary20,
  }) =>
      FunIcon(
        iconData: FontAwesomeIcons.box,
        circleColor: circleColor,
        iconColor: iconColor,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
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
          icon ??
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
