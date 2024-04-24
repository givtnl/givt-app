import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/give/widgets/home_goal_tracker.dart';
import 'package:givt_app/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';

class ImpactGroupScreen extends StatelessWidget {
  const ImpactGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return ConstrainedBox(
      constraints: BoxConstraints.expand(
        width: size.width,
        height: size.height,
      ),
      child: BlocBuilder<ImpactGroupsCubit, ImpactGroupsState>(
        builder: (context, state) {
          if (state.status == ImpactGroupCubitStatus.loading &&
              state.goals.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.goals.isEmpty) {
            return const NoGoalsWidget();
          }
          return Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  ...state.goals.map(
                    (e) => HomeGoalTracker(
                      group: state.getGoalGroup(e),
                    ),
                  ),
                ],
              ),
              if (state.status == ImpactGroupCubitStatus.loading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }
}

class NoGoalsWidget extends StatelessWidget {
  const NoGoalsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/family_superheroes.svg'),
          const SizedBox(height: 20),
          Text(
            context.l10n.yourFamilyGroupWillAppearHere,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
