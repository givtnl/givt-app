import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/features/impact_groups/model/impact_group.dart';
import 'package:givt_app/features/family/features/impact_groups/widgets/impact_group_details_bottom_panel.dart';
import 'package:givt_app/features/family/features/impact_groups/widgets/impact_group_details_expandable_description.dart';
import 'package:givt_app/features/family/features/impact_groups/widgets/impact_group_details_header.dart';
import 'package:givt_app/features/family/shared/widgets/givt_back_button_flat.dart';

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
    final bottomPanelHeight = 222 + bottomPadding;

    return Scaffold(
      appBar: AppBar(
        leading: GivtBackButtonFlat(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.onPrimary,
        ),
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
