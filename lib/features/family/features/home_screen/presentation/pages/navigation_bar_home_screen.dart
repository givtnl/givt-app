import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/notification/notification_service.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/auth/presentation/models/family_auth_state.dart';
import 'package:givt_app/features/family/features/game_summary/presentation/pages/game_summaries_screen.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_bar_home_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_custom.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_screen_uimodel.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/pages/family_home_screen.dart';
import 'package:givt_app/features/family/features/impact_groups/widgets/dialogs/impact_group_recieve_invite_sheet.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/league_screen.dart';
import 'package:givt_app/features/family/features/missions/domain/entities/mission.dart';
import 'package:givt_app/features/family/features/missions/domain/repositories/mission_repository.dart';
import 'package:givt_app/features/family/features/overview/pages/family_overview_page.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/content/tutorial/fun_tooltip.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/reward_banner_dialog.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/features/internet_connection/internet_connection_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/internet_connection_lost_dialog.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/theme/app_theme_switcher.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class NavigationBarHomeScreen extends StatefulWidget {
  const NavigationBarHomeScreen({
    this.index,
    super.key,
  });

  final int? index;

  static const int homeIndex = 0;
  static const int familyIndex = 1;
  static const int memoriesIndex = 2;
  static const int profileIndex = 3;

  static const List<int> validIndexes = [
    homeIndex,
    familyIndex,
    memoriesIndex,
    profileIndex,
  ];

  @override
  State<NavigationBarHomeScreen> createState() =>
      _NavigationBarHomeScreenState();
}

class _NavigationBarHomeScreenState extends State<NavigationBarHomeScreen> {
  final TooltipController _tooltipController = TooltipController();
  final _cubit = getIt<NavigationBarHomeCubit>();
  final _connectionCubit = getIt<InternetConnectionCubit>();
  final _missionRepo = getIt<MissionRepository>();

  late final AppLifecycleListener _listener;
  late final StreamSubscription<Mission> _missionAchievedListener;

  int _currentIndex = 0;
  bool _hasShownTutorialPopup = false;

  List<AnalyticsEvent> _getAnalyticsEvents(bool showMemoriesTab) {
    final events = <AnalyticsEvent>[
      AnalyticsEvent(
        AmplitudeEvents.navigationBarPressed,
        parameters: {
          'destination': 'Home',
        },
      ),
      AnalyticsEvent(
        AmplitudeEvents.navigationBarPressed,
        parameters: {
          'destination': 'Family',
        },
      ),
    ];
    
    if (showMemoriesTab) {
      events.add(
        AnalyticsEvent(
          AmplitudeEvents.navigationBarPressed,
          parameters: {
            'destination': 'Memories',
          },
        ),
      );
    }
    
    events.add(
      AnalyticsEvent(
        AmplitudeEvents.navigationBarPressed,
        parameters: {
          'destination': 'League',
        },
      ),
    );
    
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return OverlayTooltipScaffold(
      controller: _tooltipController,
      preferredOverlay: Container(
        color: FamilyAppTheme.primary50.withValues(alpha: 0.5),
      ),
      builder: (context) => BlocConsumer<FamilyAuthCubit, FamilyAuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is Unauthenticated) {
            return const FullScreenLoadingWidget();
          } else {
            return BlocListener<InternetConnectionCubit,
                InternetConnectionState>(
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
                        invitedImpactGroup: data.familyInviteGroup!,
                      ),
              ),
            );
          }
        },
      ),
    );
  }

  Scaffold _regularLayout({NavigationBarHomeScreenUIModel? uiModel}) {
    final width = MediaQuery.of(context).size.width;
    final showMemoriesTab = uiModel?.showMemoriesTab ?? true;
    final destinations = <NavigationDestination>[
      NavigationDestination(
        icon: const FaIcon(FontAwesomeIcons.house),
        label: context.l10n.familyNavigationBarHome,
      ),
      NavigationDestination(
        icon: FunTooltip(
          tooltipIndex: 1,
          title: context.l10n.tutorialManagingFamilyTitle,
          description: context.l10n.tutorialManagingFamilyDescription,
          labelBottomLeft: '2/6',
          triangleOffset: Offset(-(width / (showMemoriesTab ? 4 : 3)) / 2, 0),
          child: const FaIcon(
            FontAwesomeIcons.mask,
          ),
        ),
        label: context.l10n.familyNavigationBarFamily,
      ),
      if (showMemoriesTab)
        NavigationDestination(
          icon: const FaIcon(FontAwesomeIcons.solidCalendar),
          label: context.l10n.familyNavigationBarMemories,
        ),
      NavigationDestination(
        icon: const FaIcon(FontAwesomeIcons.medal),
        label: context.l10n.familyNavigationBarLeague,
      ),
    ];
    final pages = <Widget>[
      FamilyHomeScreen(
        tooltipController: _tooltipController,
      ),
      const FamilyOverviewPage(),
      if (showMemoriesTab) const GameSummariesScreen(),
      const LeagueScreen(),
    ];
    return Scaffold(
      bottomNavigationBar: FunNavigationBar(
        index: _currentIndex,
        onDestinationSelected: (int index) =>
            _onDestinationSelected(index, uiModel: uiModel),
        destinations: destinations,
        analyticsEvent: (int index) => _getAnalyticsEvents(showMemoriesTab)[index],
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
          child: pages[_currentIndex],
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
    if (index != NavigationBarHomeScreen.familyIndex) {
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
    if (NavigationBarHomeScreen.validIndexes.contains(index)) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppThemeSwitcher.of(context).switchTheme(isFamilyApp: true);
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          NotificationService.instance.navigateFirebaseNotification(message);
        }
      });
    });
  }

  @override
  void initState() {
    _setIndex(widget.index ?? 0);
    _listener = AppLifecycleListener(
      onResume: _connectionCubit.resume,
      onHide: _connectionCubit.pause,
      onPause: _connectionCubit.pause,
    );

    _missionAchievedListener =
        _missionRepo.onMissionAchieved().listen((mission) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: Theme.of(context).colorScheme.primary.withValues(alpha: .25),
        builder: (context) => MissionCompletedBannerDialog(
          missionName: mission.title,
          showTooltip: mission.showAchievedTooltip ?? false,
        ),
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _listener.dispose();
    _missionAchievedListener.cancel();
    super.dispose();
  }

  Future<void> _handleCustom(
    BuildContext context,
    NavigationBarHomeCustom custom,
  ) async {
    switch (custom) {
      case final SwitchTab event:
        _setIndex(event.tabIndex);
      case TutorialPopup():
        if (!_hasShownTutorialPopup) {
          setState(() {
            _hasShownTutorialPopup = true;
          });
          _showTutorialPopup(context);
        }
    }
  }

  void _showTutorialPopup(BuildContext context) {
    FunModal(
      icon: FunAvatar.captain(isLarge: true),
      title: context.l10n.tutorialIntroductionTitle,
      subtitle: context.l10n.tutorialIntroductionDescription,
      buttons: [
        FunButton(
          onTap: () {
            context.pop();
            _cubit.onShowTutorialClicked();
          },
          text: "Let's go!",
          analyticsEvent: AnalyticsEvent(AmplitudeEvents.tutorialStartClicked),
        ),
        FunButton.secondary(
          onTap: () {
            context.pop();
          },
          text: context.l10n.buttonSkip,
          analyticsEvent: AnalyticsEvent(AmplitudeEvents.tutorialSkipClicked),
        ),
      ],
    ).show(context);
  }
}
