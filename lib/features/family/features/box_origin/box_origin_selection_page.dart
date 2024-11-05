import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/impact_groups/widgets/dialogs/box_origin_outcome_dialog.dart';
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
  void initState() {
    super.initState();
    getIt<OrganisationBloc>().add(
      OrganisationFetchForSelection(
        Country.fromCode(context.read<AuthCubit>().state.user.country),
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
        title: 'Where did you get it?',
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
              FunOrganisationFilterTilesBar(
                stratPadding: 0,
                removedTypes: [
                  CollectGroupType.campaign.name,
                  CollectGroupType.artists.name
                ],
              ),
              const SizedBox(height: 16),
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
