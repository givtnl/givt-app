import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class IntroBottomCityWidget extends StatelessWidget {
  const IntroBottomCityWidget({
    required this.position,
    required this.opacity,
    required this.nightShiftController,
    required this.cityNightOpacity,
    super.key,
  });

  final double position;
  final double opacity;
  final AnimationController nightShiftController;
  final Animation<double> cityNightOpacity;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
          bottom: -height * position,
          child: AnimatedBuilder(
            animation: nightShiftController,
            builder: (context, child) => Opacity(
              opacity: 1 - cityNightOpacity.value,
              child: SizedBox(
                height: height * 0.25,
                width: width,
                child: SvgPicture.asset(
                  'assets/family/images/city_day.svg',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -height * position,
          child: AnimatedBuilder(
            animation: nightShiftController,
            builder: (context, child) => Opacity(
              opacity: cityNightOpacity.value,
              child: SizedBox(
                height: height * 0.25,
                width: width,
                child: SvgPicture.asset(
                  'assets/family/images/city_purple.svg',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
