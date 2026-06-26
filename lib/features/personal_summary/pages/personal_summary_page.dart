import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/external_donations/create/pages/step1_organisation_page.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';
import 'package:givt_app/features/personal_summary/cubit/personal_summary_cubit.dart';
import 'package:givt_app/features/personal_summary/models/models.dart';
import 'package:givt_app/features/personal_summary/widgets/category_donut_chart.dart';
import 'package:givt_app/features/personal_summary/widgets/giving_goal_card.dart';
import 'package:givt_app/features/personal_summary/widgets/monthly_category_bar_chart.dart';
import 'package:givt_app/features/personal_summary/giving_goal_setup/models/giving_goal_setup_extra.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_sheets.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_sticky_actions.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_year_header.dart';
import 'package:givt_app/features/personal_summary/widgets/split_bar_chart.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/giving_goal.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class PersonalSummaryPage extends StatefulWidget {
  const PersonalSummaryPage({super.key});

  @override
  State<PersonalSummaryPage> createState() => _PersonalSummaryPageState();
}

class _PersonalSummaryPageState extends State<PersonalSummaryPage> {
  late final PersonalSummaryCubit _cubit;
  late final Country _country;
  PersonalSummaryUIModel? _uiModel;
  int? _lastLoggedYear;

  @override
  void initState() {
    super.initState();
    _country = Country.fromCode(context.read<AuthCubit>().state.user.country);
    _cubit = getIt<PersonalSummaryCubit>();
    unawaited(_cubit.init());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer<PersonalSummaryUIModel, PersonalSummaryCustom>(
      cubit: _cubit,
      onCustom: _handleCustom,
      onData: _buildContent,
      onLoading: (_) => _buildLoadingScaffold(),
      onError: _buildErrorScaffold,
    );
  }

  void _handleCustom(BuildContext context, PersonalSummaryCustom custom) {
    switch (custom) {
      case ShowAddDonationSheet():
        AddDonationBottomSheet.show(
          context,
          onGiveThroughGivt: () => unawaited(
            _navigateToForYouAndRefresh(context),
          ),
          onAddExternalDonation: () => unawaited(
            _navigateToExternalDonationAndRefresh(context),
          ),
        );
      case NavigateToGivingGoalSetup():
        unawaited(_navigateToGivingGoalSetup(context));
      case NavigateToForYouList():
        unawaited(_navigateToForYouAndRefresh(context));
      case NavigateToExternalDonationCreate():
        unawaited(_navigateToExternalDonationAndRefresh(context));
      case PersonalSummaryGoalSaved():
        break;
      case PersonalSummaryGoalMutationFailed(
        :final isNoInternet,
        :final message,
      ):
        SnackBarHelper.showMessage(
          context,
          text: isNoInternet
              ? context.l10n.noInternet
              : (message ?? context.l10n.somethingWentWrong),
          isError: true,
        );
    }
  }

  Future<void> _navigateToGivingGoalSetup(BuildContext context) async {
    final goal = _uiModel?.givingGoal ?? const GivingGoal.empty();
    await context.pushNamed(
      Pages.givingGoalSetup.name,
      extra: GivingGoalSetupExtra(
        initialYearlyAmount:
            goal.hasGoal ? goal.yearlyGivingGoal.round() : 0,
        goalId: goal.id,
      ),
    );
    if (context.mounted) {
      await _cubit.refreshGivingGoal();
    }
  }

  Future<void> _navigateToForYouAndRefresh(BuildContext context) async {
    await context.pushNamed(
      Pages.forYouList.name,
      extra: const ForYouFlowContext(source: ForYouEntrySource.search),
    );
    if (context.mounted) {
      await _cubit.refresh();
    }
  }

  Future<void> _navigateToExternalDonationAndRefresh(
    BuildContext context,
  ) async {
    await Navigator.of(context).push(
      const Step1OrganisationPage().toRoute(context),
    );
    if (context.mounted) {
      await _cubit.refresh();
    }
  }

