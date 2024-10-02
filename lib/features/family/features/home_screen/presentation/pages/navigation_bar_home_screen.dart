import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/overview/pages/family_overview_page.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/account/presentation/pages/us_personal_info_edit_page.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_bar_home_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_custom.dart';
import 'package:givt_app/features/family/features/preferred_church/preferred_church_selection_page.dart';
import 'package:givt_app/features/family/features/profiles/screens/profile_selection_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:go_router/go_router.dart';

class NavigationBarHomeScreen extends StatefulWidget {
  const NavigationBarHomeScreen({
    this.index,
    super.key,
  });

  final int? index;

  static const int homeIndex = 0;
  static const int familyIndex = 1;
  static const int profileIndex = 2;

  @override
  State<NavigationBarHomeScreen> createState() =>
      _NavigationBarHomeScreenState();
}

class _NavigationBarHomeScreenState extends State<NavigationBarHomeScreen> {
  final _cubit = getIt<NavigationBarHomeCubit>();

  int _currentIndex = 0;

  final List<AnalyticsEvent> _analyticsEvents = [
    AnalyticsEvent(
      AmplitudeEvents.navigationBarPressed,
      parameters: {
        'destination': 'Home',
      },
    ),
    AnalyticsEvent(
      AmplitudeEvents.navigationBarPressed,
      parameters: {
        'destination': 'My Family',
      },
    ),
    AnalyticsEvent(
      AmplitudeEvents.navigationBarPressed,
      parameters: {
        'destination': 'My Profile',
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onCustom: _handleCustom,
      onInitial: (context) => _layout(),
      onData: (context, data) => _layout(profilePictureUrl: data),
    );
  }

  Scaffold _layout({String? profilePictureUrl}) {
    return Scaffold(
      bottomNavigationBar: FunNavigationBar(
        index: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          const NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.mask),
            label: 'My Family',
          ),
          NavigationDestination(
            icon: profilePictureUrl == null
                ? const FaIcon(FontAwesomeIcons.person)
                : SizedBox(
                    width: 28,
                    height: 28,
                    child: SvgPicture.network(profilePictureUrl),
                  ),
            label: 'My Profile',
          ),
        ],
        analyticsEvent: (int index) => _analyticsEvents[index],
      ),
      body: AnimatedSwitcher(
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
      ),
    );
  }

  Future<void> _onDestinationSelected(int index) async {
    unawaited(SystemSound.play(SystemSoundType.click));
    unawaited(HapticFeedback.selectionClick());
    if (index == NavigationBarHomeScreen.homeIndex) {
      setState(() {
        _currentIndex = index;
      });
    } else {
      await FamilyAuthUtils.authenticateUser(
        context,
        checkAuthRequest: CheckAuthRequest(
          navigate: (context, {isUSUser}) async {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.onDidChangeDependencies();
  }

  @override
  void initState() {
    _currentIndex = widget.index ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _handleCustom(BuildContext context, NavigationBarHomeCustom custom) {
    switch (custom) {
      case PreferredChurchDialog():
        showPreferredChurchModal(context);
      case UserNeedsRegistration():
      // TODO: Handle this case.
      case FamilyNotSetup():
      // TODO: Handle this case.
    }
  }

  void showPreferredChurchModal(BuildContext context) {
    FunModal(
      title: 'Choose your church',
      icon: const FunIcon(
        iconData: FontAwesomeIcons.church,
      ),
      subtitle: "Let's link your church to make giving easier",
      buttons: [
        FunButton(
          text: 'Continue',
          onTap: () async {
            context.pop(); // close modal
            await Navigator.push(
              context,
              PreferredChurchSelectionPage(
                      setPreferredChurch: _cubit.setPreferredChurch)
                  .toRoute(context),
            );
          },
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.continueChooseChurchClicked,
          ),
        ),
        FunButton.secondary(
          text: "I don't go to church",
          onTap: () => context.pop(),
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.dontGoToChurchClicked,
          ),
        ),
      ],
    ).show(context);
  }
}
