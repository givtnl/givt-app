import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/features/give/bloc/give/give_bloc.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/widgets/impact_group_details_bottom_panel.dart';
import 'package:givt_app/features/impact_groups/widgets/impact_group_details_expandable_description.dart';
import 'package:givt_app/features/impact_groups/widgets/impact_group_details_header.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/dialogs/warning_dialog.dart';

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

    return BlocListener<GiveBloc, GiveState>(
      listener: (context, state) {
        if (state.status == GiveStatus.noInternetConnection) {
          context.goNamed(
            Pages.giveSucess.name,
            extra: {
              'isRecurringDonation': false,
              'orgName': state.organisation.organisationName,
            },
          );
        }
        if (state.status == GiveStatus.error) {
          showDialog<void>(
            context: context,
            builder: (_) => WarningDialog(
              title: context.l10n.errorOccurred,
              content: context.l10n.errorContactGivt,
              onConfirm: () => context.pop(),
            ),
          );
        }
        if (state.status ==
            GiveStatus.donatedToSameOrganisationInLessThan30Seconds) {
          showDialog<void>(
            context: context,
            builder: (_) => WarningDialog(
              title: context.l10n.notSoFast,
              content: context.l10n.giftBetween30Sec,
              onConfirm: () => context.pop(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: Text(
            impactGroup.isFamilyGroup
                ? context.l10n.familyGroup
                : impactGroup.name,
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  const Flexible(child: SizedBox.expand()),
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
      ),
    );
  }
}
