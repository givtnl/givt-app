import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/family_goal_tracker/cubit/goal_tracker_cubit.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';
import 'package:givt_app/utils/utils.dart';

class HomeGoalTracker extends StatelessWidget {
  const HomeGoalTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log('HomeGoalTracker: onTap');
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(right: 10, left: 10, top: 20),
        decoration: ShapeDecoration(
          color: AppTheme.primary98,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: BlocConsumer<GoalTrackerCubit, GoalTrackerState>(
          listener: (context, state) {
            if (state.status == GoalTrackerStatus.error) {
              SnackBarHelper.showMessage(
                context,
                text: state.error,
                isError: true,
              );
            }
          },
          builder: (context, state) {
            if (state.status == GoalTrackerStatus.activeGoal) {
              return BlocBuilder<GoalTrackerCubit, GoalTrackerState>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      const Positioned(
                        right: 0,
                        top: 38,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            FontAwesomeIcons.arrowRight,
                            size: 16,
                            color: AppTheme.primary40,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/images/goal_flag_small.svg',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your Family Goal',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontSize: 17,
                                      fontFamily: 'Mulish',
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.organisation.organisationName ??
                                    'Give together',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontFamily: 'Mulish',
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
