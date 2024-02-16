import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:go_router/go_router.dart';

class NoGoalSetWidget extends StatelessWidget {
  const NoGoalSetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        Pages.createFamilyGoal.name,
        extra: context.read<FamilyOverviewCubit>(),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: 0,
            top: 38,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                FontAwesomeIcons.arrowRight,
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
            ),
          ),
        ],
      ),
    );
  }
}
