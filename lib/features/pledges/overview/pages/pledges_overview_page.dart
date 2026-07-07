import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/pledges/overview/cubit/pledges_overview_cubit.dart';
import 'package:givt_app/features/pledges/overview/widgets/pledges_empty_state.dart';
import 'package:givt_app/features/pledges/overview/widgets/pledges_grouped_list.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class PledgesOverviewPage extends StatefulWidget {
  const PledgesOverviewPage({super.key});

  @override
  State<PledgesOverviewPage> createState() => _PledgesOverviewPageState();
}

class _PledgesOverviewPageState extends State<PledgesOverviewPage> {
  late final PledgesOverviewCubit _cubit;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PledgesOverviewCubit>();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() => _selectedTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return FunScaffold(
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: locals.menuItemPledges,
        leading: const GivtBackButtonFlat(),
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onData: (context, uiModel) {
          return Column(
            children: [
              FunPrimaryTabs(
                margin: EdgeInsets.zero,
                options: [
                  locals.pledgesOverviewTabCurrent,
                  locals.pledgesOverviewTabPast,
                ],
                icons: _selectedTabIndex == 0
                    ? const [
                        FaIcon(FontAwesomeIcons.check, size: 16),
                        null,
                      ]
                    : const [null, null],
                selectedIndex: _selectedTabIndex,
                onPressed: _onTabChanged,
                analyticsEvent:
                    AnalyticsEventName.pledgesTabsChanged.toEvent(),
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
                const SizedBox(height: 24),
                FunButton(
                  onTap: _cubit.refresh,
                  text: locals.tryAgain,
                  analyticsEvent: AnalyticsEventName.retryClicked.toEvent(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentTab(PledgesOverviewUIModel uiModel) {
    if (!uiModel.hasCurrentPledges) {
      return const PledgesEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _cubit.refresh();
        unawaited(
          AnalyticsHelper.logEvent(
            eventName: AnalyticsEventName.pledgesOverviewRefreshed,
          ),
        );
      },
      child: PledgesGroupedList(groups: uiModel.currentGroups),
    );
  }

  Widget _buildPastTab(PledgesOverviewUIModel uiModel) {
    if (!uiModel.hasPastPledges) {
      return const PledgesEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _cubit.refresh();
        unawaited(
          AnalyticsHelper.logEvent(
            eventName: AnalyticsEventName.pledgesOverviewRefreshed,
          ),
        );
      },
      child: PledgesGroupedList(groups: uiModel.pastGroups),
    );
  }
}
