import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/widgets/dialogs/box_origin_outcome_dialog.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/cubit/medium_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/organisation_list_family_page.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
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
  final OrganisationBloc bloc = getIt<OrganisationBloc>();

  @override
  Widget build(BuildContext context) {
    final user = context.read<FamilyAuthCubit>().user!;
    return OrganisationListFamilyPage(
      countryCode: user.country,
      onTapListItem: (collectgroup) {
        getIt<MediumCubit>().setMediumId(collectgroup.nameSpace);
      },
      title: 'Select an organization',
      removedCollectGroupTypes: const [
        CollectGroupType.campaign,
        CollectGroupType.artists,
      ],
      buttonText: 'Confirm',
      onTapFunButton: () => _onTapConfirm(context),
      analyticsEvent: AmplitudeEvents.boxOriginConfirmClicked.toEvent(),
    );
  }

  Future<void> _onTapConfirm(BuildContext context) async {
    final selectedNamespace = getIt<MediumCubit>().state.mediumId;
    final selectedOrg = bloc.state.filteredOrganisations.firstWhere(
      (element) => element.nameSpace == selectedNamespace,
    );
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.boxOriginSelected,
        eventProperties: {
          'namespace': selectedNamespace,
          'orgname': selectedOrg.orgName,
        },
      ),
    );

    final success = await widget.setBoxOrigin(selectedNamespace);

    if (success) {
      context.goNamed(FamilyPages.profileSelection.name);
    } else {
      await showBoxOriginErrorDialog(
        context,
        onTapRetry: () {
          Navigator.of(context).pop();
          _onTapConfirm(context);
        },
        onTapSkip: () {
          Navigator.of(context).pop();
          context.goNamed(FamilyPages.profileSelection.name);
        },
      );
    }
  }
}
