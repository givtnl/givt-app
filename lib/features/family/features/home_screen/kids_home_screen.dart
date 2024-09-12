import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/history/history_cubit/history_cubit.dart';
import 'package:givt_app/features/family/features/history/history_screen.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/kids_home_screen_app_bar.dart';
import 'package:givt_app/features/family/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/pages/goal_screen.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/screens/profile_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/utils/utils.dart';

class KidsHomeScreen extends StatelessWidget {
  const KidsHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KidsHomeScreenAppBar(),
      bottomNavigationBar: FunNavigationBar(
        index: context.watch<NavigationCubit>().state.activeDestination.index,
        onDestinationSelected: (int index) {
          SystemSound.play(SystemSoundType.click);
          HapticFeedback.selectionClick();

          context
              .read<NavigationCubit>()
              .changePage(NavigationDestinationData.values[index]);

          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.navigationBarPressed,
            eventProperties: {
              'destination': NavigationDestinationData.values[index].name,
            },
          );
        },
        destinations: NavigationDestinationData.values
            .map(
              (destination) => NavigationDestination(
                icon: SvgPicture.asset(destination.iconPath),
                label: destination.label,
              ),
            )
            .toList(),
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOutQuart,
              switchOutCurve: Curves.easeInOutQuart,
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              child: getPage(state.activeDestination, context),
            ),
          );
        },
      ),
    );
  }

  Widget getPage(NavigationDestinationData destination, BuildContext context) {
    final user = context.read<ProfilesCubit>().state.activeProfile;
    switch (destination) {
      case NavigationDestinationData.home:
        return const ProfileScreen();
      case NavigationDestinationData.groups:
        context.read<ImpactGroupsCubit>().fetchImpactGroups(user.id);
        return const GoalScreen();
      case NavigationDestinationData.myGivts:
        context.read<HistoryCubit>().fetchHistory(user.id, fromBeginning: true);
        return const HistoryScreen();
    }
  }
}
