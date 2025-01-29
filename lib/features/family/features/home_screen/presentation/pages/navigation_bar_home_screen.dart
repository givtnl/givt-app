import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/notification/notification_service.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/account/presentation/pages/us_personal_info_edit_page.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/auth/presentation/models/family_auth_state.dart';
import 'package:givt_app/features/family/features/game_summary/presentation/pages/game_summaries_screen.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/navigation_bar_home_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_custom.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_screen_uimodel.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/pages/family_home_screen.dart';
import 'package:givt_app/features/family/features/impact_groups/widgets/dialogs/impact_group_recieve_invite_sheet.dart';
import 'package:givt_app/features/family/features/missions/domain/entities/mission.dart';
import 'package:givt_app/features/family/features/missions/domain/repositories/mission_repository.dart';
import 'package:givt_app/features/family/features/overview/pages/family_overview_page.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/content/triangle_painter.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/reward_banner_dialog.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/features/internet_connection/internet_connection_cubit.dart';
import 'package:givt_app/shared/dialogs/internet_connection_lost_dialog.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/buttons/custom_icon_border_button.dart';
import 'package:givt_app/shared/widgets/theme/app_theme_switcher.dart';
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

  bool _switchMaskColor = false;
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
        'destination': 'Family',
      },
    ),
    AnalyticsEvent(
      AmplitudeEvents.navigationBarPressed,
      parameters: {
        'destination': 'Memories',
      },
    ),
    AnalyticsEvent(
      AmplitudeEvents.navigationBarPressed,
      parameters: {
        'destination': 'Profile',
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return OverlayTooltipScaffold(
      controller: _tooltipController,
      preferredOverlay: GestureDetector(
        onTap: () {
          if (_tooltipController.nextPlayIndex !=
              _tooltipController.playWidgetLength - 1) {
            if (_tooltipController.nextPlayIndex == 0) {
              setState(() {
                _switchMaskColor = true;
              });
            }
            _tooltipController.next();
          } else {
            setState(() {
              _switchMaskColor = false;
            });
            _tooltipController.dismiss();
          }
        },
        child: Container(
          color: FamilyAppTheme.primary50.withOpacity(0.5),
        ),
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
          NavigationDestination(
            icon: OverlayTooltipItem(
              displayIndex: 1,
              tooltipHorizontalPosition: TooltipHorizontalPosition.CENTER,
              tooltipVerticalPosition: TooltipVerticalPosition.TOP,
              tooltip: (TooltipController controller) {
                final width = MediaQuery.of(context).size.width;
                final onePart =
                    width / NavigationBarHomeScreen.validIndexes.length;
                final halfPart = onePart / 2;
                const horizontalPadding = 24.0;
                const triangleHeight = 23.0;
                return Tooltip(
                  message: 'Play the Gratitude Game',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 12,
                    ),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: width - (horizontalPadding * 2),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TitleSmallText(
                                          'Managing your family',
                                          color: FamilyAppTheme.secondary30,
                                          textAlign: TextAlign.start,
                                        ),
                                        BodySmallText(
                                          'Encourage your heroes by topping up wallets and approving donations.',
                                          color: FamilyAppTheme.secondary30,
                                        ),
                                        SizedBox(height: 12),
                                        LabelMediumText(
                                          '2/6',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomPaint(
                              painter: TrianglePainter(
                                strokeColor: Colors.white,
                                paintingStyle: PaintingStyle.fill,
                                offset: Offset(
                                  -halfPart,
                                  0,
                                ), //we start at the center so we only need to substract half a part
                              ),
                              child: const SizedBox(
                                height: triangleHeight,
                                width: 18,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 12+triangleHeight,
                              right: 16,
                            ),
                            child: CustomIconBorderButton(
                              onTap: () {},
                              analyticsEvent: AnalyticsEvent(
                                  AmplitudeEvents.accountLocked),
                              child: const FaIcon(
                                FontAwesomeIcons.arrowRight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: FaIcon(
                FontAwesomeIcons.mask,
                color:
                    _switchMaskColor ? Colors.white : FamilyAppTheme.primary20,
              ),
            ),
            label: 'Family',
          ),
          const NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.solidCalendar),
            label: 'Memories',
          ),
          NavigationDestination(
            icon: uiModel?.profilePictureUrl == null
                ? const FaIcon(FontAwesomeIcons.person)
                : SizedBox(
                    width: 28,
                    height: 28,
                    child: SvgPicture.network(uiModel!.profilePictureUrl!),
                  ),
            label: 'Profile',
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
            FamilyHomeScreen(
              tooltipController: _tooltipController,
            ),
            const FamilyOverviewPage(),
            const GameSummariesScreen(),
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
    if (index == NavigationBarHomeScreen.homeIndex ||
        index == NavigationBarHomeScreen.memoriesIndex) {
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
        barrierColor: Theme.of(context).colorScheme.primary.withOpacity(.25),
        builder: (context) =>
            MissionCompletedBannerDialog(missionName: mission.title),
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
    }
  }
}
