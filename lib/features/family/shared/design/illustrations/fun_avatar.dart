import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunAvatar extends FunIcon {
  const FunAvatar({
    super.key,
    this.customCircleColor = FamilyAppTheme.primary95,
    this.customAvatar = const SizedBox(),
    this.customSize = 48,
  });

  factory FunAvatar.captain() {
    return FunAvatar(
      customCircleColor: FamilyAppTheme.neutral95,
      customAvatar: SvgPicture.asset(
        'assets/family/images/avatar_captain.svg',
      ),
      customSize: 48,
    );
  }

  final Color customCircleColor;
  final Widget customAvatar;
  final double customSize;

  @override
  Widget build(BuildContext context) {
    return FunIcon(
      icon: customAvatar,
      padding: EdgeInsets.zero,
      circleColor: customCircleColor,
      circleSize: customSize,
    );
  }
}
