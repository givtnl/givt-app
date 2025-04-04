import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunGoal extends FunIcon {
  const FunGoal({
    super.key,
    this.customCircleColor = FamilyAppTheme.primary95,
  });

  factory FunGoal.neutral95() {
    return const FunGoal(
      customCircleColor: FamilyAppTheme.neutral95,
    );
  }

  final Color customCircleColor;

  @override
  Widget build(BuildContext context) {
    return FunIcon(
      icon: Semantics(
        label: 'goaltile',
        child: SvgPicture.asset(
          'assets/family/images/goal_tile.svg',
        ),
      ),
      padding: EdgeInsets.zero,
      circleColor: customCircleColor,
    );
  }
}
