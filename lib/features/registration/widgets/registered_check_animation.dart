import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisteredCheckAnimation extends StatefulWidget {
  @override
  _RegisteredCheckAnimationState createState() =>
      _RegisteredCheckAnimationState();
}

class _RegisteredCheckAnimationState extends State<RegisteredCheckAnimation> {
  double leftPosition = 0;
  double topPosition = 0;
  double imageSize = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return FutureBuilder(
        // ignore: inference_failure_on_instance_creation
        future: Future.delayed(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          return TweenAnimationBuilder(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.elasticOut,
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              leftPosition = size.width * (0.3 - 0.15 * value);
              topPosition = size.width * (0.31 - 0.25 * value);
              imageSize = size.width * (0.42 * value);

              return Stack(
                children: [
                  SvgPicture.asset(
                    'assets/images/registered_check_background.svg',
                    height: size.height * 0.3,
                  ),
                  Positioned(
                    left: leftPosition,
                    top: topPosition,
                    child: SvgPicture.asset(
                      'assets/images/registered_check.svg',
                      width: imageSize,
                      clipBehavior: Clip.none,
                    ),
                  ),
                ],
              );
            },
          );
        });
  }
}
