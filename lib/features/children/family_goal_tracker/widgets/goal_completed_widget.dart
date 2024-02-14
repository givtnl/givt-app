import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GoalCompletedWidget extends StatelessWidget {
  const GoalCompletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/images/goal_check.svg',
          width: 40,
          height: 40,
        ),
        const SizedBox(height: 4),
        Text(
          'A Pocket Full Of Hope Inc.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 17,
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Family Goal completed. Great job!',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
