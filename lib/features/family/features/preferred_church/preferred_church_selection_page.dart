import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/impact_groups/widgets/dialogs/preferred_church_outcome_dialog.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/inputs/family_search_field.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class PreferredChurchSelectionPage extends StatefulWidget {
  const PreferredChurchSelectionPage({
    required this.setPreferredChurch,
    super.key,
  });

  final Future<bool> Function(String id) setPreferredChurch;

  @override
  State<PreferredChurchSelectionPage> createState() =>
      _PreferredChurchSelectionPageState();
}

class _PreferredChurchSelectionPageState
    extends State<PreferredChurchSelectionPage> {
  final TextEditingController controller = TextEditingController();
  final bloc = getIt<OrganisationBloc>();
  int selectedIndex = -1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getIt<OrganisationBloc>().add(
      OrganisationFetch(
        Country.fromCode(context.read<AuthCubit>().state.user.country),
        type: CollectGroupType.church.index,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunScaffold(
      appBar: const FunTopAppBar(
        leading: GivtBackButtonFlat(),
        title: 'Choose your church',
      ),
      body: BlocConsumer<OrganisationBloc, OrganisationState>(
        bloc: bloc,
        listener: (context, state) {
          if (state.status == OrganisationStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(locals.somethingWentWrong),
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              FamilySearchField(
                autocorrect: false,
                controller: controller,
                onChanged: (value) =>
                    bloc.add(OrganisationFilterQueryChanged(value)),
              ),
              const SizedBox(height: 8),
              if (state.status == OrganisationStatus.filtered)
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (_, index) => const Divider(
                      height: 0.1,
                      color: FamilyAppTheme.neutralVariant95,
                    ),
                    shrinkWrap: true,
                    itemCount: state.filteredOrganisations.length,
                    itemBuilder: (context, index) {
                      return _buildListTile(
                        type: state.filteredOrganisations[index].type,
                        title: state.filteredOrganisations[index].orgName,
                        isSelected: selectedIndex == index,
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      );
                    },
                  ),
                )
              else
                const Center(
                  child: CustomCircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FunButton(
        isDisabled: selectedIndex == -1,
        isLoading: isLoading,
        text: 'Confirm',
        onTap: () => _onTapConfirm(context),
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.preferredChurchConfirmClicked,
        ),
      ),
    );
  }

  Future<void> _onTapConfirm(BuildContext context) async {
    if (selectedIndex != -1) {
      setState(() {
        isLoading = true;
      });
      final churchNamespace =
          bloc.state.filteredOrganisations[selectedIndex].nameSpace;
      unawaited(AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.preferredChurchSelected,
        eventProperties: {
          'namespace': churchNamespace,
          'orgname': bloc.state.filteredOrganisations[selectedIndex].orgName,
        },
      ));

      final success = await widget.setPreferredChurch(churchNamespace);

      if (success) {
        await showPreferredChurchSuccessDialog(
          context,
          bloc.state.filteredOrganisations[selectedIndex].orgName,
          onTap: () => Navigator.of(context)
            ..pop()
            ..pop(),
        );
      } else {
        await showPreferredChurchErrorDialog(
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
