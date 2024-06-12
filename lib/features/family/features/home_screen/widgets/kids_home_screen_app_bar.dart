import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class KidsHomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KidsHomeScreenAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final profiles = context.watch<ProfilesCubit>();
    final navigation = context.watch<NavigationCubit>();
    return AppBar(
      title: Text(
        navigation.state.activeDestination.appBarTitle.isEmpty
            ? profiles.state.activeProfile.firstName
            : navigation.state.activeDestination.appBarTitle,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.onPrimary,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      actions: [
        if (navigation.state.activeDestination ==
            NavigationDestinationData.home)
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.retweet,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
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
