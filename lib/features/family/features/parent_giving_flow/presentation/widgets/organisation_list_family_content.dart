import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/widgets/organisation_allocation_filters.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/inputs/family_search_field.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/utils/utils.dart';

class OrganisationListFamilyContent extends StatefulWidget {
  const OrganisationListFamilyContent({
    required this.bloc,
    required this.onTapListItem,
    required this.removedCollectGroupTypes,
    this.showFavorites = false,
    super.key,
  });

  final OrganisationBloc bloc;
  final void Function(CollectGroup) onTapListItem;
  final List<CollectGroupType> removedCollectGroupTypes;
  final bool showFavorites;

  @override
  State<OrganisationListFamilyContent> createState() =>
      _OrganisationListFamilyContentState();
}

class _OrganisationListFamilyContentState
    extends State<OrganisationListFamilyContent> {
  final TextEditingController controller = TextEditingController();
  CollectGroup selectedCollectgroup = const CollectGroup.empty();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BlocConsumer<OrganisationBloc, OrganisationState>(
      bloc: widget.bloc,
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
              onFilterChanged: (type) {
                if (selectedCollectgroup.type != type) {
                  setState(() {
                    selectedCollectgroup = const CollectGroup.empty();
                  });
                }
              },
              stratPadding: 0,
              removedTypes: [
                ...widget.removedCollectGroupTypes.map((e) => e.name),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: OrganisationAllocationFilters(
                bloc: widget.bloc,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FamilySearchField(
                autocorrect: false,
                controller: controller,
                onChanged: (value) =>
                    widget.bloc.add(OrganisationFilterQueryChanged(value)),
              ),
            ),
            const SizedBox(height: 16),
            if (state.status == OrganisationStatus.filtered)
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) => const Divider(
                    height: 1,
                    color: AppTheme.neutralVariant95,
                  ),
                  shrinkWrap: true,
                  itemCount: state.filteredOrganisations.length,
                  itemBuilder: (context, index) {
                    final organisation = state.filteredOrganisations[index];
                    if (widget.removedCollectGroupTypes.contains(
                      organisation.type,
                    )) {
                      return const SizedBox.shrink();
                    }
                    final isFavorited = state.favoritedOrganisations.contains(
                      organisation.nameSpace,
                    );

                    return _buildListTile(
                      type: organisation.type,
                      title: organisation.orgName,
                      isSelected: selectedCollectgroup == organisation,
                      isFavorited: isFavorited,
                      onTap: () {
                        widget.onTapListItem(organisation);
                        setState(() {
                          selectedCollectgroup = organisation;
                        });
                      },
                      onFavoritePressed: () {
                        if (isFavorited) {
                          widget.bloc.add(
                            RemoveOrganisationFromFavorites(
                              organisation.nameSpace,
                            ),
                          );
                          AnalyticsHelper.logEvent(
                            eventName:
                                AmplitudeEvents.organisationFavoriteToggled,
                            eventProperties: {
                              'organisation_name': organisation.orgName,
                              'is_favorited': false,
                            },
                          );
                        } else {
                          widget.bloc.add(
                            AddOrganisationToFavorites(organisation.nameSpace),
                          );
                          AnalyticsHelper.logEvent(
                            eventName:
                                AmplitudeEvents.organisationFavoriteToggled,
                            eventProperties: {
                              'organisation_name': organisation.orgName,
                              'is_favorited': true,
                            },
                          );
                        }
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
    );
  }

  Widget _buildListTile({
    required VoidCallback onTap,
    required String title,
    required CollectGroupType type,
    required bool isSelected,
    required bool isFavorited,
    required VoidCallback onFavoritePressed,
  }) => ListTile(
        key: UniqueKey(),
        contentPadding: EdgeInsets.zero,
        onTap: () => onTap.call(),
        splashColor: FamilyAppTheme.highlight99,
        selected: isSelected,
        selectedTileColor: CollectGroupType.getColorComboByType(
          type,
        ).backgroundColor,
        leading: Icon(
          CollectGroupType.getIconByTypeUS(type),
          color: FamilyAppTheme.primary20,
        ),
        title: LabelMediumText(title, color: AppTheme.primary20),
        trailing: widget.showFavorites
            ? IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoritePressed,
              )
            : null,
      );
}
