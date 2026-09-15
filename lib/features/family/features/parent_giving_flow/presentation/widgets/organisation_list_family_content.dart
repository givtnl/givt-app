import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/widgets/about_givt_bottom_sheet.dart';
import 'package:givt_app/utils/utils.dart';

class OrganisationListFamilyContent extends StatefulWidget {
  const OrganisationListFamilyContent({
    required this.bloc,
    required this.onTapListItem,
    required this.removedCollectGroupTypes,
    this.showFavorites = false,
    this.autoFocusSearch = false,
    this.allowSelection = true,
    this.reSortOnFavoriteToggle = true,
    this.showReportMissingOption = false,
    super.key,
  });

  final OrganisationBloc bloc;
  final void Function(CollectGroup) onTapListItem;
  final List<CollectGroupType> removedCollectGroupTypes;
  final bool showFavorites;
  final bool autoFocusSearch;
  final bool allowSelection;
  final bool reSortOnFavoriteToggle;
  final bool showReportMissingOption;

  @override
  State<OrganisationListFamilyContent> createState() =>
      _OrganisationListFamilyContentState();
}

class _OrganisationListFamilyContentState
    extends State<OrganisationListFamilyContent> {
  CollectGroup selectedCollectgroup = const CollectGroup.empty();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.autoFocusSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _searchFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
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
        final visibleOrganisations = state.filteredOrganisations
            .where(
              (organisation) =>
                  !widget.removedCollectGroupTypes.contains(organisation.type),
            )
            .toList();

        return Column(
          children: [
            FunOrganisationFilterTilesBar(
              bloc: widget.bloc,
              onFilterChanged: (type) {
                if (selectedCollectgroup.type != type) {
                  setState(() {
                    selectedCollectgroup = const CollectGroup.empty();
                  });
                }
              },
              removedTypes: [
                ...widget.removedCollectGroupTypes.map((e) => e.name),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: FunInput(
                hintText: locals.forYouSearchOrganizations,
                heroTag: 'discover_search_input_hero',
                prefixIcon: Icon(
                  Icons.search,
                  color: FunTheme.of(context).neutral40,
                ),
                analyticsEvent: AnalyticsEventName.forYouSearchTapped.toEvent(),
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  widget.bloc.add(OrganisationFilterQueryChanged(value));
                },
              ),
            ),
            if (state.status == OrganisationStatus.filtered)
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) => const Divider(
                    height: 1,
                    color: AppTheme.neutralVariant95,
                  ),
                  shrinkWrap: true,
                  itemCount:
                      visibleOrganisations.length +
                      (widget.showReportMissingOption ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (widget.showReportMissingOption &&
                        index == visibleOrganisations.length) {
                      return ListTile(
                        key: const ValueKey('reportMissingOrganisationTile'),
                        leading: const Icon(
                          Icons.add,
                          color: Colors.transparent,
                        ),
                        trailing: const Icon(
                          Icons.add,
                          color: AppTheme.givtBlue,
                        ),
                        title: Text(
                          locals.reportMissingOrganisationListItem,
                          style: const TextStyle(
                            color: AppTheme.givtBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          final metadata = widget.bloc.state
                              .buildSupportMetadata(locals);
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            builder: (_) => AboutGivtBottomSheet(
                              initialMessage:
                                  locals.reportMissingOrganisationPrefilledText,
                              metadata: metadata,
                            ),
                          );
                        },
                      );
                    }

                    final organisation = visibleOrganisations[index];
                    final isFavorited = state.favoritedOrganisations.contains(
                      organisation.nameSpace,
                    );

                    final listTile = _buildListTile(
                      type: organisation.type,
                      title: organisation.orgName,
                      isSelected:
                          widget.allowSelection &&
                          selectedCollectgroup == organisation,
                      isFavorited: isFavorited,
                      onTap: widget.allowSelection
                          ? () {
                              widget.onTapListItem(organisation);
                              setState(() {
                                selectedCollectgroup = organisation;
                              });
                            }
                          : () {},
                      onFavoritePressed: () {
                        if (isFavorited) {
                          widget.bloc.add(
                            RemoveOrganisationFromFavorites(
                              organisation.nameSpace,
                              reSort: widget.reSortOnFavoriteToggle,
                            ),
                          );
                          AnalyticsHelper.logEvent(
                            eventName:
                                AnalyticsEventName.organisationFavoriteToggled,
                            eventProperties: {
                              'organisation_name': organisation.orgName,
                              'is_favorited': false,
                            },
                          );
                        } else {
                          widget.bloc.add(
                            AddOrganisationToFavorites(
                              organisation.nameSpace,
                              reSort: widget.reSortOnFavoriteToggle,
                            ),
                          );
                          AnalyticsHelper.logEvent(
                            eventName:
                                AnalyticsEventName.organisationFavoriteToggled,
                            eventProperties: {
                              'organisation_name': organisation.orgName,
                              'is_favorited': true,
                            },
                          );
                        }
                      },
                    );

                    return listTile;
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
    splashColor: FunTheme.of(context).highlight99,
    selected: isSelected,
    selectedTileColor: CollectGroupType.getColorComboByType(
      type,
    ).backgroundColor,
    leading: FaIcon(
      CollectGroupType.getIconByTypeUS(type),
      color: FunTheme.of(context).primary20,
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
