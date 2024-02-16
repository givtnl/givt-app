import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/family_goal_tracker/pages/family_goal_tracker.dart';
import 'package:givt_app/features/children/family_history/family_history.dart';
import 'package:givt_app/features/children/family_history/family_history_cubit/family_history_cubit.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/children/overview/widgets/profiles_overview_widget.dart';
import 'package:givt_app/shared/widgets/custom_green_elevated_button.dart';
import 'package:go_router/go_router.dart';

class FamilyAvailablePage extends StatelessWidget {
  const FamilyAvailablePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FamilyOverviewCubit>().state
        as FamilyOverviewUpdatedState;
    final currentUserFirstName = context.read<AuthCubit>().state.user.firstName;
    final sortedAdultProfiles = state.sortedAdults(currentUserFirstName);
    final scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        // Scrolled to end of list try to fetch more data
        context.read<FamilyHistoryCubit>().fetchHistory();
      }
    });

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FamilyGoalTracker(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
            child: CustomGreenElevatedButton(
              title: 'Create Family Goal (placeholder)',
              onPressed: () {
                context.pushNamed(
                  Pages.createFamilyGoal.name,
                  extra: context.read<FamilyOverviewCubit>(),
                );
              },
            ),
          ),
          ProfilesOverviewWidget(
            profiles: sortedAdultProfiles,
          ),
          const SizedBox(height: 20),
          ProfilesOverviewWidget(
            profiles: state.children,
          ),
          const SizedBox(height: 28),
          const FamilyHistory(),
        ],
      ),
    );
  }
}
