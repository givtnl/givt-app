import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/give/widgets/filter_suggestion_card.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/collect_group.dart';

/// Organisation search list with an "Add [query]" row for custom names.
class ExternalDonationOrganisationSearchContent extends StatefulWidget {
  const ExternalDonationOrganisationSearchContent({
    required this.bloc,
    required this.onOrganisationSelected,
    required this.onCustomNameSelected,
    super.key,
  });

  final OrganisationBloc bloc;
  final void Function(CollectGroup organisation) onOrganisationSelected;
  final void Function(String name) onCustomNameSelected;

  @override
  State<ExternalDonationOrganisationSearchContent> createState() =>
      _ExternalDonationOrganisationSearchContentState();
}

class _ExternalDonationOrganisationSearchContentState
    extends State<ExternalDonationOrganisationSearchContent> {
  final FocusNode _searchFocusNode = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BlocBuilder<OrganisationBloc, OrganisationState>(
      bloc: widget.bloc,
      builder: (context, state) {
        final organisations = state.filteredOrganisations;
        final trimmedQuery = _query.trim();
        final showAddCustom = trimmedQuery.isNotEmpty;

        return Column(
          children: [
            SizedBox(
              height: 104,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FilterSuggestionCard(
                    isFocused:
                        state.selectedType == CollectGroupType.church.index,
                    title: locals.church,
                    iconData: CollectGroupType.church.iconData,
                    color: CollectGroupType.church.color,
                    onTap: () => widget.bloc.add(
                      OrganisationTypeChanged(CollectGroupType.church.index),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilterSuggestionCard(
                    isFocused:
                        state.selectedType == CollectGroupType.charities.index,
                    title: locals.charity,
                    iconData: CollectGroupType.charities.iconData,
                    color: CollectGroupType.charities.color,
                    onTap: () => widget.bloc.add(
                      OrganisationTypeChanged(CollectGroupType.charities.index),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilterSuggestionCard(
                    isFocused:
                        state.selectedType == CollectGroupType.campaign.index,
                    title: locals.campaign,
                    iconData: CollectGroupType.campaign.iconData,
                    color: CollectGroupType.campaign.color,
                    onTap: () => widget.bloc.add(
                      OrganisationTypeChanged(CollectGroupType.campaign.index),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilterSuggestionCard(
                    isFocused:
                        state.selectedType == CollectGroupType.artists.index,
                    title: locals.other,
                    iconData: CollectGroupType.artists.iconData,
                    color: CollectGroupType.artists.color,
                    onTap: () => widget.bloc.add(
                      OrganisationTypeChanged(CollectGroupType.artists.index),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FunInput(
              hintText: locals.externalDonationsCreateSearchHint,
              prefixIcon: Icon(
                Icons.search,
                color: FunTheme.of(context).neutral40,
              ),
              analyticsEvent:
                  AnalyticsEventName.externalDonationsCreateSearchTapped
                      .toEvent(),
              focusNode: _searchFocusNode,
              onChanged: (value) {
                setState(() => _query = value);
                widget.bloc.add(OrganisationFilterQueryChanged(value));
              },
            ),
            const SizedBox(height: 16),
            if (state.status == OrganisationStatus.filtered)
              Expanded(
                child: ListView.separated(
                  itemCount: organisations.length + (showAddCustom ? 1 : 0),
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (showAddCustom && index == organisations.length) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.add,
                          color: FunTheme.of(context).primary30,
                        ),
                        title: LabelMediumText(
                          locals.externalDonationsCreateAddCustomOrganisation(
                            trimmedQuery,
                          ),
                        ),
                        onTap: () {
                          widget.onCustomNameSelected(trimmedQuery);
                        },
                      );
                    }

                    final organisation = organisations[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: FaIcon(
                        CollectGroupType.getIconByTypeUS(organisation.type),
                        color: FunTheme.of(context).primary20,
                      ),
                      title: LabelMediumText(organisation.orgName),
                      onTap: () => widget.onOrganisationSelected(organisation),
                    );
                  },
                ),
              )
            else
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
