import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/auth/presentation/models/family_auth_state.dart';
import 'package:givt_app/features/family/features/home_screen/cubit/family_home_screen_cubit.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/family_home_screen.uimodel.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/family_home_screen_custom.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/pages/family_home_overlay.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/daily_experience_container.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/give_button.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/gratitude_game_button.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/missions_container.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/stats_container.dart';
import 'package:givt_app/features/family/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_bar.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/content/pager_dot_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/content/tutorial/fun_tooltip.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/profile_type.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class FamilyHomeScreen extends StatefulWidget {
  const FamilyHomeScreen({required this.tooltipController, super.key});

  final TooltipController tooltipController;

  @override
  State<FamilyHomeScreen> createState() => _FamilyHomeScreenState();
}

class _FamilyHomeScreenState extends State<FamilyHomeScreen> {
  OverlayEntry? overlayEntry;
  bool overlayVisible = false;
  final _cubit = getIt<FamilyHomeScreenCubit>();
  final CarouselSliderController _carouselSliderController =
      CarouselSliderController();

  int _carrouselIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<ProfilesCubit>().fetchAllProfiles();
    _cubit.init();
  }

  @override
  void dispose() {
    if (overlayEntry != null && overlayEntry!.mounted) {
      closeOverlay();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onCustom: (context, custom) {
        switch (custom) {
          case final SlideCarouselTo event:
            _carouselSliderController.jumpToPage(event.carrouselIndex);
          case final OpenAvatarOverlay event:
            _openAvatarOverlay(
              context,
              event.uiModel,
              withTutorial: event.withTutorial,
            );
          case StartTutorial():
            widget.tooltipController.start();
        }
      },
      onData: (context, uiModel) {
        final hasMissions =
            uiModel.missionStats?.missionsToBeCompleted != null &&
                uiModel.missionStats!.missionsToBeCompleted > 0;
        final carrouselItems = _buildCarouselItems(uiModel, hasMissions);
        return FunScaffold(
          canPop: !overlayVisible,
          onPopInvokedWithResult: (didPop, _) {
            if (overlayVisible) {
              closeOverlay();
            }
          },
          minimumPadding: EdgeInsets.zero,
          appBar: const FunTopAppBar(title: null),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ColoredBox(
                      color: FamilyAppTheme.primary99,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: TitleLargeText(
                              overlayVisible
                                  ? ''
                                  : uiModel.familyGroupName == null
                                  ? 'Welcome!'
                                  : 'Hey ${uiModel.familyGroupName}!',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SvgPicture.asset(
                            'assets/family/images/home_screen/new_background.svg',
                            width: MediaQuery.of(context).size.width,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 36),
                        Visibility(
                          visible: !overlayVisible,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: AvatarBar(
                            circleSize: 58,
                            uiModel: AvatarBarUIModel(
                              avatarUIModels: uiModel.avatars,
                            ),
                            onAvatarTapped: onAvatarTapped,
                          ),
                        ),
                        const DailyExperienceContainer(
                          key: ValueKey('Homepage-Daily-Experience'),
                        ),
                        CarouselSlider(
                          carouselController: _carouselSliderController,
                          items: carrouselItems,
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              setState(() {
                                _carrouselIndex = index;
                              });
                            },
                            viewportFraction: 1,
                            height: 150,
                          ),
                        ),
                        if (carrouselItems.length > 1)
                          const SizedBox(height: 8),
                        if (carrouselItems.length > 1)
                          PagerDotIndicator(
                            count: carrouselItems.length,
                            index: _carrouselIndex,
                          ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      FunTooltip(
                        tooltipIndex: 2,
                        title: 'Gratitude Game',
                        description:
                            'This game helps you to build gratitude by reflecting on your day as a family',
                        labelBottomLeft: '3/6',
                        child: GratitudeGameButton(
                          onPressed: () =>
                              context.goNamed(FamilyPages.reflectIntro.name),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GiveButton(
                        onPressed: () => _openAvatarOverlay(context, uiModel),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openAvatarOverlay(BuildContext context, FamilyHomeScreenUIModel uiModel,
      {bool withTutorial = false}) {
    if (!overlayVisible) {
      createOverlay(uiModel, withTutorial: withTutorial);
      setState(() {
        overlayVisible = true;
      });
      Overlay.of(context).insert(overlayEntry!);
    }
  }

  void createOverlay(FamilyHomeScreenUIModel uiModel,
      {required bool withTutorial}) {
    overlayEntry = OverlayEntry(
      builder: (context) => FamilyHomeOverlay(
        uiModel: uiModel,
        onDismiss: closeOverlay,
        onAvatarTapped: onAvatarTapped,
        onNextTutorialClicked: _cubit.onNextTutorialClicked,
        withTutorial: withTutorial,
      ),
    );
  }

  Future<void> onAvatarTapped(int index) async {
    if (overlayVisible) {
      closeOverlay();
    }

    final profile = _cubit.profiles[index];

    unawaited(
      context.read<ProfilesCubit>().setActiveProfile(
            profile.id,
          ),
    );

    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.profilePressed,
        eventProperties: {
          'profile_id': profile.id,
          'profile_name': profile.firstName,
        },
      ),
    );

    context.read<ImpactGroupsCubit>().fetchImpactGroups(profile.id, true);

    if (profile.profileType == ProfileType.Parent) {
      final authstate = context.read<FamilyAuthCubit>().state;
      if (authstate is Unauthenticated ||
          profile.id != (authstate as Authenticated).user.guid) {
        return;
      }

      await FamilyAuthUtils.authenticateUser(
        context,
        checkAuthRequest: FamilyCheckAuthRequest(
          navigate: (context) async {
            await context.pushNamed(
              FamilyPages.parentHome.name,
              extra: profile,
            );
            await AnalyticsHelper.setUserProperties(
              userId: profile.id,
            );
          },
        ),
      );
    } else {
      context.goNamed(
        FamilyPages.wallet.name,
        extra: profile,
      );
    }
  }

  void closeOverlay() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;

    setState(() {
      overlayVisible = false;
    });
  }

  List<Widget> _buildCarouselItems(
    FamilyHomeScreenUIModel uiModel,
    bool hasMissions,
  ) {
    final items = [
      FunTooltip(
        tooltipIndex: 3,
        title: 'Let’s complete your first mission!',
        description:
            'New missions help your family grow together. Tap above to begin!',
        labelBottomLeft: '4/6',
        showButton: false,
        tooltipVerticalPosition: TooltipVerticalPosition.BOTTOM,
        onHighlightedWidgetTap: () {
          widget.tooltipController.dismiss();
          context.goNamed(
            FamilyPages.missions.name,
            extra: {
              'showTutorial': true,
            },
          );
        },
        child: MissionsContainer(uiModel.missionStats),
      ),
      StatsContainer(uiModel.gameStats),
    ];

    // If there are no missions, move the stats container to the first position
    if (!hasMissions) {
      items.insert(0, items.removeAt(1));
    }

    return items;
  }
}
