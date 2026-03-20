import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/widgets/organisation_list_family_content.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:go_router/go_router.dart';

class ForYouListPage extends StatefulWidget {
  const ForYouListPage({
    required this.flowContext,
    super.key,
  });

  final ForYouFlowContext flowContext;

  @override
  State<ForYouListPage> createState() => _ForYouListPageState();
}

class _ForYouListPageState extends State<ForYouListPage> {
  CollectGroup _selectedOrganisation = const CollectGroup.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        leading: const GivtBackButtonFlat(),
        title: context.l10n.forYouSearchOrganizations,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OrganisationListFamilyContent(
                bloc: context.read<OrganisationBloc>(),
                onTapListItem: (collectGroup) {
                  setState(() {
                    _selectedOrganisation = collectGroup;
                  });
                },
                removedCollectGroupTypes: const [CollectGroupType.artists],
                showFavorites: true,
                autoFocusSearch: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: FunButton(
              text: context.l10n.selectReceiverButton,
              isDisabled: _selectedOrganisation == const CollectGroup.empty(),
              analyticsEvent: AnalyticsEventName.forYouOrganisationSelected
                  .toEvent(),
              onTap: () {
                if (_selectedOrganisation == const CollectGroup.empty()) {
                  return;
                }
                context.goNamed(
                  Pages.forYouGiving.name,
                  extra: widget.flowContext
                      .copyWith(
                        selectedOrganisation: _selectedOrganisation,
                      )
                      .toMap(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
