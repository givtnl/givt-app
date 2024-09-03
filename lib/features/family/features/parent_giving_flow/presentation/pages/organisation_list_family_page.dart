import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/tiles/filter_tile.dart';
import 'package:givt_app/features/family/shared/widgets/inputs/family_search_field.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/collect_group.dart';

class OrganisationListFamilyPage extends StatefulWidget {
  const OrganisationListFamilyPage({
    required this.onTap,
    super.key,
  });
  final void Function(CollectGroup) onTap;
  @override
  State<OrganisationListFamilyPage> createState() =>
      _OrganisationListFamilyPageState();
}

class _OrganisationListFamilyPageState
    extends State<OrganisationListFamilyPage> {
  final TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final bloc = context.read<OrganisationBloc>();
    return Scaffold(
      appBar: const FunTopAppBar(
        leading: GivtBackButtonFlat(),
        title: 'Give',
      ),
      body: BlocConsumer<OrganisationBloc, OrganisationState>(
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
              _buildFilterType(bloc, locals),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: FamilySearchField(
                  autocorrect: false,
                  controller: controller,
                  onChanged: (value) => context
                      .read<OrganisationBloc>()
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
                      return _buildListTile(
                        type: state.filteredOrganisations[index].type,
                        title: state.filteredOrganisations[index].orgName,
                        onTap: () {
                          widget.onTap(state.filteredOrganisations[index]);
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
    );
  }

  Widget _buildListTile({
    required VoidCallback onTap,
    required String title,
    required CollectGroupType type,
  }) =>
      ListTile(
        key: UniqueKey(),
        onTap: () => onTap.call(),
        splashColor: FamilyAppTheme.highlight99,
        selectedTileColor: CollectGroupType.getHighlightColor(type),
        trailing: FaIcon(
          FontAwesomeIcons.chevronRight,
          color: FamilyAppTheme.primary50.withOpacity(0.5),
        ),
        leading: Icon(
          CollectGroupType.getIconByTypeUS(type),
          color: FamilyAppTheme.givtBlue,
        ),
        title: LabelMediumText(title),
      );

  Widget _buildFilterType(OrganisationBloc bloc, AppLocalizations locals) {
    final types = bloc.state.organisations.map((e) => e.type).toSet().toList();
    return SizedBox(
      height: 116,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(
            width: 24,
          ),
          ...types.map(
            (e) => FilterTile(
              type: e,
              edgeInsets: const EdgeInsets.only(right: 8),
              isSelected: bloc.state.selectedType == e.index,
              onClick: (context) => bloc.add(
                OrganisationTypeChanged(
                  e.index,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
