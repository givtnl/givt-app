import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/common_icons.dart';
import 'package:givt_app/features/family/shared/widgets/top_app_bar.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class KidsHomeScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const KidsHomeScreenAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final profiles = context.watch<ProfilesCubit>();
    final navigation = context.watch<NavigationCubit>();
    return TopAppBar(
      automaticallyImplyLeading: false,
      title: navigation.state.activeDestination.appBarTitle.isEmpty
          ? profiles.state.activeProfile.firstName
          : navigation.state.activeDestination.appBarTitle,
      actions: [
        if (navigation.state.activeDestination ==
            NavigationDestinationData.home)
          IconButton(
            icon: switchProfilesIcon(),
            onPressed: () {
              profiles.fetchAllProfiles();
              context.read<FlowsCubit>().resetFlow();

              context.pushReplacementNamed(FamilyPages.profileSelection.name);
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.profileSwitchPressed,
              );
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
