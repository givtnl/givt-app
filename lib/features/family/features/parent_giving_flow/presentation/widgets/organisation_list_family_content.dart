import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/content/tutorial/fun_tooltip.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

class OrganisationListFamilyContent extends StatefulWidget {
  const OrganisationListFamilyContent({
    required this.bloc,
    required this.onTapListItem,
    required this.removedCollectGroupTypes,
    this.showFavorites = false,
    this.autoFocusSearch = false,
    this.allowSelection = true,
    this.showFavoriteTutorial = false,
    this.favoriteTutorialController,
    this.reSortOnFavoriteToggle = true,
    super.key,
  });

  final OrganisationBloc bloc;
  final void Function(CollectGroup) onTapListItem;
  final List<CollectGroupType> removedCollectGroupTypes;
  final bool showFavorites;
  final bool autoFocusSearch;
  final bool allowSelection;
  final bool showFavoriteTutorial;
  final TooltipController? favoriteTutorialController;
  final bool reSortOnFavoriteToggle;

  @override
  State<OrganisationListFamilyContent> createState() =>
      _OrganisationListFamilyContentState();
}

class _OrganisationListFamilyContentState
    extends State<OrganisationListFamilyContent> {
  CollectGroup selectedCollectgroup = const CollectGroup.empty();
  final FocusNode _searchFocusNode = FocusNode();
  bool _hasTriggeredFavoriteTutorial = false;

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

        final hasVisibleOrganisations = state.filteredOrganisations.any(
          (organisation) =>
              !widget.removedCollectGroupTypes.contains(organisation.type),
        );

        if (widget.showFavoriteTutorial &&
            !_hasTriggeredFavoriteTutorial &&
            state.status == OrganisationStatus.filtered &&
            state.favoritedOrganisations.isEmpty &&
            hasVisibleOrganisations &&
            widget.favoriteTutorialController != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _hasTriggeredFavoriteTutorial) {
              return;
            }

            widget.favoriteTutorialController!.start();
            _hasTriggeredFavoriteTutorial = true;
          });
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
                  itemCount: visibleOrganisations.length,
                  itemBuilder: (context, index) {
                    final organisation = visibleOrganisations[index];
                    final isFavorited = state.favoritedOrganisations.contains(
                      organisation.nameSpace,
                    );

                    final listTile = _buildListTile(
                      type: organisation.type,
                      title: organisation.orgName,
                      isSelected: widget.allowSelection &&
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

                    if (index == 0 &&
                        widget.showFavoriteTutorial &&
                        widget.favoriteTutorialController != null &&
                        state.favoritedOrganisations.isEmpty) {
                      return FunTooltip(
                        tooltipIndex: 0,
                        title: context.l10n.forYouFavoriteTutorialTitle,
                        description:
                            context.l10n.forYouFavoriteTutorialDescription,
                        labelBottomLeft: '',
                        buttonIcon: const Icon(Icons.check),
                        onButtonTap:
                            widget.favoriteTutorialController!.dismiss,
                        onHighlightedWidgetTap:
                            widget.favoriteTutorialController!.dismiss,
                        child: listTile,
                      );
                    }

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
    leading: Icon(
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
