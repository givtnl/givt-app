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
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    //PP: this is a temp, ugly solution
    final bottomPanelHeight = 231 + bottomPadding;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        //TODO: POEditor
        title:
            Text(impactGroup.isFamilyGroup ? 'Family Group' : impactGroup.name),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              child: Column(
                children: [
                  ImpactGroupDetailsHeader(impactGroup: impactGroup),
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
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(),
                ),
                SizedBox(
                  height: bottomPanelHeight,
                  child:
                      ImpactGroupDetailsBottomPanel(impactGroup: impactGroup),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
