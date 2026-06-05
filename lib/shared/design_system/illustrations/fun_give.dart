import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class FunGive extends StatelessWidget {
  const FunGive({
    this.circleSize = 112,
    this.circleColor = FamilyAppTheme.primary95,
    super.key,
  });

  factory FunGive.secondary30() => const FunGive(
        circleColor: FamilyAppTheme.info95,
      );

  final double circleSize;
  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        SvgPicture.asset(
          'assets/fun/illustrations/give.svg',
          width: circleSize / 112 * 140,
        ),
      ],
    );
  }
}
