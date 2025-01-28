import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/cubit/collectgroup_details_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/cubit/create_transaction_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/screens/choose_amount_slider_screen.dart';
import 'package:givt_app/features/family/features/giving_flow/screens/success_screen.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/cubit/give_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/cubit/medium_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/parent_amount_page.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/parent_giving_page.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/reflect/bloc/grateful_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/summary_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_loading.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/recommendations_widget.dart';
import 'package:givt_app/features/family/features/topup/screens/empty_wallet_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_bar.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
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
  final _cubit = getIt<GratefulCubit>();
  final _give = getIt<GiveCubit>();
  final _medium = getIt<MediumCubit>();
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
    return BlocListener<GiveCubit, GiveState>(
      bloc: _give,
      listener: (context, state) {
        final userGUID = context.read<FamilyAuthCubit>().user!.guid;
        if (state is GiveFromBrowser) {
          // we assume the parent confirms on browser
          _handleParentBrowser(userGUID);
        }
        if (state is GiveError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.somethingWentWrong),
            ),
          );
        }
      },
      child: BaseStateConsumer(
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
                          backgroundColor: FamilyAppTheme.primary99,
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
                          child: FunTabs(
                            selectedIndex:
                                uiModel.recommendationsUIModel.tabIndex,
                            onPressed: _cubit.onSelectionChanged,
                            options: _cubit.tabsOptions,
                            analyticsEvent: AnalyticsEvent(
                              AmplitudeEvents.recommendationTypeSelectorClicked,
                            ),
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
                      text:
                          uiModel.recommendationsUIModel.isShowingActsOfService
                              ? "I'm going to do this"
                              : 'Give',
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents.newActOfGenerosityClicked,
                        parameters: {
                          uiModel.recommendationsUIModel.isShowingActsOfService
                                  ? 'act_of_service'
                                  : 'donation':
                              uiModel.recommendationsUIModel
                                  .organisations[_currentIndex].name,
                          AnalyticsHelper.firstNameKey:
                              uiModel.recommendationsUIModel.name,
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () {
                    _cubit.onSkip();
                    unawaited(
                      AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvents.skipGenerosActPressed,
                        eventProperties: {
                          AnalyticsHelper.firstNameKey:
                              uiModel.recommendationsUIModel.name,
                        },
                      ),
                    );
                  },
                  child: const LabelLargeText('Skip this time'),
                ),
              ],
            ),
          );
        },
      ),
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
      case final GratefulOpenParentDonationFlow data:
        _navigateToParentGivingScreen(
          context,
          data.organisation,
        );
      case final GratefulOpenActOfServiceSuccess data:
        _navigateToSuccess(
          context,
          data.profile,
          data.organisation,
        );
      case GratefulGoToGameSummary():
        _navigateToSummary(context);
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
    await context
        .read<CollectGroupDetailsCubit>()
        .getOrganisationDetails(generatedMediumId);
    final profiles = context.read<ProfilesCubit>();
    await profiles.setActiveProfile(profile.userId);
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
            context.read<ProfilesCubit>(), getIt(), getIt()),
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
        isActOfService: true,
        onCustomSuccess: () {
          _cubit.onDeed(profile);
          Navigator.pop(context);
        },
      ).toRoute(context),
    );
  }

  Future<void> _navigateToParentGivingScreen(
    BuildContext context,
    Organisation org,
  ) async {
    _medium.setMediumId(org.namespace);
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.parentReflectionFlowOrganisationClicked,
        eventProperties: {
          'organisation': org.name,
        },
      ),
    );
    final dynamic result = await Navigator.push(
      context,
      ParentAmountPage(
        authcheck: true,
        currency: r'$',
        organisationName: org.name,
        icon: CollectGroupType.getFunIconByType(CollectGroupType.charities),
      ).toRoute(context),
    );
    if (result != null && result is int && context.mounted) {
      unawaited(
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.parentGiveWithAmountClicked,
          eventProperties: {
            'amount': result,
            'organisation': org.name,
            'mediumid': org.namespace,
          },
        ),
      );
      await _give.createTransaction(
        userId: context.read<FamilyAuthCubit>().user!.guid,
        amount: result,
        isGratitude: true,
        orgName: org.name,
        mediumId: org.namespace,
      );

      await Navigator.push(
        context,
        const FullScreenLoadingWidget(
          text: 'Setting up your donation',
        ).toRoute(context),
      );
    }
  }

  Future<void> _handleParentBrowser(String guid) async {
    final dynamic result = await Navigator.pushReplacement(
      context,
      const ParentGivingPage().toRoute(context),
    );
    if (result != null && result == true && context.mounted) {
      await _cubit.onParentDonated(guid);
    }
  }

  void _navigateToSummary(BuildContext context) {
    Navigator.of(context).push(const SummaryScreen().toRoute(context));
  }

  void _showDoneOverlay(BuildContext context) {
    FunModal(
      autoClose: const Duration(milliseconds: 1500),
      icon: FunIcon.checkmark(),
      title: 'Done',
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
