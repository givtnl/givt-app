import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/overview/pages/family_overview_page.dart';
import 'package:givt_app/features/children/utils/add_member_util.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/account/presentation/pages/us_personal_info_edit_page.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_bar_home_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_custom.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_screen_uimodel.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/pages/family_home_screen.dart';
import 'package:givt_app/features/family/features/preferred_church/preferred_church_selection_page.dart';
import 'package:givt_app/features/family/features/profiles/widgets/profiles_empty_state_widget.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/features/impact_groups/widgets/impact_group_recieve_invite_sheet.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/theme/app_theme_switcher.dart';
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
  static bool _isShowingPreferredChurch = false;

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
      onLoading: (context) => const Scaffold(
        body: Center(child: CustomCircularProgressIndicator()),
      ),
      onError: (context, error) => Scaffold(
        body: ProfilesEmptyStateWidget(
          onRetry: _cubit.refreshData,
        ),
      ),
      onInitial: (context) => _regularLayout(),
      onData: (context, data) => data.familyInviteGroup == null
          ? _regularLayout(uiModel: data)
          : ImpactGroupReceiveInviteSheet(
              invitdImpactGroup: data.familyInviteGroup!,
            ),
    );
  }

  Scaffold _regularLayout({NavigationBarHomeScreenUIModel? uiModel}) {
    return Scaffold(
      bottomNavigationBar: FunNavigationBar(
        index: _currentIndex,
        onDestinationSelected: (int index) =>
            _onDestinationSelected(index, uiModel: uiModel),
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
            icon: uiModel?.profilePictureUrl == null
                ? const FaIcon(FontAwesomeIcons.person)
                : SizedBox(
                    width: 28,
                    height: 28,
                    child: SvgPicture.network(uiModel!.profilePictureUrl!),
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
            const FamilyHomeScreen(),
            const FamilyOverviewPage(),
            const USPersonalInfoEditPage(),
          ][_currentIndex],
        ),
      ),
    );
  }

  Future<void> _onDestinationSelected(
    int index, {
    NavigationBarHomeScreenUIModel? uiModel,
  }) async {
    unawaited(SystemSound.play(SystemSoundType.click));
    unawaited(HapticFeedback.selectionClick());
    if (index == NavigationBarHomeScreen.homeIndex) {
      _setIndex(index);
    } else {
      await FamilyAuthUtils.authenticateUser(
        context,
        checkAuthRequest: CheckAuthRequest(
          navigate: (context, {isUSUser}) async {
            _setIndex(index);
          },
        ),
      );
    }
  }

  void _setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppThemeSwitcher.of(context).switchTheme(isFamilyApp: true);
    });
  }

  @override
  void initState() {
    _currentIndex = widget.index ?? 0;
    super.initState();
  }

  Future<void> _handleCustom(
    BuildContext context,
    NavigationBarHomeCustom custom,
  ) async {
    switch (custom) {
      case PreferredChurchDialog():
        await _showPreferredChurchModal(context);
      case FamilyNotSetup():
        await _showSetupFamily(context);
    }
  }

  Future<void> _showSetupFamily(BuildContext context) async {
    await AddMemberUtil.addMemberPushPages(context);
  }

  Future<void> _showPreferredChurchModal(BuildContext context) async {
    if (_isShowingPreferredChurch) {
      // do nothing, dialog is already showing
    } else {
      _isShowingPreferredChurch = true;
      await FunModal(
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
      _isShowingPreferredChurch = false;
    }
  }
}
