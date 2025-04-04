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
import 'package:givt_app/features/family/features/home_screen/widgets/give_button.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/gratitude_game_button.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/gratitude_goal_container.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/missions_container.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/stats_container.dart';
import 'package:givt_app/features/family/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/models/features.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_bar.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/content/pager_dot_indicator.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/content/tutorial/fun_tooltip.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/fun_dialog.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/models/fun_dialog_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';
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
              withRewardText: event.withRewardText,
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
          appBar: const FunTopAppBar(
            title: null,
            overridePreferredSize: Size.zero,
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ColoredBox(
                      color: FamilyAppTheme.primary99,
                      child: Column(
                        children: [
                          SizedBox(
                            height: kToolbarHeight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Semantics(
                                  container: true,
                                  label: 'gear',
                                  identifier: 'gear_icon',
                                  child: GestureDetector(
                                    onTap: () {
                                      FamilyAuthUtils.authenticateUser(
                                        context,
                                        checkAuthRequest:
                                            FamilyCheckAuthRequest(
                                          navigate: (context) async {
                                            context.goNamed(
                                              FamilyPages
                                                  .familyPersonalInfoEdit.name,
                                            );
                                          },
                                        ),
                                      );
                                      AnalyticsHelper.logEvent(
                                        eventName:
                                            AmplitudeEvents.homeSettingsClicked,
                                      );
                                    },
                                    child: FunIcon.gear(),
                                  ),
                                ),
                                const SizedBox(width: 24),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: TitleLargeText(
                              overlayVisible
                                  ? ''
                                  : uiModel.familyGroupName == null
                                      ? context.l10n.homeScreenWelcome
                                      : context.l10n.homeScreenHeyFamily(
                                          uiModel.familyGroupName!,
                                        ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SvgPicture.asset(
                            'assets/family/images/home_screen/background.svg',
                            width: MediaQuery.of(context).size.width,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: kToolbarHeight),
                        const SizedBox(height: 36),
                        Visibility(
                          visible: !overlayVisible,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: AvatarBar(
                            featureId: Features.familyHomeProfile,
                            circleSize: 58,
                            uiModel: AvatarBarUIModel(
                              avatarUIModels: uiModel.avatars,
                            ),
                            onAvatarTapped: (index) =>
                                onAvatarTapped(index, uiModel),
                          ),
                        ),
                        const GratitudeGoalContainer(
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
                        if (carrouselItems.length > 1) ...[
                          const SizedBox(height: 8),
                          PagerDotIndicator(
                            count: carrouselItems.length,
                            index: _carrouselIndex,
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          child: Column(
                            children: [
                              FunTooltip(
                                tooltipIndex: 2,
                                title: context.l10n.homeScreenGratitudeGameButtonTitle,
                                description:
                                    context.l10n.homeScreenGratitudeGameButtonDescription,
                                labelBottomLeft: '3/6',
                                child: GratitudeGameButton(
                                  onPressed: () => context
                                      .goNamed(FamilyPages.reflectIntro.name),
                                ),
                              ),
                              const SizedBox(height: 16),
                              GiveButton(
                                onPressed: () =>
                                    _openAvatarOverlay(context, uiModel),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openAvatarOverlay(
    BuildContext context,
    FamilyHomeScreenUIModel uiModel, {
    bool withTutorial = false,
    bool withRewardText = false,
  }) {
    if (!overlayVisible) {
      createOverlay(
        uiModel,
        withTutorial: withTutorial,
        withRewardText: withRewardText,
      );
      setState(() {
        overlayVisible = true;
      });
      Overlay.of(context).insert(overlayEntry!);
    }
  }

  void createOverlay(
    FamilyHomeScreenUIModel uiModel, {
    required bool withTutorial,
    required bool withRewardText,
  }) {
    overlayEntry = OverlayEntry(
      builder: (context) => FamilyHomeOverlay(
        uiModel: uiModel,
        onDismiss: closeOverlay,
        onAvatarTapped: (index) => onAvatarTapped(index, uiModel),
        onNextTutorialClicked: _cubit.onNextTutorialClicked,
        withTutorial: withTutorial,
        withRewardText: withRewardText,
      ),
    );
  }

  Future<void> onAvatarTapped(
      int index, FamilyHomeScreenUIModel uiModel) async {
    if (overlayVisible) {
      closeOverlay();
    }

    final id = uiModel.avatars[index].guid ?? _cubit.profiles[index].id;
    final profile = _cubit.profiles.firstWhere(
      (element) => element.id == id,
    );
    context.read<ProfilesCubit>().setActiveProfile(
          profile.id,
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
        _cubit.markAllFeaturesAsSeen(profile.id);
        _showSecondParentDialog(context, profile);
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

  void _showSecondParentDialog(BuildContext context, Profile profile) {
    FunDialog.show(
      context,
      uiModel: FunDialogUIModel(
        title: '${profile.firstName} needs to use their own account',
        description: 'Use the Givt App on your own device',
        primaryButtonText: 'Got it',
        showCloseButton: false,
      ),
      image: FunIcon.userLarge(),
    );
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
    const title = 'Let’s complete your first mission!';
    const description =
        'New missions help your family grow together. Tap above to begin!';

    final items = [
      FunTooltip(
        tooltipIndex: 3,
        title: title,
        description: description,
        labelBottomLeft: '4/6',
        showButton: false,
        tooltipVerticalPosition: TooltipVerticalPosition.BOTTOM,
        onHighlightedWidgetTap: () {
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.tutorialNextClicked,
            eventProperties: {
              'tutorialLabelBottomLeft': '4/6',
              'tutorialTitle': title,
              'tutorialDescription': description,
            },
          );

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
