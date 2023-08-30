import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VPCIntroItemImage extends StatelessWidget {
  const VPCIntroItemImage({
    required this.background,
    required this.foreground,
    super.key,
  });

  final String background;
  final String foreground;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(background),
        SvgPicture.asset(foreground),
      ],
    );
  }
}
