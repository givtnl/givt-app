import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
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
import 'package:givt_app/features/family/features/reflect/presentation/widgets/finish_reflection_dialog.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_loading.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/leave_game_button.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/recommendations_widget.dart';
import 'package:givt_app/features/family/features/topup/screens/empty_wallet_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_bar.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
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
          return FunScaffold(
            canPop: false,
            withSafeArea: false,
            minimumPadding: EdgeInsets.zero,
            appBar: FunTopAppBar(
              title: 'Share your gratitude',
              actions: [
                LeaveGameButton(
                  onPressed: () => const FinishReflectionDialog().show(context),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  children: [
                    AvatarBar(
                      backgroundColor: FamilyAppTheme.primary99,
                      uiModel: uiModel.avatarBarUIModel,
                      onAvatarTapped: _cubit.onAvatarTapped,
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: TitleMediumText(
                        '${uiModel.recommendationsUIModel.name} you were grateful for ${uiModel.recommendationsUIModel.category!.displayText.toLowerCase()}, here are some ways to help',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: FunTabs(
                        selections: [
                          uiModel.recommendationsUIModel.showActsOfService,
                          !uiModel.recommendationsUIModel.showActsOfService,
                        ],
                        onPressed: _cubit.onSelectionChanged,
                        firstOption: 'Acts of Service',
                        secondOption: 'Give',
                        analyticsEvent: AnalyticsEvent(
                          AmplitudeEvents.recommendationTypeSelectorClicked,
                          parameters: {
                            'currentSelection':
                                uiModel.recommendationsUIModel.showActsOfService
                                    ? 'Acts of Service'
                                    : 'Give',
                          },
                        ),
                      ),
                    ),
                    RecommendationsWidget(
                      uiModel: uiModel.recommendationsUIModel,
                      onRecommendationChosen: (int i) {
                        _cubit.onRecommendationChosen(i);
                        context.pop();
                      },
                      onTapRetry: _cubit.onRetry,
                    ),
                    // todo KIDS-1763 add action buttons
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleCustom(BuildContext context, GratefulCustom custom) {
    switch (custom) {
      case final GratefulOpenKidDonationFlow data:
        _navigateToChildGivingScreen(
          context,
          data.profile,
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
    }
  }

  Future<void> _navigateToChildGivingScreen(
    BuildContext context,
    GameProfile profile,
  ) async {
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
        colorCombo:
            CollectGroupType.getColorComboByType(CollectGroupType.charities),
        icon: CollectGroupType.getIconByTypeUS(CollectGroupType.charities),
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
}
