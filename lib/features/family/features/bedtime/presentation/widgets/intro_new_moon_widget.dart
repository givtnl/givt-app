import 'package:flutter/widgets.dart';

class IntroNewMoonWidget extends StatelessWidget {
  const IntroNewMoonWidget({
    required this.positionTop,
    required this.positionRight,
    super.key,
  });

  final double positionTop;
  final double positionRight;

  @override
  Widget build(BuildContext context) {
    const smallestCircleModifier = 80;
    const middleCircleModifier = 40;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: ((height - width * 0.5) / 2) * positionTop),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: (width - width * 0.5) / 2 * positionRight,
            child: Container(
              width: width * 0.5,
              height: width * 0.5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1A2C3A),
              ),
            ),
          ),
          Positioned(
            top: middleCircleModifier * 0.5,
            left: width / 2 * positionRight -
                (width * positionRight - middleCircleModifier * 2) * 0.5 / 2,
            child: Container(
              width: (width - middleCircleModifier * 2) * 0.5,
              height: (width - middleCircleModifier * 2) * 0.5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF464D53),
              ),
            ),
          ),
          Positioned(
            top: smallestCircleModifier * 0.5,
            left: (width * positionRight -
                    (width * positionRight - smallestCircleModifier * 2) *
                        0.5) /
                2,
            child: Container(
              width: (width - smallestCircleModifier * 2) * 0.5,
              height: (width - smallestCircleModifier * 2) * 0.5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEAEAEA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
