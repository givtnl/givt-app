// ignore_for_file: no_default_cases

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/widgets/enter_amount_bottom_sheet.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/features/recurring_donations/create/widgets/create_recurring_donation_bottom_sheet.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class OrganizationListPage extends StatelessWidget {
  const OrganizationListPage({
    super.key,
    this.isChooseCategory = false,
    this.isSelection = false,
  });

  final bool isChooseCategory;
  final bool isSelection;

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
          final focusNode = FocusNode();
          if (state.selectedType == CollecGroupType.none.index) {
            focusNode.requestFocus();
          }
          return Column(
            children: [
              _buildFilterType(bloc, locals),
              Padding(
                padding: const EdgeInsets.all(8),
                child: CupertinoSearchTextField(
                  focusNode: focusNode,
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
                      onTap: () {
                        if (isChooseCategory) {
                          _buildActionSheet(
                            context,
                            state.filteredOrganisations[index].nameSpace,
                          );
                          return;
                        }
                        context.read<OrganisationBloc>().add(
                              OrganisationSelectionChanged(
                                state.filteredOrganisations[index].nameSpace,
                              ),
                            );
                      },
                    ),
                  ),
                )
              else
                const Center(
                  child: CircularProgressIndicator(),
                ),
              _buildGivingButton(
                title: isSelection ? locals.selectReceiverButton : locals.give,
                isLoading: context.watch<GiveBloc>().state.status ==
                    GiveStatus.loading,
                onPressed:
                    state.selectedCollectGroup.type == CollecGroupType.none
                        ? null
                        : () {
                            final userGUID =
                                context.read<AuthCubit>().state.user.guid;
                            if (isSelection) {
                              context.pop(
                                state.filteredOrganisations.firstWhere(
                                  (element) =>
                                      element.nameSpace ==
                                      state.selectedCollectGroup.nameSpace,
                                ),
                              );
                              return;
                            }
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
    if (isSelection) {
      title = locals.selectRecipient;
    }
    switch (CollecGroupType.fromInt(selectedType)) {
      case CollecGroupType.church:
        title = locals.church;
      case CollecGroupType.charities:
        title = locals.charity;
      case CollecGroupType.campaign:
        title = locals.campaign;
      case CollecGroupType.artists:
        title = locals.artist;
      default:
        break;
    }

    return title;
  }

  Widget _buildGivingButton({
    required String title,
    bool isLoading = false,
    VoidCallback? onPressed,
  }) {
    return Visibility(
      visible: !isChooseCategory,
      child: Expanded(
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
          CollecGroupType.getIconByType(type),
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
          FilterSuggestionCard(
            visible: Platform.isIOS,
            isFocused: bloc.state.selectedType == CollecGroupType.artists.index,
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

  void _buildActionSheet(BuildContext context, String nameSpace) {
    final locals = context.l10n;
    if (Platform.isIOS) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (_) => CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () => _showEnterAmountBottomSheet(context, nameSpace),
              child: Text(locals.discoverOrAmountActionSheetOnce),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _showCreateRecurringDonationBottomSheet(context),
              child: Text(locals.discoverOrAmountActionSheetRecurring),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => context.pop(context),
            child: Text(
              locals.cancel,
              style: const TextStyle(
                color: AppTheme.givtRed,
              ),
            ),
          ),
        ),
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.handHoldingHeart,
              color: AppTheme.givtBlue,
            ),
            title: Text(locals.discoverOrAmountActionSheetOnce),
            onTap: () {
              context.pop(context);
              _showEnterAmountBottomSheet(context, nameSpace);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.autorenew,
              color: AppTheme.givtBlue,
            ),
            title: Text(locals.discoverOrAmountActionSheetRecurring),
            onTap: () {
              context.pop(context);
              _showCreateRecurringDonationBottomSheet(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.cancel,
              color: AppTheme.givtRed,
            ),
            title: Text(
              locals.cancel,
              style: const TextStyle(
                color: AppTheme.givtRed,
              ),
            ),
            onTap: () => context.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateRecurringDonationBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const CreateRecurringDonationBottomSheet(),
    );
  }

  Future<void> _showEnterAmountBottomSheet(
      BuildContext context, String nameSpace) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: context.read<GiveBloc>(),
        child: EnterAmountBottomSheet(
          collectGroupNameSpace: nameSpace,
        ),
      ),
    );
  }
}
