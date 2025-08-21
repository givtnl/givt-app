import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/widgets/organisation_list_family_content.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/recurring_donations/create/cubit/step1_select_organization_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class SelectOrganisationListPage extends StatefulWidget {
  const SelectOrganisationListPage({
    required this.onCollectGroupSelected,
    super.key,
  });

  final void Function(CollectGroup) onCollectGroupSelected;

  @override
  State<SelectOrganisationListPage> createState() =>
      _SelectOrganisationListPageState();
}

class _SelectOrganisationListPageState
    extends State<SelectOrganisationListPage> {
  final OrganisationBloc bloc = getIt<OrganisationBloc>();
  final Step1SelectOrganizationCubit _cubit =
      getIt<Step1SelectOrganizationCubit>();
  CollectGroup selectedCollectgroup = const CollectGroup.empty();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<AuthCubit>().state.user;
    bloc
      ..add(
        OrganisationFetch(
          Country.fromCode(user.country),
          type: CollectGroupType.none.index,
        ),
      )
      ..add(const FavoritesRefresh());
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: FunTopAppBar.white(
        leading: const GivtBackButtonFlat(),
        title: context.l10n.recurringDonationsStep1Title,
      ),
      body: Column(
        children: [
          const FunStepper(
            currentStep: 0,
            stepCount: 4,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: OrganisationListFamilyContent(
              bloc: bloc,
              onTapListItem: (collectGroup) {
                setState(() {
                  selectedCollectgroup = collectGroup;
                });
              },
              removedCollectGroupTypes: const [],
              showFavorites: true,
            ),
          ),
          FunButton(
            isDisabled: selectedCollectgroup == const CollectGroup.empty(),
            onTap: () {
              _cubit.selectOrganization(selectedCollectgroup);
              widget.onCollectGroupSelected(selectedCollectgroup);
            },
            text: context.l10n.selectReceiverButton,
            analyticsEvent: AmplitudeEvents.debugButtonClicked.toEvent(),
          ),
        ],
      ),
    );
  }
}
