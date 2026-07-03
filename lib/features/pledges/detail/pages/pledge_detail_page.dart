import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/pledges/detail/cubit/pledge_detail_cubit.dart';
import 'package:givt_app/features/pledges/detail/widgets/pledge_detail_goals_section.dart';
import 'package:givt_app/features/pledges/detail/widgets/pledge_detail_history_section.dart';
import 'package:givt_app/features/pledges/detail/widgets/pledge_detail_summary_card.dart';
import 'package:givt_app/features/pledges/detail/widgets/pledge_detail_summary_tiles.dart';
import 'package:givt_app/features/pledges/manage/pages/pledge_manage_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class PledgeDetailPage extends StatefulWidget {
  const PledgeDetailPage({
    required this.pledgeGroupId,
    super.key,
  });

  final String pledgeGroupId;

  @override
  State<PledgeDetailPage> createState() => _PledgeDetailPageState();
}

class _PledgeDetailPageState extends State<PledgeDetailPage> {
  late final PledgeDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PledgeDetailCubit>();
    AnalyticsHelper.logEvent(
      eventName: AnalyticsEventName.pledgesDetailOpened,
      eventProperties: {'pledge_group_id': widget.pledgeGroupId},
    );
    _cubit.init(widget.pledgeGroupId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onData: (context, uiModel) {
        final locale = Localizations.localeOf(context).toLanguageTag();
        final auth = context.read<AuthCubit>().state;
        final countryCode = auth.user.country;

        return FunScaffold(
          appBar: FunTopAppBar(
            variant: FunTopAppBarVariant.white,
            leading: GivtBackButtonFlat(
              onPressed: () async => context.pop(),
            ),
            title: uiModel.group.pledgeGroupName,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PledgeDetailSummaryCard(
                        uiModel: uiModel,
                        countryCode: countryCode,
                      ),
                      const SizedBox(height: 24),
                      PledgeDetailSummaryTiles(
                        uiModel: uiModel,
                        countryCode: countryCode,
                        locale: locale,
                      ),
                      const SizedBox(height: 24),
                      PledgeDetailGoalsSection(
                        goalProgress: uiModel.goalProgress,
                        countryCode: countryCode,
                      ),
                      const SizedBox(height: 24),
                      PledgeDetailHistorySection(
                        history: uiModel.history,
                        countryCode: countryCode,
                        locale: locale,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              _buildBottomActions(context, uiModel),
            ],
          ),
        );
      },
      onLoading: (context) => FunScaffold(
        appBar: FunTopAppBar(
          variant: FunTopAppBarVariant.white,
          leading: GivtBackButtonFlat(
            onPressed: () async => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      onError: (context, error) {
        final locals = context.l10n;
        return FunScaffold(
          appBar: FunTopAppBar(
            variant: FunTopAppBarVariant.white,
            leading: GivtBackButtonFlat(
              onPressed: () async => context.pop(),
            ),
          ),
          body: Center(
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    PledgeDetailUIModel uiModel,
  ) {
    final locals = context.l10n;
    final campaignName = uiModel.group.pledgeGroupName;

    return Column(
      children: [
        FunButton(
          text: locals.pledgesDetailGiveButton(campaignName),
          analyticsEvent: AnalyticsEventName.pledgesDetailGiveClicked.toEvent(),
          onTap: () {},
        ),
        const SizedBox(height: 12),
        FunButton(
          text: locals.pledgesDetailEditButton,
          variant: FunButtonVariant.secondary,
          fullBorder: true,
          analyticsEvent: AnalyticsEventName.pledgesDetailEditClicked.toEvent(),
          onTap: () async {
            final didUpdate = await Navigator.of(context).push(
              PledgeManagePage(
                pledgeGroupId: widget.pledgeGroupId,
              ).toRoute(context),
            );
            if (didUpdate == true && mounted) {
              await _cubit.init(widget.pledgeGroupId);
            }
          },
        ),
      ],
    );
  }
}
