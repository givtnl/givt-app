import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/utils/app_theme.dart';

class QrCodeTarget extends StatelessWidget {
  const QrCodeTarget({
    super.key,
    this.targetCornerSize = 100,
    this.targetColor = AppTheme.givtLightGreen,
  });

  final double targetCornerSize;
  final Color targetColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                'assets/images/target_left_top.svg',
                width: targetCornerSize,
                height: targetCornerSize,
                color: targetColor,
              ),
              SizedBox(width: targetCornerSize),
              SvgPicture.asset(
                'assets/images/target_right_top.svg',
                width: targetCornerSize,
                height: targetCornerSize,
                color: targetColor,
              ),
            ],
          ),
          SizedBox(height: targetCornerSize),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                'assets/images/target_left_bottom.svg',
                width: targetCornerSize,
                height: targetCornerSize,
                color: targetColor,
              ),
              SizedBox(width: targetCornerSize),
              SvgPicture.asset(
                'assets/images/target_right_bottom.svg',
                width: targetCornerSize,
                height: targetCornerSize,
                color: targetColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
