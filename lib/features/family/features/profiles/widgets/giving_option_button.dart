import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GiveOptionButton extends StatelessWidget {
  const GiveOptionButton(
      {required this.context,
      required this.size,
      required this.text,
      required this.imageLocation,
      required this.backgroundColor,
      required this.secondColor,
      required this.onPressed,
      super.key,});
  final BuildContext context;
  final Size size;
  final String text;
  final String imageLocation;
  final Color backgroundColor;
  final Color secondColor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: secondColor.withOpacity(0.25),
            width: 2,
          ),
        ),
      ),
      child: SizedBox(
        width: size.width * 0.5 - 74,
        height: size.width * 0.5 - 40,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(imageLocation),
            const SizedBox(height: 5),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: secondColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
