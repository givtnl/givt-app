import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/model/impact_group.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/topup/screens/empty_wallet_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/widgets/goal_progress_bar/goal_progress_bar.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ImpactGroupDetailsBottomPanel extends StatelessWidget {
  const ImpactGroupDetailsBottomPanel({
    required this.impactGroup,
    super.key,
  });

  final ImpactGroup impactGroup;

  @override
  Widget build(BuildContext context) {
    final activeProfile = context.watch<ProfilesCubit>().state.activeProfile;
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 10),
      color: AppTheme.highlight99,
      child: SafeArea(
        minimum: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Goal${impactGroup.isFamilyGroup ? ': ${impactGroup.goal.orgName}' : ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.secondary30,
                  ),
            ),
            const SizedBox(height: 5),
            GoalProgressBar(
              goal: impactGroup.goal,
              showFlag: true,
              showCurrentLabel: true,
              showGoalLabel: true,
            ),
            const SizedBox(height: 15),
            GivtElevatedButton(
              onTap: () {
                if (activeProfile.wallet.balance < 1) {
                  EmptyWalletBottomSheet.show(context);
                  return;
                }
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.impactGroupDetailsGiveClicked,
                  eventProperties: {'name': impactGroup.name},
                );

                final generatedMediumId =
                    base64.encode(impactGroup.goal.mediumId.codeUnits);
                context
                    .read<OrganisationDetailsCubit>()
                    .getOrganisationDetails(generatedMediumId);

                context.pushNamed(
                  FamilyPages.chooseAmountSliderGoal.name,
                  extra: impactGroup,
                );
              },
              text: 'Give',
            ),
          ],
        ),
      ),
    );
  }
}
