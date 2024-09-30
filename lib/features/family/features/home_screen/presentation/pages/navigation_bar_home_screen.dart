import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/overview/pages/family_overview_page.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/account/presentation/pages/us_personal_info_edit_page.dart';
import 'package:givt_app/features/family/features/history/history_cubit/history_cubit.dart';
import 'package:givt_app/features/family/features/history/history_screen.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_bar_home_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_custom.dart';
import 'package:givt_app/features/family/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/pages/goal_screen.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/screens/profile_screen.dart';
import 'package:givt_app/features/family/features/profiles/screens/profile_selection_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/utils/utils.dart';

class NavigationBarHomeScreen extends StatefulWidget {
  const NavigationBarHomeScreen({
    super.key,
  });

  @override
  State<NavigationBarHomeScreen> createState() =>
      _NavigationBarHomeScreenState();
}

class _NavigationBarHomeScreenState extends State<NavigationBarHomeScreen> {
  final _cubit = getIt<NavigationBarHomeCubit>();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FunNavigationBar(
        index: _currentIndex,
        onDestinationSelected: (int index) {
          SystemSound.play(SystemSoundType.click);
          HapticFeedback.selectionClick();

          setState(() {
            _currentIndex = index;
          });

          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.navigationBarPressed,
            eventProperties: {
              'destination': NavigationDestinationData.values[index].name,
            },
          );
        },
        destinations: const [
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.mask),
            label: 'My Family',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.person),
            label: 'My Profile',
          ),
        ],
        analyticsEvent: (int index) => AnalyticsEvent(
          AmplitudeEvents.navigationBarPressed,
          parameters: {
            'destination': NavigationDestinationData.values[index].name,
          },
        ),
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onCustom: _handleCustom,
        onInitial: (context) {
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
              child: <Widget>[
                const ProfileSelectionScreen(),
                const FamilyOverviewPage(),
                const USPersonalInfoEditPage(),
              ][_currentIndex],
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.onDidChangeDependencies();
  }

  void _handleCustom(BuildContext context, NavigationBarHomeCustom custom) {
    //TODO
  }
}
