import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ImpactGroupRecieveInviteSheet extends StatelessWidget {
  const ImpactGroupRecieveInviteSheet({
    required this.invitdImpactGroup,
    super.key,
  });

  final ImpactGroup invitdImpactGroup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${context.l10n.youHaveBeenInvitedToImpactGroup}${invitdImpactGroup.name}',
            textAlign: TextAlign.center,
            style: GoogleFonts.mulish(
              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          SvgPicture.asset('assets/images/family_superheroes.svg'),
          FunButton(
            text: context.l10n.acceptInviteKey,
            onTap: () {
              context
                  .read<ImpactGroupsCubit>()
                  .acceptGroupInvite(groupId: invitdImpactGroup.id);
              context.pop();
            },
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.inviteToImpactGroupAccepted,
              parameters: {
                'group_name': invitdImpactGroup.name,
              },
            ),
          ),
        ],
      ),
    );
  }
}
