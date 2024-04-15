import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/goal_tracker/cubit/goal_tracker_cubit.dart';

class GoalCompletedWidget extends StatelessWidget {
  const GoalCompletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<GoalTrackerCubit>().state;
    final org = state.organisation;
    return Stack(children: [
      Positioned(
        right: 0,
        child: IconButton(
          onPressed: () {
            context.read<GoalTrackerCubit>().clearGoal();
          },
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 17,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Family Goal completed. Great job!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
