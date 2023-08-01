// ignore_for_file: no_default_cases

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

class OrganizationListPage extends StatelessWidget {
  const OrganizationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final bloc = context.read<OrganisationBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          _buildTitle(
            context.watch<OrganisationBloc>().state.selectedType,
            locals,
          ),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
        ),
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
              _buildFilterType(bloc, locals),
              Padding(
                padding: const EdgeInsets.all(8),
                child: CupertinoSearchTextField(
                  onChanged: (value) => context
                      .read<OrganisationBloc>()
                      .add(OrganisationFilterQueryChanged(value)),
                  placeholder: locals.searchHere,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.close),
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
                    itemBuilder: (context, index) => _buildListTile(
                      type: state.filteredOrganisations[index].type,
                      title: state.filteredOrganisations[index].orgName,
                      isSelected: state.selectedCollectGroup.nameSpace ==
                          state.filteredOrganisations[index].nameSpace,
                      onTap: () => context.read<OrganisationBloc>().add(
                            OrganisationSelectionChanged(
                              state.filteredOrganisations[index].nameSpace,
                            ),
                          ),
                    ),
                  ),
                )
              else
                const Center(
                  child: CircularProgressIndicator(),
                ),
              _buildGivingButton(
                title: locals.give,
                isLoading: context.watch<GiveBloc>().state.status ==
                    GiveStatus.loading,
                onPressed:
                    state.selectedCollectGroup.type == CollecGroupType.none
                        ? null
                        : () {
                            final userGUID =
                                context.read<AuthCubit>().state.user.guid;

                            context.read<GiveBloc>().add(
                                  GiveOrganisationSelected(
                                    state.selectedCollectGroup.nameSpace,
                                    userGUID,
                                  ),
                                );
                          },
              ),
            ],
          );
        },
      ),
    );
  }

  String _buildTitle(int selectedType, AppLocalizations locals) {
    var title = locals.chooseWhoYouWantToGiveTo;
    switch (CollecGroupType.fromInt(selectedType)) {
      case CollecGroupType.church:
        title = locals.church;
        break;
      case CollecGroupType.charities:
        title = locals.charity;
        break;
      case CollecGroupType.campaign:
        title = locals.campaign;
        break;
      case CollecGroupType.artists:
        title = locals.artist;
        break;
      default:
        break;
    }

    return title;
  }

  Expanded _buildGivingButton({
    required String title,
    bool isLoading = false,
    VoidCallback? onPressed,
  }) {
    return Expanded(
      flex: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: !isLoading
            ? ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.grey,
                ),
                child: Text(title),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget _buildListTile({
    required VoidCallback onTap,
    required bool isSelected,
    required String title,
    required CollecGroupType type,
  }) =>
      ListTile(
        key: UniqueKey(),
        onTap: onTap,
        selected: isSelected,
        selectedTileColor: getHighlightColor(type),
        leading: Icon(
          getIconByType(type),
          color: AppTheme.givtBlue,
        ),
        title: Text(title),
      );

  Widget _buildFilterType(OrganisationBloc bloc, AppLocalizations locals) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilterSuggestionCard(
            isFocused: bloc.state.selectedType == CollecGroupType.church.index,
            title: locals.church,
            icon: CollecGroupType.church.icon,
            activeIcon: CollecGroupType.church.activeIcon,
            color: CollecGroupType.church.color,
            onTap: () => bloc.add(
              OrganisationTypeChanged(
                CollecGroupType.church.index,
              ),
            ),
          ),
          FilterSuggestionCard(
            isFocused:
                bloc.state.selectedType == CollecGroupType.charities.index,
            title: locals.charity,
            icon: CollecGroupType.charities.icon,
            activeIcon: CollecGroupType.charities.activeIcon,
            color: CollecGroupType.charities.color,
            onTap: () => bloc.add(
              OrganisationTypeChanged(
                CollecGroupType.charities.index,
              ),
            ),
          ),
          FilterSuggestionCard(
            isFocused:
                bloc.state.selectedType == CollecGroupType.campaign.index,
            title: locals.campaign,
            icon: CollecGroupType.campaign.icon,
            activeIcon: CollecGroupType.campaign.activeIcon,
            color: CollecGroupType.campaign.color,
            onTap: () => bloc.add(
              OrganisationTypeChanged(
                CollecGroupType.campaign.index,
              ),
            ),
          ),
          Visibility(
            visible: Platform.isIOS,
            child: FilterSuggestionCard(
              isFocused:
                  bloc.state.selectedType == CollecGroupType.artists.index,
              title: locals.artist,
              icon: CollecGroupType.artists.icon,
              activeIcon: CollecGroupType.artists.activeIcon,
              color: CollecGroupType.artists.color,
              onTap: () => bloc.add(
                OrganisationTypeChanged(
                  CollecGroupType.artists.index,
                ),
              ),
            ),
          ),
        ],
      );

  Color getHighlightColor(CollecGroupType type) {
    switch (type) {
      case CollecGroupType.church:
        return AppTheme.givtLightBlue;
      case CollecGroupType.charities:
        return AppTheme.givtYellow;
      case CollecGroupType.campaign:
        return AppTheme.givtOrange;
      case CollecGroupType.artists:
        return AppTheme.givtDarkGreen;
      default:
        return AppTheme.givtLightBlue;
    }
  }

  IconData getIconByType(CollecGroupType type) {
    switch (type) {
      case CollecGroupType.church:
        return FontAwesomeIcons.placeOfWorship;
      case CollecGroupType.charities:
        return FontAwesomeIcons.heart;
      case CollecGroupType.campaign:
        return FontAwesomeIcons.handHoldingHeart;
      case CollecGroupType.artists:
        return FontAwesomeIcons.guitar;
      default:
        return FontAwesomeIcons.church;
    }
  }
}
