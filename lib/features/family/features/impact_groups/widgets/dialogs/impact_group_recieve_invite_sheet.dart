import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/cubit/impact_groups_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class ImpactGroupReceiveInviteSheet extends StatelessWidget {
  const ImpactGroupReceiveInviteSheet({
    required this.invitedImpactGroup,
    super.key,
  });

  final ImpactGroup invitedImpactGroup;

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleMediumText(
            '${context.l10n.youHaveBeenInvitedToImpactGroup}${invitedImpactGroup.name}',
            textAlign: TextAlign.center,
          ),
          SvgPicture.asset('assets/images/family_superheroes.svg'),
          FunButton(
            text: context.l10n.acceptInviteKey,
            onTap: () {
              context
                  .read<ImpactGroupsCubit>()
                  .acceptGroupInvite(groupId: invitedImpactGroup.id);
              context.pop();
            },
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.inviteToImpactGroupAccepted,
              parameters: {
                'group_name': invitedImpactGroup.name,
              },
            ),
          ),
        ],
      ),
    );
  }
}
