import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/family_goal/pages/family_goal_tracker.dart';
import 'package:givt_app/features/children/family_history/family_history.dart';
import 'package:givt_app/features/children/family_history/family_history_cubit/family_history_cubit.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/children/overview/widgets/profiles_overview_widget.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';

class FamilyAvailablePage extends StatefulWidget {
  const FamilyAvailablePage({
    super.key,
  });

  @override
  State<FamilyAvailablePage> createState() => _FamilyAvailablePageState();
}

class _FamilyAvailablePageState extends State<FamilyAvailablePage> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<FamilyOverviewCubit>().state
        as FamilyOverviewUpdatedState;
    final currentUserId = context.read<FamilyAuthCubit>().user!.guid;
    final sortedAdultProfiles = state.sortedAdults(currentUserId);
    final scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        // Scrolled to end of list try to fetch more data
        context.read<FamilyHistoryCubit>().fetchHistory();
      }
    });
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait(
          [
            context.read<FamilyOverviewCubit>().refresh(),
            context.read<FamilyHistoryCubit>().refresh(),
          ],
        );
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FamilyGoalTracker(),
            const SizedBox(height: 24),
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
      ),
    );
  }
}