  Widget _buildLoadingScaffold() {
    return FunScaffold(
      minimumPadding: EdgeInsets.zero,
      safeAreaBottom: false,
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: context.l10n.personalSummaryTitle,
        leading: const GivtBackButtonFlat(),
      ),
      body: const Center(child: CustomCircularProgressIndicator()),
    );
  }

  Widget _buildErrorScaffold(BuildContext context, String? message) {
    final locals = context.l10n;
    return FunScaffold(
      minimumPadding: EdgeInsets.zero,
      safeAreaBottom: false,
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: locals.personalSummaryTitle,
        leading: const GivtBackButtonFlat(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BodyMediumText(
            message == 'no_internet' ? locals.noInternet : locals.somethingWentWrong,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PersonalSummaryUIModel uiModel) {
    _uiModel = uiModel;
    final locals = context.l10n;
    final theme = FunTheme.of(context);
    final currencySymbol =
        Util.getCurrencySymbol(countryCode: _country.countryCode);
    String formatAmount(double amount) =>
        '$currencySymbol${Util.formatNumberComma(amount, _country)}';

    if (_lastLoggedYear != uiModel.selectedYear) {
      _lastLoggedYear = uiModel.selectedYear;
      unawaited(
        AnalyticsHelper.logEvent(
          eventName: AnalyticsEventName.personalSummaryYearLoaded,
          eventProperties: {
            'year': uiModel.selectedYear.toString(),
            'total_given_in_year': uiModel.yearTotal,
            'goal': uiModel.givingGoal.yearlyGivingGoal,
          },
        ),
      );
    }

    return FunScaffold(
      minimumPadding: EdgeInsets.zero,
      safeAreaBottom: false,
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: locals.personalSummaryTitle,
        leading: const GivtBackButtonFlat(),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _cubit.refresh,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                children: [
                  PersonalSummaryYearHeader(
                    year: uiModel.selectedYear,
                    canGoToPreviousYear: uiModel.canGoToPreviousYear,
                    canGoToNextYear: uiModel.canGoToNextYear,
                    onPreviousYear: _cubit.selectPreviousYear,
                    onNextYear: _cubit.selectNextYear,
                  ),
                  const SizedBox(height: 32),
                  if (uiModel.hasGivingGoal) ...[
                    GivingGoalCard(
                      year: uiModel.selectedYear,
                      yearTotal: uiModel.yearTotal,
                      goalAmount: uiModel.givingGoal.yearlyGivingGoal,
                      goalProgress: uiModel.goalProgress,
                      formattedYearTotal: formatAmount(uiModel.yearTotal),
                      formattedGoalAmount:
                          formatAmount(uiModel.givingGoal.yearlyGivingGoal),
                      onEdit: _cubit.navigateToGivingGoalSetup,
                    ),
                    const SizedBox(height: 32),
                  ],
                  CategoryDonutChart(
                    segments: uiModel.categorySegments,
                    centerAmount: formatAmount(uiModel.yearTotal),
                    formatAmount: formatAmount,
                  ),
                  const SizedBox(height: 32),
                  MonthlyCategoryBarChart(
                    rows: uiModel.monthlyRows,
                    formatAmount: formatAmount,
                  ),
                  const SizedBox(height: 32),
                  SplitBarChart(
                    title: locals.personalSummarySectionRecurring,
                    subtitle: locals.personalSummarySectionRecurringSubtitle,
                    primaryLabel: locals.personalSummaryRecurring,
                    secondaryLabel: locals.personalSummaryOneOff,
                    data: uiModel.recurringSplit,
                    primaryColor: theme.secondary30,
                    secondaryColor: theme.primary80,
                    primaryLabelColor: Colors.white,
                    secondaryLabelColor: theme.primary20,
                    primaryIconColor: theme.secondary30,
                    secondaryIconColor: theme.primary80,
                    formatAmount: formatAmount,
                  ),
                  const SizedBox(height: 32),
                  SplitBarChart(
                    title: locals.personalSummarySectionGivtVsExternal,
                    subtitle: locals.personalSummarySectionGivtVsExternalSubtitle,
                    primaryLabel: locals.personalSummaryThroughGivt,
                    secondaryLabel: locals.personalSummaryExternal,
                    data: uiModel.givtVsExternalSplit,
                    primaryColor: theme.secondary70,
                    secondaryColor: theme.neutral80,
                    primaryLabelColor: Colors.white,
                    secondaryLabelColor: theme.primary20,
                    primaryIconColor: theme.secondary70,
                    secondaryIconColor: theme.neutral80,
                    formatAmount: formatAmount,
                  ),
                ],
              ),
            ),
          ),
          PersonalSummaryStickyActions(
            hasGivingGoal: uiModel.hasGivingGoal,
            onAddDonation: _cubit.requestAddDonationSheet,
            onSetGivingGoal: _cubit.navigateToGivingGoalSetup,
          ),
        ],
      ),
    );
  }
}
