// ignore_for_file: no_default_cases

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/tiles/campaign_tile.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/tiles/charity_tile.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/tiles/church_tile.dart';
import 'package:givt_app/features/family/shared/widgets/inputs/family_search_field.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/features/recurring_donations/create/widgets/create_recurring_donation_bottom_sheet.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/widgets/about_givt_bottom_sheet.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class OrganizationListFamilyPage extends StatefulWidget {
  const OrganizationListFamilyPage({
    super.key,
  });

  @override
  State<OrganizationListFamilyPage> createState() =>
      _OrganizationListFamilyPageState();
}

class _OrganizationListFamilyPageState
    extends State<OrganizationListFamilyPage> {
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
            'Give',
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
                            context.read<OrganisationBloc>().add(
                                  OrganisationSelectionChanged(
                                    state
                                        .filteredOrganisations[index].nameSpace,
                                  ),
                                );
                            _navigateToGivingScreen(state, context);
                          },
                        );
                      },
                    ),
                  )
                else
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _navigateToGivingScreen(OrganisationState state, BuildContext context) {
    final collectGroup = state.filteredOrganisations.firstWhere(
      (element) => element.nameSpace == state.selectedCollectGroup.nameSpace,
    );
    final userGUID = context.read<AuthCubit>().state.user.guid;
    //TODO KIDS-1262 navigate to Giving screen
  }

  Widget _buildListTile({
    required VoidCallback onTap,
    required String title,
    required CollectGroupType type,
  }) =>
      ListTile(
        key: UniqueKey(),
        onTap: onTap,
        splashColor: AppTheme.generosityChallangeCardBackground,
        selectedTileColor: CollectGroupType.getHighlightColor(type),
        trailing: FaIcon(
          FontAwesomeIcons.chevronRight,
          color: FamilyAppTheme.primary50.withOpacity(0.5),
        ),
        leading: Icon(
          CollectGroupType.getIconByType(type),
          color: AppTheme.givtBlue,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelSmall ??
              const TextStyle(
                color: AppTheme.givtBlue,
              ),
        ),
      );

  Widget _buildFilterType(OrganisationBloc bloc, AppLocalizations locals) =>
      SizedBox(
        height: 116,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            CharityTile(
              edgeInsets: const EdgeInsets.only(right: 8, left: 24),
              isSelected:
                  bloc.state.selectedType == CollectGroupType.charities.index,
              onClick: (context) => bloc.add(
                OrganisationTypeChanged(
                  CollectGroupType.charities.index,
                ),
              ),
            ),
            ChurchTile(
              edgeInsets: const EdgeInsets.only(right: 8),
              isSelected:
                  bloc.state.selectedType == CollectGroupType.church.index,
              onClick: (context) => bloc.add(
                OrganisationTypeChanged(
                  CollectGroupType.church.index,
                ),
              ),
            ),
            CampaignTile(
              edgeInsets: const EdgeInsets.only(right: 8),
              isSelected:
                  bloc.state.selectedType == CollectGroupType.campaign.index,
              onClick: (context) => bloc.add(
                OrganisationTypeChanged(
                  CollectGroupType.campaign.index,
                ),
              ),
            ),
          ],
        ),
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
                  navigate: (context, {isUSUser}) =>
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
                navigate: (context, {isUSUser}) =>
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
