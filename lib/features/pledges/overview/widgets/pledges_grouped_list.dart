import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/pledges/detail/pages/pledge_detail_page.dart';
import 'package:givt_app/features/pledges/overview/cubit/pledges_overview_cubit.dart';
import 'package:givt_app/features/pledges/overview/widgets/pledge_group_header.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/features/pledges/shared/pledge_display.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';

class PledgesGroupedList extends StatelessWidget {
  const PledgesGroupedList({
    required this.groups,
    super.key,
  });

  final List<PledgeGroupSection> groups;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 98),
      itemCount: groups.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final section = groups[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PledgeGroupHeader(section: section),
            const SizedBox(height: 16),
            ...section.cards.map((card) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _PledgeGroupCard(card: card),
              );
            }),
          ],
        );
      },
    );
  }
}

class _PledgeGroupCard extends StatelessWidget {
  const _PledgeGroupCard({required this.card});

  final PledgeOverviewCard card;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final auth = context.read<AuthCubit>().state;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        title: PledgeDisplay.buildGroupCardTitle(card),
        description: PledgeDisplay.buildGroupCardSubtitle(
          locals: locals,
          card: card,
          countryCode: auth.user.country,
          locale: locale,
        ),
        progress: PledgeDisplay.buildGroupCardProgress(
          card: card,
          countryCode: auth.user.country,
        ),
      ),
      useFunProgressbar: true,
      onTap: () => Navigator.of(context).push(
        PledgeDetailPage(pledgeGroupId: card.pledgeGroupId).toRoute(context),
      ),
      analyticsEvent: AnalyticsEventName.pledgesOverviewCardClicked.toEvent(
        parameters: {
          'pledge_group_id': card.pledgeGroupId,
          'collect_group': card.collectGroup.name,
          'goal_count': card.pledges.length,
        },
      ),
    );
  }
}
