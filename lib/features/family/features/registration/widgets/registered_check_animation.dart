import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';

class RegisteredCheckAnimation extends StatefulWidget {
  const RegisteredCheckAnimation({
    super.key,
  });

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
    return TweenAnimationBuilder(
      duration: const Duration(seconds: 2),
      curve: Curves.elasticOut,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        leftPosition = size.width * (0.28 - 0.15 * value);
        topPosition = size.width * (0.4 - 0.25 * value);
        imageSize = size.width * (0.3 * value);

        return Stack(
          alignment: Alignment.center,
          children: [
            registeredCheckBackground(height: size.height * 0.25),
            Positioned(
              left: leftPosition,
              top: topPosition,
              child: registeredCheck(
                clipBehavior: Clip.none,
                width: imageSize,
              ),
            ),
          ],
        );
      },
    );
  }
}
