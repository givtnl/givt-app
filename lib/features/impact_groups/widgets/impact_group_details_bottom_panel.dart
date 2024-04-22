import 'package:flutter/material.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/custom_green_elevated_button.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_bar.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class ImpactGroupDetailsBottomPanel extends StatelessWidget {
  const ImpactGroupDetailsBottomPanel({
    required this.impactGroup,
    super.key,
  });

  final ImpactGroup impactGroup;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 16),
      color: AppTheme.generosityChallangeCardBackground,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              //TODO: POEditor
              'Goal',
              // 'Goal${impactGroup.isFamilyGroup ? ': ${impactGroup.goal.orgName}' : ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.mulish(
                textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
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
            CustomGreenElevatedButton(
              title: context.l10n.give,
              onPressed: () {
                // final giveBloc = context.read<GiveBloc>();
                // showModalBottomSheet<void>(
                //   context: context,
                //   isScrollControlled: true,
                //   useSafeArea: true,
                //   builder: (_) => BlocProvider.value(
                //     value: giveBloc,
                //     child: EnterAmountBottomSheet(
                //       collectGroupNameSpace: impactGroup.goal.mediumId,
                //       goalId: impactGroup.goal.id,
                //     ),
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
