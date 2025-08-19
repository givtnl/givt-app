import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/pages/step1_select_organisation_page.dart';
import 'package:givt_app/features/recurring_donations/overview/cubit/recurring_donations_overview_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/widgets/recurring_donations_empty_state.dart';
import 'package:givt_app/features/recurring_donations/overview/widgets/recurring_donations_list.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class RecurringDonationsOverviewPage extends StatefulWidget {
  const RecurringDonationsOverviewPage({super.key});

  @override
  State<RecurringDonationsOverviewPage> createState() =>
      _RecurringDonationsOverviewPageState();
}

class _RecurringDonationsOverviewPageState
    extends State<RecurringDonationsOverviewPage> {
  late final RecurringDonationsOverviewCubit _cubit;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<RecurringDonationsOverviewCubit>();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _cubit.onTabChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return FunScaffold(
      canPop: false,
      appBar: FunTopAppBar.white(
        title: locals.menuItemRecurringDonation,
        leading: GivtBackButtonFlat(
          onPressed: () async => {
            Navigator.of(context).popUntil((route) => route.isFirst),
          },
        ),
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onCustom: (context, custom) {
          switch (custom) {
            case NavigateToAddRecurringDonation():
              // Navigate to add recurring donation flow
              Navigator.of(context).push(
                const Step1SelectOrganisationPage().toRoute(context),
              );
          }
        },
        onData: (context, uiModel) {
          if (uiModel.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: FamilyAppTheme.error80,
                  ),
                  const SizedBox(height: 16),
                  TitleMediumText(
                    locals.somethingWentWrong,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  BodyMediumText.opacityBlack50(
                    uiModel.error ?? '',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              FunPrimaryTabs(
                margin: EdgeInsets.zero,
                options: ['Current', 'Past'],
                selectedIndex: _selectedTabIndex,
                onPressed: _onTabChanged,
                analyticsEvent: AnalyticsEvent(
                  AmplitudeEvents.recurringDonationsTabsChanged,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: _selectedTabIndex == 0
                    ? _buildCurrentTab(uiModel, locals)
                    : _buildPastTab(uiModel, locals),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FunButton(
        onTap: () => _cubit.onAddRecurringDonationPressed(),
        text: 'Add recurring donation',
        leftIcon: Icons.add,
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.recurringDonationsAddClicked,
        ),
      ),
    );
  }

  Widget _buildCurrentTab(
    RecurringDonationsOverviewUIModel uiModel,
    dynamic locals,
  ) {
    if (!uiModel.hasCurrentDonations) {
      return const RecurringDonationsEmptyState();
    }

    return RecurringDonationsList(
      donations: uiModel.currentDonations,
      isCurrentTab: true,
    );
  }

  Widget _buildPastTab(
    RecurringDonationsOverviewUIModel uiModel,
    dynamic locals,
  ) {
    if (!uiModel.hasPastDonations) {
      return const RecurringDonationsEmptyState();
    }

    return RecurringDonationsList(
      donations: uiModel.pastDonations,
      isCurrentTab: false,
    );
  }
}
