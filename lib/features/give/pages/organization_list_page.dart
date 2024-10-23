// ignore_for_file: no_default_cases

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/features/recurring_donations/create/widgets/create_recurring_donation_bottom_sheet.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/widgets/about_givt_bottom_sheet.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class OrganizationListPage extends StatefulWidget {
  const OrganizationListPage({
    super.key,
    this.isChooseCategory = false,
    this.isSelection = false,
  });

  final bool isChooseCategory;
  final bool isSelection;

  @override
  State<OrganizationListPage> createState() => _OrganizationListPageState();
}

class _OrganizationListPageState extends State<OrganizationListPage> {
  final focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final bloc = context.read<OrganisationBloc>();
    return BlocListener<GiveBloc, GiveState>(
      listener: (context, state) {
        if (state.status == GiveStatus.noInternetConnection) {
          context.goNamed(
            Pages.giveSucess.name,
            extra: {
              'isRecurringDonation': false,
              'orgName': state.organisation.organisationName,
            },
          );
        }
        if (state.status == GiveStatus.error) {
          showDialog<void>(
            context: context,
            builder: (_) => WarningDialog(
              title: context.l10n.errorOccurred,
              content: context.l10n.errorContactGivt,
              onConfirm: () => context.pop(),
            ),
          );
        }
        if (state.status ==
            GiveStatus.donatedToSameOrganisationInLessThan30Seconds) {
          showDialog<void>(
            context: context,
            builder: (_) => WarningDialog(
              title: context.l10n.notSoFast,
              content: context.l10n.giftBetween30Sec,
              onConfirm: () => context.pop(),
            ),
          );
        }
      },
      child: Scaffold(
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
            if (state.selectedType == CollectGroupType.none.index) {
              focusNode.requestFocus();
            }
            return Column(
              children: [
                _buildFilterType(bloc, locals),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CupertinoSearchTextField(
                    autocorrect: false,
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
                      itemCount: state.filteredOrganisations.length + 1,
                      itemBuilder: (context, index) {
                        if (index == state.filteredOrganisations.length) {
                          return ListTile(
                            key: UniqueKey(),
                            onTap: () => showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              builder: (_) => AboutGivtBottomSheet(
                                initialMessage: locals
                                    .reportMissingOrganisationPrefilledText,
                              ),
                            ),

                            /// To keep the symetry of the list
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
                          );
                        }
                        return _buildListTile(
                          type: state.filteredOrganisations[index].type,
                          title: state.filteredOrganisations[index].orgName,
                          isSelected: state.selectedCollectGroup.nameSpace ==
                              state.filteredOrganisations[index].nameSpace,
                          onTap: () {
                            if (widget.isChooseCategory) {
                              _buildActionSheet(
                                context,
                                state.filteredOrganisations[index],
                              );
                              return;
                            }
                            context.read<OrganisationBloc>().add(
                                  OrganisationSelectionChanged(
                                    state
                                        .filteredOrganisations[index].nameSpace,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  )
                else
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                _buildGivingButton(
                  title: widget.isSelection
                      ? locals.selectReceiverButton
                      : locals.give,
                  isLoading: context.watch<GiveBloc>().state.status ==
                      GiveStatus.loading,
                  onPressed:
                      state.selectedCollectGroup.type == CollectGroupType.none
                          ? null
                          : () {
                              final userGUID =
                                  context.read<AuthCubit>().state.user.guid;
                              if (widget.isSelection) {
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
                                      nameSpace:
                                          state.selectedCollectGroup.nameSpace,
                                      userGUID: userGUID,
                                    ),
                                  );
                            },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _buildTitle(int selectedType, AppLocalizations locals) {
    var title = locals.chooseWhoYouWantToGiveTo;

    if (widget.isSelection) {
      title = locals.selectRecipient;
    }

    switch (CollectGroupType.fromInt(selectedType)) {
      case CollectGroupType.church:
        title = locals.church;
      case CollectGroupType.charities:
        title = locals.charity;
      case CollectGroupType.campaign:
        title = locals.campaign;
      case CollectGroupType.artists:
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
      visible: !widget.isChooseCategory,
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
    required CollectGroupType type,
  }) =>
      ListTile(
        key: UniqueKey(),
        onTap: onTap,
        selected: isSelected,
        selectedTileColor: CollectGroupType.getHighlightColor(type),
        leading: Icon(
          CollectGroupType.getIconByType(type),
          color: AppTheme.givtBlue,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppTheme.givtBlue,
          ),
        ),
      );

  Widget _buildFilterType(OrganisationBloc bloc, AppLocalizations locals) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilterSuggestionCard(
            isFocused: bloc.state.selectedType == CollectGroupType.church.index,
            title: locals.church,
            icon: CollectGroupType.church.icon,
            activeIcon: CollectGroupType.church.activeIcon,
            color: CollectGroupType.church.color,
            onTap: () => bloc.add(
              OrganisationTypeChanged(
                CollectGroupType.church.index,
              ),
            ),
          ),
          FilterSuggestionCard(
            isFocused:
                bloc.state.selectedType == CollectGroupType.charities.index,
            title: locals.charity,
            icon: CollectGroupType.charities.icon,
            activeIcon: CollectGroupType.charities.activeIcon,
            color: CollectGroupType.charities.color,
            onTap: () => bloc.add(
              OrganisationTypeChanged(
                CollectGroupType.charities.index,
              ),
            ),
          ),
          FilterSuggestionCard(
            isFocused:
                bloc.state.selectedType == CollectGroupType.campaign.index,
            title: locals.campaign,
            icon: CollectGroupType.campaign.icon,
            activeIcon: CollectGroupType.campaign.activeIcon,
            color: CollectGroupType.campaign.color,
            onTap: () => bloc.add(
              OrganisationTypeChanged(
                CollectGroupType.campaign.index,
              ),
            ),
          ),
          FilterSuggestionCard(
            visible: Platform.isIOS,
            isFocused:
                bloc.state.selectedType == CollectGroupType.artists.index,
            title: locals.artist,
            icon: CollectGroupType.artists.icon,
            activeIcon: CollectGroupType.artists.activeIcon,
            color: CollectGroupType.artists.color,
            onTap: () => bloc.add(
              OrganisationTypeChanged(
                CollectGroupType.artists.index,
              ),
            ),
          ),
        ],
      );

  void _buildActionSheet(BuildContext context, CollectGroup recipient) {
    final locals = context.l10n;
    if (Platform.isIOS) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (_) => CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () => _showEnterAmountBottomSheet(
                context,
                recipient.nameSpace,
              ),
              child: Text(locals.discoverOrAmountActionSheetOnce),
            ),
            CupertinoActionSheetAction(
              onPressed: () async => AuthUtils.checkToken(
                context,
                checkAuthRequest: CheckAuthRequest(
                  navigate: (context, isUSUser) =>
                      _showCreateRecurringDonationBottomSheet(
                    context,
                    recipient: recipient,
                  ),
                ),
              ),
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
              _showEnterAmountBottomSheet(context, recipient.nameSpace);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.autorenew,
              color: AppTheme.givtBlue,
            ),
            title: Text(locals.discoverOrAmountActionSheetRecurring),
            onTap: () async => AuthUtils.checkToken(
              context,
              checkAuthRequest: CheckAuthRequest(
                navigate: (context, isUSUser) =>
                    _showCreateRecurringDonationBottomSheet(
                  context,
                  recipient: recipient,
                ),
              ),
            ),
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

  Future<void> _showCreateRecurringDonationBottomSheet(
    BuildContext context, {
    required CollectGroup recipient,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => CreateRecurringDonationBottomSheet(
        recipient: recipient,
      ),
    );
  }

  Future<void> _showEnterAmountBottomSheet(
    BuildContext context,
    String nameSpace,
  ) {
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
