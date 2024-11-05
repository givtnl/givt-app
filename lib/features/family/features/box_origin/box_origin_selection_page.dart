import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/impact_groups/widgets/dialogs/box_origin_outcome_dialog.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/organisation_list_family_page.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class BoxOrignSelectionPage extends StatefulWidget {
  const BoxOrignSelectionPage({
    required this.setBoxOrign,
    super.key,
  });

  final Future<bool> Function(String id) setBoxOrign;

  @override
  State<BoxOrignSelectionPage> createState() => _BoxOrignSelectionPageState();
}

class _BoxOrignSelectionPageState extends State<BoxOrignSelectionPage> {
  final TextEditingController controller = TextEditingController();
  final bloc = getIt<OrganisationBloc>();
  int selectedIndex = -1;
  bool isLoading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrganisationListFamilyPage(
      onTap: (collectgroup) {
        final index = bloc.state.filteredOrganisations.indexOf(collectgroup);
        setState(() {
          selectedIndex = index;
        });
      },
      title: 'Where did you get it?',
      removedCollectGroupTypes: const [
        CollectGroupType.campaign,
        CollectGroupType.artists,
      ],
      fab: FunButton(
        isDisabled: selectedIndex == -1,
        isLoading: isLoading,
        text: 'Confirm',
        onTap: () => _onTapConfirm(context),
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.boxOrignConfirmClicked,
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
        eventName: AmplitudeEvents.boxOrignSelected,
        eventProperties: {
          'namespace': orgNamespace,
          'orgname': bloc.state.filteredOrganisations[selectedIndex].orgName,
        },
      ));

      final success = await widget.setBoxOrign(orgNamespace);

      if (success) {
        await showBoxOrignSuccessDialog(
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
        await showBoxOrignErrorDialog(
          context,
          onTap: () {
            Navigator.of(context).pop();
            _onTapConfirm(context);
          },
        );
      }
    }
  }

  Widget _buildListTile({
    required VoidCallback onTap,
    required String title,
    required CollectGroupType type,
    required bool isSelected,
  }) =>
      ListTile(
        key: UniqueKey(),
        selected: isSelected,
        onTap: () => onTap.call(),
        splashColor: FamilyAppTheme.highlight99,
        selectedTileColor:
            CollectGroupType.getColorComboByType(type).backgroundColor,
        leading: Icon(
          CollectGroupType.getIconByTypeUS(type),
          color: FamilyAppTheme.primary20,
        ),
        title: LabelMediumText(title),
      );
}
