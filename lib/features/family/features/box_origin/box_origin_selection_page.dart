import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/impact_groups/widgets/dialogs/box_origin_outcome_dialog.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/cubit/medium_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/organisation_list_family_page.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class BoxOriginSelectionPage extends StatefulWidget {
  const BoxOriginSelectionPage({
    required this.setBoxOrigin,
    super.key,
  });

  final Future<bool> Function(String id) setBoxOrigin;

  @override
  State<BoxOriginSelectionPage> createState() => _BoxOriginSelectionPageState();
}

class _BoxOriginSelectionPageState extends State<BoxOriginSelectionPage> {
  final bloc = getIt<OrganisationBloc>();

  @override
  Widget build(BuildContext context) {
    return OrganisationListFamilyPage(
      onTapListItem: (collectgroup) {
        getIt<MediumCubit>().setMediumId(collectgroup.nameSpace);
      },
      title: 'Where did you get it?',
      removedCollectGroupTypes: const [
        CollectGroupType.campaign,
        CollectGroupType.artists,
      ],
      buttonText: 'Confirm',
      onTapFunButton: () => _onTapConfirm(context),
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.boxOriginConfirmClicked,
      ),
    );
  }

  Future<void> _onTapConfirm(BuildContext context) async {
    final selectedNamespace = getIt<MediumCubit>().state.mediumId;
    final selectedOrg = bloc.state.filteredOrganisations
        .firstWhere((element) => element.nameSpace == selectedNamespace);
    unawaited(AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.boxOriginSelected,
      eventProperties: {
        'namespace': selectedNamespace,
        'orgname': selectedOrg.orgName,
      },
    ));

    final success = await widget.setBoxOrigin(selectedNamespace);

    if (success) {
      await showBoxOriginSuccessDialog(
        context,
        selectedOrg.orgName,
        onTap: () {
          Navigator.of(context)
            ..pop()
            ..pop();
          context.pushNamed(FamilyPages.reflectIntro.name);
        },
      );
    } else {
      await showBoxOriginErrorDialog(
        context,
        onTap: () {
          Navigator.of(context).pop();
          _onTapConfirm(context);
        },
      );
    }
  }
}
