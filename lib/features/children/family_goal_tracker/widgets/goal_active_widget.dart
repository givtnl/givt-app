import 'package:flutter/material.dart';
import 'package:givt_app/features/children/family_goal_tracker/widgets/gradient_progress_bar.dart';
import 'package:givt_app/utils/app_theme.dart';

class GoalActiveWidget extends StatelessWidget {
  const GoalActiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
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
          r'Family Goal: $100',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w400,
              ),
        ),
        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: GradientProgressBar(
            progress: 0.5,
            colors: [
              AppTheme.highlight90,
              AppTheme.progressGradient1,
              AppTheme.progressGradient2,
              AppTheme.progressGradient3,
              AppTheme.primary70,
            ],
          ),
        ),
      ],
    );
  }
}
