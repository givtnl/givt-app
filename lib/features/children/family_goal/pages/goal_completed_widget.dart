import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/impact_groups/cubit/impact_groups_cubit.dart';

class GoalCompletedWidget extends StatelessWidget {
  const GoalCompletedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final impactGroupsCubit = context.watch<ImpactGroupsCubit>();
    final org = impactGroupsCubit.state.familyGroup.organisation;
    return Stack(
      children: [
        Positioned(
          right: 0,
          child: IconButton(
            onPressed: () => impactGroupsCubit
                .dismissGoal(impactGroupsCubit.state.familyGroup.goal.id),
            icon: const Icon(
              FontAwesomeIcons.xmark,
              size: 20,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
            child: Column(
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
                  org.organisationName ?? 'Name Placeholder',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Family Goal completed. Great job!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
