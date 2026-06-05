import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/cubit/collectgroup_details_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/screens/choose_amount_slider_screen.dart';
import 'package:givt_app/features/family/features/giving_flow/screens/success_screen.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/reflect/bloc/grateful_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/gather_around_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_loading.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/recommendations_widget.dart';
import 'package:givt_app/features/family/features/topup/screens/empty_wallet_bottom_sheet.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class GratefulScreen extends StatefulWidget {
  const GratefulScreen({super.key});

  @override
  State<GratefulScreen> createState() => _GratefulScreenState();
}

class _GratefulScreenState extends State<GratefulScreen> {
  final GratefulCubit _cubit = getIt<GratefulCubit>();
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onCustom: _handleCustom,
      onLoading: (context) => const GratefulLoading(),
      onData: (context, uiModel) {
        if (_currentIndex >=
            uiModel.recommendationsUIModel.organisations.length) {
          _currentIndex = 0;
        }
        return FunScaffold(
          canPop: false,
          minimumPadding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
          appBar: const FunTopAppBar(
            title: 'Generosity time',
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      AvatarBar(
                        backgroundColor: FunTheme.of(context).primary99,
                        uiModel: uiModel.avatarBarUIModel,
                        onAvatarTapped: _cubit.onAvatarTapped,
                        circleSize: 50,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                        ),
                        child: TitleMediumText(
                          '${uiModel.recommendationsUIModel.name} would you like to Help or Give?',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: FunPrimaryTabs(
                          selectedIndex:
                              uiModel.recommendationsUIModel.tabIndex,
                          onPressed: _cubit.onSelectionChanged,
                          options: _cubit.tabsOptions,
                          analyticsEvent: AnalyticsEventName
                              .recommendationTypeSelectorClicked
                              .toEvent(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      RecommendationsWidget(
                        uiModel: uiModel.recommendationsUIModel,
                        onRecommendationChosen: _cubit.onRecommendationChosen,
                        onTapRetry: _cubit.onRetry,
                        onSkip: _cubit.onSkip,
                        onIndexChanged: (index) {
                          _currentIndex = index;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (!uiModel.recommendationsUIModel.isNotLoggedInParent ||
                  uiModel.recommendationsUIModel.isShowingActsOfService)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: FunButton(
                    onTap: () => _cubit.onRecommendationChosen(_currentIndex),
                    text: uiModel.recommendationsUIModel.isShowingActsOfService
                        ? "I'm going to do this"
                        : 'Give',
                    analyticsEvent:
                        AnalyticsEventName.newActOfGenerosityClicked.toEvent(
                      parameters: {
                        uiModel.recommendationsUIModel.isShowingActsOfService
                                ? 'act_of_service'
                                : 'donation':
                            uiModel.recommendationsUIModel.organisations
                                .elementAtOrNull(_currentIndex)
                                ?.name,
                        AnalyticsHelper.firstNameKey:
                            uiModel.recommendationsUIModel.name,
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              FunTextButton(
                onTap: _cubit.onSkip,
                text: 'Skip this time',
                analyticsEvent:
                    AnalyticsEventName.skipGenerosActPressed.toEvent(
                  parameters: {
                    AnalyticsHelper.firstNameKey:
                        uiModel.recommendationsUIModel.name,
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _handleCustom(BuildContext context, GratefulCustom custom) {
    switch (custom) {
      case final GratefulOpenKidDonationFlow data:
        _navigateToChildGivingScreen(
          context,
          data.profile,
          data.organisation,
        );
      case final GratefulOpenActOfServiceSuccess data:
        _navigateToSuccess(
          context,
          data.profile,
          data.organisation,
        );
      case GratefulGoToGatherAround():
        _navigateToGatherAround(context);
      case ScrollToTop():
        _scrollToTop();
      case ShowDoneOverlay():
        _showDoneOverlay(context);
      case ShowSkippedOverlay():
        _showSkippedOverlay(context);
    }
  }

  Future<void> _navigateToChildGivingScreen(
    BuildContext context,
    GameProfile profile,
    Organisation organisation,
  ) async {
    final generatedMediumId = base64.encode(organisation.namespace.codeUnits);
    await context.read<CollectGroupDetailsCubit>().getOrganisationDetails(
          generatedMediumId,
          experiencePoints: organisation.experiencePoints,
        );
    final profiles = context.read<ProfilesCubit>();
    profiles.setActiveProfile(profile.userId);
    if (mounted && profiles.state.activeProfile.wallet.balance == 0) {
      EmptyWalletBottomSheet.show(context, () {
        context.pop();
        _pushChooseAmountSliderScreen(context, profile);
      });
      return;
    }
    await _pushChooseAmountSliderScreen(context, profile);
  }

  Future<void> _pushChooseAmountSliderScreen(
    BuildContext context,
    GameProfile profile,
  ) async {
    await Navigator.of(context).push(
      BlocProvider(
        create: (BuildContext context) => CreateTransactionCubit(
          context.read<ProfilesCubit>(),
          getIt(),
          getIt(),
        ),
        child: ChooseAmountSliderScreen(
          onCustomSuccess: () {
            _cubit.onDeed(profile);
            context.pop();
          },
          isActOfService: true,
        ),
      ).toRoute(context),
    );
  }

  Future<void> _navigateToSuccess(
    BuildContext context,
    GameProfile profile,
    Organisation org,
  ) async {
    _cubit.saveActOfService(org);
    await Navigator.push(
      context,
      SuccessScreen(
        experiencePoints: org.experiencePoints,
        isActOfService: true,
        onCustomSuccess: () {
          _cubit.onDeed(profile);
          Navigator.pop(context);
        },
      ).toRoute(context),
    );
  }

  void _navigateToGatherAround(BuildContext context) {
    Navigator.of(context).push(const GatherAroundScreen().toRoute(context));
  }

  void _showDoneOverlay(BuildContext context) {
    FunModal(
      autoClose: const Duration(milliseconds: 1500),
      icon: FunIcon.checkmark(),
      title: context.l10n.buttonDone,
      closeAction: () {
        context.pop();
      },
    ).show(context);
  }

  void _showSkippedOverlay(BuildContext context) {
    FunModal(
      autoClose: const Duration(milliseconds: 1500),
      icon: FunIcon.checkmark(),
      title: 'Skipped',
      closeAction: () {
        context.pop();
      },
    ).show(context);
  }
}
