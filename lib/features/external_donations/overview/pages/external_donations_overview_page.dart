import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/external_donations/create/pages/step1_organisation_page.dart';
import 'package:givt_app/features/external_donations/overview/cubit/external_donations_overview_cubit.dart';
import 'package:givt_app/features/external_donations/overview/widgets/external_donations_empty_state.dart';
import 'package:givt_app/features/external_donations/overview/widgets/external_donations_list.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';

class ExternalDonationsOverviewPage extends StatefulWidget {
  const ExternalDonationsOverviewPage({super.key});

  @override
  State<ExternalDonationsOverviewPage> createState() =>
      _ExternalDonationsOverviewPageState();
}

class _ExternalDonationsOverviewPageState
    extends State<ExternalDonationsOverviewPage> {
  late final ExternalDonationsOverviewCubit _cubit;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ExternalDonationsOverviewCubit>();
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
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return FunScaffold(
      canPop: false,
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: locals.menuItemExternalDonations,
        leading: GivtBackButtonFlat(
          onPressed: () async => {
            Navigator.of(context).popUntil((route) => route.isFirst),
          },
        ),
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onData: (context, uiModel) {
          if (uiModel.isEmpty) {
            return const ExternalDonationsEmptyState();
          }

          return Column(
            children: [
              FunPrimaryTabs(
                margin: EdgeInsets.zero,
                options: [
                  locals.externalDonationsOverviewTabCurrent,
                  locals.externalDonationsOverviewTabPast,
                ],
                selectedIndex: _selectedTabIndex,
                onPressed: _onTabChanged,
                analyticsEvent:
                    AnalyticsEventName.externalDonationsTabsChanged.toEvent(),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: _selectedTabIndex == 0
                    ? _buildCurrentTab(uiModel)
                    : _buildPastTab(uiModel),
              ),
            ],
          );
        },
        onError: (context, error) {
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
                  error ?? '',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FunButton(
                  onTap: _cubit.refresh,
                  text: locals.tryAgain,
                  analyticsEvent:
                      AnalyticsEventName.retryClicked.toEvent(),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FunButton(
        onTap: () {
          Navigator.of(context).push(
            const Step1OrganisationPage().toRoute(context),
          );
        },
        text: locals.externalDonationsOverviewAddButton,
        leftIcon: Icons.add,
        analyticsEvent: AnalyticsEventName.externalDonationsAddClicked.toEvent(),
      ),
    );
  }

  Widget _buildCurrentTab(ExternalDonationsOverviewUIModel uiModel) {
    if (!uiModel.hasCurrentDonations) {
      return const ExternalDonationsEmptyState();
    }

    return ExternalDonationsList(
      donations: uiModel.currentDonations,
      onDonationUpdated: _cubit.refresh,
    );
  }

  Widget _buildPastTab(ExternalDonationsOverviewUIModel uiModel) {
    if (!uiModel.hasPastDonations) {
      return const ExternalDonationsEmptyState();
    }

    return ExternalDonationsList(
      donations: uiModel.pastDonations,
      onDonationUpdated: _cubit.refresh,
    );
  }
}
