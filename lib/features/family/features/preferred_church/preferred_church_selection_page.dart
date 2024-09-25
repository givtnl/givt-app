import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/inputs/family_search_field.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class PreferredChurchSelectionPage extends StatefulWidget {
  const PreferredChurchSelectionPage({
    required this.onTap,
    super.key,
  });
  final void Function(CollectGroup) onTap;
  @override
  State<PreferredChurchSelectionPage> createState() =>
      _PreferredChurchSelectionPageState();
}

class _PreferredChurchSelectionPageState
    extends State<PreferredChurchSelectionPage> {
  final TextEditingController controller = TextEditingController();
  int selectedIndex = -1;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final bloc = getIt<OrganisationBloc>();
    return FunScaffold(
      appBar: const FunTopAppBar(
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: FunButton(
          isDisabled: selectedIndex == -1,
          text: 'Confirm',
          onTap: () {
            if (selectedIndex != -1) {
              widget.onTap(
                bloc.state.filteredOrganisations[selectedIndex],
              );
            }
          },
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.preferredChurchSelected,
          ),
        ),
      ),
    );
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
