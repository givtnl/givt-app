import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/parent_amount_page.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/tiles/filter_tile.dart';
import 'package:givt_app/features/family/shared/widgets/inputs/family_search_field.dart';
import 'package:givt_app/features/family/shared/widgets/layout/top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class OrganisationListFamilyPage extends StatefulWidget {
  const OrganisationListFamilyPage({
    super.key,
  });

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
      appBar: const TopAppBar(
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
          return BlocConsumer<GiveBloc, GiveState>(
            listener: (context, state) {
              final userGUID = context.read<AuthCubit>().state.user.guid;
              if (state.status == GiveStatus.success) {
                context.read<GiveBloc>().add(
                      GiveOrganisationSelected(
                        nameSpace: bloc.state.selectedCollectGroup.nameSpace,
                        userGUID: userGUID,
                      ),
                    );
              }
              if (state.status == GiveStatus.readyToGive) {
                context.pushReplacementNamed(
                  FamilyPages.parentGive.name,
                  extra: context.read<GiveBloc>(),
                );
              }
              if (state.status == GiveStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(locals.somethingWentWrong),
                  ),
                );
              }
            },
            builder: (context, giveState) => giveState.status ==
                        GiveStatus.loading ||
                    giveState.status == GiveStatus.processed ||
                    giveState.status == GiveStatus.success
                ? const CustomCircularProgressIndicator()
                : Column(
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
                                title:
                                    state.filteredOrganisations[index].orgName,
                                onTap: () {
                                  context.read<OrganisationBloc>().add(
                                        OrganisationSelectionChanged(
                                          state.filteredOrganisations[index]
                                              .nameSpace,
                                        ),
                                      );

                                  _navigateToGivingScreen(
                                    state,
                                    context,
                                    state.filteredOrganisations[index].type,
                                  );
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
                  ),
          );
        },
      ),
    );
  }

  void _navigateToGivingScreen(
    OrganisationState state,
    BuildContext context,
    CollectGroupType type,
  ) async {
    final collectGroup = state.filteredOrganisations.firstWhere(
      (element) => element.nameSpace == state.selectedCollectGroup.nameSpace,
    );
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.parentGivingFlowOrganisationClicked,
        eventProperties: {
          'organisation': collectGroup.orgName,
        },
      ),
    );
    final dynamic result = await Navigator.push(
      context,
      ParentAmountPage(
        currency: r'$',
        organisationName: collectGroup.orgName,
        colorCombo: CollectGroupType.getColorComboByType(type),
        icon: CollectGroupType.getIconByType(type),
      ).toRoute(context),
    );
    if (result != null && result is int && context.mounted) {
      context.read<GiveBloc>().add(
            GiveAmountChanged(
              firstCollectionAmount: result.toDouble(),
              secondCollectionAmount: 0,
              thirdCollectionAmount: 0,
            ),
          );
    }
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
