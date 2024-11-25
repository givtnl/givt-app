import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class IntroSunWidget extends StatelessWidget {
  const IntroSunWidget({
    this.scale = 0.5,
    this.position = 0.2,
    this.isNight = false,
    super.key,
  });

  final double scale;
  final double position;
  final bool isNight;

  @override
  Widget build(BuildContext context) {
    const smallestCircleModifier = 80;
    const middleCircleModifier = 40;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: ((height - width * scale) / 2) * position),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: width / 2 - width * scale / 2,
            child: Container(
              width: width * scale,
              height: width * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isNight
                    ? const Color(0xFF1A2C3A)
                    : const Color(0xFFFFF9EB).withOpacity(0.7),
              ),
            ),
          ),
          Positioned(
            top: middleCircleModifier * scale,
            left: width / 2 - (width - middleCircleModifier * 2) * scale / 2,
            child: Container(
              width: (width - middleCircleModifier * 2) * scale,
              height: (width - middleCircleModifier * 2) * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isNight
                    ? const Color(0xFF464D53)
                    : FamilyAppTheme.highlight95,
              ),
            ),
          ),
          Positioned(
            top: smallestCircleModifier * scale,
            left: width / 2 - (width - smallestCircleModifier * 2) * scale / 2,
            child: Container(
              width: (width - smallestCircleModifier * 2) * scale,
              height: (width - smallestCircleModifier * 2) * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isNight
                    ? const Color(0xFFEAEAEA)
                    : FamilyAppTheme.highlight90,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
