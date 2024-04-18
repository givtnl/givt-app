import 'package:flutter/material.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/widgets/impact_group_details_bottom_panel.dart';
import 'package:givt_app/features/impact_groups/widgets/impact_group_details_expandable_description.dart';
import 'package:givt_app/features/impact_groups/widgets/impact_group_details_header.dart';

class ImpactGroupDetailsPage extends StatelessWidget {
  const ImpactGroupDetailsPage({
    required this.impactGroup,
    super.key,
  });

  final ImpactGroup impactGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        //TODO: POEditor
        title:
            Text(impactGroup.isFamilyGroup ? 'Family Group' : impactGroup.name),
      ),
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 30),
              child: Column(
                children: [
                  ImpactGroupDetailsHeader(
                    image: impactGroup.isFamilyGroup
                        ? 'assets/images/family_avatar.svg'
                        : impactGroup.organiser.avatar,
                    title: impactGroup.isFamilyGroup
                        ? impactGroup.name
                        : impactGroup.organiser.fullName,
                    goal: impactGroup.goal.goalAmount,
                    members: impactGroup.amountOfMembers,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 20),
                    child: ImpactGroupDetailsExpandableDescription(
                      description: impactGroup.description,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          ImpactGroupDetailsBottomPanel(
            impactGroup: impactGroup,
          ),
        ],
      ),
    );
  }
}
