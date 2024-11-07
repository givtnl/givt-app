import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/impact_groups/widgets/dialogs/box_origin_outcome_dialog.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/organisation_list_family_page.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';

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
  int selectedIndex = -1;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return OrganisationListFamilyPage(
      onTap: (collectgroup) {},
      title: 'Where did you get it?',
      removedCollectGroupTypes: const [
        CollectGroupType.campaign,
        CollectGroupType.artists,
      ],
      button: FunButton(
        isDisabled: selectedIndex == -1,
        isLoading: isLoading,
        text: 'Confirm',
        onTap: () => _onTapConfirm(context),
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.boxOriginConfirmClicked,
        ),
      ),
    );
  }

  Future<void> _onTapConfirm(BuildContext context) async {
    if (selectedIndex != -1) {
      setState(() {
        isLoading = true;
      });
      final orgNamespace =
          bloc.state.filteredOrganisations[selectedIndex].nameSpace;
      unawaited(AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.boxOriginSelected,
        eventProperties: {
          'namespace': orgNamespace,
          'orgname': bloc.state.filteredOrganisations[selectedIndex].orgName,
        },
      ));

      final success = await widget.setBoxOrigin(orgNamespace);

      if (success) {
        await showBoxOriginSuccessDialog(
          context,
          bloc.state.filteredOrganisations[selectedIndex].orgName,
          onTap: () {
            Navigator.of(context)
              ..pop()
              ..pop()
              ..pushNamed(FamilyPages.reflectIntro.name);
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
}
