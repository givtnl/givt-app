import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/models/collectgroup_details.dart';
import 'package:givt_app/features/family/features/impact_groups/model/impact_group.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';

class FamilyGoalWidget extends StatelessWidget {
  const FamilyGoalWidget(
    this.group,
    this.organisation, {
    super.key,
  });
  final CollectGroupDetails organisation;
  final ImpactGroup group;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (organisation.logoLink != null)
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.only(right: 12),
            child: Image.network(
              organisation.logoLink!,
              fit: BoxFit.contain,
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleMediumText(
                group.goal.orgName,
              ),
              BodyMediumText(
                group.type == ImpactGroupType.family
                    ? 'Family goal: \$${group.goal.goalAmount}'
                    : 'Goal: \$${group.goal.goalAmount}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
