import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoGoalSetWidget extends StatelessWidget {
  const NoGoalSetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/goal_flag_small.svg',
            width: 40,
            height: 40,
          ),
          const SizedBox(height: 4),
          Text(
            'Create a Family Goal',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 17,
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Give together',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}
