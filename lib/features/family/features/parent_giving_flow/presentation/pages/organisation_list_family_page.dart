import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/inputs/family_search_field.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class OrganisationListFamilyPage extends StatefulWidget {
  const OrganisationListFamilyPage({
    this.onTapListItem,
    this.onTapFunButton,
    this.title = 'Give',
    this.removedCollectGroupTypes = const [],
    this.buttonText,
    this.analyticsEvent,
    super.key,
  });
  final void Function(CollectGroup)? onTapListItem;
  final void Function()? onTapFunButton;
  final String title;
  final List<CollectGroupType> removedCollectGroupTypes;
  final String? buttonText;
  final AnalyticsEvent? analyticsEvent;
  @override
  State<OrganisationListFamilyPage> createState() =>
      _OrganisationListFamilyPageState();
}

class _OrganisationListFamilyPageState
    extends State<OrganisationListFamilyPage> {
  final TextEditingController controller = TextEditingController();
  CollectGroup selectedCollectgroup = const CollectGroup.empty();
  @override
  void initState() {
    super.initState();
    getIt<OrganisationBloc>().add(
      OrganisationFetch(
        Country.fromCode(context.read<AuthCubit>().state.user.country),
        type: CollectGroupType.none.index,
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
      appBar: FunTopAppBar(
        leading: const GivtBackButtonFlat(),
        title: widget.title,
      ),
      body: BlocConsumer<OrganisationBloc, OrganisationState>(
        bloc: getIt<OrganisationBloc>(),
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
              const SizedBox(
                height: 16,
              ),
              FunOrganisationFilterTilesBar(
                onFilterChanged: (type) {
                  if (selectedCollectgroup.type != type) {
                    setState(() {
                      selectedCollectgroup = const CollectGroup.empty();
                    });
                  }
                },
                stratPadding: 0,
                removedTypes: [
                  ...widget.removedCollectGroupTypes.map((e) => e.name)
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: FamilySearchField(
                  autocorrect: false,
                  controller: controller,
                  onChanged: (value) => getIt<OrganisationBloc>()
                      .add(OrganisationFilterQueryChanged(value)),
                ),
              ),
              if (state.status == OrganisationStatus.filtered)
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (_, index) => const Divider(
                      height: 0.1,
                    ),
                    shrinkWrap: true,
                    itemCount: state.filteredOrganisations.length,
                    itemBuilder: (context, index) {
                      if (widget.removedCollectGroupTypes
                          .contains(state.filteredOrganisations[index].type)) {
                        return const SizedBox.shrink();
                      }
                      return _buildListTile(
                        type: state.filteredOrganisations[index].type,
                        title: state.filteredOrganisations[index].orgName,
                        isSelected: selectedCollectgroup ==
                            state.filteredOrganisations[index],
                        onTap: () {
                          widget.onTapListItem
                              ?.call(state.filteredOrganisations[index]);
                          setState(() {
                            selectedCollectgroup =
                                state.filteredOrganisations[index];
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
              const SizedBox(height: 16),
              if (widget.buttonText.isNotNullAndNotEmpty() &&
                  widget.analyticsEvent != null &&
                  widget.onTapFunButton != null)
                FunButton(
                  isDisabled:
                      selectedCollectgroup == const CollectGroup.empty(),
                  onTap: widget.onTapFunButton,
                  text: widget.buttonText!,
                  analyticsEvent: widget.analyticsEvent!,
                )
            ],
          );
        },
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
        onTap: () => onTap.call(),
        splashColor: FamilyAppTheme.highlight99,
        selected: isSelected,
        selectedTileColor:
            CollectGroupType.getColorComboByType(type).backgroundColor,
        leading: Icon(
          CollectGroupType.getIconByTypeUS(type),
          color: FamilyAppTheme.givtBlue,
        ),
        title: LabelMediumText(title),
      );
}
