import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/overview/pages/family_overview_page.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/account/presentation/pages/us_personal_info_edit_page.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/auth/presentation/models/family_auth_state.dart';
import 'package:givt_app/features/family/features/box_origin/box_origin_selection_page.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_bar_home_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_custom.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_screen_uimodel.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/pages/family_home_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/features/impact_groups/widgets/impact_group_recieve_invite_sheet.dart';
import 'package:givt_app/features/internet_connection/internet_connection_cubit.dart';
import 'package:givt_app/shared/dialogs/internet_connection_lost_dialog.dart';
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
  final _connectionCubit = getIt<InternetConnectionCubit>();

  int _currentIndex = 0;
  static bool _isShowingBoxOrigin = false;

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
    return BlocConsumer<FamilyAuthCubit, FamilyAuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is Unauthenticated) {
          return const FullScreenLoadingWidget();
        } else {
          return BlocListener<InternetConnectionCubit, InternetConnectionState>(
            bloc: _connectionCubit,
            listener: (context, state) {
              if (state is InternetConnectionLost) {
                InternetConnectionLostDialog.show(context);
              }
            },
            child: BaseStateConsumer(
              cubit: _cubit,
              onCustom: _handleCustom,
              onLoading: (context) => const Scaffold(
                body: Center(child: CustomCircularProgressIndicator()),
              ),
              onInitial: (context) => _regularLayout(),
              onData: (context, data) => data.familyInviteGroup == null
                  ? _regularLayout(uiModel: data)
                  : ImpactGroupReceiveInviteSheet(
                      invitdImpactGroup: data.familyInviteGroup!,
                    ),
            ),
          );
        }
      },
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
        checkAuthRequest: FamilyCheckAuthRequest(
          navigate: (context) async {
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
      case BoxOriginDialog():
        await _showBoxOriginModal(context);
    }
  }

  Future<void> _showBoxOriginModal(BuildContext context) async {
    if (_isShowingBoxOrigin) {
      // do nothing, dialog is already showing
    } else {
      _isShowingBoxOrigin = true;
      await FunModal(
        title: 'Did you get a generosity mission box?',
        icon: const FunIcon(
          iconData: FontAwesomeIcons.gift,
        ),
        buttons: [
          FunButton(
            text: 'Yes',
            onTap: () async {
              context.pop(); // close modal
              await Navigator.push(
                context,
                BoxOriginSelectionPage(setBoxOrigin: _cubit.setBoxOrigin)
                    .toRoute(context),
              );
            },
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.continueChooseChurchClicked,
            ),
          ),
          FunButton.secondary(
            text: 'No',
            onTap: () => context.pop(),
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.dontHaveABoxClicked,
            ),
          ),
        ],
      ).show(context);
      _isShowingBoxOrigin = false;
    }
  }
}
