import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunAvatar extends FunIcon {
  const FunAvatar({
    required this.semanticsIdentifier,
    super.key,
    this.customCircleColor = FamilyAppTheme.primary95,
    this.customAvatar = const SizedBox(),
    this.customSize = 48,
  });

  factory FunAvatar.captain({bool isLarge = false}) {
    return FunAvatar(
      semanticsIdentifier: 'captain',
      customCircleColor: FamilyAppTheme.neutral95,
      customAvatar: SvgPicture.asset(
        isLarge
            ? 'assets/family/images/avatar_captain_large.svg'
            : 'assets/family/images/avatar_captain.svg',
      ),
      customSize: isLarge ? 140 : 48,
    );
  }

  factory FunAvatar.captainAi({bool withBorder = false, bool isLarge = false}) {
    return FunAvatar(
      semanticsIdentifier: 'captainAi',
      customCircleColor: FamilyAppTheme.neutral95,
      customAvatar: Image.asset(
        withBorder
            ? 'assets/family/images/beta_captain_with_border.webp'
            : 'assets/family/images/beta_captain.webp',
      ),
      customSize: isLarge ? 160 : 50,
    );
  }

  factory FunAvatar.family({bool isLarge = false}) {
    return FunAvatar(
      semanticsIdentifier: 'family',
      customCircleColor: FamilyAppTheme.neutral95,
      customAvatar: SvgPicture.asset('assets/family/images/family_avatar.svg'),
      customSize: isLarge ? 120 : 48,
    );
  }

  final String semanticsIdentifier;
  final Color customCircleColor;
  final Widget customAvatar;
  final double customSize;

  @override
  Widget build(BuildContext context) {
    return FunIcon(
      icon: customAvatar,
      semanticsIdentifier: semanticsIdentifier,
      padding: EdgeInsets.zero,
      circleColor: customCircleColor,
      circleSize: customSize,
    );
  }
}
